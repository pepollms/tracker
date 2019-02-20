# Software Setup and Configuration {#chapter-software-setup-and-configuration}

This section describes the setup and configuration procedures of the system.

The target software system shall use a GNU/Linux platform.
All supporting software tools shall use open source software only.

The system uses the following major components:

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
    +-- barangays/          [auto-created]
    +-- css/                [stylesheets]
    +-- _data/              [JSON files]
        |
        +-- to_import       [import directory]
            |
            +-- region
            +-- province
            +-- district
            +-- current
    +-- districts/          [auto-created]
    +-- _doc/               [documentation files]
    +-- images/             [web page images]
    +-- _includes/          [include page files]
    +-- javascripts/
    +-- _layouts/           [page layouts]
    +-- municipalities/     [auto-created]
    +-- _posts/             [not used]
    +-- _sass/              [SASS stylesheets]
    +-- _scripts/           [script files]
        |
        +-- sql             [SQL script files]
            |
            +-- base        [database table creation]
            +-- dm          [data management]
            +-- import      [source data importing]
            +-- json        [JSON creation]
            +-- mock
            +-- utility     [database utility functions]
            +-- view        [database view creation]
    +-- _site/              [output web pages]
    +-- vendor/             [Jekyll-specific files]
    +-- 404.html
    +-- about.md
    +-- _config.yml         [Jekyll configuration file]
    +-- Gemfile             [Ruby dependencies]
    +-- Gemfile.lock
    +-- index.md
~~~

The project files are kept in a Git version control repository.



## Project Repository

The system uses the Git version control[^git_version_control].
The system uses a GitHub account to host the project repository and to host the static web pages.

Currently, the project repository name is `tracker` and hosted remotely on GitHub, `https://github.com/pepollms/tracker`.

For Git reference, an online documentation available at [https://git-scm.com/docs](https://git-scm.com/docs) and a downloadable electronic book in `pdf`, `epub` and `mobi` formats at [https://git-scm.com/book/en/v2](https://git-scm.com/book/en/v2).

[^git_version_control]: https://en.wikipedia.org/wiki/Git



### Installing Git Version Control

Note that the machine must be online to access the remote repository.

~~~
$ sudo pacman -S git
~~~



### Cloning Git Repository

A clone is a copy of a repository.
The remote repository on GitHub must be cloned to have a local copy in the filesystem.

Note that there are a couple of ways to clone a git repository on GitHub; HTTPS and SSH.
HTTPS provide access to the Git repository over a secure connection and is available even if behind a firewall or proxy.
Using SSH URLS provide access to the Git repository via SSH, a secure protocol, which requires creating SSH keys.
The difference is that using HTTPS requires that the user provide their GitHub username and password every time a `git pull`, `git push` or `git fetch` command is executed.
To be able to push changes to the repository, without providing the GitHub username and password everytime, the project will use SSH.
See the [GitHub](#section-github) section on how to setup and use SSH.

The following command will create a clone of the project files from the remote site in a subdirectory named `vtracker`.
The default behaviour of the `git clone` command is to create the subdirectory based on the name of the project which is `vtracker`.

~~~
$ git clone git@github.com:pepollms/tracker.git
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



### Commit Changes and Push Changes to Remote Repository

All changes are stored in the Git repository.
Add new changes by issuing the following command inside the project directory.

~~~
$ git commit -a -m "commit message"
~~~

or use the `git gui  &` command to run a graphical user interface.

When the last `git push` command was issued, Git bookmarks that event so that the next time the command is executed, Git will only send changes from that time onwards.
To send the changes in the local repository to the remote repository, run the following command:

~~~
$ git push
~~~



### Get Project Updates from Remote Repository {#section-get-project-updates-from-remote-repository}

Any changes in the remote site may be obtained by updating the local copy of the project.
In the Git version control, this is called a `pull`.
All changes can be pulled from the remote site and put on the local copy.

The following command "pulls" all changes from the project remote repository and put on the local git repository.
It must be executed inside the project directory.

~~~
$ git pull
~~~

If the command above produces an error like the one below, it means that the remote site could not verify the SSH public key.
Add the public key to the `ssh-agent`.
See the [Add SSH Key to `ssh-agent`](#section-add-ssh-key-to-ssh-agent) section.

~~~
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
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



#### Adding SSH Key to `ssh-agent` {#section-add-ssh-key-to-ssh-agent}

Add the SSH private key to the ssh-agent.

The following command assumes that the SSH key is in the `~/.ssh` directory and the key name is `github_pepollms_rsa`.

~~~
$ ssh-add ~/.ssh/github_pepollms_rsa
~~~

Note that the command must be executed everytime the machine is restarted.



#### Adding SSH Key to GitHub

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



### Installing PostgreSQL

Note that the machine must be online to access the operating system remote repositories.

~~~
$ sudo pacman -S postgresql
~~~



#### Database Initialization

Creating the PostgreSQL database requires that the command `initdb` be executed as a `postgres` user.
Become `root` then as `postgres`[^archlinux162075].

~~~
$ su -
# su - postgres
~~~

The directory `/var/lib/postgres` is the home directory of the user `postgres`.

The following command initializes the database storage area on disk also called a _database cluster_.
A database cluster is a collection of databases managed by a single instance of a running database server.[^postgres_11_1_sec_18_2]

~~~
$ initdb --locale en_PH.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
~~~

The option `--locale` tells `initdb` to create the database using the locale named `en_PH` and the optional codeset `UTF-8`.[^postgres_11_1_sec_23_1_1]

The directory `/var/lib/postgres/data` is where the data will be stored, also called _data directory_ or _data area_.
It could have been created anywhere in the system but the project uses the popular location.

The following is an output of the command above.

~~~
$ initdb --locale en_PH.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_PH.UTF-8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgres/data ... ok
creating subdirectories ... ok
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting dynamic shared memory implementation ... posix
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

WARNING: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    pg_ctl -D /var/lib/postgres/data -l logfile start
~~~

[^archlinux162075]: [https://bbs.archlinux.org/viewtopic.php?id=162075](https://bbs.archlinux.org/viewtopic.php?id=162075)
[^postgres_11_1_sec_18_2]: PostgreSQL 11.1 §18.2 [https://www.postgresql.org/docs/11/creating-cluster.html](https://www.postgresql.org/docs/11/creating-cluster.html)
[^postgres_11_1_sec_23_1_1]: PostgreSQL 11.1 §23.1.1 [https://www.postgresql.org/docs/11/locale.html](https://www.postgresql.org/docs/11/locale.html)



### Starting and Stopping the Database Server {#section-starting-stopping-database-server}

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

The commands above require privilege to execute and will prompt for the password of the current user.

If for some reason the command `systemctl start postgresql` produces the error below, it is possible that the PostgreSQL database has not been created or initialized yet.

~~~
$ systemctl start postgresql
Job for postgresql.service failed because the control process exited with error code.
See "systemctl status postgresql.service" and "journalctl -xe" for details.
~~~



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

The numbers `5432` is the port number used by the PostgreSQL database server to listen to connections.



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

* Ruby version 2.2.5 or above, including all development headers (ruby version can be checked by running ruby -v).
* RubyGems is a package manager for Ruby modules, called _gems_ (which you can check by running gem -v).
* GCC and Make (in case your system doesn’t have them installed, which you can check by running `gcc -v`, `g++ -v` and `make -v` on the command line).

The following references may be consulted on how to setup Jekyll with GitHub pages.

[Setting up your GitHub Pages site locally with Jekyll](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)
[Setting up GitHub Pages with Jekyll](http://www.stephaniehicks.com/githubPages_tutorial/pages/githubpages-jekyll.html)

### Install Ruby

### Install Bundler

Bundler manages a Ruby application's dependencies.
Bundler allows you to specify which gems and optionally their version that your application depends on.
Once this specification is in place, Bundler installs all required gems (including the full gem dependency tree) and logs the results for later inspection.

~~~
$ gem install bundler
Fetching bundler-2.0.1.gem
WARNING:  You don't have /home/dan/.gem/ruby/2.6.0/bin in your PATH,
      gem executables will not run.
Successfully installed bundler-2.0.1
1 gem installed
~~~

If the warning appears, edit `.bashrc` and add the Ruby executable path to the `PATH` environment variable.

~~~
export PATH=$PATH:~/.gem/ruby/2.6.0/bin
~~~

And execute the following:

~~~
$ source ~/.bashrc
~~~



### Install Jekyll and Other Dependencies

Jekyll is a Ruby program and therefore requires Ruby to be installed first.

Create a `Gemfile` to tell `bundler` what to install.

~~~
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
~~~

The first line tells `bundler` where to get the _gems_.
The second line tells `bundler` to use GitHub Pages.

Install Jekyll and other dependencies by running the command below.
The parameter `--path ./vendor/bundle` tells `bundler` to create and install to that directory.
This allows the dependencies to be in an isolated environment which ensures that they do not conflict with other Ruby Gems on the system.

~~~
$ bundle install --path ./vendor/bundle
...
~~~

See the [Jekyll Install](#section-jekyll-install) section of the Output chapter to see the details of the output of the command above.



### Upgrade

To upgrade, run the following command in the project directory.

~~~
$ bundle update github-pages
~~~



### Configure Ignored Directory

Add the following to the Git ignore file `.gitignore` file:

~~~
vendor/**
.bundle
.jekyll-metadata
Gemfile
Gemfile.lock
~~~

Add the following to the Jekyll configuration file `_config.yml`:

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
   - _doc/
   - _scripts/
~~~



### Generate Local Files

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
