module Main where

import Cursor exposing(..)
import Focus exposing((=>))

import Html exposing (Html, text, p)


type alias Store =
  { value: String
  }

valueL : Focus.Focus Store String
valueL = Focus.create .value (\f r -> { r | value = f r.value })

view : Cursor Store Store -> Html.Html
view cursor = p [] [text (getC (cursor >=> valueL))]

main = drawC {value = "foo"} view
