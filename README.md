# postgres_chpw

# Postgresql with pg_cron, pg_hint, postgis and data wrapers

### Realized extensions::

 - pg_cron
 - pg_hint_plan
 - postgis
 - tds_fdw(connect to MsSQL)
 - mysql_fdw
 - oracle_fdw
 - SQLite
 - Firebird
 - MonetDB
 - Cassandra
 - MongoDB
 - Redis

### TODO:

 - Correct variable substitution for pg_cron
 - More lightweight images with only one wrapper type

### Wrappers repositories with instructions how to use it:

 - [MsSQL](https://github.com/tds-fdw/tds_fdw)
 - [MySQL](https://github.com/EnterpriseDB/mysql_fdw)
 - [Oracle](https://github.com/laurenz/oracle_fdw)

### To use pg_cron:

 - Use [THIS](https://github.com/citusdata/pg_cron) instruction from repository.

 - Remember, that by default DB for pgcron is "postgres"

 - The list of all possible wrapper extensions you can find [here](https://wiki.postgresql.org/wiki/Foreign_data_wrappers)

### To use pg_hint_plan:

 - Use [THIS](https://pghintplan.osdn.jp/pg_hint_plan.html) instruction from repository.

 - Remember, that by default DB for pgcron is "postgres"

### To use postgis:

 - Use [THIS](https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt) instruction from repository.

 - Remember, that by default DB for pgcron is "postgres"

 - Postgis version is 2.5


### After build actions

 - Add to /var/lib/postgresql/data/postgresql.conf:
	<p>shared_preload_libraries = 'pg_cron, pg_stat_statements, pg_hint_plan'</p>
	<p>cron.database_name = 'postgres'</p>

 - After first run the container, need to create extensions:
	CREATE EXTENSION pg_cron;
	LOAD 'pg_hint_plan';
	CREATE EXTENSION postgis;
	CREATE EXTENSION dblink;
	CREATE EXTENSION mysql_fdw;
	CREATE EXTENSION oracle_fdw ;
	CREATE EXTENSION postgres_fdw;
	CREATE EXTENSION tds_fdw;
