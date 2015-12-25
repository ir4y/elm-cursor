module Tests where

import ElmTest exposing (..)

import Signal
import Cursor exposing((>=>))
import Focus


all : Test
all =
    suite "A Cursor Test Suite"
        (let
            data = {foo = "bar"}
            fooL = Focus.create .foo (\f r -> { r | foo = f r.foo })
            mailbox = Signal.mailbox data
            cursor = Cursor.createC mailbox data
            cursorFoo = cursor >=> fooL
         in
            [ test "Cursor read"
                (assertEqual (Cursor.getC cursor) data)
            , test "Cursor composition read"
                (assertEqual (Cursor.getC cursorFoo) "bar")
            ])
