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

