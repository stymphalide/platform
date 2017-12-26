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

type alias Player =
    { displayName : String
    , id : Int
    , score : Int
    , username : String
    }

type alias Model =
    { gamesList : List Game
    , playersList : List Player
    }

-- MESSAGES
type Msg 
    = FetchGamesList (Result Http.Error (List Game))
    | FetchPlayersList (Result Http.Error (List Player))

-- INIT
init : (Model, Cmd Msg)
init =
    (initialModel, initialCommand)

initialModel : Model
initialModel =
    { gamesList = 
        []
    , playersList = 
        []
    }
initialCommand : Cmd Msg
initialCommand =
    Cmd.batch
        [ fetchGamesList
        , fetchPlayersList
        ]
    

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
        FetchPlayersList result ->
            case result of
                Ok players ->
                    ({model | playersList = players}, Cmd.none)
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
fetchPlayersList : Cmd Msg
fetchPlayersList =
    Http.get "/api/players" decodePlayersList
        |> Http.send FetchPlayersList


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

decodePlayer : Decode.Decoder Player
decodePlayer =
    Decode.map4 Player
        (Decode.field "display_name" Decode.string)
        (Decode.field "id" Decode.int)
        (Decode.field "score" Decode.int)
        (Decode.field "username" Decode.string)

decodePlayersList : Decode.Decoder (List Player)
decodePlayersList =
    decodePlayer
        |> Decode.list
        |> Decode.at [ "data" ]


--VIEW
view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "games-section" ] [ text "Games" ]
        , gamesIndex model
        , playersIndex model
        ]


gamesIndex : Model -> Html Msg
gamesIndex model =
    if List.isEmpty model.gamesList then
        div [] []
    else
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

playersIndex : Model -> Html Msg
playersIndex model =
    if List.isEmpty model.playersList then
        div [] []
    else
        div [class "games-index"] 
            [ h1 [ class "players-section" ] [text "Players"]
            , playersList model.playersList
            ]

playersList : List Player -> Html Msg
playersList players = 
    ul [class "players-list"]
    (List.map playersListItem players)
playersListItem : Player -> Html Msg
playersListItem player =
    li [class "player-item"]
        [ strong [] [text player.displayName]
        , p [] [text (toString player.score)]
        ]

