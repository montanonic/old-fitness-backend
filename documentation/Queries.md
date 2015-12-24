# Queries

## Components

All of these should have Notifications, but that is a to-do.

Multimedia should probably exist on a different server, and should both have
individual size caps (for compression) **and** temporal caps that limit how
much a user can post at one time or in a day/week/month et cetera; this is to be
used primarily to prevent abuse, so the cap should be reasonably high.

  * Wall: access to Post (news feed) information, and User information.
  * News feed: access to Post information, and comment+like information.
  * Messaging: access to Conversations + ConversationMessages

## Notification object ; Notification system.

When a post appears on someone's wall they should get a notification. Run a
function after it arrives in the database. This is concurrency.

## Wall vs. News Feed

The Post entity will be used for both the News feed and user's Walls. Walls
contain all the posts made by a user, and all posts that have that user tagged
in them.

### Posts should have a tagging feature; a one-to-many relationship.

Posts and Conversation should have approximately the same implementation. One
fundamental difference would be that the Conversation entity only contains
references to foreign keys, while the Post entity contains references to keys
in addition to a Post Message, written by the poster of the message.

### If a user posts to another user's wall
That post should only appear on the sender's and receiver's walls, *not* the
news feed.

## Friend requests

A sender of a friend request can delete that request before the other user
ACCEPTS or DECLINES it, at which point that request is no longer displayed. The
user will be able to send another request after revoking. NOTE: If we have a
notification system, sending another request can lead to notification spam if
not handled properly so be sure to ensure that we have a system for preventing
this from occurring.

##
