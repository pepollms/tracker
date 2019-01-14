#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Input file argument missing."
    exit
fi

input_file=$(basename "$1")
shift 1
input_extension="${input_file##*.}"
input_filename="${input_file%.*}"
output_file=${input_filename}-us.pdf

./build_main.sh                         \
    -i $input_file                      \
    -t template_doc_us.tex              \
    -o $output_file                     \
    $*

echo "Done."
