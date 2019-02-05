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
        retval := count(*) from vt_precinct where id = p_id;
        if retval = 0 then
            return 0;
        end if;
        update vt_precinct_monitor set current=current + p_count where precinct_id = p_id;
        return p_count;
    END IF;
end;
$function$;
