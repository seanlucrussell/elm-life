module GameOfLife exposing (Cell, Board, nextBoard)

import List exposing (range)
import Set exposing (..)

type alias Cell = (Int, Int)
type alias Board = Set Cell

nearby : Cell -> Board
nearby (x,y) = map (\n -> (x-1+modBy 3 n, y-1+n//3)) (fromList (range 0 8))

cellWillBeAlive : Board -> Cell -> Bool
cellWillBeAlive board cell =
  let neighbors = size (diff (intersect board (nearby cell)) (singleton cell))
  in neighbors == 3 || (neighbors == 2 && member cell board)

cellsToCheck : Board -> Board
cellsToCheck = foldl (nearby >> union) empty

nextBoard : Board -> Board
nextBoard board = filter (cellWillBeAlive board) (cellsToCheck board)
