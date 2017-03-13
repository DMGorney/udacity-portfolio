-- module TrueTest exposing (..)

{-- Core library and Package Library dependencies --}
import Html exposing (..)
import Html.Attributes exposing (..)
import Animation exposing (turn, px)
import Update.Extra.Infix exposing ((:>))
import Task
import CogTypes exposing ( Name(..), Trigger(..), MenuState(..), CogAnimMsg(..) )
import Cog
import CogFile

{-- Local Source Modules --}

-- Views
import Logo
import Intro
import Menu

{--

MAIN

--}

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

{--

MODEL

--}

type alias Model =
    { bits : (Cog.Bits Msg)
    , cogVars : CogFile.Vars
    }

init : ( Model, Cmd Msg)
init =
    let
        initialized = Cog.make ( CogFile.config CogFile.initVars CogMsg )

    in
        (   { bits = initialized
            , cogVars = CogFile.initVars
            } , Task.perform   ( \_ -> KickStart )
                             ( Task.succeed NoOp )
        )

{--

UPDATE

--}

type Msg
    = NoOp
    | Animate Animation.Msg
    | Cog CogTypes.Name CogTypes.Trigger
    | CogChunk CogTypes.Trigger
    | CogMsg CogTypes.CogAnimMsg
    | KickStart
    | ToggleMenu
    | MenuHover
    | MenuUnhover

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)

        Animate animMsg ->
            let
                ( animated, cmds ) =
                    Cog.animateBits model.bits animMsg

            in
                ({ model
                    | bits = animated
                }, cmds )

        Cog name trigger ->
            let
                triggered =
                    Cog.triggerBit model.bits name trigger

            in
                ({ model
                    | bits = triggered
                }, Cmd.none)

        CogChunk trigger ->
            let
                chunkTriggered =
                    Cog.triggerChunk model.bits trigger

            in
                ({ model
                    | bits = chunkTriggered
                }, Cmd.none)


        CogMsg ResetLogoCog ->
            ( model, Cmd.none )
                :> update ( Cog LogoCog StartGears )

        ToggleMenu ->
            if model.cogVars.menuState == Closed then
                let
                    opened =
                        CogFile.openMenu model.cogVars

                in
                    ({ model
                        | cogVars = opened
                    }, Cmd.none )
                        :> update (CogChunk MenuOpen)
            else
                let
                    closed =
                        CogFile.closeMenu model.cogVars

                in
                    ({ model
                        | cogVars = closed
                    }, Cmd.none )
                        :> update (CogChunk MenuClose)

        KickStart ->
            (model, Cmd.none)
                :> update (CogChunk Appear)
                :> update (CogChunk StartGears)

        MenuHover ->
            if model.cogVars.menuState == Closed then
                (model, Cmd.none)
                    :> update (CogChunk MenuHovered)
            else
                (model, Cmd.none)

        MenuUnhover ->
            if model.cogVars.menuState == Closed then
                (model, Cmd.none)
                    :> update (CogChunk MenuUnhovered)
            else
                (model, Cmd.none)

{--

SUBSCRIPTIONS

--}

subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate ( Cog.getSubscriptions model.bits )

{--

VIEW

--}

view : Model -> Html Msg
view model =
    div [ id "app-container" ]
        [ landingSection model
        ]

landingSection : Model -> Html Msg
landingSection model =
    div [ id "portfolio"]
        [ div   ( Cog.plug BGFader model
                    ++ [ id "bg-fader" ]
                )
            []
        , section [ id "landing" ]
            [ div [ class "columns is-mobile" ]
                [ Logo.logo model
                , Intro.intro model
                , Menu.menu model ToggleMenu MenuHover MenuUnhover
                ]
            ]
        ]
