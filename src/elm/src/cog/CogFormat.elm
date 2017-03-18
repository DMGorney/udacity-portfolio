module CogFormat exposing (..)

import Animation
import Animation.Messenger
import Maybe exposing (Maybe(..))
import Ease
import Time exposing (millisecond)

import CogTypes

type alias Config msg =
    { name : CogTypes.Name
    , init : (Animation.Messenger.State msg)
    , sequences : List (Sequence msg)
    }

type alias Sequence msg =
    ( CogTypes.Trigger , List (Animation.Messenger.Step msg) )

named : CogTypes.Name -> (Config msg)
named elementName =
    { name =
        elementName
    , init =
        Animation.style
            []
    , sequences =
        []
    }


initialize : List Animation.Property -> (Config msg) -> (Config msg)
initialize  initialStyle config =
    let
        styled =
            Animation.style
                initialStyle
    in
        { config
            | init = styled
        }

initializeWith : ( Float, Ease.Easing ) -> List Animation.Property -> (Config msg) -> (Config msg)
initializeWith ( customDuration, customEasing ) initialStyle config =
    let
        styled =
            Animation.styleWith
                ( Animation.easing
                    { duration = ( customDuration * millisecond )
                    , ease = customEasing
                    }
                )
                initialStyle

    in
        { config
            | init = styled
        }



animations : (Config msg) -> (Config msg)
animations config =
    config

(=>) : CogTypes.Trigger -> List (Animation.Messenger.Step msg) -> Sequence msg
(=>) trigger steps =
    ( trigger, steps )

immediate : CogTypes.Trigger -> List (Animation.Messenger.Step msg) -> (Config msg) -> (Config msg)
immediate trigger steps config =
    let
        sequence =
            trigger => steps

    in
        { config
            | sequences = sequence :: config.sequences
        }
