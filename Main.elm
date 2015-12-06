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
main = Signal.map2 view (changingCoord actionsMailbox1.signal) (changingCoord actionsMailbox2.signal)


type alias Coord = Maybe (Int, Int)


type Action = In | Out


actionsMailbox1 : Signal.Mailbox Action
actionsMailbox1 = Signal.mailbox Out

actionsMailbox2 : Signal.Mailbox Action
actionsMailbox2 = Signal.mailbox Out


view : Coord -> Coord -> Html
view c1 c2 =
  let outerStyle = [("margin-left", "2em"), ("margin-top", "2em"), ("font-size", "20pt")]
      innerStyle = [("width", "20em"), ("height", "10em"), ("border", "1px solid black")]
      emitIn1  = onBoth ["mousemove",  "touchmove"] actionsMailbox1.address In
      emitOut1 = onBoth ["mouseleave", "touchend"]  actionsMailbox1.address Out
      emitIn2  = onBoth ["mousemove",  "touchmove"] actionsMailbox2.address In
      emitOut2 = onBoth ["mouseleave", "touchend"]  actionsMailbox2.address Out
  in
  div [style outerStyle]
    [ div ([style innerStyle] ++ emitIn1 ++ emitOut1) []
    , p [] [text (toString c1)]
    , div ([style innerStyle] ++ emitIn2 ++ emitOut2) []
    , p [] [text (toString c2)]
    ]


onBoth : List String -> Signal.Address a -> a -> List Attribute
onBoth events a x =
  List.map (\event -> messageOn event a x) events


-- NOTE: Copied from Html.Events. Why isn't it exported...?
messageOn : String -> Signal.Address a -> a -> Attribute
messageOn name addr msg =
  on name value (\_ -> Signal.message addr msg)

changingCoord : Signal Action -> Signal Coord
changingCoord actions =
  let mouse = Signal.map Just Mouse.position
      touch =
        Signal.map (Maybe.map toPair << List.head) Touch.touches
  in
  Signal.map2 toggleInOut actions <| Signal.merge mouse touch


toggleInOut : Action -> Coord -> Coord
toggleInOut a c =
  if a == In then
    c
  else
    Nothing


toPair : Touch.Touch -> (Int, Int)
toPair t = (t.x, t.y)
