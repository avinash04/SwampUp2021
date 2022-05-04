#!/usr/bin/env sh

#################
# init process #
#################

#!/usr/bin/env sh

#################
# init process #
#################

cd ../maven-example

echo -n "Configuration name for CLI (unique name) : "
read -r CLIName
export CLI_NAME=${CLIName}

jf config use $CLI_NAME

echo -n "Jfrog is accessible check : "
jf rt ping

#Config Maven

jf mvnc --repo-resolve-snapshots su201-libs-snapshot --repo-resolve-releases su201-libs-release --repo-deploy-snapshots su201-libs-snapshot --repo-deploy-releases su201-libs-release

RANDOM=$$
export BUILD_NUMBER=${RANDOM}

#Run Maven Build

jf mvn clean install -Dartifactory.publish.artifacts=true --build-name=swampup_s003_mvn_pipeline --build-number=$BUILD_NUMBER

#Collect Environment Variables

jf rt bce swampup_s003_mvn_pipeline $BUILD_NUMBER

#Publish Build Info

jf rt bp swampup_s003_mvn_pipeline $BUILD_NUMBER

echo "START : Xray Scan"
jf bs swampup_s003_mvn_pipeline $BUILD_NUMBER
echo "COMPLETE : Xray Scan"