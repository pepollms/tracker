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



function create_file {
    if [ $# -eq 0 ]; then
        echo "Missing file and content parameters."
        return 1
    fi
    local -r file="$1"
    shift 1
    local content=""
    if [ $# -eq 1 ]; then
        content="$1"
        shift 1
    fi
    echo -e ${content} > "${file}"
}

function create_district_markdown_files {
    local -r SQL="select count(*) from vt_district;"
    local -r count=`psql -d postgres -w --tuples-only --no-align -c "${SQL}"`
    echo "  District markdown files: ${count}"
    # Use three-expression bash for loops syntax which share a common heritage
    # with the C programming language. It is characterized by a three-parameter
    # loop control expression; consisting of an initializer (EXP1), a loop-test
    # or condition (EXP2), and a counting expression (EXP3).
    # Ref: https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
    local -r start=1
    local -r end=$((count + 0))
    file=""
    content=""
    for (( i=$start; i<=$end; i++ )); do
        content=""`
            `"---\n"`
            `"layout: district\n"`
            `"district_id: ${i}\n"`
            `"---"
        file="${DISTRICT_MARKDOWN_FILE_DIR}/district_${i}.md"
        echo -e ${content} > "${file}"
    done
}

function create_municipality_markdown_files {
    local -r SQL="select count(*) from vt_municipality;"
    local count=`psql -d postgres -w --tuples-only --no-align -c "${SQL}"`
    echo "  Municipality markdown files: ${count}"
    local -r start=1
    local -r end=$((count + 0))
    file=""
    content=""
    for (( i=$start; i<=$end; i++ )); do
        content=""`
            `"---\n"`
            `"layout: municipality\n"`
            `"municipality_id: ${i}\n"`
            `"---"
        file="${MUNICIPAL_MARKDOWN_FILE_DIR}/municipality_${i}.md"
        echo -e ${content} > "${file}"
    done
}

function create_barangay_markdown_files {
    local -r SQL="select count(*) from vt_barangay;"
    local count=`psql -d postgres -w --tuples-only --no-align -c "${SQL}"`
    echo "  Barangay markdown files: ${count}"
    local -r start=1
    local -r end=$((count + 0))
    file=""
    content=""
    for (( i=$start; i<=$end; i++ )); do
        content=""`
            `"---\n"`
            `"layout: barangay\n"`
            `"barangay_id: ${i}\n"`
            `"---"
        file="${BARANGAY_MARKDOWN_FILE_DIR}/barangay_${i}.md"
        echo -e ${content} > "${file}"
    done
}

function create_leader_markdown_files {
    local -r SQL="select count(*) from vt_leader;"
    local count=`psql -d postgres -w --tuples-only --no-align -c "${SQL}"`
    echo "  Leader markdown files: ${count}"
    local -r start=1
    local -r end=$((count + 0))
    file=""
    content=""
    for (( i=$start; i<=$end; i++ )); do
        content=""`
            `"---\n"`
            `"layout: leader\n"`
            `"leader_id: ${i}\n"`
            `"---"
        file="${DISTRICT_MARKDOWN_FILE_DIR}/leader_${i}.md"
        echo -e ${content} > "${file}"
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
        shift 1
        if [ $# -eq 0 ]; then
            arg_mock_data_file="precinct_monitor_data.sql"
        else
            arg_mock_data_file="$1"
            shift 1
        fi
        if [ -z "${arg_mock_data_file}" ]; then
            arg_mock_data_file="precinct_monitor_data.sql"
        fi
        if [ ! -e ./sql/mock/${arg_mock_data_file} ]; then
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

    psql -d postgres -w -f ./sql/import/region.sql
    psql -d postgres -w -f ./sql/import/province.sql

    #
    # Create the SQL files for importing the district level data.
    #

    # Make sure the district import directory is empty
    district_source_dir="../_data/to_import/district"
    district_dest_dir="./sql/import"
    district_files=$(find ${district_source_dir}/ -maxdepth 1 -iname "*.csv")
    echo "Import District Files:"
    echo "${district_files}"
    readarray -t files <<<"${district_files}"
    IFS=$'\n' files=($(sort <<<"${files[*]}"))
    unset IFS
    sql_district_files=()
    for file in ${files[@]}; do
        filename=$(basename ${file})
        sql_file="${district_dest_dir}/${filename%.*}.sql"
        echo "Creating ${sql_file}."
        sql_district_files+="${sql_file}"
        district_file_content=""`
            `"\\COPY vt_import("`
            `" province,"`
            `" district,"`
            `" municipality,"`
            `" municipality_code,"`
            `" barangay,"`
            `" precinct,"`
            `" voters,"`
            `" leader,"`
            `" contact,"`
            `" target) FROM '${file}' DELIMITER ',' CSV HEADER ENCODING 'UTF8';"
        create_file ${sql_file} "${district_file_content}"
        echo "Executing ${sql_file}."
        psql -d postgres -w -f ${sql_file}
    done

    echo "Processing imported data."
    psql -d postgres -w -f ./sql/process_import.sql
    echo "Done."
fi

if [ ${op_generate_mock_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    echo "Generate mock data using ${arg_mock_data_file}."
    psql -d postgres -w -f ./sql/mock/${arg_mock_data_file}
    echo "Done."
fi

if [ ${op_create_markdown} -eq 1 ]; then
    echo "Create markdown files:"
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    # Make sure destination directories exists
    if [ ! -d ${DISTRICT_MARKDOWN_FILE_DIR} ]; then
        echo "Create <project>/districts directory."
        mkdir ${DISTRICT_MARKDOWN_FILE_DIR}
    fi
    create_district_markdown_files

    if [ ! -d ${MUNICIPAL_MARKDOWN_FILE_DIR} ]; then
        echo "Create <project>/municipalities directory."
        mkdir ${MUNICIPAL_MARKDOWN_FILE_DIR}
    fi
    create_municipality_markdown_files

    if [ ! -d ${BARANGAY_MARKDOWN_FILE_DIR} ]; then
        echo "Create <project>/barangays directory."
        mkdir ${BARANGAY_MARKDOWN_FILE_DIR}
    fi
    create_barangay_markdown_files

    #if [ ! -d ${LEADER_MARKDOWN_FILE_DIR} ]; then
    #    echo "Create ${LEADER_MARKDOWN_FILE_DIR}"
    #    mkdir ${LEADER_MARKDOWN_FILE_DIR}
    #fi
    #create_leader_markdown_files
fi

echo "Done (${PROGRAM_NAME})."
exit 0
