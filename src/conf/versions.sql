
DROP VIEW  IF EXISTS v_versions;
DROP TABLE IF EXISTS versions;
DROP TABLE IF EXISTS releases;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS categories;

DROP TABLE IF EXISTS flavors;

DROP VIEW  IF EXISTS v_images;
DROP TABLE IF EXISTS images;
DROP TABLE IF EXISTS image_types;

DROP VIEW  IF EXISTS v_locations;
DROP TABLE IF EXISTS locations;
DROP VIEW  IF EXISTS v_regions;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS metros;
DROP TABLE IF EXISTS volume_types;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS provider_types;
DROP VIEW  IF EXISTS v_services;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_types;


CREATE TABLE categories (
  category    INTEGER  NOT NULL PRIMARY KEY,
  sort_order  SMALLINT NOT NULL,
  description TEXT     NOT NULL,
  short_desc  TEXT     NOT NULL
);


CREATE TABLE projects (
  project   	 TEXT     NOT NULL PRIMARY KEY,
  category  	 INTEGER  NOT NULL,
  port      	 INTEGER  NOT NULL,
  depends   	 TEXT     NOT NULL,
  start_order    INTEGER  NOT NULL,
  sources_url    TEXT     NOT NULL,
  short_name     TEXT     NOT NULL,
  is_extension   SMALLINT NOT NULL,
  image_file     TEXT     NOT NULL,
  description    TEXT     NOT NULL,
  project_url    TEXT     NOT NULL,
  FOREIGN KEY (category) REFERENCES categories(category)
);


CREATE TABLE releases (
  component     TEXT     NOT NULL PRIMARY KEY,
  sort_order    SMALLINT NOT NULL,
  project       TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  doc_url       TEXT     NOT NULL,
  stage         TEXT     NOT NULL,
  description   TEXT     NOT NULL,
  is_open       SMALLINT NOT NULL DEFAULT 1,
  license       TEXT     NOT NULL,
  is_available  TEXT     NOT NULL,
  available_ver TEXT     NOT NULL,
  FOREIGN KEY (project) REFERENCES projects(project)
);


CREATE TABLE versions (
  component     TEXT    NOT NULL,
  version       TEXT    NOT NULL,
  platform      TEXT    NOT NULL,
  is_current    INTEGER NOT NULL,
  release_date  DATE    NOT NULL,
  parent        TEXT    NOT NULL,
  pre_reqs      TEXT    NOT NULL,
  release_notes TEXT    NOT NULL,
  PRIMARY KEY (component, version),
  FOREIGN KEY (component) REFERENCES releases(component)
);

CREATE VIEW v_versions AS
  SELECT c.category as cat, c.sort_order as cat_sort, r.sort_order as rel_sort,
         c.description as cat_desc, c.short_desc as cat_short_desc,
         p.image_file, r.component, r.project, r.stage, r.disp_name as release_name,
         v.version, p.sources_url, p.project_url, v.platform, 
         v.is_current, v.release_date, p.description as proj_desc, 
         r.description as rel_desc, v.pre_reqs, r.license, p.depends, 
         r.is_available, v.release_notes
    FROM categories c, projects p, releases r, versions v
   WHERE c.category = p.category
     AND p.project = r.project
     AND r.component = v.component;

INSERT INTO categories VALUES (0,   0, 'Hidden', 'NotShown');
INSERT INTO categories VALUES (1,  10, 'Rock-solid Postgres', 'Postgres');
INSERT INTO categories VALUES (11, 30, 'Clustering', 'Cloud');
INSERT INTO categories VALUES (10, 15, 'Streaming Change Data Capture', 'CDC');
INSERT INTO categories VALUES (2,  12, 'Legacy RDBMS', 'Legacy');
INSERT INTO categories VALUES (6,  20, 'Oracle Migration & Compatibility', 'OracleMig');
INSERT INTO categories VALUES (4,  11, 'Postgres Apps & Extensions', 'Extras');
INSERT INTO categories VALUES (5,  25, 'Data Integration', 'Integration');
INSERT INTO categories VALUES (3,  80, 'Database Developers', 'Developers');
INSERT INTO categories VALUES (9,  87, 'Management & Monitoring', 'Manage/Monitor');

-- ## HUB ################################
INSERT INTO projects VALUES ('hub',0, 0, 'hub', 0, 'https://github.com/pgsql-io/pgsql-io','',0,'','','');
INSERT INTO releases VALUES ('hub', 1, 'hub', '', '', 'hidden', '', 1, '', '', '');
INSERT INTO versions VALUES ('hub', '6.77', '',  1, '20221130', '', '', '');
INSERT INTO versions VALUES ('hub', '6.76', '',  0, '20220927', '', '', '');
INSERT INTO versions VALUES ('hub', '6.75', '',  0, '20220908', '', '', '');
INSERT INTO versions VALUES ('hub', '6.74', '',  0, '20220901', '', '', '');
INSERT INTO versions VALUES ('hub', '6.73', '',  0, '20220811', '', '', '');
INSERT INTO versions VALUES ('hub', '6.72', '',  0, '20220715', '', '', '');

-- ##
INSERT INTO projects VALUES ('pg', 1, 5432, 'hub', 1, 'https://github.com/postgres/postgres/tags',
 'postgres', 0, 'postgresql.png', 'Best RDBMS', 'https://postgresql.org');

INSERT INTO releases VALUES ('pg11', 4, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/11/release-11.html>2018</a></font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg11', '11.18-1', 'arm, amd, el8', 1, '20221110', '', '', '');
INSERT INTO versions VALUES ('pg11', '11.17-1', 'arm, amd, el8', 0, '20220811', '', '', '');

INSERT INTO releases VALUES ('pg12', 3, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/12/release-12.html>2019</a></font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg12', '12.13-1', 'arm, amd, el8', 1, '20221110', '', '', '');
INSERT INTO versions VALUES ('pg12', '12.12-1', 'arm, amd, el8', 0, '20220811', '', '', '');

INSERT INTO releases VALUES ('pg13', 2, 'pg', '', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/13/release-13.html>2020</a></font>', 
  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg13', '13.9-1',  'arm, amd, el8', 1, '20221110','', '', '');
INSERT INTO versions VALUES ('pg13', '13.8-1',  'arm, amd, el8', 0, '20220811','', '', '');

INSERT INTO releases VALUES ('pg14', 1, 'pg', '', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/14/release-14.html>2021</a></font>',
  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg14', '14.6-1', 'el8, arm', 1, '20221110','', '', '');
INSERT INTO versions VALUES ('pg14', '14.5-1', 'el8, arm', 0, '20220811','', '', '');

INSERT INTO releases VALUES ('pg15', 5, 'pg', '', '', 'prod', 
  '<font size=-1 color=red><b>New in <a href=https://sql-info.de/postgresql/postgresql-15/articles-about-new-features-in-postgresql-15.html>2022!</a></b></font>',
  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg15', '15.1-2',  'el8, arm', 1, '20221117','', '', '');
INSERT INTO versions VALUES ('pg15', '15.1-1',  'el8, arm', 0, '20221110','', '', '');
INSERT INTO versions VALUES ('pg15', '15.0-1',  'el8, arm', 0, '20221013','', '', '');

INSERT INTO projects VALUES ('pge', 1, 0, 'hub', 1, ' ', 'PGE', 0, 'postgresql.png', 'Postgres', ' ');
INSERT INTO releases VALUES ('pge', 10, 'pge', 'PGE', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pge', '15',  '', 1, '20221031', '', '', '');
INSERT INTO versions VALUES ('pge', '14',  '', 0, '20221031', '', '', '');

INSERT INTO projects VALUES ('ivory14', 6, 5432, 'hub', 1, 'https://github.com/ivorysql/ivorysql/tags',
  'IvorySQL', 0, 'highgo.png', 'Postgres w/ mode=oracle', 'https://ivorysql.org');
INSERT INTO releases VALUES ('ivory14', 10, 'ivory14', 'IvorySQL', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('ivory14', '14.3-1',  'amd', 0, '20220523', '', 'LIBC-2.17', '');

INSERT INTO projects VALUES ('debezium', 10, 8083, '', 3, 'https://debezium.io/releases/1.9/',
  'Debezium', 0, 'debezium.png', 'Heterogeneous CDC', 'https://debezium.io');
INSERT INTO releases VALUES ('debezium', 1, 'debezium', 'Debezium', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('debezium', '1.9.2.Final',   '', 0, '20220520', '', '', '');

INSERT INTO projects VALUES ('olr', 10, 8083, '', 3, 'https://github.com/bersler/OpenLogReplicator/releases',
  'OLR', 0, 'olr.png', 'Oracle Binary Log Replicator', 'https://www.bersler.com/openlogreplicator');
INSERT INTO releases VALUES ('olr', 3, 'olr', 'OLR', '', 'test', '', 1, 'GPL', '', '');
INSERT INTO versions VALUES ('olr', '0.9.41-beta',   '', 0, '20220328', '', '', '');
INSERT INTO versions VALUES ('olr', '0.9.40-beta',   '', 0, '20220204', '', '', '');

INSERT INTO projects VALUES ('kafka', 10, 9092, '', 2, 'https://kafka.apache.org/downloads',
  'Kafka', 0, 'kafka.png', 'Streaming Platform', 'https://kafka.apache.org');
INSERT INTO releases VALUES ('kafka', 0, 'kafka', 'Apache Kafka', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('kafka', '3.2.0', '', 0, '20220517', '', '', 'https://downloads.apache.org/kafka/3.2.0/RELEASE_NOTES.html');

INSERT INTO projects VALUES ('redis',  2, 6379, 'hub', 2, 'https://github.com/redis/redis/tags',
  'Redis', 0, 'redis.png', 'In-Memory DataStore', 'https://redis.io');
INSERT INTO releases VALUES ('redis', 6, 'redis', 'Redis 6.2.6', '', 'test', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('redis', '6.2', '', 0, '20211004', '', '', '');

INSERT INTO projects VALUES ('memcached',  2, 6379, 'hub', 2, 'http://memcached.org/downloads',
  'Memcached', 0, 'memcached.png', 'In-Memory Cache', 'http://memcached.org');
INSERT INTO releases VALUES ('memcached', 3, 'memcached', 'Memached 1.6.12', '', 'test', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('memcached', '1.6', '', 0, '20210928', '', '', '');

INSERT INTO projects VALUES ('mariadb',  2, 3306, 'hub', 2, 'https://github.com/mariadb/server/tags',
  'MariaDB', 0, 'mariadb.png', 'Replacement for MySQL', 'https://mariadb.com');
INSERT INTO releases VALUES ('mariadb', 3, 'mariadb', 'MariaDB 10.9.1', '', 'test', '', 1, 'GPL', '', '');
INSERT INTO versions VALUES ('mariadb', '10.9', '',   0, '20220520', '', '', '');

INSERT INTO projects VALUES ('sqlsvr',  2, 1433, 'hub', 2, 
  'https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-release-notes-2019?view=sql-server-ver15#release-history',
  'MS SQL Server', 0, 'sqlsvr.png', 'SQL Server 2019 for Linux',
  'https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview?view=sql-server-ver15');
INSERT INTO releases VALUES ('sqlsvr', 2, 'sqlsvr', 'SQL Svr 15', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('sqlsvr', '15.0.4223', '',   0, '20220516', '', 'UBU20', '');

INSERT INTO projects VALUES ('mongodb',  2, 27017, 'hub', 2, 
  'https://docs.mongodb.com/v5.0/release-notes/5.0/',
  'MongoDB', 0, 'mongodb.png', 'Document Database',
  'https://docs.mongodb.com/v5.0/release-notes/5.0/');
INSERT INTO releases VALUES ('mongodb', 4, 'mongodb', 'MongoDB 5.0', '', 'test', '', 1, 'SSPL', '', '');
INSERT INTO versions VALUES ('mongodb', '5.0.8', '',   0, '20220425', '', '', '');

INSERT INTO projects VALUES ('elasticsearch',  5, 9200, 'hub', 2, 
  'https://www.elastic.co/downloads/elasticsearch',
  'Elasticsearch', 0, 'elasticsearch.png', 'Search and Analytics Engine',
  'https://www.elastic.co/elasticsearch/');
INSERT INTO releases VALUES ('elasticsearch', 0, 'elasticsearch', 'ElasticSearch 7.14.0', '', 'test', '', 1, 'SSPL', '', '');
INSERT INTO versions VALUES ('elasticsearch', '7.x', '',   0, '20210803', '', 'UBU20', '');

INSERT INTO projects VALUES ('apicurio', 10, 8080, 'hub', 1, 'https://github.com/apicurio/apicurio-registry/releases',
  'apicurio', 0, 'apicurio.png', 'Schema Registry', 'https://www.apicur.io/registry/');
INSERT INTO releases VALUES ('apicurio', 3, 'apicurio', 'Apicurio', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('apicurio', '2.2.3', '',  0, '20220414', '', '', '');
INSERT INTO versions VALUES ('apicurio', '2.2.2', '',  0, '20220328', '', '', '');

INSERT INTO projects VALUES ('zookeeper', 10, 2181, 'hub', 1, 'https://zookeeper.apache.org/releases.html#releasenotes',
  'zookeeper', 0, 'zookeeper.png', 'Distributed Key-Store for HA', 'https://zookeeper.apache.org');
INSERT INTO releases VALUES ('zookeeper', 3, 'zookeeper', 'Zookeeper', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('zookeeper', '3.7.0', '',  0, '20210327', '', '',
  'https://zookeeper.apache.org/doc/r3.7.0/releasenotes.html');

INSERT INTO projects VALUES ('cassandrafdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/cassandra_fdw/releases', 
  'cstarfdw', 1, 'cstar.png', 'Cassandra from PG', 'https://github.com/pgsql-io/cassandra_fdw#cassandra_fdw');
INSERT INTO releases VALUES ('cassandrafdw-pg12', 12, 'cassandrafdw', 'CassandraFDW','','test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('cassandrafdw-pg12', '3.1.5-1', 'amd', 0, '20191230', 'pg12', '', '');

INSERT INTO projects VALUES ('decoderbufs', 10, 0, 'hub', 0, 'https://github.com/debezium/postgres-decoderbufs', 
  'decoderbufs', 1, 'protobuf.png', 'Logical decoding via ProtoBuf', 'https://github.com/debezium/postgres-decoderbufs');
INSERT INTO releases VALUES ('decoderbufs-pg14',  4, 'decoderbufs', 'DecoderBufs', '', 'test', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('decoderbufs-pg14', '1.7.0-1', 'arm, el8', 1, '20211001', 'pg14', '', '');

INSERT INTO projects VALUES ('wal2json', 10, 0, 'hub', 0, 'https://github.com/eulerto/wal2json/tags', 
  'wal2json', 1, 'wal2json.png', 'Logical decoding via JSON ', 'https://github.com/eulerto/wal2json#introduction');
INSERT INTO releases VALUES ('wal2json-pg14',  3, 'wal2json', 'wal2json', '', 'prod', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('wal2json-pg14', '2.4-1', 'amd', 0, '20210831', 'pg14', '', '');

INSERT INTO projects VALUES ('mongofdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mongo_fdw/tags', 
  'mongofdw', 1, 'mongodb.png', 'MongoDB from PG', 'https://github.com/EnterpriseDB/mongo_fdw#mongo_fdw');
INSERT INTO releases VALUES ('mongofdw-pg14',  3, 'mongofdw', 'MongoFDW', '', 'prod', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('mongofdw-pg14', '5.4.0-1', 'el8', 1, '20220519', 'pg14', '', '');

INSERT INTO projects VALUES ('hivefdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/hive_fdw/tags', 
  'hivefdw', 1, 'hive.png', 'Big Data Queries from PG', 'https://github.com/pgsql-io/hive_fdw#hive_fdw');
INSERT INTO releases VALUES ('hivefdw-pg13', 14, 'hivefdw', 'HiveFDW', '', 'test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('hivefdw-pg13', '4.0-1', 'amd', 0, '20200927', 'pg13', '', '');

INSERT INTO projects VALUES ('pgredis', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/pg_redis/tags', 
  'pgredis', 1, 'redis.png', 'Leverage Redis as a Hi-speed cache', 'https://github.com/pgsql-io/pg_redis');
INSERT INTO releases VALUES ('pgredis-pg14',  2, 'pgredis', 'PgRedis',  '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pgredis-pg14', '2.0-1', 'amd', 0, '20210620', 'pg14', '', '');

INSERT INTO projects VALUES ('mysqlfdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mysql_fdw/tags', 
  'mysqlfdw', 1, 'mysql.png', 'MySQL & MariaDB from PG', 'https://github.com/EnterpriseDb/mysql_fdw');
INSERT INTO releases VALUES ('mysqlfdw-pg14',  4, 'mysqlfdw', 'MySQL FDW',  '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg14', '2.8.0-1', 'el8, arm', 1, '20220516', 'pg14', '', '');

INSERT INTO projects VALUES ('tdsfdw', 5, 0, 'hub', 0, 'https://github.com/tds-fdw/tds_fdw/tags',
  'tdsfdw', 1, 'tds.png', 'SQL Svr & Sybase from PG', 'https://github.com/tds-fdw/tds_fdw/#tds-foreign-data-wrapper');
INSERT INTO releases VALUES ('tdsfdw-pg15', 4, 'tdsfdw', 'TDS FDW', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('tdsfdw-pg15', '2.0.3-1', 'el8', 1, '20221022', 'pg15', '', 'https://github.com/tds-fdw/tds_fdw/releases/tag/v2.0.3');

INSERT INTO projects VALUES ('proctab', 9, 0, 'hub', 0, 'https://github.com/markwkm/pg_proctab/releases',
  'proctab', 1, 'proctab.png', 'Monitoring Functions for pgTop', 'https://github.com/markwkm/pg_proctab');
INSERT INTO releases VALUES ('proctab-pg12', 8, 'proctab', 'pgProcTab', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('proctab-pg12', '0.0.9-1', 'amd',  0, '20200508', 'pg12', '', '');

INSERT INTO projects VALUES ('pgtop', 9, 0, 'proctab', 0, 'https://github.com/markwkm/pg_top/releases',
  'pgtop', 1, 'pgtop.png', '"top" for Postgres', 'https://github.com/markwkm/pg_top/');
INSERT INTO releases VALUES ('pgtop-pg12', 8, 'pgtop', 'pgTop', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('pgtop-pg12', '4.0.0-1', 'amd',  0, '20201008', 'pg12', '', '');

INSERT INTO projects VALUES ('bqfdw', 5, 0, 'multicorn2', 1, 'https://pypi.org/project/bigquery-fdw/#history',
  'bqfdw', 1, 'bigquery.png', 'BigQuery from PG', 'https://pypi.org/project/bigquery-fdw');
INSERT INTO releases VALUES ('bqfdw-pg14',  3, 'bqfdw', 'BigQueryFDW', '', 'prod', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('bqfdw-pg14', '1.9', 'amd',  0, '20211218', 'pg14', '', '');

INSERT INTO projects VALUES ('esfdw', 5, 0, 'multicorn2', 1, 'https://pypi.org/project/pg-es-fdw/#history',
  'esfdw', 1, 'esfdw.png', 'ElasticSearch from PG', 'https://pypi.org/project/pg-es-fdw/');
INSERT INTO releases VALUES ('esfdw-pg14',  4, 'esfdw', 'ElasticSearchFDW', '', 'prod', '', 1, 'MIT', '', '');
INSERT INTO releases VALUES ('esfdw-pg15',  4, 'esfdw', 'ElasticSearchFDW', '', 'prod', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('esfdw-pg14', '0.11.2', 'amd',  1, '20220918', 'pg14', '', '');
INSERT INTO versions VALUES ('esfdw-pg15', '0.11.2', 'amd',  1, '20220918', 'pg15', '', '');

INSERT INTO projects VALUES ('ora2pg', 6, 0, 'hub', 0, 'https://github.com/darold/ora2pg/tags',
  'ora2pg', 0, 'ora2pg.png', 'Migrate from Oracle to PG', 'https://ora2pg.darold.net');
INSERT INTO releases VALUES ('ora2pg', 2, 'ora2pg', 'Oracle to PG', '', 'test', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('ora2pg', '23.1', '', 0, '20220512', '', '', 'https://github.com/darold/ora2pg/releases/tag/v23.1');

INSERT INTO projects VALUES ('oraclefdw', 6, 0, 'hub', 0, 'https://github.com/laurenz/oracle_fdw/tags',
  'oraclefdw', 1, 'oracle_fdw.png', 'Oracle from PG', 'https://github.com/laurenz/oracle_fdw');
INSERT INTO releases VALUES ('oraclefdw-pg15', 2, 'oraclefdw', 'OracleFDW', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('oraclefdw-pg15','2.5.0-1', 'el8', 1, '20221028', 'pg15', '', 'https://github.com/laurenz/oracle_fdw/releases/tag/ORACLE_FDW_2_5_0');

INSERT INTO projects VALUES ('oracle',  2, 1521, 'hub', 0, 'https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#19c', 
  'oracle', 0, 'oracle.png', 'Oracle Express for Linux', 'https://www.oracle.com/database/technologies');
INSERT INTO releases VALUES ('oracle', 1, 'oracle', 'Oracle', '', 'test','', 0, 'ORACLE', '', '');
INSERT INTO versions VALUES ('oracle', '11', 'amd', 0, '20180501', '', '', '');

INSERT INTO projects VALUES ('instantclient', 6, 0, 'hub', 0, 'https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html', 
  'instantclient', 0, 'instantclient.png', 'Oracle Instant Client', 'https://www.oracle.com/database/technologies/instant-client.html');
INSERT INTO releases VALUES ('instantclient', 2, 'instantclient', 'Instant Client', '', 'test','', 0, 'ORACLE', '', '');
INSERT INTO versions VALUES ('instantclient', '21.6', '', 0, '20220420', '', '', '');

INSERT INTO projects VALUES ('plusql', 6, 1, 'hub', 0, 'https://github.com/pgsql-io/plusql2/tags',
  'plusql', 0, 'plusql.png', 'SQL*PLUS<sup>&reg;</sup> Compatible CLI', 'https://github.com/pgsql-io/plusql2');
INSERT INTO releases VALUES ('plusql', 99, 'plusql', 'PlusQL', '', 'test', '', 0, 'SSPL', '', '');
INSERT INTO versions VALUES ('plusql', '0.2',  'amd', 0, '20210908', '', '', '');

INSERT INTO projects VALUES ('orafce', 6, 0, 'hub', 0, 'https://github.com/orafce/orafce/releases',
  'orafce', 1, 'larry.png', 'Ora Built-in Packages', 'https://github.com/orafce/orafce#orafce---oracles-compatibility-functions-and-packages');
INSERT INTO releases VALUES ('orafce-pg15', 2, 'orafce', 'OraFCE', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('orafce-pg15', '3.25.1-1',  'arm, el8', 1, '20221025', 'pg15', '', '');
INSERT INTO versions VALUES ('orafce-pg15', '3.25.0-1',  'arm, el8', 0, '20221006', 'pg15', '', '');

INSERT INTO projects VALUES ('fixeddecimal', 6, 0, 'hub', 0, 'https://github.com/pgsql-io/fixeddecimal/tags',
  'fixeddecimal', 1, 'fixeddecimal.png', 'Much faster than NUMERIC', 'https://github.com/pgsql-io/fixeddecimal');
INSERT INTO releases VALUES ('fixeddecimal-pg14', 90, 'fixeddecimal', 'FixedDecimal', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('fixeddecimal-pg14', '1.1.0-1',  'amd', 0, '20201119', 'pg14', '', '');

INSERT INTO projects VALUES ('plr', 3, 0, 'hub', 0, 'https://github.com/postgres-plr/plr/releases',
  'plr',   1, 'r-project.png', 'R Stored Procedures', 'https://github.com/postgres-plr/plr');
INSERT INTO releases VALUES ('plr-pg12', 4, 'plr', 'PL/R 8.4.1', '', 'soon', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plr-pg12', '8.4-1', 'amd', 0, '20200912', 'pg12', '', '');

INSERT INTO projects VALUES ('plv8', 3, 0, 'hub', 0, 'https://github.com/plv8/plv8/tags',
  'plv8',   1, 'v8.png', 'Javascript Stored Procedures', 'https://github.com/plv8/plv8');
INSERT INTO releases VALUES ('plv8-pg14', 4, 'plv8', 'PL/V8', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plv8-pg14', '3.1.2-1', 'el8', 1, '20200721', 'pg14', '', '');

INSERT INTO projects VALUES ('plpython', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plpython.html',
  'plpython', 1, 'python.png', 'Python3 Stored Procedures', 'https://www.postgresql.org/docs/13/plpython.html');
INSERT INTO releases VALUES ('plpython3', 5, 'plpython', 'PL/Python','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpython3', '13', 'arm, el8', 0, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('plperl', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plperl.html',
	'plperl', 1, 'perl.png', 'Perl Stored Procedures', 'https://www.postgresql.org/docs/13/plperl.html');
INSERT INTO releases VALUES ('plperl', 6, 'plperl', 'PL/Perl','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plperl', '13', 'arm, el8', 0, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('pljava', 3, 0, 'hub', 0, 'https://github.com/tada/pljava/releases', 
  'pljava', 1, 'pljava.png', 'Java Stored Procedures', 'https://github.com/tada/pljava');
INSERT INTO releases VALUES ('pljava-pg13', 7, 'pljava', 'PL/Java', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pljava-pg13', '1.6.2-1',  'amd',  0, '20201127', 'pg13', '', '');

INSERT INTO projects VALUES ('pldebugger', 3, 0, 'hub', 0, 'https://github.com/EnterpriseDB/pldebugger/tags',
  'pldebugger', 1, 'debugger.png', 'Stored Procedure Debugger', 'https://github.com/EnterpriseDB/pldebugger');
INSERT INTO releases VALUES ('pldebugger-pg14', 2, 'pldebugger', 'PL/Debugger', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pldebugger-pg14', '1.4-1',  'arm, el8',  1, '20210923', 'pg14', '', '');

INSERT INTO projects VALUES ('plpgsql', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plpgsql-overview.html',
  'plpgsql', 0, 'jan.png', 'Postgres Procedural Language', 'https://www.postgresql.org/docs/13/plpgsql-overview.html');
INSERT INTO releases VALUES ('plpgsql', 1, 'plpgsql', 'PL/pgSQL', '', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpgsql', '14',  'amd',  0, '20210930', '', '', '');

INSERT INTO projects VALUES ('pgtsql', 3, 0, 'hub', 0, 'https://github.com/bigsql/pgtsql/releases',
  'pgtsql', 1, 'tds.png', 'Transact-SQL Procedures', 'https://github.com/bigsql/pgtsql#pgtsql');
INSERT INTO releases VALUES ('pgtsql-pg13', 3, 'pgtsql', 'PL/pgTSQL','', 'soon', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('pgtsql-pg13', '3.0-1', 'amd', 0, '20191119', 'pg13', '', '');

INSERT INTO projects VALUES ('plprofiler', 3, 0, 'hub', 7, 'https://github.com/bigsql/plprofiler/tags',
  'plprofiler', 1, 'plprofiler.png', 'Stored Procedure Profiler', 'https://github.com/bigsql/plprofiler#plprofiler');
INSERT INTO releases VALUES ('plprofiler-pg14', 0, 'plprofiler',    'PL/Profiler',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO releases VALUES ('plprofiler-pg15', 0, 'plprofiler',    'PL/Profiler',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plprofiler-pg14', '4.2-1', 'arm, el8', 1, '20221003', 'pg14', '', '');
INSERT INTO versions VALUES ('plprofiler-pg14', '4.1-1', 'arm, el8', 0, '20211019', 'pg14', '', '');
INSERT INTO versions VALUES ('plprofiler-pg15', '4.2-1', 'arm, el8', 1, '20221003', 'pg15', '', '');

INSERT INTO projects VALUES ('golang', 4, 0, 'hub', 0, 'https://go.dev/dl',
  'golang', 0, 'go.png', 'Fast & Scaleable Programming', 'https://go.dev');
INSERT INTO releases VALUES ('golang', 9, 'golang', 'GO', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('golang', '1.19.2', '', 0, '20221021', '', '', '');

INSERT INTO projects VALUES ('walg', 4, 0, 'hub', 0, 'https://github.com/wal-g/wal-g/releases',
  'walg', 0, 'walg.png', 'Archival Restoration Tool', 'https://wal-g.readthedocs.io');
INSERT INTO releases VALUES ('walg', 9, 'walg', 'WAL-G', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('walg', '2.0.0', 'amd', 1, '20220519', '', '', '');

INSERT INTO projects VALUES ('pgrest', 4, 3000, 'hub', 0, 'https://github.com/postgrest/postgrest/tags',
  'pgrest', 0, 'postgrest.png', 'a RESTful API', 'https://postgrest.org');
INSERT INTO releases VALUES ('pgrest', 9, 'pgrest', 'PostgREST', '', 'test', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('pgrest', '10.1.1', 'arm', 1, '20221108', '', '', 'https://postgrest.org');
INSERT INTO versions VALUES ('pgrest', '9.0.1',  '', 0, '20220720', '', '', 'https://postgrest.org');

INSERT INTO projects VALUES ('autossh', 4, 0, 'hub', 0, 'https://www.harding.motd.ca/autossh/',
  'autossh', 0, 'autossh.png', 'SSH Tunneling', 'https://www.harding.motd.ca/autossh/');
INSERT INTO releases VALUES ('autossh', 9, 'autossh', 'AutoSSH sessions & tunnels', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('autossh', '1.4g', '', 1, '20190105', '', '', 'https://github.com/prometheus-community/postgres_exporter');

INSERT INTO projects VALUES ('prompgexp', 4, 9187, 'golang', 0, 'https://github.com/prometheus-community/postgres_exporter/tags',
  'prompgexp', 0, 'prometheus.png', 'Prometheus PG Exporter', 'https://github.com/prometheus-community/postgres_exporter');
INSERT INTO releases VALUES ('prompgexp', 9, 'prompgexp', 'Prometheus PG Exporter', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('prompgexp', '0.11.1', '', 1, '20220720', '', '', 'https://github.com/prometheus-community/postgres_exporter');

INSERT INTO projects VALUES ('nodejs', 4, 3000, 'hub', 0, 'https://github.com/postgrest/postgrest/tags',
  'nodejs', 0, 'prest.png', 'a RESTful API', 'https://nodejs.org');
INSERT INTO releases VALUES ('nodejs', 9, 'nodejs', 'Node.js', '', 'test', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('nodejs', '18.6.0', '', 1, '20220720', '', '', 'https://nodejs.org');

INSERT INTO projects VALUES ('audit', 4, 0, 'hub', 0, 'https://github.com/pgaudit/pgaudit/releases',
  'audit', 1, 'audit.png', 'Audit Logging', 'https://github.com/pgaudit/pgaudit');
INSERT INTO releases VALUES ('audit-pg14', 10, 'audit', 'pgAudit', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO releases VALUES ('audit-pg15', 10, 'audit', 'pgAudit', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('audit-pg14', '1.6.2-1', 'arm, el8', 1, '20220225', 'pg14', '', 'https://github.com/pgaudit/pgaudit/releases/tag/1.6.2');
INSERT INTO versions VALUES ('audit-pg15', '1.7.0-1', 'arm, el8', 1, '20221013', 'pg15', '', 'https://github.com/pgaudit/pgaudit/releases/tag/1.7.0');

INSERT INTO projects VALUES ('hintplan', 6, 0, 'hub', 0, 'https://github.com/ossc-db/pg_hint_plan/tags',
  'hintplan', 1, 'hintplan.png', 'Execution Plan Hints', 'https://github.com/ossc-db/pg_hint_plan');
INSERT INTO releases VALUES ('hintplan-pg14', 10, 'hintplan', 'pgHintPlan', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('hintplan-pg14', '1.4.0-1', 'arm, el8', 1, '20220118', 'pg14', '', 'https://github.com/pghintplan/pghintplan/releases/tag/1.6.0');

INSERT INTO projects VALUES ('odyssey', 6, 0, 'hub', 0, 'https://github.com/yandex/odyssey',
  'odyssey', 0, 'odyssey.png', 'Connection Pooler & Request Router', 'https://github.com/yandex/odyssey');
INSERT INTO releases VALUES ('odyssey', 10, 'odyssey', 'Odyssey', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('odyssey', '1.3-1', 'arm, el8', 1, '20221018', '', '', '');

INSERT INTO projects VALUES ('autofailover', 6, 0, 'hub', 0, 'https://github.com/oscg-io/auto_failover/tags',
  'autofailover', 1, 'autofailover.png', 'AutoFailover & HA', 'https://github.com/oscg-io/auto_failover');
INSERT INTO releases VALUES ('autofailover-pg15', 10, 'autofailover', 'AutoFailover', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('autofailover-pg15', '1.6.4-1', 'arm, el8', 1, '20221018', 'pg15', '', '');

INSERT INTO projects VALUES ('anon', 4, 0, 'ddlx', 1, 'https://gitlab.com/dalibo/postgresql_anonymizer/-/tags',
  'anon', 1, 'anon.png', 'Anonymization & Masking', 'https://gitlab.com/dalibo/postgresql_anonymizer/blob/master/README.md');
INSERT INTO releases VALUES ('anon-pg15', 11, 'anon', 'Anonymizer', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('anon-pg15', '1.1.0-1', 'arm, el8', 1, '20220928', 'pg15', '', '');

INSERT INTO projects VALUES ('citus', 4, 0, 'hub',0, 'https://github.com/citusdata/citus/releases',
  'citus', 1, 'citus.png', 'Distributed PostgreSQL', 'https://github.com/citusdata/citus');
INSERT INTO releases VALUES ('citus-pg15',  0, 'citus', 'Citus', '', 'prod', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('citus-pg15', '11.1.4-1', 'el8, arm', 1, '20221024', 'pg15', '', 'https://github.com/citusdata/citus/releases/tag/v11.1.4');
INSERT INTO versions VALUES ('citus-pg15', '11.1.3-1', 'el8, arm', 0, '20221014', 'pg15', '', 'https://github.com/citusdata/citus/releases/tag/v11.1.3');

INSERT INTO projects VALUES ('cron', 4, 0, 'hub',0, 'https://github.com/citusdata/pg_cron/releases',
  'cron', 1, 'cron.png', 'Background Job Scheduler', 'https://github.com/citusdata/pg_cron');
INSERT INTO releases VALUES ('cron-pg14', 10, 'cron', 'pgCron', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('cron-pg14', '1.4.2-1', 'el8, arm', 1, '20220714', 'pg14', '', '');

INSERT INTO projects VALUES ('background', 4, 0, 'hub',0, 'https://github.com/oscg-io/background/tags',
  'background', 1, 'background.png', 'Background Worker', 'https://github.com/oscg-io/background');
INSERT INTO releases VALUES ('background-pg14', 10, 'background', 'Background', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('background-pg14', '1.1-1', 'el8, arm', 1, '20220804', 'pg14', '', '');

INSERT INTO projects VALUES ('timescaledb', 4, 0, 'hub', 1, 'https://github.com/timescale/timescaledb/releases',
   'timescaledb', 1, 'timescaledb.png', 'Time Series Data', 'https://github.com/timescale/timescaledb/#timescaledb');
INSERT INTO releases VALUES ('timescaledb-pg14',  2, 'timescaledb', 'TimescaleDB', '', 'prod', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('timescaledb-pg14', '2.8.0-1',  'el8, arm', 0, '20220831', 'pg14', '', 'https://github.com/timescale/timescaledb/releases/tag/2.8.0');

INSERT INTO projects VALUES ('spock', 4, 0, 'hub', 1, 'https://github.com/oscg-io/spock/tags',
  'spock', 1, 'spock.png', 'Logical & Multi-Master Replication', 'https://github.com/oscg-io/spock/#spock');
INSERT INTO releases VALUES ('spock-pg14', 4, 'spock', 'Spock', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO releases VALUES ('spock-pg15', 4, 'spock', 'Spock', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('spock-pg14', '3.0.6-1',  'el8, arm', 0, '20221114', 'pg14', '', '');
INSERT INTO versions VALUES ('spock-pg15', '3.0.6-1',  'el8, arm', 0, '20221114', 'pg15', '', '');
INSERT INTO versions VALUES ('spock-pg15', '3.0.7-1',  'el8, arm', 1, '20221117', 'pg15', '', '');

INSERT INTO projects VALUES ('pglogical', 4, 0, 'hub', 1, 'https://github.com/2ndQuadrant/pglogical/releases',
  'pglogical', 1, 'spock.png', 'Logical Replication', 'https://github.com/2ndQuadrant/pglogical');
INSERT INTO releases VALUES ('pglogical-pg14', 4, 'pglogical', 'pgLogical', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO releases VALUES ('pglogical-pg15', 4, 'pglogical', 'pgLogical', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pglogical-pg14', '2.4.2-1',  'arm, el8', 1, '20221021', 'pg14', '', 'https://github.com/2ndQuadrant/pglogical/releases/tag/REL2_4_2');
INSERT INTO versions VALUES ('pglogical-pg15', '2.4.2-1',  'arm, el8', 1, '20221021', 'pg15', '', 'https://github.com/2ndQuadrant/pglogical/releases/tag/REL2_4_2');

INSERT INTO projects VALUES ('postgis', 4, 1, 'hub', 3, 'http://postgis.net/source',
  'postgis', 1, 'postgis.png', 'Spatial Extensions', 'http://postgis.net');
INSERT INTO releases VALUES ('postgis-pg15', 3, 'postgis', 'PostGIS', '', 'prod', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('postgis-pg15', '3.3.1-1', 'arm', 1, '20220909', 'pg15', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.3.1/NEWS');

INSERT INTO projects VALUES ('omnidb', 6, 8000, '', 1, 'https://github.com/pgsql-io/omnidb-ng/tags',
  'omnidb', 0, 'omnidb.png', 'UI for Database Mgmt', 'https://github.com/pgsql-io/omnidb-ng#omnidb-ng-306');
INSERT INTO releases VALUES ('omnidb', 1, 'omnidb', 'OmniDB-NG', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('omnidb', '3.0.6', '', 0, '20220509', '', '', '');

INSERT INTO projects VALUES ('kubernetes', 11, 80, '', 1, 'https://github.com/ubuntu/microk8s/releases',
  'kubernetes', 0, 'kubernetes.png', 
  'Scale & Manage Containers', 
  'https://k8s.io');
INSERT INTO releases VALUES ('kubernetes', 3, 'kubernetes', 'Kubernetes', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('kubernetes', '1.22', '', 0, '20210809', '', 'UBU20', '');

INSERT INTO projects VALUES ('pgadmin', 3, 80, '', 1, 'https://www.pgadmin.org/news/',
  'pgadmin', 0, 'pgadmin.png', 'PostgreSQL Tools', 'https://pgadmin.org');
INSERT INTO releases VALUES ('pgadmin', 2, 'pgadmin', 'pgAdmin 4', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('pgadmin', '6.9', '', 0, '20220512', '', '', '');

INSERT INTO projects VALUES ('bulkload', 4, 0, 'hub', 5, 'https://github.com/ossc-db/pg_bulkload/releases',
  'bulkload', 1, 'bulkload.png', 'High Speed Data Loading', 'https://github.com/ossc-db/pg_bulkload');
INSERT INTO releases VALUES ('bulkload-pg14', 6, 'bulkload', 'pgBulkLoad',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bulkload-pg14', '3.1.19-1', 'arm, el8', 1, '20211012', 'pg14', '', '');

INSERT INTO projects VALUES ('repack', 4, 0, 'hub', 5, 'https://github.com/reorg/pg_repack/tags',
  'repack', 1, 'repack.png', 'Remove Table/Index Bloat' , 'https://github.com/reorg/pg_repack');
INSERT INTO releases VALUES ('repack-pg15', 6, 'repack', 'pgRepack',  '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('repack-pg15', '1.4.8-1', 'arm, el8', 1, '20221019', 'pg15', '', '');

INSERT INTO projects VALUES ('partman', 4, 0, 'hub', 4, 'https://github.com/pgpartman/pg_partman/tags',
  'partman', 1, 'partman.png', 'Partition Management', 'https://github.com/pgpartman/pg_partman#pg-partition-manager');
INSERT INTO releases VALUES ('partman-pg15', 6, 'partman', 'pgPartman',   '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('partman-pg15', '4.7.1-1',  'arm, el8', 1, '20221013', 'pg15', '', '');

INSERT INTO projects VALUES ('hypopg', 4, 0, 'hub', 8, 'https://github.com/HypoPG/hypopg/releases',
  'hypopg', 1, 'whatif.png', 'Hypothetical Indexes', 'https://hypopg.readthedocs.io/en/latest/');
INSERT INTO releases VALUES ('hypopg-pg14', 99, 'hypopg', 'HypoPG', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('hypopg-pg14', '1.3.1-1',  'arm, el8', 1, '20210622', 'pg14', '', '');

INSERT INTO projects VALUES ('badger', 4, 0, 'hub', 6, 'https://github.com/darold/pgbadger/releases',
  'badger', 0, 'badger.png', 'Performance Reporting', 'https://pgbadger.darold.net');
INSERT INTO releases VALUES ('badger', 101, 'badger','pgBadger','', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('badger', '11.8', '', 0, '20220408', '', '', '');

INSERT INTO projects VALUES ('pool2', 4, 0, 'hub', 3, 'http://github.com/pgpool/pgpool2/tags',
  'pool2',  0, 'pgpool2.png', 'QueryCache', 'http://pgpool.net');
INSERT INTO releases VALUES ('pool2', 1, 'pool2',  'pgPool2', '', 'included', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('pool2', '4.3.1', 'el8, arm', 1, '20220216', '', '', '');

INSERT INTO projects VALUES ('bouncer', 4, 5433, 'hub', 3, 'http://pgbouncer.org',
  'bouncer',  0, 'pg-bouncer.png', 'Connection Pooler', 'http://pgbouncer.org');
INSERT INTO releases VALUES ('bouncer', 2, 'bouncer',  'pgBouncer', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bouncer', '1.17.0-1', 'el8, arm', 1, '20220323', '', '', '');

INSERT INTO projects VALUES ('patroni', 11, 0, 'haproxy', 4, 'https://github.com/zalando/patroni/releases',
  'patroni', 0, 'patroni.png', 'HA Template', 'https://github.com/zalando/patroni');
INSERT INTO releases VALUES ('patroni', 1, 'patroni', 'Patroni', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('patroni', '2.1.1', '', 0, '20210819', '', 'UBU20 PYTHON3', 'https://github.com/zalando/patroni/releases/tag/v2.1.1');

INSERT INTO projects VALUES ('pgjdbc', 7, 0, 'hub', 1, 'https://jdbc.postgresql.org', 'jdbc', 0, 'java.png', 'JDBC Driver', 'https://jdbc.postgresql.org');
INSERT INTO releases VALUES ('pgjdbc', 7, 'jdbc', 'JDBC', '', 'bring-own', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pgjdbc', '42.2.18', '', 0, '20201015', '', '',
  'https://jdbc.postgresql.org/documentation/changelog.html#version_42.2.18');

INSERT INTO projects VALUES ('npgsql', 7, 0, 'hub', 2, 'https://www.nuget.org/packages/Npgsql/', 'npgsql', 0, 'npgsql.png', '.NET Provider', 'https://www.npgsql.org');
INSERT INTO releases VALUES ('npgsql', 20, 'npgsql', '.net PG', '', 'bring-own', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('npgsql', '5.0.1.1', '', 0, '20201211', '', '', '');
INSERT INTO versions VALUES ('npgsql', '5.0.0', '', 0, '20201115', '', '', '');
INSERT INTO versions VALUES ('npgsql', '4.1.5', '', 0, '20200929', '', '', '');

INSERT INTO projects VALUES ('psycopg', 7, 0, 'hub', 3, 'https://pypi.org/project/psycopg2/', 'psycopg', 0, 'psycopg.png', 'Python Adapter', 'http://psycopg.org');
INSERT INTO releases VALUES ('psycopg', 6, 'psycopg', 'Psycopg2', '', 'bring-own', '', 1, 'LGPLv2', '', '');
INSERT INTO versions VALUES ('psycopg', '2.8.6', '', 0, '20200906', '', '', '');

INSERT INTO projects VALUES ('ruby', 7, 0, 'hub', 4, 'https://rubygems.org/gems/pg', 'ruby', 0, 'ruby.png', 'Ruby Interface', 'https://github.com');
INSERT INTO releases VALUES ('ruby', 7, 'ruby', 'Ruby', '', 'bring-own', '', 1, 'BSD-2', '', '');
INSERT INTO versions VALUES ('ruby', '1.2.3', '', 0, '20200318', '', '', '');

INSERT INTO projects VALUES ('psqlodbc', 3, 0, 'hub', 5, 'https://www.postgresql.org/ftp/odbc/versions/msi/', 'psqlodbc', 0, 'odbc.png', 'ODBC Driver', 'https://odbc.postgresql.org');
INSERT INTO releases VALUES ('psqlodbc', 2, 'psqlodbc',  'psqlODBC', '', 'test', '', 1, 'LIBGPLv2', '', '');
INSERT INTO versions VALUES ('psqlodbc', '13.01-1', 'amd', 0, '20210502', '', '', '');
INSERT INTO versions VALUES ('psqlodbc', '13.00-1', 'amd', 0, '20201119', '', '', '');

INSERT INTO projects VALUES ('ddlx',      7, 0, 'hub', 0, 'https://github.com/lacanoid/pgddl/releases', 'ddlx',  1, 'ddlx.png', 'DDL Extractor', 'https://github.com/lacanoid/pgddl#ddl-extractor-functions--for-postgresql');
INSERT INTO releases VALUES ('ddlx-pg13', 2, 'ddlx', 'DDLeXtact', '', 'prod','',  0, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('ddlx-pg13', '0.17-1', 'amd', 1, '20200911', 'pg13', '', '');

INSERT INTO projects VALUES ('wa',      4, 0, 'hub', 1, 'https://github.com/powa-team/powa/releases', 'powa',  1, 'powa.png', 'Analyzer', 'https://powa.readthedocs.io/en/latest/components/index.html');
INSERT INTO releases VALUES ('wa-pg13', 97, 'wa', 'Analyzer', '', 'test','', '', 'POSTGRES', '', '');
INSERT INTO versions VALUES ('wa-pg13', '2.1-1', 'amd', 0, '20210508', 'pg13', '', '');

INSERT INTO projects VALUES ('archivist',      4, 0, 'hub', 1, 'https://github.com/powa-team/powa/releases', 'archivist',  1, 'archivist.png', 'Archive Workloads', ' https://powa.readthedocs.io/en/latest/components/powa-archivist/index.html');
INSERT INTO releases VALUES ('archivist-pg13', 97, 'archivist', 'Archivist', '', 'test','',  0, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('archivist-pg13', '4.1.2-1', 'amd', 0, '20201220', 'pg13', '', '');

INSERT INTO projects VALUES ('qualstats', 4, 0, 'powa', 2, 'https://github.com/powa-team/pg_qualstats/releases',
  'qualstats', 1, 'qualstats.png', 'WHERE Clause Stats', 'https://github.com/powa-team/pg_qualstats');
INSERT INTO releases VALUES ('qualstats-pg13', 98, 'qualstats', 'QualStats', '', 'test','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('qualstats-pg13', '2.0.3-1', 'amd', 0, '20210604', 'pg13', '', '');

INSERT INTO projects VALUES ('statkcache', 4, 0, 'powa', 3, 'https://github.com/powa-team/pg_stat_kcache/releases',
  'statkcache', 1, 'statkcache.png', 'Filesystem Stats', 'https://github.com/powa-team/pg_stat_kcache');
INSERT INTO releases VALUES ('statkcache-pg13', 98, 'statkcache', 'StatKcache', '', 'test','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('statkcache-pg13', '2.2.0-1', 'amd', 0, '20201210', 'pg13', '', '');

INSERT INTO projects VALUES ('waitsampling', 4, 0, 'powa', 4, 'https://github.com/postgrespro/pg_wait_sampling/releases',
  'waitsampling', 1, 'waitsampling.png', 'Stats for Wait Events', 'https://github.com/postgrespro/pg_wait_sampling');
INSERT INTO releases VALUES ('waitsampling-pg13', 98, 'waitsampling', 'WaitSampling', '', 'test','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('waitsampling-pg13', '1.1.3-1', 'amd', 0, '20210127', 'pg13', '', '');

INSERT INTO projects VALUES ('statmonitor', 4, 0, 'powa', 4, 'https://github.com/percona/pg_stat_monitor/releases',
  'statmonitor', 1, 'percona.png', 'Query Performance Monitoring', 'https://github.com/percona/pg_stat_monitor');
INSERT INTO releases VALUES ('statmonitor-pg13', 98, 'statmonitor', 'pgStatMonitor', '', 'test','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('statmonitor-pg13', '0.9.1-1', 'amd', 0, '20210414', 'pg13', '', '');

INSERT INTO projects VALUES ('multicorn2', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/multicorn2/tags',
  'multicorn2', 1, 'multicorn.png', 'Python FDW Library', 'http://multicorn2.org');
INSERT INTO releases VALUES ('multicorn2-pg14', 1, 'multicorn2', 'Multicorn2', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO releases VALUES ('multicorn2-pg15', 1, 'multicorn2', 'Multicorn2', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('multicorn2-pg15', '2.4-1', 'arm, el8', 1, '20220909', 'pg15', '', '');
INSERT INTO versions VALUES ('multicorn2-pg14', '2.4-1', 'arm, el8', 1, '20220909', 'pg14', '', '');
INSERT INTO versions VALUES ('multicorn2-pg14', '2.3-1', 'el8', 0, '20220509', 'pg14', '', '');
