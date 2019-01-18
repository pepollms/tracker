drop view if exists view_province;
create or replace view view_province
    (current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
        target_percentage)
as
    select
        sum(current_sum),
        sum(target_sum),
        sum(voters_sum),
        get_percentage(sum(current_sum), sum(target_sum)),
        get_percentage(sum(target_sum), sum(voters_sum))
    from
        view_precinct;
