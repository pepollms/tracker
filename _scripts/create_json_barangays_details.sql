-- Generate JSON file for Barangays
-- with formatted values

select array_to_json(array_agg(row_to_json(t)))
from (
    select
        municipality_id,
        municipality,
        barangay_id,
        barangay,
        to_char(current_count_sum, 'FM999,999') as current_count,
        to_char(target_count_sum, 'FM999,999') as target_count,
        to_char(total_voters_sum, 'FM999,999') as total_voters,
        current_percentage,
        target_percentage
    from
        view_barangay
    order by
        current_percentage,
        current_count_sum / target_count_sum,
        barangay,
        municipality
) t;
