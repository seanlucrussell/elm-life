module Main exposing (..)

import Browser
import ExampleBoards exposing (..)
import GameOfLife exposing (..)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Process
import Random
import RenderBoard exposing (..)
import Set exposing (fromList, map)
import Task


type Msg
    = SleepComplete
    | RandomBoardGenerated (List Cell)
    | LoadBoard Board
    | GenBoard


type alias Model =
    Board


randomBoardGenerator : Random.Generator (List Cell)
randomBoardGenerator =
    Random.list 500 (Random.pair (Random.int 40 60) (Random.int 40 60))


sleep : Cmd Msg
sleep =
    Process.sleep 300 |> Task.perform (always SleepComplete)


initialModel : ( Model, Cmd Msg )
initialModel =
    ( fromList [], Random.generate RandomBoardGenerated randomBoardGenerator )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SleepComplete ->
            ( nextBoard model, sleep )

        RandomBoardGenerated cells ->
            ( fromList cells, sleep )

        LoadBoard board ->
            ( board, sleep )

        GenBoard ->
            ( model, Random.generate RandomBoardGenerated randomBoardGenerator )


selectorButton : msg -> String -> Html msg
selectorButton msg description =
    button
        [ onClick msg
        , style "margin" ".4em .7em"
        , style "padding" ".4em 1em"
        , style "font-size" "large"
        , style "font-weight" "200"
        , style "border-radius" "0.2em"
        , style "border-width" "thin"
        , style "border-style" "solid"
        , style "border-color" "silver"
        , style "background-color" "#ffffffbb"
        , style "color" "#112233"
        ]
        [ text description ]


offset : Int -> Int -> Board -> Board
offset n m =
    map (\( x, y ) -> ( x + n, y + m ))


view : Board -> Html Msg
view b =
    div
        [ style "aspect-ratio" "1/1"
        , style "width" "100%"
        , style "position" "relative"
        ]
        [ renderBoard b
        , div
            [ style "position" "absolute"
            , style "bottom" "0"
            , style "width" "100%"
            , style "display" "flex"
            , style "justify-content" "center"
            , style "flex-wrap" "wrap"
            ]
            [ selectorButton GenBoard "Randomize"
            , selectorButton (LoadBoard (offset 50 50 glider)) "Glider"
            , selectorButton (LoadBoard (offset 50 50 pulsar)) "Pulsar"
            , selectorButton (LoadBoard (offset 50 50 methuselah)) "Methuselah"
            , selectorButton (LoadBoard (offset 50 50 gliderGun)) "Glider Gun"
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always initialModel
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
