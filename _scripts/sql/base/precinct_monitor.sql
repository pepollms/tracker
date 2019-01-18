DROP TABLE IF EXISTS vt_precinct_monitor;
CREATE TABLE vt_precinct_monitor
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    voters numeric(10,0) NOT NULL DEFAULT 0,
    target numeric(10,0) NOT NULL DEFAULT 0,
    current numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_precinct_monitor_pkey PRIMARY KEY (id)
);
