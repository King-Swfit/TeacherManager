package com.haitong.youcai.controller;


import com.haitong.youcai.entity.SysUser;
import com.haitong.youcai.service.CustomUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by Administrator on 2019/6/12.
 */
@Controller
public class LoginController {
    @Autowired
    private CustomUserService userService;

    @RequestMapping("/login")
    public String login() {
        return "login";
    }

    @RequestMapping(value={"/index",""})
    public String index() {
        return "index";
    }

    @RequestMapping(value={"/test"})
    @ResponseBody
    public String test() {
        return "dshdshdfh";
    }
}
