module Counter.Counter
  ( view, countStyle
  ) where

import Json.Decode as Json

import Html exposing (Html, Attribute, text, div, button)
import Html.Attributes exposing (style)
import Html.Events exposing (on)

import Cursor exposing (Cursor)


view: Cursor a Int -> Html.Html
view cursor =
  let
    btn f t =
      button
        [ on "click" Json.value
            <| \_ -> Cursor.update cursor f
        ]
        [ text t ]

    dec_ a = a - 1

    inc_ a = a + 1
  in
    div []
      [ btn inc_ "+"
      , div [ countStyle ] [ text <| toString <| Cursor.get cursor ]
      , btn dec_ "-"
      ]


countStyle : Attribute
countStyle =
  let
    (=>) = (,)
  in
    style
      [ "font-size" => "20px"
      , "font-family" => "monospace"
      , "display" => "inline-block"
      , "width" => "50px"
      , "text-align" => "center"
      ]
