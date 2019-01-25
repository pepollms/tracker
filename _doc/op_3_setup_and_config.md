# Software Setup and Configuration {#chapter-software-setup-and-configuration}

This section describes the setup and configuration procedures of the system.

The target software system shall use a GNU/Linux platform.
All supporting software tools shall use open source software only.

The system uses the following:

* GitHub - web site for hosting the static web pages for testing and possibly for production.
* PostgreSQL - relational database to hold all system data.
* Jekyll - static site generator for creating HTML pages.



## Manjaro

This section describes the maintenance of the Manjaro Linux operating system.



### Synching Mirror Sites

The official Manjaro repositories (also known as mirrors) are hosted on _Software Servers_ located throughout the world.
These servers are responsible for receiving requests from software packages via the terminal, or GUI-based applications and delivering them to your local system.
Three primary factors will determine the speed of downloads from these servers:

* Your internet connection
* The speed of the server itself, and
* The proximity of the server to you (i.e. how close or how far away it is)

Using `pacman-mirrors` is the preferred way of getting a mirror list.
It accepts `-fasttrack [number]` or `-f [number]`.
The `-fasttrack` option ensures that the local machine connects to a server with the latest software.
The `[number]` specifies the number of servers to be written in the local mirror list and the default is to use all up-to-date mirrors.

The following command uses all mirror sites.

~~~
$ sudo pacman-mirrors --fasttrack
~~~

The following command limits mirror sites to 10.

~~~
$ sudo pacman-mirrors --fasttrack 10
~~~

These are the steps performed by the command:

* Pacman-mirrors will download a status file from the mirror service URL.
* From that file you will get 10 random mirrors that have updated software for your current branch.
* The 10 mirrors will be sorted by their current response times and written to the mirror list.

Refer to a more detailed information on Pacman mirrors at this url:

~~~
https://wiki.manjaro.org/Pacman-mirrors
~~~



### Synchronizing Package Database

Manjaro Linux maintains a local database of all software packages that are available from the official repositories.
These repositories are used to locate and download software packages. Synchronizing this database ensures that it is up to date to avoid potential problems when downloading software packages.

The following command needs a bit of explanation.
The parameter options `-Sy` will synchronize and download a fresh copy of the master package database.
Specifying `-Syy` will force a refresh of all package databases even if they appear to be up-to-date which is the recommended parameter option..

~~~
$ sudo pacman -Syy
~~~


### Update

Updating Manjaro Linux with the latest software packages requires downloading those packages from mirror sites.

The following command does the job:

~~~
$ sudo pacman -Su
~~~

But this is not the recommended way.
The recommended way is to combine the package database synchronization option and the update in one command.

~~~
$ sudo pacman -Syyu
~~~



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

## GitHub {#section-github}

The project uses GitHub, a web-based hosting service for version control using Git.



### Connecting to GitHub with SSH

The steps to enable connecting to GitHub via SSH is discussed in detail in [https://help.github.com/articles/connecting-to-github-with-ssh/](https://help.github.com/articles/connecting-to-github-with-ssh/).



### Generating SSH Key

Enter the following command to create a new SSH key in the current directory using the RSA algorithm.

~~~
$ ssh-keygen -t rsa
~~~

It will prompt for a filename wherein to save the key and a passphrase.
The filename could be renamed if necessary.
The passphrase asked whenever adding the SSH key to the ssh-agent.



#### Add SSH Key to `ssh-agent` {#section-add-ssh-key-to-ssh-agent}

Add the SSH private key to the ssh-agent.

The following command assumes that the SSH key is in the `~/.ssh` directory and the key name is `github_pepollms_rsa`.

~~~
$ ssh-add ~/.ssh/github_pepollms_rsa
~~~

Note that the command must be executed everytime the machine is restarted.



#### Add SSH Key to GitHub

The `xclip` program may be necessary to install if it has not yet been installed.
`xclip` is a commandline program used to copy text into.

Install `xclip`.

~~~
$ sudo pacman -Syu xclip
[sudo] password for <user>:
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
 multilib is up to date
:: Starting full system upgrade...
resolving dependencies...
looking for conflicting packages...

Packages (1) xclip-0.13-2

Total Download Size:   0.01 MiB
Total Installed Size:  0.06 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 xclip-0.13-2-x86_64       14.8 KiB  46.8K/s 00:00 [#####] 100%
(1/1) checking keys in keyring                     [#####] 100%
(1/1) checking package integrity                   [#####] 100%
(1/1) loading package files                        [#####] 100%
(1/1) checking for file conflicts                  [#####] 100%
(1/1) checking available disk space                [#####] 100%
:: Processing package changes...
(1/1) installing xclip                             [#####] 100%
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
~~~

Copy the SSH Key to the clipboard.
Note that the `<filename>` is the public SSH key filename you created with `ssh-keygen`.
The public key is the filename with the `.pub` extension.

~~~
$ xclip -sel clip < ~/.ssh/<filename>
~~~

Add the SSH key in the GitHub account settings and under the SSH and GPG keys section by pasting the copied SSH key text in the clipboard.



#### Run `ssh-agent` on System Start-Up

Add the following to the `~/.bash_profile` file.

~~~
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
~~~

The following was taken from Stack Overflow site, [https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login](https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login).



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
