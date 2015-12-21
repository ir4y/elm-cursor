module Counter.Counter (view) where

import Cursor exposing(..)
import Html exposing (Html, text, div, button)
import Html.Events exposing (on)
import Json.Decode as Json



dec_ a =
  a - 1


inc_ a =
  a + 1


view: Cursor a Int -> Html.Html
view cursor =
  div []
        [ button [ on "click" Json.value <| \_ -> updateC cursor dec_] [ text "-" ]
        , div [] [ text << toString <| getC cursor]
        , button [ on "click" Json.value <| \_ -> updateC cursor inc_] [ text "+" ]
        ]
