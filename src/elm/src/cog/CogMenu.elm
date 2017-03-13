module CogMenu exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import CogTypes exposing (..)

configShard vars cogMsg =
    [   { name = MenuIcon
        , init =
            styleWith
                ( easing
                    { duration = ( 250 * millisecond )
                    , ease = Ease.linear }
                )
                [ backgroundColor ( Color.rgb 0 17 17 )
                ]
        , sequences =
            [( MenuHovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ backgroundColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ,( MenuUnhovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ backgroundColor ( Color.rgb 0 17 17 )
                    ]
                ]
             )
            ,( MenuOpen,
                [ to
                    [ backgroundColor ( Color.rgb 221 221 221 )
                    ]
                ]
             )
            ,( MenuClose,
                [ to
                    [ backgroundColor ( Color.rgb 0 17 17 )
                    ]
                ]
             )
            ]
        }

    ,   { name = MenuLine1
        , init =
            styleWith
                ( easing
                    { duration = ( 300 * millisecond )
                    , ease = Ease.inOutElastic }
                    )
                [ rotate ( turn 0 )
                , top ( percent 0 )
                , borderColor ( Color.rgb 238 238 238 )
                ]
        , sequences =
            [( MenuOpen,
                [ to
                    [ rotate ( turn 0.125 )
                    , top ( percent 33 )
                    , borderColor ( Color.rgb 65 85 123 )
                    ]
                ]

             )
            ,( MenuClose,
                [ to
                    [ rotate ( turn 0 )
                    , top ( percent 0 )
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ,( MenuHovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ rotate ( turn 0 )
                    , top ( percent 0 )
                    , borderColor ( Color.rgb 0 17 17 )
                    ]
                ]
             )
            ,( MenuUnhovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ rotate ( turn 0 )
                    , top ( percent 0 )
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ]
        }

    ,   { name = MenuLine2
        , init =
            styleWith
                (easing
                    { duration = ( 300 * millisecond )
                    , ease = Ease.inOutElastic }
                    )
                [ rotate ( turn 0 )
                , borderColor ( Color.rgb 238 238 238 )
                ]
        , sequences =
            [( MenuOpen,
                [ to
                    [ rotate ( turn ( -0.125 ) )
                    , borderColor ( Color.rgb 65 85 123 )
                    ]
                ]
             )
            ,( MenuClose,
                [ to
                    [ rotate ( turn 0 )
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ,( MenuHovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ rotate ( turn 0 )
                    , borderColor ( Color.rgb 0 17 17 )
                    ]
                ]
             )
            ,( MenuUnhovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ rotate ( turn 0 )
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ]
        }

    ,   { name = MenuLine3
        , init =
            styleWith
                ( easing
                    { duration = ( 300 * millisecond )
                    , ease = Ease.inOutElastic }
                    )
                [ opacity 1
                , borderColor ( Color.rgb 238 238 238 )
                ]
        , sequences =
            [( MenuOpen,
                [ to
                    [ opacity 0
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ,( MenuClose,
                [ to
                    [ opacity 1
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ,( MenuHovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ opacity 1
                    , borderColor ( Color.rgb 0 17 17 )
                    ]
                ]
             )
            ,( MenuUnhovered,
                [ toWith
                    ( easing
                        { duration = ( 100 * millisecond )
                        , ease = Ease.linear }
                    )
                    [ opacity 1
                    , borderColor ( Color.rgb 238 238 238 )
                    ]
                ]
             )
            ]
        }

    ,   { name = MenuBio
        , init =
            styleWith
                ( easing
                    { duration = ( 200 * millisecond )
                    , ease = vars.menuItemEasing }
                )
                menuItemInitialState
        , sequences =
            [( MenuOpen,
                openMenuItem ( px ( -60 ) ) vars
             )
            ,( MenuClose,
                closeMenuItem
             )
            ]
        }

    ,   { name = MenuSkills
        , init =
            styleWith
                ( easing
                    { duration = ( 250 * millisecond )
                    , ease = vars.menuItemEasing }
                    )
                menuItemInitialState
        , sequences =
            [( MenuOpen,
                openMenuItem ( px 50 ) vars
             )
            ,( MenuClose,
                closeMenuItem
             )
            ]
        }

    ,   { name = MenuProjects
        , init =
            styleWith
                ( easing
                    { duration = ( 300 * millisecond )
                    , ease = vars.menuItemEasing }
                    )
                menuItemInitialState
        , sequences =
            [( MenuOpen,
                openMenuItem ( px 160 ) vars
             )
            ,( MenuClose,
                closeMenuItem
             )
            ]
        }

    ,   { name = MenuContact
        , init =
            styleWith
                ( easing
                    { duration = ( 350 * millisecond )
                    , ease = vars.menuItemEasing }
                    )
                menuItemInitialState
        , sequences =
            [( MenuOpen,
                openMenuItem ( px 270 ) vars
             )
            ,( MenuClose,
                closeMenuItem
             )
            ]
        }
    ]

openMenuItem topPX vars =
    [ set
        [ display flex ]
    , to
        [ opacity 1
        , top topPX
        , right ( vars.menuItemRightOffset )
        ]
    ]

closeMenuItem =
    [ to
        menuItemClosedState
    , set
        [ display none]
    ]

menuItemClosedState =
    [ opacity 0
    , top ( px ( -60 ) )
    , right ( px 0 )
    ]

menuItemInitialState =
    [ opacity 0
    , display none
    , top ( px ( -60 ) )
    , right ( px 0 )
    ]
