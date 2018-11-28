环境：CentOS-7-x86_64-Everything-1804

脚本：opt

集群：zookeeper 3、kafka 3、orderer 2、peer 4、ca 2(个)

在IDEA 中运行 java chaincode 需要 jdk11

建议将opt打个zip,在linux/opt中解压，可直接使用

(1) yum -y install epel-release docker docker-compose golang

(2) profile GOPATH=/opt/gopath GOROOT=/opt/go

(3) /opt/gopath/src/github.com/hyperledger/fabric-1.3.0

(4) cd /opt/e2e

(5) sh network_setup.sh channelName

(6) docker-compose -f ./docker-compose-ca.yaml up -d

docker-compose-ca.yaml ：需要自己改 ca证书路径，也可以自己编写shell动态生成

---------------------------------------------------------------------------
IDEA 启动 chaincode

Program arguments: -peer.address=192.168.1.104:9052(码链地址)
Environment variables: 
    CORE_CHAINCODE_ID_NAME: SimpleSample:1.0
    CORE_CHANCODE_LOGGING_LEVEL: debug
    CORE_CHANCODE_LOGGING_SHIM: debug
    CORE_PEER_ADDRESS: 192.168.1.104:9051


    