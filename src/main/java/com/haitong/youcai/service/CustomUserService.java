package com.haitong.youcai.service;

import com.haitong.youcai.entity.SysUser;
import com.haitong.youcai.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Administrator on 2019/6/21.
 */
@Service
public class CustomUserService {
    @Autowired
    private UserMapper userMapper;

    public SysUser findByUsername(String username) {
        return userMapper.findByUsername(username);
    }
}
