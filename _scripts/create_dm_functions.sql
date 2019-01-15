    -- Create data manipulation functions



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
CREATE OR REPLACE FUNCTION set_leader_name(p_leader_id integer,
                                           p_name character varying(50))
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
CREATE OR REPLACE FUNCTION set_leader_contact(p_leader_id integer,
                                              p_contact character varying(50))
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
-- Return -2 if leader contact already exists.
DROP FUNCTION IF EXISTS add_leader;
CREATE OR REPLACE FUNCTION add_leader(p_name character varying(50),
                                      p_contact character varying(50))
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

    retval := count(*) from vt_leader where contact = p_contact;
    if retval = 1 then
        return -2;
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
CREATE OR REPLACE FUNCTION set_leader_assignment(p_leader_id integer,
                                                 p_precinct_id integer)
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

    retval := count(*) from vt_leader_assignment
        where leader_id = p_leader_id and precinct_id = p_precinct_id;
    if retval = 0 then
        return -3;
    end if;

    insert into vt_leader_assignment(precinct_id, leader_id)
        values(p_precinct_id, p_leader_id);

    return 1;
end;
$function$;
