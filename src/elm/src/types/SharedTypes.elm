module SharedTypes exposing (..)

import Animation

type Msg
    = NoOp
    | Animate Animation.Msg
    | Cog Name Trigger
    | CogChunk Trigger
    | CogEvent Event
    -- | CogTimeline Timeline

type Name
    = Greeting
    | Introduction1
    | Introduction2
    | LogoCog
    | MiniCog1
    | MiniCog2
    | MiniCog3
    | MenuIcon
    | MenuLine1
    | MenuLine2
    | MenuLine3
    | MenuBio
    | MenuSkills
    | MenuProjects
    | MenuContact
    | BGFader

type Trigger
    = Appear
    | StartGears
    | MenuHovered
    | MenuUnhovered
    | MenuOpen
    | MenuClose

type Event
    = KickStart
    | ToggleMenu
    | MenuHover
    | MenuUnhover

-- type Timeline
--     = GreetingsAppear

type CogAnimMsg
    = ResetLogoCog

type Collapsable
    = Open
    | Collapsed
