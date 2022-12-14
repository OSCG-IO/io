
import os
import util

logdir = os.getcwd() + "/data/logs/postgrest"

port = util.get_comp_port("postgrest")

print("postgrest starting on port " + port)
os.system("postgrest/postgrest postgrest/postgrest.conf >> " + logdir + "/postgrest.log 2>&1 &")

print("swagger starting on port 8080")
os.chdir("/usr/local/lib/node_modules/swagger-ui-dist/")
os.system("npx http-server >> " + logdir + "/swagger.log 2>&1 &")

