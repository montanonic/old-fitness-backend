module Model.Data.ProfileUpdate where

import Prelude
import Database.Persist.TH

-- | These are updates a user can perform on their profile information;
-- currently pending Model/CRUD implementations of the Profile and ProfileLog
-- entities. This datatype will be used to log which field the user updated and
-- when.
data ProfileUpdate
    = UpdateFirstName
    | UpdateLastName
    | UpdateEmail
    | UpdateDateOfBirth
    | UpdateGender
    deriving (Show, Read, Eq)
derivePersistField "ProfileUpdate"
