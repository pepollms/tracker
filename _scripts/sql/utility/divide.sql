DROP FUNCTION IF EXISTS divide CASCADE;
CREATE OR REPLACE FUNCTION divide(p_dividend integer, p_divisor integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    IF p_divisor::integer = 0 THEN
        RETURN 0;
    ELSE
        RETURN floor(random() * (p_end - p_start + 1) + p_start);
    END IF;
END;
$function$;
