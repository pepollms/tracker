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
        current,
        target,
        voters,
        get_percentage(current, target),
        get_percentage(target, voters)
    from
        vt_precinct
        inner join vt_precinct_monitor
            on (vt_precinct.id = vt_precinct_monitor.precinct_id)
        inner join vt_leader_precinct_assignment as lpa
            on (vt_precinct.id = lpa.precinct_id)
        inner join vt_leader on (lpa.leader_id = vt_leader.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
        inner join vt_municipality
            on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district
            on (vt_municipality.district_id = vt_district.id);
