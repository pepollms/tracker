# Operations {#chapter-operations}

This chapter discusses the operations in detail and the commands needed to execute the corresponding operations.



## System Initialization

At the start of operation, this procedure is all there is to perform.
This procedure involves other procedures that are called automatically.

### Start the Database Server

Make sure that the PostgreSQL database server is running before performing any of the following procedures.
See the [Starting and Stopping the Database Server](#section-starting-stopping-database-server) section.

### Ensure Source Data Files are in UTF-8 Encoding

Prepare the _source data import files_.
See the [Source Data Import Table section](#section-source-data-import-table) for more information on the _source data import files_.

In case the files are not in UTF-8 encoding, convert them.

~~~
$ iconv -i <file>
$ iconv -f us-ascii -t utf-8 <input> -o <output>
~~~

### System Initialization

This procedure initializes the system by automatically calling other required procedures:

* Database creation
* Source data files importation
* Markdown files generation

The command will prompt the user whether to proceed or not for confirmation since this is a destructive operaiton.
It will erase all data in an existing database, recreate all database objects, populate them with new data from the imported source data files and generate all markdown files.

~~~
$ ./import.sh --init

System initialization is only performed during system startup.
It will destroy all existing data in the current database and
(re)populated with new data from the source data files.

The following operations will be performed:
  1. Create database
  2. Import source data
  3. Create markdown files

Do you want to initialize the system?
1) Yes
2) No
#?
~~~

The user is required to enter either `1` or `2` only.



## Create Database

All database tables, functions, views, procedures, triggers will be created.
This procedure will erase these database objects if they were previously created and all existing data will be lost.

This procedure is automatically called during system initialization.
This procedure may be performed separately only during testing.

The following command in the _scripts directory_ (re)creates all database objects.

~~~
$ ./import.sh --create-db
~~~



## Import Source Data

The database will be populated with data from the source data files.
This procedure will read the CSV files from the _source data import directory_ and imported into the _source data import table_.
See the [Source Data Import Table](#section-source-data-import-table) section for more details.

This procedure is automatically called during system initialization.
This procedure may be performed separately only during testing.

The following command in the _scripts directory_ imports the source data into the database.

~~~
$ ./import.sh --import source
~~~



## Create Markdown Files

Markdown files are template files for rendering by Jekyll.
They are automatically created based on data imported into the database and processed by Jekyll to produce the HTML files.

This procedure is automatically called during system initialization.
This procedure may be performed separately only during testing.

The following command creates all markdown files in the `district`, `municipality` and `barangay` directories under the project root directory.

~~~
$ ./import.sh --create-markdown
~~~

The number of created markdown files will depend on the number districts, municipalities and barangays in the database.



## Generate In-Favor Mock Data

In-Favor mock data is used during testing to verify correct system output.
This procedure creates mock data in the _poll monitoring table_.

This procedure is not called during system initialization.
This procedure may be performed separately only during testing.

The command has the following sytax:

~~~
$ ./import.sh --mock <-a n | -p x m> <-a n | -p x m>
                     --------------- ---------------
                       lower bound     upper bound
~~~

The command generates values between a lower bound and upper bound number where the upper bound should not exceed the poll target value.
If the upper bound exceeds the poll target value, then the poll target value is used instead.
The command accepts an absolute value or a percentage of some number.
The absolute value is specified using option `-a` followed by a number.
The percentage value is specified using option `-p` followed by a percentage value and a number.
The syntax `-p x m` is read as, `x` percent of `m`.

### Examples

The following will compute a value between 1 and 500.

~~~
$ ./import.sh --mock -a 1 -a 500
~~~

The following will compute a value between 1 and 50% of 500.

~~~
$ ./import.sh --mock -a 1 -p 50 500
~~~

The following will compute a value between 10% of 100 and 80% of 1,000.

~~~
$ ./import.sh --mock -p 10 100 -p 80 1000
~~~

The following will compute a value between 10% of 100 and 500.

~~~
$ ./import.sh --mock -p 10 100 -p 500
~~~

If no arguments are supplied, the defaults are used.
The default value for the lower bound is 1 and the upper bound is the poll target value.
Note that the poll target value is set when the source data was imported.

See the [Source Data Import Table](#section-source-data-import-table) section for further information.



## Updating In-Favor Value

In-Favor values in the database are updated by importing the In-Favor message collection or manually adding/setting a precinct in-favor value.

There are three ways to update the in-favor values:

1. Add a value to the current precinct in-favor value
2. Import one or more CSV files containing precincts and in-favor values to be add to the current precinct in-favor values
3. Set the current precinct in-favor value

The _data management script_ does all three ways and the _import script_ does the second.
Importing the precinct in-favor values to be added requires that the CSV files be in the _import directory_ `<project>/_data/to_import/current`.

The following command will add the specified value `4` to the current in-favor value of the precinct whose id is `100` using the _data management script_.

~~~
$ ./dm.sh add-precinct-current 100 4
~~~

The following command will import the precinct in-favor values to be added to the current in-favor values of the corresponding precincts using the _data management script_.

~~~
$ ./dm.sh add-precinct-current -f
~~~

The following _data mangement script_ command will change the current in-favor value to `4` of the precinct whose id is `100` using the _data management script_.

~~~
$ ./dm.sh set-precinct-current 100 4
~~~

The _import script_ can also be used to update the precinct in-favor value by importing one or more CSV files.
This command is the same if it was executed using the _data management script_ above.

~~~
$ ./import.sh --import current
~~~



## Create JSON Files

After updating the database, the data from the database must be exported to JSON files that Jekyll uses to (re)create the HTML files.

The following command creates all JSON files in the _script directory_ `<project>/_scripts`.

~~~
$ ./create_json.sh
~~~

The output JSON files will be created in the data directory `<project>/_data`.



## Upload Repository

To publish all changes and be viewable online, the project files need to be uploaded to GitHub.

First, we need to send all file changes and put them in the local repository.
The first command tells Git what files to add to the local repository.
The second command tells git to put the files into the local repository.

~~~
$ git add
$ git commit
~~~

Then, the following command will send the local repository to the remote GitHub repository.

~~~
$ git push
~~~



## View Poll Status

The poll monitoring status can be viewed as HTML pages from the remote site using a web browser and going to the following URL:

~~~
https://pepollms.github.io/tracker/
~~~



## Data Management {#section-data-management}

Data management handles database query, insert and update operations.

The bash shell script, `dm.sh` in the _scripts directory_ `<project>/_scripts` is the driver for data management.

Query operations:

1. Get precinct information
2. Get leader information
3. Get leader-precinct assignment

Insert and update operations:

1. Add new leader information
2. Set leader name
3. Set leader contact
4. Set leader-precinct assignment
5. Add In-Favor count
6. Set In-Favor count
7. Set Target count

To display the help text, execute the following command:

~~~
$ ./dm.sh --help
~~~



### Parameter Wildcard

Certain query operations could display multiple rows of data depending on the value of the supplied parameters.
Parameters containing the wildcard character, percent (`%`), means any number of characters.
The wildcard could be a used as a prefix or a suffix or both.

Used as a prefix, `%abc` means any text ending with `abc`.
Used as a suffix, `abc%` means any text starting with `abc`.
Used as a prefix and a suffix, `%abc%` means any text containing the text `abc`.

The following table shows which satisfies the criteria column.

| Text     | %abc | abc% | %abc% |
|----------|:----:|:----:|:-----:|
| abc      | Yes  | Yes  | Yes   |
| abcde    | No   | Yes  | Yes   |
| 123abc   | Yes  | No   | Yes   |
| 123abcde | No   | No   | Yes   |

Parameters containing the wildcard character, underscore (`_`), means any one character.
The wildcard could be a used as a prefix or a suffix or both.

The criteria `abc_` means any text starting with `abc` with at least one character after it.
The criteria `abc__` means any text starting with `abc` with at least two characters after it.
The criteria `___abc` menas any text ending with `abc` and with three characters before it.

The following table shows which texts satisfies the criteria column.

| Text     | `abc_` | `abc__` | `___abc` |
|----------|:------:|:-------:|:--------:|
| abc      | No     | No      | No       |
| abcde    | No     | Yes     | No       |
| 123abc   | No     | No      | Yes      |
| 123abcde | No     | No      | No       |




### List all municipalities

The following lists all municipalities in alphabetical order.

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

The following displays the precinct information whose precinct identifier is `100`.

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

The following displays the precinct information whose precinct name is `0010A`.

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

The following displays the leader information whose leader identifier is `100`.

~~~
$ ./dm.sh get-leader-info id 100
Get leader information with 'id' equal to '100'.
 id  |          name          |  contact
-----+------------------------+------------
 100 | ANTONIO,ROWENA   DIOMA | 9166006445
(1 row)
~~~

The following displays leader information whose leader identifier ends with `10`.

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

The following displays the leader information whose leader identifier starts with `11`.

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

The following displays the leader information whose leader identifier starts with `11` and have at least one succeeding character.

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

The following displays the precincts assigned to the specified leader.

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



### Add New Leader Information

Create a new leader record.
The software will check that the leader name and contact number is unique.

~~~
$ ./dm.sh
~~~



### Set Leader Name

Set the name of an existing leader record.
The software will check that the new name is unique.



### Set Leader Contact

Set the contact number of an existing leader record.
The software will check that the new contact number is unique.



### Set Leader-Precinct Assignment

Assign a leader to a precinct voting jurisdiction.
The precinct must not currently be assigned to any leader.



### Set Target Count

Set the target In-Favor value.

\clearpage
