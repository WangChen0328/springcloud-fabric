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
TLS_ENABLED=$2

ORDERER_CA0=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/wangchen.com/orderers/orderer1.wangchen.com/msp/tlscacerts/tlsca.wangchen.com-cert.pem
ORDERER_CA1=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/wangchen.com/orderers/orderer2.wangchen.com/msp/tlscacerts/tlsca.wangchen.com-cert.pem

echo "Channel name : "$CHANNEL_NAME

if [ -z $TLS_ENABLED ]; then 
	echo "当前为非TLS连接 "
	echo "如果要使用TLS连接,到 base/ca-base、orderer-base、peer-base 中修改属性 - TLS_ENABLED=true "
	echo "还需修改 docker-compose-e2e.yaml中的CA配置，预先设定好volumes中的引用和base/ca-base中的command命令!"
else
	echo "当前为TLS连接 "
	echo "如果要使用非TLS连接,到 base/ca-base、orderer-base、peer-base 中修改属性 - TLS_ENABLED=false "
fi

setPeer0Org1 () {

	CORE_PEER_ADDRESS=peer0.org1.wangchen.com:7051
    CORE_PEER_LOCALMSPID=bgOrg1Msp
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/peers/peer0.org1.wangchen.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/users/Admin@org1.wangchen.com/msp
	
	echo "=====================  setGlobals peer0.org1.wangchen.com:7051  ===================== "
	echo
}

setPeer1Org1 () {

	CORE_PEER_ADDRESS=peer1.org1.wangchen.com:7051
    CORE_PEER_LOCALMSPID=bgOrg1Msp
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/peers/peer1.org1.wangchen.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/users/Admin@org1.wangchen.com/msp

	echo "=====================  setGlobals peer1.org1.wangchen.com:7051  ===================== "
	echo
}
setPeer0Org2() {

	CORE_PEER_ADDRESS=peer0.org2.wangchen.com:7051
    CORE_PEER_LOCALMSPID=bgOrg2Msp
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.wangchen.com/peers/peer0.org2.wangchen.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.wangchen.com/users/Admin@org2.wangchen.com/msp
	
	echo "=====================  setGlobals peer0.org2.wangchen.com:7051  ===================== "
	echo
}
setPeer1Org2 () {

	CORE_PEER_ADDRESS=peer1.org2.wangchen.com:7051
    CORE_PEER_LOCALMSPID=bgOrg2Msp
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.wangchen.com/peers/peer1.org2.wangchen.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.wangchen.com/users/Admin@org2.wangchen.com/msp
	
	echo "=====================  setGlobals peer1.org2.wangchen.com:7051  ===================== "
	echo
}
setOtherUser () {

	CORE_PEER_ADDRESS=peer1.org1.wangchen.com:7051
    CORE_PEER_LOCALMSPID=bgOrg1Msp
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/peers/peer1.org1.wangchen.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/users/User1@org1.wangchen.com/msp
	
	echo "=====================  setGlobals peer1.org2.wangchen.com:7051  ===================== "
	echo
}

createChannel() {
	echo "=====================  start createChannel ===================== "
	
	setPeer1Org1

	if [ -z $TLS_ENABLED ];
	then
		peer channel create -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/bcChannel.tx >&log.txt
	else
		CORE_PEER_TLS_ENABLED=true
		peer channel create -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/bcChannel.tx --tls --cafile $ORDERER_CA0>&log.txt
	fi
	
	cat log.txt
	echo "=====================  end createChannel ======================= "
	echo
}

joinChannel() {
	echo "=====================  start joinChannel ===================== "
	
	setPeer0Org1
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	
	setPeer1Org1
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	
	setPeer0Org2
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	
	setPeer1Org2
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	
	cat log.txt
	echo "=====================  end joinChannel ======================= "
	echo
}

updateAnchorPeers() {
	echo "=====================  start updateAnchorPeers ===================== "
	
	if [ -z $TLS_ENABLED ];
	then
		peer channel update -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx >&log.txt
		peer channel update -o orderer2.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx >&log.txt
	else
		CORE_PEER_TLS_ENABLED=true
		peer channel update -o orderer1.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile $ORDERER_CA0>&log.txt
		peer channel update -o orderer2.wangchen.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile $ORDERER_CA1>&log.txt
	fi
	
	cat log.txt
	echo "=====================  end updateAnchorPeers ======================= "
	echo
}

installChaincode () {
    echo "=====================  start installChaincode ===================== "
	
	setPeer0Org1
	peer chaincode install -n SimpleSample -v 1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/java/wangchen>&log.txt
	
	setPeer1Org1
	peer chaincode install -n SimpleSample -v 1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/java/wangchen>&log.txt
	
	setPeer0Org2
	peer chaincode install -n SimpleSample -v 1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/java/wangchen>&log.txt
	
	setPeer1Org2
	peer chaincode install -n SimpleSample -v 1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/java/wangchen>&log.txt
	
	cat log.txt
	echo "=====================  end installChaincode ======================= "
	echo
}

instantiateChaincode () {
	echo "=====================  start instantiateChaincode ===================== "

	setPeer1Org1
		
	if [ -z $TLS_ENABLED ];
	then
		peer chaincode instantiate -o orderer1.wangchen.com:7050 -C $CHANNEL_NAME -n SimpleSample -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('bgOrg1Msp.peer','bgOrg2Msp.peer')" >&log.txt
	else
		CORE_PEER_TLS_ENABLED=true
		peer chaincode instantiate -o orderer1.wangchen.com:7050 --tls --cafile $ORDERER_CA0 -C $CHANNEL_NAME -n SimpleSample -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('bgOrg1Msp.member','bgOrg2Msp.member')" >&log.txt
	fi
	
	cat log.txt
	echo "=====================  end instantiateChaincode ======================= "
	echo
}

chaincodeQuery () {
	sleep 10
	setPeer1Org1
	peer chaincode query -C $CHANNEL_NAME -n SimpleSample -c '{"Args":["query","a"]}'
	echo "=====================  end chaincodeQuery ======================= "
}

chaincodeInvoke() {
	sleep 5
	setOtherUser
	if [ -z $TLS_ENABLED ];
	then
		peer chaincode invoke -C $CHANNEL_NAME -o orderer1.wangchen.com:7050 -n SimpleSample \
		-c '{"Args":["invoke","a","b","10"]}'
	else	
		CORE_PEER_TLS_ENABLED=true
		peer chaincode invoke -C $CHANNEL_NAME -o orderer1.wangchen.com:7050 -n SimpleSample --tls --cafile $ORDERER_CA0 \
		--peerAddresses peer0.org1.wangchen.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.wangchen.com/peers/peer0.org1.wangchen.com/msp/tlscacerts/tlsca.org1.wangchen.com-cert.pem \
		--peerAddresses peer0.org2.wangchen.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.wangchen.com/peers/peer0.org2.wangchen.com/msp/tlscacerts/tlsca.org2.wangchen.com-cert.pem \
		-c '{"Args":["invoke","a","b","10"]}' 
	fi
	echo "=====================  end chaincodeInvoke ======================= "
}

createChannel
joinChannel
updateAnchorPeers
installChaincode 
instantiateChaincode
chaincodeQuery 
chaincodeInvoke
chaincodeQuery

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
