package com.haitong.youcai.service;

import com.haitong.youcai.entity.Role;
import com.haitong.youcai.mapper.PermissionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoleService {
    @Autowired
    private PermissionMapper permissionMapper;
    public Role selectByName(String rname){
        return permissionMapper.selectByName(rname);
    }
}