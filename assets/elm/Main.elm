module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


-- MAIN

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL
type alias Game =
    { gameTitle : String
    , gameDescription : String
    }

type alias Model =
    { gamesList : List Game
    , displayGamesList : Bool
    }

-- MESSAGES
type Msg 
    = DisplayGamesList 
    | HideGamesList

-- INIT
init : (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

initialModel : Model
initialModel =
    { gamesList = 
        [ { gameTitle = "Platform Game"
          , gameDescription = "Platform game example."
          }
        , { gameTitle = "Adventure Game"
          , gameDescription = "Adventure game example."
          }
        ]
    , displayGamesList = False
    }

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DisplayGamesList ->
            ({ model | displayGamesList = True }, Cmd.none)
        HideGamesList ->
            ({ model | displayGamesList = False }, Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


--VIEW
view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "games-section" ] [ text "Games" ]
        , button [ onClick DisplayGamesList, class "btn btn-success" ] [ text "Display Games List" ]
        , button [ onClick HideGamesList, class "btn btn-danger" ] [ text "Hide Games List" ]
        , if model.displayGamesList then 
            gamesIndex model
          else
            div [] []
        ]


gamesIndex : Model -> Html Msg
gamesIndex model =
    div [class "games-index"] [gamesList model.gamesList]

gamesList : List Game -> Html Msg
gamesList games  =
    ul [class "games-list"] 
    (List.map gamesListItem games)

gamesListItem : Game -> Html Msg
gamesListItem game =
    li [class "game-item"] 
        [ strong  [] [ text game.gameTitle ] 
        , p [] [ text game.gameDescription ]
        ]