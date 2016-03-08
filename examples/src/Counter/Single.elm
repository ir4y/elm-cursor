module Counter.Single where

import Json.Decode as Json
import Signal exposing (Signal)

import Html exposing (Html)

import Focus exposing (Focus, (=>))

import Cursor exposing (Cursor, (>=>))

import Counter.Counter as Counter


type alias Store =
  { counter_: Int
  }


counter : Focus Store Int
counter =
  Focus.create .counter_ (\f r -> { r | counter_ = f r.counter_ })


view : Cursor Store Store -> Html
view cursor =
  Counter.view <| cursor >=> counter


main : Signal Html
main =
  Cursor.start { counter_ = 0 } view
