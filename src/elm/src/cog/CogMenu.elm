module CogMenu exposing (..)

import Animation exposing (..)
import Animation.Messenger exposing (send)
import Ease
import Time exposing (millisecond)
import Color

import CogFormat exposing ( named, initialize, initializeWith, immediate )
import SharedTypes exposing (..)

configShard vars =
    [ named MenuIcon
            |> initializeWith
                ( 250 , Ease.linear )
                [ backgroundColor ( Color.rgb 0 17 17 )
                ]
            |> immediate
                MenuHovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ backgroundColor ( Color.rgb 238 238 238 )
                        ]
                    ]
            |> immediate
                MenuUnhovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ backgroundColor ( Color.rgb 0 17 17 )
                        ]
                    ]
            |> immediate
                MenuOpen
                    [ to
                        [ backgroundColor ( Color.rgb 221 221 221 )
                        ]
                    ]
            |> immediate
                MenuClose
                [ to
                    [ backgroundColor ( Color.rgb 0 17 17 )
                    ]
                ]

    , named MenuLine1
            |> initializeWith
                ( 300 , Ease.inOutElastic )
                [ rotate ( turn 0 )
                , top ( percent 0 )
                , borderColor ( Color.rgb 238 238 238 )
                ]
            |> immediate
                MenuOpen
                    [ set
                        [ borderColor ( Color.rgb 65 85 123 )
                        ]
                    , wait ( 250 * millisecond )
                    , toWith
                        ( easing
                            { duration = ( 600 * millisecond )
                            , ease = Ease.outElastic }
                        )
                        [ rotate ( turn 0.125 )
                        , top ( percent 33 )
                        ]
                    ]
            |> immediate
                MenuClose
                    [ to
                        [ rotate ( turn 0 )
                        , top ( percent 0 )
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]
            |> immediate
                MenuHovered
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
            |> immediate
                MenuUnhovered
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

    , named MenuLine2
            |> initializeWith
                ( 300 , Ease.inOutElastic )
                [ rotate ( turn 0 )
                , borderColor ( Color.rgb 238 238 238 )
                ]
            |> immediate
                MenuOpen
                    [ set
                        [ borderColor ( Color.rgb 65 85 123 )
                        ]
                    , wait ( 250 * millisecond )
                    , toWith
                        ( easing
                            { duration = ( 600 * millisecond )
                            , ease = Ease.outElastic }
                        )
                        [ rotate ( turn ( -0.125 ) )
                        ]
                    ]
            |> immediate
                MenuClose
                    [ to
                        [ rotate ( turn 0 )
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]
            |> immediate
                MenuHovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ rotate ( turn 0 )
                        , borderColor ( Color.rgb 0 17 17 )
                        ]
                    ]
            |> immediate
                MenuUnhovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ rotate ( turn 0 )
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]

    , named MenuLine3
            |> initializeWith
                ( 100 , Ease.linear )
                [ opacity 1
                , borderColor ( Color.rgb 238 238 238 )
                ]
            |> immediate
                MenuOpen
                    [ to
                        [ opacity 0
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]
            |> immediate
                MenuClose
                    [ to
                        [ opacity 1
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]
            |> immediate
                MenuHovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ opacity 1
                        , borderColor ( Color.rgb 0 17 17 )
                        ]
                    ]
            |> immediate
                MenuUnhovered
                    [ toWith
                        ( easing
                            { duration = ( 100 * millisecond )
                            , ease = Ease.linear }
                        )
                        [ opacity 1
                        , borderColor ( Color.rgb 238 238 238 )
                        ]
                    ]

    , named MenuBio
            |> initializeWith
                ( 200 , vars.menuItemEasing )
                menuItemInitialState
            |> immediate
                MenuOpen
                    ( openMenuItem ( px ( -60 ) ) vars )
            |> immediate
                MenuClose
                    closeMenuItem

    , named MenuSkills
            |> initializeWith
                ( 250 , vars.menuItemEasing )
                menuItemInitialState
            |> immediate
                MenuOpen
                    ( openMenuItem ( px 50 ) vars )
            |> immediate
                MenuClose
                    closeMenuItem

    , named MenuProjects
            |> initializeWith
                ( 300 , vars.menuItemEasing )
                menuItemInitialState
            |> immediate
                MenuOpen
                    ( openMenuItem ( px 160 ) vars )
            |> immediate
                MenuClose
                    closeMenuItem

    , named MenuContact
            |> initializeWith
                ( 350 , vars.menuItemEasing )
                menuItemInitialState
            |> immediate
                MenuOpen
                    ( openMenuItem ( px 270 ) vars )
            |> immediate
                MenuClose
                    closeMenuItem
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
