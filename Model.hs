{-# LANGUAGE FlexibleInstances #-}

module Model where

import ClassyPrelude.Yesod
import Database.Persist.Quasi

import Model.Data.FriendshipAction
import Model.Data.Gender
import Model.Data.ProfileUpdate

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

-- | All json instances for models are defined here. This is to prevent orphan
-- instances from occuring. All models with JSON instances defined here will
-- have a comment indicating as much in their persistent entitity declaration.

-- #Profile
instance ToJSON (Entity Profile) where
    toJSON (Entity pid p) = object
        [ "type" .= String "Profile"
        , "id" .= (String $ toPathPiece pid)
        , "user_id" .= profileUser p
        , "firstName" .= profileFirstName p
        , "lastName" .= profileLastName p
        , "dateOfBirth" .= (toJSON . toGregorian $ profileDateOfBirth p)
        , "gender" .= profileGender p
        , "createdAt" .= profileCreatedAt p
        , "updatedAt" .= profileUpdatedAt p
        ]
instance FromJSON Profile where
    parseJSON (Object o) = Profile
        <$> o .: "user_id"
        <*> o .: "firstName"
        <*> o .: "lastName"
        <*> o .: "dateOfBirth"
        <*> o .: "gender"
        <*> o .: "createdAt"
        <*> o .: "updatedAt"
    parseJSON _ = mzero
