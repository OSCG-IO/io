cd sources
cmd="aws --region $REGION s3 sync s3://pgsql-io-download/IN/sources . $1 $2"
echo $cmd
sleep 3

$cmd
rc=$?

echo "rc($rc)"
exit $rc
