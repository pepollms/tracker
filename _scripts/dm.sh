#!/usr/bin/env bash

declare -r PROGRAM_NAME="${0##*/}"

declare -r CMD_TEST="test"
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
    echo "  $CMD_GET_PRECINCT_INFO          <id \"id\" | name \"name\">"
    echo "  $CMD_GET_LEADER_INFO            <id \"id\" |"
    echo "                                  name \"name\" |"
    echo "                                  contact \"contact\">"
    echo "  $CMD_GET_LEADER_ASSIGNMENT      <id \"id\" | name \"name\">"
    echo ""
    echo "  $CMD_ADD_LEADER                 \"name\" \"contact\""
    echo "  $CMD_SET_LEADER_NAME            id \"name\""
    echo "  $CMD_SET_LEADER_CONTACT         id \"contact\""
    echo "  $CMD_SET_LEADER_ASSIGNMENT      leader-id precinct-id"
    echo "  $CMD_ADD_PRECINCT_CURRENT       [municipality-code precinct number | -id precinct-id number | -f]"
    echo "  $CMD_SET_PRECINCT_CURRENT       <precinct-id number>"
    echo "  $CMD_SET_PRECINCT_TARGET        <precinct-id number>"
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

function get_precinct_info {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_GET_PRECINCT_INFO operation."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local column="$1"
    shift
    if [ $# -eq 0 ]; then
        echo "Missing $column argument for operation $CMD_GET_PRECINCT_INFO."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    local criteria="$1"
    if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
        echo "Get precinct information with '$column' like '${criteria}'."
    else
        echo "Get precinct information with '$column' equal to '${criteria}'."
    fi

    local -r SELECT="select * from view_precinct where"

    local -r WHERE_PRECINCT_ID_LIKE=""`
        `"trim(to_char(precinct_id, '999999')) like '${criteria}'"
    local -r WHERE_PRECINCT_ID_IS="precinct_id = ${criteria}"
    local -r WHERE_PRECINCT_LIKE="precinct like '${criteria}'"
    local -r WHERE_PRECINCT_IS="precinct = '${criteria}'"

    local SQL=""

    columns=("id" "name")
    if [[ ! "${columns[@]}" =~ "${column}" ]]; then
        echo "Unknown column '$column' argument."
        echo "Syntax: $CMD_GET_PRECINCT_INFO [id <\"id\">] [name <\"name\">]"
        return -1
    fi

    if [ ${column} == "id" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_PRECINCT_ID_LIKE}"
        else
            SQL="${SELECT} ${WHERE_PRECINCT_ID_IS}"
        fi
    elif [ ${column} == "name" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_PRECINCT_LIKE}"
        else
            SQL="${SELECT} ${WHERE_PRECINCT_IS}"
        fi
    fi

    psql -d postgres -w -q -c '\pset pager off' -c '\x' -c "${SQL}"
}

# Check if a leader with the specified criteria exists.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   Return the number of found rows.
#
# Syntax:
#   get_existing_leader_id <column>=<criteria>
#
#   column: [id | name]
#   criteria: [%]value[%]
#
#   local result=$(leader_exists id=10)
#   local result=$(leader_exists id=%10)
#   local result=$(leader_exists name=text)
#   local result=$(leader_exists name=%text)
#
#   if [ "$result" -eq "0" ]; then
#   if [ "$result" == "0" ]; then
function leader_exists {
    if [ $# -eq 0 ]; then
        #echo "No argument specified."
        echo "0"
        return -1
    fi
    arg="$1"
    if [ -z "$arg" ]; then
        #echo "Argument is empty."
        echo "0"
        return -1
    fi
    column=${arg%=*}    # Remove suffix with =
    criteria=${arg#*=}  # Remove prefix with =

    local -r SELECT="select count(*) from vt_leader where"

    local -r WHERE_ID_LIKE="trim(to_char(id, '999999')) like '${criteria}'"
    local -r WHERE_ID_IS="id = ${criteria}"
    local -r WHERE_NAME_LIKE="name like '${criteria}'"
    local -r WHERE_NAME_IS="name = '${criteria}'"

    local SQL=""

    #printf "Leader Exists:"
    #printf "Argument: $arg"
    #printf "Column: $column"
    #printf "Criteria: $criteria"

     if [ "${column}" == "id" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_ID_LIKE};"
        else
            SQL="${SELECT} ${WHERE_ID_IS};"
        fi
    elif [ "${column}" == "name" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_NAME_LIKE};"
        else
            SQL="${SELECT} ${WHERE_NAME_IS};"
        fi
    else
        echo "0"
        return -1
    fi

    local -r result=`psql -d postgres -w -q -A -c '\t' -c "${SQL}"`
    echo "${result}"
}

# Checks if contact number already exists.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   Return the number of found rows.
#
# Syntax:
#   contact_exists <contact>
#
#   contact: [%]value[%]
#
# local result=$(contact_exists text)
# local result=$(contact_exists %text)
#
# if [ "$result" -eq "0" ]; then
# if [ "$result" == "0" ]; then
function contact_exists {
    if [ $# -eq 0 ]; then
        echo "0"
        return -1
    fi
    criteria="$1"
    if [ -z "$criteria" ]; then
        echo "0"
        return -1
    fi
    local -r SELECT="select count(*) from vt_leader where"

    local -r WHERE_CONTACT_LIKE="contact like '${criteria}'"
    local -r WHERE_CONTACT_IS="contact = '${criteria}'"

    local SQL=""

    if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
        SQL="${SELECT} ${WHERE_CONTACT_LIKE};"
    else
        SQL="${SELECT} ${WHERE_CONTACT_IS};"
    fi

    local -r result=`psql -d postgres -w -q -A -c '\t' -c "${SQL}"`
    echo "${result}"
}

# Return the leader id with the specified criteria.
# The leader is assumed to exists and is the only one matching the
# specified criteria.
#
# Return:
#   If one is found, return the leader id.
#   If none is found, return zero.
#   If more than one is found, return the count as a negative value.
#
# Syntax:
#   get_existing_leader_id <column>=<criteria>
#
#   column: [id | name | contact]
#   criteria: [%]value[%]
#
# local result=$(leader_exists id=10)
# local result=$(leader_exists id=%10)
# local result=$(leader_exists name=text)
# local result=$(leader_exists name=%text)
# local result=$(leader_exists contact=text)
# local result=$(leader_exists contact=%text)
#
# if [ "$result" -eq "0" ]; then
# if [ "$result" -eq "100" ]; then
# if [ "$result" -lt "0" ]; then
function get_existing_leader_id {
    if [ $# -eq 0 ]; then
        #echo "No argument specified."
        echo "0"
        return -1
    fi
    arg="$1"
    if [ -z "$arg" ]; then
        #echo "Argument is empty."
        echo "0"
        return -1
    fi
    column=${arg%=*}    # Remove suffix with =
    criteria=${arg#*=}  # Remove prefix with =

    local -r SELECT="select * from vt_leader where"

    local -r WHERE_ID_LIKE="trim(to_char(id, '999999')) like '${criteria}'"
    local -r WHERE_ID_IS="id = ${criteria}"
    local -r WHERE_NAME_LIKE="name like '${criteria}'"
    local -r WHERE_NAME_IS="name = '${criteria}'"
    local -r WHERE_CONTACT_LIKE="contact like '${criteria}'"
    local -r WHERE_CONTACT_IS="contact = '${criteria}'"

    local SQL=""

    #echo "Get Leader ID:"
    #echo "Argument: $arg"
    #echo "Column: $column"
    #echo "Criteria: $criteria"

    columns=("id" "name" "contact")
    if [[ ! "${columns[@]}" =~ "${column}" ]]; then
        #echo "Unknown column '$column' argument."
        #echo "Syntax: get_existing_leader_id <column>=<criteria>"
        #echo "          column: [id | name | contact]"
        #echo "          criteria: [%]value[%]""
        echo "0"
        return -1
    fi

    if [ "${column}" == "id" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_ID_LIKE};"
        else
            SQL="${SELECT} ${WHERE_ID_IS};"
        fi
    elif [ "${column}" == "name" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_NAME_LIKE};"
        else
            SQL="${SELECT} ${WHERE_NAME_IS};"
        fi
    elif [ "${column}" == "contact" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_CONTACT_LIKE};"
        else
            SQL="${SELECT} ${WHERE_CONTACT_IS};"
        fi
    fi

    if [ -n "${SQL}" ]; then
        local -r result=`psql -d postgres -w -q -A -c '\t' -c "${SQL}"`
        echo "${result}"
    else
        echo "0"
    fi
}

# Display the leader basic information.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   If the leader is found, then the leader information is sent to the
#   standard output.
#
# Syntax:
#   get_leader_info_data <column>=<criteria>
#
#   column: [id | name | contact]
#   criteria: [%]value[%]
#
#   display_leader_info id=10
#   display_leader_info id=%10
#   display_leader_info name=text
#   display_leader_info name=%text
#   display_leader_info contact=text
#   display_leader_info contact=%text
function display_leader_info {
    local -r column="$1"
    local -r criteria="$2"
    shift 2

    local -r SELECT="select * from vt_leader where"

    local -r WHERE_ID_LIKE="trim(to_char(id, '999999')) like '${criteria}'"
    local -r WHERE_ID_IS="id = ${criteria}"
    local -r WHERE_NAME_LIKE="name like '${criteria}'"
    local -r WHERE_NAME_IS="name = '${criteria}'"
    local -r WHERE_CONTACT_LIKE="contact like '${criteria}'"
    local -r WHERE_CONTACT_IS="contact = '${criteria}'"

    local SQL=""

    if [ "${column}" == "id" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_ID_LIKE};"
        else
            SQL="${SELECT} ${WHERE_ID_IS};"
        fi
    elif [ "${column}" == "name" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_NAME_LIKE};"
        else
            SQL="${SELECT} ${WHERE_NAME_IS};"
        fi
    elif [ "${column}" == "contact" ]; then
        if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
            SQL="${SELECT} ${WHERE_CONTACT_LIKE};"
        else
            SQL="${SELECT} ${WHERE_CONTACT_IS};"
        fi
    fi
    psql -d postgres -w -q      \
        -c '\pset pager off'    \
        -c '\pset footer off'   \
        -c "${SQL}"
}

# Get the leader basic information and display them.
#
# Syntax:
#   get_leader_info <column>=<criteria>
#
#   column: [id | name | contact]
#   criteria: [%]value[%]
#
#   get_leader_info id 10
#   get_leader_info id %10
#   get_leader_info name text
#   get_leader_info name %text
#   get_leader_info contact text
#   get_leader_info contact %text
function get_leader_info {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments for $CMD_GET_LEADER_INFO operation."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">]"
        echo "                             [name <\"name\">]"
        echo "                             [contact <\"contact\">]"
        return -1
    fi

    local column="$1"
    shift
    if [ $# -eq 0 ]; then
        echo "Missing $column argument for operation $CMD_GET_LEADER_INFO."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">]"
        echo "                             [name <\"name\">]"
        echo "                             [contact <\"contact\">]"
        return -1
    fi

    local criteria="$1"
    if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
        echo "Get leader information with '${column}' like '${criteria}'."
    else
        echo "Get leader information with '${column}' equal to '${criteria}'."
    fi

    columns=("id" "name" "contact")
    if [[ ! "${columns[@]}" =~ "${column}" ]]; then
        echo "Unknown column '${column}' argument."
        echo "Syntax: $CMD_GET_LEADER_INFO [id <\"id\">]"
        echo "                             [name <\"name\">]"
        echo "                             [contact <\"contact\">]"
        return -1
    fi

    if [[ "${column}" == "id" || "${column}" == "name" ]]; then
        local count=$(leader_exists "${column}=${criteria}")
        if [ ${count} -eq 0 ]; then
            echo "No leader found."
            return -1
        elif [ ${count} -gt 1 ]; then
            echo "Multiple leaders found."
            return -1
        fi
    elif [ "${column}" == "contact" ]; then
        local -r count=$(contact_exists "${criteria}")
        if [ ${count} -eq 0 ]; then
            echo "No leader found."
            return -1
        elif [ ${count} -gt 1 ]; then
            echo "Multiple leaders found."
            return -1
        fi
    fi

    display_leader_info "${column}" "${criteria}"
}

# Display the leader-precinct assignments.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   If the leader is found, then the leader-precinct information is sent to
#   the standard output.
#
# Syntax:
#   display_leader_assignment <leader id>
#
#   display_leader_assignment 10
function display_leader_assignment {
    local -r leader_id="$1"
    local -r SQL=""`
        `" select"`
        `"     district,"`
        `"     municipality_id as mun_id,"`
        `"     municipality,"`
        `"     barangay,"`
        `"     precinct_id as prec_id,"`
        `"     precinct"`
        `" from"`
        `"     view_precinct"`
        `" where"`
        `"     leader_id = ${leader_id}"`
        `" order by"`
        `"     district,"`
        `"     municipality,"`
        `"     barangay,"`
        `"     precinct;"
    psql -d postgres -w -q      \
        -c '\pset pager off'    \
        -c '\pset footer off'   \
        -c "$SQL"
}

function get_leader_assignment {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments for $CMD_GET_LEADER_ASSIGNMENT operation."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">]"
        echo "                                   [name <\"name\">]"
        return -1
    fi

    local column="$1"
    shift
    if [ $# -eq 0 ]; then
        echo "Missing column argument for $CMD_GET_LEADER_ASSIGNMENT."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">]"
        echo "                                   [name <\"name\">]"
        return -1
    fi

    columns=("id" "name")
    if [[ ! "${columns[@]}" =~ "${columns}" ]]; then
        echo "Unknown column '$column' argument."
        echo "Syntax: $CMD_GET_LEADER_ASSIGNMENT [id <\"id\">]"
        echo "                                   [name <\"name\">]"
        return -1
    fi

    local -r criteria="$1"

    local count=$(leader_exists "${column}=${criteria}")
    if [ ${count} -eq 0 ]; then
        echo "No leader found."
        return -1
    elif [ ${count} -gt 1 ]; then
        echo "Multiple leaders found."
        return -1
    fi

    local -r leader_id=$(get_existing_leader_id "${column}=${criteria}")
    if [ "${leader_id}" -eq "0" ]; then
        echo "Could not get Leader ID ${leader_id} from ${column}=${criteria}."
        return -1
    elif [ "$leader_id" -lt "0" ]; then
        echo "Multiple leaders found from ${column}=${criteria}."
        return -1
    else
        echo "Leader ${leader_id} found from ${column}=${criteria}."
    fi

    display_leader_info "id" "${leader_id}"
    display_leader_assignment "${leader_id}"
}

function add_leader {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_ADD_LEADER operation."
        echo "Syntax: $CMD_ADD_LEADER <\"name\"> <\"contact\">"
        return -1
    fi

    local name="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'contact' argument to $CMD_ADD_LEADER operation."
        echo "Syntax: $CMD_ADD_LEADER <\"name\"> <\"contact\">"
        return -1
    fi

    local contact="$1"
    shift

    local count=$(leader_exists "name=${name}")
    if [ ${count} -eq 1 ]; then
        echo "Leader '${name}' already exists."
        return -1
    elif [ ${count} -gt 0 ]; then
        echo "Multiple '${name}' leaders found."
        return -1
    fi

    # Check if contact number already exists
    #count=$(contact_exists "${contact}")
    #if [ ${count} -eq 1 ]; then
    #    echo "An existing leader already uses that contact number."
    #    # Show the leader who owns the existing contact number
    #    display_leader_info "contact" "${contact}"
    #    return -1
    #elif [ ${count} -gt 0 ]; then
    #    echo "Multiple leaders having the same contact numbers."
    #    echo "This should have been checked when adding new leaders."
    #    return -1
    #fi

    local result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select add_leader('${name}', '${contact}');"`
    # Redundant error checking necessary.
    # A new leader could have been added before we did.
    if [ "${result}" == "-1" ]; then
        echo "Error: Leader with name '${name}' already exists."
        return -1
    elif [ "${result}" == "-2" ]; then
        echo "Error: Leader with contact '${contact}' already exists."
        return -1
    else
        # Display the newly added leader information
        display_leader_info "name" "${name}"
    fi
}

function set_leader_name {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_SET_LEADER_NAME operation."
        echo "Syntax: $CMD_SET_LEADER_NAME <id> <\"name\">"
        return -1
    fi

    local leader_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_SET_LEADER_NAME operation."
        echo "Syntax: $CMD_SET_LEADER_NAME <id> <\"name\">"
        return -1
    fi

    local name="$1"
    shift

    local count=$(leader_exists "id=${leader_id}")
    if [ ${count} -eq 0 ]; then
        echo "Leader ID '${leader_id}' is not found."
        return -1
    elif [ ${count} -gt 1 ]; then
        echo "Multiple '${name}' leaders found."
        return -1
    fi

    # Get old leader name
    local old_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_leader_name(${leader_id});"`
    local new_value="${name}"

    local result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select set_leader_name(${leader_id}, '${name}');"`
    if [ "${result}" == "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi

    echo "Leader '${leader_id}' name set."
    echo "Old: '${old_value}'"
    echo "New: '${new_value}'"
}

function set_leader_contact {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_SET_LEADER_NAME operation."
        echo "Syntax: $CMD_SET_LEADER_NAME <id> <\"name\">"
        return -1
    fi

    local leader_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_SET_LEADER_NAME operation."
        echo "Syntax: $CMD_SET_LEADER_NAME <id> <\"name\">"
        return -1
    fi

    local contact="$1"
    shift

    local count=$(leader_exists "id=${leader_id}")
    if [ ${count} -eq 0 ]; then
        echo "Leader ID '${leader_id}' is not found."
        return -1
    elif [ ${count} -gt 1 ]; then
        echo "Multiple '${name}' leaders found."
        return -1
    fi

    local old_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_leader_contact(${leader_id});"`
    local new_value="${contact}"

    local result=`psql -d postgres -w -q        \
        --no-align                              \
        -c '\t'                                 \
        -c "select set_leader_contact(${leader_id}, '${contact}');"`
    if [ "${result}" == "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    fi

    echo "Leader '${leader_id}' contact number set."
    echo "Old: '${old_value}'"
    echo "New: '${new_value}'"
}

# Checks if precinct already exists.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   Return the number of found rows.
#
# Syntax:
#   precinct_exists id=<precinct_id>
#
# local result=$(precinct_exists id=text)
#
# if [ "$result" -eq "0" ]; then
# if [ "$result" == "0" ]; then
function precinct_exists {
    if [ $# -eq 0 ]; then
        echo "0"
        return -1
    fi

    arg="$1"
    if [ -z "$arg" ]; then
        #echo "Argument is empty."
        echo "0"
        return -1
    fi
    column=${arg%=*}    # Remove suffix with =
    criteria=${arg#*=}  # Remove prefix with =

    if [ ! "${column}" == "id" ]; then
        # Specified column name is wrong
        echo "0"
        return -1
    fi

    if [ -z "$criteria" ]; then
        # Criteria is empty
        echo "0"
        return -1
    fi

    local -r SELECT="select count(*) from vt_precinct where"

    local -r WHERE_PRECINCT_LIKE="trim(to_char(id, '999999')) like '${criteria}'"
    local -r WHERE_PRECINCT_IS="id = ${criteria}"

    local SQL=""

    if [[ "${criteria}" == *"%"* || "${criteria}" == *"_"* ]]; then
        SQL="${SELECT} ${WHERE_PRECINCT_LIKE};"
    else
        SQL="${SELECT} ${WHERE_PRECINCT_IS};"
    fi

    local -r result=`psql -d postgres -w -q -A -c '\t' -c "${SQL}"`
    echo "${result}"
}

function set_leader_assignment {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_SET_LEADER_ASSIGNMENT operation."
        echo "Syntax: $CMD_SET_LEADER_ASSIGNMENT <id> <\"name\">"
        return -1
    fi

    local leader_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_SET_LEADER_NAME operation."
        echo "Syntax: $CMD_SET_LEADER_NAME <id> <\"name\">"
        return -1
    fi

    local precinct_id="$1"
    shift

    local count=$(leader_exists "id=${leader_id}")
    if [ ${count} -eq 0 ]; then
        echo "Leader ID '${leader_id}' is not found."
        return -1
    elif [ ${count} -gt 1 ]; then
        echo "Multiple '${name}' leaders found."
        return -1
    fi

    count=$(precinct_exists "id=${precinct_id}")
    if [ ${count} -eq 0 ]; then
        echo "Precinct ID '${precinct_id}' is not found."
        return -1
    elif [ ${count} -gt 1 ]; then
        echo "Multiple '${precinct_id}' precincts found."
        return -1
    fi

    local -r result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select set_leader_assignment(${leader_id}, ${precinct_id});"`
    if [ "${result}" == "-1" ]; then
        echo "Error: Leader ${leader_id} not found."
        return -1
    elif [ "${result}" == "-2" ]; then
        echo "Error: Precinct ${precinct_id} not found."
        return -2
    elif [ "${result}" == "-3" ]; then
        echo "Error: Leader ${leader_id} already assigned to Precinct ID ${precinct_id}."
        return -3
    fi

    echo "Leader ${leader_id} assigned to Precinct ${precinct_id}."
    display_leader_assignment "${leader_id}"
}

# Display the precinct information.
#
# The function assumes that the parameters have been checked and verified
# because they are not checked here for validity.
#
# Return:
#   If the precinct id is found, then the precinct information is sent to
#   the standard output.
#
# Syntax:
#   display_precinct_info <leader id>
#
#   display_precinct_info 10
function display_precinct_info {
    local -r precinct_id="$1"
    shift
    echo ""
    local -r SQL=""`
        `" select"`
        `"     municipality_id,"`
        `"     municipality,"`
        `"     barangay,"`
        `"     precinct_id,"`
        `"     precinct,"`
        `"     current_sum,"`
        `"     target_sum,"`
        `"     voters_sum,"`
        `"     current_percentage,"`
        `"     target_percentage"`
        `" from"`
        `"     view_precinct"`
        `" where"`
        `"     precinct_id = ${precinct_id};"
    psql -d postgres -w -q      \
        -c '\t'                 \
        -c '\pset expanded'     \
        -c '\pset pager off'    \
        -c '\pset footer off'   \
        -c "$SQL"
}

function add_precinct_current {
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_ADD_PRECINCT_CURRENT operation."
        echo "Syntax: $CMD_ADD_PRECINCT_CURRENT <precinct-id> <number>"
        return -1
    fi
    if [[ "${1}" == "-f" ]]; then
        shift
        add_precinct_current_from_file
    elif [[ "${1}" == "-id" ]]; then
        add_precinct_current_value_using_id "${1}" "${2}"
    else
        add_precinct_current_value_using_name
    fi
}

function add_precinct_current_value_using_id {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_ADD_PRECINCT_CURRENT operation."
        echo "Syntax: $CMD_ADD_PRECINCT_CURRENT <precinct-id> <number>"
        return -1
    fi

    local precinct_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_ADD_PRECINCT_CURRENT operation."
        echo "Syntax: $CMD_ADD_PRECINCT_CURRENT <precinct-id> <number>"
        return -1
    fi

    local add_value="$1"
    shift

    local -r count=$(precinct_exists "id=${precinct_id}")
    if [[ "${count}" -eq "0" ]]; then
        echo "Precinct ID '${precinct_id}' is not found."
        return -1
    elif [[ "${count}" -gt "1" ]]; then
        echo "Multiple '${precinct_id}' precincts found."
        return -1
    fi

    if [[ "${add_value}" -eq "0" ]]; then
        echo "Operation aborted."
        echo "Adding or subtracting zero (0) makes no sense."
        return -1
    fi

    local -r old_value=`psql -d postgres -w -q  \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_current(${precinct_id});"`

    local result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select add_precinct_current(${precinct_id}, ${add_value});"`
    if [ "${result}" == "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi

    local new_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_current(${precinct_id});"`

    echo "Added ${add_value} to Precinct ID ${precinct_id} current value."
    echo "Old value: ${old_value}"
    echo "New value: ${new_value}"

    display_precinct_info ${precinct_id}
}

function add_precinct_current_value_using_name {
    echo "Implement add_precinct_current_value_using_name function."
}

function add_precinct_current_from_file {
    ./import.sh --import current
}

function set_precinct_current {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_ADD_PRECINCT_CURRENT operation."
        echo "Syntax: $CMD_ADD_PRECINCT_CURRENT <precinct-id> <number>"
        return -1
    fi

    local precinct_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_ADD_PRECINCT_CURRENT operation."
        echo "Syntax: $CMD_ADD_PRECINCT_CURRENT <precinct-id> <number>"
        return -1
    fi

    local value="$1"
    shift

    local -r count=$(precinct_exists "id=${precinct_id}")
    if [ ${count} -eq 0 ]; then
        echo "Precinct ID '${precinct_id}' is not found."
        return -1
    elif [ ! ${count} -eq 1 ]; then
        echo "Multiple '${precinct_id}' precincts found."
        return -1
    fi

    local -r old_value=`psql -d postgres -w -q  \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_current(${precinct_id});"`

    local result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select set_precinct_current(${precinct_id}, ${value});"`
    if [ "${result}" == "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi

    local new_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_current(${precinct_id});"`

    echo "Added ${value} to Precinct ID ${precinct_id} current value."
    echo "Old value: ${old_value}"
    echo "New value: ${new_value}"

    display_precinct_info ${precinct_id}
}

function set_precinct_target {
    check_if_server_is_ready
    if [ $# -eq 0 ]; then
        echo "Missing arguments to $CMD_SET_PRECINCT_TARGET operation."
        echo "Syntax: $CMD_SET_PRECINCT_TARGET <precinct-id> <number>"
        return -1
    fi

    local precinct_id="$1"
    shift

    if [ $# -eq 0 ]; then
        echo "Missing 'name' argument to $CMD_SET_PRECINCT_TARGET operation."
        echo "Syntax: $CMD_SET_PRECINCT_TARGET <precinct-id> <number>"
        return -1
    fi

    local value="$1"
    shift

    local -r count=$(precinct_exists "id=${precinct_id}")
    if [ ${count} -eq 0 ]; then
        echo "Precinct ID '${precinct_id}' is not found."
        return -1
    elif [ ! ${count} -eq 1 ]; then
        echo "Multiple '${precinct_id}' precincts found."
        return -1
    fi

    local old_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_target(${precinct_id});"`

    local result=`psql -d postgres -w -q    \
        --no-align                          \
        -c '\t'                             \
        -c "select set_precinct_target(${precinct_id}, ${value});"`
    if [ "${result}" == "0" ]; then
        echo "Error: Precinct ID: ${precinct_id} not found."
        return -1
    fi

    local new_value=`psql -d postgres -w -q     \
        --no-align                              \
        -c '\t'                                 \
        -c "select get_precinct_target(${precinct_id});"`

    echo "Added ${value} to Precinct ID ${precinct_id} current value."
    echo "Old value: ${old_value}"
    echo "New value: ${new_value}"

    display_precinct_info ${precinct_id}
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
    $CMD_TEST
    $CMD_GET_PRECINCT_INFO
    $CMD_GET_LEADER_INFO
    $CMD_GET_LEADER_ASSIGNMENT
    $CMD_ADD_LEADER
    $CMD_SET_LEADER_NAME
    $CMD_SET_LEADER_CONTACT
    $CMD_SET_LEADER_ASSIGNMENT
    $CMD_ADD_PRECINCT_CURRENT
    $CMD_SET_PRECINCT_CURRENT
    $CMD_SET_PRECINCT_TARGET
)

if [[ ! "${commands[@]}" =~ "${1}" ]]; then
    echo_err "Unknown command ${1}."
    echo ""
    echo "See help for complete information: ./$PROGRAM_NAME --help"
    exit 1
fi

arg_command="${1}"
shift

case "${arg_command}" in
    $CMD_TEST)                      test "$@" ;;
    $CMD_GET_PRECINCT_INFO)         get_precinct_info "$@" ;;
    $CMD_GET_LEADER_INFO)           get_leader_info "$@" ;;
    $CMD_GET_LEADER_ASSIGNMENT)     get_leader_assignment "$@" ;;

    $CMD_ADD_LEADER)                add_leader "$@" ;;
    $CMD_SET_LEADER_NAME)           set_leader_name "$@" ;;
    $CMD_SET_LEADER_CONTACT)        set_leader_contact "$@" ;;

    $CMD_SET_LEADER_ASSIGNMENT)     set_leader_assignment "$@" ;;
    $CMD_ADD_PRECINCT_CURRENT)      add_precinct_current "$@" ;;
    $CMD_SET_PRECINCT_CURRENT)      set_precinct_current $@ ;;
    $CMD_SET_PRECINCT_TARGET)       set_precinct_target $@ ;;
esac

#  psql -d postgres -w -t -c "${SQL_COMMAND}"
