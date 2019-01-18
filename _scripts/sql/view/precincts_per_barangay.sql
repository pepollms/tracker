drop view if exists view_precincts_per_barangay;
create or replace view view_precincts_per_barangay
    (district_id, district, municipality_id, municipality, barangay_id, barangay, precinct_count)
as
    select
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        vt_barangay.id,
        vt_barangay.name,
        count(vt_precinct.id)
    from
        vt_precinct
        inner join vt_barangay on (vt_barangay.id = vt_precinct.barangay_id)
        inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district on (vt_municipality.district_id = vt_district.id)
    group by
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        vt_barangay.id,
        vt_barangay.name
    order by
        vt_district.name,
        vt_municipality.name,
        vt_barangay.name;
