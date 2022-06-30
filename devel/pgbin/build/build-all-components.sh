
source versions.sh


function build {
  pgbin="--with-pgbin /opt/pgcomponent/pg$pgV"
  pgver="--with-pgver $3"
  src="$SRC/$1-$2.tar.gz"
  echo ""
  echo "###################################"
  cmd="./build-component.sh --build-$1 $src $pgbin $pgver $copyBin $4"
  ## echo "cmd=$cmd"
  $cmd
  rc=$?
}


################### MAINLINE #####################

pgV="$2"
copyBin="$3"
if [ "$copyBin" == "" ]; then
  copyBin="--no-copy-bin"
fi
if [[ "$pgV" < "11" ]] || [[ "$pgV" > "15" ]]; then
  echo  "ERROR: second parm must be 11 thru 15"
  exit 1
fi


## WIP ############################################

if [ "$1" == "parquets3fdw" ]; then
  build parquets3fdw $parquetFullV $2 parquets3fdw
fi

if [ "$1" == "agent" ]; then
  build agent $agentFullV $2 agent
fi

if [ "$1" == "pljava" ]; then
  build pljava $pljavaFullV $2 pljava
fi

if [ "$1" == "plv8" ]; then
  build plv8 $plv8FullV $2 plv8
fi

if [ "$1" == "pgtsql" ]; then
  build pgtsql $pgTSQLFullV $2 tsql
fi

if [ "$1" == "pgtop" ]; then
  build pgtop $pgtopFullV $2 pgtop
fi

if [ "$1" == "pldebugger" ]; then
  build pldebugger $debugFullV $2 pldebugger
fi

if [ "$1" == "pgredis" ]; then
  build pgredis $pgredisFullV $2 pgredis
fi


if [ "$1" == "archivist" ]; then
  build archivist $archivFullV $2 archivist
fi

if [ "$1" == "statkcache" ]; then
  build statkcache $statkFullV $2 statkcache
fi

if [ "$1" == "qualstats" ]; then
  build qualstats $qstatFullV $2 qualstats
fi

if [ "$1" == "waitsampling" ]; then
  build waitsampling $waitsFullV $2 waitsampling
fi

## PROD ##############################################

if [ "$1" == "hintplan" ] || [ "$1" == "all" ]; then
  build hintplan $hintplanFullV $2 hintplan
fi

if [ "$1" == "decoderbufs" ]  || [ "$1" == "all" ]; then
  build decoderbufs $decoderbufsFullV $2 decoderbufs
fi

if [ "$1" == "wal2json" ]  || [ "$1" == "all" ]; then
  build wal2json $wal2jsonFullV $2 wal2json
fi

if [ "$1" == "mongofdw" ]; then
  build mongofdw $mongofdwFullV $2 mongofdw
fi

if [ "$1" == "backrest" ]; then
  build backrest $backrestFullV $2 backrest
fi

if [ "$1" == "citus" ]; then
  build citus $citusFullV $2 citus
fi

if [ "$1" == "multicorn2" ]; then
  build multicorn2 $multicorn2FullV $2 multicorn2 
fi

if [ "$1" == "cron" ] || [ "$1" == "all" ]; then
  build cron $cronFullV $2 cron
fi

if [ "$1" == "hivefdw" ]; then
  build hivefdw $hivefdwFullV $2 hivefdw
fi

if [ "$1" == "cassandrafdw" ]; then
  build cassandrafdw $cassFullV $2 cassandrafdw
fi

if [ "$1" == "repack" ] || [ "$1" == "all" ]; then
  build repack $repackFullV $2 repack
fi

if [ "$1" == "partman" ] || [ "$1" == "all" ]; then
  build partman $partmanFullV $2 partman
fi

if [ "$1" == "bulkload" ] || [ "$1" == "all" ]; then
  build bulkload $bulkloadFullV $2 bulkload
fi

if [ "$1" == "postgis" ] || [ "$1" == "all" ]; then
  build postgis $postgisFullV $2 postgis  
fi

if [ "$1" == "audit" ] || [ "$1" == "all" ]; then
  build audit $auditFull14V $2 audit    
fi

if [ "$1" == "orafce" ] || [ "$1" == "all" ]; then
  build orafce $orafceFullV $2 orafce
fi

if [ "$1" == "fixeddecimal" ] || [ "$1" == "all" ]; then
  build fixeddecimal $fdFullV $2 fixeddecimal
fi

if [ "$1" == "hypopg" ] || [ "$1" == "all" ]; then
  build hypopg $hypopgFullV $2 hypopg
fi

if [ "$1" == "plprofiler" ]; then
  build plprofiler $plProfilerFullVersion $2 profiler
fi

if [ "$1" == "timescaledb" ] || [ "$1" == "all" ]; then
  build timescaledb $timescaledbFullV $2 timescale
fi

if [ "$1" == "spock" ] || [ "$1" == "all" ]; then
  build spock $spockFullV $2  spock
fi

if [ "$1" == "pglogical" ] || [ "$1" == "all" ]; then
  build pglogical $pgLogicalFullV $2 logical
fi

if [ "$1" == "anon" ] || [ "$1" == "all" ]; then
  build anon $anonFullV $2 anon
fi

if [ "$1" == "ddlx" ]; then
  build ddlx $ddlxFullV $2 ddlx
fi

if [ "$1" == "http" ]; then
  build http $httpFullV $2 http
fi

if [ "$1" == "proctab" ]; then
  build proctab $proctabFullV $2 proctab
fi

if [ "$1" == "bouncer" ]; then
  build bouncer $bouncerFullV $2 bouncer
fi

if [ "$1" == "mysqlfdw" ]; then
  build mysqlfdw $mysqlfdwFullV $2 mysqlfdw
fi

if [ "$1" == "oraclefdw" ]; then
  build oraclefdw $oraclefdwFullV $2 oraclefdw
fi

if [ "$1" == "tdsfdw" ]; then
  build tdsfdw $tdsfdwFullV $2 tdsfdw
fi

exit 0
