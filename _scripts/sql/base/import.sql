DROP TABLE IF EXISTS vt_import;
CREATE TABLE vt_import
(
    id serial NOT NULL,
    province character varying(50) NOT NULL,
    district character varying(50) NOT NULL,
    municipality character varying(50) NOT NULL,
    municipality_code numeric(10) NOT NULL,
    barangay character varying(50) NOT NULL,
    precinct character varying(10) NOT NULL,
    voters numeric(10) NOT NULL,
    leader character varying(100) NOT NULL,
    contact character varying(50) NOT NULL,
    target numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_import_pkey PRIMARY KEY (id)
);
