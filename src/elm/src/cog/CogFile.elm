module CogFile exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Color
import Update.Extra.Infix exposing ((:>))

import CogFormat exposing ( named, initialize, initializeWith, immediate )

import SharedTypes exposing (..)
import CogGears
import CogGreetings
import CogMenu

--MODEL

{--
Animation Configs
--}

config initVars =
    [ named BGFader
            |> initializeWith
                ( 350 , Ease.inOutCirc )
                [ opacity 0
                , display none
                ]
            |> immediate
                MenuOpen
                    [ set
                        [ display block ]
                    , to
                         [ opacity 1 ]
                    ]
            |> immediate
                MenuClose
                    [ to
                        [ opacity 0 ]
                    , set
                        [ display none ]
                    ]
    ]
        ++ (CogGears.configShard initVars)
        ++ (CogGreetings.configShard initVars)
        ++ (CogMenu.configShard initVars)

{--
    CogFile Variables section.
    Any animation-related state that animations depend on to function properly.
--}

type alias Vars =
    { menuState : Collapsable
    , gearSpeedFactor : Float
    , logoCogDelay : Float
    , menuItemEasing : Ease.Easing
    , menuItemRightOffset : Animation.Length
    }

initVars : Vars
initVars =
    { menuState =
        Collapsed
    , gearSpeedFactor =
        0.8
    , logoCogDelay =
        3750
    , menuItemEasing =
        Ease.outCubic
    , menuItemRightOffset =
        percent 70
    }

--UPDATE

{--
    CogFile Events section.
    Any application events that trigger chunks or sequences of animations.
--}


handleEvent event update model =
    let
        bits =
            model.bits

        cogVars =
            model.cogVars

    in
        case event of
            KickStart ->
                (model, Cmd.none)
                    :> update ( CogChunk Appear )
                    :> update ( CogChunk StartGears )

            ToggleMenu ->
                if cogVars.menuState == Collapsed then
                    let
                        opened =
                            { cogVars
                                | menuState = Open
                            }

                    in
                        ({ model
                            | cogVars = opened
                        }, Cmd.none )
                            :> update (CogChunk MenuOpen)
                else
                    let
                        closed =
                            { cogVars
                                | menuState = Collapsed
                            }

                    in
                        ({ model
                            | cogVars = closed
                        }, Cmd.none )
                            :> update (CogChunk MenuClose)

            MenuHover ->
                if cogVars.menuState == Collapsed then
                    (model, Cmd.none)
                        :> update (CogChunk MenuHovered)
                else
                    (model, Cmd.none)

            MenuUnhover ->
                if cogVars.menuState == Collapsed then
                    (model, Cmd.none)
                        :> update (CogChunk MenuUnhovered)
                else
                    (model, Cmd.none)


-- {--
--     CogFile Sequences section.
-- --}
--
-- handleSequence sequence update model =
--     let
--         bits =
--             model.bits
--
--         cogVars =
--             model.cogVars
--
--     in
--         case sequence of
--             GreetingsAppear ->
