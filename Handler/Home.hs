module Handler.Home where

import Import
import Data.Time.Calendar()

-- | This is for prototyping, and will require adding server-side and/or
-- client-side validation before it should be allowed for production.
--
-- NOTE: This is a PARTIAL FUNCTION, and WILL cause app crashes in the event of
-- failure. THIS SHOULD NOT BE INCLUDED IN A REAL WEBSITE AS IS.
--
-- An ideal solution to the partial function problem would be to make this
-- and runFormPost return Maybe FormResults. However, my many attempts at that
-- failed, which is why I'm resorting to an unsafe function right now.
profileForm :: Maybe UserId -> Form Profile
profileForm muid = renderDivs $ Profile
    <$> pure uid -- user
    <*> areq textField "First Name" Nothing
    <*> areq textField "Last Name" Nothing
    <*> areq dayField "Birthday" Nothing
    <*> areq (radioField optionsEnum) "Gender" Nothing
    <*> lift (liftIO getCurrentTime) -- createdAt
    <*> pure Nothing -- updatedAt
  where
    Just uid = muid -- circumvents pattern-match error.

getHomeR :: Handler Html
getHomeR = do
    -- maybe get a user's authenticated identity
    muid <- maybeAuthId
    -- maybe find a user's Profile entity connected to their UserId
    mprofile <- maybe (pure Nothing)
        (runDB . getBy . UniqueProfile) muid

    (formWidget, enctype) <- generateFormPost $ profileForm muid
    defaultLayout $(widgetFile "homepage")

postHomeR :: Handler Html
postHomeR = do
    muid <- maybeAuthId
    ((res, _), _) <- runFormPost $ profileForm muid
    case res of
        FormMissing -> setMessage "We didn't get any information. Please try\
            \ again."
        FormFailure fs -> setMessage [shamlet|#{show fs}|]
        FormSuccess profile -> runDB $ insert_ profile
    redirect HomeR
