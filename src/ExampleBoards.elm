module ExampleBoards exposing (..)

import GameOfLife exposing (Board)
import Set exposing (fromList)


gliderGun : Board
gliderGun =
    fromList
        [ ( 35, 50 )
        , ( 35, 51 )
        , ( 36, 50 )
        , ( 36, 51 )
        , ( 45, 50 )
        , ( 45, 51 )
        , ( 45, 52 )
        , ( 46, 49 )
        , ( 46, 53 )
        , ( 47, 48 )
        , ( 47, 54 )
        , ( 48, 48 )
        , ( 48, 54 )
        , ( 49, 51 )
        , ( 50, 49 )
        , ( 50, 53 )
        , ( 51, 50 )
        , ( 51, 51 )
        , ( 51, 52 )
        , ( 52, 51 )
        , ( 55, 48 )
        , ( 55, 49 )
        , ( 55, 50 )
        , ( 56, 48 )
        , ( 56, 49 )
        , ( 56, 50 )
        , ( 57, 47 )
        , ( 57, 51 )
        , ( 59, 46 )
        , ( 59, 47 )
        , ( 59, 51 )
        , ( 59, 52 )
        , ( 69, 48 )
        , ( 69, 49 )
        , ( 70, 48 )
        , ( 70, 49 )
        ]


methuselah : Board
methuselah =
    fromList [ ( 47, 51 ), ( 48, 49 ), ( 48, 51 ), ( 50, 50 ), ( 51, 51 ), ( 52, 51 ), ( 53, 51 ) ]


explosion : Board
explosion =
    fromList [ ( 49, 50 ), ( 50, 49 ), ( 50, 50 ), ( 50, 51 ), ( 51, 49 ) ]


glider : Board
glider =
    fromList [ ( 49, 50 ), ( 50, 51 ), ( 51, 49 ), ( 51, 50 ), ( 51, 51 ) ]
