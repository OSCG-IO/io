cpdV=2.16.0
uvV=1.35.0

cat /etc/os-release | grep el8
rc=$?
if [ "$rc" == "0" ]; then
  elV=8
else
  elV=7
fi

rm -rf *.rpm*

url=https://downloads.datastax.com/cpp-driver/centos/$elV/dependencies/libuv
rpm=libuv-$uvV-1.el$elV.x86_64.rpm
wget $url/v$uvV/$rpm
sudo yum install -y $rpm

rpm=libuv-devel-$uvV-1.el$elV.x86_64.rpm
wget $url/v$uvV/$rpm
sudo yum install -y $rpm

cas=https://downloads.datastax.com/cpp-driver/centos/$elV/cassandra

rpm=cassandra-cpp-driver-$cpdV-1.el$elV.x86_64.rpm
wget $cas/v$cpdV/$rpm
sudo yum install -y $rpm


rpm=cassandra-cpp-driver-devel-$cpdV-1.el$elV.x86_64.rpm
wget $cas/v$cpdV/$rpm
sudo yum install -y $rpm

rm *.rpm

