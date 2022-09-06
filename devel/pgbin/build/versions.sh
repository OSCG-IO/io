#!/bin/bash

ivory14V=14.3.1.3
ivory14BuildV=1

pg15V=15beta4
pg15BuildV=1

pg14V=14.5
pg14BuildV=1

pg13V=13.8
pg13BuildV=1

pg12V=12.12
pg12BuildV=1

pg11V=11.17
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

bckgrndFullV=1.1
bckgrndShortV=
bckgrndBuildV=1

pool2FullV=4.3.3
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

citusFullV=11.0.6
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

postgisFullV=3.3.0
postgisShortV=
postgisBuildV=1

prestoFullV=0.229
prestoShortV=
prestoBuildV=1

cassFullV=3.1.5
cassShortV=
cassBuildV=1

orafceFullV=3.24.4
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

mysqlfdwFullV=2.8.0
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

plProfilerFullVersion=4.1
plProfilerShortVersion=
plprofilerBuildV=1

plv8FullV=3.1.2
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

spockFullV=3.0beta1
spockShortV=
spockBuildV=1

pgLogicalFullV=2.4.1
pgLogicalShortV=
pgLogicalBuildV=1

repackFullV=1.4.7
repackShortV=
repackBuildV=1

partmanFullV=4.7.0
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

timescaledbFullV=2.8.0
timescaledbShortV=
timescaledbBuildV=1

cronFullV=1.4.2
cronShortV=
cronBuildV=1

isEL8=no
grep el8 /etc/os-release > /dev/null
rc=$?
if [ "$rc" == "0" ]; then
  isEL8=yes
fi

ARCH=`arch`
OS=`uname -s`
OS=${OS:0:7}
if [[ "$OS" == "Linux" ]]; then
  if [[ "$ARCH" == "aarch64" ]]; then
    OS=arm
  else
    if [[ "$isEL8" == "yes" ]]; then
      OS=el8
    else
      OS=amd
    fi
  fi
elif [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
      OS="osx-arm"
    else
      OS="osx"
    fi 
elif [[ $OS == "MINGW64" ]]; then
    OS=win
else
  echo "Think again. :-)"
  exit 1
fi

cpuCores=`egrep -c 'processor([[:space:]]+):.*' /proc/cpuinfo`
