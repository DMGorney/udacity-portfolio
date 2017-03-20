{-- Core library and Package Library dependencies --}
import Html exposing (..)
import Html.Attributes exposing (..)
import Animation exposing (turn, px)
import Task

import Cog

{-- Local Source Modules --}
--Types
import SharedTypes exposing (..)
import CogFile

-- Views
import Logo
import Intro
import Menu

{--

MAIN

--}

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

{--

MODEL

--}

type alias Model =
    { bits : (Cog.Bits Msg)
    , cogVars : CogFile.Vars
    }

init : ( Model, Cmd Msg)
init =
    let
        initialized = Cog.make (CogFile.config CogFile.initVars)

    in
        (   { bits = initialized
            , cogVars = CogFile.initVars
            } , Task.perform   ( \_ -> (CogEvent KickStart) )
                             ( Task.succeed NoOp )
        )

{--

UPDATE

--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)

        Animate animMsg ->
            let
                ( animated, cmds ) =
                    Cog.animateBits model.bits animMsg

            in
                ({ model
                    | bits = animated
                }, cmds )

        Cog name trigger ->
            let
                triggered =
                    Cog.triggerBit model.bits name trigger

            in
                ({ model
                    | bits = triggered
                }, Cmd.none)

        CogChunk trigger ->
            let
                chunkTriggered =
                    Cog.triggerChunk model.bits trigger

            in
                ({ model
                    | bits = chunkTriggered
                }, Cmd.none)

        CogEvent event ->
            CogFile.handleEvent event update model

        -- CogSequence sequence ->
        --     CogFile.handleSequence sequence update model

{--

SUBSCRIPTIONS

--}

subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate ( Cog.getSubscriptions model.bits )

{--

VIEW

--}

view : Model -> Html Msg
view model =
    div [ id "app-container" ]
        [ div   ( Cog.plug BGFader model
                    ++ [ id "bg-fader" ]
                )
                []
        , landingSection model
        , bioSection model
        ]

landingSection : Model -> Html Msg
landingSection model =
    section [ id "landing" ]
        [ div [ class "columns is-mobile" ]
            [ Logo.logo model
            , Intro.intro model
            , Menu.menu model
            ]
        ]

bioSection : Model -> Html msg
bioSection model =
    section [ id "bio" ]
        [ div [ class "columns" ]
            [
            ]
        ]
