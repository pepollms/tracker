drop view if exists view_current;
create or replace view view_current
    (contact,
        municipality_id,
        precinct,
        precinct_id,
        current)
as
    select
        vt_current.contact,
        vt_current.municipality_code,
        vt_current.precinct,
        vt_precinct.id,
        vt_current.current
    from
        vt_current
        inner join vt_precinct on (vt_precinct.name = vt_current.precinct)
        inner join vt_barangay on (vt_barangay.id = vt_precinct.barangay_id)
        inner join vt_municipality on (vt_municipality.id = vt_barangay.municipality_id);
