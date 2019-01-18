drop view if exists view_municipalities_per_district;
create or replace view view_municipalities_per_district
    (district_id, district, municipality_count)
as
    select
        vt_district.id,
        vt_district.name,
        count(vt_municipality.id)
    from
        vt_municipality
        inner join vt_district on (vt_municipality.district_id = vt_district.id)
    group by
        vt_district.id,
        vt_district.name
    order by
        vt_district.name;
