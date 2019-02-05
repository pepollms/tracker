DROP FUNCTION IF EXISTS random_between CASCADE;
CREATE OR REPLACE FUNCTION random_between(p_start integer, p_end integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN floor(random() * (p_end - p_start + 1) + p_start);
END;
$function$;
