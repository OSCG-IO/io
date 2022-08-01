
## pg built using --with-libgss
cd ~
VER=1.0.3
wget ftp://ftp.gnu.org/gnu/gss/gss-$VER.tar.gz
tar -xvf gss-$VER.tar.gz
cd gss-$VER
./configure
make -j6
sudo make install

# recent CMAKE needed for timescaledb
cd ~
VE=3.19
VER=$VE.8
wget https://cmake.org/files/v$VE/cmake-$VER.tar.gz
tar -xvzf cmake-$VER.tar.gz
cd cmake-$VER
./bootstrap
make -j6
sudo make install

# recent Maven needed for PL/Java Builds
cd ~
VER=3.8.4
wget https://downloads.apache.org/maven/maven-3/$VER/binaries/apache-maven-$VER-bin.tar.gz
tar -xvzf apache-maven-$VER-bin.tar.gz

# recent ANT for BenchmarkSQL Builds
cd ~
VER=1.10.12
wget https://dlcdn.apache.org//ant/binaries/apache-ant-$VER-bin.tar.gz
tar -xvzf apache-ant-$VER-bin.tar.gz


