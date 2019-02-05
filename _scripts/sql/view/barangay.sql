drop view if exists view_barangay;
create or replace view view_barangay
    (district_id,
        district,
        municipality_id,
        municipality,
        barangay_id,
        barangay,
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
        barangay_id,
        barangay,
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
        municipality,
        barangay_id,
        barangay
    order by
        district,
        municipality,
        barangay;
