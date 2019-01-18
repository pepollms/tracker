drop view if exists view_districts_per_province;
create or replace view view_districts_per_province
    (province_id, province, district_count)
as
    select
        vt_province.id,
        vt_province.name,
        count(vt_district.id)
    from
        vt_province
        inner join vt_district on (vt_province.id = vt_district.province_id)
    group by
        vt_province.id,
        vt_province.name
    order by
        vt_province.name;
