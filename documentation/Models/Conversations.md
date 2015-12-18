# Conversations

### A many-to-many relationship

A conversation requires that we have two or more users. Because SQL requires a
fixed number of fields in a table, the 'or more users' part will require
creating an additional table. Each conversation is a many-to-one relationship:
many users to one conversation. The relationship between a user and a
conversation is one-to-many: one user to many conversations.

Hence, we can assume that each user will be participating in many different
conversations, all containing varying amounts of users. This, as mentioned, will
mandate the creation of an intermediary table, as the totality of this
relationship is many-to-many.

### Fitting the model to our desired functionality

Users should be able to opt-out of conversations at any point. This should
*not* delete the messages associated with a conversation (as that would
interfere with the other user), but it *should* remove that conversation from
that user's conversation list.

This becomes an even more pressing feature for group conversations, where there
is no guarantee that a message will actually be addressed to you. We'll address
how this is implemented shortly.

Though most conversations will happen between two and only two users, aside from
potential efficiencies, there is no real reason why there ought to be a separate
encoding in the data model just for this case. Instead, we ought to have data
encoded the following way:

## ConversationUsers

The relationship between conversations and users is many-to-many: each user
may be participating in many different conversations, and each conversation
involves many users.

The ConversationUsers table is an intermediary table utilizes two key pieces of
information: a UserId, and a ConversationId. These values will be used to link
each user to the conversations that they are a part of. In OOP terms, User
objects will point to ConversationUser objects for each and every separate
conversation that they are a part of. The ConversationUser objects will in turn
point to a Conversation object that contains the actual messages.

This intermediate step preserves the (P)SQL requirement that there be a fixed
number of fields in each table, while allowing a variable number of users to
participate in a conversation. This is a standard SQL technique for many-to-many
relationships (many users to many conversations).

The ConversationUser object will have an additional field to address the issue
of a user wanting to opt-out of a conversation. The `isActive` field is a
Boolean that determines if a user will see that particular conversation in their
messages tab, or wherever else it would have a visual representation (think
Facebook, and their archive option for messages). A user never deletes a
conversation, they simply de-activate it.

## ConversationMessages

The relationship between conversations and messages is one-to-many: messages
exclusively refer to one conversation; message-content may be identical, though
each will retain a unique ID.


### Thinking of privacy

Given the sensitive nature of some conversations, we would very likely want to
have an actual delete function for conversations. However, we'd need to get the
permission of each participant in order to do this. In some cases (a large group
conversation) this may be very impractical, and we may want to develop a special
type of conversation that will automatically delete older records after a
certain period of time. This may be helpful for people who are in groups that
resemble therapy sessions. Currently, such features are ***not implemented***.

This special type of Conversation could be expanded further to support encrypted
messages and other privacy-protecting options. This will be vital for
Doctor-Patient messaging.
