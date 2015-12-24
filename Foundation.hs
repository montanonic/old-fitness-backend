module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Text.Hamlet          (hamletFile)
import Text.Jasmine         (minifym)
import Yesod.Auth.BrowserId (authBrowserId)
import Yesod.Auth.Dummy     (authDummy)
import Yesod.Default.Util   (addStaticContentExternal)
import Yesod.Core.Types     (Logger)
import qualified Yesod.Core.Unsafe as Unsafe
import qualified Data.CaseInsensitive as CI
import qualified Data.Text.Encoding as TE

-- | The foundation datatype for your application. This can be a good place to
-- keep settings and values requiring initialization before your application
-- starts running, such as database connections. Every handler will have
-- access to the data present here.
data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static -- ^ Settings for static file serving.
    , appConnPool    :: ConnectionPool -- ^ Database connection pool.
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

-- This is where we define all of the routes in our application. For a full
-- explanation of the syntax, please see:
-- http://www.yesodweb.com/book/routing-and-handlers
--
-- Note that this is really half the story; in Application.hs, mkYesodDispatch
-- generates the rest of the code. Please see the following documentation
-- for an explanation for this split:
-- http://www.yesodweb.com/book/scaffolding-and-the-site-template#scaffolding-and-the-site-template_foundation_and_application_modules
--
-- This function also generates the following type synonyms:
-- type Handler = HandlerT App IO
-- type Widget = WidgetT App IO ()
mkYesodData "App" $(parseRoutesFile "config/routes")

-- | A convenient synonym for creating forms.
type Form x = Html -> MForm (HandlerT App IO) (FormResult x, Widget)

-- Please see the documentation for the Yesod typeclass. There are a number
-- of settings which can be configured by overriding methods here.
instance Yesod App where
    -- Controls the base of generated URLs. For more information on modifying,
    -- see: https://github.com/yesodweb/yesod/wiki/Overriding-approot
    approot = ApprootRequest $ \app req ->
        case appRoot $ appSettings app of
            Nothing -> getApprootText guessApproot app req
            Just root -> root

    -- Store session data on the client in encrypted cookies; see below this
    -- instance for the sessionTimeout variable and brief notes on cookies.
    makeSessionBackend _ = sslOnlySessions $
        Just <$> defaultClientSessionBackend sessionTimeout -- 120 minutes
            "config/client_session_key.aes"

    -- The following comments are *not* currently implemented; I've removed
    -- CSRF protection due to conflicts for now. This should be resolved later,
    -- but will simply be ommitted for the time being.
    -- Yesod Middleware allows you to run code before and after each handler function.
    -- The defaultYesodMiddleware adds the response header "Vary: Accept, Accept-Language" and performs authorization checks.
    -- The defaultCsrfMiddleware:
    --   a) Sets a cookie with a CSRF token in it.
    --   b) Validates that incoming write requests include that token in either a header or POST parameter.
    -- For details, see the CSRF documentation in the Yesod.Core.Handler module of the yesod-core package.
    yesodMiddleware = (sslOnlyMiddleware sessionTimeout)
        {- . defaultCsrfMiddleware -} . defaultYesodMiddleware

    defaultLayout widget = do
        master <- getYesod
        mmsg <- getMessage -- In production we're either going to want to get
        -- rid of messages, or to create a special class for displaying
        -- messages that allows them to be closed, using CSS and/or JS. The
        -- reason being that messages are embedded within the HTML statically
        -- by default, and require a refresh to get rid of. We don't want our
        -- clients refreshing.

        -- We break up the default layout into two components:
        -- default-layout is the contents of the body tag, and
        -- default-layout-wrapper is the entire page. Since the final
        -- value passed to hamletToRepHtml cannot be a widget, this allows
        -- you to use normal widget features in default-layout.

        pc <- widgetToPageContent $ do
            addStylesheet $ StaticR css_foundation_css
            $(widgetFile "default-layout")
        withUrlRenderer $(hamletFile "templates/default-layout-wrapper.hamlet")

    -- The page to be redirected to when authentication is required.
    authRoute _ = Just $ AuthR LoginR

    -- Routes not requiring authentication.
    isAuthorized (AuthR _) _ = return Authorized
    isAuthorized FaviconR _ = return Authorized
    isAuthorized RobotsR _ = return Authorized

    -- require that a user is authenticated and logged in before they can
    -- submit a profile form. A user does not have to be authorized for read
    -- requests at this route.
    isAuthorized HomeR True = isUser
    isAuthorized HomeR False = return Authorized

    -- current default for accessing all other routes is that a user has a
    -- Profile entity.
    isAuthorized _ _ = hasProfile

    -- This function creates static content files in the static folder
    -- and names them based on a hash of their content. This allows
    -- expiration dates to be set far in the future without worry of
    -- users receiving stale content.
    addStaticContent ext mime content = do
        master <- getYesod
        let staticDir = appStaticDir $ appSettings master
        addStaticContentExternal
            minifym
            genFileName
            staticDir
            (StaticR . flip StaticRoute [])
            ext
            mime
            content
      where
        -- Generate a unique filename based on the content itself
        genFileName lbs = "autogen-" ++ base64md5 lbs

    -- What messages should be logged. The following includes all messages when
    -- in development, and warnings and errors in production.
    shouldLog app _source level =
        appShouldLogAll (appSettings app)
            || level == LevelWarn
            || level == LevelError

    makeLogger = return . appLogger

-- | This is self-describing. Session timeouts are currently implemented
-- client-side, using cookies with authentication data and an expiration set
-- to the value below, in minutes.
--
-- When we integreate with the mobile app, we'll either want to implement
-- timeouts, or make sure that the session logic will not run when handling
-- requests from the mobile app. This may require Middleware that uses request
-- header meta-information to determine whether or not to use cookies.
sessionTimeout :: Int
sessionTimeout = 120 -- normally 120 but leaving it at less for testing
    -- purposes

-- | Yell at me if this doesn't have a helpful comment.
isUser :: Handler AuthResult
isUser = do
    muid <- maybeAuthId
    return $ case (isJust muid) of
        True -> Authorized
        False -> AuthenticationRequired

-- | Yell at me if this doesn't have a helpful comment.
hasProfile :: Handler AuthResult
hasProfile = do
    -- maybe get a user's authenticated identity
    muid <- maybeAuthId
    -- maybe find a user's Profile entity connected to their UserId
    mprofile <- maybe (pure Nothing)
        (runDB . getBy . UniqueProfile) muid
    return $ case (muid, mprofile) of
        -- user is logged in and has a profile
        (_, Just _) -> Authorized
        -- user is not logged in or does not have an account
        (Nothing, _) -> AuthenticationRequired
        -- user is logged in but does not have a Profile; this shouldn't
        -- happen, because a user's client shouldn't let them access these
        -- parts of the app unless they already have created a profile.
        (_, Nothing) -> Unauthorized "You need to have a Profile to access\
            \ the application."


-- How to run database actions.
instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master
instance YesodPersistRunner App where
    getDBRunner = defaultGetDBRunner appConnPool

instance YesodAuth App where
    type AuthId App = UserId

    -- Where to send a user after successful login
    loginDest _ = HomeR
    -- Where to send a user after logout
    logoutDest _ = HomeR
    -- Override the above two destinations when a Referer: header is present
    redirectToReferer _ = True

    -- Alter how the login route works. In this case, we make it so that if a
    -- user is already logged in, visiting the login page redirects them to
    -- the homepage.
    loginHandler = do
        ma <- lift maybeAuthId
        when (isJust ma) $
            lift $ redirect HomeR
        defaultLoginHandler


    -- Authentication plugins authenticate a user's credentials, but do not
    -- verify that they are members of the website. The authenticate function
    -- handles that second step.

    -- Under our current scheme, authentication will either login users if
    -- their credentials already exist in the database, or create new users
    -- using their current credentials. This does not give a User access to the
    -- app; a User must both be authenticated *and* have a Profile for that.

    -- NOTE: This function is called when using an authentication Plugin.
    -- Currently authentication is only supported through BrowserId.
    authenticate creds = runDB $ do
        let email = credsIdent creds -- from BrowserId
        now <- liftIO getCurrentTime
        -- `insertBy` will go Left if that UserEmail is already in use,
        -- returning the duplicate entity. Otherwise it inserts and returns a
        -- new key, creating a new user.
        euid <- insertBy $ User email now Nothing
        return $ case euid of
            -- User is already in database:
            Left (Entity uid _) -> Authenticated uid
            -- User was not in database, so they were added:
            -- (perhaps we should also display a welcome message at this
            -- point?)
            Right newUid -> Authenticated newUid

{- Old authentication method:
    authenticate creds = runDB $ do
        x <- getBy $ UniqueUser $ credsIdent creds
        return $ case x of
            Just (Entity uid _) -> Authenticated uid
            Nothing -> UserError InvalidLogin
            -}

    -- You can add other plugins like BrowserID, email or OAuth here
    authPlugins master = addAuthBackDoor master $ [authBrowserId def]

    authHttpManager = getHttpManager

-- see https://robots.thoughtbot.com/on-auth-and-tests-in-yesod
-- conditionally adds AuthDummy for purposes of testing, only when the
-- application is in Development (this would be a critical security breach
-- otherwise).
addAuthBackDoor :: App -> [AuthPlugin App] -> [AuthPlugin App]
addAuthBackDoor app =
    if appAllowDummyAuth (appSettings app) then (authDummy :) else id

instance YesodAuthPersist App

-- This instance is required to use forms. You can modify renderMessage to
-- achieve customized and internationalized form validation messages.
instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

-- Useful when writing code that is re-usable outside of the Handler context.
-- An example is background jobs that send email.
-- This can also be useful for writing code that works across multiple Yesod applications.
instance HasHttpManager App where
    getHttpManager = appHttpManager

unsafeHandler :: App -> Handler a -> IO a
unsafeHandler = Unsafe.fakeHandlerGetLogger appLogger

-- Note: Some functionality previously present in the scaffolding has been
-- moved to documentation in the Wiki. Following are some hopefully helpful
-- links:
--
-- https://github.com/yesodweb/yesod/wiki/Sending-email
-- https://github.com/yesodweb/yesod/wiki/Serve-static-files-from-a-separate-domain
-- https://github.com/yesodweb/yesod/wiki/i18n-messages-in-the-scaffolding
