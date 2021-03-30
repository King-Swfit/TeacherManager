package com.haitong.youcai.entity;

import java.io.Serializable;

public class SysLog implements Serializable{
    private String username;
    private String ip;
    private String method;
    private String params;
    private String createDate;

    public SysLog() {

    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getParams() {
        return params;
    }

    public void setParams(String params) {
        this.params = params;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    @Override
    public String toString() {
        return "SysLog{" +
                "username='" + username + '\'' +
                ", ip='" + ip + '\'' +
                ", method='" + method + '\'' +
                ", params='" + params + '\'' +
                ", createDate='" + createDate + '\'' +
                '}';
    }


}