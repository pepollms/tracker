select array_to_json(array_agg(row_to_json(t)))
from (
    select
        vt_district.id,
        vt_district.name,
        to_char(sum(vt_current.current), 'FM999,999') as current_count,
        to_char(sum(vt_precinct.target), 'FM999,999') as target_count,
        to_char(sum(vt_precinct.voters), 'FM999,999') as total_voters,
        (sum(vt_current.current) / sum(vt_precinct.target) * 100)::integer as current_percent,
        (sum(vt_precinct.target) / sum(vt_precinct.voters) * 100)::integer as target_percent
    from
        vt_precinct
        inner join vt_current on (vt_precinct.id = vt_current.precinct_id)
        inner join vt_barangay on (vt_barangay.id = vt_precinct.barangay_id)
        inner join vt_municipality on (vt_municipality.id = vt_barangay.municipality_id)
        inner join vt_district on (vt_district.id = vt_municipality.district_id)
    group by
        vt_district.id,
        vt_district.name
    order by
        vt_district.id
) t;
