module CogGreetings exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import SharedTypes exposing (..)

configShard vars =
    [{ name = Greeting
     , init =
         styleWith
             ( easing
                 { duration = ( 1500 * millisecond)
                 , ease = Ease.inOutCubic }
             )
             [ opacity 0
             ]
     , sequences =
         [( Appear,
             [ wait ( 3000 * millisecond )
             , to
                 [ opacity 1
                 ]
             ]
          )
         ]
     }

    ,   { name = Introduction1
     , init =
         styleWith
             ( easing
                 { duration = ( 1500 * millisecond)
                 , ease = Ease.inOutCubic }
             )
             [ opacity 0
             ]
     , sequences =
         [( Appear,
             [ wait ( 6000 * millisecond )
             , to
                 [ opacity 1
                 ]
             ]
          )
         ]
     }

    ,   { name = Introduction2
     , init =
         styleWith
             ( easing
                 { duration = ( 1500 * millisecond )
                 , ease = Ease.inOutCubic
                 }
             )
             [ opacity 0
             ]
     , sequences =
         [( Appear,
             [ wait ( 6100 * millisecond )
             , to
                 [ opacity 1
                 ]
             ]
          )
         ]
     }
    ]
