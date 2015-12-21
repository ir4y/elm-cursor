module Single where

import Cursor exposing(..)
import Counter.Counter as Counter
import Focus exposing((=>))
import Html exposing (Html)
import Json.Decode as Json


type alias Store =
  { counter: Int
  }


counterL : Focus.Focus Store Int
counterL =
  Focus.create .counter (\f r -> { r | counter = f r.counter })


view : Cursor Store Store -> Html.Html
view cursor =
  let
     counter = cursor >=> counterL
  in Counter.view counter


main =
  drawC {counter = 0} view
