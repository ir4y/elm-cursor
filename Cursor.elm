module Cursor where

import Array
import Focus exposing ((=>))
import Maybe

type alias Cursor a b =
  { receiver : Signal.Address a
  , state : a
  , lens : Focus.Focus a b
  }

(>=>) : Cursor a b -> Focus.Focus b c -> Cursor a c
(>=>) c1 f1 = { c1 | lens = (c1.lens => f1) }

idL : Focus.Focus a a
idL = Focus.create identity (\f r -> f r)

atL : Int -> a -> Focus.Focus (Array.Array a) a
atL index default = Focus.create ((Maybe.withDefault  default) << (Array.get index)) (\f r -> (Array.set index (f (Maybe.withDefault  default (Array.get index r))) r))

createC : Signal.Mailbox a -> a -> Cursor a a
createC mailbox state = { receiver = mailbox.address
                        , state = state
                        , lens = idL
                        }

setC : Cursor a b -> b -> Signal.Message
setC c1 v =  Signal.message c1.receiver (Focus.set c1.lens v c1.state)

updateC : Cursor a b -> (b -> b) -> Signal.Message
updateC c1 f = Signal.message c1.receiver (Focus.update c1.lens f c1.state)

getC : Cursor a b -> b
getC c1 = Focus.get c1.lens c1.state

drawC : a -> (Cursor a a -> b) -> Signal.Signal b
drawC state view = let
                       mailbox = Signal.mailbox state
                   in
                       Signal.map ((createC mailbox) >> view)  mailbox.signal
