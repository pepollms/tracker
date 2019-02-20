# Design {#chapter-design}

This chapter describes the design of the components of the system.
It shows how user interactions are mapped to the softwares used, the data storage structure and the filesystem layout of project files.



## Database Design

The following sub-sections show the database conceptual design.



### Source Data Import Table {#section-source-data-import-table}

The database is created and initially populated with the _source data_ supplied during system setup and performed once at the start of the system operation. The _source data import table_ is structured as a standalone table whose structure is identical to the _source data import file_ structure.

The _source data import file_ is comma-separated value (CSV) file with a header line.
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

The following clarifies some information on the source data import table structure above.

1. The data in the `district` column is assumed to contain only abbreviations of ordinal numbers.
Ordinal number examples are `1st`, `2nd`, `3rd` and so on.
2. The `municipal code` column is assumed to contain only positive integral numbers.
3. The `contact` column holds a mobile number and must be prefixed by country code (+639166006445).
3. The `voters` and `target` column is assumed to contain positive integral numbers.
4. The `voters` column is assumed to contain the number of voters.
5. The `target` column is assumed to contain a percentage value.
That means the column expects values from zero to a hundred percent (0-100).
The column does not expect a percentage (%) symbol.
The actual value of the _target_ will be computed from this percentage and kept.

All _source data import files_ are expected to be in UTF-8 encoding to accomodate special characters like the Spanish "enye", Ñ (lower case ñ).
All _source data import files_ must be in the _source data import directory_ `_data/to_import/district`.



### In-Favor Data Import Table

The _precinct monitor_ table in-favor column can be updated with values from a comma-separated value (CSV) file.
The file is imported into the database and processed.

The _in-favor data import table_ is structured as a standalone table whose structure is identical to the _in-favor data import file_ structure.

The _in-favor data import file_ is a comma-separated value (CSV) file with a header line.
The following table shows the structure of the CSV file that is read by the system.

| Column No. | Column Name       | Data Type | Length |
|:----------:+-------------------+-----------+--------|
|      1     | contact           | text      |   50   |
|      2     | municipality      | text      |   50   |
|      3     | precinct          | text      |   10   |
|      4     | current           | numeric   |        |

The _in-favor data import file_ is expected to be in UTF-8 encoding.
All _in-favor data import files_ must be in the _in-favor data import directory_ `_data/to_import/current`.



### Subdivisions

The following diagram shows the structure and relationships of the geographical subdivisions and voting jurisdictions.
Note that the PSGC is not used here.

![Geographical subdivisions][image_geo]

\clearpage



### Poll Monitoring

The following diagram shows how the poll monitoring information has been structured.

![Operations][image_operations]

Note that the `target` column of the _precinct monitor_ table does not hold a percentage value.
The percentage value from the _import table_ is converted to an actual value using the utility function `get_percentage_value`.

[image_geo]: ./erd_geo.svg {width=400}
[image_operations]: ./erd_operations.svg {width=430}



## Major Functions

This section discusses the major functionalities of the system.



### Importing Source Data Files

Pre-Election Poll Monitoring System imports source data file(s) like geographical subdivisions, voting jurisdictions, number of registered voters and campaign leaders.

Maintainer imports the source data file(s) once on system setup.

!uml(images/pp-import-data.svg {width=550})(Import Source Data File(s))
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Import\nProgram" : import source data file(s)
"Import\nProgram" -> "Poll Database" : insert data into source import table
"Poll Database" -> "Poll Database" : distribute data from import table\ninto geographical subdivisions,\nvoting jurisdictions and\npoll monitoring tables.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The source data files are expected to be read from the import subdirectories `<project>/_data/to_import/...` and imported into PostgreSQL database using the `import.sh` driver script in the scripts directory `<project>/_scripts`. It is assumed that `region.csv` is in the `region` sub-directory, `province.csv` is in the `province` sub-directory and the district CSV files are in the `district` sub-directory.

See the [Project Files section](#section-project-files) for more details on the project directory structure.



### Add In-Favor Message

Leader sends an SMS message to the Message Receiver.
The message denotes an In-Favor information for the candidate.
The Messager Receiver is expected to receive many SMS messages and collects them until some event is reached.
The event may be a certain cut-off time, a number of messages, or just manual intervention.

!uml(images/pp-send-in-favor-message.svg {width=220})(Send In-Favor Message)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Leader -> "Message\nReceiver" : send In-Favor message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



### Update Poll Database

The maintainer updates the poll database with the latest received messages from the Message Receiver collection.

!uml(images/pp-update-poll-database.svg {width=500})(Update Poll Database)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Message\nReceiver" : fetch set of messages
Maintainer <- "Message\nReceiver" : messages
Maintainer -> "Import\nProgram" : update(messages)
"Import\nProgram" -> "Poll Database" : save to temporary table
"Import\nProgram" -> "Poll Database" : call validation procedure

alt Valid Messages

    "Import\nProgram" -> "Poll Database" : Call update procedure

else

    "Poll Database" -> "Import\nProgram" : Error: Invalid messages
    "Import\nProgram" -> "Maintainer" : Error: Invalid messages

end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\



### Exporting Data as JSON Files

To build these HTML files, Jekyll reads the JSON files in the data directory `<project>/_data`.
The following diagram shows the sequence of events and operations performed.

!uml(images/pp-create-json-files.svg {width=280})(Create JSON Files)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Create JSON\nProgram" : call
"Create JSON\nProgram" -> "Poll Database" : run queries
"Create JSON\nProgram" -> Maintainer : JSON files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



\clearpage



### Updating Local HTML Pages

The static web pages are automatically re-generated by Jekyll if one of the files have changed.
Also, the static web pages are re-generated every time Jekyll is executed.

!uml(images/pp-update-local-html-pages.svg {width=150})(Update Local HTML Pages)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Jekyll" : run jekyll
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Updating Remote HTML Pages

The static web pages are automatically re-generated in the remote site when the project files are uploaded.

!uml(images/pp-update-remote-project-files.svg {width=430})(Update Remote Project Files)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Git" : git push
"Git\nProgram" -> "Remote Site" : git sends the project\nfiles to the remote site

alt Success

    "Remote Site" -> "Remote Site" : (re)generate HTML files

else

    "Remote Site" -> "Maintainer" : remote site sends email\nnotification about failure

end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If there is an error with the file generation in the remote site, the remote site will send an email notification of the event and information regarding the failure.



## Minor Functions

This section discusses the minor functionalities supporting the use of the system.



### Assign Precinct Leader

Maintainer attempts to put a precinct voting jurisdiction under a leader's management.
Each precinct can only be under one leader.
Therefore, if the precinct is already under any other leader's management, the attempt fails.
Otherwise, the attempt succeeds and the precinct now belongs to the leader's management.

\clearpage

!uml(images/pp-assign-precinct-leader.svg {width=460})(Assign Precinct Leader)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maintainer -> "Data Manager\nProgram" : Assign(leader id, precinct)
"Data Manager\nProgram" -> "Poll Database" : is valid (leader id, precint)

alt Valid Parameters

    "Data Manager\nProgram" -> "Poll Database" : add (leader id, precint)
    "Data Manager\nProgram" <- "Poll Database" : success

else

    "Data Manager\nProgram" -> Maintainer : Error: Invalid parameters

end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To assign a precinct to a leader, use the data management script.




\clearpage
