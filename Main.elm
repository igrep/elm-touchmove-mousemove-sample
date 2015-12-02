module Main where

import Html exposing (..)
import Html.Attributes exposing (style)
import List
import Maybe
import Mouse
import Signal exposing (Address)
import Touch


main : Signal Html
main = Signal.map view mergedCoord

type alias Coord = Maybe (Int, Int)

view : Coord -> Html
view c =
  div [ style [ ("margin-left", "2em"), ("margin-top", "2em"), ("font-size", "20pt") ] ]
    [ div
      [ style [ ("width", "20em"), ("height", "10em"), ("border", "1px solid black") ] ]
      []
    , p [] [text (toString c)]
    ]


mergedCoord : Signal Coord
mergedCoord =
  let mouse = Signal.map Just Mouse.position
      touch =
        Signal.map (Maybe.map toPair << List.head) Touch.touches
  in
  Signal.merge mouse touch


toPair : Touch.Touch -> (Int, Int)
toPair t = (t.x, t.y)

