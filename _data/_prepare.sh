#!/usr/bin/env bash

# Make sure CSV files are readable
chmod 777 ../../../database/to_import/district_1.csv
chmod 777 ../../../database/to_import/district_2.csv
chmod 777 ../../../database/to_import/district_3.csv

sed -i 's/1ST/1/g' ../../../database/to_import/district_1.csv
sed -i 's/2ND/2/g' ../../../database/to_import/district_2.csv
sed -i 's/3RD/3/g' ../../../database/to_import/district_3.csv
