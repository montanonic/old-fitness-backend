## How to understand what's going on:

This repository contains all the scaffolding from Yesod, so it will look
intimidating without familiarity with the framework. Thankfully, the bulk of
the most accessible information is located in just two folders and one file:

  1. `config/models` is the file which contains all of the database models. It
  will be split into more granular and organized files should the models grow
  much more, but for now everything is consolidated into this file (which is
  standard practice in Yesod).

  2. `Model/Data/` contains the Haskell files for custom datatypes used in the
  `models` file.

  3. `documentation/` is the directory containing the documentation for the
  entire repository. This can help bridge you into other parts of the project.
  Documentation is very important to me, and though all of this is a major work
  in progress, please let me know if I need to better clarify something, if not
  provide documentation for it in the first place. Also feel free to open a pull
  request with edits to the documentation.

Those should give you access to the highest-level information about the website.

The following guide offers a nice overview of core ideas in Relational
Database design, and will help immensely with understanding `config/models`:
http://en.tekstenuitleg.net/articles/software/database-design-tutorial/intro.html
