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
version: Version 0.2.0
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

The system uses the following:

* GitHub - web site for hosting the static web pages for testing and possibly for production.
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

The project files are kept in a Git version control repository.
The Git repository is hosted on GitHub ([https://github.com/](https://github.com/)).



# Database

Pre-Election Poll Monitoring System imports source data files like geographical subdivisions, voting jurisdictions, number of registered voters and campaign leaders.



## Source Data

The database is created and initially populated with the source data supplied during system setup and performed once at the start of the system operation.



### Structure

The source data files are comma-separated value (CSV) files with a header line.
The following table shows the structure of the CSV file that is read by the system.

| Column No. | Column Name       | Data Type | Length |
|:----------:+-------------------+-----------+--------|
|      1     | province          | text      |   50   |
|      2     | district          | text      |   50   |
|      3     | municipality      | text      |   50   |
|      4     | municipality code | text      |   10   |
|      5     | barangay          | text      |   50   |
|      6     | precinct          | text      |   10   |
|      7     | voters            | numeric   |        |
|      8     | leader            | text      |  100   |
|      9     | contact           | text      |   50   |
|     10     | target            | numeric   |        |

The following are remarks or clarifications about the import table structure above:

1. The data in the `district` column is assumed to contain only abbreviations of ordinal numbers.
Ordinal number examples are `1st`, `2nd`, `3rd` and so on.
2. The `municipal code` column is assumed to contain only positive integral numbers.
3. The `voters` and `target` column is assumed to contain positive integral numbers.
4. The `voters` column is assumed to contain the number of voters.
5. The `target` column is assumed to contain a percentage value.
That means the column expects values from zero to a hundred percent (0-100).
The column does not expect a percentage (%) symbol.



### Importing Data

The source data files is expected to be read from the `<project>/_data/to_import/` directory and imported into PostgreSQL database using the `import.sh` driver script. It is assumed that there will be three (3) files in the import directory; each file corresponds to a district. The filenames of the files are assumed to be in the format `district_x.csv`, where x is a number between 1 and 3 inclusive. The files are expected to be in UTF-8 encoding to accomodate special characters like the Spanish "enye", Ñ (lower case ñ).

To import the source data files into the database, a shell script is executed in the scripts directory, `<project>/_scripts`.

~~~
$ ./import.sh --prepare
~~~

The `import.sh` bash shell script driver file is used to prepare the CSV files, create the database objects, import the CSV files, create the source markdown files and other operations. The file `import.sh` uses the SQL script file `create_databse.sql` which creates the database objects.



## Database Design <a name="database-design"></a>

The following diagrams show the database conceptual design.
The conceptual design is primarily influenced by the structure of the source data.

The following diagram shows the structure and relationships of the geographical subdivisions and voting jurisdictions.
Note that the PSGC is not used here.

![Geographical subdivisions][image_geo]

\clearpage
The following diagram shows how the poll monitoring information has been structured.

![Operations][image_operations]

[image_geo]: ./geo.svg
[image_operations]: ./operations.svg



## Data Management

The bash shell script, `dm.sh` in the scripts directory, `<project>/_scripts`, handles database query, insert and update operations.

Query operations:

1. List all municipalities
2. Get precinct information
3. Get leader information
4. Get leader-precinct assignment

Insert and update operations:

1. Add new leader information
2. Set leader name
3. Set leader contact
4. Set leader-precinct assignment
5. Add to precinct current count
6. Set precinct current count
7. Set precinct target



### Parameter Wildcard

Certain query operations could display multiple rows of data depending on the value of the supplied parameters.
Parameters containing the wildcard character, percent (`%`), means any number of characters.
The wildcard could be a used as a prefix or a suffix or both.

Used as a prefix, `%abc` means any text ending with `abc`.
The following table shows which texts satisfies the criteria `%abc`.

| Text     | Found? |
|----------|:------:|
| abc      | Yes    |
| abcde    | No     |
| 123abc   | Yes    |
| 123abcde | No     |

Used as a suffix, `abc%` means any text starting with `abc`.
The following table shows which texts satisfies the criteria `abc%`:

| Text     | Found? |
|----------|:------:|
| abc      | Yes    |
| abcde    | Yes    |
| 123abc   | No     |
| 123abcde | No     |

Used as a prefix and a suffix, `%abc%` means any text containing the text `abc`.
The following table shows which texts satisfies the criteria `%abc%`:

| Text     | Found? |
|----------|:------:|
| abc      | Yes    |
| abcde    | Yes    |
| 123abc   | Yes    |
| 123abcde | Yes    |

Parameters containing the wildcard character, underscore (`_`), means any one character.
The wildcard could be a used as a prefix or a suffix or both.

Used as a prefix, `abc_` means any text starting with `abc` with at least one character after it.
The following table shows which texts satisfies the criteria `abc_`:

| Text     | Found? |
|----------|:------:|
| abc      | No     |
| abcde    | No     |
| 123abc   | No     |
| 123abcde | No     |

The following table shows which texts satisfies the criteria `abc__`:

| Text     | Found? |
|----------|:------:|
| abc      | No     |
| abcde    | Yes    |
| 123abc   | No     |
| 123abcde | No     |

Note that the result above is the same if the criteria `abc_%` is used.

The following table shows which texts satisfies the criteria `___abc`:

| Text     | Found? |
|----------|:------:|
| abc      | No     |
| abcde    | No     |
| 123abc   | Yes    |
| 123abcde | No     |

Note that the result above is the same if the criteria `%_abc` is used.



### List all municipalities

List all municipalities in alphabetical order.

~~~
$ ./dm.sh list-municipality
Municipality list
 id | municipality
----+--------------
  1 | ALAMADA
  2 | ALEOSAN
  7 | ANTIPAS
  8 | ARAKAN
 13 | BANISILAN
 14 | CARMEN
 15 | KABACAN
  9 | KIDAPAWAN
  3 | LIBUNGAN
 10 | MAGPET
 11 | MAKILALA
 16 | MATALAM
  4 | MIDSAYAP
 17 | MLANG
  5 | PIGKAWAYAN
  6 | PIKIT
 12 | PRES. ROXAS
 18 | TULUNAN
(18 rows)
~~~



### Get Precinct Information

Display precinct information.
The operation accepts either a precinct identifier or a precinct name.

Display precinct information whose precinct identifier is 100.

~~~
$ ./dm.sh get-precinct-info id 100
-[ RECORD 1 ]------+--------------------
district_id        | 1
district           | 1ST DISTRICT
municipality_id    | 1
municipality       | ALAMADA
barangay_id        | 231
barangay           | KITACUBONG
precinct_id        | 100
precinct           | 0010A
leader_id          | 12
leader             | ABRIQUE,NOEL   IBOT
contact            | 9166006445
current_count_sum  | 41
target_count_sum   | 138
current_percentage | 30
total_voters_sum   | 197
target_percentage  | 70
~~~

Display precinct information whose precinct name is 0010A.

~~~
$ ./dm.sh get-precinct-info name 0010A
-[ RECORD 1 ]------+------------------------------
district_id        | 1
district           | 1ST DISTRICT
municipality_id    | 1
municipality       | ALAMADA
barangay_id        | 231
barangay           | KITACUBONG
precinct_id        | 100
precinct           | 0010A
leader_id          | 12
leader             | ABRIQUE,NOEL   IBOT
contact            | 9166006445
current_count_sum  | 41
target_count_sum   | 138
current_percentage | 30
total_voters_sum   | 197
target_percentage  | 70
-[ RECORD 2 ]------+------------------------------
district_id        | 1
district           | 1ST DISTRICT
municipality_id    | 2
municipality       | ALEOSAN
barangay_id        | 473
barangay           | SAN MATEO
precinct_id        | 297
precinct           | 0010A
leader_id          | 209
leader             | BELANDA,ROSE   GUMAY
contact            | 9166006445
current_count_sum  | 55
target_count_sum   | 107
current_percentage | 51
total_voters_sum   | 153
target_percentage  | 70
...
~~~



### Get Leader Information

Display leader information.

Display leader information whose leader identifier is 100.

~~~
$ ./dm.sh get-leader-info id 100
Get leader information with 'id' equal to '100'.
 id  |          name          |  contact
-----+------------------------+------------
 100 | ANTONIO,ROWENA   DIOMA | 9166006445
(1 row)
~~~

Display leader information whose leader identifier ends with `10`.

~~~
$ ./dm.sh get-leader-info id '%10'
Get leader information with 'id' like '%10'.
 id  |             name             |  contact
-----+------------------------------+------------
  10 | ABOLO,DELIO   OBEJERO        | 9166006445
 110 | ARELLANO,JUDITH   MANALASTAS | 9166006445
 210 | BELMONTE                     | 9166006445
 310 | CLAVERIA,DEMETRIO  PACLIBAR  | 9166006445
 410 | FAJARDO,SALCHIL   ENCABO     | 9166006445
 510 | GUMAY,DIONY   BENATO         | 9166006445
 610 | LUMAGA,SHEILA   MAE  CASTOR  | 9166006445
(7 rows)
~~~

Display leader information whose leader identifier starts with `11`.

~~~
$ ./dm.sh get-leader-info id '11%'
Get leader information with 'id' like '11%'.
 id  |             name             |  contact
-----+------------------------------+------------
  11 | ABOLO,MARITES   MONTAÑO      | 9166006445
 110 | ARELLANO,JUDITH   MANALASTAS | 9166006445
 111 | ARILLA,DANILO   SELLE        | 9166006445
 112 | ARNAIZ,MARIBEL   ANGAL       | 9166006445
 113 | ARNAIZ,MELBOY   MERMAL       | 9166006445
 114 | ARVADO,RENE   LANGOTE        | 9166006445
 115 | ARVADO,RODY   LANGOTE        | 9166006445
 116 | ARVADO,ROMY   LANGOTE        | 9166006445
 117 | ATILLO,DIVINA   PILASOR      | 9166006445
 118 | AVENIO,TERESITA   ESCODO     | 9166006445
 119 | AVENUE,JOVIE   VITUDIO       | 9166006445
(11 rows)
~~~

Display leader information whose leader identifier starts with `11` and have at least one succeeding character.

~~~
$ ./dm.sh get-leader-info id '11%'
Get leader information with 'id' like '11_'.
 id  |             name             |  contact
-----+------------------------------+------------
 110 | ARELLANO,JUDITH   MANALASTAS | 9166006445
 111 | ARILLA,DANILO   SELLE        | 9166006445
 112 | ARNAIZ,MARIBEL   ANGAL       | 9166006445
 113 | ARNAIZ,MELBOY   MERMAL       | 9166006445
 114 | ARVADO,RENE   LANGOTE        | 9166006445
 115 | ARVADO,RODY   LANGOTE        | 9166006445
 116 | ARVADO,ROMY   LANGOTE        | 9166006445
 117 | ATILLO,DIVINA   PILASOR      | 9166006445
 118 | AVENIO,TERESITA   ESCODO     | 9166006445
 119 | AVENUE,JOVIE   VITUDIO       | 9166006445
(10 rows)
~~~



### Get Leader-Precinct Assignment

Display the precincts assigned to the specified leader.

~~~
$ ./dm.sh get-leader-assignment id 100
Get leader assignment with leader 'id' equal to '100'.
-[ RECORD 1 ]-------------------
id      | 100
name    | ANTONIO,ROWENA   DIOMA
contact | 9166006445

   district   | mun_id | municipality |  barangay  | prec_id | precinct
--------------+--------+--------------+------------+---------+----------
 1ST DISTRICT |      1 | ALAMADA      | GUILING    |      80 | 0066A
 1ST DISTRICT |      4 | MIDSAYAP     | MACASENDEG |     791 | 0185A
 1ST DISTRICT |      6 | PIKIT        | PANICUPAN  |    1511 | 0172A
 2ND DISTRICT |      7 | ANTIPAS      | MALATAB    |    1667 | 0051B
 2ND DISTRICT |      9 | KIDAPAWAN    | SINGAO     |    2402 | 0287A
 2ND DISTRICT |     12 | PRES. ROXAS  | MABUHAY    |    3076 | 0078A
 3RD DISTRICT |     13 | BANISILAN    | PANTAR     |    3247 | 0059B
 3RD DISTRICT |     16 | MATALAM      | KILADA     |    3940 | 0071C
 3RD DISTRICT |     18 | TULUNAN      | NEW CULASI |    4641 | 0106A

(9 rows)
~~~



## Exporting Data as JSON Files

To build these HTML files, Jekyll reads the JSON files in the data directory `<project>/_data`.

To create all JSON files in the data directory, the bash shell script file `create_json.sh` in the script directory `<project>/_scripts` must be executed.

~~~
$ ./create_json.sh
~~~

The following SQL script files in the `<project>/_scripts/sql/json` directory are used by `create_json.sh` to generate the JSON files:

* create_json_province.sql
* create_json_districts.sql
* create_json_municipalities.sql
* create_json_barangays.sql
* create_json_precincts.sql
* create_json_municipalities_details.sql
* create_json_barangays_details.sql
* create_json_precincts_details.sql



## Updating HTML Pages

The static web pages are automatically re-generated by Jekyll if one of the files have changed.
Also, the static web pages are re-generated every time Jekyll is executed.



# System Setup and Configuration

This section describes the setup and configuration procedures of the system.



## Project Repository

The system uses the Git version control[^git_version_control].
The system uses a GitHub account to host the project repository and to host the static web pages.

Currently, the project `vtracker` is hosted on GitHub using the user account `rmaicle`.
It could be accessed via browser at `https://github.com/rmaicle/vtracker`.

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
$ git logt
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
                    done in 11.831 seconds.
 Auto-regeneration: enabled for '.'
    Server address: http://127.0.0.1:4000/vtracker/
  Server running... press ctrl-c to stop.
~~~



# Source Files

This section provides the source file listings.


## Import Script

The data source import script `import.sh` in the scripts directory `<project>/_scripts` is used to prepare the system.
It is responsible with the following operations:

1. Create the all database objects.
2. Import the source data into the `import` table and populate other tables.
3. Optionally create mock data for the `monitor` table.
4. Create the markdown files used by Jekyll to generate the static HTML pages.

Database creation is distributed into different SQL script files corresponding to their functionality.
The scripts are located in the scripts directory, `<project>/_scripts/sql`.
The individual scripts are called from the [source data import script](#source-data-import-script) `import.sh`.
There is no driver file for the database creation script but are executed sequentially in the following order:

1. create_base_tables.sql
3. create_monitor_views.sql
4. create_dm_functions.sql
2. create_utility_functions.sql



### Source Data Import Script <a name="source-data-import-script"></a>

The bash shell script file `import.sh` in the scripts directory `<project>/_scripts` is used as the driver

!source(../_scripts/import.sh)(bash)



### Tables

The bash shell script file `create_base_tables.sql` in the script directory `<project>/_scripts/sql` is used to create all database tables; geographical subdivisions, voting jurisdictions and poll monitoring tables.
See the section [Database Design](#database-design) section for a conceptual overview of the database model.

!source(../_scripts/sql/create_base_tables.sql)(sql)



### Views

Database views used to aid in query reusability and ease of use..

!source(../_scripts/sql/create_monitor_views.sql)(sql)



### Data Management Functions

Database functions that help in the data management operations.

!source(../_scripts/sql/create_dm_functions.sql)(sql)



### Utility Functions

Database functions that are used during testing and to help in other operations.

!source(../_scripts/sql/create_utility_functions.sql)(sql)



## Data Management

Source file listing of `dm.sh` in the scripts directory `_scripts`.

!source(../_scripts/dm.sh)(bash)



## JSON Creation



The bash shell script `create_json.sh` in the scripts directory `<project>/_scripts` consolidates the creation of all JSON files.
It calls the SQL scripts in the `<project>/_scripts/sql/json` directory.

!source(../_scripts/create_json.sh)(bash)

The following is a brief description of the arguments to the PostgrSQL `psql` application:

| Option | Description |
|--------+-------------|
| -d     | Specifies the name of the database to connect to. |
| -w     | Never issue a password prompt. |
| -t     | Suppress printing of column names and result row count footers, etc. |
| -c     | Command or SQL statement(s) to execute. |
| -f     | Specifies the file where commands will be read and executed. |
| -o     | Specifies the file where the output of the commands will be sent. |

All integral and non-percentage outputs are formatted as `FM999,999` which means no padding blank spaces and leading zeroes.



### Provincial

The bash shell script `create_json_province.json` creates the provincial total.

!source(../_scripts/sql/json/create_json_province.sql)(sql)



### District Summary

The bash shell script `create_json_districts.json` creates the district summary total.

!source(../_scripts/sql/json/create_json_districts.sql)(sql)



### Municipality Summary

The bash shell script `create_json_municipalities.json` creates the municipality summary total.

!source(../_scripts/sql/json/create_json_municipalities.sql)(sql)



### Municipality Details

The bash shell script `create_json_municipalities_details.json` creates the municipality details total.

!source(../_scripts/sql/json/create_json_municipalities_details.sql)(sql)



### Barangay Summary

The bash shell script `create_json_barangays.json` creates the barangay summary total.

!source(../_scripts/sql/json/create_json_barangays.sql)(sql)



### Barangay Details

The bash shell script `create_json_barangays_details.json` creates the barangay details total.

!source(../_scripts/sql/json/create_json_barangays_details.sql)(sql)



### Precinct Summary

The bash shell script `create_json_precincts.json` creates the precinct summary total.

!source(../_scripts/sql/json/create_json_precincts.sql)(sql)



### Precinct Details

The bash shell script `create_json_precincts_details.json` creates the precinct details total.

!source(../_scripts/sql/json/create_json_precincts_details.sql)(sql)

