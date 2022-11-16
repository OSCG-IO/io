
bundle=oscg
api=io
hubV=6.77

#I14=14.3-1

P15=15.1-2
P14=14.6-2
P13=13.9-1
P12=12.13-1
P11=11.18-1

walgV=2.0.0
goV=1.19.2
pgrestV=9.0.1
prompgexpV=0.11.1
autosshV=1.4g
nodejsV=18.6.0
bckgrndV=1.1-1
pgeV=15

multicorn2V=2.4-1
esfdwV=0.11.2
bqfdwV=1.9

w2jV=2.4-1
odbcV=13.01-1
citusV=11.1.4-1
hivefdwV=4.0-1

oraclefdwV=2.5.0-1
inclV=21.6
orafceV=3.25.1-1
ora2pgV=23.1
v8V=3.1.2-1

fdV=1.1.0-1
anonV=1.1.0-1
ddlxV=0.17-1
hypoV=1.3.1-1
timescaleV=2.8.0-1
logicalV=2.4.2-1
spockV=3.0.6-1
profV=4.2-1
bulkloadV=3.1.19-1
partmanV=4.7.1-1
repackV=1.4.8-1
hintV=1.4.0-1

afoV=1.6.4-1
odysseyV=1.3-1
bouncerV=1.17.0-1

waV=2.1-1
archiV=4.1.2-1
qstatV=2.0.3-1
statkV=2.2.0-1
waitsV=1.1.3-1

dbzV=1.8.1.Final
apicV=2.2.0
decbufsV=1.7.0-1

zooV=3.7.0
kfkV=3.1.0
redisV=6.2
mariaV=10.6
sqlsvrV=2019
mongoV=5.0
esV=7.x

adminV=5.5
omniV=2.17.0

audit14V=1.6.2-1
audit15V=1.7.0-1
postgisV=3.3.1-1

pljavaV=1.6.2-1
debuggerV=1.4-1
cronV=1.4.2-1

mysqlfdwV=2.8.0-1
mongofdwV=5.4.0-1
tdsfdwV=2.0.3-1
badgerV=11.6
patroniV=2.1.1

HUB="$PWD"
SRC="$HUB/src"
zipOut="off"
isENABLED=false

pg="postgres"

OS=`uname -s`
OS=${OS:0:7}

if [[ $OS == "Linux" ]]; then
  if [ `arch` == "aarch64" ]; then
    OS=arm
    outDir=a64
  else
    OS=amd;
    outDir=l64
  fi
  sudo="sudo"
elif [[ $OS == "Darwin" ]]; then
  outDir=m64
  if [ `arch` == "arm64" ]; then
    OS="osx-arm"
  else
    OS=osx;
  fi
  echo OS=$OS
  sudo="sudo"
elif [[ $OS = "MINGW64" ]]; then
  outDir=w64
  OS=win
  sudo=""
else
  echo "ERROR: '$OS' is not supported"
  return
fi

plat=$OS
