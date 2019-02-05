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
        update vt_precinct_monitor set target=p_count where id = p_id;
        return p_count;
    END IF;
end;
$function$;
