# OSCG IO Project


## Create build environment on el7 or el8

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
       sharedLibs.sh
