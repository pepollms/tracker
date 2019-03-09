#!/usr/bin/env bash

declare -r DESTINATION_DIR="../_data"

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_province_name.sql             \
    -o ${DESTINATION_DIR}/province.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_province.sql                  \
    -o ${DESTINATION_DIR}/all.json

# Results are sorted by name
psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_districts.sql                 \
    -o ${DESTINATION_DIR}/districts.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_municipalities.sql            \
    -o ${DESTINATION_DIR}/municipalities.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_barangays.sql                 \
    -o ${DESTINATION_DIR}/barangays.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_precincts.sql                 \
    -o ${DESTINATION_DIR}/precincts.json

# Results are sorted by current / target
psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_municipalities_details.sql    \
    -o ${DESTINATION_DIR}/municipalities_details.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_barangays_details.sql         \
    -o ${DESTINATION_DIR}/barangays_details.json

psql -d postgres -w -t                                      \
    -f ./sql/json/create_json_precincts_details.sql         \
    -o ${DESTINATION_DIR}/precincts_details.json

