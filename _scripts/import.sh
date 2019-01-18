#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"
declare -r PROJECT_ROOT=".."
declare -r IMPORT_DIR="${PROJECT_ROOT}/_data/to_import"
declare -r DISTRICT_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/districts"
declare -r MUNICIPAL_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/municipalities"
declare -r BARANGAY_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/barangays"

declare -r CMD_HELP="--help"
declare -r CMD_DEBUG="--debug"
declare -r CMD_CREATE_DB="--create-db"
declare -r CMD_IMPORT="--import"
declare -r CMD_MOCK="--mock"
declare -r CMD_CREATE_MARKDOWN="--create-markdown"

declare -r COMMANDS=(
    "${CMD_CREATE_DB}"
    "${CMD_IMPORT}"
    "${CMD_MOCK}"
    "${CMD_CREATE_MARKDOWN}"
)

declare debug=0
declare op_create_db=0
declare op_import_data=0
declare op_generate_mock_data=0
declare op_create_markdown=0

function show_usage {
    echo "Import data from a CSV file."
    echo ""
    echo "Import the comma-separated values (CSV) files into a PostgreSQL"
    echo "database. The CSV files will be read from:"
    echo ""
    echo "  <project>/_data/to_import"
    echo ""
    echo "Generated markdown files will be created in:"
    echo ""
    echo "  <project>/districts"
    echo "  <project>/municipalities"
    echo "  <project>/barangays"
    echo ""
    echo "Usage: $PROGRAM_NAME [options]"
    echo ""
    echo "Options in sequential order:"
    echo "  ${CMD_HELP}                  Show usage help text"
    echo "  ${CMD_CREATE_DB}             Recreate database objects"
    echo "  ${CMD_IMPORT}                Import data from CSV files"
    echo "  ${CMD_MOCK} <file>           Run <file> to generate mock data"
    echo "  ${CMD_CREATE_MARKDOWN}       Create markdown files"
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
    echo "  District markdown files: ${count}"
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
    echo "  Municipality markdown files: ${count}"
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
    echo "  Barangay markdown files: ${count}"
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
    echo "  Leader markdown files: ${count}"
    local start=1
    local end=$((count + 0))
    for (( i=$start; i<=$end; i++ )); do
        create_leader_markdown_file $i
    done
}



if [ $# -eq 0 ]; then
    op_create_db=1
    op_import_data=1
    op_create_markdown=1
fi

if [ "$1" == "${CMD_HELP}" ]; then
    show_usage
    exit
fi

if [ "$1" == "${CMD_DEBUG}" ]; then
    debug=1
    shift 1
fi

arg_mock_data_file=""
while [ $# -gt 0 ] && [[ "${COMMANDS[@]}" =~ "${1}" ]]; do
    if [ "${1}" == "${CMD_CREATE_DB}" ]; then
        op_create_db=1
        shift 1
    elif [ "${1}" == "${CMD_IMPORT}" ]; then
        op_import_data=1
        shift 1
    elif [ "$1" == "${CMD_MOCK}" ]; then
        arg_mock_data_file="$2"
        shift 2
        if [ ! -e ${arg_mock_data_file} ]; then
            echo "Mock data script file not found: '${arg_mock_data_file}'."
            exit 1
        fi
        op_generate_mock_data=1
    elif [ "$1" == "${CMD_CREATE_MARKDOWN}" ]; then
        op_create_markdown=1
        shift 1
    fi
done



#-------------------------------------------------------------------------------



if [ ${op_create_db} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Create database objects."
    psql -d postgres -w -f ./sql/create_base_tables.sql
    psql -d postgres -w -f ./sql/create_utility_functions.sql
    psql -d postgres -w -f ./sql/create_monitor_views.sql
    psql -d postgres -w -f ./sql/create_dm_functions.sql
    echo "Done."
fi

if [ ${op_import_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Import from source data files"
    psql -d postgres -w -f ./sql/import.sql
    psql -d postgres -w -f ./sql/process_import.sql
    echo "Done."
fi

if [ ${op_generate_mock_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Generate mock data."
    psql -d postgres -w -f ./sql/mock/${arg_mock_data_file}
    echo "Done."
fi

if [ ${op_create_markdown} -eq 1 ]; then
    echo "Create markdown files:"
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
    create_municipality_markdown_files
    create_barangay_markdown_files
#    create_leader_markdown_files
fi

exit 0
