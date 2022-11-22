import os
import util

port = util.get_comp_port("postgrest")

print("postgrest starting on port " + port)

os.system("postgrest/postgrest postgrest/postgrest.conf >> data/logs/postgrest/postgrest.log 2>&1 &")

