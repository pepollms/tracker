#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare -r CMD_ADD_LEADER="add-leader"
declare -r CMD_GET_LEADER_ID="get-leader-id"
declare -r CMD_GET_LEADER_NAME="get-leader-name"
declare -r CMD_GET_LEADER_CONTACT="get-leader-contact"
declare -r CMD_SET_LEADER_NAME="set-leader-name"
declare -r CMD_SET_LEADER_CONTACT="set-leader-contact"
declare -r CMD_GET_LEADER_ASSIGNMENT="get-leader-assignment"
declare -r CMD_SET_LEADER_ASSIGNMENT="set-leader-assignment"
declare -r CMD_GET_PRECINCT_ID="get-precinct-id"
declare -r CMD_GET_PRECINCT_NAME="get-precinct-name"
declare -r CMD_ADD_PRECINCT_CURRENT="add-precinct-current"
declare -r CMD_SET_PRECINCT_CURRENT="set-precinct-current"
declare -r CMD_SET_PRECINCT_TARGET="set-precinct-target"

function display_commands {
    echo "  $CMD_ADD_LEADER                 Add new leader information"
    echo "  $CMD_GET_LEADER_ID              Get leader information using identifier"
    echo "  $CMD_GET_LEADER_NAME            Get leader information using name"
    echo "  $CMD_GET_LEADER_CONTACT         Get leader information using contact"
    echo "  $CMD_SET_LEADER_NAME            Set leader name"
    echo "  $CMD_SET_LEADER_CONTACT         Set leader contact"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      Get leader-precinct assignment"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      Set leader-precinct assignment"
    echo "  $CMD_GET_PRECINCT_ID            Get precinct information using identifier"
    echo "  $CMD_GET_PRECINCT_NAME          Get precinct information using name"
    echo "  $CMD_ADD_PRECINCT_CURRENT       Add to precinct current count"
    echo "  $CMD_SET_PRECINCT_CURRENT       Set precinct current count"
    echo "  $CMD_SET_PRECINCT_TARGET        Set precinct target"
}

function show_usage {
    echo "$PROGRAM_NAME - Data manipulation script."
    echo ""
    echo "Usage: $PROGRAM_NAME [--help] <command> <arguments>"
    echo ""
    echo "Commands:"

    display_commands

    echo ""
    echo "Command arguments: Parameters enclosed in quotes may contain spaces."
    echo "  $CMD_ADD_LEADER                 <\"name\"> <\"contact\">"
    echo "  $CMD_GET_LEADER_ID              <\"id\">"
    echo "  $CMD_GET_LEADER_NAME            <\"name\">"
    echo "  $CMD_GET_LEADER_CONTACT         <\"contact\">"
    echo "  $CMD_SET_LEADER_NAME            <id> <\"name\">"
    echo "  $CMD_SET_LEADER_CONTACT         <id> <\"contact\">"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      <leader id>"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      <leader id> <precinct id>"
    echo "  $CMD_GET_PRECINCT_ID            <\"id\">"
    echo "  $CMD_GET_PRECINCT_NAME          <\"name\">"
    echo "  $CMD_ADD_PRECINCT_CURRENT       <precinct id> <number>"
    echo "  $CMD_SET_PRECINCT_CURRENT       <precinct id> <number>"
    echo "  $CMD_SET_PRECINCT_TARGET        <precinct id> <number>"
    echo ""
} # show_usage

# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: $1"
    echo "-----"
} # echo_err



function add_leader {
    local name="$1"
    local contact="$2"
    local result=`psql -d postgres -w --tuples-only --no-align -c "select add_leader('${name}', '${contact}');"`
    if [ "$result" = "-1" ]; then
        echo "Error: Leader with name '${name}' already exists."
        return -1
    fi
    echo "Leader '${name}' with contact '${contact} added."
}

function get_leader_id {
    local parameter="$1"
    if [[ $parameter == *"%"* ]]; then
        echo "Get leader with ID like '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where to_char(id, '999999') like '${parameter}';"
    else
        echo "Get leader with ID equal to '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where id = ${parameter};"
    fi
}

function get_leader_name {
    local parameter="$1"
    if [[ $parameter == *"%"* ]]; then
        echo "Get leader with name like '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where name like '${parameter}';"
    else
        echo "Get leader with name equal to '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where name = '${parameter}';"
    fi
}

function get_leader_contact {
    local parameter="$1"
    if [[ $parameter == *"%"* ]]; then
        echo "Get leader with contact like '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where contact like '${parameter}';"
    else
        echo "Get leader with contact equal to '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c "select * from vt_leader where contact = '${parameter}';"
    fi
}

function set_leader_name {
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

function get_leader_assignment {
    local leader_id=$1
    echo "Get leader ${leader_id} information."
    get_leader_id ${leader_id}
    #local result=`psql -d postgres -w --tuples-only -c '\x' -c "select * from view_precinct where leader_id=${leader_id};"`
    psql -d postgres -w -c '\pset pager off' -c "select district, municipality_id, municipality, barangay, precinct_id, precinct from view_precinct where leader_id = ${leader_id} order by district, municipality, barangay, precinct;"
}

function set_leader_assignment {
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
    #echo_err "Function add_precinct_count not implemented yet."
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

function get_precinct_id {
    local parameter=$1
    if [[ $parameter == *"%"* ]]; then
        echo "Get precinct with id like '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c '\x' -c "select * from view_precinct where to_char(precinct_id, '999999') like '${parameter}';"
    else
        echo "Get precinct with id equal to '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c '\x' -c "select * from view_precinct where precinct_id = ${parameter};"
    fi
}

function get_precinct_name {
    local precinct_id=$1
    if [[ $parameter == *"%"* ]]; then
        echo "Get precinct with id like '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c '\x' -c "select * from view_precinct where name like '${parameter}';"
    else
        echo "Get precinct with id equal to '${parameter}'"
        psql -d postgres -w -c '\pset pager off' -c '\x' -c "select * from view_precinct where name = '${parameter}';"
    fi
}

function set_precinct_target {
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

if [[ ! "${1}" == @($CMD_ADD_LEADER|$CMD_GET_LEADER_ID|$CMD_GET_LEADER_NAME|$CMD_GET_LEADER_CONTACT|$CMD_SET_LEADER_NAME|$CMD_SET_LEADER_CONTACT|$CMD_GET_LEADER_ASSIGNMENT|$CMD_SET_LEADER_ASSIGNMENT|$CMD_GET_PRECINCT_ID|$CMD_GET_PRECINCT_NAME|$CMD_ADD_PRECINCT_CURRENT|$CMD_SET_PRECINCT_CURRENT|$CMD_SET_PRECINCT_TARGET) ]]; then
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
    $CMD_ADD_LEADER)             add_leader "$@" ;;
    $CMD_GET_LEADER_ID)          get_leader_id "$@" ;;
    $CMD_GET_LEADER_NAME)        get_leader_name "$@" ;;
    $CMD_GET_LEADER_CONTACT)     get_leader_contact "$@" ;;
    $CMD_SET_LEADER_NAME)        set_leader_name "$@" ;;
    $CMD_SET_LEADER_CONTACT)     set_leader_contact "$@" ;;
    $CMD_GET_LEADER_ASSIGNMENT)  get_leader_assignment $@ ;;
    $CMD_SET_LEADER_ASSIGNMENT)  set_leader_assignment $@ ;;
    $CMD_GET_PRECINCT_ID)        get_precinct_id $@ ;;
    $CMD_GET_PRECINCT_NAME)      get_precinct_name $@ ;;
    $CMD_ADD_PRECINCT_CURRENT)   add_precinct_current $@ ;;
    $CMD_SET_PRECINCT_CURRENT)   set_precinct_current $@ ;;
    $CMD_SET_PRECINCT_TARGET)    set_precinct_target $@ ;;
esac

#  psql -d postgres -w -t -c "${SQL_COMMAND}"
