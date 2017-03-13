module Intro exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import CogTypes exposing ( Name(..), Trigger(..) )
import Cog


intro model =
    div [ id "intro", class "column is-half" ]
        [ div [ class "columns is-mobile is-multiline is-gapless"]
            [ introItem viewGreeting model
            , introItem viewIntroduction1 model
            , introItem viewIntroduction2 model
            ]
        ]

-- introItem : IntroItem -> Model -> Html msg
introItem {target, itemID, classes, content} model =
    div
        ( Cog.plug target model
            ++  [ id itemID
                , class classes
                ]
        )
        [ text content
        ]

type alias IntroItem =
    { target : CogTypes.Name
    , itemID : String
    , classes : String
    , content : String
    }

viewGreeting =
    { target = Greeting
    , itemID = "greeting"
    , classes = "column is-12 has-text-centered"
    , content =  "Hi."
    }

viewIntroduction1 =
    { target = Introduction1
    , itemID = "introduction1"
    , classes = "column has-text-right is-5"
    , content = " I'm"
    }

viewIntroduction2 =
    { target = Introduction2
    , itemID = "introduction2"
    , classes = "column has-text-left is-7"
    , content = "Daniel."
    }
