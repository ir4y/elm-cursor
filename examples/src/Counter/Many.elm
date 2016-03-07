module Counter.Many where

import Array exposing (Array)
import Html exposing (Html)
import Json.Decode as Json
import Json.Encode
import Maybe
import Signal exposing (Signal, Message)

import Html exposing (Html, text, div)
import Html.Attributes exposing (style)
import Html.Events exposing (on)

import Focus exposing (Focus, (=>))

import Cursor exposing (Cursor, (>=>))

import Counter.Counter as Counter


type alias Store =
  { counters_: Array Int
  }


counters : Focus Store (Array Int)
counters =
  Focus.create .counters_ (\f r -> { r | counters_ = f r.counters_ })


at : Int -> a -> Focus (Array a) a
at index default =
  let
    getter = Maybe.withDefault default << Array.get index
    setter f r =
      Array.set index
             (f (Maybe.withDefault default (Array.get index r))) r
  in
    Focus.create getter setter


button : (Json.Encode.Value -> Message) -> String -> Html
button f t =
  Html.button
        [ on "click" Json.value f ]
        [ text t ]


viewCounter : Cursor Store (Array Int) -> Int -> Int -> Html
viewCounter cursor index _ =
  let
    counter = cursor >=> at index -1
  in
    div [ Counter.countStyle ]
      [ Counter.view counter
      , button (\_ -> Cursor.update cursor <| removeItem index) "X"
      ]


addItem : Array Int -> Array Int
addItem counters =
  Array.push 0 counters


removeItem : Int -> Array Int -> Array Int
removeItem index cs =
  Array.append (Array.slice 0 index cs)
  <| Array.slice (index + 1) (Array.length cs) cs


view : Cursor Store Store -> Html.Html
view cursor =
  let
    cs = cursor >=> counters
  in
    div []
      [ button (\_ -> Cursor.update cs addItem) "Add item"
      , div []
          <| Array.toList
          <| Array.indexedMap (viewCounter cs)
          <| Cursor.get cs
      ]


main : Signal Html
main =
  Cursor.start { counters_ = Array.fromList [] } view
