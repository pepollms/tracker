#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare -r CMD_LIST_MUNICIPALITY="list-municipality"
declare -r CMD_GET_PRECINCT_INFO="get-precinct-info"
declare -r CMD_GET_LEADER_INFO="get-leader-info"
declare -r CMD_GET_LEADER_ASSIGNMENT="get-leader-assignment"

declare -r CMD_ADD_LEADER="add-leader"
declare -r CMD_SET_LEADER_NAME="set-leader-name"
declare -r CMD_SET_LEADER_CONTACT="set-leader-contact"
declare -r CMD_SET_LEADER_ASSIGNMENT="set-leader-assignment"

declare -r CMD_ADD_PRECINCT_CURRENT="add-precinct-current"
declare -r CMD_SET_PRECINCT_CURRENT="set-precinct-current"
declare -r CMD_SET_PRECINCT_TARGET="set-precinct-target"

function show_usage {
    echo "$PROGRAM_NAME - Data manipulation script."
    echo ""
    echo "Usage: $PROGRAM_NAME [--help] <command> <arguments>"
    echo ""
    echo "Query Commands:"
    echo ""
    echo "  $CMD_LIST_MUNICIPALITY          List all municipalities"
    echo "  $CMD_GET_PRECINCT_INFO          Get precinct information"
    echo "  $CMD_GET_LEADER_INFO            Get leader information"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      Get leader-precinct assignment"
    echo ""
    echo "Update Commands:"
    echo ""
    echo "  $CMD_ADD_LEADER                 Add new leader information"
    echo "  $CMD_SET_LEADER_NAME            Set leader name"
    echo "  $CMD_SET_LEADER_CONTACT         Set leader contact"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      Set leader-precinct assignment"
    echo "  $CMD_ADD_PRECINCT_CURRENT       Add to precinct current count"
    echo "  $CMD_SET_PRECINCT_CURRENT       Set precinct current count"
    echo "  $CMD_SET_PRECINCT_TARGET        Set precinct target"
    echo ""
    echo "Command arguments: "
    echo ""
    echo "  $CMD_LIST_MUNICIPALITY"
    echo "  $CMD_GET_PRECINCT_INFO          [id <\"id\">] [name <\"name\">]"
    echo "  $CMD_GET_LEADER_INFO            [id <\"id\">] [name <\"name\">] [contact <\"contact\">]"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      [id <\"id\">] [name <\"name\">]"
    echo ""
    echo "  $CMD_ADD_LEADER                 <\"name\"> <\"contact\">"
    echo "  $CMD_SET_LEADER_NAME            <id> <\"name\">"
    echo "  $CMD_SET_LEADER_CONTACT         <id> <\"contact\">"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      <leader-id> <precinct-id>"
    echo "  $CMD_ADD_PRECINCT_CURRENT       <precinct-id> <number>"
    echo "  $CMD_SET_PRECINCT_CURRENT       <precinct-id> <number>"
    echo "  $CMD_SET_PRECINCT_TARGET        <precinct-id> <number>"
    echo ""
    echo "Parameters enclosed in quotes may contain spaces and wildcard characters."
    echo "Wildcard character '%' means any number of characters."
    echo "  '%abc' - any text ending with 'abc'; abc, 123abc, xyzabc"
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

function list_municipality {
    check_if_server_is_ready
    echo "Municipality list"
    psql -d postgres -w -q -c '\pset pager off' -c "select municipality_id as id, municipality from view_municipality order by municipality;"
}

function get_precinct_info {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_GET_PRECINCT_INFO operation."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local column="$1"
    shift 1
    if [ $# -eq 0 ]; then
        echo "Missing $column argument for operation $CMD_GET_PRECINCT_INFO."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local parameter="$1"
    if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
        echo "Get precinct information with '$column' like '${parameter}'."
    else
        echo "Get precinct information with '$column' equal to '${parameter}'."
    fi

    if [ $column == "id" ]; then
        if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
            psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select * from view_precinct where trim(to_char(precinct_id, '999999')) like '${parameter}';"
        else
            psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select * from view_precinct where precinct_id = ${parameter};"
        fi
    elif [ $column == "name" ]; then
        if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
            psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select * from view_precinct where precinct like '${parameter}';"
        else
            psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select * from view_precinct where precinct = '${parameter}';"
        fi
    else
        echo "Unknown column '$column' argument."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
    fi
}

function get_leader_info {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_GET_LEADER_INFO operation."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">] [name <\"name\">] [contact <\"contact\">]"
        return -1
    fi

    local column="$1"
    shift 1
    if [ $# -eq 0 ]; then
        echo "Missing $column argument for operation $CMD_GET_LEADER_INFO."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">] [name <\"name\">] [contact <\"contact\">]"
        return -1
    fi

    local parameter="$1"
    if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
        echo "Get leader information with '$column' like '${parameter}'."
    else
        echo "Get leader information with '$column' equal to '${parameter}'."
    fi

    if [ $column == "id" ]; then
        if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where trim(to_char(id, '999999')) like '${parameter}';"
        else
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where id = ${parameter};"
        fi
    elif [ $column == "name" ]; then
        if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where name like '${parameter}';"
        else
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where name = '${parameter}';"
        fi
    elif [ $column == "contact" ]; then
        if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where contact like '${parameter}';"
        else
            psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where contact = '${parameter}';"
        fi
    else
        echo "Unknown column '$column' argument."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">] [name <\"name\">] [contact <\"contact\">]"
    fi
}

function get_leader_assignment {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_GET_LEADER_ASSIGNMENT operation."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local column="$1"
    shift 1
    if [ $# -eq 0 ]; then
        echo "Missing $column argument for operation $CMD_GET_LEADER_ASSIGNMENT."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local parameter="$1"
    if [[ "$parameter" = *"%"* || "$parameter" = *"_"* ]]; then
        if [ $column == "id" ]; then
            local result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where trim(to_char(id, '999999')) like '${parameter}';"`
            if [[ "$result" == "0" ]]; then
                echo "Leader not found."
                return -1
            fi
            if [[ ! "$result" == "1" ]]; then
                echo "Multiple leaders found: $result"
                psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where trim(to_char(id, '999999')) like '${parameter}';"
                return -1
            fi
        elif [ $column == "name" ]; then
            local result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where name like '${parameter}';"`
            if [[ "$result" == "0" ]]; then
                echo "Leader not found."
                return -1
            fi
            if [[ ! "$result" == "1" ]]; then
                echo "Multiple leaders found: $result"
                psql -d postgres -w -q -c '\pset pager off' -c "select * from vt_leader where name like '${parameter}';"
                return -1
            fi
        else
            echo "Unknown column '$column' argument."
            echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">] [name <\"name\">]"
        fi
    else
        echo "Get leader assignment with leader '$column' equal to '${parameter}'."
    fi

    if [ $column == "id" ]; then
        local result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where id = ${parameter};"`
        if [[ "$result" == "0" ]]; then
            echo "Leader not found."
            return -1
        fi
        psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select id, name, contact from vt_leader where id = ${parameter};"
        psql -d postgres -w -q -c '\pset pager off' -c "select district, municipality_id as mun_id, municipality, barangay, precinct_id as prec_id, precinct from view_precinct where leader_id = ${parameter} order by district, municipality, barangay, precinct;"
    elif [ $column == "name" ]; then
        local result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where name = '${parameter}';"`
        if [[ "$result" == "0" ]]; then
            echo "Leader not found."
            return -1
        fi
        psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select id, name, contact from vt_leader where name = '${parameter}';"
        psql -d postgres -w -q -c '\pset pager off' -c "select district, municipality_id as mun_id, municipality, barangay, precinct_id as prec_id, precinct from view_precinct where leader = '${parameter}' order by district, municipality, barangay, precinct;"
    else
        echo "Unknown column '$column' argument."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">] [name <\"name\">]"
    fi
}

function add_leader {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_ADD_LEADER operation."
        echo "Syntax: $CMD_ADD_LEADER <\"name\"> <\"contact\">"
        return -1
    fi

    local name="$1"
    shift 1

    if [ $# -eq 0 ]; then
        echo "Missing 'contact' argument to $CMD_ADD_LEADER operation."
        echo "Syntax: $CMD_ADD_LEADER <\"name\"> <\"contact\">"
        return -1
    fi

    local contact="$1"
    shift 1

    local result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where name = '${name}';"`
    if [[ ! "$result" == "0" ]]; then
        echo "Leader '${name}' already exists."
        psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select id, name, contact from vt_leader where name = '${name}';"
        return -1
    fi

    result=`psql -d postgres -w --tuples-only --no-align -c "select count(*) from vt_leader where contact = '${contact}';"`
    if [[ $result -eq 1 ]]; then
        echo "Leader contact '${contact}' already exists."
        psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select id, name, contact from vt_leader where contact = '${contact}';"
        return -1
    elif [[ $result -gt 1 ]]; then
        echo "Multiple leaders with contact '${contact}' found: $result"
        return -1
    fi

    local result=`psql -d postgres -w --tuples-only --no-align -c "select add_leader('${name}', '${contact}');"`
    if [ "$result" = "-1" ]; then
        echo "Error: Leader with name '${name}' already exists."
        return -1
    elif [ "$result" = "-2" ]; then
        echo "Error: Leader with contact '${contact}' already exists."
        return -1
    else
        # Display newly added leader
        psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "select id, name, contact from vt_leader where name = '${name}';"
    fi
    echo "Leader '${name}' with contact '${contact}'' added."
}

function set_leader_name {
    check_if_server_is_ready
    local leader_id=$1
    local name="$2"
    local old_value=`psql -d postgres -w --tuples-only --no-align -c "select get_leader_name(${leader_id});"`
    if [ -z "$old_value" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    local result=`psql -d postgres -w --tuples-only --no-align -c "select set_leader_name(${leader_id}, '${name}');"`
    if [ "$result" = "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    local new_value=`psql -d postgres -w --tuples-only --no-align -c "select get_leader_name(${leader_id});"`
    if [ -z "$new_value" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    echo "Leader ${leader_id} name set from \"${old_value}\" to \"${new_value}\"."
}

function set_leader_contact {
    check_if_server_is_ready
    local leader_id=$1
    local contact="$2"
    local old_value=`psql -d postgres -w --tuples-only --no-align -c "select get_leader_contact(${leader_id});"`
    if [ -z "$old_value" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    local result=`psql -d postgres -w --tuples-only --no-align -c "select set_leader_contact(${leader_id}, '${contact}');"`
    if [ "$result" = "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    local new_value=`psql -d postgres -w --tuples-only --no-align -c "select get_leader_contact(${leader_id});"`
    if [ -z "$new_value" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    echo "Leader ${leader_id} contact set from \"${old_value}\" to \"${new_value}\"."
}

function set_leader_assignment {
    check_if_server_is_ready
    local leader_id=$1
    local precinct_id=$2
    local result=`psql -d postgres -w --tuples-only --no-align -c "select set_leader_assignment(${leader_id}, ${precinct_id});"`
    if [ "$result" = "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi
    if [ "$result" = "-2" ]; then
        echo "Error: Precinct ${precinct_id} not found."
        return -2
    fi
    if [ "$result" = "-3" ]; then
        echo "Error: Leader ${leader_id} already assigned to Precinct ${precinct_id}."
        return -3
    fi
    echo "Leader ${leader_id} assigned to Precinct ${precinct_id}."
}

function add_precinct_current {
    check_if_server_is_ready
    local precinct_id=$1
    local count=$2
    if [ $count -eq 0 ]; then
        echo "Did not perform the operation."
        echo "Adding or subtracting zero (0) makes no sense."
        return -1
    fi
    local old_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_current(${precinct_id});"`
    local result=`psql -d postgres -w --tuples-only --no-align -c "select add_precinct_current(${precinct_id}, ${count});"`
    if [ $result = "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi
    echo "Successfully added ${count} to Precinct ID ${precinct_id} current count."
    local new_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_current(${precinct_id});"`
    echo "From ${old_value} to ${new_value}."
    return $count
}

function set_precinct_current {
    check_if_server_is_ready
    local precinct_id=$1
    local count=$2
    local old_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_current(${precinct_id});"`
    local result=`psql -d postgres -w --tuples-only --no-align -c "select set_precinct_current(${precinct_id}, ${count});"`
    if [ $result = "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi
    echo "Successfully set current count to ${count} for Precinct ID ${precinct_id}."
    local new_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_current(${precinct_id});"`
    echo "From ${old_value} to ${new_value}."
    return $count
}

function set_precinct_target {
    check_if_server_is_ready
    local precinct_id=$1
    local target=$2
    local old_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_target(${precinct_id});"`
    local result=`psql -d postgres -w --tuples-only --no-align -c "select set_precinct_target(${precinct_id}, ${target});"`
    if [ $result = "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi
    echo "Successfully set target to ${target} for Precinct ID ${precinct_id}."
    local new_value=`psql -d postgres -w --tuples-only --no-align -c "select get_precinct_target(${precinct_id});"`
    echo "From ${old_value} to ${new_value}."
    return $target
}



if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

if [[ ! "${1}" == @($CMD_LIST_MUNICIPALITY|$CMD_GET_PRECINCT_INFO|$CMD_GET_LEADER_INFO|$CMD_GET_LEADER_ASSIGNMENT|$CMD_ADD_LEADER|$CMD_SET_LEADER_NAME|$CMD_SET_LEADER_CONTACT|$CMD_SET_LEADER_ASSIGNMENT|$CMD_ADD_PRECINCT_CURRENT|$CMD_SET_PRECINCT_CURRENT|$CMD_SET_PRECINCT_TARGET) ]]; then
    echo_err "Unknown command ${1}."
    echo ""
    echo "Available commands:"

    display_commands

    echo ""
    echo "See help for complete information: ./$PROGRAM_NAME --help"
    exit 1
fi

arg_command="${1}"
shift 1

case "${arg_command}" in
    $CMD_LIST_MUNICIPALITY)      list_municipality ;;
    $CMD_GET_PRECINCT_INFO)      get_precinct_info $@ ;;
    $CMD_GET_LEADER_INFO)        get_leader_info "$@" ;;
    $CMD_GET_LEADER_ASSIGNMENT)  get_leader_assignment $@ ;;

    $CMD_ADD_LEADER)             add_leader "$@" ;;
    $CMD_SET_LEADER_NAME)        set_leader_name "$@" ;;
    $CMD_SET_LEADER_CONTACT)     set_leader_contact "$@" ;;

    $CMD_SET_LEADER_ASSIGNMENT)  set_leader_assignment $@ ;;
    $CMD_ADD_PRECINCT_CURRENT)   add_precinct_current $@ ;;
    $CMD_SET_PRECINCT_CURRENT)   set_precinct_current $@ ;;
    $CMD_SET_PRECINCT_TARGET)    set_precinct_target $@ ;;
esac

#  psql -d postgres -w -t -c "${SQL_COMMAND}"
