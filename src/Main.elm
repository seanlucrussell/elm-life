module Main exposing (..)

import Browser
import Css exposing (..)
import ExampleBoards exposing (..)
import GameOfLife exposing (..)
import Html
import Html.Styled exposing (Html, button, div, text, toUnstyled)
import Html.Styled.Attributes exposing (css, style)
import Html.Styled.Events exposing (onClick)
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
    Random.list 500 (Random.pair (Random.int 40 60) (Random.int 10 30))


sleep : Cmd Msg
sleep =
    Process.sleep 400 |> Task.perform (always SleepComplete)


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
        , css
            [ margin2 (em 0.4) (em 0.7)
            , padding2 (em 0.4) (em 1)
            , fontSize large
            , fontWeight (int 200)
            , borderRadius (em 0.2)
            , borderWidth (px 1)
            , borderStyle solid
            , borderColor (hex "C0C0C0")
            , backgroundColor (hex "ffffffbb")
            , color (hex "112233")
            , hover
                [ backgroundColor (hex "ddddddbb")
                , borderColor (hex "a0a0a0")
                ]
            ]
        ]
        [ text description ]


offset : Int -> Int -> Board -> Board
offset n m =
    map (\( x, y ) -> ( x + n, y + m ))


view : Board -> Html Msg
view b =
    div
        [ css
            [ width (pct 100)
            , position relative
            ]
        , style
            "aspect-ratio"
            "2/1"
        ]
        [ renderBoard b
        , div
            [ css
                [ position absolute
                , bottom (px 0)
                , width (pct 100)
                , displayFlex
                , justifyContent center
                , flexWrap wrap
                ]
            ]
            [ selectorButton GenBoard "Randomize"
            , selectorButton (LoadBoard (offset 50 20 glider)) "Glider"
            , selectorButton (LoadBoard (offset 50 20 pulsar)) "Pulsar"
            , selectorButton (LoadBoard (offset 50 20 methuselah)) "Methuselah"
            , selectorButton (LoadBoard (offset 50 20 gliderGun)) "Glider Gun"
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always initialModel
        , view = view >> toUnstyled
        , update = update
        , subscriptions = always Sub.none
        }
