module CogTypes exposing (..)

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

type CogAnimMsg
    = ResetLogoCog

type MenuState
    = Open
    | Closed
