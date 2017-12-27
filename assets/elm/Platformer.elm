module Platformer exposing (..)

import AnimationFrame exposing (diffs)
import Html exposing (Html, div)
import Keyboard exposing (KeyCode, downs, ups)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, every, second)



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
type Direction
    = Left
    | Right

type GameState
    = StartScreen
    | Playing
    | Success
    | GameOver

type alias Model =
    { gameState : GameState
    , characterPositionX : Float
    , characterPositionY : Float
    , characterVelocity : Float
    , characterDirection : Direction
    , itemPositionX : Int
    , itemPositionY : Int
    , playerScore : Int
    , itemsCollected : Int
    , timeRemaining : Int
    }

initialModel : Model
initialModel =
    { gameState = StartScreen
    , characterPositionX = 50.0
    , characterPositionY = 300.0
    , characterVelocity = 0.0
    , characterDirection = Right
    , itemPositionX = 500
    , itemPositionY = 300
    , itemsCollected = 0
    , playerScore = 0
    , timeRemaining = 10
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

-- UPDATE
type Msg
    = NoOp
    | KeyDown KeyCode
    | KeyUp KeyCode
    | TimeUpdate Time
    | CountdownTimer Time
    | SetNewItemPositionX Int
    | MoveCharacter Time

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        KeyDown keyCode ->
            case keyCode of
                32 -> -- Space Bar
                    let
                        resetGameState  =
                            ( { model 
                                | gameState = Playing
                                , playerScore = 0
                                , itemsCollected = 0
                                , timeRemaining = 10
                            }, Cmd.none)
                    in
                        case model.gameState of
                            StartScreen ->
                                resetGameState
                            Success ->
                                resetGameState
                            GameOver ->
                                resetGameState
                            Playing ->
                                (model, Cmd.none)
                37 -> -- Left Arrow
                    ({model | characterVelocity = -0.3}, Cmd.none)
                39 -> -- Right Arrow
                    ( {model | characterVelocity =  0.3}, Cmd.none)
                _ ->
                    (model, Cmd.none)
        KeyUp keyCode ->
            case keyCode of
                37 -> -- Left Arrow 
                    ( {model | characterVelocity = 0 }, Cmd.none )
                39 -> -- Right Arrow
                    ( {model | characterVelocity = 0 }, Cmd.none )
                _ ->
                    ( model, Cmd.none )


        TimeUpdate time ->
            if characterFoundItem model then
                ( { model 
                    | itemsCollected = model.itemsCollected + 1
                    , playerScore = model.playerScore + 100
                }, Random.generate SetNewItemPositionX (Random.int 50 500) )
            else if model.itemsCollected >= 10 then
                ( {model | gameState = Success }, Cmd.none)
            else if model.itemsCollected < 10 && model.timeRemaining == 0 then
                ( {model | gameState = GameOver }, Cmd.none )
            else
                (model, Cmd.none)
        CountdownTimer time ->
            if model.timeRemaining > 0 then
                ( {model | timeRemaining = model.timeRemaining - 1}, Cmd.none )
            else
                ( model, Cmd.none )
        SetNewItemPositionX newPositionX ->
            ( {model | itemPositionX = newPositionX}, Cmd.none )
        MoveCharacter time ->
            ( {model | characterPositionX = model.characterPositionX + model.characterVelocity * time}, Cmd.none )

characterFoundItem : Model -> Bool
characterFoundItem model =
    let
        approximateItemLowerBound =
            toFloat model.itemPositionX - 35
        approximateItemUpperBound =
            toFloat model.itemPositionX + 35

        currentCharacterPosition =
            model.characterPositionX
    in
        currentCharacterPosition
            >= approximateItemLowerBound
            && currentCharacterPosition
            <= approximateItemUpperBound


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch 
    [ downs KeyDown
    , ups KeyUp
    , diffs TimeUpdate
    , diffs MoveCharacter
    , every second CountdownTimer
    ]

-- VIEW
view : Model -> Html Msg
view model =
    div [] 
        [ viewGame model]

viewGame : Model -> Svg Msg
viewGame model = 
    svg [ version "1.1", width "600", height "400" ] 
        (viewGameState model)

viewGameState : Model -> List (Svg Msg)
viewGameState model = 
    case model.gameState of
        StartScreen ->
            [ viewGameWindow 
            , viewGameSky
            , viewGameGround
            , viewCharacter model
            , viewItem model
            , viewStartScreenText 
            ]
        Playing ->
            [ viewGameWindow 
            , viewGameSky
            , viewGameGround
            , viewCharacter model
            , viewItem model
            , viewGameScore model
            , viewItemsCollected model
            , viewGameTime model
            ]
        Success ->
            [ viewGameWindow 
            , viewGameSky
            , viewGameGround
            , viewCharacter model
            , viewItem model
            , viewSuccessScreenText
            ]
        GameOver ->
            [ viewGameWindow 
            , viewGameSky
            , viewGameGround
            , viewCharacter model
            , viewItem model
            , viewGameOverScreenText
            ]

viewGameText : Int -> Int -> String -> Svg Msg
viewGameText positionX positionY str =
    Svg.text_
        [ x <| toString positionX
        , y <| toString positionY
        , fontFamily "Courier"
        , fontWeight "bold"
        , fontSize "16"
        ] [Svg.text str]

viewStartScreenText : Svg Msg
viewStartScreenText =
    Svg.svg []
        [ viewGameText 140 160 "Collect ten coins in ten seconds!"
        , viewGameText 140 180 "Press the SPACE BAR key to start."
        ]

viewSuccessScreenText : Svg Msg
viewSuccessScreenText =
    Svg.svg []
        [ viewGameText 120 180 "Success!"
        , viewGameText 140 180 "Press the SPACE BAR key to restart."
        ]

viewGameOverScreenText : Svg Msg
viewGameOverScreenText =
    Svg.svg []
        [ viewGameText 260 160 "Game Over"
        , viewGameText 140 180 "Press the SPACE BAR key to restart."
        ]

viewGameScore : Model -> Svg Msg
viewGameScore model =
    let
        currentScore =
            model.playerScore
                |> toString
                |> String.padLeft 5 '0'
    in
        Svg.svg []
            [ viewGameText 25 25 "SCORE"
            , viewGameText 25 40 currentScore
            ]

viewGameWindow : Svg Msg
viewGameWindow =
    rect
        [ width "600"
        , height "400"
        , fill "none"
        , stroke  "black"
        ] []


viewGameSky : Svg Msg
viewGameSky =
    rect
        [ x "0"
        , y "0"
        , width "600"
        , height "300"
        , fill "#4b7cfb"
        ] []

viewGameGround : Svg Msg
viewGameGround =
    rect 
        [ x "0"
        , y "300"
        , width "600"
        , height "100"
        , fill "green"
        ] []

viewCharacter : Model -> Svg Msg
viewCharacter model =
    image
        [ xlinkHref "/images/character.gif"
        , x <| toString model.characterPositionX
        , y <| toString model.characterPositionY
        , width "50"
        , height "50"
        ] []

viewItem : Model -> Svg Msg
viewItem model =
    image
        [ xlinkHref "/images/coin.svg"
        , x <| toString model.itemPositionX
        , y <| toString model.itemPositionY
        , width "20"
        , height "20"
        ] []

viewItemsCollected : Model -> Svg Msg
viewItemsCollected model =
    let
        currentItemCount =
            model.itemsCollected
                |> toString
                |> String.padLeft 3 '0'
    in
        Svg.svg []
            [ image 
                [ xlinkHref "/images/coin.svg"
                , x "275"
                , y "18"
                , width "15"
                , height "15"
                ] []
            , viewGameText 300 30 ("x " ++ currentItemCount)
            ] 
viewGameTime : Model -> Svg Msg
viewGameTime model =
    let
        currentTime =
            model.timeRemaining
                |> toString
                |> String.padLeft 4 '0'
    in
        Svg.svg []
            [ viewGameText 525 25 "TIME"
            , viewGameText 525 40 currentTime
            ]