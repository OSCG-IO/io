
buildSrc () {
  ver=$1
  dir=$2
  file=$3
  url=$4
  config="./configure"
  if [[ ! "$5" == "" ]]; then
    config="$5"
  fi

  rm -rf $dir*

  echo " "
  echo "#################################################################"
  echo "# $BANNER"

  echo " downloading $url/$file"
  wget -q $url/$file

  echo " expanding $file"
  touch $file
  tar -xf $file

  cd $dir
  log="make-$dir.log"
  echo " configuring... "
  $config > $log 2>&1

  echo " compiling..."
  make -j4 >> $log 2>&1

  echo " installing..."
  sudo make install > makeinstall-$dir.log 2>&1
}



BANNER="PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules."
v=8.45
d=pcre-$v
f=$d.tar.gz
u=https://sourceforge.net/projects/pcre/files/pcre/$v
buildSrc $v $d $f $u 

BANNER="ZLIB – Supports header compression. Required by the NGINX Gzip module."
v=1.2.12
d=zlib-$v
f=$d.tar.gz
u=http://zlib.net
buildSrc $v $d $f $u

BANNER="OPENSSL – Supports the HTTPS protocol. Required by the NGINX SSL module and others."
v=1.1.1q
d=openssl-$v
f=$d.tar.gz
u=http://www.openssl.org/source
buildSrc $v $d $f $u "./config"

exit

