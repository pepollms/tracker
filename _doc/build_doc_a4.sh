#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Pass the input document."
    exit
fi

input_file=$(basename "$1")
shift 1
input_extension="${input_file##*.}"
input_filename="${input_file%.*}"
output_file=${input_filename}.pdf

echo "Running document build script..."
echo "Input: $input_file"
echo "Output: $output_file"

./build.sh                              \
    -i $input_file                      \
    -t template_doc_a4_20190110.tex     \
    -o $output_file                     \
    $*

echo "Done."
