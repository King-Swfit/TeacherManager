package com.haitong.youcai.service;

import com.haitong.youcai.entity.Permission;
import com.haitong.youcai.mapper.PermissionMapper;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionService {
    @Autowired
    private PermissionMapper permissionMapper;

    public List<Permission> listByRoleId(Integer roleId){
        return permissionMapper.listByRoleId(roleId);
    }
}