module Model.Data.UserUpdate where

import Prelude
import Database.Persist.TH

-- | These are updates to a user's own information that are pending
-- Model/CRUD implementation for use with the UserLog entity. These will be
-- used to log which field the user updated and when.
data UserUpdate
    = UpdateFirstName
    | UpdateLastName
    | UpdateEmail
    | UpdateDateOfBirth
    | UpdateGender
    deriving (Show, Read, Eq)
derivePersistField "UserUpdate"
