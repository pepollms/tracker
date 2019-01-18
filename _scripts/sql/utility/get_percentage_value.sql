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
