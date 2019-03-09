#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"
declare -r PROJECT_ROOT=".."
declare -r IMPORT_DIR="${PROJECT_ROOT}/_data/to_import"

declare -r IMPORT_SOURCE_DIR="${IMPORT_DIR}/district"
declare -r IMPORT_CURRENT_DIR="${IMPORT_DIR}/current"
declare -r DISTRICT_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/districts"
declare -r MUNICIPAL_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/municipalities"
declare -r BARANGAY_MARKDOWN_FILE_DIR="${PROJECT_ROOT}/barangays"

declare -r CMD_HELP="--help"
declare -r CMD_DEBUG="--debug"
declare -r CMD_INIT="--init"
declare -r CMD_CREATE_DB="--create-db"
declare -r CMD_IMPORT="--import"
declare -r CMD_MOCK="--mock"
declare -r CMD_CREATE_MARKDOWN="--create-markdown"

declare -r COMMANDS=(
    "${CMD_INIT}"
    "${CMD_CREATE_DB}"
    "${CMD_IMPORT}"
    "${CMD_MOCK}"
    "${CMD_CREATE_MARKDOWN}"
)

declare debug=0
declare op_create_db=0
declare op_import_source_data=0
declare op_import_current_data=0
declare op_generate_mock_data=0
declare op_create_markdown=0

function show_usage {
    echo "Import source/current data from a comma-separated values (CSV) file."
    echo ""
    echo "Usage: $PROGRAM_NAME [options]"
    echo ""
    echo "Options in sequential order:"
    echo "  ${CMD_HELP}                         Show usage help text"
    echo "  ${CMD_INIT} [options]               Initialize the system"
    echo "    [-no-json]                          Do not create JSON files"
    echo "    [-no-git]                           Do not run git commands"
    echo "    [-y]                                Skip confirmation step"
    echo "  ${CMD_CREATE_DB}                    Recreate database objects"
    echo "  ${CMD_IMPORT} [source | current]    Import data from CSV files"
    #echo "  ${CMD_MOCK} <file>                  Run <file> to generate mock data"
    echo "  ${CMD_MOCK} <from> [to]             Generate in-favor mock data"
    echo "      from|to: -a n | -p x m       where n and m is any number, x is 0..100"
    echo "  ${CMD_CREATE_MARKDOWN}              Create markdown files"
    echo ""
    echo "Import CSV source data files into PostgreSQL database."
    echo "The CSV files will be read from:"
    echo ""
    echo "  <project>/_data/to_import/district"
    echo ""
    echo "Import CSV current data files into PostgreSQL database."
    echo "The CSV files will be read from:"
    echo ""
    echo "  <project>/_data/to_import/current"
    echo ""
    echo "Generated markdown files will be created in:"
    echo ""
    echo "  <project>/districts"
    echo "  <project>/municipalities"
    echo "  <project>/barangays"
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
    shift
    local content=""
    if [ $# -eq 1 ]; then
        content="$1"
        shift
    fi
    echo -e "${content}" > "${file}"
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
        echo -e "${content}" > "${file}"
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
        echo -e "${content}" > "${file}"
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
        echo -e "${content}" > "${file}"
    done
}



if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" == "${CMD_HELP}" ]; then
    show_usage
    exit
fi

if [ "$1" == "${CMD_DEBUG}" ]; then
    debug=1
    shift
fi

mock_data_ccolumn="vt_precinct_monitor.target"
mock_data_lb="1"
mock_data_ub="vt_precinct_monitor.target::integer"
init_do_json=1
init_do_git=1
while [ $# -gt 0 ] && [[ "${COMMANDS[@]}" =~ "${1}" ]]; do
    if [ "${1}" == "${CMD_INIT}" ]; then
        shift

        if [ "${1}" == "-no-json" ]; then
            shift
            init_do_json=0
        fi
        if [ "${1}" == "-no-git" ]; then
            shift
            init_do_git=0
        fi

        if [ "${1}" == "-y" ]; then
            shift
            op_create_db=1
            op_import_source_data=1
            op_create_markdown=1
            break
        else
            echo ""
            echo "System initialization is only performed during system startup."
            echo "It will destroy all existing data in the current database."
            echo ""
            echo "The following operations will be performed:"
            echo "  1. Create database"
            echo "  2. Import source data"
            echo "  3. Create markdown files"
            echo ""
            echo "Do you want to initialize the system?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )   op_create_db=1
                            op_import_source_data=1
                            op_create_markdown=1
                            break ;;
                    No )    exit ;;
                esac
            done
        fi
    elif [ "${1}" == "${CMD_CREATE_DB}" ]; then
        op_create_db=1
        shift
    elif [ "${1}" == "${CMD_IMPORT}" ]; then
        shift
        if [ $# -eq 0 ]; then
            echo "Missing --import parameter"
            exit 1
        else
            if [ "${1}" == "source" ]; then
                op_import_source_data=1
            elif [ "${1}" == "current" ]; then
                op_import_current_data=1
            fi
            shift
            if [ "${1}" == "-no-json" ]; then
                shift
                init_do_json=0
            fi
            if [ "${1}" == "-no-git" ]; then
                shift
                init_do_git=0
            fi
        fi
    elif [ "$1" == "${CMD_MOCK}" ]; then
        shift
        op_generate_mock_data=1
        if [ $# -eq 0 ]; then
            continue
        fi
        if [ "${1}" == "-a" ]; then
            mock_data_lb="least($2, $mock_data_ccolumn)::integer"
            shift 2
        elif [ "${1}" == "-p" ]; then
            mock_data_lb="get_percentage_value($2, least($3, $mock_data_ccolumn))"
            shift 3
        fi
        if [ $# -eq 0 ]; then
            continue
        fi
        if [ "${1}" == "-a" ]; then
            mock_data_ub="least($2, $mock_data_ccolumn)::integer"
            shift 2
        elif [ "${1}" == "-p" ]; then
            mock_data_ub="get_percentage_value($2, least($3, $mock_data_ccolumn))"
            shift 3
        fi
    elif [ "$1" == "${CMD_CREATE_MARKDOWN}" ]; then
        op_create_markdown=1
        shift
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
    echo "----------"
    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/create_base_tables.sql)
    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/create_utility_functions.sql)
    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/create_monitor_views.sql)
    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/create_dm_functions.sql)
    echo "Database objects has been created."
    echo "----------"
fi

if [ ${op_import_source_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    if [ ! -e "${IMPORT_SOURCE_DIR}" ]; then
        echo "Source data import directory does not exist: '${IMPORT_SOURCE_DIR}'."
        exit 1
    fi

    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/import/region.sql)
    $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/import/province.sql)

    #
    # Create the SQL files for importing the district level data.
    #

    # Make sure the district import directory is empty
    district_dest_dir="./sql/import"
    district_files=$(find ${IMPORT_SOURCE_DIR}/ -maxdepth 1 -iname "*.csv")
    readarray -t files <<<"${district_files}"
    IFS=$'\n' files=($(sort <<<"${files[*]}"))
    unset IFS
    if (( "${#files[@]}" )); then
        echo "Import source data files:"
        echo "${files}"
        sql_district_files=()
        for file in ${files[@]}; do
            filename=$(basename ${file})
            sql_file="${district_dest_dir}/${filename%.*}.sql"
            echo_debug "Creating ${sql_file}."
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
            echo_debug "Executing ${sql_file}."
            # Suppress messages
            # https://stackoverflow.com/questions/3530767/disable-notices-in-psql-output
            $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ${sql_file})
            echo "Import done."
        done

        echo "----------"
        ./dq.sh count-import district
        ./dq.sh count-import municipality
        ./dq.sh count-import barangay
        #./dq.sh count-import precinct
        ./dq.sh count-import leader
        ./dq.sh voter-import
        echo "----------"

#        echo "Checking imported data."
#        psql -d postgres -w -q -f ./sql/check_import.sql
#        echo "Source data has been checked."

        echo "Processing imported data."
        #psql -d postgres -w -q -f ./sql/process_import.sql
        $(psql -X -q -v ON_ERROR_STOP=1 -d postgres -w -f ./sql/process_import.sql)
        echo "Source data has been imported."

        if [ ${init_do_json} -eq 1 ]; then
            echo "Creating JSON files."
            ./create_json.sh
            echo "JSON files created."
        fi

        if [ ${init_do_git} -eq 1 ]; then
            echo "Store changes to Git repository."
            git add ../_data/to_import/district/*.csv
            git add ../_data/*.json
            git commit -m "Update JSON files"
            echo "Changes stored in local Git repository."

            echo "Synchronize remote repository."
            git push
            echo "Remote repository synchronized."
        fi
    else
        echo "No import files found."
    fi
fi

if [ ${op_import_current_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
    if [ ! -e "${IMPORT_CURRENT_DIR}" ]; then
        echo "In-favor data import directory does not exist: '${IMPORT_CURRENT_DIR}'."
        exit 1
    fi
    current_dest_dir="./sql/import"
    current_files=$(find ${IMPORT_CURRENT_DIR}/ -maxdepth 1 -iname "*.csv")
    readarray -t files <<<"${current_files}"
    IFS=$'\n' files=($(sort <<<"${files[*]}"))
    unset IFS
    if (( "${#files[@]}" )); then
        echo "Importing ${#files[@]} files:"
        echo "${files}"
        sql_current_files=()
        for file in ${files[@]}; do
            filename=$(basename ${file})
            sql_file="${current_dest_dir}/${filename%.*}.sql"
            echo "Creating ${sql_file}."
            sql_current_files+="${sql_file}"
            current_file_content=""`
                `"\\COPY vt_import_current("`
                `" municipality_code,"`
                `" precinct,"`
                `" current) FROM '${file}' DELIMITER ',' CSV HEADER ENCODING 'UTF8';"
            create_file ${sql_file} "${current_file_content}"
            echo "Executing ${sql_file}."
            psql -d postgres -w -f ${sql_file}
        done

        echo "Processing imported current data."
        psql -d postgres -w -f ./sql/process_current.sql
        echo "Current data processing done."

        if [ ${init_do_json} -eq 1 ]; then
            echo "Creating JSON files."
            ./create_json.sh
            echo "JSON files created."
        fi

        if [ ${init_do_git} -eq 1 ]; then
            echo "Store changes to Git repository."
            git add ../_data/*.json
            git commit -m "Update JSON files"
            echo "Changes stored in local Git repository."

            echo "Synchronize remote repository."
            git push
            echo "Remote repository synchronized."
        fi
    else
        echo "No import files found."
    fi
fi

if [ ${op_generate_mock_data} -eq 1 ]; then
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi

    content=""`
    `"update vt_precinct_monitor\n"`
    `"set current = random_between(${mock_data_lb}, ${mock_data_ub})\n"`
    `"from\n"`
    `"    vt_precinct\n"`
    `"    inner join vt_barangay on\n"`
    `"        (vt_barangay.id = vt_precinct.barangay_id)\n"`
    `"    inner join vt_municipality on\n"`
    `"        (vt_municipality.id = vt_barangay.municipality_id)\n"`
    `"where\n"`
    `"    vt_precinct.id = vt_precinct_monitor.precinct_id;"

    file="./sql/mock//mock_data.sql"
    create_file ${file} "${content}"
    psql -d postgres -w -f ./sql/mock/mock_data.sql
    echo "In-favor mock data has been generated."
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
    echo "Markdown files has been created."
fi

echo "Done."
exit 0
