#!/usr/bin/env bash

input_file="source.md"
template_file="template.tex"
output_file="output.pdf"

#
# Display script usage
#
function show_usage() {
    echo "Build script for converting markdown to PDF using LaTeX."
    echo "Usage:"
    echo "  $(basename $0) [option ...]"
    echo "Options:"
    echo "  -h         print help and exit"
    echo "  -i <file>  source markdown file"
    echo "  -t <file>  latex template file"
    echo "  -o <file>  output pdf file"
}

# ==============================

if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" = "--help" ]; then
    show_usage
    exit
fi

while getopts :hi:t:o: OPTION; do
    case $OPTION in
        h)      show_usage
                exit
                ;;
        i)      input_file="$OPTARG"
                ;;
        t)      template_file="$OPTARG"
                ;;
        o)      output_file="$OPTARG"
                ;;
        \:)     printf "argument missing from -%s option\n" $OPTARG
                show_usage
                exit 2
                ;;
        \?)     show_usage
                exit 2
                ;;
    #esac >&2
    esac
done
shift $(($OPTIND - 1))

echo "Build arguments:"
echo "  Input:    $input_file"
echo "  Template: $template_file"
echo "  Output:   $output_file"

if [ $# -gt 0 ]; then
    printf "Unknown arguments: %s\n" "$*"
    echo   "Aborting."
    exit
fi

# Other arguments to pandoc:
#
#   --pdf-engine=[pdflatex | xelatex]
#   --verbose
#     Give verbose debugging output. Currently this only has an effect
#     with PDF output.
#   --log=FILE
#     Write log messages in machine-readable JSON format to
#     FILE. All messages above DEBUG level will be written,
#     regardless of verbosity settings (--verbose, --quiet).

pandoc  ${input_file}                   \
        --template=${template_file}     \
        -f markdown+raw_tex+fenced_code_blocks+footnotes   \
        -t latex                        \
        -o ${output_file}               \
        --pdf-engine=pdflatex           \
        --toc                           \
        --top-level-division=chapter    \
        --listing

echo "Done."
