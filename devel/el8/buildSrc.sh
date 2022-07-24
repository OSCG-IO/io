
buildSrc () {
  ver=$1
  dir=$2
  file=$3
  url=$4
  config=$5
  basedir=/opt/$6/$2

  echo " "
  echo "#################################################################"
  echo "# $BANNER"
  echo "#################################################################"
  echo "#     ver=$ver"
  echo "#     dir=$dir"
  echo "#     ver=$ver"
  echo "#     url=$url"
  echo "#  config=$config"
  echo "# basedir=$basedir"
  echo "#################################################################"

  if [ "$#" -ne 6 ]; then
    echo "ERROR: must be six parms"
    exit 1
  fi

  echo "#"
  echo "# cleaning up cruft ..."
  rm -rf $basedir
  mkdir -p $basedir
  cd $basedir
  rm -rf $dir*

  echo "#"
  echo "# downloading $url/$file ..."
  wget -q $url/$file

  echo "#"
  echo "# expanding $file ..."
  touch $file
  tar -xf $file

  cd $dir
  log="make-$dir.log"
  echo " configuring ... "
  $config > $log 2>&1

  echo " compiling ..."
  make -j4 >> $log 2>&1

  echo " installing..."
  sudo make install > makeinstall-$dir.log 2>&1
}

