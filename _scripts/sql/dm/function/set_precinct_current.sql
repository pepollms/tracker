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
