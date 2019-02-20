# Operations {#chapter-operations}

This chapter discusses the operations in detail and the commands needed to execute the corresponding operations.



## System Initialization

At the start of operation, this procedure is all there is to perform.
This procedure involves other procedures that are called automatically.

__Start the Database Server__

Make sure that the PostgreSQL database server is running before performing any of the following procedures.
See the [Starting and Stopping the Database Server](#section-starting-stopping-database-server) section.

__Ensure Source Data Files are in UTF-8 Encoding__

Prepare the _source data import files_.
See the [Source Data Import Table section](#section-source-data-import-table) for more information on the _source data import files_.

In case the files are not in UTF-8 encoding, convert them.

~~~
$ iconv -i <file>
$ iconv -f us-ascii -t utf-8 <input> -o <output>
~~~

__Initialization Script__

The script calls other specific procedures to perform the system initialization:

* Database creation
* Source data files importation
* Markdown files generation

The command will prompt the user for confirmation whether to proceed or not since this is a destructive operaiton.
It will erase all data in the database by recreating all database objects, populate them with new data from the imported source data files and generate all markdown files.

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



### Create Database

All database tables, functions, views, procedures, triggers will be created.
This procedure will delete database objects if they were previously created and recreate them, erasing  all existing data.

The database creation script is automatically called by the initialization script, although it may be performed separately.

The following command (re)creates the database objects:

~~~
$ ./import.sh --create-db
~~~



### Import Source Data

The database will be populated with the _source data files_.
This procedure will read the CSV files from the _source data import directory_ and imported into the _source data import table_.
See the [Source Data Import Table](#section-source-data-import-table) section for more details.

Importing the _source data files_ is automatically called by the initialization script, although it may be performed separately.

The following command imports the _source data files_ into the database.

~~~
$ ./import.sh --import source
~~~



### Create Markdown Files

Markdown files are template files rendered by Jekyll to produce HTML files.
They are automatically created based on the data in the database.

The markdown file creation is automatically called by the initialization script, although it may be performed separately.

The following command creates all markdown files for the `district`, `municipality` and `barangay` directories under the project root directory. The number of created markdown files depends on the number districts, municipalities and barangays in the database.

~~~
$ ./import.sh --create-markdown
~~~



## In-Favor Value

There are 3 ways to update the in-favor value by precinct.
A fourth exists only for testing.

1. Add a value to the current precinct in-favor value;
2. Set the current precinct in-favor value
3. Import one or more _in-favor data files_ to be added to the current precinct in-favor values;

The _data management script_ is used to do all three ways.
The _import script_ does only the third.



### Add or Setting the Precinct In-Favor Value

The following command will add the specified value `4` to the current in-favor value of the precinct whose id is `100` using the _data management script_.

~~~
$ ./dm.sh add-precinct-current 100 4
~~~

The following command will change the current in-favor value to `4` of the precinct whose id is `100` using the _data management script_.

~~~
$ ./dm.sh set-precinct-current 100 4
~~~

The following command will import the precinct in-favor values to be added to the current in-favor values of the corresponding precincts using the _data management script_.

~~~
$ ./dm.sh add-precinct-current -f
~~~



### Importing In-Favor Data Files

Importing the _in-favor data files_ requires that the CSV files be in the _import directory_ `<project>/_data/to_import/current`.

The _import script_ can also be used to update the precinct in-favor value by importing one or more CSV files.
This command is the same if it was executed using the _data management script_ above.

~~~
$ ./import.sh --import current
~~~

Note that this procedure automatically calls the script that generates the JSON files.



### Generate In-Favor Mock Data

In-Favor mock data is used during testing to verify computation routines.
This procedure creates mock data in the _poll monitoring table_.

This procedure is not called by the initialization script.

The following command syntax shows how it can be used:

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



## Create JSON Files

After system initialization and/or after updating the database, the data from the database must be exported to JSON files.
The purpose of the JSON files is to feed the data when generating the HTML files locally or remotely.

This procedure is automatically called after in-favor data files have been imported.
If somehow, there is any database update performed after the in-favor data files have been imported, then it is necessary to manually execute this command.

The following command will create all JSON files.

~~~
$ ./create_json.sh
~~~

The JSON files will be created in the _data directory_ `<project>/_data`.

Note that this procedure automatically updates the local and remote repositories.



## Publish Changes

To publish all changes and make them viewable locally and remotely, the local repository must be synchronized with the remote repository hosted by GitHub.
In production, it is only necessary to synchronize the changes made in the JSON files given that there are no other modifications made to the system, like changes in the HTML page generation templates.
If there are other changes to the system, then it is necessary to publish those changes locally and then synchronized with the remote repository.

### Publish JSON Files Only

The following command will add the JSON files to the staging area.
It is necessary that this command is executed in the _scripts directory_ `<project>/_scripts`.

This procedure is automatically called when the JSON files were created.

~~~
$ git add ../_data/*.json
~~~

Publish the changes to the local repository.

~~~
$ git commit -m "Update JSON files"
~~~



### Publish Other Changes

All file changes must be commited to the local repository and then synchronized with the remote repository.

The first command tells Git what files to add to the local repository.
The second command tells git to put the files into the local repository.

~~~
$ git add ...
$ git commit ...
~~~

The following command synchronizes the remote repository hosted by GitHub with the local repository.

~~~
$ git push
~~~



## View Poll Status

The poll monitoring status can be viewed as HTML pages from the remote site using a web browser in the following URL:

~~~
https://pepollms.github.io/tracker/
~~~



## Other Data Management Functions {#section-other-data-management-functions}

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
$ ./dm.sh add-leader "Black, Joe" +639160000091
~~~



### Set Leader Name

Set the name of an existing leader record.
The software will check that the new name is unique.

~~~
$ ./dm.sh set-leader-name 16 "Black, Jack"
~~~



### Set Leader Contact

Set the contact number of an existing leader record.
The software will check that the new contact number is unique.

~~~
$ ./dm.sh set-leader-contact 16 "+639160000081"
~~~



### Set Leader-Precinct Assignment

Assign a leader to a precinct voting jurisdiction.
The precinct must not currently be assigned to any leader.

~~~
$ ./dm.sh set-leader-assignment 16 10
~~~



### Set Target Count

Set the target In-Favor value.
The precinct ID must exist.

~~~
$ ./dm.sh set-precinct-target 1 10
~~~



\clearpage
