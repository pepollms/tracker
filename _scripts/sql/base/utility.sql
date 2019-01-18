drop function if exists view_table;
drop type if exists view_table_columns;

create type view_table_columns as (colname name, datatype text, is_null boolean);

create or replace function view_table(p_table_name text)
    returns setof view_table_columns
    language plpgsql as $function$
begin
    return query
    SELECT
        a.attname as "Column",
        pg_catalog.format_type(a.atttypid, a.atttypmod) as "Datatype",
        a.attnotnull as IsNull
    FROM
        pg_catalog.pg_attribute a
    WHERE
        a.attnum > 0
        AND NOT a.attisdropped
        AND a.attrelid = (
            SELECT c.oid
            FROM
                pg_catalog.pg_class c
                LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
            WHERE
                c.relname = p_table_name
                AND pg_catalog.pg_table_is_visible(c.oid)
        );
end;
$function$;
