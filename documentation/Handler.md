# Handler

In Yesod, Handlers are what we run Database actions in, and how we send and
collect data to/from the web. They quite literally handle HTTP requests, and
in our case we will exclusively be using RESTful principles in how we handle
requests.

## The brief on being RESTful

RESTful guidelines for handling HTTP requests basically just boil down to making
it so that you don't need any State information to give web clients the data
they need, only query parameters or database keys. Furthermore, our GET requests
*must* only lead to Read actions, creation and updating (Write actions) will be
handled by POST requests, and deletion will of course be relegated to DELETE
requests.

There is of course more to say and think about here, but in short, follow those
brief guidelines above and you'll be RESTful.
