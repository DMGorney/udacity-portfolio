module CogGears exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import CogFormat exposing ( named, initialize, initializeWith, immediate )
import SharedTypes exposing (..)

configShard vars =
    [ named LogoCog
            |> initialize
                [ rotate ( turn 0 ) ]
            |> immediate
                StartGears
                    ( let
                        delayedTicks =
                            makeDelayedTicks ticksTo1

                        makeDelayedTicks ticks =
                            List.concatMap makeDelayed ticks

                        makeDelayed tick =
                            [ logoCogWait , logoCogTick tick ]

                        logoCogWait =
                            wait ( vars.logoCogDelay * millisecond )

                        logoCogTick nextAngle =
                            toWith
                                ( easing
                                    { duration = ( 1800 * millisecond )
                                    , ease = Ease.outBounce
                                    }
                                )
                                [ rotate ( turn nextAngle ) ]

                        -- ticksTo1 : List Float
                        ticksTo1 =
                            let
                                oneTick =
                                    1 / 8

                                finalAngle =
                                    1

                                ticksSoFar =
                                    []

                            in
                                List.sort ( getTicks oneTick finalAngle oneTick ticksSoFar )

                        -- getTicks : Float -> Float -> Float -> List Float -> List Float
                        getTicks oneTick finalAngle currentTick ticksSoFar =
                            if currentTick <= finalAngle then
                                getTicks oneTick finalAngle ( calcNextTick oneTick currentTick ) ( currentTick :: ticksSoFar )
                            else
                                ticksSoFar


                        calcNextTick : Float -> Float -> Float
                        calcNextTick sizeOfTick currentTick =
                            currentTick + sizeOfTick

                    in
                        ( List.append
                                delayedTicks
                                [ set   [ rotate ( turn 0 ) ]
                                , send ( Cog LogoCog StartGears )
                                ]
                        )
                    )

    , named MiniCog1
            |> initialize
                [ rotate ( turn 0 ) ]
            |> immediate
                StartGears
                    [ loop
                        [ toWith
                            ( speed { perSecond = 1 * vars.gearSpeedFactor })
                            [ rotate ( turn 1 ) ]
                        , set
                            [ rotate ( turn 0 ) ]
                        ]
                    ]

    , named MiniCog2
            |> initialize
                [ rotate ( turn 0 ) ]
            |> immediate
                StartGears
                    [ loop
                        [ toWith
                            ( speed { perSecond = 1 * vars.gearSpeedFactor })
                            [ rotate ( turn 1 ) ]
                        , set
                            [ rotate ( turn 0 ) ]
                        ]
                    ]

    , named MiniCog3
            |> initialize
                [ rotate ( turn 0 ) ]
            |> immediate
                StartGears
                    [ loop
                        [ toWith
                            ( speed { perSecond = 1 * vars.gearSpeedFactor })
                            [ rotate ( turn 1 ) ]
                        , set
                            [ rotate ( turn 0 ) ]
                        ]
                    ]
    ]
