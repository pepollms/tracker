-- Create views for generating JSON data files



-- Precinct view
drop view if exists view_precinct;
create or replace view view_precinct
    (district_id,
        district,
        municipality_id,
        municipality,
        barangay_id,
        barangay,
        precinct_id,
        precinct,
        leader_id,
        leader,
        leader_contact,
        current_sum,
        target_sum,
        voters_sum,
        current_percentage,
        target_percentage)
as
    select
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        vt_barangay.id,
        vt_barangay.name,
        vt_precinct.id,
        vt_precinct.name,
        vt_leader.id,
        vt_leader.name,
        vt_leader.contact,
        vt_values.current,
        vt_values.target,
        vt_values.voters,
        get_percentage(vt_values.current, vt_values.target),
        get_percentage(vt_values.target, vt_values.voters)
    from
        vt_precinct
        inner join vt_values on (vt_precinct.id = vt_values.precinct_id)
        inner join vt_leader_assignment
            on (vt_precinct.id = vt_leader_assignment.precinct_id)
        inner join vt_leader on (vt_leader_assignment.leader_id = vt_leader.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
        inner join vt_municipality
            on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district
            on (vt_municipality.district_id = vt_district.id);



-- Barangay view
drop view if exists view_barangay;
create or replace view view_barangay
    (district_id,
        district,
        municipality_id,
        municipality,
        barangay_id,
        barangay,
        voters_sum,
        target_sum,
        current_sum,
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
        current_percentage,
        target_percentage
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
        district
        municipality,
        barangay;



-- Municipality view
drop view if exists view_municipality;
create or replace view view_municipality
    (district_id,
        district,
        municipality_id,
        municipality,
        voters_sum,
        target_sum,
        current_sum,
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
        current_percentage,
        target_percentage
        get_percentage(sum(current_sum), sum(target_sum)),
        get_percentage(sum(target_sum), sum(voters_sum))
    from
        view_precinct
    order by
        district
        municipality;



-- District view
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
        current_percentage,
        target_percentage
        get_percentage(sum(current_sum), sum(target_sum)),
        get_percentage(sum(target_sum), sum(voters_sum))
    from
        view_precinct
    order by
        district;



-- Province view
drop view if exists view_province;
create or replace view view_province
    (current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
        target_percentage)
as
    select
        sum(vt_current.current),
        sum(vt_precinct.target),
        get_percentage(sum(vt_current.current), sum(vt_precinct.target)),
        sum(vt_precinct.voters),
        get_percentage(sum(vt_precinct.target), sum(vt_precinct.voters))
    from
        view_precinct;
