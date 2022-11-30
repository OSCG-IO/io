
import sys, os
import util, meta

try:
  import fire
except ImportError as e:
  print("ERROR: Missing 'fire' module from pip")
  sys.exit(1)


def get_one_pg(pg):
  if pg:
    return(pg)

  k = 0
  pg_s = meta.get_installed_pg()
  for p in pg_s:
    k = k + 1
    if k > 1:
      print("ERROR: must be only one PG installed")
      sys.exit(1)

  return(str(p[0]))



def create_node(node_name, dsn, db, pg=None):
  pg_v = get_one_pg(pg)
  os.environ['pgName'] = str(db)

  sql = "SELECT spock.create_node(node_name := '" + node_name + \
                                  "' , dsn := '" + dsn + "')"
  rc = util.run_sql_cmd(pg_v, sql, True)
  sys.exit(rc)


def create_replication_set(set_name, replicate_insert=True, replicate_update=True, 
                           replicate_delete=True, replicate_truncate=True):
  pass


def create_subscription(subscription_name, provider_dsn, replication_sets=None,
                        synchronize_structure=False, synchronize_data=False, 
                        forward_origins='{}', apply_delay=0):
  pass


def alter_subscription_add_replication_set(subscription_name, replication_set):
  pass


def wait_for_subscription_sync_complete(subscription_name):
  pass


if __name__ == '__main__':
  fire.Fire({
      'create_node': create_node,
      'create_replication_set': create_replication_set,
      'create_subscription': create_subscription,
      'alter_subscription_add_replication_set': alter_subscription_add_replication_set,
      'wait_for_subscription_sync_complete': wait_for_subscription_sync_complete,
  })

