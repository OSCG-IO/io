#!/bin/bash 

source env.sh

if [ "x$REPO" == "x" ]; then
  repo="http://localhost"
else
  repo="$REPO"
fi

`python --version  > /dev/null 2>&1`
rc=$?
if [ $rc == 0 ];then
  PYTHON=python
else
  PYTHON=python3
fi

if [ "$OUT" == "" ]; then
  echo "ERROR: Environment is not set"
  exit 1
fi


printUsageMessage () {
  echo "#-------------------------------------------------------------------#"
  echo "#                Copyright (c) 2022 OSCG                            #"
  echo "#-------------------------------------------------------------------#"
  echo "# -p $P15 $P14 $P13  $P12  $P11"
  echo "# -b hub-$hubV"
  echo "#-------------------------------------------------------------------#"
}


fatalError () {
  echo "FATAL ERROR!  $1"
  if [ "$2" == "u" ]; then
    printUsageMessage
  fi
  echo
  exit 1
}


echoCmd () {
  echo "# $1"
  checkCmd "$1"
}


checkCmd () {
  $1
  rc=`echo $?`
  if [ ! "$rc" == "0" ]; then
    fatalError "Stopping Script"
  fi
}


myReplace () {
  oldVal="$1"
  newVal="$2"
  fileName="$3"

  if [ ! -f "$fileName" ]; then
    echo "ERROR: Invalid file name - $fileName"
    return 1
  fi

  if [ `uname` == "Darwin" ]; then
    sed -i "" "s#$oldVal#$newVal#g" "$fileName"
  else
    sed -i "s#$oldVal#$newVal#g" "$fileName"
  fi
}

## write Setting row to SETTINGS config table
writeSettRow() {
  pSection="$1"
  pKey="$2"
  pValue="$3"
  pVerbose="$4"
  dbLocal="$out/conf/db_local.db"
  cmdPy="$PYTHON $HUB/src/conf/insert_setting.py"
  $cmdPy "$dbLocal"  "$pSection" "$pKey" "$pValue"
  if [ "$pVerbose" == "-v" ]; then
    echo "$pKey = $pValue"
  fi
}


## write Component row to COMPONENTS config table
writeCompRow() {
  pComp="$1"
  pProj="$2"
  pVer="$3"
  pPlat="$4"
  pPort="$5"
  pStatus="$6"
  pStageDir="$7"

  if [ ! "$pStageDir" == "nil" ]; then
    echo "#"
  fi

  if [ "$pStatus" == "NotInstalled" ] && [ "$isENABLED" == "true" ]; then
    pStatus="Enabled"
  fi

  if [ ! "$pStatus" == "Enabled" ]; then
    return
  fi

  dbLocal="$out/conf/db_local.db"
  cmdPy="$PYTHON $HUB/src/conf/insert_component.py"
  $cmdPy "$dbLocal"  "$pComp" "$pProj" "$pVer" "$pPlat" "$pPort" "$pStatus"
}


initDir () {
  pComponent=$1
  pProject=$2
  pPreNum=$3
  pExt=$4
  pStageSubDir=$5
  pStatus="$6"
  pPort="$7"
  pParent="$8"

  if [ "$pStatus" == "" ]; then
    pStatus="NotInstalled"
  fi

  if [ "$pStatus" == "NotInstalled" ] && [ "$isENABLED" == "true" ]; then
    pStatus="Enabled"
  fi

  if [ "$pStatus" == "NotInstalled" ] && [ ! "$zipOut" == "off" ]; then
     if [ "$pExt" == "" ]; then
       fileNm=$OUT/$pComponent-$pPreNum.tar.bz2
     else
       fileNm=$OUT/$pComponent-$pPreNum-$pExt.tar.bz2
     fi
     if [ -f "$fileNm" ]; then
       return
     fi
  fi

  osName=`uname`
  if [ "$osName" == "Darwin" ]; then
    cpCmd="cp -r"
  else
    cpCmd="cp -Lr"
  fi

  writeCompRow "$pComponent" "$pProject" "$pPreNum" "$pExt" "$pPort" "$pStatus" "nil"

  if [ "$pExt" == "" ]; then
    pCompNum=$pPreNum
  else
    pCompNum=$pPreNum-$pExt
  fi

  if [ "$pParent" == "Y" ]; then
    myOrigDir=$pComponent
  else
    myOrigDir=$pComponent-$pCompNum
  fi
  myOrigFile=$myOrigDir.tar.bz2

  if [ "$pStageSubDir" == "nil" ]; then
    thisDir=$IN
  else
    thisDir=$IN/$pStageSubDir
  fi
 
  if [ ! -d "$thisDir/$myOrigDir" ]; then
    origFile=$thisDir/$myOrigFile
    if [ -f $origFile ]; then
      checkCmd "tar -xf $origFile"      
      ## pbzip2 -dc $origFile | tar x
      rc=`echo $?`
      if [ $rc -ne 0 ]; then
        fatalError "can't unzip"
      fi
    else
      fatalError "Missing input file: $origFile"
    fi
  fi

  myNewDir=$pComponent
  if [ "$pParent" == "nil" ]; then
     mv $myOrigDir $myNewDir
  fi

  if [ -d "$SRC/$pComponent" ]; then
    $cpCmd $SRC/$pComponent/*  $myNewDir/.
  fi

  copy-pgXX "orafce"
  copy-pgXX "fixeddecimal"
  copy-pgXX "spock"
  copy-pgXX "pglogical"
  copy-pgXX "timescaledb"
  copy-pgXX "anon"
  copy-pgXX "cassandrafdw"
  copy-pgXX "hivefdw"
  copy-pgXX "plprofiler"
  copy-pgXX "pldebugger"
  copy-pgXX "pgtsql"
  copy-pgXX "hypopg"
  copy-pgXX "partman"
  copy-pgXX "proctab"
  copy-pgXX "repack"
  copy-pgXX "bulkload"
  copy-pgXX "audit"   
  copy-pgXX "postgis"   
  copy-pgXX "mysqlfdw"  
  copy-pgXX "pgredis"  
  copy-pgXX "kubernetes" 
  copy-pgXX "apicurio"
  copy-pgXX "mongofdw"  
  copy-pgXX "wal2json"  
  copy-pgXX "decoderbufs"  
  copy-pgXX "oraclefdw"  
  copy-pgXX "tdsfdw"  
  copy-pgXX "cron"
  copy-pgXX "citus"
  copy-pgXX "background"
  copy-pgXX "multicorn2"
  copy-pgXX "esfdw"
  copy-pgXX "bqfdw"
  copy-pgXX "pljava"
  copy-pgXX "plv8"
  copy-pgXX "hintplan"
  copy-pgXX "autofailover"

  ## POWA #######################
  ## copy-pgXX "wa"
  ## copy-pgXX "archivist"
  ## copy-pgXX "qualstats"
  ## copy-pgXX "statkcache"
  ## copy-pgXX "waitsampling"

  if [ -f $myNewDir/LICENSE.TXT ]; then
    mv $myNewDir/LICENSE.TXT $myNewDir/$pComponent-LICENSE.TXT
  fi

  if [ -f $myNewDir/src.tar.gz ]; then
    mv $myNewDir/src.tar.gz $myNewDir/$pComponent-src.tar.gz
  fi

  ##rm -f $myNewDir/*INSTALL*
  rm -f $myNewDir/logs/*

  rm -rf $myNewDir/manual

  rm -rf $myNewdir/build*
  rm -rf $myNewDir/.git*
}


copy-pgXX () {
  if [ "$pComponent" == "$1-pg$pgM" ]; then
    checkCmd "cp -r $SRC/$1-pgXX/* $myNewDir/."

    checkCmd "mv $myNewDir/install-$1-pgXX.py $myNewDir/install-$1-pg$pgM.py"
    myReplace "pgXX" "pg$pgM" "$myNewDir/install-$1-pg$pgM.py"

    if [ -f $myNewDir/remove-$1-pgXX.py ]; then
      checkCmd "mv $myNewDir/remove-$1-pgXX.py $myNewDir/remove-$1-pg$pgM.py"
      myReplace "pgXX" "pg$pgM" "$myNewDir/remove-$1-pg$pgM.py"
    fi
  fi
}


zipDir () {
  pComponent="$1"
  pNum="$2"
  pPlat="$3"
  pStatus="$4"

  if [ "$zipOut" == "off" ]; then
    return
  fi

  if [ "$pPlat" == "" ]; then
    baseName=$pComponent-$pNum
  else
    baseName=$pComponent-$pNum-$pPlat
  fi
  myTarball=$baseName.tar.bz2
  myChecksum=$myTarball.sha512

  if [ ! -f "$OUT/$myTarball" ] && [ ! -f "$OUT/$myChecksum" ]; then
    echo "COMPONENT = '$baseName' '$pStatus'"
    options=""
    if [ "$osName" == "Linux" ]; then
      options="--owner=0 --group=0"
    fi
    checkCmd "tar $options -cjf $myTarball $pComponent"
    writeFileChecksum $myTarball
  fi

  if [ "$pStatus"  == "NotInstalled" ]; then
    rm -rf $pComponent
  fi
}


## move file to output directory and write a checksum file with it
writeFileChecksum () {
  pFile=$1
  sha512=`openssl dgst -sha512 $pFile | awk '{print $2}'`
  checkCmd "mv $pFile $OUT/."
  echo "$sha512  $pFile" > $OUT/$pFile.sha512
}


finalizeOutput () {
  writeCompRow "hub"  "hub" "$hubV" "" "0" "Enabled" "nil"
  checkCmd "cp -r $SRC/hub ."
  checkCmd "mkdir -p hub/scripts"
  checkCmd "cp -r $CLI/* hub/scripts/."
  checkCmd "cp -r $CLI/../doc hub/."
  checkCmd "cp $CLI/../README.md  hub/doc/."
  checkCmd "rm -f hub/scripts/*.pyc"
  zipDir "hub" "$hubV" "" "Enabled"

  checkCmd "cp conf/$verSQL ."
  writeFileChecksum "$verSQL"

  checkCmd "cd $HUB"

  if [ ! "$zipOut" == "off" ] &&  [ ! "$zipOut" == "" ]; then
    zipExtension="tar.bz2"
    options=""
    if [ "$osName" == "Linux" ]; then
      options="--owner=0 --group=0"
    fi
    zipCommand="tar $options -cjf"
    zipCompressProg=""

    zipOutFile="$zipOut-$NUM-$plat.$zipExtension"
    if [ "$plat" == "posix" ]; then
      zipOutFile="$zipOut-$NUM.$zipExtension"
    fi

    if [ "$platx" == "posix" ]; then
      if [ ! -f $OUT/$zipOutFile ]; then
        echo "OUTFILE = '$zipOutFile'"
        checkCmd "cd out"
        checkCmd "mv $outDir $bundle"
        outDir=$bundle
        checkCmd "$zipCommand $zipOutFile $zipCompressProg $outDir"
        writeFileChecksum "$zipOutFile"
        checkCmd "cd .."
      fi
    fi
  fi
}


copyReplaceScript() {
  script=$1
  comp=$2
  checkCmd "cp $pgXX/$script-pgXX.py  $newDir/$script-$comp.py"
  myReplace "pgXX" "$comp" "$comp/$script-$comp.py"
}


supplementalPG () {
  newDir=$1
  pgXX=$SRC/pgXX

  checkCmd "mkdir $newDir/init"

  copyReplaceScript "install"  "$newDir"
  copyReplaceScript "start"    "$newDir"
  copyReplaceScript "stop"     "$newDir"
  copyReplaceScript "init"     "$newDir"
  copyReplaceScript "config"   "$newDir"
  copyReplaceScript "reload"   "$newDir"
  copyReplaceScript "activity" "$newDir"
  copyReplaceScript "remove"   "$newDir"

  checkCmd "cp $pgXX/run-pgctl.py $newDir/"
  myReplace "pgXX" "$comp" "$newDir/run-pgctl.py"

  checkCmd "cp $pgXX/pg_hba.conf.nix      $newDir/init/pg_hba.conf"

  checkCmd "chmod 755 $newDir/bin/*"
  chmod 755 $newDir/lib/* 2>/dev/null
}


initC () {
  status="$6"
  if [ "$status" == "" ]; then
    status="NotInstalled"
  fi
  initDir "$1" "$2" "$3" "$4" "$5" "$status" "$7" "$8"
  zipDir "$1" "$3" "$4" "$status"
}


initPG () {
  IVORY=False
  if [ "$pgM" == "11" ]; then
    pgV=$P11
  elif [ "$pgM" == "12" ]; then
    pgV=$P12
  elif [ "$pgM" == "13" ]; then
    pgV=$P13
  elif [ "$pgM" == "14" ]; then
    pgV=$P14
  elif [ "$pgM" == "15" ]; then
    pgV=$P15
  elif [ "$pgM" == "i14" ]; then
    pgV=$I14
    IVORY=True
    pgM=14
  else
    echo "ERROR: Invalid PG version '$pgM'"
    exit 1
  fi

  if [ "$outDir" == "a64" ]; then
    outPlat="arm"
  elif [ "$outDir" == "m64" ]; then
    outPlat="osx"
  else
    if [ "$isEL8" == "True" ]; then
      outPlat="el8"
    else
      outPlat="amd"
    fi
  fi

  if [ "$IVORY" == "True" ]; then
    pgComp="ivory$pgM"
  else
    pgComp="pg$pgM"
  fi
  initDir "$pgComp" "pg" "$pgV" "$outPlat" "postgres/$pgComp" "Enabled" "5432" "nil"
  supplementalPG "$pgComp"
  zipDir "$pgComp" "$pgV" "$outPlat" "Enabled"

  writeSettRow "GLOBAL" "STAGE" "prod"
  writeSettRow "GLOBAL" "AUTOSTART" "off"


  if [ "$IVORY" == "True" ] || [ "$outPlat" == "osx" ]; then
    return
  fi

  if [ "$pgM" == "15" ] && [  "$isEL8" == "True" ]; then
    initC "multicorn2-pg$pgM" "multicorn2" "$multicorn2V" "$outPlat" "postgres/multicorn2" "" "" "nil"
    initC "esfdw-pg$pgM" "esfdw" "$esfdwV" "$outPlat" "postgres/esfdw" "" "" "Y"
    initC "citus-pg$pgM" "citus" "$citusV" "$outPlat" "postgres/citus" "" "" "nil"
    initC "postgis-pg$pgM" "postgis" "$postgisV" "$outPlat" "postgres/postgis" "" "" "nil"
    initC "spock-pg$pgM" "spock" "$spockV" "$outPlat" "postgres/spock" "" "" "nil"
    initC "anon-pg$pgM" "anon" "$anonV" "$outPlat" "postgres/anon" "" "" "nil"
    initC "autofailover-pg$pgM" "autofailover" "$afoV" "$outPlat" "postgres/autofailover" "" "" "nil"
    initC "plprofiler-pg$pgM" "plprofiler" "$profV" "$outPlat" "postgres/profiler" "" "" "nil"
  fi

  if [ "$pgM" == "14" ] && [  "$isEL8" == "True" ]; then
    initC "background-pg$pgM" "background" "$bckgrndV" "$outPlat" "postgres/background" "" "" "nil"
    initC "citus-pg$pgM" "citus" "$citusV" "$outPlat" "postgres/citus" "" "" "nil"
    initC "timescaledb-pg$pgM" "timescaledb" "$timescaleV"  "$outPlat" "postgres/timescale" "" "" "nil"
    initC "spock-pg$pgM" "spock" "$spockV" "$outPlat" "postgres/spock" "" "" "nil"
    initC "cron-pg$pgM" "cron" "$cronV" "$outPlat" "postgres/cron" "" "" "nil"
    initC "postgis-pg$pgM" "postgis" "$postgisV" "$outPlat" "postgres/postgis" "" "" "nil"
    initC "mysqlfdw-pg$pgM" "mysqlfdw" "$mysqlfdwV" "$outPlat" "postgres/mysqlfdw" "" "" "nil"
    initC "orafce-pg$pgM" "orafce" "$orafceV" "$outPlat" "postgres/orafce" "" "" "nil"
    initC "autofailover-pg$pgM" "autofailover" "$afoV" "$outPlat" "postgres/autofailover" "" "" "nil"

    initC "partman-pg$pgM" "partman" "$partmanV" "$outPlat" "postgres/partman" "" "" "nil"
    initC "orafce-pg$pgM" "orafce" "$orafceV" "$outPlat" "postgres/orafce" "" "" "nil"
    initC "audit-pg$pgM" "audit" "$audit16V" "$outPlat" "postgres/audit" "" "" "nil"
    initC "hintplan-pg$pgM" "hintplan" "$hintV" "$outPlat" "postgres/hintplan" "" "" "nil"
    initC "decoderbufs-pg$pgM" "decoderbufs" "$decbufsV" "$outPlat" "postgres/decoderbufs" "" "" "nil"
    initC "bulkload-pg$pgM" "bulkload" "$bulkloadV" "$outPlat" "postgres/bulkload" "" "" "nil"
    initC "pglogical-pg$pgM" "pglogical" "$logicalV" "$outPlat" "postgres/logical" "" "" "nil"
    initC "repack-pg$pgM" "repack" "$repackV" "$outPlat" "postgres/repack" "" "" "nil"
    initC "hypopg-pg$pgM" "hypopg" "$hypoV" "$outPlat" "postgres/hypopg" "" "" "nil"
    initC "cron-pg$pgM" "cron" "$cronV" "$outPlat" "postgres/cron" "" "" "nil"
    initC "plprofiler-pg$pgM" "plprofiler" "$profV" "$outPlat" "postgres/profiler" "" "" "nil"
    initC "pldebugger-pg$pgM" "pldebugger" "$debuggerV" "$outPlat" "postgres/pldebugger" "" "" "nil"
    initC "multicorn2-pg$pgM" "multicorn2" "$multicorn2V" "$outPlat" "postgres/multicorn2" "" "" "nil"
    initC "esfdw-pg$pgM" "esfdw" "$esfdwV" "$outPlat" "postgres/esfdw" "" "" "Y"
    initC "anon-pg$pgM" "anon" "$anonV" "$outPlat" "postgres/anon" "" "" "nil"

    if [ "$outPlat" == "el8" ]; then
      initC "plv8-pg$pgM" "plv8" "$v8V" "$outPlat" "postgres/plv8" "" "" "nil"

      initC "oraclefdw-pg$pgM" "oraclefdw" "$oraclefdwV" "$outPlat" "postgres/oraclefdw" "" "" "nil"
      initC "mongofdw-pg$pgM" "mongofdw" "$mongofdwV" "$outPlat" "postgres/mongofdw" "" "" "nil"

    fi

  fi

  initC "pge14"    "pge14"    "$pgeV"     ""  "pge"              "" "" "Y"
  #initC "nodejs"   "nodejs"   "$nodejsV" "" "nodejs"           "" "" "Y"
  #initC "pgrest"   "pgrest"   "$pgrestV"  ""  "postgres/pgrest"  "" "" "Y"
  initC  "prompgexp"  "prompgexp"  "$prompgexpV"  ""  "prometheus/pg_exporter"  "" "" "Y"

  ##if [ "$isEL8" == "True" ]; then
  return
  ##fi
  

  ##if [ "$pgM" == "14" ]; then 
  ##  initC "bqfdw-pg$pgM" "bqfdw" "$bqfdwV" "$outPlat" "postgres/bqfdw" "" "" "Y"

  ##  initC "postgis-pg$pgM" "postgis" "$postgisV" "$outPlat" "postgres/postgis" "" "" "nil"
  ##  initC "wal2json-pg$pgM" "wal2json" "$w2jV" "$outPlat" "postgres/wal2json" "" "" "nil"


  ##  initC "oraclefdw-pg$pgM" "oraclefdw" "$oraclefdwV" "$outPlat" "postgres/oraclefdw" "" "" "nil"
  ##  initC "mysqlfdw-pg$pgM" "mysqlfdw" "$mysqlfdwV" "$outPlat" "postgres/mysqlfdw" "" "" "nil"
  ##  initC "mongofdw-pg$pgM" "mongofdw" "$mongofdwV" "$outPlat" "postgres/mongofdw" "" "" "nil"

  ##  initC "plv8-pg$pgM" "plv8" "$v8V" "$outPlat" "postgres/plv8" "" "" "nil"

    #initC "fixeddecimal-pg$pgM" "fixeddecimal" "$fdV" "$outPlat" "postgres/fixeddecimal" "" "" "nil"
    #initC "psqlodbc" "psqlodbc" "$odbcV" "$outPlat" "postgres/psqlodbc" "" "" "nil"
    #if [ "$outPlat" == "amd" ]; then
    #  initC "pljava-pg$pgM" "pljava" "$pljavaV" "$outPlat" "postgres/pljava" "" "" "nil"
    #  initC "tdsfdw-pg$pgM" "tdsfdw" "$tdsfdwV" "$outPlat" "postgres/tdsfdw" "" "" "nil"
    #fi
    #initC "hivefdw-pg$pgM" "hivefdw" "$hivefdwV" "$outPlat" "postgres/hivefdw" "" "" "nil"
    #initC "ddlx-pg$pgM" "ddlx" "$ddlxV" "$outPlat" "postgres/ddlx" "" "" "nil"
    #initC "wa-pg$pgM" "wa" "$waV" "$outPlat" "postgres/wa" "" "" "nil"
    #initC "archivist-pg$pgM" "archivist" "$archiV" "$outPlat" "postgres/archivist" "" "" "nil"
    #initC "qualstats-pg$pgM" "qualstats" "$qstatV" "$outPlat" "postgres/qualstats" "" "" "nil"
    #initC "statkcache-pg$pgM" "statkcache" "$statkV" "$outPlat" "postgres/statkcache" "" "" "nil"
    #initC "waitsampling-pg$pgM" "waitsampling" "$waitsV" "$outPlat" "postgres/waitsampling" "" "" "nil"
    #if [ "$outPlat" == "amd" ]; then
    #  initC "cassandrafdw-pg$pgM" "cassandrafdw" "$cstarfdwV" "$outPlat" "postgres/cassandrafdw" "" "" "nil"
    #  initC "pgtop-pg$pgM" "pgtop" "$pgtopV" "$outPlat" "postgres/pgtop" "" "" "nil"
    #  initC "proctab-pg$pgM" "proctab" "$proctabV" "$outPlat" "postgres/proctab" "" "" "nil"
    #fi

    #initC "cassandra" "cassandra" "$cstarV" "" "cassandra" "" "" "nil"

    ##initC "timescaledb-pg$pgM" "timescaledb" "$timescaleV"  "$outPlat" "postgres/timescale" "" "" "nil"
    ##initC "citus-pg$pgM" "citus" "$citusV" "$outPlat" "postgres/citus" "" "" "nil"
 ## fi

  initC "instantclient" "instantclient" "$inclV" "" "oracle/instantclient" "" "" "Y"
  initC "walg" "walg" "$walgV" "$outPlat" "postgres/walg" "" "" "Y"
  initC "golang" "golang" "$goV" "$outPlat" "golang" "" "" "Y"
  initC "mariadb"   "mariadb"   "$mariaV" "" "mariadb"          "" "" "Y"
  ##initC "zookeeper" "zookeeper" "$zooV"   "" "zookeeper"        "" "" "Y"
  initC "kafka"     "kafka"     "$kfkV"   "" "kafka"            "" "" "Y"
  initC "apicurio"  "apicurio"  "$apicV"  "" "apicurio"         "" "" "nil"
  initC "debezium"  "debezium"  "$dbzV"   "" "debezium"         "" "" "Y"
  initC "kubernetes" "kubernetes" "$k8sV" "" "kubernetes"       "" "" "Y"
  initC "pgadmin"   "pgadmin"   "$adminV" "" "postgres/pgadmin" "" "" "Y"
  initC "omnidb"    "omnidb"    "$omniV"  "" "postgres/omnidb"  "" "" "Y"
  initC "sqlsvr"    "sqlsvr"    "$sqlsvrV" "" "sqlsvr"          "" "" "Y"
  initC "mongodb"   "mongodb"   "$mongoV"  "" "mongodb"         "" "" "Y"

  initC "ora2pg"    "ora2pg"    "$ora2pgV" "" "postgres/ora2pg" "" "" "Y"
  #initC "patroni"   "patroni"   "$patroniV" "" "postgres/patroni" "" "" "nil"

}


setupOutdir () {
  rm -rf out
  mkdir out
  cd out
  mkdir $outDir
  cd $outDir
  out="$PWD"
  mkdir conf
  mkdir conf/cache
  conf="$SRC/conf"

  cp $conf/db_local.db  conf/.
  cp $conf/versions.sql  conf/.
  sqlite3 conf/db_local.db < conf/versions.sql
}


###############################    MAINLINE   #########################################
osName=`uname`
verSQL="versions.sql"
grep el8 /etc/os-release > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  isEL8="True"
else
  isEL8="False"
fi
##echo "isEL8=$isEL8"


## process command line paramaters #######
while getopts "c:X:N:Ep:Rh" opt
do
    case "$opt" in
      X)  if [ "$OPTARG" == "l64" ] || [ "$OPTARG" == "posix" ] ||
	     [ "$OPTARG" == "a64" ] || [ "$OPTARG" == "m64" ]; then
            outDir="$OPTARG"
            setupOutdir
            OS_TYPE="POSIX"
            cp $CLI/cli.sh ./$api
            if [ "$outDir" == "posix" ]; then
              OS="???"
              platx="posix"
              plat="posix"
            elif [ "$outDir" == "posix" ]; then
              OS="OSX"
              platx=osx64
            else
              OS="LINUX"
              platx=$plat
            fi
          else
            fatalError "Invalid Platform (-X) option" "u"
          fi
          writeSettRow "GLOBAL" "PLATFORM" "$plat"
          if [ "$plat" == "posix" ]; then
            checkCmd "cp $CLI/install.py $OUT/."
          fi;;

      R)  writeSettRow "GLOBAL" "REPO" "$repo" "-v";;

      c)  zipOut="$OPTARG";;

      N)  NUM="$OPTARG";;

      E)  isENABLED=true;;

      p)  pgM="$OPTARG"
          checkCmd "initPG";;

      h)  printUsageMessage
          exit 1;;
    esac
done

if [ $# -lt 1 ]; then
  printUsageMessage
  exit 1
fi

finalizeOutput

exit 0
