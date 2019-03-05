#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"
declare -r CD="$(dirname "$0")"

declare -r CMD_LIST="list"
declare -r CMD_COUNT="count"

function show_usage {
    echo "$PROGRAM_NAME - Data query script."
    echo ""
    echo "Usage: $PROGRAM_NAME [--help] <command> <arguments>"
    echo ""
    echo ""
    echo "Parameters enclosed in quotes may contain spaces and wildcard"
    echo "characters. Wildcard character '%' means any number of characters."
    echo "'%abc' - any text ending with 'abc'; 'abc', '123abc', 'xyzabc'."
    echo ""
} # show_usage

# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: $1"
    echo "-----"
} # echo_err



function check_if_server_is_ready {
    if ! /usr/bin/pg_isready &>/dev/null; then
        echo "PostgreSQL service is not running."
        echo "Aborting operation."
        exit 1
    fi
}

function exec_sql {
    if [ $# -eq 0 ]; then
        echo_err "Missing SQL parameter."
        exit
    fi
    arg_sql="${1}"
    local -r result=$(psql \
        -d postgres \
        -w \
        -q \
        -c '\t' \
        -c '\pset pager off' \
        -c '\pset footer off' \
        -c "${arg_sql}")
    #echo "$(echo ${result} | tr -d '[:space:]')"
    echo "${result}"
}

function list_province {
    check_if_server_is_ready
    echo "List: province"
    local -r SQL=""`
        `" select distinct"`
        `"     province"`
        `" from"`
        `"     vt_import;"
# psql -d postgres -w -q -c '\t' -c '\pset pager off' -c '\pset footer off' -c "select distinct province from vt_import;"
    echo "$(exec_sql "${SQL}")"
}

function count_district {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select"`
        `"     count(district)"`
        `" from"`
        `"     (select distinct district from vt_import) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "Count: district $(echo ${result} | tr -d '[:space:]')"
}

function list_district {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select"`
        `"     count(district)"`
        `" from"`
        `"     (select distinct district from vt_import) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "List: district $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select distinct"`
        `"     district"`
        `" from"`
        `"     vt_import"`
        `" order by"`
        `"     district;"
    echo "$(exec_sql "${SQL}")"
}

function count_municipality {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(municipality)"`
        `" from"`
        `"     (select distinct district, municipality from vt_import group by district, municipality) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "Count: municipality $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select district, count(municipality)"`
        `" from"`
        `"     (select distinct district, municipality from vt_import group by district, municipality) as t"`
        `" group by district"`
        `" order by district;"
    echo "$(exec_sql "${SQL}")"
}

function list_municipality {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(municipality)"`
        `" from"`
        `"     (select distinct district, municipality from vt_import group by district, municipality) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "List: municipality $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select"`
        `"     row_number() over (order by district, municipality) as seqnum,"`
        `"     district,"`
        `"     municipality"`
        `" from"`
        `"     (select distinct district, municipality from vt_import group by district, municipality) as t"`
        `" order by district, municipality;"
    echo "$(exec_sql "${SQL}")"
}

function count_barangay {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(barangay)"`
        `" from"`
        `"     (select distinct district, municipality, barangay from vt_import group by district, municipality, barangay) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "Count: barangay $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select district, municipality, count(barangay)"`
        `" from"`
        `"     (select distinct district, municipality, barangay from vt_import group by district, municipality, barangay) as t"`
        `" group by district, municipality"`
        `" order by district, municipality;"
    echo "$(exec_sql "${SQL}")"
}

function list_barangay {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(barangay)"`
        `" from"`
        `"     (select distinct district, municipality, barangay from vt_import group by district, municipality, barangay) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "List: barangay $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select distinct"`
        `"     row_number() over (order by district, municipality, barangay) as seqnum,"`
        `"     district,"`
        `"     municipality,"`
        `"     barangay"`
        `" from"`
        `"     vt_import"`
        `" order by"`
        `"     district,"`
        `"     municipality,"`
        `"     barangay;"
    echo "$(exec_sql "${SQL}")"
}

function count_precinct {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(precinct)"`
        `" from"`
        `"     (select distinct district, municipality, barangay, precinct from vt_import group by district, municipality, barangay, precinct) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "Count: precinct $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select district, municipality, barangay, count(precinct)"`
        `" from"`
        `"     (select distinct district, municipality, barangay, precinct from vt_import group by district, municipality, barangay, precinct) as t"`
        `" group by district, municipality, barangay"`
        `" order by district, municipality, barangay;"
    echo "$(exec_sql "${SQL}")"
}

function list_precinct {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(precinct)"`
        `" from"`
        `"     (select distinct district, municipality, barangay, precinct from vt_import group by district, municipality, barangay, precinct) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "List: precinct $(echo ${result} | tr -d '[:space:]')"
    local -r SQL=""`
        `" select distinct"`
        `"     row_number() over (order by district, municipality, barangay, precinct) as seqnum,"`
        `"     district,"`
        `"     municipality,"`
        `"     barangay,"`
        `"     precinct"`
        `" from"`
        `"     vt_import"`
        `" order by"`
        `"     district,"`
        `"     municipality,"`
        `"     barangay,"`
        `"     precinct;"
    echo "$(exec_sql "${SQL}")"
}

function count_leader {
    check_if_server_is_ready
    local -r SQL_COUNT=""`
        `" select count(leader)"`
        `" from"`
        `"     (select distinct leader from vt_import) as t;"
    local -r result=$(exec_sql "${SQL_COUNT}")
    echo "Count: leader $(echo ${result} | tr -d '[:space:]')"
}



if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

commands=(
    $CMD_LIST
    $CMD_COUNT
)

if [[ ! "${commands[@]}" =~ "${1}" ]]; then
    echo_err "Unknown command ${1}."
    echo ""
    echo "See help for complete information: ./$PROGRAM_NAME --help"
    exit 1
fi

arg_command="${1}"
shift

if [ $# -eq 0 ]; then
    show_usage
    exit
fi

arg_data="${1}"
shift

if [ "${arg_command}" == "list" ]; then
    case "${arg_data}" in
        province)       list_province ;;
        district)       list_district ;;
        municipality)   list_municipality ;;
        barangay)       list_barangay ;;
        precinct)       list_precinct ;;
    esac
elif [ "${arg_command}" == "count" ]; then
    case "${arg_data}" in
        district)       count_district ;;
        municipality)   count_municipality ;;
        barangay)       count_barangay ;;
        precinct)       count_precinct ;;
        leader)         count_leader ;;
    esac
fi




