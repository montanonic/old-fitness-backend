# To be deleted after implementation; this is a Note.

Given that we lose typesafe routes when sending requests from things outside
of Yesod, like PureScript (which currently lacks integration) and the mobile
app, how can we make sure that they use the correct routes?

My answer is to create a key-value map between the route resource, so HomeR,
and the link rendered by @{HomeR}. Because I use the @{} syntax, this will
always have the latest routes. I can render those urls within Julius and
have a route with a simple JSON key-value mapping with all the route resource
names and their actual URLs. This way, anything using the app can just store
that JSON somewhere and then consult it when making queries.

The precise implementation details are currently beyond my understanding, but
I think this may be a good idea.
