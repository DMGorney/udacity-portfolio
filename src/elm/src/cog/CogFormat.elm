module CogFormat exposing (..)

import Animation
import Animation.Messenger
import Maybe exposing (Maybe(..))
import Ease
import Time exposing (millisecond)

import SharedTypes exposing (..)

type alias Config msg =
    { name : SharedTypes.Name
    , init : (Animation.Messenger.State msg)
    , sequences : List (Sequence msg)
    }

type alias Sequence msg =
    ( SharedTypes.Trigger , ((Animation.Messenger.State msg) -> (Animation.Messenger.State msg)) )

named : SharedTypes.Name -> (Config msg)
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

immediate : SharedTypes.Trigger -> List (Animation.Messenger.Step msg) -> (Config msg) -> (Config msg)
immediate trigger steps config =
    let
        interrupt =
            (Animation.interrupt steps)

        sequence =
            ( trigger, interrupt )

    in
        { config
            | sequences = sequence :: config.sequences
        }

afterCurrent : SharedTypes.Trigger -> List (Animation.Messenger.Step msg) -> (Config msg) -> (Config msg)
afterCurrent trigger steps config =
    let
        queued =
            (Animation.queue steps)

        sequence =
            ( trigger, queued )

    in
        { config
            | sequences = sequence :: config.sequences
        }
