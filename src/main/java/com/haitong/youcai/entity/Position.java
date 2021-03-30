package com.haitong.youcai.entity;

import java.util.Date;

/**
 * Created by Administrator on 2019/4/1.
 */
public class Position {
    private int pid;
    private String pname;
    private int salary;
    private String createTime;
    private int type= 0; //0 教学  1教研  2管理
    private int courseId;//所教课程的课程id--cid
    private String duty;//职责描述

    public Position(){
        pid = -1;
        pname = "";
        salary = -1;
        createTime = "";
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }

    public int getSalary() {
        return salary;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getDuty() {
        return duty;
    }

    public void setDuty(String duty) {
        this.duty = duty;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
}
