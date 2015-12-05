module Main where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Json.Decode exposing (value)
import List
import Maybe
import Mouse
import Signal exposing (Address)
import Touch


main : Signal Html
main = Signal.map view changingCoord


type alias Coord = Maybe (Int, Int)


type Action = In | Out


actionsMailbox : Signal.Mailbox Action
actionsMailbox = Signal.mailbox Out


view : Coord -> Html
view c =
  let outerStyle = [("margin-left", "2em"), ("margin-top", "2em"), ("font-size", "20pt")]
      innerStyle = [("width", "20em"), ("height", "10em"), ("border", "1px solid black")]
      emitIn  = onBoth ["mousemove",  "touchmove"] actionsMailbox.address In
      emitOut = onBoth ["mouseleave", "touchend"]  actionsMailbox.address Out
  in
  div [style outerStyle]
    [ div ([style innerStyle] ++ emitIn ++ emitOut) []
    , p [] [text (toString c)]
    ]


onBoth : List String -> Signal.Address a -> a -> List Attribute
onBoth events a x =
  List.map (\event -> messageOn event a x) events


-- NOTE: Copied from Html.Events. Why isn't it exported...?
messageOn : String -> Signal.Address a -> a -> Attribute
messageOn name addr msg =
  on name value (\_ -> Signal.message addr msg)

changingCoord : Signal Coord
changingCoord =
  let mouse = Signal.map Just Mouse.position
      touch =
        Signal.map (Maybe.map toPair << List.head) Touch.touches
  in
  Signal.map2 toggleInOut actionsMailbox.signal <| Signal.merge mouse touch


toggleInOut : Action -> Coord -> Coord
toggleInOut a c =
  if a == In then
    c
  else
    Nothing


toPair : Touch.Touch -> (Int, Int)
toPair t = (t.x, t.y)
