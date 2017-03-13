module Cog exposing (..)

import Animation
import Animation.Messenger
import CogFile
import EveryDict
import Array exposing (Array)
import Maybe.Extra exposing ((?))

import CogTypes

--MODEL
type alias Bits msg =
    EveryDict.EveryDict CogTypes.Name (TotalSequences msg)

type alias Bit msg =
    ( CogTypes.Name , (TotalSequences msg) )

type alias TotalSequences msg =
    { current : (Animation.Messenger.State msg)
    , sequences : EveryDict.EveryDict CogTypes.Trigger
                    ( (Animation.Messenger.State msg) -> (Animation.Messenger.State msg) )
    }

type alias Config msg =
    { name : CogTypes.Name
    , init : (Animation.Messenger.State msg)
    , sequences : List (Sequence msg)
    }

type alias Sequence msg =
    ( CogTypes.Trigger , List (Animation.Messenger.Step msg) )

--INIT

{--
    Does the heavy lifting in converting the CogFile config into usable
    Animation-compatible data structures.

    Conceptually, can be thought of as taking in the config created in the
    CogFile and applying all of the necessary boilerplate to 'wire up' the
    desired animations to work nicely with the Animation library as well as
    fitting nicely into the standard Elm Architecture. It doesn't do anything
    a normal user of the Animation library couldn't do manually - it just
    saves you the trouble of having to type and re-type (multipled by however
    many animations you create) all of the boilerplate code it takes to hook
    each animation up properly before you can see things moving around on the
    screen. Less typing, more moving pixels.

    Ultimately creates an AllDict with keys of CogFile.Name (the name of an
    element to be animated), with each such key pointing to a Record that
    encapsulates (1) the current animation state of the named element and (2)
    every possible animation for the named element as well as an associated
    "trigger" (CogFile.Trigger) used to set off that animation. (2) is actually
    implemented as a nested AllDict with keys of type CogFile.Trigger, each of
    which points to a partially applied function (the Animation.Interrupt
    function, with its first argument ( List Step msg) already satisfied) which
    is simply a potential animation waiting to be triggered. This underlying
    data structure need not ever be directly interacted with by a user of this
    module; see the api functions provided that alleviate any need to deal
    with the underlying AllDict implementation.

    AllDicts were used instead of Records due to the removal of Record
    extensibility: because the number of animations listed in the CogFile can
    be any arbitrary amount and it is not (to my knowledge) possible to create
    a Record with a to-be-defined-later totally-arbitrary number of fields,
    I had to settle for using AllDicts in this initial implementation. For
    performance reasons, I will be switching to Records from AllDicts in the
    future if at all possible; AllDicts are quite fast ( logN ) but Records
    are faster ( constant ).
--}
make : List (Config msg) -> (Bits msg)
make configList =
    let
        processedBits =
            List.map processConfig configList

        -- processConfig : (Config msg) -> (Bit msg)
        processConfig { name, init, sequences } =
            let
                totalSequences =
                    processSequences name init sequences

            in
                ( name, totalSequences )

        -- processSequences : CogTypes.Name -> (Animation.Messenger.State msg) -> List (Sequence msg) -> (TotalSequences msg)
        processSequences name init rawSequences =
            let
                processedSequences =
                    ( EveryDict.fromList rawSequences )
                        |> EveryDict.map processRawSequence

            in
                { current = init
                , sequences = processedSequences
                }

        processRawSequence trigger rawAnimation =
            processRawAnimation rawAnimation

        processRawAnimation rawAnimation =
             Animation.interrupt rawAnimation

        populatedBitsDict =
            populateBitsDict processedBits

        populateBitsDict processedBits =
            let
                populated =
                    EveryDict.fromList processedBits

            in
                populated

    in
        populatedBitsDict


--UPDATE

{--
Logic for running animations in response to (Animate animMsg) messages for
the underlying Elm-Stlye-Animation library.

Handles both normal animations and animations that send Msgs via Animation.
Messenger. This underlying distinction is made invisible to the user.

--}
animateBits bits animMsg =
    let
        {--
            This is done in two steps.

            Step One: The goal is to gather all potential Msgs from any
            Messenger animations that may be present. Given that these
            are optional, the result could be an empty list. We have
            a default of [ Cmd.none ] and append our Msgs (if any) to it.
            We then Cmd.batch this to make it a single Cmd to be passed back
            to the update function.
                For more info on Messenger animations, see the underlying
                Animation library's documentation on Animation.Messenger.

            Step Two: We update the current state of our animations via
            Animation.Messenger.update. (Note: Messenger.update returns
            a Tuple, with the first element being the updated animation
             -- which is what we are after here -- and the second element
             being the Msgs sent (if any) if this particular animation
             happens to be a Messenger animation. We took care of these Msgs
             (if any) inStep One, so we ignore them here.)

        --}

        --Step One begin--
        totalSequences =
            EveryDict.values bits

        currentStates =
            List.map .current ( totalSequences )

        updatedStates  =
            List.map updateState currentStates

        updateState state =
            Animation.Messenger.update animMsg state

        messageCmds =
            [ Cmd.none ]
                |> (++) ( List.map Tuple.second updatedStates )
                |> Cmd.batch

        --Step One end--

        --Step Two begin--
        animated =
            EveryDict.map updateCurrentAnims bits

        updateCurrentAnims name totalSequence =
            let
                updated =
                    totalSequence.current
                        |> Animation.Messenger.update animMsg
                        |> Tuple.first

            in
                { totalSequence
                    | current = updated
                }

        --Step Two end--

    in
        ( animated , messageCmds )



{--
Logic for triggering animations in response to (Cog Name Trigger) messages.
--}
triggerBit bits name trigger =
    let
        triggered =
            EveryDict.update name changeCurrent bits

        changeCurrent maybeTotalSequence =
            case maybeTotalSequence of
                Just totalSequence ->
                    Just    { totalSequence
                                | current = ( calculateTriggeredCurrent totalSequence )
                            }
                Nothing ->
                    Nothing

        calculateTriggeredCurrent totalSequence =
            let
                interrupt =
                    (EveryDict.get trigger totalSequence.sequences)

            in
                case interrupt of
                    Just interrupt ->
                        ( interrupt totalSequence.current )
                    Nothing ->
                        totalSequence.current

    in
        triggered

{--
    Logic for triggering entire chunks of animations at a time, all of which
    share some common specified Trigger.
--}

triggerChunk bits trigger =
    let
        -- bitsWithTrigger =
        --     EveryDict.filter hasTrigger bits
        --
        -- hasTrigger name totalSequence =
        --     let
        --         sequences =
        --             totalSequence.sequences
        --
        --     in
        --         EveryDict.member trigger sequences

        triggered =
            EveryDict.map triggerElement bits

        triggerElement name totalSequence =
            let
                sequences =
                    totalSequence.sequences

                maybeInterrupt =
                    EveryDict.get trigger sequences

                interrupted =
                    case maybeInterrupt of
                        Just interrupt ->
                            interrupt totalSequence.current

                        Nothing ->
                            totalSequence.current


            in
                { totalSequence
                    | current = interrupted
                }

    in
        triggered

--SUBSCRIPTIONS
getSubscriptions : (Bits msg) -> List (Animation.Messenger.State msg)
getSubscriptions bits =
    let
        currentStates =
            ( EveryDict.toList bits )
                |> List.map getCurrentAnimState

        getCurrentAnimState bit =
            ( Tuple.second bit )
                |> .current

    in
        currentStates



--VIEW

{--
Gets the current animation state for a particular element and gets it ready
to be rendered into a View. This function is the primary method for hooking
View elements up to Cog animations.
--}
plug name model =
    let
        maybeTotalSequence =
            ( EveryDict.get name model.bits )

    in
        case maybeTotalSequence of
            Just someTotalSequence ->
                Animation.render someTotalSequence.current
            Nothing ->
                []
