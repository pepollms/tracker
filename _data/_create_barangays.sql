select array_to_json(array_agg(row_to_json(t)))
from (
    select
        vt_barangay.id,
        vt_barangay.name,
        to_char(sum(vt_current.current), 'FM999,999') as current_count,
        to_char(sum(vt_precinct.target), 'FM999,999') as target_count,
        to_char(sum(vt_precinct.voters), 'FM999,999') as total_voters,
        (sum(vt_current.current) / sum(vt_precinct.voters) * 100)::integer as percent
    from
        vt_precinct
        inner join vt_current on (vt_precinct.id = vt_current.precinct_id)
        inner join vt_barangay on (vt_barangay.id = vt_precinct.barangay_id)
    group by
        vt_barangay.id,
        vt_barangay.name
    order by
        vt_barangay.name
) t;
