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
    retval := count(*) from vt_precinct where id = p_id;
    if retval = 0 then
        return 0;
    end if;
    update vt_precinct_monitor set current=p_count where precinct_id = p_id;
    return 1;
end;
$function$;
