# Authentication

Yesod's documentation for `maybeAuthId` states:

>  This can be overridden to allow authentication via other means, such as
checking for a special token in a request header. This is especially useful for
creating an API to be accessed via some means other than a browser.

So we should definitely remember that this function should be one of the ones
that needs reimplemented when adding support for the mobile app.
