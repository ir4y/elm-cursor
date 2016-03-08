module Minimal where

import Graphics.Element exposing (show)

import Cursor

main =
  Cursor.start model view

model =
  "Hello World!"

view =
  show << Cursor.get
