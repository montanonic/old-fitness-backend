module Model.Profile where

import Import

fetchProfile :: UserId -> Handler (Maybe (Entity Profile))
fetchProfile uid = runDB $ getBy $ UniqueProfileUser uid

-- | Fetch profile, but return a 404 error instead of null.
fetchProfile404 :: UserId -> Handler (Entity Profile)
fetchProfile404 uid = runDB $ getBy404 $ UniqueProfileUser uid

-- | Fetch a profile with a userId that may not exist.
maybeFetchProfile :: Maybe UserId -> Handler (Maybe (Entity Profile))
maybeFetchProfile muid = maybe (pure Nothing) fetchProfile muid

-- | Updates a single field in the Profile Object.
updateProfile :: ProfileId -> [Update Profile] -> Handler ()
updateProfile pid fields = runDB $ update pid fields

-- | Like updateProfile, but takes the entire entity instead.
updateProfile' :: Entity Profile
updateProfile' = error "updateProfile' not implemented"

-- | This is not a very safe method
replaceProfile :: Entity Profile -> Entity Profile
replaceProfile = error "replaceProfile not implemented"

--updateProfile profile = update (entityKey profile)
