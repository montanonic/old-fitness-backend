module Handler.Profile where

import Import

import Model.Profile (fetchProfile404)

-- | Responds to READ-only queries for Profile data.  Currently this returns the
-- whole user's profile. I can cut this down to more selective queries but
-- honestly that seems unnecessary for now.
getUserProfileR :: UserId -> Handler Value
getUserProfileR uid = do
    profile <- fetchProfile404 uid
    return $ object ["data" .= profile]
    --returnJson profile

-- | Responds to UPDATE queries for Profile data. CREATION is handled on the
-- homepage.
putUserProfileR :: UserId -> Handler ()
putUserProfileR uid = error "fuck you"

        {-do
    -- get a list of updates from JSON
    upds <- requireJsonBody :: Handler [Update Profile] -}


{-
putUserProfileR :: UserId -> Handler Value
putUserProfileR _ = do
    uid <- requireAuthId
    profile <- requireJsonBody :: Handler Profile

    runDB $ do
        ent <- getBy404 (UniqueProfileUser uid)
        replace (entityKey ent) profile

    sendResponseStatus status200 ("REPLACED" :: Text)
-}
