ver=2.6.1

rm -f v$ver.tar.gz*

wget https://github.com/protocolbuffers/protobuf/archive/refs/tags/v$ver.tar.gz
dir=protobuf-$ver
rm -f $dir

tar -xvf v$ver.tar.gz

rm -f release-1.5.0.tar.gz
wget  https://github.com/google/googletest/archive/refs/tags/release-1.5.0.tar.gz
rm -rf googletest-release-1.5.0
tar -xvf release-1.5.0.tar.gz
mv googletest-release-1.5.0 $dir/gtest

cd $dir

./autogen.sh
./configure
#make check
make clean
make -j6
sudo make install
sudo ldconfig # refresh shared library cache.

cd ..
rm  -rf $dir
rm  -f release-1.5.0.tar.gz
rm  -f v$ver.tar.gz
