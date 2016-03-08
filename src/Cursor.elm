module Cursor
  ( Cursor, (>=>)
  , cursor, start
  , get, set, update
  ) where

{-| Alternative way to build elm app,
    this module contains all low level primitives
    to build elm app with high level cursor abstraction.

# Cursor
@docs Cursor

# Composition operator
@docs (>=>)

# Cursor helpers
@docs cursor, start

# Cursor modifiers
@docs get, set, update

-}

import Array
import Focus exposing (Focus, (=>))
import Maybe
import Signal exposing (Signal, Message, Mailbox)


{-| Base type, the triplet of state, signal and lens
 -}
type alias Cursor a b =
  { receiver : Signal.Address a
  , state : a
  , lens : Focus.Focus a b
  }


{-| Composition operator, allow to go deeper in state via lens
 -}
(>=>) : Cursor a b -> Focus b c -> Cursor a c
(>=>) cursor focus =
  { cursor | lens = (cursor.lens => focus) }


id : Focus a a
id =
  Focus.create identity (\f r -> f r)


{-| Helper to create a Cursor form signal mail box and initial state data
-}
cursor : Mailbox a -> a -> Cursor a a
cursor mailbox state =
  { receiver = mailbox.address
  , state = state
  , lens = id
  }


{-| Get cursor value
 -}
get : Cursor a b -> b
get c =
  Focus.get c.lens c.state


{-| Set cursor value
 -}
set : Cursor a b -> b -> Message
set c v =
  Signal.message c.receiver (Focus.set c.lens v c.state)


{-| Update cursor value via f
 -}
update : Cursor a b -> (b -> b) -> Message
update c f =
  Signal.message c.receiver (Focus.update c.lens f c.state)


{-| Create render loop for cursor
-}
start : a -> (Cursor a a -> b) -> Signal b
start state view =
  let
    mailbox = Signal.mailbox state
    c = cursor mailbox
  in
    Signal.map (c >> view) mailbox.signal
