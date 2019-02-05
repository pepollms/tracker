DROP FUNCTION IF EXISTS get_percentage_value CASCADE;
CREATE OR REPLACE FUNCTION get_percentage_value(p_percent numeric, p_n numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN (p_percent * p_n) / 100;
end;
$function$;
