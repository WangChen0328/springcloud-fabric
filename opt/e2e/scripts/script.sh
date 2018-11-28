#!/bin/bash
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
echo
echo " ____    _____      _      ____    _____           _____   ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|         | ____| |___ \  | ____|"
echo "\___ \    | |     / _ \   | |_) |   | |    _____  |  _|     __) | |  _|  "
echo " ___) |   | |    / ___ \  |  _ <    | |   |_____| | |___   / __/  | |___ "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|           |_____| |_____| |_____|"
echo

CHANNEL_NAME=$1

echo "Channel name : "$CHANNEL_NAME

setGlobals () {
	CORE_PEER_LOCALMSPID="bgOrg1Msp"
	CORE_PEER_ADDRESS=peer0.org1.wangchen.com:7051
	CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/users/Admin@org1.wangchen.com/msp
	echo "=====================  setGlobals ===================== "
	echo
}

createChannel() {
	echo "=====================  start createChannel ===================== "
	peer channel create -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/bcChannel.tx >&log.txt
	cat log.txt
	echo "=====================  end createChannel ======================= "
	echo
}

joinChannel() {
	echo "=====================  start joinChannel ===================== "
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	cat log.txt
	echo "=====================  end joinChannel ======================= "
	echo
}

updateAnchorPeers() {
	echo "=====================  start updateAnchorPeers ===================== "
	peer channel update -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx >&log.txt
	#peer channel update -o orderer2.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx >&log.txt
	
	cat log.txt
	echo "=====================  end updateAnchorPeers ======================= "
	echo
}

installChaincode () {
    echo "=====================  start installChaincode ===================== "
	peer chaincode install -n wangchen02 -v 1.0 -p github.com/hyperledger/fabric/chaincode/go/chaincode_wangchen02>&log.txt
	peer chaincode install -n SimpleSample -v 1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/java/wangchen>&log.txt
	cat log.txt
	echo "=====================  end installChaincode ======================= "
	echo
}

instantiateChaincode () {
	echo "=====================  start instantiateChaincode ===================== "
	peer chaincode instantiate -o orderer1.wangchen.com:7050 -C $CHANNEL_NAME -n wangchen02 -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('bgOrg1Msp.peer','bgOrg2Msp.peer')" >&log.txt
	peer chaincode instantiate -o orderer1.wangchen.com:7050 -C $CHANNEL_NAME -n SimpleSample -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('bgOrg1Msp.peer','bgOrg2Msp.peer')" >&log.txt
	cat log.txt
	echo "=====================  end instantiateChaincode ======================= "
	echo
}

createChannel
joinChannel
updateAnchorPeers
installChaincode 
instantiateChaincode 

echo
echo "===================== All GOOD, End-2-End execution completed ===================== "
echo

echo
echo " _____   _   _   ____            _____   ____    _____ "
echo "| ____| | \ | | |  _ \          | ____| |___ \  | ____|"
echo "|  _|   |  \| | | | | |  _____  |  _|     __) | |  _|  "
echo "| |___  | |\  | | |_| | |_____| | |___   / __/  | |___ "
echo "|_____| |_| \_| |____/          |_____| |_____| |_____|"
echo

exit 0
