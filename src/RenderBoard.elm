module RenderBoard exposing (renderBoard)

import GameOfLife exposing (..)

import Html exposing (Html,div,button)
import Html.Attributes exposing (style)
import List exposing (range, map)
import Set exposing (member)
import String exposing (fromFloat)

renderCell : Board -> Cell -> Html msg
renderCell board cell =
  let
    (x,y) = cell
    opacity = 1 / (1.001 ^ (((toFloat x) - 49) ^ 2 + ((toFloat y) - 49) ^ 2))
  in
    div
      [ style "background-color" (if member cell board then "red" else "transparent")
      , style "height" "100%"
      , style "width" "1%"
      , style "opacity" (fromFloat opacity)
      , style "display" "inline-block"
      ]
      []

renderRow : Board -> Int -> Html msg
renderRow board rowNumber =
  div 
    [ style "height" "1%"
    , style "width" "100%"
    ]
    (map (\x -> renderCell board (x,rowNumber)) (range 0 99))

renderBoard : Board -> Html msg
renderBoard board =
  div
    [ style "width" "100%"
    , style "height" "100%"
    ]
    (map (renderRow board) (range 0 99))
