

function test14 {
  pgV=pg14
  ./io install pg14; 
  ./io start pg14 -y -d demo;

  ## Citus must be installed first before any other extension
  ./io install citus-$pgV

  ./io install audit-$pgV         -d demo
  ./io install hintplan-$pgV      -d demo
  ./io install timescaledb-$pgV   -d demo
}


function testCommon {
  ./io install multicorn2-$pgV    -d demo
  ./io install plprofiler-$pgV    -d demo
  ./io install pldebugger-$pgV    -d demo

  ./io install decoderbufs-$pgV   -d demo
  ./io install postgis-$pgV       -d demo
  ./io install hypopg-$pgV        -d demo
  ./io install cron-$pgV
  ./io install repack-$pgV        -d demo
  ./io install orafce-$pgV        -d demo
  ./io install spock-$pgV        -d demo
  ##./io install wal2json-$pgV      -d demo
  ##./io install pglogical-$pgV     -d demo
  ##./io install anon-$pgV          -d demo

  ./io install bulkload-$pgV      -d demo
  ./io install partman-$pgV       -d demo

  #./io install plv8-$pgV          -d demo

  ./io install mysqlfdw-$pgV      -d demo
  ./io install mongofdw-$pgV      -d demo
  ./io install oraclefdw-$pgV     -d demo

  #./io install archivist-pg13     -d demo
  #./io install qualstats-pg13     -d demo
  #./io install statkcache-pg13    -d demo
  #./io install waitsampling-pg13  -d demo

  #./io install redisfdw-pg13      -d demo

  #./io install esfdw-pg13         -d demo
}


function test13 {
  pgV=pg13
  ./io install pg13; 
  ./io start pg13 -y -d demo;
}


cd ../..

if [ "$1" == "13" ]; then
  test13
  testCommon
  exit 0
fi

if [ "$1" == "14" ]; then
  test14
  testCommon
  exit 0
fi

echo "ERROR: Invalid parm, must be '13' or '14'"
exit 1

