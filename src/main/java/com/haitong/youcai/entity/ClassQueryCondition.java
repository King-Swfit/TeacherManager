package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/9.
 */
public class ClassQueryCondition {
    int centerId;
    int classteacherId;
    String classstate;
    int classstate_i;

    String startTime;
    String endTime;

    public int getCenterId() {
        return centerId;
    }

    public void setCenterId(int centerId) {
        this.centerId = centerId;
    }



    public String getClassstate() {
        return classstate;
    }

    public void setClassstate(String classstate) {
        this.classstate = classstate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }



    public int getClassstate_i() {
        return classstate_i;
    }

    public void setClassstate_i(int classstate_i) {
        this.classstate_i = classstate_i;
    }

    public int getClassteacherId() {
        return classteacherId;
    }

    public void setClassteacherId(int classteacherId) {
        this.classteacherId = classteacherId;
    }
}
