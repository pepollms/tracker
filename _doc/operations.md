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

Pre-Election Poll Monitoring System imports source data files like geographical subdivisions, voting jurisdictions, number of registered voters and campaign leaders.



## Source Data

The database is created and initially populated with the source data supplied during system setup and performed once at the start of the system operation.



### Structure

The source data files are comma-separated value (CSV) files with a header line.
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

The source data files is expected to be read from the `<project>/_data/to_import/` directory and imported into PostgreSQL database using the `import.sh` driver script. It is assumed that there will be three (3) files in the import directory; each file corresponds to a district. The filenames of the files are assumed to be in the format `district_x.csv`, where x is a number between 1 and 3 inclusive. The files are expected to be in UTF-8 encoding to accomodate special characters like the Spanish "enye", Ñ (lower case ñ).

To import the source data files into the database, a shell script is executed in the scripts directory, `<project>/_scripts`.

~~~
$ ./import.sh --prepare
~~~

The `import.sh` bash shell script driver file is used to prepare the CSV files, create the database objects, import the CSV files, create the source markdown files and other operations. The file `import.sh` uses the SQL script file `create_databse.sql` which creates the database objects.



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

   district   | municipality_id | municipality |  barangay  | precinct_id | precinct
--------------+-----------------+--------------+------------+-------------+----------
 1ST DISTRICT |               1 | ALAMADA      | GUILING    |          80 | 0066A
 1ST DISTRICT |               4 | MIDSAYAP     | MACASENDEG |         791 | 0185A
 1ST DISTRICT |               6 | PIKIT        | PANICUPAN  |        1511 | 0172A
 2ND DISTRICT |               7 | ANTIPAS      | MALATAB    |        1667 | 0051B
 2ND DISTRICT |               9 | KIDAPAWAN    | SINGAO     |        2402 | 0287A
 2ND DISTRICT |              12 | PRES. ROXAS  | MABUHAY    |        3076 | 0078A
 3RD DISTRICT |              13 | BANISILAN    | PANTAR     |        3247 | 0059B
 3RD DISTRICT |              16 | MATALAM      | KILADA     |        3940 | 0071C
 3RD DISTRICT |              18 | TULUNAN      | NEW CULASI |        4641 | 0106A
(9 rows)
~~~


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


## Updating HTML Pages




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
