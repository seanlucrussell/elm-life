module Main exposing (..)

import Html.Attributes exposing (style)

import Random
import Browser
import String exposing (fromFloat)
import Tuple exposing (first, second)
import Html exposing (Html,div,text, button)
import Html.Events exposing (onClick)
import List exposing (foldl, map, concatMap, range)
import Set exposing (Set, union, empty, singleton, fromList, toList, member, filter, size)
import Process
import Task

type alias Cell = (Int, Int)
type alias Board = Set Cell

-- a couple of generic set functions
cartesianProduct : List a -> List b -> List (a,b)
cartesianProduct xs ys = List.concatMap ( \x -> List.map ( \y -> (x,y) ) ys ) xs

unions : List (Set comparable) -> Set comparable
unions = foldl union empty

-- now we define the proper semantics for the game of life
nearbyCells (x,y) = fromList (cartesianProduct (range (x-1) (x+1)) (range (y-1) (y+1)))

cellWillBeAlive : Board -> Cell -> Bool
cellWillBeAlive board cell =
  let numberOfNeighbors = size (filter (\n -> n /= cell && member n board) (nearbyCells cell))
  in numberOfNeighbors == 3 || (numberOfNeighbors == 2 && member cell board)

nearbyLiveCells : Board -> Cell -> Board
nearbyLiveCells b c = filter (cellWillBeAlive b) (nearbyCells c)

nextBoard : Board -> Board
nextBoard b = unions (map (nearbyLiveCells b) (toList b))

-- and the UI
type Msg = SleepComplete | RandomnessGenerated (List Cell) | LoadBoard Board | GenBoard
type alias Model = Board

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
        case msg of
            SleepComplete -> (nextBoard model, sleep)
            RandomnessGenerated cells -> (fromList cells, sleep)
            LoadBoard board -> (board, sleep)
            GenBoard -> (model, Random.generate RandomnessGenerated boardGen)

sleep : Cmd Msg
sleep = Process.sleep 100 |> Task.perform (always SleepComplete)

renderCell : Board -> Cell -> Html msg
renderCell board cell =
    let visibility = 1 / (1.001 ^ (((toFloat (first cell)) - 49) ^ 2 + ((toFloat (second cell)) - 49) ^ 2))
     in div
        [ style "background-color" (if member cell board then "red" else "transparent")
        , style "height" "100%"
        , style "width" "1%"
        , style "opacity" (fromFloat visibility)
        , style "display" "inline-block"
        ]
        []

renderRow : Board -> Int -> Html msg
renderRow board n =
        div 
        [ style "height" "1%"
        , style "width" "100%"
        ]
        (map (\x -> renderCell board (x,n)) (range 0 99))

buttonStyle = [ style "margin" ".4em .7em"
              , style "padding" ".4em 1em"
              , style "font-size" "large"
              , style "font-weight" "200"
              -- , style "color" "white"
              -- , style "border-radius" "0.7em"
              -- , style "border" "none"
              -- , style "background-color" "orange"

              , style "border-radius" "0.2em"
              , style "border-width" "thin"
              , style "border-style" "solid"
              , style "border-color" "silver"


              -- , style "box-shadow" ".2em .2em .1em, -.2em -.2em .1em gray"
              -- , style "color" "black"
              -- , style "background-color" "transparent"
              -- , style "border" "medium solid black"

              -- , style "border-radius" "0.7em"
              -- , style "box-shadow" ".4em .4em 0 -.3em, -.4em -.4em 0 -.3em"
              -- , style "box-shadow" ".6em .6em 0 -.5em orange, -.6em -.6em 0 -.5em orange"
              -- , style "color" "orange"
              -- -- , style "color" "black"
              -- , style "border" "none"
              , style "background-color" "#ffffffbb"
              -- , style "background-color" "transparent"

              -- , style "background-color" "#331111"
              , style "color" "#112233"
              -- , style "border" "none"
              -- , style "color" "white"
              ]

view : Board -> Html Msg
view b =
  div
    [style "aspect-ratio" "1/1", style "width" "100%", style "position" "relative"]
    [ div [ style "width" "100%", style "height" "100%" ] (map (\y -> renderRow b y) (range 0 99))
    , div [ style "position" "absolute", style "bottom" "0", style "width" "100%", style "display" "flex", style "justify-content" "center", style "flex-wrap" "wrap"]
      [ button (buttonStyle ++ [ onClick GenBoard ]) [ text "Randomize" ]
      , button (buttonStyle ++ [ onClick (LoadBoard glider) ]) [ text "Glider" ]
      , button (buttonStyle ++ [ onClick (LoadBoard explosion) ]) [ text "Explosion" ]
      , button (buttonStyle ++ [ onClick (LoadBoard methuselah) ]) [ text "Methuselah" ]
      , button (buttonStyle ++ [ onClick (LoadBoard gliderGun) ]) [ text "Glider Gun" ]
      ]
    ]

gliderGun : Board
gliderGun =
  fromList [ (35,50),(35,51)
           , (36,50),(36,51)
           , (45,50),(45,51),(45,52)
           , (46,49),(46,53)
           , (47,48),(47,54)
           , (48,48),(48,54)
           , (49,51)
           , (50,49),(50,53)

           , (51,50),(51,51),(51,52)
           , (52,51)

           , (55,48),(55,49),(55,50)
           , (56,48),(56,49),(56,50)
           , (57,47),(57,51)
           , (59,46),(59,47),(59,51),(59,52)
           , (69,48),(69,49)
           , (70,48),(70,49)
           ]


methuselah : Board
methuselah = fromList [(47,51),(48,49),(48,51),(50,50),(51,51),(52,51),(53,51)]

explosion : Board
explosion = fromList [(49,50),(50,49),(50,50),(50,51),(51,49)]

glider : Board
glider = fromList [(49,50),(50,51),(51,49),(51,50),(51,51)]

boardGen : Random.Generator (List Cell)
boardGen = Random.list 500 (Random.pair (Random.int 40 60) (Random.int 40 60))

initialModel = (fromList [(0,0),(2,3),(5,6),(1,3)], Random.generate RandomnessGenerated boardGen)

main : Program () Model Msg
main = Browser.element
        { init = always initialModel
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
