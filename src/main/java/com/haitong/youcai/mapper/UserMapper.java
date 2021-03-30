package com.haitong.youcai.mapper;


import com.haitong.youcai.entity.SysLog;
import com.haitong.youcai.entity.SysUser;
import org.springframework.stereotype.Repository;

/**
 * Created by Administrator on 2019/3/27.
 */
@Repository
public interface UserMapper {
    SysUser selectUserByCondition(String username, String password, String role);

    SysUser findByUsername(String username);

    void saveLog(SysLog sysLog);
}
