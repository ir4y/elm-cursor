module Main where

import Cursor exposing(..)
import Focus exposing((=>))
import Html exposing (Html, text, p, div, button)
import Html.Attributes as Attributes
import Html.Events exposing (on, targetValue)
import Json.Decode as Json


type alias Store =
  { value: String
  , counter: Int
  }


valueL : Focus.Focus Store String
valueL =
  Focus.create .value (\f r -> { r | value = f r.value })

counterL : Focus.Focus Store Int
counterL =
  Focus.create .counter (\f r -> { r | counter = f r.counter })

view : Cursor Store Store -> Html.Html
view cursor =
  let
     value = cursor >=> valueL
     counter = cursor >=> counterL
  in div [] [ view_input value
            , view_counter counter
            ]

input : Cursor a String -> Html
input cursor =
    Html.input [ Attributes.value <| getC cursor
               , on "input" targetValue <| setC cursor
               ] []

view_input : Cursor Store String -> Html.Html
view_input cursor =
  div [] [ p [] [ text <| getC cursor]
                , input cursor
                ]

dec_ a =
  a - 1


inc_ a =
  a + 1


view_counter : Cursor Store Int -> Html.Html
view_counter cursor =
  div []
      [ button [ on "click" Json.value <| \_ -> updateC cursor dec_] [ text "-" ]
      , div [] [ text << toString <| getC cursor]
      , button [ on "click" Json.value <| \_ -> updateC cursor inc_] [ text "+" ]
      ]


main =
  drawC {value = "foo", counter = 0} view
