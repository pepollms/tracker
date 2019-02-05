drop view if exists view_import_current;
create or replace view view_import_current
    (municipality_id,
        municipality,
        barangay_id,
        barangay,
        precinct_id,
        precinct,
        leader_contact,
        current,
        imported_when)
as
    select
        vt_municipality.id,
        vt_municipality.name,
        vt_barangay.id,
        vt_barangay.name,
        vt_precinct.id,
        vt_precinct.name,
        vt_import_current.contact,
        vt_import_current.current,
        vt_import_current.imported_when
    from
        vt_import_current
        inner join vt_municipality on (vt_municipality.id = vt_import_current.municipality_code)
        inner join vt_barangay on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_precinct on (vt_precinct.barangay_id = vt_barangay.id)
    where
        vt_precinct.name = vt_import_current.precinct
    order by
        vt_municipality.name,
        vt_barangay.name,
        vt_precinct.name;
