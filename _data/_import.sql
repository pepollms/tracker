-- Make sure the postgresql server is running
--   systemctl start postgresql
--
-- Execute this file using _import.sh

-- Function that returns the percentage of two numbers
-- Example: 70 is 35% of 200
--   select get_percentage(70, 200) returns 35
DROP FUNCTION IF EXISTS public.get_percentage CASCADE;
CREATE OR REPLACE FUNCTION public.get_percentage(p_n numeric, p_total numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    IF p_n::integer = 0 THEN
        RETURN 0;
    ELSE
        RETURN (p_n / p_total) * 100;
    END IF;
end;
$function$;

-- Function that returns the value of the percentage of a given number
-- Example: 70% of 200 is 140
--   select get_percentage_value(70, 200) returns 140
DROP FUNCTION IF EXISTS public.get_percentage_value CASCADE;
CREATE OR REPLACE FUNCTION public.get_percentage_value(p_percent numeric, p_n numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN (p_percent * p_n) / 100;
end;
$function$;

-- Create user-defined function returning a number between a specified range
DROP FUNCTION IF EXISTS public.random_between CASCADE;
CREATE OR REPLACE FUNCTION public.random_between(p_start integer, p_end integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN floor(random() * (p_end - p_start + 1) + p_start);
END;
$function$;



--------------------------------------------------------------------------------



-- Delete dependencies first
drop view if exists view_municipality_per_district;
drop view if exists view_barangays_per_municipality;
drop view if exists view_precincts_per_barangay;

drop view if exists view_province;
drop view if exists view_district;
drop view if exists view_municipality;
drop view if exists view_barangay;
drop view if exists view_precinct;
-- drop view if exists view_leader_assignment;



--------------------------------------------------------------------------------



-- Create import table
DROP TABLE IF EXISTS vtracker;
CREATE TABLE vtracker
(
    id serial NOT NULL,
    province character varying(50) NOT NULL,
    district character varying(10) NOT NULL,
    municipality character varying(50) NOT NULL,
    municipality_code numeric(10) NOT NULL,
    barangay character varying(50) NOT NULL,
    precinct character varying(10) NOT NULL,
    voters numeric(10) NOT NULL,
    leader character varying(100) NOT NULL,
    contact character varying(50) NOT NULL,
    target numeric(10,0) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);


-- Trigger function
-- Converts percentage string to numeric value
-- CREATE OR REPLACE FUNCTION ps_to_int()
--     RETURNS trigger
--     LANGUAGE plpgsql
--     AS $function$
-- BEGIN
--     INSERT INTO
--         vtracker(
--             province,
--             district,
--             municipality,
--             municipality_code,
--             barangay,
--             precinct,
--             voters,
--             leader,
--             contact,
--             target)
--     VALUES(
--         new.province,
--         new.district,
--         new.municipality,
--         new.municipality_code,
--         new.barangay,
--         new.precinct,
--         new.voters,
--         new.leader,
--         new.contact,
--         new.target);
--     RETURN NEW;
-- END;
-- $function$;

-- Trigger
-- CREATE TRIGGER vtracker_insert_trigger
--     BEFORE INSERT
--     ON vtracker
--     FOR EACH ROW
--     EXECUTE PROCEDURE ps_to_int();

-- Districts
DROP TABLE IF EXISTS vt_district;
CREATE TABLE vt_district
(
    id serial NOT NULL,
    code character varying(10),
    province_id numeric(10, 0) NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vt_district_pkey PRIMARY KEY (id)
);

-- Municipalities
DROP TABLE IF EXISTS vt_municipality;
CREATE TABLE vt_municipality
(
    id serial NOT NULL,
    code character varying(10),
    district_id numeric(10,0) NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vt_municipality_pkey PRIMARY KEY (id)
);

-- Barangays
DROP TABLE IF EXISTS vt_barangay;
CREATE TABLE vt_barangay
(
    id serial NOT NULL,
    code character varying(10),
    municipality_id numeric(10,0) NOT NULL,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vt_barangay_pkey PRIMARY KEY (id)
);

-- Leaders
DROP TABLE IF EXISTS vt_leader;
CREATE TABLE vt_leader
(
    id serial NOT NULL,
    name character varying(100) NOT NULL,
    contact character varying(50) NOT NULL,
    CONSTRAINT vt_leader_pkey PRIMARY KEY (id)
);

-- Precincts
DROP TABLE IF EXISTS vt_precinct;
CREATE TABLE vt_precinct
(
    id serial NOT NULL,
    barangay_id numeric(10,0),
    code character varying(10),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    voters numeric(10,0) NOT NULL DEFAULT 0,
    target numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_precinct_pkey PRIMARY KEY (id)
);

-- Leader to Precinct Assignments
DROP TABLE IF EXISTS vt_leader_assignment;
CREATE TABLE vt_leader_assignment
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    leader_id numeric(10,0) NOT NULL,
    CONSTRAINT vt_leader_assignment_pkey PRIMARY KEY (id)
);

-- "Current count" table
-- This was separated only because our database tool cannot produce mock data
-- for a single column.
-- This table is linked with the precincts table.
DROP TABLE IF EXISTS vt_current;
CREATE TABLE vt_current
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    current numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_current_pkey PRIMARY KEY (id)
);



--------------------------------------------------------------------------------



-- Number of municipality per district
drop view if exists view_municipality_per_district;
create or replace view view_municipality_per_district
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

-- Number of barangays per municipality
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

-- Number of precints per barangay
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



--------------------------------------------------------------------------------



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
        vt_current
        inner join vt_precinct on (vt_current.precinct_id = vt_precinct.id);
        --inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id);
        --inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
        --inner join vt_district on (vt_municipality.district_id = vt_district.id);

-- District view
drop view if exists view_district;
create or replace view view_district
    (district_id,
        district,
        current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
        target_percentage)
as
    select
        vt_district.id,
        vt_district.name,
        sum(vt_current.current),
        sum(vt_precinct.target),
        get_percentage(sum(vt_current.current), sum(vt_precinct.target)),
        sum(vt_precinct.voters),
        get_percentage(sum(vt_precinct.target), sum(vt_precinct.voters))
    from
        vt_current
        inner join vt_precinct on (vt_current.precinct_id = vt_precinct.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
        inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district on (vt_municipality.district_id = vt_district.id)
    group by
        vt_district.id,
        vt_district.name
    order by
        vt_district.name;

-- Municipality view
drop view if exists view_municipality;
create or replace view view_municipality
    (district_id,
        district,
        municipality_id,
        municipality,
        current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
        target_percentage)
as
    select
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        sum(vt_current.current),
        sum(vt_precinct.target),
        get_percentage(sum(vt_current.current), sum(vt_precinct.target)),
        sum(vt_precinct.voters),
        get_percentage(sum(vt_precinct.target), sum(vt_precinct.voters))
    from
        vt_current
        inner join vt_precinct on (vt_current.precinct_id = vt_precinct.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
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

-- Barangay view
drop view if exists view_barangay;
create or replace view view_barangay
    (district_id,
        district,
        municipality_id,
        municipality,
        barangay_id,
        barangay,
        current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
        target_percentage)
as
    select
        vt_district.id,
        vt_district.name,
        vt_municipality.id,
        vt_municipality.name,
        vt_barangay.id,
        vt_barangay.name,
        sum(vt_current.current),
        sum(vt_precinct.target),
        get_percentage(sum(vt_current.current), sum(vt_precinct.target)),
        sum(vt_precinct.voters),
        get_percentage(sum(vt_precinct.target), sum(vt_precinct.voters))
    from
        vt_current
        inner join vt_precinct on (vt_current.precinct_id = vt_precinct.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
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
        leader,
        contact,
        current_count_sum,
        target_count_sum,
        current_percentage,
        total_voters_sum,
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
        vt_leader.name,
        vt_leader.contact,
        vt_current.current,
        vt_precinct.target,
        get_percentage(vt_current.current, vt_precinct.target),
        vt_precinct.voters,
        get_percentage(vt_precinct.target, vt_precinct.voters)
    from
        vt_leader_assignment
        inner join vt_leader on (vt_leader_assignment.leader_id = vt_leader.id)
        inner join vt_current on (vt_leader_assignment.precinct_id = vt_current.id)
        inner join vt_precinct on (vt_leader_assignment.precinct_id = vt_precinct.id)
        inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
        inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
        inner join vt_district on (vt_municipality.district_id = vt_district.id);

-- Leader-Precinct assignment view
-- drop view if exists view_leader_assignment;
-- create or replace view view_leader_assignment
--     (leader, contact, district, municipality, barangay, precinct, current_count, target_count, current_percentage, total_voters, target_percentage)
-- as
--     select
--         vt_leader.name,
--         vt_leader.contact,
--         vt_district.name,
--         vt_municipality.name,
--         vt_barangay.name,
--         vt_precinct.name,
--         vt_current.current,
--         vt_precinct.target,
--         get_percentage(vt_current.current, vt_precinct.target),
--         vt_precinct.voters,
--         get_percentage(vt_precinct.target, vt_precinct.voters)
--     from
--         vt_leader_assignment
--         inner join vt_leader on (vt_leader_assignment.leader_id = vt_leader.id)
--         inner join vt_current on (vt_leader_assignment.precinct_id = vt_current.id)
--         inner join vt_precinct on (vt_leader_assignment.precinct_id = vt_precinct.id)
--         inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
--         inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
--         inner join vt_district on (vt_municipality.district_id = vt_district.id)
--     order by
--         vt_leader.name,
--         vt_district.name,
--         vt_municipality.name,
--         vt_barangay.name,
--         vt_precinct.name;


--------------------------------------------------------------------------------



\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_1.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_2.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
\COPY vtracker(province, district, municipality, municipality_code, barangay, precinct, voters, leader, contact, target) FROM '../../../database/to_import/district_3.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';



--------------------------------------------------------------------------------



-- Insert Districts from the import table
-- District ID is auto-generated
insert into vt_district(province_id, name)
select distinct
    1,
    district || ' DISTRICT' as district_name
from vtracker
order by district_name asc;

-- Insert Municipalities from the import table
insert into vt_municipality(district_id, id, name)
select distinct
    to_number(district, '9') as district_number,
    municipality_code,
    municipality
from vtracker
order by district_number, municipality asc;

-- Insert Barangays from the import table
insert into vt_barangay(municipality_id, name)
select distinct
    vt_municipality.id,
    barangay
from vtracker
    inner join vt_municipality on (vtracker.municipality = vt_municipality.name)
order by barangay asc;

-- Insert Leaders from the import table
insert into vt_leader(name, contact)
select distinct
    leader,
    contact
from vtracker
order by leader asc;

-- Insert Precincts from the import table
-- insert into vt_precinct(barangay_id, name, voters, target)
-- select distinct
--     (select vt_barangay.id
--         from vt_barangay
--         where
--             vt_municipality.id = vt_barangay.municipality_id and
--             vt_barangay.name = vtracker.barangay) as bid,
--     vtracker.precinct,
--     vtracker.voters,
--     vtracker.target
-- from
--     vtracker
--     inner join vt_municipality on (vtracker.municipality = vt_municipality.name)
-- order by bid, precinct asc;

-- Corrected?
insert into vt_precinct(barangay_id, name, voters, target)
select
    (select vt_barangay.id
        from
            vt_barangay
            inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)
            inner join vt_district on (vt_municipality.district_id = vt_district.id)
        where
            vtracker.barangay = vt_barangay.name
            and vtracker.municipality = vt_municipality.name
            and vt_district.name like vtracker.district || '%') as bid,
    vtracker.precinct,
    vtracker.voters,
    vtracker.target
from
    vtracker
order by district, municipality, barangay, precinct asc;

-- Display precincts
-- select
--     vt_precinct.id,
--     vt_precinct.name as precinct,
--     vt_barangay.name as bararangay,
--     vt_municipality.name as municipality
-- from
--     vt_precinct
--     inner join vt_barangay on (vt_precinct.barangay_id = vt_barangay.id)
--     inner join vt_municipality on (vt_barangay.municipality_id = vt_municipality.id)

-- Insert Leader-Precinct assignments
insert into vt_leader_assignment(precinct_id, leader_id)
select
    (select vt_precinct.id
        from
            vt_precinct,
            vt_barangay,
            vt_municipality,
            vt_district
        where
            vt_precinct.barangay_id = vt_barangay.id
            and vt_barangay.municipality_id = vt_municipality.id
            and vt_municipality.district_id = vt_district.id
            and vtracker.precinct = vt_precinct.name
            and vtracker.barangay = vt_barangay.name
            and vtracker.municipality = vt_municipality.name
            and vt_district.name like vtracker.district || '%') as precinct_id,
    (select vt_leader.id
        from
            vt_leader
        where
            vt_leader.name = vtracker.leader) as leader_id
    --vtracker.precinct,
    --vtracker.leader,
    --vtracker.contact
from
    vtracker;

---------------------------------
-- NOTE:
-- Compute value from percentage
-- We will not need this when the target data becomes a value instead
-- of a percentage
---------------------------------
update vt_precinct as dest
set target = get_percentage_value(target, voters);

-- Insert precinct initial (zero) current values
insert into vt_current(precinct_id, current)
select vt_precinct.id, 0
from vt_precinct;



--------------------------------------------------------------------------------



-- Set current count to a random numb er up to 80%  of the target count
-- insert into vt_current(precinct_id, current)
-- select vt_precinct.id, random_between(1, ((vt_precinct.target / 10) * 8)::integer)
-- from vt_precinct;


-- Set current count between 1 and 80% of target
update vt_current
set current = random_between(1, get_percentage_value(80, vt_precinct.target))
from
    vt_precinct,
    vt_barangay,
    vt_municipality
where
    vt_current.precinct_id = vt_precinct.id
    and vt_precinct.barangay_id = vt_barangay.id
    and vt_barangay.municipality_id = vt_municipality.id;

-- Set current count between 1 and 80% of target of specified municipality
-- update vt_current
-- set current = random_between(1, get_percentage_value(80, vt_precinct.target))
-- from
--     vt_precinct,
--     vt_barangay,
--     vt_municipality
-- where
--     vt_current.precinct_id = vt_precinct.id
--     and vt_precinct.barangay_id = vt_barangay.id
--     and vt_barangay.municipality_id = 1

-- Set current count between 1 and 80% of target of specified district
-- update vt_current
-- set current = random_between(1, get_percentage_value(80, vt_precinct.target))
-- from
--     vt_precinct,
--     vt_barangay,
--     vt_municipality,
--     vt_district
-- where
--     vt_current.precinct_id = vt_precinct.id
--     and vt_precinct.barangay_id = vt_barangay.id
--     and vt_barangay.municipality_id = vt_municipality.id
--     and vt_district.id = 1
