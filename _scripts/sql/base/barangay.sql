DROP TABLE IF EXISTS vt_barangay;
CREATE TABLE vt_barangay
(
    id serial NOT NULL,
    municipality_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_barangay_pkey PRIMARY KEY (id)
);
