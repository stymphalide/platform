module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode

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
    { description : String
    , featured : Bool
    , id : Int
    , thumbnail : String
    , title : String
    }

type alias Model =
    { gamesList : List Game
    }

-- MESSAGES
type Msg 
    = FetchGamesList (Result Http.Error (List Game))

-- INIT
init : (Model, Cmd Msg)
init =
    (initialModel, initialCommand)

initialModel : Model
initialModel =
    { gamesList = 
        []
    }
initialCommand : Cmd Msg
initialCommand =
    fetchGamesList

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchGamesList result ->
            case result of
                Ok games ->
                    ( {model | gamesList = games}, Cmd.none )
                Err _ ->
                    (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- COMMANDS
fetchGamesList : Cmd Msg
fetchGamesList =
    Http.get "/api/games" decodeGamesList
        |> Http.send FetchGamesList

-- DECODERS
decodeGame : Decode.Decoder Game
decodeGame =
    Decode.map5 Game
        (Decode.field "description" Decode.string)
        (Decode.field "featured" Decode.bool)
        (Decode.field "id" Decode.int)
        (Decode.field "thumbnail" Decode.string)
        (Decode.field "title" Decode.string)



decodeGamesList : Decode.Decoder (List Game)
decodeGamesList =
    decodeGame
        |> Decode.list
        |> Decode.at [ "data" ]


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