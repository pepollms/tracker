DROP TABLE IF EXISTS vt_precinct;
CREATE TABLE vt_precinct
(
    id serial NOT NULL,
    barangay_id numeric(10,0),
    name character varying(50) NOT NULL,
    CONSTRAINT vt_precinct_pkey PRIMARY KEY (id)
);
