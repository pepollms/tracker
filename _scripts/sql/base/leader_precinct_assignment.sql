DROP TABLE IF EXISTS vt_leader_precinct_assignment;
CREATE TABLE vt_leader_precinct_assignment
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    leader_id numeric(10,0) NOT NULL,
    CONSTRAINT vt_leader_precinct_assignment_pkey PRIMARY KEY (id)
);
