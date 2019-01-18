# Concept of Operations {#chapter-concept-of-operations}

## Project Files

All project files are in the `<project>` directory.
This directory could be created anywhere in the filesystem owned by the current logged in user.
The following hierarchy shows the project directory structure:

~~~
<project>
    |
    +-- barangays/
    +-- css/                [stylesheets]
    +-- _data/              [JSON files]
    +-- districts/
    +-- _doc/               [documentation files]
    +-- images/             [web page images]
    +-- _includes/          [include page files]
    +-- javascripts/
    +-- _layouts/           [page layouts]
    +-- municipalities/
    +-- _posts/             [not used]
    +-- _sass/              [SASS stylesheets]
    +-- _scripts/           [script files]
    +-- _site/              [output web pages]
    +-- _temp/
    +-- vendor/             [Jekyll-specific files]
    +-- 404.html
    +-- about.md
    +-- _config.yml         [Jekyll configuration file]
    +-- Gemfile             [Ruby dependencies]
    +-- Gemfile.lock
    +-- index.md
~~~

The project files are kept in a Git version control repository.
The Git repository is hosted on GitHub ([https://github.com/](https://github.com/)).
