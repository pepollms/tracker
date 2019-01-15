-- Drop views
-- This has to be executed prior to creating any tables to remove dependencies

drop view if exists view_districts_per_province;
drop view if exists view_municipalities_per_district;
drop view if exists view_barangays_per_municipality;
drop view if exists view_precincts_per_barangay;

drop view if exists view_province;
drop view if exists view_district;
drop view if exists view_municipality;
drop view if exists view_barangay;
drop view if exists view_precinct;
