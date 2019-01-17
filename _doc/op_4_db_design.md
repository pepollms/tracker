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



## Database Design

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
