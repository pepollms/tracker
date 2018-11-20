#!/usr/bin/env bash

psql -d postgres -w -t -f _create_totals.sql -o all.json
psql -d postgres -w -t -f _create_districts.sql -o districts.json
psql -d postgres -w -t -f _create_municipalities.sql -o municipalities.json
psql -d postgres -w -t -f _create_barangays.sql -o barangays.json
psql -d postgres -w -t -f _create_precincts.sql -o precincts.json
