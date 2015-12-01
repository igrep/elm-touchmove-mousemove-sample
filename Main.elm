module Main where

import Html exposing (..)
import Html.Attributes exposing (style)
import Mouse
import Signal exposing (Address)
import Touch

main : Signal Html
main =
  Signal.constant <|
    div [ style [ ("margin-left", "2em"), ("margin-top", "2em"), ("font-size", "20pt") ] ]
      [ div
          [ style [ ("width", "20em"), ("height", "10em"), ("border", "1px solid black") ] ]
          []
      , p [] [text "Coordinates: "]
      ]
