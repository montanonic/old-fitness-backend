## How to understand what's going on:

This repository contains all the scaffolding from Yesod, so it will look
intimidating without familiarity with the framework. Thankfully, for now, all
of the relevant information is located in just two folders and one file:

  1. `config/models` is the file which contains all of the database models. It
  will be split into more granular and organized files should the models grow
  much more, but for now everything is consolidated into this file (which is
  standard practice in Yesod).

  2. `Model/Data/` contains the Haskell files for custom datatypes used in the
  `models` file.

  3. `documentation/` is the directory containing the documentation for the
  entire repository. For now, this documentation is only on the Models, given
  that that is all that's being worked on. Hopefully, the code-comments in the
  `models` file in addition to the longer explanations in this file will be
  helpful. Documentation is very important to me, and though all of this is a
  major work in progress, please let me know if I need to better clarify
  something, if not provide documentation for it in the first place. Also feel
  free to edit the documentation.

Please read the following for a nice overview of core ideas in Relational
Database design:
http://en.tekstenuitleg.net/articles/software/database-design-tutorial/intro.html
