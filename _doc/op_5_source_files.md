# Source Files {#chapter-source-files}

This section provides the source file listings.



## Import Script {#section-import-script}

The data source import script `import.sh` in the scripts directory `<project>/_scripts` is responsible for the following operations:
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

The bash shell script file `import.sh` in the scripts directory `<project>/_scripts` is the driver script.

!source(../_scripts/import.sh)(bash .numberLines)



## Tables

The bash shell script file `create_base_tables.sql` in the script directory `<project>/_scripts/sql` is used to create all database tables; geographical subdivisions, voting jurisdictions and poll monitoring tables.
See the [Database Design](#database-design) section for a conceptual overview of the database model.

!source(../_scripts/sql/create_base_tables.sql)(sql)



### `import` Table

!source(../_scripts/sql/base/import.sql)(sql)



### `region` Table

!source(../_scripts/sql/base/region.sql)(sql)



### `province` Table

!source(../_scripts/sql/base/province.sql)(sql)



### `district` Table

!source(../_scripts/sql/base/district.sql)(sql)



### `municipality` Table

!source(../_scripts/sql/base/municipality.sql)(sql)



### `barangay` Table

!source(../_scripts/sql/base/barangay.sql)(sql)



### `precinct` Table

!source(../_scripts/sql/base/precinct.sql)(sql)



### `leader` Table

!source(../_scripts/sql/base/leader.sql)(sql)



### `leader_precinct_assignment` Table

!source(../_scripts/sql/base/leader_precinct_assignment.sql)(sql)



### `precinct_monitor` Table

!source(../_scripts/sql/base/precinct_monitor.sql)(sql)



## Views

Database views used to aid in query reusability and ease of use.

!source(../_scripts/sql/create_monitor_views.sql)(sql)



### `precinct` View

Display all precinct information.

!source(../_scripts/sql/view/precinct.sql)(sql)



### `barangay` View

Display all barangay information.

!source(../_scripts/sql/view/barangay.sql)(sql)



### `municipality` View

Display all municipality information.

!source(../_scripts/sql/view/municipality.sql)(sql)



### `district` View

Display all district information.

!source(../_scripts/sql/view/district.sql)(sql)



### `province` View

Display all province information.

!source(../_scripts/sql/view/province.sql)(sql)



## Data Management

Source file listing of `dm.sh` in the scripts directory `_scripts`.

!source(../_scripts/dm.sh)(bash)



### Data Management Functions

Database functions that help in the data management operations.

!source(../_scripts/sql/create_dm_functions.sql)(sql)



#### `get_leader_name` Function

Return the name of the specified leader id.

!source(../_scripts/sql/dm/function/get_leader_name.sql)(sql)



#### `get_leader_contact` Function

Return the contact number of the specified leader id.

!source(../_scripts/sql/dm/function/get_leader_contact.sql)(sql)



#### `add_leader` Function

Add a new leader information.

!source(../_scripts/sql/dm/function/add_leader.sql)(sql)



#### `set_leader_name` Function

Update the name of the speficied leader id.

!source(../_scripts/sql/dm/function/set_leader_name.sql)(sql)



#### `set_leader_contact` Function

Update the contact number of the specified leader id.

!source(../_scripts/sql/dm/function/set_leader_contact.sql)(sql)



#### `set_leader_assignment` Function

Assign a precinct to a leader.

!source(../_scripts/sql/dm/function/set_leader_assignment.sql)(sql)



#### `get_precinct_current` Function

Return the current value of the specified precinct id.

!source(../_scripts/sql/dm/function/get_precinct_current.sql)(sql)



#### `get_precinct_target` Function

Return the target value of the specified precinct id.

!source(../_scripts/sql/dm/function/get_precinct_target.sql)(sql)



#### `add_precinct_current` Function

Add a value to the current value of the specified precinct id.

!source(../_scripts/sql/dm/function/add_precinct_current.sql)(sql)



#### `set_precinct_current` Function

Set the current value of the specified precinct id to the specified value.

!source(../_scripts/sql/dm/function/set_precinct_current.sql)(sql)



#### `set_precinct_target` Function

Set the target value of the specified precinct id to the specified value.

!source(../_scripts/sql/dm/function/set_precinct_target.sql)(sql)



## JSON Creation

The bash shell script `create_json.sh` in the scripts directory `<project>/_scripts` consolidates the creation of all JSON files.
It calls the SQL scripts in the `<project>/_scripts/sql/json` directory.

The following is a brief description of the arguments to the PostgrSQL `psql` application used in the script.

| Option | Description |
|--------+-------------|
| -d     | Specifies the name of the database to connect to. |
| -w     | Never issue a password prompt. |
| -t     | Suppress printing of column names and result row count footers, etc. |
| -c     | Command or SQL statement(s) to execute. |
| -f     | Specifies the file where commands will be read and executed. |
| -o     | Specifies the file where the output of the commands will be sent. |

All integral and non-percentage outputs are formatted as `FM999,999` which means no padding blank spaces and leading zeroes.

!source(../_scripts/create_json.sh)(bash)



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



## Utility Functions

Database functions that are used during testing and to help in other operations.

!source(../_scripts/sql/create_utility_functions.sql)(sql)



### `get_percentage` Function

Return the percentage of a specified value based on another specified number.
Example, 70 is 35% of 200.
This function returns 35.

!source(../_scripts/sql/utility/get_percentage.sql)(sql)



### `get_percentage_value` Function

Return the value of the percentage of a given number based on another.
Example, 70% of 200 is 140.
This function returns 140.

!source(../_scripts/sql/utility/get_percentage_value.sql)(sql)



### `random_between` Function

Return a value in between the specified range.

!source(../_scripts/sql/utility/random_between.sql)(sql)




## Mock SQL Script for Testing

The following SQL script file is only used during testing to produce mock data for the In-Favor values.

!source(../_scripts/sql/mock/precinct_monitor_data.sql)(sql)

\clearpage
