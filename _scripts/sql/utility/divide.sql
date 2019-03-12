DROP FUNCTION IF EXISTS divide CASCADE;
CREATE OR REPLACE FUNCTION divide(p_dividend numeric, p_divisor numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    IF p_divisor::integer = 0 THEN
        RETURN 0;
    ELSE
        RETURN p_dividend / p_divisor;
    END IF;
END;
$function$;
