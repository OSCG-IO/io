# OSCG IO Project

## Punch list items for development

1.) Whenever and INSTALL or UPGRADE command is run...  Automagically run UPDATE if it hasn't been run in last 24 hours.


## Create build environment on el7, el8 or OSX

### 1.) run ./setupInitial.sh to configure OS environment

### 2.) configure your ~/.aws/config credentials

### 3.) run ./setupBLD-IN.sh to pull in the IN directory from S3

### 4.) Setup Src builds for PGBIN from devel/pgbin/build
       in el7-only:
         + libSrcBuilds.sh
         + gisSrcBuilds.sh
         + buildBoost.sh
         + buildProtobuf.sh
         + buildProtobufc.sh

       + installOracleInstantClient.sh
       + installCppDriver.sh
       sharedLibs.sh
