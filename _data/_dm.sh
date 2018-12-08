#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare -r CMD_ADD_LEADER="add-leader"
declare -r CMD_SET_LEADER_NAME="set-leader-name"
declare -r CMD_SET_LEADER_CONTACT="set-leader-contact"
declare -r CMD_GET_LEADER_ASSIGNMENT="get-leader-assignment"
declare -r CMD_SET_LEADER_ASSIGNMENT="set-leader-assignment"
declare -r CMD_GET_PRECINCT="get-precinct"
declare -r CMD_ADD_PRECINCT_CURRENT="add-precinct-current"
declare -r CMD_SET_PRECINCT_CURRENT="set-precinct-current"
declare -r CMD_SET_PRECINCT_TARGET="set-precinct-target"

function display_commands {
    echo "  $CMD_ADD_LEADER                 Add new leader information"
    echo "  $CMD_SET_LEADER_NAME            Set leader name"
    echo "  $CMD_SET_LEADER_CONTACT         Set leader contact"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      Get leader-precinct assignment"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      Set leader-precinct assignment"
    echo "  $CMD_GET_PRECINCT               Get precinct information"
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
    echo "Command arguments:"
    echo "  $CMD_ADD_LEADER                 Add new leader information"
    echo "     -name <\"text\">               name must be enclosed in double"
    echo "                                      quotes so it can contain spaces"
    echo "     -contact <text>                contact number"
    echo "  $CMD_SET_LEADER_NAMEe           Set leader name"
    echo "     -id <id>                       unique identifier"
    echo "     -name <\"text\">               name must be enclosed in double"
    echo "                                      quotes so it can contain spaces"
    echo "  $CMD_SET_LEADER_CONTACT         Set leader contact"
    echo "     -id <id>                       unique identifier"
    echo "     -contact <text>                contact number"
    echo "  $CMD_SET_LEADER_ASSIGNMENT      Set leader-precinct assignment"
    echo "     -precinct-id <id>              precinct unique identifier"
    echo "     -leader-id <id>                leader unique identifier"
    echo "  $CMD_ADD_PRECINCT_CURRENT       Add to precinct current count"
    echo "     -precinct-id <id>              precinct unique identifier"
    echo "      <number>                      number to add to the current count"
    echo "  $CMD_SET_PRECINCT_CURRENT       Set precinct current count"
    echo "     -precinct-id <id>              precinct unique identifier"
    echo "      <number>                      current count number"
    echo "  $CMD_SET_PRECINCT_TARGET        Set precinct target"
    echo "     -precinct-id <id>              precinct unique identifier"
    echo "      <number>                      number to set the new target count"
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
    local result=`psql -d postgres -w --tuples-only -c '\x' -c "select * from view_precinct where leader_id=${leader_id};"`
    if [ -z "$result" ]; then
        echo "No data found."
    else
        echo "$result"
    fi
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

function get_precinct {
    local precinct_id=$1
    local result=`psql -d postgres -w --tuples-only -c '\x' -c "select * from view_precinct where precinct_id=${precinct_id};"`
    if [ -z "$result" ]; then
        echo "No data found."
    else
        echo "$result"
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

if [[ ! "${1}" == @($CMD_ADD_LEADER|$CMD_SET_LEADER_NAME|$CMD_SET_LEADER_CONTACT|$CMD_GET_LEADER_ASSIGNMENT|$CMD_SET_LEADER_ASSIGNMENT|$CMD_GET_PRECINCT|$CMD_ADD_PRECINCT_CURRENT|$CMD_SET_PRECINCT_CURRENT|$CMD_SET_PRECINCT_TARGET) ]]; then
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
    $CMD_SET_LEADER_NAME)        set_leader_name "$@" ;;
    $CMD_SET_LEADER_CONTACT)     set_leader_contact "$@" ;;
    $CMD_GET_LEADER_ASSIGNMENT)  get_leader_assignment $@ ;;
    $CMD_SET_LEADER_ASSIGNMENT)  set_leader_assignment $@ ;;
    $CMD_GET_PRECINCT)           get_precinct $@ ;;
    $CMD_ADD_PRECINCT_CURRENT)   add_precinct_current $@ ;;
    $CMD_SET_PRECINCT_CURRENT)   set_precinct_current $@ ;;
    $CMD_SET_PRECINCT_TARGET)    set_precinct_target $@ ;;
esac

#  psql -d postgres -w -t -c "${SQL_COMMAND}"
