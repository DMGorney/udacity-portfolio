module CogGreetings exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import CogFormat exposing ( named, initialize, initializeWith, immediate )
import SharedTypes exposing (..)

configShard vars =
    [ named Greeting
            |> initializeWith
                ( 1500 , Ease.inOutCubic )
                [ opacity 0
                , display none
                ]
            |> immediate
                Appear
                    [ wait ( 3000 * millisecond )
                    , set
                        [ display block ]
                    , to
                        [ opacity 1
                        ]
                    ]

    , named Introduction1
            |> initializeWith
                ( 1500 , Ease.inOutCubic )
                [ opacity 0
                , display none
                ]
            |> immediate
                Appear
                    [ wait ( 6000 * millisecond )
                    , set
                        [ display block ]
                    , to
                         [ opacity 1 ]
                    ]

    , named Introduction2
            |> initializeWith
                ( 1500 , Ease.inOutCubic )
                [ opacity 0
                , display none
                ]
            |> immediate
                Appear
                    [ wait ( 6100 * millisecond )
                    , set
                        [ display block ]
                    , to
                         [ opacity 1 ]
                    ]
    ]
