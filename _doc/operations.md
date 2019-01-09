---
title: Pre-Election Poll Monitoring System
subtitle: |
    | Operations Manual
    |
author:
  - name: Ricardo Maicle
    email: rmaicle@gmail.com
  - name: Dan Zambrano
    email: dan.kidtech@gmail.com
version: Version 0.1.0
date: January 2019
distribution: |
    | Private; distribution limited to company use only.
    |
xdistribution: |
    | For private use; distribution limited to executive level only.
    | This is an optional second line.
    | Approved for public release and unlimited distribution.
    |
xcopyright: Copyleft \textcopyright\space2017
licenseimage: cc_by_nc_sa_40.eps
license: CC BY-NC-SA 4.0
licensetext: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0). You are free to copy, reproduce, distribute, display, and make adaptations of this work for non-commercial purposes provided that you give appropriate credit. To view a copy of this license, visit [http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode](http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode).
licenselink: "http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/"
xsource: The source is available at [https://www.github.com/rmaicle/mdtopdf](https://www.github.com/rmaicle/mdtopdf).
---



# Introduction

The Pre-Election Poll Monitoring System keeps track of the number of voters who would prefer to vote for a candidate. The numbers are then compared to the voting population to determine the likelyhood of winning the election.



# Concept of Operations



# Software System Overview

The target software system shall use a GNU/Linux platform.
All supporting software tools shall use open source software only.

The system shall use the following:

* GitHub - for static web page hosting for testing and possibly for production.
* PostgreSQL - relational database to hold all system data.
* Jekyll - static site generator for creating HTML pages.

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



# Database

Pre-Election Poll Monitoring System imports pre-election data files like geographical subdivisions, voting jurisdictions, number of registered voters and campaign leaders.



## Pre-Election Data

The database is created and initially populated with the pre-election data supplied during system setup and performed once at the start of the system operation.



### Structure

The pre-election data files are comma-separated value (CSV) files with a header line.
The following table shows the structure of the CSV file as expected by the system.

| Column No. | Column Name       | Data Type | Length |
|:----------:+-------------------+-----------+--------|
|      1     | province          | text      |   50   |
|      1     | district          | text      |   50   |
|      1     | municipality      | text      |   50   |
|      1     | municipality code | text      |   10   |
|      1     | barangay          | text      |   50   |
|      1     | precinct          | text      |   10   |
|      1     | voters            | numeric   |        |
|      1     | leader            | text      |  100   |
|      1     | contact           | text      |   50   |
|      1     | target            | numeric   |        |

The data in the district column is assumed to be formatted as abbreviations of ordinal numbers.
Municipal code is assumed as numbers. Voters and Target column data cannot contain negative values.



### Importing Data

The pre-election data files is expected to be read from the `<project>/_data/to_import/` directory and imported into PostgreSQL database using the `import.sh` driver script. It is assumed that there will be three (3) files in the import directory; each file corresponds to a district. The filenames of the files are assumed to be in the format `district_x.csv`, where x is a number between 1 and 3 inclusive. The files are expected to be in UTF-8 encoding to accomodate special characters like the Spanish "enye", Ñ (lower case ñ).

To import the pre-election data files into the database, a shell script is executed in the scripts directory, `<project>/_scripts`.

~~~
$ ./import.sh --prepare
~~~

* The `import.sh` bash shell script driver file is used to prepare the CSV files, create the database objects, import the CSV files, create the source markdown files and other operations.

* The `create_databse.sql` SQL script file is used by `import.sh` to create the actual database objects.



## Exporting Data as JSON Files

The system displays the data in web pages as HTML files. To build these HTML files with data, Jekyll reads the JSON files containing the data from the database.

To create all JSON files that will be used by Jekyll in generating the static HTML files, a separate script file has to be executed in the script directory, `<project>/_scripts`. The JSON files will be created in the directory `<project>/_data`.

~~~
$ ./create_json_all.sh
~~~

The following SQL script files are used by `create_json_all.sh` to generate the JSON files:

* create_json_regions.sql
* create_json_districts.sql
* create_json_municipalities.sql
* create_json_barangays.sql
* create_json_precincts.sql
* create_json_municipalities_details.sql
* create_json_barangays_details.sql
* create_json_precincts_details.sql
* create_json_totals.sql



## Data Management

There is a bash shell script for data management, `dm.sh` which handles the following operations:

1. Add leader
2. Set leader name
3. Set leader contact
4. Get leader assignment
5. Set leader assignment
6. Get precinct information
7. Set precinct target value
8. Add precinct current value
9. Set precinct current value

The script file is under the scripts directory, `<project>/_scripts`.

### Add Leader

Add new leader information.

### Set Leader Name

Update an existing leader's name.

### Set Leader Contact

Update and existing leader's contact number.

### Get Leader Assignment

Show leader precinct assignments.

### Set Leader Assignment

Update leader precinct assignments.

### Get Precinct Information

Show precinct information.

### Set Precinct Target Value

Update precinct target value.

### Add Precinct Current Value

Add to precinct current value.

### Set Precinct Current Value

Update precinct current value.



# System Setup and Configuration

The following sections describe how how to setup and configure the softwares used by the system.



## GitHub Account

The system shall use a GitHub account to host the static web pages.
Currently, we are using `https://github.com/rmaicle/vtracker` to host the static web pages.

For production, a new account must be used.



## Database

The system shall use PostgreSQL version 11 or higher.



### Install PostgreSQL

Note that the machine must be online to access the operating system remote repositories.

~~~
$ sudo pacman -S postgresql
~~~



### Switch to User &nbsp;`postgres`

Become `root` then as `postgres`[^archlinux162075].

~~~
$ su -
# su - postgres
~~~

The last command will change the current working directory to `/var/lib/postgres`.

[^archlinux162075]: [https://bbs.archlinux.org/viewtopic.php?id=162075](https://bbs.archlinux.org/viewtopic.php?id=162075)

### Database Initialization

The following command initializes the database storage area on disk; also called _database cluster_ in PostgreSQL and _catalog cluster_ in the SQL standard[^postgres_945_17_2].

~~~
$ initdb --locale en_PH.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
~~~

The directory `/var/lib/postgres/data` is called _data directory_ or _data area_.
The command must be executed while logged as PostgrSQL user account.

[^postgres_945_17_2]: PostgreSQL 9.4.5 §17.2 [http://www.postgresql.org/docs/9.4/interactive/creating-cluster.html](http://www.postgresql.org/docs/9.4/interactive/creating-cluster.html)

### Starting the Database Server

The database server may be started using `systemctl`.
It runs the database server in the background so there is no need to keep an open console as when using the `postgres` command.

~~~
$ systemctl start postgresql
~~~



### Stopping the Database Server

The corresponding command to stop a running database server is:

~~~
$ systemctl stop postgresql
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



### PostgreSQL Version

There are a number of ways to check the PostgreSQL version information; through the commandline and inside the PostgreSQL client application.



#### Server version

~~~
$ pg_config --version
PostgreSQL 9.5.1
$ postgres -V
postgres (PostgreSQL) 9.5.1
~~~



#### Client version

~~~
$ psql --version
psql (PostgreSQL) 9.5.1
~~~



#### `psql` Interface

One can also query the database version from the PostgreSQL commandline client application.
The database server must be running and one must be connected to it.

~~~
$ psql -d postgres -U postgres -h localhost
psql (9.5.1)
Type "help" for help.
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



### Bundle Install

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
                    done in 11.831 seconds.
 Auto-regeneration: enabled for '.'
    Server address: http://127.0.0.1:4000/vtracker/
  Server running... press ctrl-c to stop.
~~~
