# The Homepage

## Design Goals

For those who *are not logged in*, the homepage should offer three paths:

  1. A sign-up area
  2. A log-in area
  3. An overview of the App with links to more information.

Users who *are signed in* will be taken directly to the App, which will exist
almost exclusively in PureScript code. Yesod itself will handle the basic logic
for displaying the above 3 paths only to users who are not logged in. To do
this, we'll use an `$if`, `$then`, `$else` sequence in `homepage.hamlet`.

## Authentication

Our login/sign-ups will initially be Authenticated with Firefox's *Persona*, AKA
*BrowserId*. The mobile app will use a different means of authentication.
Expanding  what services we offer for authentication is currently not a
priority.
