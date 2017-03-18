module CogFile exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import CogFormat exposing ( named, initialize, initializeWith, animations,
                            immediate )

import CogTypes exposing (..)
import CogGears
import CogGreetings
import CogMenu

config vars cogMsg =
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
                         [ opacity 1
                         ]
                    ]
            |> immediate
                MenuClose
                    [ to
                        [ opacity 0
                        ]
                    , set
                        [ display none ]
                    ]
    ]
        ++ (CogGears.configShard vars cogMsg)
        ++ (CogGreetings.configShard vars cogMsg)
        ++ (CogMenu.configShard vars cogMsg)



-- config vars cogMsg =
--     [ { name = BGFader
--      , init =
--          styleWith
--              ( easing
--                  { duration = ( 350 * millisecond)
--                  , ease = Ease.inOutCirc }
--              )
--              [ opacity 0
--              , display none
--              ]
--      , sequences =
--          [( MenuOpen,
--             [ set
--                 [ display block ]
--             , to
--                  [ opacity 1
--                  ]
--             ]
--           )
--          ,( MenuClose,
--             [ to
--                 [ opacity 0
--                 ]
--             , set
--                 [ display none ]
--             ]
--           )
--          ]
--      }
--     ]
--         ++ (CogGears.configShard vars cogMsg)
--         ++ (CogGreetings.configShard vars cogMsg)
--         ++ (CogMenu.configShard vars cogMsg)



{--
    CogFile Variables section.
    Any animation-related state that animations depend on to function properly.
--}
--MODEL

type alias Vars =
    { menuState : MenuState
    , gearSpeedFactor : Float
    , logoCogDelay : Float
    , menuItemEasing : Ease.Easing
    , menuItemRightOffset : Animation.Length
    }

initVars =
    { menuState =
        Closed
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

openMenu vars =
    { vars
        | menuState = Open
    }

closeMenu vars =
    { vars
        | menuState = Closed
    }
