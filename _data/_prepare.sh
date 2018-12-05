#!/usr/bin/env bash

declare -r PROGRAM_NAME="$0"

declare debug=0

function show_usage {
    echo "$PROGRAM_NAME - Prepare data importing."
    echo "Copyright (C) 2016 Ricky Maicle rmaicle@gmail.com"
    echo "This is free software; see the source for copying conditions."
    echo "There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR"
    echo "A PARTICULAR PURPOSE."
    echo ""
    echo "Prepare the comma-separated values (CSV) files before being imported"
    echo "into a PostgreSQL database import table. The files will be imported"
    echo "from the directory:"
    echo ""
    echo "  <project>/database/to_import/"
    echo ""
    echo "Directory structure:"
    echo "  <project>/database"
    echo "  <project>/database/to_import"
    echo "  <project>/database/to_import/<date>"
    echo "  <project>/source"
    echo "  <project>/source/<site>"
    echo "  <project>/source/<site>/_data"
    echo ""
    echo "Usage: $PROGRAM_NAME [--help] [--debug] -d <directory>"
    echo ""
} # show_usage

# Echo messages when in debug mode only
function echo_debug {
    if [ $# -eq 0 ]; then
        echo "Debug: Message to display is missing."
        return 1
    fi
    if [ $debug -eq 1 ]; then
        echo "Debug: $1"
    fi
    return 0
}

# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: $1"
    echo "-----"
}

if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

if [ "$1" == "--debug" ]; then
    debug=1
    shift 1
fi

arg_directory=""
if [ "$1" == "-d" ]; then
    arg_directory="$2"
    shift 2
fi

if [ -z "$arg_directory" ]; then
    echo_err "Directory is empty."
    exit 1
fi

if [ ! -d "../../../database/to_import/${arg_directory}" ]; then
    echo_err "Directory ../../../database/to_import/${arg_directory} does not exist."
    exit 1
fi

echo "Prepare the comma-separated values (CSV) files before being imported"
echo "into a PostgreSQL database import table. The files will be imported"
echo "from the directory:"
echo "  ../../../database/to_import/${arg_directory}"
echo ""

echo_debug "Mode: Debug"

# Make sure CSV files are readable
chmod 777 ../../../database/to_import/${arg_directory}/district_1.csv
chmod 777 ../../../database/to_import/${arg_directory}/district_2.csv
chmod 777 ../../../database/to_import/${arg_directory}/district_3.csv
echo_debug "CSV files file mode changed."

#sed -i 's/1ST/1/g' ../../../database/to_import/district_1.csv
#sed -i 's/2ND/2/g' ../../../database/to_import/district_2.csv
#sed -i 's/3RD/3/g' ../../../database/to_import/district_3.csv
#echo_debug "Replace district names"

#j Copy files to destination directory
destination_dir="../../../database/to_import"
cp -f ../../../database/to_import/${arg_directory}/district_1.csv ${destination_dir}/district_1.csv
cp -f ../../../database/to_import/${arg_directory}/district_2.csv ${destination_dir}/district_2.csv
cp -f ../../../database/to_import/${arg_directory}/district_3.csv ${destination_dir}/district_3.csv
echo_debug "Files copied to ${destination_dir}."

# Remove the percent sign after the number at the end of each line
sed -i 's/%$//' ../../../database/to_import/district_1.csv
sed -i 's/%$//' ../../../database/to_import/district_2.csv
sed -i 's/%$//' ../../../database/to_import/district_3.csv
echo_debug "Remove the percentage symbol in the target percentage column."

echo "Done."
