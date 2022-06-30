#!/bin/bash

ivory14V=14.3.1.3
ivory14BuildV=1

pg15V=15beta2
pg15BuildV=1

pg14V=14.4
pg14BuildV=1

pg13V=13.7
pg13BuildV=1

pg12V=12.11
pg12BuildV=1

pg11V=11.16
pg11BuildV=1

decoderbufsFullV=1.7.0
decoderbufsShortV=
decoderbufsBuildV=1

wal2jsonFullV=2.4
wal2jsonShortV=
wal2jsonBuildV=1

odbcFullV=13.01
odbcShortV=
odbcBuildV=1

backrestFullV=2.38
backrestShortV=
backrestBuildV=1

pool2FullV=4.3.2
pool2ShortV=
pool2BuildV=1

bouncerFullV=1.17.0
bouncerShortV=
bouncerBuildV=3

multicorn2FullV=2.3
multicorn2ShortV=
multicorn2BuildV=1

agentFullV=4.0.0
agentShortV=
agentBuildV=1

citusFullV=11.0.2
citusShortV=
citusBuildV=1

pgtopFullV=3.7.0
pgtopShortV=
pgtopBuildV=1

proctabFullV=0.0.8.1
proctabShortV=
proctabBuildV=1

httpFullV=1.3.1
httpShortV=
httpBuildV=1

hypopgFullV=1.3.1
hypopgShortV=
hypopgBuildV=1

postgisFullV=3.2.1
postgisShortV=
postgisBuildV=1

backgroundFullVersion=1.0
backgroundShortVersion=1
backgroundBuildV=1

prestoFullV=0.229
prestoShortV=
prestoBuildV=1

cassFullV=3.1.5
cassShortV=
cassBuildV=1

orafceFullV=3.21.0
orafceShortV=
orafceBuildV=1

fdFullV=1.1.0-1
fdShortV=
fdBuildV=1

oraclefdwFullV=2.4.0
oraclefdwShortV=
oraclefdwBuildV=1

tdsfdwFullV=2.0.2
tdsfdwShortV=
tdsfdwBuildV=1

mysqlfdwFullV=2.7.0
mysqlfdwShortV=
mysqlfdwBuildV=1

pgredisFullV=2.0
pgredisShortV=
pgredisBuildV=1

hivefdwFullV=4.0
hivefdwShortV=
hivefdwBuildV=1

mongofdwFullV=5.4.0
mongofdwShortV=
mongofdwBuildV=1

pgmpFullVersion=1.2.2
pgmpShortVersion=
pgmpBuildV=1

parquetFullV=0.1
parquetShortV=
parquetBuildV=1

cstoreFDWFullVersion=1.6.2
cstoreFDWShortVersion=
cstoreFDWBuildV=1

plProfilerFullVersion=4.1
plProfilerShortVersion=
plprofilerBuildV=1

plv8FullV=2.3.15
plv8ShortV=
plv8BuildV=1

debugFullV=1.4
debugShortV=
debugBuildV=1

fdFullV=1.1.0
fdShortV=
fdBuildV=1

anonFullV=1.0.0
anonShortV=
anonBuildV=1

ddlxFullV=0.17
ddlxShortV=
ddlxBuildV=1

auditFull14V=1.6.2
auditShortV=
auditBuildV=1

setUserFullVersion=1.6.2
setUserShortVersion=
setUserBuildV=1

pljavaFullV=1.6.2
pljavaShortV=
pljavaBuildV=1

plRFullVersion=8.3.0.17
plRShortVersion=83
plRBuildV=1

pgTSQLFullV=3.0
pgTSQLShortV=
pgTSQLBuildV=1

bulkloadFullV=3.1.19
bulkloadShortV=
bulkloadBuildV=1

spockFullV=2.4.1
spockShortV=
spockBuildV=1

pgLogicalFullV=2.4.1
pgLogicalShortV=
pgLogicalBuildV=1

repackFullV=1.4.7
repackShortV=
repackBuildV=1

partmanFullV=4.6.1
partmanShortV=
partmanBuildV=1

archivFullV=4.1.2
archivShortV=
archivBuildV=1

statkFullV=2.2.0
statkShortV=
statkBuildV=1

qstatFullV=2.0.3
qstatShortV=
qstatBuildV=1

waitsFullV=1.1.3
waitsShortV=
waitsBuildV=1

hintplanFullV=1.4.0
hintplanShortV=
hintplanBuildV=1

timescaledbFullV=2.7.0
timescaledbShortV=
timescaledbBuildV=1

cronFullV=1.4.1
cronShortV=
cronBuildV=1

isEL8=no
grep el8 /etc/os-release > /dev/null
rc=$?
if [ "$rc" == "0" ]; then
  isEL8=yes
fi

OS=`uname -s`
OS=${OS:0:7}
if [[ $OS == "Linux" ]]; then
  grep "CPU architecture: 8" /proc/cpuinfo 1>/dev/null
  rc=$?
  if [ "$rc" == "0" ]; then
    OS=arm
  else
    OS=amd
  fi
elif [[ $OS == "Darwin" ]]; then
    OS=osx
elif [[ $OS == "MINGW64" ]]; then
    OS=win
else
  echo "Think again. :-)"
  exit 1
fi

if [[ "$isEL8" == "yes" ]]; then
  OS=el8
fi

cpuCores=`egrep -c 'processor([[:space:]]+):.*' /proc/cpuinfo`
