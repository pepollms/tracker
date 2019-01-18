drop view if exists view_district;
create or replace view view_district
    (district_id,
        district,
        voters_sum,
        target_sum,
        current_sum,
        current_percentage,
        target_percentage)
as
    select
        district_id,
        district,
        sum(current_sum),
        sum(target_sum),
        sum(voters_sum),
        get_percentage(sum(current_sum), sum(target_sum)),
        get_percentage(sum(target_sum), sum(voters_sum))
    from
        view_precinct
    group by
        district_id,
        district
    order by
        district;
