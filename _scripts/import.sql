-- Import data into database



\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_1.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_2.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_3.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';



--------------------------------------------------------------------------------



-- Insert Districts from the import table
-- District ID is auto-generated
insert into vt_district(province_id, name)
select distinct
    1,
    district || ' DISTRICT' as district_name
from vtracker
order by district_name asc;

-- Insert Municipalities from the import table
insert into vt_municipality(district_id, id, name)
select distinct
    to_number(district, '9') as district_number,
    municipality_code,
    municipality
from vtracker
order by district_number, municipality asc;

-- Insert Barangays from the import table
insert into vt_barangay(municipality_id, name)
select distinct
    vt_municipality.id,
    barangay
from vtracker
    inner join vt_municipality on (vtracker.municipality = vt_municipality.name)
order by barangay asc;

-- Insert Leaders from the import table
insert into vt_leader(name, contact)
select distinct
    leader,
    contact
from vtracker
order by leader asc;

-- Insert Precincts from the import table
-- insert into vt_precinct(barangay_id, name, voters, target)
-- select distinct
--     (select vt_barangay.id
--         from vt_barangay
--         where
--             vt_municipality.id = vt_barangay.municipality_id and
--             vt_barangay.name = vtracker.barangay) as bid,
--     vtracker.precinct,
--     vtracker.voters,
--     vtracker.target
-- from
--     vtracker
--     inner join vt_municipality on (vtracker.municipality = vt_municipality.name)
-- order by bid, precinct asc;

-- Corrected?
insert into vt_precinct(barangay_id, name, voters, target)
select
    (select vt_barangay.id
        from
            vt_barangay
            inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
            inner join vt_district on (vt_municipality.district_id = vt_district.id)
        where
            vtracker.barangay = vt_barangay.name
            and vtracker.municipality = vt_municipality.name
            and vt_district.name like vtracker.district || '%') as bid,
    vtracker.precinct,
    vtracker.voters,
    vtracker.target
from
    vtracker
order by district, municipality, barangay, precinct asc;

-- Display precincts
-- select
--     vt_precinct.id,
--     vt_precinct.name as precinct,
--     vt_barangay.name as bararangay,
--     vt_municipality.name as municipality
-- from
--     vt_precinct
--     inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
--     inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)

-- Insert Leader-Precinct assignments
insert into vt_leader_assignment(precinct_id, leader_id)
select
    (select vt_precinct.id
        from
            vt_precinct,
            vt_barangay,
            vt_municipality,
            vt_district
        where
            vt_precinct.barangay_id = vt_barangay.id
            and vt_barangay.municipality_id = vt_municipality.id
            and vt_municipality.district_id = vt_district.id
            and vtracker.precinct = vt_precinct.name
            and vtracker.barangay = vt_barangay.name
            and vtracker.municipality = vt_municipality.name
            and vt_district.name like vtracker.district || '%') as precinct_id,
    (select vt_leader.id
        from
            vt_leader
        where
            vt_leader.name = vtracker.leader) as leader_id
    --vtracker.precinct,
    --vtracker.leader,
    --vtracker.contact
from
    vtracker;

---------------------------------
-- NOTE:
-- Compute value from percentage
-- We will not need this when the target data becomes a value instead
-- of a percentage
---------------------------------
update vt_precinct as dest
set target = get_percentage_value(target, voters);

-- Insert precinct initial (zero) current values
insert into vt_current(precinct_id, current)
select vt_precinct.id, 0
from vt_precinct;
