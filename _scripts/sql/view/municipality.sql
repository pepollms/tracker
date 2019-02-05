drop view if exists view_municipality;
create or replace view view_municipality
    (district_id,
        district,
        municipality_id,
        municipality,
        current_sum,
        target_sum,
        voters_sum,
        current_percentage,
        target_percentage)
as
    select
        district_id,
        district,
        municipality_id,
        municipality,
        sum(current_sum),
        sum(target_sum),
        sum(voters_sum),
        get_percentage(sum(current_sum), sum(target_sum)),
        get_percentage(sum(target_sum), sum(voters_sum))
    from
        view_precinct
    group by
        district_id,
        district,
        municipality_id,
        municipality
    order by
        district,
        municipality;
