package com.haitong.youcai.config;


import com.haitong.youcai.entity.Permission;
import com.haitong.youcai.service.PermissionService;
import com.haitong.youcai.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.PermissionEvaluator;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Component
public class CustomPermissionEvaluator implements PermissionEvaluator {
    @Autowired
    private PermissionService permissionService;

    @Autowired
    private RoleService roleService;


    //在 hasPermission() 方法中，参数 1 代表用户的权限身份，
    // 参数 2 参数 3 分别和 @PreAuthorize("hasPermission('/admin','r')") 中的参数对应，即访问 url 和权限。
    @Override
    public boolean hasPermission(Authentication authentication, Object targetUrl, Object targetPermission) {
        System.out.println(targetUrl.toString());
        // 获得loadUserByUsername()方法的结果
        User user = (User)authentication.getPrincipal();
        // 获得loadUserByUsername()中注入的角色
        Collection<GrantedAuthority> authorities = user.getAuthorities();

        boolean isExistUrl = false;
        // 遍历用户所有角色
        for(GrantedAuthority authority : authorities) {
            String roleName = authority.getAuthority();
            Integer roleId = roleService.selectByName(roleName).getId();
            // 得到角色所有的权限
            List<Permission> permissionList = permissionService.listByRoleId(roleId);

            // 遍历permissionList

            for(Permission permission : permissionList) {
                // 获取权限集
                String per = permission.getPermission();
                // 如果访问的Url和权限用户符合的话，返回true
                if(targetUrl.toString().equals(permission.getUrl())) {
                    isExistUrl = true;
                    if(per.equals(targetPermission)){
                        return true;
                    }

                }
            }

        }

        //若无该url，则放行
        if(isExistUrl == false) {
            return true;
        }


        return false;
    }

    @Override
    public boolean hasPermission(Authentication authentication, Serializable serializable, String s, Object o) {
        return false;
    }
}
