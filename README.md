环境：CentOS-7-x86_64-Everything-1804

脚本：opt

集群：zookeeper 3、kafka 3、orderer 2、peer 4、ca 2(个)

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

(1) 必须先启动一次码链

(2) 需要 jdk11

(3) IDEA 环境配置

    Program arguments:
    
        -peer.address=192.168.1.104:9052(码链地址)
    
    Environment variables: 
        
        CORE_CHAINCODE_ID_NAME: SimpleSample:1.0
        CORE_CHANCODE_LOGGING_LEVEL: debug
        CORE_CHANCODE_LOGGING_SHIM: debug
        CORE_PEER_ADDRESS: 192.168.1.104:9051
        
        TLS属性 (测试未成功)：
        CORE_PEER_TLS_ENABLED: true
        CORE_PEER_TLS_ROOTCERT_FILE: C:\Users\wangchen\keystore\ca.crt
        CORE_TLS_CLIENT_KEY_PATH: C:\Users\wangchen\keystore\client.key
        CORE_TLS_CLIENT_CERT_PATH: C:\Users\wangchen\keystore\client.crt
    
    使用TLS加密后的码链，并未在IDEA中的测试DEBUG成功。
    错误为：unable to find valid certification path to requested target
    
    经过尝试的方法：
    <1> 在jdk中导入证书
    <2> 在环境(windows)中导入证书 
    <3> 源码中直接使用BASE64解密，所以需要先将 client.crt、client.key BASE64编码
    
    经过测试发现 Peer服务器已经接受到TLS请求，但证书验证不通过，不知道原因。    


    