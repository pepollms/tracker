DROP TABLE IF EXISTS vt_district;
CREATE TABLE vt_district
(
    id serial NOT NULL,
    province_id numeric(10, 0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_district_pkey PRIMARY KEY (id)
);
