DROP TABLE IF EXISTS vt_current;
CREATE TABLE vt_current
(
    id serial NOT NULL,
    contact character varying(50) NOT NULL,
    municipality_code numeric(10) NOT NULL,
    precinct character varying(10) NOT NULL,
    current numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_current_pkey PRIMARY KEY (id)
);
