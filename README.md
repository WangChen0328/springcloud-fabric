环境：CentOS-7-x86_64-Everything-1804

脚本：opt

集群：zookeeper 3、kafka 3、orderer 2、peer 4、ca 2(个)

Java chaincode 在 项目fabric-chaincode中

建议将opt打个zip,在linux/opt中解压，可直接使用。

(1) yum -y install epel-release docker docker-compose golang

(2) profile GOPATH=/opt/gopath GOROOT=/opt/go

(3) cd /opt/e2e

(4) sh network_setup.sh channelName

(5) docker-compose -f ./docker-compose-ca.yaml up -d

docker-compose-ca.yaml ：需要自己改 ca证书路径，也可以自己编写shell动态生成
 

    