-- Make sure the postgresql server is running
--   systemctl start postgresql
--
-- Execute this file as:
--   psql -d postgres -w -t -f _import.sql
--

-- Create import table
DROP TABLE IF EXISTS public.vtracker;
CREATE TABLE public.vtracker
(
    id serial NOT NULL,
    province character varying(50) NOT NULL,
    district numeric(10) NOT NULL,
    municipality character varying(50) NOT NULL,
    barangay character varying(50) NOT NULL,
    precinct character varying(10) NOT NULL,
    voters numeric(10) NOT NULL,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vtracker
    OWNER to sphere;

-- Districts
DROP TABLE IF EXISTS public.vt_district;
CREATE TABLE public.vt_district
(
    id numeric(10,0) NOT NULL,
    code character varying(10),
    province_id numeric(10, 0),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vt_district_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vt_district
    OWNER to sphere;

-- Municipalities
DROP TABLE IF EXISTS public.vt_municipality;
CREATE TABLE public.vt_municipality
(
    id serial NOT NULL,
    code character varying(10),
    district_id numeric(10,0),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vt_municipality_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vt_municipality
    OWNER to sphere;

-- Barangays
DROP TABLE IF EXISTS public.vt_barangay;
CREATE TABLE public.vt_barangay
(
    id serial NOT NULL,
    code character varying(10),
    municipality_id numeric(10,0),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    target numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_barangay_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vt_barangay
    OWNER to sphere;

-- Precincts
DROP TABLE IF EXISTS public.vt_precinct;
CREATE TABLE public.vt_precinct
(
    id serial NOT NULL,
    code character varying(10),
    barangay_id numeric(10,0),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    voters numeric(10,0) NOT NULL DEFAULT 0,
    target numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_precinct_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vt_precinct
    OWNER to sphere;

-- "Current count" table
-- This was separated only because our database tool cannot produce mock data
-- for a single column.
-- This table is linked with the precincts table.
DROP TABLE IF EXISTS public.vt_current;
CREATE TABLE public.vt_current
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    current numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_current_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.vt_current
    OWNER to sphere;


--------------------------------------------------------------------------------



\COPY public.vtracker(province, district, municipality, barangay, precinct, voters) FROM '../../../database/to_import/district_1.csv' DELIMITER ',' CSV HEADER;
\COPY public.vtracker(province, district, municipality, barangay, precinct, voters) FROM '../../../database/to_import/district_2.csv' DELIMITER ',' CSV HEADER;
\COPY public.vtracker(province, district, municipality, barangay, precinct, voters) FROM '../../../database/to_import/district_3.csv' DELIMITER ',' CSV HEADER;



--------------------------------------------------------------------------------



-- Insert Districts from the import table
insert into public.vt_district(id, province_id, name)
select distinct
    district,
    1,
    'District ' || to_char(district, '9')
from public.vtracker
order by district asc;

-- Insert Municipalities from the import table
insert into public.vt_municipality(district_id, name)
select distinct
    district,
    municipality
from public.vtracker
order by district, municipality asc;

-- Insert Barangays from the import table
insert into public.vt_barangay(municipality_id, name)
select distinct
    public.vt_municipality.id,
    barangay
from public.vtracker
    inner join public.vt_municipality on (public.vtracker.municipality = public.vt_municipality.name)
order by barangay asc;

-- Insert Precincts from the import table
insert into public.vt_precinct(barangay_id, name, voters)
select distinct
    (select public.vt_barangay.id
        from public.vt_barangay
        where
            public.vt_municipality.id = public.vt_barangay.municipality_id and
            public.vt_barangay.name = public.vtracker.barangay) as bid,
    public.vtracker.precinct,
    public.vtracker.voters
from
    public.vtracker
    inner join public.vt_municipality on (public.vtracker.municipality = public.vt_municipality.name)
order by bid, precinct asc;



--------------------------------------------------------------------------------



-- Create user-defined function returning a number between a specified range
CREATE OR REPLACE FUNCTION public.random_between(p_start integer, p_end integer)
    RETURNS integer
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN floor(random()* (p_end - p_start + 1) + p_start);
END;
$function$
;



--------------------------------------------------------------------------------



-- Target count for District 1 is 75%
update public.vt_precinct
set target = ((vt_precinct.voters / 4) * 3)::integer
from
    vt_barangay,
    vt_municipality
where
    vt_precinct.barangay_id = vt_barangay.id and
    vt_barangay.municipality_id = vt_municipality.id and
    vt_municipality.district_id = 1
;

-- Target count for District 2 is 80%
update vt_precinct
set target = ((vt_precinct.voters / 10) * 8)::integer
from
    vt_barangay,
    vt_municipality
where
    vt_precinct.barangay_id = vt_barangay.id and
    vt_barangay.municipality_id = vt_municipality.id and
    vt_municipality.district_id = 2
;

-- Target count for District 3 is 85%
update vt_precinct
set target = ((vt_precinct.voters / 10) * 8 + 5)::integer
from
    vt_barangay,
    vt_municipality
where
    vt_precinct.barangay_id = vt_barangay.id and
    vt_barangay.municipality_id = vt_municipality.id and
    vt_municipality.district_id = 3
;


--------------------------------------------------------------------------------



-- Target count for District 3, Carmen is 4% - 12%
update vt_precinct
set target = random_between(((4 / vt_precinct.voters) * 100)::integer, ((12 / vt_precinct.voters) * 100)::integer)
from
    vt_barangay,
    vt_municipality
where
    vt_precinct.barangay_id = vt_barangay.id and
    vt_barangay.municipality_id = vt_municipality.id and
    vt_municipality.district_id = 3 and
    vt_municipality.name = 'CARMEN'
;


--------------------------------------------------------------------------------



insert into vt_current(precinct_id, current)
select vt_precinct.id, public.random_between(1, ((vt_precinct.target / 10) * 8)::integer)
from vt_precinct;
