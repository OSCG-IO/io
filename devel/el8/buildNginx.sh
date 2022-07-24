
ver=$1
ver=1.22.0

##PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.44.tar.gz
tar -xf pcre-8.44.tar.gz
cd pcre-8.44
./configure
make
sudo make install

##ZLIB – Supports header compression. Required by the NGINX Gzip module.
wget http://zlib.net/zlib-1.2.11.tar.gz
tar -xf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make
sudo make install

##OPENSSL – Supports the HTTPS protocol. Required by the NGINX SSL module and others.
wget http://www.openssl.org/source/openssl-1.1.1g.tar.gz
tar -xf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g
./Configure --prefix=/usr
make
sudo make install

##NGINX - Https Server & Reverse Proxy
dir=nginx-$ver
file=$dir.tar.gz
wget http://nginx.org/download/nginx-$ver.tar.gz 
tar -xf $file
cd $dir
./configure
make
make install
