set -e
echo "##NGINX - Https Server & Reverse Proxy"
ver=1.22.0
dir=nginx-$ver
file=$dir.tar.gz

rm -rf $dir*
wget http://nginx.org/download/nginx-$ver.tar.gz 
tar -xf $file
cd $dir
lib=/usr/local/lib64
prefix=$DEVEL/build/$dir
rm -rf $prefix
mkdir -p $prefix
./configure --prefix=$prefix --with-openssl=$lib
make
make install
cd ..
rm -r $dir*
