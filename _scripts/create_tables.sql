-- Create tables



-- Create import table
DROP TABLE IF EXISTS vtracker;
CREATE TABLE vtracker
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
    PRIMARY KEY (id)
);



DROP TABLE IF EXISTS vt_region;
CREATE TABLE vt_region
(
    id serial NOT NULL,
    code character varying(10),
    name character varying(50) NOT NULL,
    aka character varying(50),
    abbreviation character varying(20),
    CONSTRAINT vt_region_pkey PRIMARY KEY (id)
);



DROP TABLE IF EXISTS vt_province;
CREATE TABLE vt_province
(
    id serial NOT NULL,
    region_id numeric(10, 0) NOT NULL,
    code character varying(10),
    name character varying(50) NOT NULL,
    aka character varying(50),
    CONSTRAINT vt_province_pkey PRIMARY KEY (id)
);



-- Districts
DROP TABLE IF EXISTS vt_district;
CREATE TABLE vt_district
(
    id serial NOT NULL,
    province_id numeric(10, 0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_district_pkey PRIMARY KEY (id)
);



-- Municipalities
DROP TABLE IF EXISTS vt_municipality;
CREATE TABLE vt_municipality
(
    id serial NOT NULL,
    district_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_municipality_pkey PRIMARY KEY (id)
);



-- Barangays
DROP TABLE IF EXISTS vt_barangay;
CREATE TABLE vt_barangay
(
    id serial NOT NULL,
    municipality_id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT vt_barangay_pkey PRIMARY KEY (id)
);



-- Precincts
DROP TABLE IF EXISTS vt_precinct;
CREATE TABLE vt_precinct
(
    id serial NOT NULL,
    barangay_id numeric(10,0),
    name character varying(50) NOT NULL,
    CONSTRAINT vt_precinct_pkey PRIMARY KEY (id)
);



-- Leaders
DROP TABLE IF EXISTS vt_leader;
CREATE TABLE vt_leader
(
    id serial NOT NULL,
    name character varying(50) NOT NULL,
    contact character varying(50) NOT NULL,
    CONSTRAINT vt_leader_pkey PRIMARY KEY (id)
);



-- Leader to Precinct Assignments
DROP TABLE IF EXISTS vt_leader_assignment;
CREATE TABLE vt_leader_assignment
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    leader_id numeric(10,0) NOT NULL,
    CONSTRAINT vt_leader_assignment_pkey PRIMARY KEY (id)
);



-- Poll values
DROP TABLE IF EXISTS vt_current;
CREATE TABLE vt_current
(
    id serial NOT NULL,
    precinct_id numeric(10,0) NOT NULL,
    voters numeric(10,0) NOT NULL DEFAULT 0,
    target numeric(10,0) NOT NULL DEFAULT 0,
    current numeric(10,0) NOT NULL DEFAULT 0,
    CONSTRAINT vt_current_pkey PRIMARY KEY (id)
);
