#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

CHANNEL_NAME=$1

function networkUp () {
    if [ -d "./crypto-config" ]; then
      echo "crypto-config directory already exists."
    else
	  #初始化证书结      
	  source /opt/e2e/generateArtifacts.sh $CHANNEL_NAME
    fi
	#启动实例，构建通道
    CHANNEL_NAME=$CHANNEL_NAME TIMEOUT=1 docker-compose -f ./docker-compose-e2e.yaml up -d 2>&1
	#显示cli的log
    #docker logs -f cli
}

if [ -z $1 ]; then
   echo "必须输入channelName"
else
   echo $CHANNEL_NAME
   networkUp
fi




