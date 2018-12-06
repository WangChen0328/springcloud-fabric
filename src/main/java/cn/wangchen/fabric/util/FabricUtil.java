package cn.wangchen.fabric.util;

import cn.wangchen.fabric.pojo.FabricCaUser;
import org.hyperledger.fabric.sdk.*;
import org.hyperledger.fabric.sdk.exception.CryptoException;
import org.hyperledger.fabric.sdk.exception.InvalidArgumentException;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric_ca.sdk.HFCAClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.lang.reflect.InvocationTargetException;
import java.util.Collection;

/**
 * 所有变量必须已经在环境中设定，这里只是引用
 * 根据书中作者的建议，应该做中间层，可以通过springcloud，做中间层服务治理，把每个节点定死。
 */
@Component
public class FabricUtil {

    /**
     * ca 地址
     */
    @Value("${hyperledger.fabric.ca.address}")
    private String caAdress;
    /**
     * ca 用户名
     */
    @Value("${hyperledger.fabric.ca.username}")
    private String caUsername;
    /**
     * ca 密码
     */
    @Value("${hyperledger.fabric.ca.password}")
    private String caPassword;
    /**
     * orderer 名称
     */
    @Value("${hyperledger.fabric.orderer.name}")
    private String ordererName;
    /**
     * orderer 地址
     */
    @Value("${hyperledger.fabric.orderer.grpcURL}")
    private String ordererUrl;
    /**
     * peer 名称
     */
    @Value("${hyperledger.fabric.peer.name}")
    private String peerName;
    /**
     * peer 管理员账户
     */
    @Value("${hyperledger.fabric.peer.user}")
    private String peerUser;
    /**
     * peer 地址
     */
    @Value("${hyperledger.fabric.peer.grpcURL}")
    private String peerUrl;
    /**
     * peer mspId
     */
    @Value("${hyperledger.fabric.peer.mspId}")
    private String peerMspId;
    /**
     * peer 组织名称
     */
    @Value("${hyperledger.fabric.peer.organizationName}")
    private String peerOrganizationName;
    /**
     * channel 名称
     */
    @Value("${hyperledger.fabric.channel.name}")
    private String channelName;
    /**
     * channel 名称
     */
    @Value("${hyperledger.fabric.chaincode.name}")
    private String chainCodeName;
    /**
     * channel 版本
     */
    @Value("${hyperledger.fabric.chaincode.version}")
    private String chainCodeVersion;
    /**
     * channel 路径
     */
    @Value("${hyperledger.fabric.chaincode.path}")
    private String chainCodePath;

    private User getFabricUserForFabricCA() throws Exception {
        FabricCaUser user = new FabricCaUser(peerUser, peerOrganizationName);
        user.setMspId(peerMspId);
        CryptoSuite cryptoSuite = CryptoSuite.Factory.getCryptoSuite();
        HFCAClient caClient = HFCAClient.createNewInstance(caAdress, null);
        caClient.setCryptoSuite(cryptoSuite);
        Enrollment enroll = caClient.enroll(caUsername, caPassword);
        user.setEnrollment(enroll);
        return user;
    }

    /**
     *
     * peer chaincode query -C $channelName -n $chainCode -c '{"Args":["$fcn" , "$args"]}'
     * @param fcn = $fcn
     * @param args = $args
     * 参考上面go命令
     * @return
     * @throws Exception
     */
    public Collection<ProposalResponse> query(String fcn, String... args) throws Exception {
        HFClient hfClient = getHFClient();

        QueryByChaincodeRequest queryByChaincodeRequest = hfClient.newQueryProposalRequest();

        queryByChaincodeRequest.setArgs(args);
        queryByChaincodeRequest.setFcn(fcn);
        queryByChaincodeRequest.setChaincodeLanguage(TransactionRequest.Type.JAVA);
        queryByChaincodeRequest.setChaincodeID(ChaincodeID.newBuilder().setName(chainCodeName).setVersion(chainCodeVersion).setPath(chainCodePath).build());

        return hfClient.getChannel(channelName).queryByChaincode(queryByChaincodeRequest);
    }

    /**
     * peer chaincode invoke -o orderer -C $channelName -n $chainCode -c '{"Args":["$fcn","$args"]}'
     *
     * @param fcn
     * @param args
     * @return
     * @throws Exception
     */
    public Collection<ProposalResponse> invoke(String fcn, String... args) throws Exception {
        HFClient hfClient = getHFClient();
        TransactionProposalRequest transactionProposalRequest = hfClient.newTransactionProposalRequest();
        transactionProposalRequest.setChaincodeLanguage(TransactionRequest.Type.JAVA);
        transactionProposalRequest.setChaincodeID(ChaincodeID.newBuilder().setName(chainCodeName).setVersion(chainCodeVersion).setPath(chainCodePath).build());
        transactionProposalRequest.setFcn(fcn);
        transactionProposalRequest.setArgs(args);
        transactionProposalRequest.setProposalWaitTime(300 * 1000);
        transactionProposalRequest.setUserContext(hfClient.getUserContext());

        return hfClient.getChannel(channelName).sendTransactionProposal(transactionProposalRequest);
    }

    /**
     * 可以剥离出来，存到文本或数据库中，spinrg cloud config
     * 转化为对象
     * @return
     * @throws Exception
     */
    private HFClient getHFClient() throws Exception {
        HFClient hfClient = HFClient.createNewInstance();
        CryptoSuite cryptoSuite = CryptoSuite.Factory.getCryptoSuite();
        hfClient.setCryptoSuite(cryptoSuite);

        User user = getFabricUserForFabricCA();
        hfClient.setUserContext(user);

        Channel channel = hfClient.newChannel(channelName);
        Orderer orderer = hfClient.newOrderer(ordererName, ordererUrl);
        channel.addOrderer(orderer);

        Peer peer = hfClient.newPeer(peerName, peerUrl);
        channel.addPeer(peer);
        channel.initialize();
        return hfClient;
    }
}
