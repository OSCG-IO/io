
import sys, os
import util, meta

try:
  import fire
except ImportError as e:
  util.exit_message("Missing 'fire' module from pip", 1)

try:
  import psycopg2
except ImportError as e:
  util.exit_message("Missing 'psycopg2' module from pip", 1)

isVerbose = os.getenv('isVerbose', 'False')
if isVerbose == 'False':
  isVerbose = False
else:
  isVerbose = True


def run_psyco_sql(pg_v, db, cmd, usr=None):
  if usr == None:
    usr = "postgres"

  dbp = util.get_column("port", pg_v)

  try:
    con = psycopg2.connect(dbname=db, user=usr, host="localhost", port=dbp)
    cur = con.cursor()
    cur.execute(cmd)
    data = cur.fetchall()
    for d in data:
      print(str(d))
    cur.close()
    conn.close()
  except Exception as e:
    util.exit_message(str(e), 1)


def set_pg_db(pg, db):
  pg_v = str(pg)

  if pg_v.isdigit():
    pg_v = "pg" + str(pg_v)

  if pg_v == "None":
    k = 0
    pg_s = meta.get_installed_pg()

    for p in pg_s:
      k = k + 1

    if k == 1:
      pg_v = str(p[0])
    else:
      util.exit_message("must be one PG installed", 1)

  if not os.path.isdir(pg_v):
    util.exit_message(str(pg_v) + " not installed", 1)

  rc = os.system(pg_v + "/bin/pg_isready > /dev/null 2>&1")
  if rc != 0:
    util.exit_message(pg_v + " not ready", 1) 

  os.environ['pgName'] = str(db)

  return(pg_v)


def get_eq(parm, val, sufx):
  colon_equal = str(parm) + " := '" + str(val) + "'" + str(sufx)

  return(colon_equal)


def create_node(node_name, dsn, db, pg=None):
  pg_v = set_pg_db(pg, db)

  sql = "SELECT spock.create_node(" + \
           get_eq("node_name", node_name, ", ") + \
           get_eq("dsn",       dsn,       ")")

  ##rc = util.run_sql_cmd(pg_v, sql, isVerbose)
  run_psyco_sql(pg_v, db, sql)

  sys.exit(rc)


def create_replication_set(set_name, db, replicate_insert=True, replicate_update=True, 
                           replicate_delete=True, replicate_truncate=True, pg=None):
  pg_v = set_pg_db(pg, db)

  sql = "SELECT spock.create_replication_set(" + \
           get_eq("set_name", set_name, ", ") + \
           get_eq("replicate_insert",   replicate_insert,   ", ") + \
           get_eq("replicate_update",   replicate_update,   ", ") + \
           get_eq("replicate_delete",   replicate_delete,   ", ") + \
           get_eq("replicate_truncate", replicate_truncate, ")")

  rc = util.run_sql_cmd(pg_v, sql, isVerbose)
  sys.exit(rc)


def create_subscription(subscription_name, provider_dsn, db, replication_sets=None,
                        synchronize_structure=False, synchronize_data=False, 
                        forward_origins='{}', apply_delay=0, pg=None):
  pg_v = set_pg_db(pg, db)

  sql = "SELECT spock.create_subscription(" + \
           get_eq("subscription_name",     subscription_name,     ", ") + \
           get_eq("provider_dsn",          provider_dsn,          ", ") + \
           get_eq("replication_sets",      replication_sets,      ", ") + \
           get_eq("synchronize_structure", synchronize_structure, ", ") + \
           get_eq("synchronize_data",      synchronize_data,      ", ") + \
           get_eq("forward_origins",       forward_origins,       ", ") + \
           get_eq("apply_delay",           apply_delay,           ")")

  rc = util.run_sql_cmd(pg_v, sql, isVerbose)
  sys.exit(rc)


def alter_subscription_add_replication_set(subscription_name, replication_set, db, pg=None):
  pg_v = set_pg_db(pg, db)

  sql = "SELECT spock.alter_subscription_add_replication_set(" + \
           get_eq("subscription_name", subscription_name, ", ") + \
           get_eq("replication_set",   replication_set,   ")")

  rc = util.run_sql_cmd(pg_v, sql, isVerbose)
  sys.exit(rc)


def wait_for_subscription_sync_complete(subscription_name, db, pg):
  pg_v = set_pg_db(pg, db)

  sql = "SELECT spock.wait_for_subscription_sync_complete(" + \
           get_eq("subscription_name", subscription_name, ")")

  rc = util.run_sql_cmd(pg_v, sql, isVerbose)
  sys.exit(rc)


if __name__ == '__main__':
  fire.Fire({
      'create-node': create_node,
      'create-replication-set': create_replication_set,
      'create-subscription': create_subscription,
      'alter-subscription-add-replication-set': alter_subscription_add_replication_set,
      'wait-for-subscription-sync-complete': wait_for_subscription_sync_complete,
  })

