package cn.wangchen.fabric;

import cn.wangchen.fabric.util.FabricUtil;
import org.hyperledger.fabric.sdk.ProposalResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Service
public class AccessService {

    @Autowired
    private FabricUtil util;

    public String query(){
        Collection<ProposalResponse> query = null;
        try {
            query = util.query("query", "a");
        } catch (Exception e) {
            e.printStackTrace();
        }
        for (ProposalResponse response : query) {
            return response.getProposalResponse().getResponse().getPayload().toStringUtf8();
        }
        return "";
    }

    public String invoke(){
        Collection<ProposalResponse> invoke = null;
        try {
            invoke = util.invoke("invoke", "a", "b", "1");
        } catch (Exception e) {
            e.printStackTrace();
        }
        for (ProposalResponse response : invoke) {
            response.getProposalResponse().getResponse().getPayload().toStringUtf8();
        }
        return query();
    }
}
