-- Utility functions
-- Used only in generating dummy data



-- Function that returns the percentage of two numbers
-- Example: 70 is 35% of 200
--   select get_percentage(70, 200) returns 35
DROP FUNCTION IF EXISTS get_percentage CASCADE;
CREATE OR REPLACE FUNCTION get_percentage(p_n numeric, p_total numeric)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    IF p_n::integer = 0 THEN
        RETURN 0;
    ELSE
        RETURN (p_n / p_total) * 100;
    END IF;
end;
$function$;



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



-- Create user-defined function returning a number between a specified range
DROP FUNCTION IF EXISTS random_between CASCADE;
CREATE OR REPLACE FUNCTION random_between(p_start integer, p_end integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN floor(random() * (p_end - p_start + 1) + p_start);
END;
$function$;
