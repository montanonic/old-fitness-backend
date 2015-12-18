module Model.Data.FriendshipAction where

import Prelude
import Database.Persist.TH

-- | Currently, a user can send a friend request, accept a request, or defriend,
-- which does not require a request or notification.
data FriendshipAction = SendRequest | AcceptRequest | Defriend
  deriving (Show, Read, Eq)
derivePersistField "FriendshipAction"
