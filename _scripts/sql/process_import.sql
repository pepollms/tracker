-- Insert Districts from the import table
-- District ID is auto-generated
insert into vt_district(province_id, name)
select distinct
    1,
    district || ' District' as district_name
from vt_import
order by district_name asc;

-- Insert Municipalities from the import table
insert into vt_municipality(id, district_id, name)
select distinct
    municipality_code,
    to_number(district, '9') as district_number,
    municipality
from vt_import
order by district_number, municipality asc;

-- Insert Barangays from the import table
insert into vt_barangay(municipality_id, name)
select distinct
    vt_municipality.id,
    barangay
from vt_import
    inner join vt_municipality on (vt_import.municipality = vt_municipality.name)
order by barangay asc;

-- Insert Leaders from the import table
insert into vt_leader(name, contact)
select distinct
    leader,
    contact
from vt_import
order by leader asc;

-- Insert Precincts from the import table
insert into vt_precinct(barangay_id, name)
select
    (select vt_barangay.id
        from
            vt_barangay
            inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
            inner join vt_district on (vt_municipality.district_id = vt_district.id)
        where
            vt_import.barangay = vt_barangay.name
            and vt_import.municipality = vt_municipality.name
            and vt_district.name like vt_import.district || '%') as bid,
    vt_import.precinct
from
    vt_import
order by
    district,
    municipality,
    barangay,
    precinct asc;

-- Insert precinct monitor values from the import table
insert into vt_precinct_monitor(precinct_id, voters, target, current)
select
    (select vt_precinct.id
        from
            vt_precinct
            inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
            inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
            inner join vt_district on (vt_municipality.district_id = vt_district.id)
        where
            vt_import.precinct = vt_precinct.name
            and vt_import.barangay = vt_barangay.name
            and vt_import.municipality = vt_municipality.name
            and vt_district.name like vt_import.district || '%') as bid,
    -- Compute value from percentage
    -- The input target is a percentage, so we need to compute the approximate
    -- value of that percentage.
    get_percentage_value(vt_import.target, vt_import.voters),
    vt_import.voters,
    0
from
    vt_import;


-- Insert Leader-Precinct assignments
insert into vt_leader_precinct_assignment(precinct_id, leader_id)
select
    (select vt_precinct.id
        from
            vt_precinct
            inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
            inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
            inner join vt_district on (vt_municipality.district_id = vt_district.id)
        where
            vt_import.precinct = vt_precinct.name
            and vt_import.barangay = vt_barangay.name
            and vt_import.municipality = vt_municipality.name
            and vt_district.name like vt_import.district || '%') as precinct_id,
    (select vt_leader.id
        from
            vt_leader
        where
            vt_leader.name = vt_import.leader) as leader_id
from
    vt_import;
