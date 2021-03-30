package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/6/5.
 */
public class XuejiCondition {
    private int centerId;
    private int ctid;
    private String classcode;
    private String startTime;
    private String endTime;
    private String markq="q";
    private String markz="z";

    public int getCenterId() {
        return centerId;
    }

    public void setCenterId(int centerId) {
        this.centerId = centerId;
    }

    public int getCtid() {
        return ctid;
    }

    public void setCtid(int ctid) {
        this.ctid = ctid;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
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

    public String getMarkq() {
        return markq;
    }

    public void setMarkq(String markq) {
        this.markq = markq;
    }

    public String getMarkz() {
        return markz;
    }

    public void setMarkz(String markz) {
        this.markz = markz;
    }
}
