DROP TABLE IF EXISTS vt_municipality;
CREATE TABLE vt_municipality
(
    id serial NOT NULL,
    district_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_municipality_pkey PRIMARY KEY (id)
);
