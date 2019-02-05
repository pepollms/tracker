DROP TABLE IF EXISTS vt_import_current;
CREATE TABLE vt_import_current
(
    id serial NOT NULL,
    contact character varying(50) NOT NULL,
    municipality_code numeric(10) NOT NULL,
    precinct character varying(10) NOT NULL,
    current numeric(10) NOT NULL,
    imported_when timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT vt_import_current_pkey PRIMARY KEY (id)
);
