# Output {#chapter-output}

This section provides terminal outputs.

## System Initialization

~~~
$ ./import.sh --init

System initialization is only performed during system startup.
It will destroy all existing data in the current database.

The following operations will be performed:
  1. Create database
  2. Import source data
  3. Create markdown files

Do you want to initialize the system?
1) Yes
2) No
#? 1
Create database objects.
psql:./sql/create_base_tables.sql:7: NOTICE:  view "view_districts_per_province" does not exist, skipping
DROP VIEW
psql:./sql/create_base_tables.sql:8: NOTICE:  view "view_municipalities_per_district" does not exist, skipping
DROP VIEW
psql:./sql/create_base_tables.sql:9: NOTICE:  view "view_barangays_per_municipality" does not exist, skipping
DROP VIEW
psql:./sql/create_base_tables.sql:10: NOTICE:  view "view_precincts_per_barangay" does not exist, skipping
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP FUNCTION
DROP TYPE
CREATE TYPE
CREATE FUNCTION
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP TABLE
CREATE TABLE
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
psql:./sql/view/precinct.sql:1: NOTICE:  view "view_precinct" does not exist, skipping
DROP VIEW
CREATE VIEW
psql:./sql/view/barangay.sql:1: NOTICE:  view "view_barangay" does not exist, skipping
DROP VIEW
CREATE VIEW
psql:./sql/view/municipality.sql:1: NOTICE:  view "view_municipality" does not exist, skipping
DROP VIEW
CREATE VIEW
psql:./sql/view/district.sql:1: NOTICE:  view "view_district" does not exist, skipping
DROP VIEW
CREATE VIEW
psql:./sql/view/province.sql:1: NOTICE:  view "view_province" does not exist, skipping
DROP VIEW
CREATE VIEW
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
DROP FUNCTION
CREATE FUNCTION
Database objects has been created.
Import from source data files
COPY 17
COPY 6
Import source data files:
../_data/to_import/district/mock_data_district_1_alamada.csv
Creating ./sql/import/mock_data_district_1_alamada.sql.
Executing ./sql/import/mock_data_district_1_alamada.sql.
COPY 5
Creating ./sql/import/mock_data_district_2_kidapawan.sql.
Executing ./sql/import/mock_data_district_2_kidapawan.sql.
COPY 5
Creating ./sql/import/mock_data_district_3_banisilan.sql.
Executing ./sql/import/mock_data_district_3_banisilan.sql.
COPY 5
Processing imported data.
INSERT 0 3
INSERT 0 3
INSERT 0 3
INSERT 0 15
INSERT 0 15
INSERT 0 15
INSERT 0 15
Source data has been imported
Create markdown files:
  District markdown files: 3
  Municipality markdown files: 3
  Barangay markdown files: 3
Markdown files has been created.
Done.
~~~


## Jekyll

### Bundle Install

~~~
$ bundle install --path ./vendor/bundle
Fetching gem metadata from https://rubygems.org/..............
Fetching gem metadata from https://rubygems.org/..
Resolving dependencies...
Fetching concurrent-ruby 1.1.4
Installing concurrent-ruby 1.1.4
Fetching i18n 0.9.5
Installing i18n 0.9.5
Fetching minitest 5.11.3
Installing minitest 5.11.3
Fetching thread_safe 0.3.6
Installing thread_safe 0.3.6
Fetching tzinfo 1.2.5
Installing tzinfo 1.2.5
Fetching activesupport 4.2.10
Installing activesupport 4.2.10
Fetching public_suffix 2.0.5
Installing public_suffix 2.0.5
Fetching addressable 2.5.2
Installing addressable 2.5.2
Using bundler 2.0.1
Fetching coffee-script-source 1.11.1
Installing coffee-script-source 1.11.1
Fetching execjs 2.7.0
Installing execjs 2.7.0
Fetching coffee-script 2.4.1
Installing coffee-script 2.4.1
Fetching colorator 1.1.0
Installing colorator 1.1.0
Fetching ruby-enum 0.7.2
Installing ruby-enum 0.7.2
Fetching commonmarker 0.17.13
Installing commonmarker 0.17.13 with native extensions
Fetching dnsruby 1.61.2
Installing dnsruby 1.61.2
Fetching eventmachine 1.2.7
Installing eventmachine 1.2.7 with native extensions
Fetching http_parser.rb 0.6.0
Installing http_parser.rb 0.6.0 with native extensions
Fetching em-websocket 0.5.1
Installing em-websocket 0.5.1
Fetching ffi 1.10.0
Installing ffi 1.10.0 with native extensions
Fetching ethon 0.12.0
Installing ethon 0.12.0
Fetching multipart-post 2.0.0
Installing multipart-post 2.0.0
Fetching faraday 0.15.4
Installing faraday 0.15.4
Fetching forwardable-extended 2.6.0
Installing forwardable-extended 2.6.0
Fetching gemoji 3.0.0
Installing gemoji 3.0.0
Fetching sawyer 0.8.1
Installing sawyer 0.8.1
Fetching octokit 4.13.0
Installing octokit 4.13.0
Fetching typhoeus 1.3.1
Installing typhoeus 1.3.1
Fetching github-pages-health-check 1.8.1
Installing github-pages-health-check 1.8.1
Fetching rb-fsevent 0.10.3
Installing rb-fsevent 0.10.3
Fetching rb-inotify 0.10.0
Installing rb-inotify 0.10.0
Fetching sass-listen 4.0.0
Installing sass-listen 4.0.0
Fetching sass 3.7.3
Installing sass 3.7.3
Fetching jekyll-sass-converter 1.5.2
Installing jekyll-sass-converter 1.5.2
Fetching ruby_dep 1.5.0
Installing ruby_dep 1.5.0
Fetching listen 3.1.5
Installing listen 3.1.5
Fetching jekyll-watch 2.1.2
Installing jekyll-watch 2.1.2
Fetching kramdown 1.17.0
Installing kramdown 1.17.0
Fetching liquid 4.0.0
Installing liquid 4.0.0
Fetching mercenary 0.3.6
Installing mercenary 0.3.6
Fetching pathutil 0.16.2
Installing pathutil 0.16.2
Fetching rouge 2.2.1
Installing rouge 2.2.1
Fetching safe_yaml 1.0.4
Installing safe_yaml 1.0.4
Fetching jekyll 3.7.4
Installing jekyll 3.7.4
Fetching jekyll-avatar 0.6.0
Installing jekyll-avatar 0.6.0
Fetching jekyll-coffeescript 1.1.1
Installing jekyll-coffeescript 1.1.1
Fetching jekyll-commonmark 1.2.0
Installing jekyll-commonmark 1.2.0
Fetching jekyll-commonmark-ghpages 0.1.5
Installing jekyll-commonmark-ghpages 0.1.5
Fetching jekyll-default-layout 0.1.4
Installing jekyll-default-layout 0.1.4
Fetching jekyll-feed 0.11.0
Installing jekyll-feed 0.11.0
Fetching jekyll-gist 1.5.0
Installing jekyll-gist 1.5.0
Fetching jekyll-github-metadata 2.9.4
Installing jekyll-github-metadata 2.9.4
Fetching mini_portile2 2.4.0
Installing mini_portile2 2.4.0
Fetching nokogiri 1.10.1
Installing nokogiri 1.10.1 with native extensions
Fetching html-pipeline 2.10.0
Installing html-pipeline 2.10.0
Fetching jekyll-mentions 1.4.1
Installing jekyll-mentions 1.4.1
Fetching jekyll-optional-front-matter 0.3.0
Installing jekyll-optional-front-matter 0.3.0
Fetching jekyll-paginate 1.1.0
Installing jekyll-paginate 1.1.0
Fetching jekyll-readme-index 0.2.0
Installing jekyll-readme-index 0.2.0
Fetching jekyll-redirect-from 0.14.0
Installing jekyll-redirect-from 0.14.0
Fetching jekyll-relative-links 0.5.3
Installing jekyll-relative-links 0.5.3
Fetching rubyzip 1.2.2
Installing rubyzip 1.2.2
Fetching jekyll-remote-theme 0.3.1
Installing jekyll-remote-theme 0.3.1
Fetching jekyll-seo-tag 2.5.0
Installing jekyll-seo-tag 2.5.0
Fetching jekyll-sitemap 1.2.0
Installing jekyll-sitemap 1.2.0
Fetching jekyll-swiss 0.4.0
Installing jekyll-swiss 0.4.0
Fetching jekyll-theme-architect 0.1.1
Installing jekyll-theme-architect 0.1.1
Fetching jekyll-theme-cayman 0.1.1
Installing jekyll-theme-cayman 0.1.1
Fetching jekyll-theme-dinky 0.1.1
Installing jekyll-theme-dinky 0.1.1
Fetching jekyll-theme-hacker 0.1.1
Installing jekyll-theme-hacker 0.1.1
Fetching jekyll-theme-leap-day 0.1.1
Installing jekyll-theme-leap-day 0.1.1
Fetching jekyll-theme-merlot 0.1.1
Installing jekyll-theme-merlot 0.1.1
Fetching jekyll-theme-midnight 0.1.1
Installing jekyll-theme-midnight 0.1.1
Fetching jekyll-theme-minimal 0.1.1
Installing jekyll-theme-minimal 0.1.1
Fetching jekyll-theme-modernist 0.1.1
Installing jekyll-theme-modernist 0.1.1
Fetching jekyll-theme-primer 0.5.3
Installing jekyll-theme-primer 0.5.3
Fetching jekyll-theme-slate 0.1.1
Installing jekyll-theme-slate 0.1.1
Fetching jekyll-theme-tactile 0.1.1
Installing jekyll-theme-tactile 0.1.1
Fetching jekyll-theme-time-machine 0.1.1
Installing jekyll-theme-time-machine 0.1.1
Fetching jekyll-titles-from-headings 0.5.1
Installing jekyll-titles-from-headings 0.5.1
Fetching jemoji 0.10.1
Installing jemoji 0.10.1
Fetching minima 2.5.0
Installing minima 2.5.0
Fetching unicode-display_width 1.4.1
Installing unicode-display_width 1.4.1
Fetching terminal-table 1.8.0
Installing terminal-table 1.8.0
Fetching github-pages 193
Installing github-pages 193
Bundle complete! 1 Gemfile dependency, 85 gems now installed.
Bundled gems are installed into `./vendor/bundle`
Post-install message from dnsruby:
Installing dnsruby...
  For issues and source code: https://github.com/alexdalitz/dnsruby
  For general discussion (please tell us how you use dnsruby): https://groups.google.com/forum/#!forum/dnsruby
Post-install message from sass:

Ruby Sass is deprecated and will be unmaintained as of 26 March 2019.

* If you use Sass as a command-line tool, we recommend using Dart Sass, the new
  primary implementation: https://sass-lang.com/install

* If you use Sass as a plug-in for a Ruby web framework, we recommend using the
  sassc gem: https://github.com/sass/sassc-ruby#readme

* For more details, please refer to the Sass blog:
  http://sass.logdown.com/posts/7081811

Post-install message from html-pipeline:
-------------------------------------------------
Thank you for installing html-pipeline!
You must bundle Filter gem dependencies.
See html-pipeline README.md for more details.
https://github.com/jch/html-pipeline#dependencies
-------------------------------------------------
~~~

\clearpage
