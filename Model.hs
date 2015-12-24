{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Model where

import ClassyPrelude.Yesod
import Database.Persist.Quasi

import Model.Data.FriendshipAction
import Model.Data.Gender
import Model.Data.ProfileUpdate

-- Not all datatypes come with pre-defined from/toJSON instances. Custom data
-- imported from Model.Data will have `deriveJSON` in their own files, when
-- necessary. Data that is not custom but lacks instances will be added below
-- this comment.

-- | The standard way of displaying Day is as a modified jul
instance ToJSON Day where
    toJSON day = toJSON $ toGregorian day

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")
