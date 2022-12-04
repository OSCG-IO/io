
import sys, os
import util, meta

try:
  import fire
except ImportError as e:
  print("ERROR: Missing 'fire' module from pip")
  sys.exit(1)

isVerbose = os.getenv('isVerbose', 'False')
if isVerbose == 'False':
  isVerbose = False
else:
  isVerbose = True


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
      print("ERROR: must be one PG installed")
      sys.exit(1)

  if not os.path.isdir(pg_v):
    print("ERROR: " + pg_v + " not installed")
    sys.exit(1)

  rc = os.system(pg_v + "/bin/pg_isready > /dev/null 2>&1")
  if rc != 0:
    print("ERROR: " + pg_v + " not ready") 
    sys.exit(1)

  os.environ['pgName'] = str(db)

  return(pg_v)


def get_eq(parm, val, sufx):
  colon_equal = str(parm) + " := '" + str(val) + "'" + str(sufx)

  ##print("DEBUG: colon_equal = " + str(colon_equal))
  return(colon_equal)


def create_node(node_name, dsn, db, pg=None):
  pg_v = set_pg_db(pg, db)
  ##print("DEBUG: pg_v = " + str(pg_v))

  sql = "SELECT spock.create_node(" + \
           get_eq("node_name", node_name, ", ") + \
           get_eq("dsn",       dsn,       ")")

  ##print("DEBUG: sql = \n" + str(sql))
  rc = util.run_sql_cmd(pg_v, sql, isVerbose)

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
      'create_node': create_node,
      'create_replication_set': create_replication_set,
      'create_subscription': create_subscription,
      'alter_subscription_add_replication_set': alter_subscription_add_replication_set,
      'wait_for_subscription_sync_complete': wait_for_subscription_sync_complete,
  })

