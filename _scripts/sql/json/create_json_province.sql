select
    row_to_json(x)
from (
    select (
        select
            row_to_json(t)
        from (
            select
                to_char(current_count_sum, 'FM999,999') as current_count,
                to_char(target_count_sum, 'FM999,999') as target_count,
                to_char(total_voters_sum, 'FM999,999') as total_voters,
                current_percentage,
                target_percentage
            from
                view_province
            ) t
        ) as total
    ) x;
