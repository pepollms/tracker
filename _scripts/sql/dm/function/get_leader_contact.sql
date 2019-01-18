-- Return leader contact
-- Return empty string '' if leader is not found.
DROP FUNCTION IF EXISTS get_leader_contact;
CREATE OR REPLACE FUNCTION get_leader_contact(p_leader_id integer)
    RETURNS character varying(50)
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where id = p_leader_id;
    if retval = 0 then
        return '';
    end if;
    return contact from vt_leader where id = p_leader_id;
end;
$function$;
