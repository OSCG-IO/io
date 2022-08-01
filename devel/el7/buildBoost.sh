url=https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source
boost_dir=boost_1_75_0

rm -rf $boost_dir
boost_zip=$boost_dir.tar.gz
rm -f $boost_zip
wget $url/$boost_zip
tar xvf $boost_zip
rm $boost_zip

cd $boost_dir
./bootstrap.sh --with-libraries=atomic,chrono,system,thread,test
sudo ./b2 -j6 cxxflags="-fPIC" install
cd ..

sudo rm -rf $boost_dir

