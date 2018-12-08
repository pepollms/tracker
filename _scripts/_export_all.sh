#!/usr/bin/env bash

psql -d postgres -w -t -f _export_districts.sql -o districts.json
psql -d postgres -w -t -f _export_municipalities.sql -o municipalities.json
psql -d postgres -w -t -f _export_barangays.sql -o barangays.json
psql -d postgres -w -t -f _export_precincts.sql -o precincts.json
