# User Information

It is worth considering whether we should take advantage of any opportunity to
log information. For example, in the case of defriending, the current model
keeps track of who sent the friend request and who defriended; so if Mike
friends Jill we'll know Mike sent the request, and if, some time after
accepting, Jill defriends Mike, we'll know she was the one who defriended.

However, what if Jill later friends Mike again? We have two choices in the
current model:   

  1. We record Jill as the person who sent the request, and overwrite the data
  that Mike sent the first request.

  2. We keep Mike as the original request sender and lose any knowledge of who
  sent subsequent requests after refriending occurs.

Though we may not care much about such data, if we consider having a large
userbase and medical applications, it may actually be useful for companies like
Kaiser to look at trends in Relationship defriending/refriending.

We should definitely talk to Kim about the extent that we should be keeping
track of data like the example above.

## User

### unverifiedEmail

This field exists in place of a Boolean isVerified field primarily because of
enforcing Uniqueness constraints. In SQL, you can declare a field to be unique,
which will mean that SQL will complain and refuse to insert any identical value
into that column anywhere else in the table. This allows us to avoid having to
check and see if an email already exists when registering a user, relegating
that to the backend.

Now, because of this, if we didn't have an unverifiedEmail field, and a user
created an account but did not yet **verify** it, while another user created an
account with the same email, likewise **not verifying it**, we'd either have to
refuse to create the second user's account, or to delete the first. The
important fact here is that ***no authentication has yet happened for either
user***. Deleting a user account with an unverified email when someone else
verifies that same email in another account totally makes sense. However, we
should not be deleting any accounts on this basis until one user has ***verified
that email***; until then, all accounts should be preserved.

#### Why would this ever matter?

Security-wise, this is not important at all. However, it could be a potential
source of confusion/annoyance if people ever discovered this behavior, as they
could continually prevent a friend from authenticating by registering with their
email, no authentication required. Though this is not a very realistic scenario,
the fact is, it could be done, and it is very trivial to prevent this from
happening, so I will.

## Friendships

### DEPRECATED

This field:

> isConfirmed Bool -- When a user sends a friend request we create a row in
  -- the table, but make the isConfirmed field 'false'. Once the other user
  -- confirms the request, we update this field to 'true', which indicates
  -- that the users are now friends.

became redundant once replaced by `becameFriends UTCTime Maybe`, which, because
it is nullable, serves as a boolean, while the timestamp also lets us know
when the friendship was formed.

The `updatedAt` field was enough to give us this information in the original
model, but now that we've added the option to defriend, we need a separate
field to reliably let us know when two users first became friends.
