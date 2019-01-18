drop view if exists view_barangays_per_municipality;
create or replace view view_barangays_per_municipality
    (district_id, district, municipality_id, municipality, barangay_count)
as
    select
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        count(vt_barangay.id)
    from
        vt_barangay
        inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district on (vt_municipality.district_id = vt_district.id)
    group by
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name
    order by
        vt_district.name,
        vt_municipality.name;
