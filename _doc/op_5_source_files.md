# Source Files {#chapter-source-files}

This section provides the source file listings.



## Import Script {#section-import-script}

The _data source import script_ is responsible for a number of operations:

1. Create the all database objects.
2. Import the source data into the `import` table and populate other tables.
3. Optionally create mock data for the `monitor` table.
4. Create the markdown files used by Jekyll to generate the static HTML pages.

The creation of database objects are further divided into specific operations:

1. Create base tables
3. Create poll monitoring views
4. Create data management functions
2. Create utility functions

The following Bash shell script is the driver script for the operations above.

File: `<project>/_scripts/import.sh`

!source(../_scripts/import.sh)(bash .numberLines)



## Base Tables

The following Bash shell script is used to create all database tables; geographical subdivisions, voting jurisdictions and poll monitoring tables.
See the [Database Design](#database-design) section for a conceptual overview of the database model.

File: `<project>/_scripts/sql/create_base_tables.sql`

!source(../_scripts/sql/create_base_tables.sql)(sql)



### Source Data Import Table

Script to create the `vt_import` table.

File: `<project>/_scripts/sql/base/import.sql`

!source(../_scripts/sql/base/import.sql)(sql)



### Current Import Table

Script to create the `vt_import_current` table.

File: `<project>/_scripts/sql/base/import_current.sql`

!source(../_scripts/sql/base/import_current.sql)(sql)



### Region Table

Script to create the `vt_region` table.

File: `<project>/_scripts/sql/base/region.sql`

!source(../_scripts/sql/base/region.sql)(sql)



### Province Table

Script to create the `vt_province` table.

File: `<project>/_scripts/sql/base/province.sql`

!source(../_scripts/sql/base/province.sql)(sql)



### District Table

Script to create the `vt_district` table.

File: `<project>/_scripts/sql/base/district.sql`

!source(../_scripts/sql/base/district.sql)(sql)



### Municipality Table

Script to create the `vt_municipality` table.

File: `<project>/_scripts/sql/base/municipality.sql`

!source(../_scripts/sql/base/municipality.sql)(sql)



### Barangay Table

Script to create the `vt_barangay` table.

File: `<project>/_scripts/sql/base/barangay.sql`

!source(../_scripts/sql/base/barangay.sql)(sql)



### Precinct Table

Script to create the `vt_precinct` table.

File: `<project>/_scripts/sql/base/precinct.sql`

!source(../_scripts/sql/base/precinct.sql)(sql)



### Leader Table

Script to create the `vt_leader` table.

File: `<project>/_scripts/sql/base/leader.sql`

!source(../_scripts/sql/base/leader.sql)(sql)



### Leader-Precinct Assignment Table

Script to create the `vt_leader_precinct_assignment` table.

File: `<project>/_scripts/sql/base/leader_precinct_assignment.sql`

!source(../_scripts/sql/base/leader_precinct_assignment.sql)(sql)



### Precinct Monitor Table

Script to create the `vt_precinct_monitor` table.

File: `<project>/_scripts/sql/base/precinct_monitor.sql`

!source(../_scripts/sql/base/precinct_monitor.sql)(sql)



## Views

Script that calls all specific view creation scripts.

File: `<project>/_scripts/sql/create_monitor_views.sql`

!source(../_scripts/sql/create_monitor_views.sql)(sql)



### Precinct View

Displays all precinct information.

File: `<project>/_scripts/sql/view/precinct.sql`

!source(../_scripts/sql/view/precinct.sql)(sql)



### Barangay View

Displays all barangay information.

File: `<project>/_scripts/sql/view/barangay.sql`

!source(../_scripts/sql/view/barangay.sql)(sql)



### Municipality View

Displays all municipality information.

File: `<project>/_scripts/sql/view/municipality.sql`

!source(../_scripts/sql/view/municipality.sql)(sql)



### District View

Displays all district information.

File: `<script>/_scripts/sql/view/district.sql`

!source(../_scripts/sql/view/district.sql)(sql)



### Province View

Displays all province information.

File: `<project>/_scripts/sql/view/province.sql`

!source(../_scripts/sql/view/province.sql)(sql)



## Data Management

Data management is concerned with database queries, adding and updating informaiton.
See the Operations chapter, [Data Management](#section-data-management) section.

The following Bash shell script is the driver script for the data management operations above.

File: `<project>/_scripts/dm.sh`

!source(../_scripts/dm.sh)(bash)



### Data Management Functions

SQL functions that help in the data management operations.

File: `<project>/_scripts/sql/create_dm_functions.sql`

!source(../_scripts/sql/create_dm_functions.sql)(sql)



#### `get_leader_name` Function

SQL function that returns the name of the specified Leader ID.

File: `<project>/_scripts/sql/dm/function/get_leader_name.sql`

!source(../_scripts/sql/dm/function/get_leader_name.sql)(sql)



#### `get_leader_contact` Function

SQL function that returns the contact number of the specified Leader ID.

File: `<project>/_scripts/sql/dm/function/get_leader_contact.sql`

!source(../_scripts/sql/dm/function/get_leader_contact.sql)(sql)



#### `add_leader` Function

SQL function that adds a new leader record.

File: `<project>/_scripts/sql/dm/function/add_leader.sql`

!source(../_scripts/sql/dm/function/add_leader.sql)(sql)



#### `set_leader_name` Function

SQL function that updates the name of the speficied Leader ID.

File: `<project>/_scripts/sql/dm/function/set_leader_name.sql`

!source(../_scripts/sql/dm/function/set_leader_name.sql)(sql)



#### `set_leader_contact` Function

SQL function that updates the contact number of the specified Leader ID.

File: `<project>/_scripts/sql/dm/function/set_leader_contact.sql`

!source(../_scripts/sql/dm/function/set_leader_contact.sql)(sql)



#### `set_leader_assignment` Function

SQL function that assigns a Precinct to a Leader.

File: `<project>/_scripts/sql/dm/function/set_leader_assignment.sql`

!source(../_scripts/sql/dm/function/set_leader_assignment.sql)(sql)



#### `get_precinct_current` Function

SQL function that returns the current value of the specified Precinct ID.

File: `<project>/_scripts/sql/dm/function/get_precinct_current.sql`

!source(../_scripts/sql/dm/function/get_precinct_current.sql)(sql)



#### `get_precinct_target` Function

SQL function that returns the target value of the specified Precinct ID.

File: `<project>/_scripts/sql/dm/function/get_precinct_target.sql`

!source(../_scripts/sql/dm/function/get_precinct_target.sql)(sql)



#### `add_precinct_current` Function

SQL function that adds a value to the current value of the specified Precinct ID.

File: `<project>/_scripts/sql/dm/function/add_precinct_current.sql`

!source(../_scripts/sql/dm/function/add_precinct_current.sql)(sql)



#### `set_precinct_current` Function

SQL function that sets the current value of the specified Precinct ID.

File: `<project>/_scripts/sql/dm/function/set_precinct_current.sql`

!source(../_scripts/sql/dm/function/set_precinct_current.sql)(sql)



#### `set_precinct_target` Function

SQL function that sets the target value of the specified Precinct ID.

File: `<project>/_scripts/sql/dm/function/set_precinct_target.sql`

!source(../_scripts/sql/dm/function/set_precinct_target.sql)(sql)



## JSON Creation

This Bash shell script consolidates the creation of all JSON files.

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

File: `<project>/_scripts/create_json.sh`

!source(../_scripts/create_json.sh)(bash)



### Provincial

The Bash shell script creates the JSON file containing the provincial totals.

File: `<project>/_scripts/sql/json/create_json_province.sql`

!source(../_scripts/sql/json/create_json_province.sql)(sql)



### District Summary

The Bash shell script creates the JSON file containing the District summary totals.

File: `<project>/_scripts/sql/json/create_json_districts.sql`

!source(../_scripts/sql/json/create_json_districts.sql)(sql)



### Municipality Summary

The Bash shell script creates the JSON file containing the Municipality summary totals.

File: `<project>/_scripts/sql/json/create_json_municipalities.sql`

!source(../_scripts/sql/json/create_json_municipalities.sql)(sql)



### Municipality Details

The Bash shell script creates the JSON file containing the Municipality detail totals.

File: `<project>/_scripts/sql/json/create_json_municipalities_details.sql`

!source(../_scripts/sql/json/create_json_municipalities_details.sql)(sql)



### Barangay Summary

The Bash shell script creates the JSON file containing the Barangay summary totals.

File: `<project>/_scripts/sql/json/create_json_barangays.sql`

!source(../_scripts/sql/json/create_json_barangays.sql)(sql)



### Barangay Details

The Bash shell script creates the JSON file containing the Barangay detail totals.

File: `<project>/_scripts/sql/json/create_json_barangays_details.sql`

!source(../_scripts/sql/json/create_json_barangays_details.sql)(sql)



### Precinct Summary

The Bash shell script creates the JSON file containing the Precinct summary totals.

File: `<project>/_scripts/sql/json/create_json_precincts.sql`

!source(../_scripts/sql/json/create_json_precincts.sql)(sql)



### Precinct Details

The Bash shell script creates the JSON file containing the Precinct detail totals.

File: `<project>/_scripts/sql/json/create_json_precincts_details.sql`

!source(../_scripts/sql/json/create_json_precincts_details.sql)(sql)



## Utility Functions

SQL functions for use during testing and other operations.

File: `<project>/_scripts/sql/create_utility_functions.sql`

!source(../_scripts/sql/create_utility_functions.sql)(sql)



### `get_percentage` Function

SQL function that returns the percent rate of some number compared to some total number.

File: `<project>/_scripts/sql/utility/get_percentage.sql`

Example, 70 is what percentage of 200?
The function returns 35.

!source(../_scripts/sql/utility/get_percentage.sql)(sql)



### `get_percentage_value` Function

SQL function that returns the percentage value of a percent rate of some total number.

File: `<project>/_scripts/sql/utility/get_percentage_value.sql`

Example, 70% of 200 is what?
The function returns 140.

!source(../_scripts/sql/utility/get_percentage_value.sql)(sql)



### `random_between` Function

SQL function that returns a value between the specified lower bound and upper bound numbers.

File: `<project>/_scripts/sql/utility/random_between.sql`

!source(../_scripts/sql/utility/random_between.sql)(sql)



\clearpage
