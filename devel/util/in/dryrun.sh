

if [ ! "$1" == "prod" ]; then
  echo "invalid 1st parm"
  exit 1
fi

echo "push-s3 $1 dryrun..."
./push-s3.sh $1 --dryrun
echo "pull-s3 $1 dryrun..."
./pull-s3.sh $1 --dryrun
