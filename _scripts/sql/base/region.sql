DROP TABLE IF EXISTS vt_region;
CREATE TABLE vt_region
(
    id serial NOT NULL,
    code character varying(10),
    name character varying(50) NOT NULL,
    aka character varying(50),
    abbreviation character varying(20),
    CONSTRAINT vt_region_pkey PRIMARY KEY (id)
);
