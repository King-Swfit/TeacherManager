package com.haitong.youcai.service;

import com.haitong.youcai.entity.SysLog;
import com.haitong.youcai.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SysLogService {
    @Autowired
    private UserMapper userMapper;

    public void saveLog(SysLog sysLog){
        userMapper.saveLog(sysLog);
    }
}
