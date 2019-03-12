select
    array_to_json(array_agg(row_to_json(t)))
from (
    select
        municipality_id,
        municipality,
        barangay_id,
        barangay,
        to_char(current_sum, 'FM999,999') as current_count,
        to_char(target_sum, 'FM999,999') as target_count,
        to_char(voters_sum, 'FM999,999') as total_voters,
        current_percentage,
        target_percentage
    from
        view_barangay
    order by
        current_percentage,
        divide(current_sum, target_sum),
        barangay,
        municipality
    ) t;
