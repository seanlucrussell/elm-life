module RenderBoard exposing (renderBoard)

import GameOfLife exposing (Board, Cell)
import Html exposing (Html)
import List exposing (filter, map, range)
import Set exposing (toList)
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg, circle, svg)
import Svg.Attributes exposing (cx, cy, fill, fillOpacity, height, r, width)


renderBoard : Board -> Html msg
renderBoard board =
    svg
        [ width "100%"
        , height "100%"
        ]
        (map (renderCell board) (filter inBounds (toList board)))


inBounds : Cell -> Bool
inBounds ( x, y ) =
    0 <= x && x < 100 && 0 <= y && y < 100


renderCell : Board -> Cell -> Svg msg
renderCell board cell =
    let
        ( x, y ) =
            cell

        opacity =
            1 / (1.001 ^ ((toFloat x - 49) ^ 2 + (toFloat y - 49) ^ 2))
    in
    circle
        [ cx (fromInt x ++ ".5%")
        , cy (fromInt y ++ ".5%")
        , r "0.5%"
        , fill "red"
        , fillOpacity (fromFloat opacity)
        ]
        []
