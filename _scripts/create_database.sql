-- Create database tables, views, functions, etc
--
-- Make sure the postgresql server is running
--   systemctl start postgresql



-- Function that returns the percentage of two numbers
-- Example: 70 is 35% of 200
--   select get_percentage(70, 200) returns 35
DROP FUNCTION IF EXISTS get_percentage CASCADE;
CREATE OR REPLACE FUNCTION get_percentage(p_n numeric, p_total numeric)
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
DROP FUNCTION IF EXISTS get_percentage_value CASCADE;
CREATE OR REPLACE FUNCTION get_percentage_value(p_percent numeric, p_n numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN (p_percent * p_n) / 100;
end;
$function$;

-- Create user-defined function returning a number between a specified range
DROP FUNCTION IF EXISTS random_between CASCADE;
CREATE OR REPLACE FUNCTION random_between(p_start integer, p_end integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN floor(random() * (p_end - p_start + 1) + p_start);
END;
$function$;



--------------------------------------------------------------------------------
-- Delete views


-- Delete dependencies first
drop view if exists view_municipality_per_district;
drop view if exists view_barangays_per_municipality;
drop view if exists view_precincts_per_barangay;

drop view if exists view_province;
drop view if exists view_district;
drop view if exists view_municipality;
drop view if exists view_barangay;
drop view if exists view_precinct;



--------------------------------------------------------------------------------
-- Create tables


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
    name character varying(50) NOT NULL,
    CONSTRAINT vt_district_pkey PRIMARY KEY (id)
);

-- Municipalities
DROP TABLE IF EXISTS vt_municipality;
CREATE TABLE vt_municipality
(
    id serial NOT NULL,
    code character varying(10),
    district_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_municipality_pkey PRIMARY KEY (id)
);

-- Barangays
DROP TABLE IF EXISTS vt_barangay;
CREATE TABLE vt_barangay
(
    id serial NOT NULL,
    code character varying(10),
    municipality_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_barangay_pkey PRIMARY KEY (id)
);

-- Leaders
DROP TABLE IF EXISTS vt_leader;
CREATE TABLE vt_leader
(
    id serial NOT NULL,
    name character varying(50) NOT NULL,
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
    name character varying(50) NOT NULL,
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
-- Create views for data display


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
-- Create views for generating JSON data files



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
        leader_id,
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
        vt_leader.id,
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
-- Create data manipulation functions for the client-side


-- Return the current count of precinct
DROP FUNCTION IF EXISTS get_precinct_current;
CREATE OR REPLACE FUNCTION get_precinct_current(p_id integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_current where id = p_id;
    if retval = 0 then
        return 0;
    end if;
    retval := current from vt_current where id = p_id;
    return retval;
end;
$function$;

-- Return the target count of precinct
DROP FUNCTION IF EXISTS get_precinct_target;
CREATE OR REPLACE FUNCTION get_precinct_target(p_id integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_precinct where id = p_id;
    if retval = 0 then
        return 0;
    end if;
    retval := target from vt_precinct where id = p_id;
    return retval;
end;
$function$;

-- Add/subtract to precinct current count
-- Return the number added if successful, otherwise, return 0.
DROP FUNCTION IF EXISTS add_precinct_current;
CREATE OR REPLACE FUNCTION add_precinct_current(p_id integer, p_count integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    IF p_count::integer = 0 THEN
        RETURN 0;
    ELSE
        retval := count(*) from vt_current where id = p_id;
        if retval = 0 then
            return 0;
        end if;
        update vt_current set current=current + p_count where precinct_id = p_id;
        return p_count;
    END IF;
end;
$function$;

-- Update current count of precinct
-- Return 1 if successful, otherwise, return 0.
DROP FUNCTION IF EXISTS set_precinct_current;
CREATE OR REPLACE FUNCTION set_precinct_current(p_id integer, p_count integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    IF p_count::integer = 0 THEN
        RETURN 0;
    ELSE
        retval := count(*) from vt_current where id = p_id;
        if retval = 0 then
            return 0;
        end if;
        update vt_current set current=p_count where precinct_id = p_id;
        return p_count;
    END IF;
end;
$function$;

-- Update precinct target
-- Return 1 if successful, otherwise, return 0.
DROP FUNCTION IF EXISTS set_precinct_target;
CREATE OR REPLACE FUNCTION set_precinct_target(p_id integer, p_count integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    IF p_count::integer = 0 THEN
        RETURN 0;
    ELSE
        retval := count(*) from vt_precinct where id = p_id;
        if retval = 0 then
            return 0;
        end if;
        update vt_precinct set target=p_count where id = p_id;
        return p_count;
    END IF;
end;
$function$;

-- Return leader name
-- Return empty string '' if leader is not found.
DROP FUNCTION IF EXISTS get_leader_name;
CREATE OR REPLACE FUNCTION get_leader_name(p_leader_id integer)
    RETURNS character varying(50)
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return '';
    end if;
    return name from vt_leader where id = p_leader_id;
end;
$function$;

-- Update leader name
-- Return 1 if successful.
-- Return -1 if leader is not found.
DROP FUNCTION IF EXISTS set_leader_name;
CREATE OR REPLACE FUNCTION set_leader_name(p_leader_id integer, p_name character varying(50))
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return -1;
    end if;

    update vt_leader set name = p_name where id = p_leader_id;
    return 1;
end;
$function$;

-- Return leader contact
-- Return empty string '' if leader is not found.
DROP FUNCTION IF EXISTS get_leader_contact;
CREATE OR REPLACE FUNCTION get_leader_contact(p_leader_id integer)
    RETURNS character varying(50)
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return '';
    end if;
    return contact from vt_leader where id = p_leader_id;
end;
$function$;

-- Update leader contact
-- Return 1 if successful.
-- Return -1 if leader is not found.
DROP FUNCTION IF EXISTS set_leader_contact;
CREATE OR REPLACE FUNCTION set_leader_contact(p_leader_id integer, p_contact character varying(50))
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return -1;
    end if;

    update vt_leader set contact = p_contact where id = p_leader_id;
    return 1;
end;
$function$;

-- Add new leader
-- Return 1 if successful.
-- Return -1 if leader name already exists.
DROP FUNCTION IF EXISTS add_leader;
CREATE OR REPLACE FUNCTION add_leader(p_name character varying(50), p_contact character varying(50))
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where name = p_name;
    if retval = 1 then
        return -1;
    end if;

    insert into vt_leader(name, contact) values (p_name, p_contact);
    return id from vt_leader where name = p_name;
end;
$function$;

-- Assign a leader to a precinct
-- Return 1 if successful.
-- Return -1 if leader is not found.
-- Return -2 if precinct is not found.
-- Return -3 if leader is already assigned to precinct.
DROP FUNCTION IF EXISTS set_leader_assignment;
CREATE OR REPLACE FUNCTION set_leader_assignment(p_leader_id integer, p_precinct_id integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return -1;
    end if;

    retval := count(*) from vt_precinct where id = p_precinct_id;
    if retval = 0 then
        return -2;
    end if;

    retval := count(*) from vt_leader_assignment where leader_id = p_leader_id and precinct_id = p_precinct_id;
    if retval = 0 then
        return -3;
    end if;

    insert into vt_leader_assignment(precinct_id, leader_id)
        values(p_precinct_id, p_leader_id);

    return 1;
end;
$function$;
