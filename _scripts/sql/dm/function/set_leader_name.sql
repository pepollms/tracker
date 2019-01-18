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
