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



### Source Data Import Table

Script to create the `vt_import` table, `<project>/_scripts/sql/base/import.sql`.

!source(../_scripts/sql/base/import.sql)(sql)



### Current Import Table

Script to create the `vt_import_current` table, `<project>/_scripts/sql/base/import_current.sql`.

!source(../_scripts/sql/base/import_current.sql)(sql)



### Region Table

Script to create the `vt_region` table, `<project>/_scripts/sql/base/region.sql`.

!source(../_scripts/sql/base/region.sql)(sql)



### Province Table

Script to create the `vt_province` table, `<project>/_scripts/sql/base/province.sql`.

!source(../_scripts/sql/base/province.sql)(sql)



### District Table

Script to create the `vt_district` table, `<project>/_scripts/sql/base/district.sql`.

!source(../_scripts/sql/base/district.sql)(sql)



### Municipality Table

Script to create the `vt_municipality` table, `<project>/_scripts/sql/base/municipality.sql`.

!source(../_scripts/sql/base/municipality.sql)(sql)



### Barangay Table

Script to create the `vt_barangay` table, `<project>/_scripts/sql/base/barangay.sql`.

!source(../_scripts/sql/base/barangay.sql)(sql)



### Precinct Table

Script to create the `vt_precinct` table, `<project>/_scripts/sql/base/precinct.sql`.

!source(../_scripts/sql/base/precinct.sql)(sql)



### Leader Table

Script to create the `vt_leader` table, `<project>/_scripts/sql/base/leader.sql`.

!source(../_scripts/sql/base/leader.sql)(sql)



### Leader-Precinct Assignment Table

Script to create the `vt_leader_precinct_assignment` table, `<project>/_scripts/sql/base/leader_precinct_assignment.sql`.

!source(../_scripts/sql/base/leader_precinct_assignment.sql)(sql)



### Precinct Monitor Table

Script to create the `vt_precinct_monitor` table,  `<project>/_scripts/sql/base/precinct_monitor.sql`.

!source(../_scripts/sql/base/precinct_monitor.sql)(sql)



## Views

Script that calls all specific view creation scripts, `<project>/_scripts/sql/create_monitor_views.sql`.

!source(../_scripts/sql/create_monitor_views.sql)(sql)



### Precinct View

Displays all precinct information, `<project>/_scripts/sql/view/precinct.sql`.

!source(../_scripts/sql/view/precinct.sql)(sql)



### Barangay View

Displays all barangay information, `<project>/_scripts/sql/view/barangay.sql`.

!source(../_scripts/sql/view/barangay.sql)(sql)



### Municipality View

Displays all municipality information, `<project>/_scripts/sql/view/municipality.sql`.

!source(../_scripts/sql/view/municipality.sql)(sql)



### District View

Displays all district information, `<script>/_scripts/sql/view/district.sql`.

!source(../_scripts/sql/view/district.sql)(sql)



### Province View

Displays all province information, `<project>/_scripts/sql/view/province.sql`.

!source(../_scripts/sql/view/province.sql)(sql)



## Data Management

Data management script, `<project>/_scripts/dm.sh`.

!source(../_scripts/dm.sh)(bash)



### Data Management Functions

SQL functions that help in the data management operations, `<project>/_scripts/sql/create_dm_functions.sql`.

!source(../_scripts/sql/create_dm_functions.sql)(sql)



#### `get_leader_name` Function

SQL function that returns the name of the specified Leader ID, `<project>/_scripts/sql/dm/function/get_leader_name.sql`.

!source(../_scripts/sql/dm/function/get_leader_name.sql)(sql)



#### `get_leader_contact` Function

SQL function that returns the contact number of the specified Leader ID, `<project>/_scripts/sql/dm/function/get_leader_contact.sql`.

!source(../_scripts/sql/dm/function/get_leader_contact.sql)(sql)



#### `add_leader` Function

SQL function that adds a new leader record, `<project>/_scripts/sql/dm/function/add_leader.sql`.

!source(../_scripts/sql/dm/function/add_leader.sql)(sql)



#### `set_leader_name` Function

SQL function that updates the name of the speficied Leader ID, `<project>/_scripts/sql/dm/function/set_leader_name.sql`.

!source(../_scripts/sql/dm/function/set_leader_name.sql)(sql)



#### `set_leader_contact` Function

SQL function that updates the contact number of the specified Leader ID, `<project>/_scripts/sql/dm/function/set_leader_contact.sql`.

!source(../_scripts/sql/dm/function/set_leader_contact.sql)(sql)



#### `set_leader_assignment` Function

SQL function that assigns a Precinct to a Leader, `<project>/_scripts/sql/dm/function/set_leader_assignment.sql`.

!source(../_scripts/sql/dm/function/set_leader_assignment.sql)(sql)



#### `get_precinct_current` Function

SQL function that returns the current value of the specified Precinct ID, `<project>/_scripts/sql/dm/function/get_precinct_current.sql`.

!source(../_scripts/sql/dm/function/get_precinct_current.sql)(sql)



#### `get_precinct_target` Function

SQL function that returns the target value of the specified Precinct ID, `<project>/_scripts/sql/dm/function/get_precinct_target.sql`.

!source(../_scripts/sql/dm/function/get_precinct_target.sql)(sql)



#### `add_precinct_current` Function

SQL function that adds a value to the current value of the specified Precinct ID, `<project>/_scripts/sql/dm/function/add_precinct_current.sql`.

!source(../_scripts/sql/dm/function/add_precinct_current.sql)(sql)



#### `set_precinct_current` Function

SQL function that sets the current value of the specified Precinct ID, `<project>/_scripts/sql/dm/function/set_precinct_current.sql`.

!source(../_scripts/sql/dm/function/set_precinct_current.sql)(sql)



#### `set_precinct_target` Function

SQL function that sets the target value of the specified Precinct ID, `<project>/_scripts/sql/dm/function/set_precinct_target.sql`.

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

The Bash shell script `create_json_province.json` creates the JSON file containing the provincial totals, `<project>/_scripts/sql/json/create_json_province.sql.

!source(../_scripts/sql/json/create_json_province.sql)(sql)



### District Summary

The Bash shell script `create_json_districts.json` creates the JSON file containing the District summary totals, `<project>/_scripts/sql/json/create_json_districts.sql.

!source(../_scripts/sql/json/create_json_districts.sql)(sql)



### Municipality Summary

The Bash shell script `create_json_municipalities.json` creates the JSON file containing the Municipality summary totals, `<project>/_scripts/sql/json/create_json_municipalities.sql`.

!source(../_scripts/sql/json/create_json_municipalities.sql)(sql)



### Municipality Details

The Bash shell script `create_json_municipalities_details.json` creates the JSON file containing the Municipality detail totals, `<project>/_scripts/sql/json/create_json_municipalities_details.sql`.

!source(../_scripts/sql/json/create_json_municipalities_details.sql)(sql)



### Barangay Summary

The Bash shell script `create_json_barangays.json` creates the JSON file containing the Barangay summary totals, `<project>/_scripts/sql/json/create_json_barangays.sql`.

!source(../_scripts/sql/json/create_json_barangays.sql)(sql)



### Barangay Details

The Bash shell script `create_json_barangays_details.json` creates the JSON file containing the Barangay detail totals, `<project>/_scripts/sql/json/create_json_barangays_details.sql`.

!source(../_scripts/sql/json/create_json_barangays_details.sql)(sql)



### Precinct Summary

The Bash shell script `create_json_precincts.json` creates the JSON file containing the Precinct summary totals, `<project>/_scripts/sql/json/create_json_precincts.sql`.

!source(../_scripts/sql/json/create_json_precincts.sql)(sql)



### Precinct Details

The Bash shell script `create_json_precincts_details.json` creates the JSON file containing the Precinct detail totals, `<project>/_scripts/sql/json/create_json_precincts_details.sql`.

!source(../_scripts/sql/json/create_json_precincts_details.sql)(sql)



## Utility Functions

SQL functions for use during testing and other operations., `<project>/_scripts/sql/create_utility_functions.sql`.

!source(../_scripts/sql/create_utility_functions.sql)(sql)



### `get_percentage` Function

SQL function that returns the percentage of a corresponding number based on another given number, `<project>/_scripts/sql/utility/get_percentage.sql`.

Example, given the number 70 and 200, the function returns 35.
It is read as, 70 is 35% of 200.

!source(../_scripts/sql/utility/get_percentage.sql)(sql)



### `get_percentage_value` Function

SQL function that returns the corresponding value of the percentage of a specified number, `<project>/_scripts/sql/utility/get_percentage_value.sql`.

Example, given the number 70 and 200, the function returns 140.
It is read as, 70% of 200 is 140.

!source(../_scripts/sql/utility/get_percentage_value.sql)(sql)



### `random_between` Function

SQL function that returns a value between the specified lower bound and upper bound numbers, `<project>/_scripts/sql/utility/random_between.sql`.

!source(../_scripts/sql/utility/random_between.sql)(sql)



\clearpage
