#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"
declare -r PROJECT_ROOT=".."
declare -r IMPORT_DIR="${PROJECT_ROOT}/_data/to_import"
declare -r DISTRICT_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/districts"
declare -r MUNICIPAL_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/municipalities"
declare -r BARANGAY_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/barangays"

declare debug=0

declare op_prepare=0
declare op_create_db=0
declare op_import_data=0
declare op_generate_dummy_data=0
declare op_create_markdown=0

function show_usage {
    echo "$PROGRAM_NAME - Import data from a CSV file."
    echo ""
    echo "Prepare and import the comma-separated values (CSV) files into a"
    echo "PostgreSQL database. The CSV files will be read from the following"
    echo "directory:"
    echo ""
    echo "  <project>/_data/to_import"
    echo ""
    echo "Generated files will be created in the following directories:"
    echo ""
    echo "  <project>/districts"
    echo "  <project>/municipalities"
    echo "  <project>/barangays"
    echo ""
    echo "Usage: $PROGRAM_NAME [options]"
    echo ""
    echo "Options in sequential order:"
    echo "  --help                  Show usage help text"
    echo "  --prepare               Prepare CSV files and copy to import directory"
    echo "  --create-db             Recreate database objects"
    echo "  --import                Import data from CSV files"
    echo "  --dummy <file>          Run <file> to generate dummy data"
    echo "  --create-markdown       Create markdown files"
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
} # echo_debug

# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: $1"
    echo "-----"
} # echo_err



function create_district_markdown_file {
    if [ $# -eq 0 ]; then
        echo "Missing district id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: district\n"
    contents+="district_id: ${arg_id}\n"
    contents+="---"
    local file="${DISTRICT_MARKDOWN_FILE_DIR}/district_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

function create_district_markdown_files {
    local count=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_district;"`
    # Use three-expression bash for loops syntax which share a common heritage
    # with the C programming language. It is characterized by a three-parameter
    # loop control expression; consisting of an initializer (EXP1), a loop-test
    # or condition (EXP2), and a counting expression (EXP3).
    # Ref: https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
    local start=1
    local end=$((count + 0))
    for (( i=$start; i<=$end; i++ )); do
        create_district_markdown_file $i
    done
}

function create_municipality_markdown_file {
    if [ $# -eq 0 ]; then
        echo "Missing municipality id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: municipality\n"
    contents+="municipality_id: ${arg_id}\n"
    contents+="---"
    local file="${MUNICIPAL_MARKDOWN_FILE_DIR}/municipality_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

function create_municipality_markdown_files {
    local count=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_municipality;"`
    local start=1
    local end=$((count + 0))
    for (( i=$start; i<=$end; i++ )); do
        create_municipality_markdown_file $i
    done
}


function create_barangay_markdown_file {
    if [ $# -eq 0 ]; then
        echo "Missing barangay id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: barangay\n"
    contents+="barangay_id: ${arg_id}\n"
    contents+="---"
    local file="${BARANGAY_MARKDOWN_FILE_DIR}/barangay_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

function create_barangay_markdown_files {
    local count=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_barangay;"`
    local start=1
    local end=$((count + 0))
    for (( i=$start; i<=$end; i++ )); do
        create_barangay_markdown_file $i
    done
}

function create_leader_markdown_file {
    if [ $# -eq 0 ]; then
        echo "Missing leader id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: leader\n"
    contents+="leader_id: ${arg_id}\n"
    contents+="---"
    local file="${LEADER_MARKDOWN_FILE_DIR}/leader_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

function create_leader_markdown_files {
    local count=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader;"`
    local start=1
    local end=$((count + 0))
    for (( i=$start; i<=$end; i++ )); do
        create_leader_markdown_file $i
    done
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
if [ "$1" == "--prepare" ]; then
    if [ ! -d "${IMPORT_DIR}" ]; then
        echo_err "Import directory does not exist: ${IMPORT_DIR}"
        exit 1
    fi
    op_prepare=1
    op_create_db=1
    op_import_data=1
    op_create_markdown=1
fi

if [ "$1" == "--create-db" ]; then
    op_create_db=1
    op_import_data=1
    op_create_markdown=1
fi

if [ "$1" == "--import" ]; then
    op_import_data=1
    op_create_markdown=1
fi

arg_dummy_data_file=""
if [ "$1" == "--dummy" ]; then
    arg_dummy_data_file="$2"
    shift 2
    if [ ! -e ${arg_dummy_data_file} ]; then
        echo "Dummy data generation file not found: '${arg_dummy_data_file}'."
        exit 1
    fi
    op_generate_dummy_data=1
fi

if [ "$1" == "--create-markdown" ]; then
    op_create_markdown=1
fi



#-------------------------------------------------------------------------------



if [ ${op_prepare} -eq 1 ]; then
    # Make sure CSV files are readable
    chmod 777 ${IMPORT_DIR}/district_1.csv
    chmod 777 ${IMPORT_DIR}/district_2.csv
    chmod 777 ${IMPORT_DIR}/district_3.csv
    echo_debug "CSV files file mode changed."

    # Delete files from destination directory
    destination_dir="${IMPORT_DIR}/converted"
    if [ ! -d ${destination_dir} ]; then
        mkdir ${destination_dir}
    else
        rm -f ${destination_dir}/district_1.csv
        rm -f ${destination_dir}/district_2.csv
        rm -f ${destination_dir}/district_3.csv
    fi

    # Convert to UTF-8 files and copy to import directory
    iconv -f UTF-8 -t UTF-8 ${IMPORT_DIR}/district_1.csv -o ${destination_dir}/district_1.csv
    iconv -f UTF-8 -t UTF-8 ${IMPORT_DIR}/district_2.csv -o ${destination_dir}/district_2.csv
    iconv -f UTF-8 -t UTF-8 ${IMPORT_DIR}/district_3.csv -o ${destination_dir}/district_3.csv

    echo_debug "Files copied to ${destination_dir}."

    current_dir=`pwd`
    cd ${destination_dir}
    # Display file encodings
    file -i district_1.csv district_2.csv district_3.csv
    cd ${current_dir}

    echo "Done preparing CSV files."
fi

if [ ${op_create_db} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Create database objects."
    psql -d postgres -w -f create_database.sql
    echo "Done."
fi

if [ ${op_import_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Import data."
    psql -d postgres -w -f import.sql
    echo "Done."
fi

if [ ${op_generate_dummy_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Generate dummy data."
    psql -d postgres -w -f ${arg_dummy_data_file}
    echo "Done."
fi

if [ ${op_create_markdown} -eq 1 ]; then
    # Make sure destination directories exists
    if [ ! -d ${DISTRICT_MARKDOWN_FILE_DIR} ]; then
        echo "Create ${DISTRICT_MARKDOWN_FILE_DIR}"
        mkdir ${DISTRICT_MARKDOWN_FILE_DIR}
    fi
    if [ ! -d ${MUNICIPAL_MARKDOWN_FILE_DIR} ]; then
        echo "Create ${MUNICIPAL_MARKDOWN_FILE_DIR}"
        mkdir ${MUNICIPAL_MARKDOWN_FILE_DIR}
    fi
    if [ ! -d ${BARANGAY_MARKDOWN_FILE_DIR} ]; then
        echo "Create ${BARANGAY_MARKDOWN_FILE_DIR}"
        mkdir ${BARANGAY_MARKDOWN_FILE_DIR}
    fi
    if [ ! -d ${LEADER_MARKDOWN_FILE_DIR} ]; then
        echo "Create ${LEADER_MARKDOWN_FILE_DIR}"
        mkdir ${LEADER_MARKDOWN_FILE_DIR}
    fi

    create_district_markdown_files
#    create_municipality_markdown_files
#    create_barangay_markdown_files
#    create_leader_markdown_files
fi

exit 0
