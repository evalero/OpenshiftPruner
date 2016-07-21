#/bin/bash

#Include whiteList file from config

#Parameters for pruning builds and deployments
PRUNE_B_D_PARAMETERS="--orphans --keep-complete=5 --keep-failed=1 --keep-younger-than=60m --confirm"

#Parameters for pruning images
PRUNE_I_PARAMETERS=" --keep-tag-revisions=5 --keep-younger-than=60m --confirm"

# Config file of whitelist of images to be excluded to be erased
CONFIG_FILE="./imageWhitelist.out"

IMAGES_TO_SAVE=

#Pruning elements from etcd as seen in https://docs.openshift.com/enterprise/3.2/admin_guide/pruning_resources.html

#Starting with deployments
echo $(oadm prune deployments $PRUNE_B_D_PARAMETERS)

#Pruning builds
echo $(oadm prune builds $PRUNE_B_D_PARAMETERS)

#And finally images
echo $(oadm prune images $PRUNE_I_PARAMETERS)

#at last, we remove all docker containers that are not running and images that are not attached to any container excluding the whitelist images
docker rm $(docker ps -qa); docker rmi $(docker images | grep -vf "$CONFIG_FILE" | grep -v "IMAGE" | awk '{print $3'})
