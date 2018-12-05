-- Generate JSON file for Precincts
-- with formatted values

select array_to_json(array_agg(row_to_json(t)))
from (
    select
        barangay_id,
        precinct_id,
        precinct,
        leader,
        contact,
        to_char(current_count, 'FM999,999'),
        to_char(target_count, 'FM999,999'),
        to_char(total_voters, 'FM999,999'),
        current_percentage,
        target_percentage
    from
        view_precinct
    order by
        current_percentage,
        precinct
) t;
