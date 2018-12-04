#!/bin/bash -eu
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

dockerFabricPull() {
  for IMAGES in peer orderer ccenv javaenv tools; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:1.3.0
      docker tag hyperledger/fabric-$IMAGES:1.3.0 hyperledger/fabric-$IMAGES
  done
}

dockerCaPull() {
  echo "==> FABRIC CA IMAGE"
  echo
  docker pull hyperledger/fabric-ca:1.3.0
  docker tag hyperledger/fabric-ca:1.3.0 hyperledger/fabric-ca
}

dockerFabricSupportedPull() {
  for IMAGES in zookeeper kafka baseimage; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:0.4.13
      docker tag hyperledger/fabric-$IMAGES:0.4.13 hyperledger/fabric-$IMAGES
  done
}

dockerKafkaManagerPull() {
	docker pull hlebalbau/kafka-manager:1.3.3.18
    docker tag hlebalbau/kafka-manager:1.3.3.18 hlebalbau/kafka-manager
}

echo "===> Pulling fabric Images"
dockerFabricPull

echo "===> Pulling fabric ca Image"
dockerCaPull

echo "===> Pulling fabric ca Image"
dockerFabricSupportedPull

echo "===> Pulling fabric ca KafkaManager"
dockerKafkaManagerPull
echo
echo "===> List out hyperledger docker images"
docker images | grep hyperledger*
