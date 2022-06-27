
if [ ! "$1" == "prod" ]; then
  echo "invalid 1st parm"
  exit 1
fi

cmd="aws --region $REGION s3 sync $BUCKET/IN . $2 $3"
echo $cmd
sleep 3

$cmd
rc=$?

echo "rc($rc)"
exit $rc
