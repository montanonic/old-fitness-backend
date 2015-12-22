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

## A note about profileForm

That function is an unsafe one, unsafe in the sense that Yesod will literally
crash if you give it `Nothing` instead of `Just _`. I'm able to get away with
it because that function should never actually be used unless we already have
the value that we need (a `Just profile`), but I'm still *very* uncomfortable
with having a crashable function in this repository.

Having searched for potential solutions, and tried my hand at many, I was
neither able to succeed nor to find a compelling alternative. I may want to
ask the mailing group directly, but I think the longer-term solution will just
be migrating the form construction over to the front-end in PureScript, where
we can process requests through AJAX.

That said, with this one particular route, I do think it would actually be
viable to keep the form-generation server-side. I'll have to figure out how
to properly return a `Maybe FormResults` to do this.

This resides in the category of concerns that are important, but not important
enough to focus on until we're nearing production, or we notice bugs arising
with it.

## Testing

All routes ought to have actual tests, this being no exception. Currently I've
only tested this through `yesod devel`, but I plan to write tests for it in the
near future, and I'm going to let this paragraph remain as a note to myself
until I've completed my task.
