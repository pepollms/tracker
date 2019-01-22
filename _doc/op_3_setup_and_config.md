# Software Setup and Configuration {#chapter-software-setup-and-configuration}

This section describes the setup and configuration procedures of the system.

The target software system shall use a GNU/Linux platform.
All supporting software tools shall use open source software only.

The system uses the following:

* GitHub - web site for hosting the static web pages for testing and possibly for production.
* PostgreSQL - relational database to hold all system data.
* Jekyll - static site generator for creating HTML pages.



## Project Files {#section-project-files}

All project files are in the `<project>` directory.
This directory could be created anywhere in the filesystem owned by the current logged in user.
The following hierarchy shows the project directory structure:

~~~
<project>
    |
    +-- barangays/
    +-- css/                [stylesheets]
    +-- _data/              [JSON files]
        |
        +-- to_import       [import directory]
            |
            +-- region
            +-- province
            +-- district
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
        |
        +-- sql             [SQL script files]
            |
            +-- base        [database table SQL script files]
            +-- dm          [data management SQL script files]
            +-- import      [import SQL script files]
            +-- json        [JSON file SQL script files]
            +-- mock
            +-- utility     [database utility functions SQL script files]
            +-- view        [database view SQL script files]
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




## Project Repository

The system uses the Git version control[^git_version_control].
The system uses a GitHub account to host the project repository and to host the static web pages.

Currently, the project `vtracker` is hosted on GitHub using the user account `rmaicle`.
It could be accessed from a browser at `https://github.com/rmaicle/vtracker`.

For production, a new account must be used.

For reference, there is an online documentation available at [https://git-scm.com/docs](https://git-scm.com/docs) and a downloadable electronic book in `pdf`, `epub` and `mobi` formats at [https://git-scm.com/book/en/v2](https://git-scm.com/book/en/v2).

[^git_version_control]: https://en.wikipedia.org/wiki/Git



### Install `git`

Note that the machine must be online to access the operating system remote repositories.

~~~
$ sudo pacman -S git
~~~



### Clone the Git repository

A clone or a copy of the project repository is needed in the local filesystem.
A clone is an exact and complete copy of the project files, and all the changes made.

The project files must be cloned from the remote GitHub site, `https://github.com/rmaicle/vtracker`.

The following command will create a clone of the project files from the remote site in a subdirectory named `vtracker`.
The default behaviour of the `git clone` command is to create the subdirectory based on the name of the project which is `vtracker`.

~~~
$ git clone https://github.com/rmaicle/vtracker
~~~

If a different subdirectory name is preferred or necessary, then the `git clone` command has an option for that.
Issue the same command and add the preferred subdirectory name to be created.

The following command will create a subdirectory named `preferred_dir`.

~~~
$ git clone https://github.com/rmaicle/vtracker preferred_dir
~~~

Note that the project subdirectory will be created on the current working directory.
Therefore, more than one copy of the project files can be present in the filesystem.



### Commit Log

Git maintains a log of all changes made to the project files.
Each change contains a log message about the change, a list of modified or new files, and the actuall `diff`[^diff].

To display log messages, run the command inside the project directory:

~~~
$ git log
~~~

A more compact way of displaying log messages is the following command:

~~~
$ git log --oneline
~~~

The following command is a more detailed and colorful display of log messages:

~~~
$ git log \
    --decorate \
    --graph \
    --pretty=format:'%C(green)%h %<(10)%C(cyan)%ad%Creset %s%C(red)%d' \
    --abbrev-commit \
    --date=format:'%Y-%m-%d %H:%M:%S' \
    --max-count=25
~~~

Note that the date argument `--date=format:'%Y-%m-%d %H:%M:%S'` only works with `git` version 2.6.0 and higher.

The last command can be created as an alias.
An alias is a short-named command used in place of a, usually long, command.

Edit the `git` configuration file of the current user's home directory.
This is usually at `/home/<user>/.gitconfig`.
Add the following:

~~~
[alias]
    logm = log \
        --decorate \
        --graph \
        --pretty=format:'%C(green)%h %<(10)%C(cyan)%ad%Creset %s%C(red)%d' \
        --abbrev-commit \
        --date=format:'%Y-%m-%d %H:%M:%S' \
        --max-count=25
~~~

The short-named command is `logm`.
Whenever `git logm` is entered at the project directory, it will output something like the following:

~~~
$ git logm
* d361663 2019-01-15 11:21:44 Update documentation (HEAD -> gh-pages,
                              origin/gh-pages)
* 54d336b 2019-01-15 11:21:10 Split the creation of database objects into
                              different files
* 17a7863 2019-01-15 11:19:48 Update data management script
* 3527aa0 2019-01-15 11:18:32 Reorganize Latex template
* edc616b 2019-01-15 11:17:36 Use 3rd party pandoc preprocessor for the
                              documentation
* 325c919 2019-01-15 00:07:40 Update documentation markdown file
* 30448ba 2019-01-15 00:06:57 Rename documentation generation scripts and Latex
                              template files
* 108dd7d 2019-01-14 08:21:56 Rename documentation build files
* d00dd61 2019-01-14 08:21:30 Add server checks before executing any SQL
                              operation
* fe2d434 2019-01-14 08:20:58 Rename output columns of leader assignment
~~~


[^diff]: Typically, a `diff` is an output showing the changes between two versions of the same file.  The tool used to produce it is also called `diff` The output is also sometimes called or a `patch`, since the output can be applied with the Unix program `patch`.



### Commit Changes

Changes are stored in the repository by issuing the following command:

~~~
$ git commit -a -m "commit message"
~~~

send changes to the remote repository.

~~~
$ git push
~~~



### Getting Project Updates

Any changes in the remote site may be obtained by updating the local copy of the project.
In the Git version control, this is called a `pull`.
All changes can be pulled from the remote site and put on the local copy.

The following command "pulls" all changes from the project remote repository and put on the local git repository.

~~~
$ git pull
~~~



## Database

The system shall use PostgreSQL version 11 or higher.



### Install PostgreSQL

Note that the machine must be online to access the operating system remote repositories.

~~~
$ sudo pacman -S postgresql
~~~



#### Switch to User &nbsp;`postgres`

Become `root` then as `postgres`[^archlinux162075].

~~~
$ su -
# su - postgres
~~~

The last command will change the current working directory to `/var/lib/postgres`.

[^archlinux162075]: [https://bbs.archlinux.org/viewtopic.php?id=162075](https://bbs.archlinux.org/viewtopic.php?id=162075)



#### Database Initialization

The following command initializes the database storage area on disk; also called _database cluster_ in PostgreSQL and _catalog cluster_ in the SQL standard[^postgres_945_17_2].

~~~
$ initdb --locale en_PH.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
~~~

The directory `/var/lib/postgres/data` is called _data directory_ or _data area_.
The command must be executed while logged as PostgrSQL user account.

[^postgres_945_17_2]: PostgreSQL 9.4.5 §17.2 [http://www.postgresql.org/docs/9.4/interactive/creating-cluster.html](http://www.postgresql.org/docs/9.4/interactive/creating-cluster.html)



### Starting and Stopping the Database Server

The database server may be started using the GNU/Linux `systemctl`.
The program `systemctl` controls the systemd system and service manager.

The following command runs (starts) the PostgreSQL database server in the background:

~~~
$ systemctl start postgresql
~~~

And the corresponding command stops a running database server:

~~~
$ systemctl stop postgresql
~~~

Note that the command requires a privilege to execute and will prompt for the password of the current user.



### PostgreSQL Server Status

PostgreSQL has a [utility](https://www.postgresql.org/docs/9.3/static/app-pg-isready.html) that checks the connection status of a PostgreSQL server.

When the server has not been started the utility will have the following output.

~~~
$ pg_isready
/run/postgresql:5432 - no response
~~~

Otherwise, the following will be displayed:

~~~
$ pg_isready
/run/postgresql:5432 - accepting connections
~~~



### PostgreSQL Version

There are a number of ways to check the PostgreSQL version.

1. Using the PostgreSQL interactive terminal program.

    ~~~
    $ psql --version
    psql (PostgreSQL) 11.1
    ~~~

2. Using the PostgreSQL configuration utility program.

    ~~~
    $ pg_config --version
    PostgreSQL 11.1
    ~~~

3. Using the PostgreSQL server application.

    ~~~
    $ postgres -V
    postgres (PostgreSQL) 11.1
    ~~~



## Jekyll

The system shall use Jekyll 3.8.4 or higher.
The following are the system requirements for Jekyll 3.8.4:

* Ruby version 2.2.5 or above, including all development headers (ruby version can be checked by running ruby -v)
* RubyGems (which you can check by running gem -v)
* GCC and Make (in case your system doesn’t have them installed, which you can check by running `gcc -v`, `g++ -v` and `make -v` on the command line)

The following references may be consulted on how to setup Jekyll with GitHub pages.

[Setting up your GitHub Pages site locally with Jekyll](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)
[Setting up GitHub Pages with Jekyll](http://www.stephaniehicks.com/githubPages_tutorial/pages/githubpages-jekyll.html)



### Install Jekyll

Note that the machine must be online to access the operating system remote repositories.

~~~
$ gem install jekyll bundler
...
~~~

See the [Jekyll Install](#section-jekyll-install) section of the Output chapter to see the details of the output of the command above.



### Bundle Install

Install the bundled Ruby Gems or Ruby libraries into `./vendor/bundle/` in contrast to installing into the system-wide directory.
This allows the dependencies to be in an isolated environment which ensures that they do not conflict with other Ruby Gems on the system.
Note that the machine must be online to access the operating system remote repositories.

~~~
$ bundle install --path ./vendor/bundle
...
~~~



### Configure Ignored Directory

Add the following to the `git` ignore file `.gitignore` file:

~~~
vendor/**
.bundle
.jekyll-metadata
Gemfile
Gemfile.lock
~~~

Add the following to the `jekyll` configuration file `_config.yml`:

~~~
# Exclude from processing.
# The following items will not be processed, by default. Create a custom list
# to override the default setting.
exclude:
   - Gemfile
   - Gemfile.lock
   - node_modules
   - vendor/bundle/
   - vendor/cache/
   - vendor/gems/
   - vendor/ruby/
~~~



### Generate Files

To generate static HTML pages, change directory to the project directory then execute the command, `bundle exec jekyll serve`.

~~~
$ bundle exec jekyll serve
Configuration file: /mnt/work/projects/dan/source/vtracker/_config.yml
            Source: .
       Destination: ./_site
 Incremental build: disabled. Enable with --incremental
      Generating...
                    done in 20.018 seconds.
 Auto-regeneration: enabled for '.'
    Server address: http://127.0.0.1:4000/vtracker/
  Server running... press ctrl-c to stop.
~~~

\clearpage
