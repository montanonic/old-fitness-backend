# Home

See `Design/Homepage.md` as well as `templates/homepage.hamlet` for descriptions
of how the homepage ought to look and behave.

## Separation between Handlers and Models

Currently `getHomeR` and `postHomeR` contain Model code explicitly written
within them. The queries are short, and definitely don't seem to necessitate
moving to a file in the `Model/` directory.

That said, this does raise the question of whether or not we should be stringent
about separating MVC code into respective components/modules. I do think
modularization usually helps readability, so I would be in favor of moving
any and all Model queries into the Model directory.

### To aid readability when modularized:

I think adding a comment to every handler function that relies upon functions
within the `Model/` directory, one which specifies which Models that it relies
upon (akin to `config/models` 'data: Gender, ...' comments), would make the
above proposal a sure-fire improvement.

## Testing

All routes ought to have actual tests, this being no exception. Currently I've
only tested this through `yesod devel`, but I plan to write tests for it in the
near future, and I'm going to let this paragraph remain as a note to myself
until I've completed my task.
