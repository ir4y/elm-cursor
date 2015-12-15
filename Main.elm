module Main where

import Cursor exposing(..)
import Focus exposing((=>))

import Html exposing (Html, text, p, div)
import Html.Attributes
import Html.Events exposing (on, targetValue)


type alias Store =
  { value: String
  }

valueL : Focus.Focus Store String
valueL = Focus.create .value (\f r -> { r | value = f r.value })

input : Cursor a String-> Html
input cursor = Html.input [ Html.Attributes.value (getC cursor)
                          , on "input" targetValue (setC cursor)
                          ] []

view : Cursor Store Store -> Html.Html
view cursor = let
                 value = (cursor >=> valueL)
              in div[] [ p [] [text (getC value)]
                       , input value
                       ]

main = drawC {value = "foo"} view
