module Greeting where

import Html exposing (Html, text, p, div)
import Html.Attributes as Attributes
import Html.Events exposing (on, targetValue)

import Focus exposing (Focus)

import Cursor exposing (Cursor, (>=>))


type alias Store =
  { value_: String
  }


value : Focus Store String
value =
  Focus.create .value_ (\f r -> { r | value_ = f r.value_ })


view : Cursor Store Store -> Html
view cursor =
  viewInput <| cursor >=> value


input : Cursor a String -> Html
input cursor =
  Html.input
    [ Attributes.value <| Cursor.get cursor
    , on "input" targetValue <| Cursor.set cursor
    ] []


viewInput : Cursor Store String -> Html
viewInput cursor =
  div []
    [ p []
        [ text "Hello: "
        , text <| Cursor.get cursor
        , text " !"
        ]
    , p []
        [ input cursor
        ]
    ]


main : Signal Html
main =
  Cursor.start { value_ = "" } view
