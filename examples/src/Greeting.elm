import Cursor exposing(..)
import Focus exposing((=>))
import Html exposing (Html, text, p, div)
import Html.Attributes as Attributes
import Html.Events exposing (on, targetValue)
import Json.Decode as Json


type alias Store =
  { value: String
  }


valueL : Focus.Focus Store String
valueL =
  Focus.create .value (\f r -> { r | value = f r.value })


view : Cursor Store Store -> Html.Html
view cursor =
  let
     value = cursor >=> valueL
  in div [] [ view_input value ]

input : Cursor a String -> Html
input cursor =
    Html.input [ Attributes.value <| getC cursor
               , on "input" targetValue <| setC cursor
               ] []

view_input : Cursor Store String -> Html.Html
view_input cursor =
  div [] [ p [] [ text "Hello: "
                , text <| getC cursor
                , text " !"
                ]
         , p [] [ input cursor
                ]
         ]

main =
  drawC {value = ""} view
