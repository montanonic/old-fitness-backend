module Model.Data.Gender where

import Prelude
import Database.Persist.TH

-- NOTE: I intend to use only the Male/Female fields for now. The Specify field
-- is included for sake of completeness. I think deferring gender options to
-- a User's Profile might be the best route, while requiring that users
-- select from Male/Female for biological sex identification at the beginning.
--
-- Given that Sex and Gender are not the same, we may want to rephrase this as
-- Sex, given the biological relevance of such information. That said, if this
-- app will be tying a user to their medical records in some way, we'd already
-- have access to biological sex information, so only Gender would not be
-- redundant.

-- | Pronouns should be a list of three, in the grammatical form of
-- 'he, him, his', 'she, her, hers', 'they, them, theirs'.
type Pronouns = String

-- | Binary gender choice + Specify (a more kindly-worded 'Other' field), which
-- takes two Strings. This allows a user to specify their gender and gender
-- pronouns.
-- Client-side and/or server-side validation should be used for the Specify
-- field.
-- It will probably be best to have a list of common options availible. We
-- wouldn't want users abusing this feature, so limiting choices and preventing
-- customizations would safeguard us (and other users) from such abuses.
data Gender = Male | Female | Specify String Pronouns
  deriving (Show, Read, Eq)
derivePersistField "Gender"
