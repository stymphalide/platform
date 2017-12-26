module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


-- MAIN
main : Html msg
main =
    div []
        [ h1 [] [text "Games"]
        , gamesIndex
        ]


gamesIndex : Html msg
gamesIndex =
    div [class "games-index"] [gamesList]

gamesList : Html msg
gamesList =
    ul [class "games-list"] 
        [ gamesListItem "Platform Game"
        , gamesListItem "Adventure Game"
        ]

gamesListItem : String -> Html msg
gamesListItem game =
    li [] [text game]