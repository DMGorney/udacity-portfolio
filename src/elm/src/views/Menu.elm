module Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import CogTypes exposing ( Name(..), Trigger(..) )
import Cog

menu model menuToggleMsg menuHoverMsg menuUnhoverMsg =
    div [ class "column is-one-quarter"]
        [ div [ class "columns" ]
            [ div [ id "menu-container", class "column" ]
                [ div
                    ( Cog.plug MenuIcon model
                        ++  [ id "menu"
                            , onClick menuToggleMsg
                            , onMouseOver menuHoverMsg
                            , onMouseOut menuUnhoverMsg
                            ]
                    )
                    [ div [ id "line-container"]
                        [ div   ( Cog.plug MenuLine1 model
                                    ++ [ class "menu-line" ]
                                )
                                []
                        , div   ( Cog.plug MenuLine2 model
                                    ++ [ class "menu-line" ]
                                )
                                []
                        , div   ( Cog.plug MenuLine3 model
                                    ++ [ class "menu-line" ]
                                )
                                []
                        ]
                    , div [ id "menu-item-container" ]
                        [ menuItem "bio" "Who I Am" "fa fa-user" MenuBio model
                        , menuItem "skills" "What I Do" "fa fa-bar-chart" MenuSkills model
                        , menuItem "projects" "Projects" "fa fa-cogs" MenuProjects model
                        , menuItem "contact" "Contact Me" "fa fa-envelope" MenuContact model
                        ]
                    ]
                ]
            ]
        ]

menuItem target description icon menuAnimationTarget model =
    div ( Cog.plug menuAnimationTarget model
            ++ [ id ( "menu-" ++ target ) ]
        )
        [ div [ id ( target ++ "-wrapper" ) ]
            [ div [ id ( target ++ "-icon-wrapper" ) ]
                [ span [ id ( target ++ "-icon" ), class icon ] []
                ]
            , div [ id ( target ++ "-textbubble" ) ]
                [ div [ id ( target ++ "-text-wrapper" ) ]
                    [ text description
                    ]
                ]
            ]
        ]
