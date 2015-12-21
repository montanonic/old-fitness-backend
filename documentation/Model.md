# Models in Yesod

In `config/models` you'll find the implementation for the SQL tables, rows, and
values for the Fitness App datatypes. To better understand the meaning of that
syntax, consult the
[Persistent Entity Syntax](https://github.com/yesodweb/persistent/wiki/Persistent-entity-syntax)
guide.

Please note that Yesod automatically generates Primary Keys for *all* tables
in the models.hs file. Consult that file for a bit more elaboration on this.

Fitness App uses PostgreSQL for its backend. But since Yesod uses a
database-agnostic backend<-->server library (Persistent), it's not necessary to
understand SQL in particular to understand how the models are declared. However,
it will be very helpful to have some familiarity with databases.

For more information on how Persistent works, consult
http://www.yesodweb.com/book/persistent. Basic knowledge of Haskell and
databases are prerequisites.

## Logging in Models

Starting with `Friendship`, I've decided to implement some basic logging
functionality for select tables. The idea is to preserve all information that
would otherwise be overwritten when Updating a field. To avoid data redundancy,
entries in an associated log table (like `FriendshipLog`) will be created
*only what that information is about to be overwritten*. This means that many
`Friendship`s won't even have an entry in `FriendshipLog`, and requires that
we join both tables to get a full history.

## Model/Data

Haskell Sum Types to be used as Persistent Values are stored here. This helps to
lay the foundation of our database, but the actual work is done in the CRUD
folder.

Be ***sure*** that all modules in this directory are made 'exposed-modules' in
`fitness-app.cabal`.

## Model/CRUD

Database actions that CREATE records in entities, READ (query) data, UPDATE
one, some, or all fields of a record, and occasionally DELETE records.

These actions will be called within their respective Handlers, and will
constitute the bulk of the work done by Yesod on this particular App.

The standard output for these operations will be JSON Values (done by using the
Aeson package and Yesod's integration with it).
