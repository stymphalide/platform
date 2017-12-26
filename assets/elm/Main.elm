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
    { title : String
    , description : String
    }

type alias Model =
    { gamesList : List Game
    }

-- MESSAGES
type Msg 
    = FetchGamesList

-- INIT
init : (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

initialModel : Model
initialModel =
    { gamesList = 
        []
    }

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchGamesList ->
            ( {model | gamesList = []}, Cmd.none )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


--VIEW
view : Model -> Html Msg
view model =
    if List.isEmpty model.gamesList then
        div [] []
    else
        div []
            [ h1 [ class "games-section" ] [ text "Games" ]
            , gamesIndex model
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
        [ strong  [] [ text game.title ] 
        , p [] [ text game.description ]
        ]