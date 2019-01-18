DROP TABLE IF EXISTS vt_leader;
CREATE TABLE vt_leader
(
    id serial NOT NULL,
    name character varying(50) NOT NULL,
    contact character varying(50) NOT NULL,
    CONSTRAINT vt_leader_pkey PRIMARY KEY (id)
);
