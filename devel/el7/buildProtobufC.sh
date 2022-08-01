
ver=1.2.1

url=https://github.com/protobuf-c/protobuf-c/releases/download/v$ver
dir=protobuf-c-$ver 
gz=$dir.tar.gz

rm -rf $dir
rm -f $gz
wget $url/$gz
tar xvf $gz
rm $gz

cd $dir

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

./configure
make -j 4
sudo make install
cd ..

sudo rm -rf $dir

