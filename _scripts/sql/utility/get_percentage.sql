DROP FUNCTION IF EXISTS get_percentage CASCADE;
CREATE OR REPLACE FUNCTION get_percentage(p_n numeric, p_total numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    IF p_n::integer = 0 OR p_total::integer = 0 THEN
        RETURN 0;
    ELSE
        RETURN (p_n / p_total) * 100;
    END IF;
end;
$function$;
