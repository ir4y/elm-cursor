module Single where

import Cursor exposing(..)
import Array
import Counter.Counter as Counter
import Focus exposing((=>))
import Html exposing (Html)
import Json.Decode as Json
import Html exposing (Html, text, div, button)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Json
import Maybe


type alias Store =
  { counters: Array.Array Int
  }


countersL : Focus.Focus Store (Array.Array Int)
countersL =
  Focus.create .counters (\f r -> { r | counters = f r.counters })


atL : Int -> a -> Focus.Focus (Array.Array a) a
atL index default =
  let
    getter = ((Maybe.withDefault  default) << (Array.get index))
    setter = (\f r -> (Array.set index (f (Maybe.withDefault  default (Array.get index r))) r))
  in
    Focus.create getter setter


view_counter : Cursor Store (Array.Array Int) -> Int -> Int -> Html
view_counter counters index _ =
  let
    c = counters >=> (atL index -1)
  in
    div [ countStyle ] [ Counter.view c
           , button [ on "click" Json.value <| \_ -> updateC counters <| removeItem index] [text "X"]
           ]

addItem : Array.Array Int -> Array.Array Int
addItem counters = Array.push 0 counters

removeItem : Int -> Array.Array Int -> Array.Array Int
removeItem index cs = Array.append (Array.slice 0 index cs) (Array.slice (index + 1) (Array.length cs) cs)

view : Cursor Store Store -> Html.Html
view cursor =
  let
    counters = cursor >=> countersL
  in
    div [] [ button [ on "click" Json.value <| \_ -> updateC counters addItem] [ text "Add item" ]
           , div [] <| Array.toList (Array.indexedMap (view_counter counters) (getC counters))
           ]


main =
  drawC {counters = Array.fromList []} view

countStyle : Html.Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
