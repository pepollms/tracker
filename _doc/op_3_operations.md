# Operations {#chapter-operations}

This chapter discusses the operations in detail and the commands needed to execute the corresponding operations.

The following table shows the system operations categorized by when each is performed.

| Operation                      | Production Start | Routine  |
|--------------------------------|:----------------:|:--------:|
| 1. Update Project Repository   | Yes              | Optional |
| 2. Start the Database Server   | Yes              | Yes      |
| 3. System Initialization       | Yes              |          |
| 4. Update In Favor Values      |                  | Yes      |
| 5. Create JSON Files           | Yes              | Yes      |
| 6. Publish Changes             | Yes              | Yes      |



## Update Project Repository

The project source files could change during production run in the event of bug fixes and enhancements published to the remote repository.
To acquire any changes in the project source files in the remote repository, it is necessary to update or synchronize the local repository.

The following table shows the procedures categorized by when each is performed.

| Operation                            | Re-Boot  | Live    |
|--------------------------------------|:--------:|:-------:|
| 1. Add SSH private key to SSH agent  | Yes      |         |
| 2. Synchronize local repository      | Yes      | Yes     |

1. Add the machine SSH private key to SSH agent.
This step is only necessary when the machine is rebooted because the system is not yet configured to automatically perform this during machine boot up.
See the section [Adding SSH Key to `ssh-agent`](#section-add-ssh-key-to-ssh-agent) in chapter 4 for details.

    The following command can be executed anywhere in the filesystem.
    The user will be asked for the passphrase that was used when the SSH key was created.
    See the [Generating SSH Key](#section-generating-ssh-key) section in chapter 4 for details.

    ~~~
    $ ssh-add ~/.ssh/github_pepollms_rsa
    ~~~

2. Synchronize local repository.
Synchronize the local repository with the changes in the remote repository by "pulling" the changes in.
See the section [Commit Changes and Push Changes to Remote Repository](#section-get-project-updates-from-remote-repository) in chapter 4 for details.

    The following command must be executed in the project directory.

    ~~~
    $ git pull
    ~~~



## Start the Database Server

Make sure that the PostgreSQL database server is running before performing any operations involving the database.
This step is only necessary when the machine is rebooted because the system is not yet configured to automatically perform this during machine boot up.
See the [Starting and Stopping the Database Server](#section-starting-stopping-database-server) section.



## Initialize the System

This operation is performed only at the start of production run to initialize the system.
This operation involves other procedures that are automatically performed.
These procedures are discussed in the subsections below.



### Ensure Source Data Files are in UTF-8 Encoding

Prepare the _source data import files_.
See the [Source Data Import Table section](#section-source-data-import-table) section in Chapter 2 for details.

The following command shows the text file encoding.

~~~
$ iconv -i <file>
~~~

Convert the files if they are not yet in UTF-8 encoding.
The following shows the syntax on how to use the `iconv` program to convert text files in ASCII encoding to UTF-8 encoding.

~~~
$ iconv -f us-ascii -t utf-8 <input> -o <output>
~~~



### Run the Initialization Script

The initialization script calls other procedures to perform the system initialization.
Although this procedure is only required at the start of the production run, the other procedures may be separately called and, usually, during testing or maintenance.
The other procedures are discussed below for more details.


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

The user is required to reply either `1` or `2` only.



### Create Database

This procedure will create all database tables, functions, views, procedures, and other objects.
If the database objects currently exists in the database, as in the case when testing was performed, they will be deleted along with all data and will be recreated.

The database creation script is automatically called by the initialization script, although it may be performed separately.

The following command (re)creates the database objects.

~~~
$ ./import.sh --create-db
~~~



### Import Source Data

The database tables will be initially populated with data from the _source data files_.
This procedure will read the CSV files from the _source data import directory_ and imported into the _source data import table_.
See the [Source Data Import Table](#section-source-data-import-table) section for more details.

Importing the _source data files_ is automatically called by the initialization script, although it may be performed separately.

The following command imports the _source data files_ into the database.

~~~
$ ./import.sh --import source
~~~



### Create Markdown Files

Markdown files are template files processed by Jekyll to produce HTML files.
These template markdown files are created based on the data in the database.

The markdown file creation is automatically called by the initialization script, although it may be performed separately.

The following command creates all markdown files for the `district`, `municipality` and `barangay` directories under the _project root directory_.
The number of created markdown files depends on the number districts, municipalities, barangays and precincts in the database.

~~~
$ ./import.sh --create-markdown
~~~



## Update In Favor Values

There are 3 ways to update the in favor value by precinct.

1. Import one or more _in favor data files_ to be added to the current precinct in favor values;
2. Add a value to the current precinct in favor value;
3. Set the current precinct in favor value

The _data management script_ is used to do all three ways.
The _import script_ does only the first.



### Importing In Favor Data Files

Importing _in favor data files_ requires that the CSV files exists in the _import directory_.

Note that the two procedures will automatically call the operation that generates JSON files.

__Using the Import Script__

The _import script_ is one of the tools that can be used to import one or more _in favor data files_.

~~~
$ ./import.sh --import current
~~~

__Using the Data Management Script__

The _data management script_ is another tool to import one or more _in favor data files_.

~~~
$ ./dm.sh add-precinct-current -f
~~~



### Add or Set the Precinct In Favor Value

The system  is also allowed to manually add to or set the precinct in favor value.

__Adding an In Favor Value__

The following syntax shows how to add a precinct in favor value using the _data management script_.

~~~
$ ./dm.sh add-precinct-current <precinct> <number>
~~~

The following command will add the specified value `4` to the current in favor value of the precinct whose id is `100`.

~~~
$ ./dm.sh add-precinct-current 100 4
~~~

__Setting an In Favor Value__

Setting a precinct in favor value uses the same syntax as adding an in favor value.
The following syntax shows how to set a precinct in favor value using the _data management script_.

~~~
$ ./dm.sh set-precinct-current <precinct> <number>
~~~

The following command will change the current in favor value to `4` of the precinct whose id is `100`.

~~~
$ ./dm.sh set-precinct-current 100 4
~~~



### Generate In Favor Mock Data

In Favor mock data is used during testing to verify computation routines.
This procedure creates mock data in the _poll monitoring table_.

This procedure is not called by the initialization script.

The following command syntax shows how it can be used.

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

This procedure is automatically called after in favor data files have been imported.
However, if any database update was performed after the in favor data files have been imported, then it is necessary to manually execute this command.

The following command will create all JSON files.

~~~
$ ./create_json.sh
~~~

The JSON files will be created in the _data directory_.

Note that this procedure automatically updates the local and remote repositories.



## Publish Changes

To publish all changes and make them viewable locally and remotely, the local repository must be synchronized with the remote repository hosted by GitHub.
In production, it is only necessary to synchronize the changes made in the JSON files given that there are no other modifications made to the system, like changes in the HTML page generation templates.
If there are other changes to the system, then it is necessary to publish those changes locally and then synchronized with the remote repository.

### Publish JSON Files Only

The following command will add the JSON files to the staging area.
It is necessary that this command is executed in the _scripts directory_.

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

The bash shell script, `dm.sh`, in the _scripts directory_ is the driver for data management.

Query operations:

1. Get precinct information
2. Get leader information
3. Get leader-precinct assignment

Insert and update operations:

1. Add new leader information
2. Set leader name
3. Set leader contact
4. Set leader-precinct assignment
5. Add In Favor count
6. Set In Favor count
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

Set the target In Favor value.
The precinct ID must exist.

~~~
$ ./dm.sh set-precinct-target 1 10
~~~



\clearpage
