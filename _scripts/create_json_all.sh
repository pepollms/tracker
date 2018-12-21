#!/usr/bin/env bash

# psql options:
#
#   -d dbname
#   --dbname=dbname
#       Specifies the name of the database to connect to. This is equivalent to specifying
#       dbname as the first non-option argument on the command line.
#       If this parameter contains an = sign or starts with a valid URI prefix
#       (postgresql:// or postgres://), it is treated as a conninfo string. See
#       Section 33.1.1 for more information.
#
#   -e
#   --echo-queries
#       Copy all SQL commands sent to the server to standard output as well. This is
#       equivalent to setting the variable ECHO to queries.
#
#   -f filename
#   --file=filename
#       Read commands from the file filename, rather than standard input. This option can
#       be repeated and combined in any order with the -c option. When either -c or -f is
#       specified, psql does not read commands from standard input; instead it terminates
#       after processing all the -c and -f options in sequence. Except for that, this
#       option is largely equivalent to the meta-command \i.
#
#       If filename is - (hyphen), then standard input is read until an EOF indication or
#       \q meta-command. This can be used to intersperse interactive input with input from
#       files. Note however that Readline is not used in this case (much as if -n had been
#       specified).
#
#       Using this option is subtly different from writing psql < filename. In general,
#       both will do what you expect, but using -f enables some nice features such as
#       error messages with line numbers. There is also a slight chance that using this
#       option will reduce the start-up overhead. On the other hand, the variant using the
#       shell's input redirection is (in theory) guaranteed to yield exactly the same
#       output you would have received had you entered everything by hand.
#
#   -t
#   --tuples-only
#       Turn off printing of column names and result row count footers, etc. This is
#       equivalent to \t or \pset tuples_only.
#
#   -w
#   --no-password
#       Never issue a password prompt. If the server requires password authentication and
#       a password is not available by other means such as a .pgpass file, the connection
#       attempt will fail. This option can be useful in batch jobs and scripts where no
#       user is present to enter a password.
#
#       Note that this option will remain set for the entire session, and so it affects
#       uses of the meta-command \connect as well as the initial connection attempt.

declare -r DESTINATION_DIR="../_data"

psql -d postgres -w -t -c "select row_to_json(t) from (select 'NORTH COTABATO' as name) t;" -o ${DESTINATION_DIR}/province.json

psql -d postgres -w -t -f create_json_totals.sql -o ${DESTINATION_DIR}/all.json

psql -d postgres -w -t -f create_json_regions.sql -o ${DESTINATION_DIR}/regions.json

# Results are sorted by name
psql -d postgres -w -t -f create_json_districts.sql -o ${DESTINATION_DIR}/districts.json
psql -d postgres -w -t -f create_json_municipalities.sql -o ${DESTINATION_DIR}/municipalities.json
psql -d postgres -w -t -f create_json_barangays.sql -o ${DESTINATION_DIR}/barangays.json
psql -d postgres -w -t -f create_json_precincts.sql -o ${DESTINATION_DIR}/precincts.json

# Results are sorted by current / target
psql -d postgres -w -t -f create_json_municipalities_details.sql -o ${DESTINATION_DIR}/municipalities_details.json
psql -d postgres -w -t -f create_json_barangays_details.sql -o ${DESTINATION_DIR}/barangays_details.json
psql -d postgres -w -t -f create_json_precincts_details.sql -o ${DESTINATION_DIR}/precincts_details.json
