# OSCG-IO for ~/.bash... ############################################################
alias git-push="cd ~/dev/io; git status; git add .; git commit -m wip; git push"
alias bp="cd ~/dev/io; . ./bp.sh"
alias ver="vi ~/dev/io/src/conf/versions.sql"

export REGION=us-west-2
export BUCKET=s3://oscg-io-download

export DEV=$HOME/dev
export IN=$DEV/in
export OUT=$DEV/out
export HIST=$DEV/history
export IO=$DEV/io
export SRC=$IN/sources
export BLD=/opt/pgbin-build/pgbin/bin

export HTML=$IO/web/static
export IMG=$HTML/html/img
export DEVEL=$IO/devel
export PG=$DEVEL/pg
export CLI=$IO/cli/scripts
export REPO=http://localhost:8000

export JAVA_HOME=/etc/alternatives/jre_11_openjdk

export PATH=/usr/local/bin:$JAVA_HOME/bin:$PATH

# for Centos 7 only
export PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rh/llvm-toolset-7/root/usr/bin:$PATH
