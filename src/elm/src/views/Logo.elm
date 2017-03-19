module Logo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Cog

import SharedTypes exposing (..)

logo model =
    div [ class "column is-one-quarter"]
        [ div [ class "columns is-mobile" ]
            [ div [ class "column"]
                [ div [ id "logo" ]
                    [ span [ id "logo-d"]
                        [ text "D"
                        ]
                    , span
                        ( Cog.plug LogoCog model
                            ++ [ id "logo-cog", class "fa fa-cog" ]
                        )
                        []
                    , span [ id "logo-fill" ]
                        []
                    , div [ id "mini-cogs"]
                        [ div [ id "cog-container"]
                            [ span
                                ( Cog.plug MiniCog1 model
                                    ++ [ id "logo-mini-cog-1", class "fa fa-cog"]
                                )
                                []
                            , span
                                ( Cog.plug MiniCog2 model
                                    ++ [ id "logo-mini-cog-2", class "fa fa-cog"]
                                )
                                []
                            , span
                                ( Cog.plug MiniCog3 model
                                    ++ [ id "logo-mini-cog-3", class "fa fa-cog"]
                                )
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]
