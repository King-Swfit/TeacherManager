package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.*;
import com.haitong.youcai.entity.Permission;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.acls.model.*;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/4/1.
 */
@Repository
public interface PermissionMapper {
    List<Permission> listByRoleId(Integer roleId);

    Role selectByName(String rname);
}
