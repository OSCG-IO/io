sudo yum -y install libmpc-devel
rm -rf gcc*
GCC_VERSION=10.2.0
wget http://gnu.mirror.constant.com/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
tar zxf gcc-$GCC_VERSION.tar.gz
mkdir gcc-build
cd gcc-build
../gcc-$GCC_VERSION/configure --enable-languages=c,c++ --disable-multilib
make -j`nproc`
sudo make install
