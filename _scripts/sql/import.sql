-- Import data into database

\COPY vt_region(code, name, aka, abbreviation) FROM '../_data/to_import/region.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vt_province(region_id, code, name, aka) FROM  '../_data/to_import/province.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

\COPY vt_import(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../_data/to_import/converted/district_1.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vt_import(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../_data/to_import/converted/district_2.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vt_import(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../_data/to_import/converted/district_3.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
