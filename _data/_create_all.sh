#!/usr/bin/env bash

psql -d postgres -w -t -f _create_totals.sql -o all.json

# Results are sorted by name
psql -d postgres -w -t -f _create_districts.sql -o districts.json
psql -d postgres -w -t -f _create_municipalities.sql -o municipalities.json
psql -d postgres -w -t -f _create_barangays.sql -o barangays.json
psql -d postgres -w -t -f _create_precincts.sql -o precincts.json

# Results are sorted by current percentage
psql -d postgres -w -t -f _create_municipalities_details.sql -o municipalities_details.json
psql -d postgres -w -t -f _create_barangays_details.sql -o barangays_details.json
psql -d postgres -w -t -f _create_precincts_details.sql -o precincts_details.json
