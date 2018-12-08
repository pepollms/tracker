#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare debug=0

function show_usage {
    echo "$PROGRAM_NAME - Prepare executable scripts."
    echo ""
    echo "Make all shell scripts executable."
    echo ""
    echo "Usage: $PROGRAM_NAME [--help]"
    echo ""
} # show_usage

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

echo "Make all shell scripts executable."

chmod +x import.sh
chmod +x create_json_all.sh
chmod +x dm.sh

echo "Data import: import.sh"
echo "JSON data file creation: create_json_all.sh"
echo "Data manipulation: dm.sh"

echo "Done."
