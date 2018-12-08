#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare debug=0

function show_usage {
    echo "$PROGRAM_NAME - Prepare executable scripts."
    echo ""
    echo "Make all shell scripts are executable."
    echo ""
    echo "Usage: $PROGRAM_NAME [--help]"
    echo ""
} # show_usage

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

echo "Make all shell scripts are executable."

chmod +x _dm.sh
chmod +x _prepare_import.sh
chmod +x _import.sh
chmod +x _create_all.sh

echo "Data manipulation: _dm.sh"
echo "Data import preparation: _prepare_import.sh"
echo "Data import: _import.sh"
echo "JSON data file creation: _create_all.sh"

echo "Done."

