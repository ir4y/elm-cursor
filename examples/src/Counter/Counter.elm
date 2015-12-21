module Counter.Counter (view) where

import Cursor exposing(..)
import Html exposing (Html, text, div, button)
import Html.Attributes exposing (style)
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
        , div [ countStyle ] [ text << toString <| getC cursor]
        , button [ on "click" Json.value <| \_ -> updateC cursor inc_] [ text "+" ]
        ]


countStyle : Html.Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
