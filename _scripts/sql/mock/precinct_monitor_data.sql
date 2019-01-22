-- Mock data for the vt_precinct_monitor table



-- Set current count to a random number up to 80%  of the target count
-- insert into vt_current(precinct_id, current)
-- select vt_precinct.id, random_between(1, ((vt_precinct.target / 10) * 8)::integer)
-- from vt_precinct;


-- Set current count between 1 and 80% of target
update vt_precinct_monitor
set current = random_between(1, get_percentage_value(70, vt_precinct_monitor.target))
from
    vt_precinct
    inner join vt_barangay on (vt_barangay.id = vt_precinct.barangay_id)
    inner join vt_municipality on (vt_municipality.id = vt_barangay.municipality_id)
where
    vt_precinct.id = vt_precinct_monitor.precinct_id;



-- Set current count between 1 and 80% of target of specified municipality
-- update vt_current
-- set current = random_between(1, get_percentage_value(80, vt_precinct.target))
-- from
--     vt_precinct,
--     vt_barangay,
--     vt_municipality
-- where
--     vt_current.precinct_id = vt_precinct.id
--     and vt_precinct.barangay_id = vt_barangay.id
--     and vt_barangay.municipality_id = 1

-- Set current count between 1 and 80% of target of specified district
-- update vt_current
-- set current = random_between(1, get_percentage_value(80, vt_precinct.target))
-- from
--     vt_precinct,
--     vt_barangay,
--     vt_municipality,
--     vt_district
-- where
--     vt_current.precinct_id = vt_precinct.id
--     and vt_precinct.barangay_id = vt_barangay.id
--     and vt_barangay.municipality_id = vt_municipality.id
--     and vt_district.id = 1

-- update vtx_current
-- set current = random_between(1, get_percentage_value(80, vtx_municipality.target))
-- from
--     vtx_municipality;
