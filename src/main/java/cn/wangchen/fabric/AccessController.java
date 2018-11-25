package cn.wangchen.fabric;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class AccessController {

    @Autowired
    private AccessService service;

    @RequestMapping("/query")
    public String query() {
        return service.query();
    }

    @RequestMapping("/invoke")
    public String invoke() {
        return service.invoke();
    }

}
