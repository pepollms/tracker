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

    retval := count(*) from vt_leader_precinct_assignment
        where leader_id = p_leader_id and precinct_id = p_precinct_id;
    if retval = 0 then
        return -3;
    end if;

    insert into vt_leader_precinct_assignment(precinct_id, leader_id)
        values(p_precinct_id, p_leader_id);

    return 1;
end;
$function$;
