-- Add new leader
-- Return 1 if successful.
-- Return -1 if leader name already exists.
-- Return -2 if leader contact already exists.
DROP FUNCTION IF EXISTS add_leader;
CREATE OR REPLACE FUNCTION add_leader(p_name character varying(50),
                                      p_contact character varying(50))
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
DECLARE
    retval integer := 0;
BEGIN
    retval := count(*) from vt_leader where name = p_name;
    if retval = 1 then
        return -1;
    end if;

    --retval := count(*) from vt_leader where contact = p_contact;
    --if retval = 1 then
    --    return -2;
    --end if;

    insert into vt_leader(name, contact) values (p_name, p_contact);
    return id from vt_leader where name = p_name;
end;
$function$;
