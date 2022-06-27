 
####################################################################
######          Copyright (c)  2020-2021 OpenRDS          ##########
####################################################################

import util, datetime, os

util.change_pgconf_keyval("pgXX", "wal_level", "logical", True)
util.change_pgconf_keyval("pgXX", "max_worker_processes", "10", True)
util.change_pgconf_keyval("pgXX", "max_replication_slots", "10", True)
util.change_pgconf_keyval("pgXX", "max_wal_senders", "10", True)

util.change_pgconf_keyval("pgXX", "track_commit_timestamp", "on", True)
util.change_pgconf_keyval("pgXX", "pglogical.conflict_resolution", "last_update_wins", True)
#util.change_pgconf_keyval("pgXX", "log_min_messages", "debug3", True)

util.change_pgconf_keyval("pgXX", "log_destination", "stderr, csvlog")

util.run_sql_cmd("pgXX", "CREATE EXTENSION file_fdw", True)
util.run_sql_cmd("pgXX", "CREATE SERVER pglog FOREIGN DATA WRAPPER file_fdw", True)

util.change_pgconf_keyval("pgXX", "pglogical.conflict_resolution", "last_update_wins", True)

day = datetime.datetime.now().strftime('%a')
logdir = util.get_column("logdir", "pgXX")
csvlogfile = logdir + os.sep + "postgresql-" + day + ".csv"
sql = \
"CREATE FOREIGN TABLE pglog ( \
  log_time timestamp(3) with time zone, \
  user_name text, \
  database_name text, \
  process_id integer, \
  connection_from text, \
  session_id text, \
  session_line_num bigint, \
  command_tag text, \
  session_start_time timestamp with time zone, \
  virtual_transaction_id text, \
  transaction_id bigint, \
  error_severity text, \
  sql_state_code text, \
  message text, \
  detail text, \
  hint text, \
  internal_query text, \
  internal_query_pos integer, \
  context text, \
  query text, \
  query_pos integer, \
  location text, \
  application_name text \
) SERVER pglog \
OPTIONS ( filename '" + csvlogfile + "', format 'csv' )"
util.run_sql_cmd("pgXX", sql, True)

passwd = util.get_random_password(10)
ip = util.get_1st_ip()
port = util.get_comp_port("pgXX")
util.remember_pgpassword(passwd, port, ip, "*", "replication")
sql="CREATE ROLE replication WITH SUPERUSER REPLICATION LOGIN ENCRYPTED PASSWORD '" + passwd + "'"
util.run_sql_cmd("pgXX", sql, False)

datadir = util.get_column("datadir", "pgXX")
os.system("cp " + datadir + "/pg_hba.conf " + datadir + "/pg_hba.conf.orig")

thisdir = os.path.dirname(os.path.realpath(__file__))
os.system("cp " + thisdir + "/pg_hba.conf.replication " + datadir + "/pg_hba.conf")

util.create_extension("pgXX", "pglogical", True)


