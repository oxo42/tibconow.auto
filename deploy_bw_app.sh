#!/bin/bash

TIBCO_HOME=/opt/tibco
BW_HOME=$TIBCO_HOME/bw/6.3

domain=$1
appspace=$2
application=$3
ear=$4
version=$5
profile=$6

mkdir -p $HOME/$application

cd $HOME/$application

# Check EAR exists
if [ ! -f $ear ] ; then
	echo "EAR $ear not found"
	exit 1
fi

source $BW_HOME/scripts/bashrc.sh

script=$(mktemp)
echo "stop -d $domain appspace $appspace" >> $script
echo "upload -domain $domain -replace $ear" >> $script
echo "deploy -domain $domain -appspace $appspace -p $profile -replace $ear" >> $script
echo "start -domain $domain appspace $appspace" >> $script
echo "start -d $domain -a $appspace application $application $version" >> $script

echo "Deployment script"
echo "------------------------"
cat $script
echo "------------------------"
bwadmin -f $script
rm $script
