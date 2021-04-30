package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/4/19.
 */
public class BaseInfo_Class {
    private int clid;
    private String classcode;
    private int directionId;
    private int centerId;
    private int classteacherId;
    private String beginDate;
    private String preExamGraducateDate;
    private String preGraducateDate;
    private String realExamGraducateDate;
    private String realGraducateDate;
    private String state;
    private int initPfx;


    public int getClid() {
        return clid;
    }

    public void setClid(int clid) {
        this.clid = clid;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public int getDirectionId() {
        return directionId;
    }

    public void setDirectionId(int directionId) {
        this.directionId = directionId;
    }

    public int getCenterId() {
        return centerId;
    }

    public void setCenterId(int centerId) {
        this.centerId = centerId;
    }

    public int getClassteacherId() {
        return classteacherId;
    }

    public void setClassteacherId(int classteacherId) {
        this.classteacherId = classteacherId;
    }

    public String getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(String beginDate) {
        this.beginDate = beginDate;
    }

    public String getPreExamGraducateDate() {
        return preExamGraducateDate;
    }

    public void setPreExamGraducateDate(String preExamGraducateDate) {
        this.preExamGraducateDate = preExamGraducateDate;
    }

    public String getPreGraducateDate() {
        return preGraducateDate;
    }

    public void setPreGraducateDate(String preGraducateDate) {
        this.preGraducateDate = preGraducateDate;
    }

    public String getRealExamGraducateDate() {
        return realExamGraducateDate;
    }

    public void setRealExamGraducateDate(String realExamGraducateDate) {
        this.realExamGraducateDate = realExamGraducateDate;
    }

    public String getRealGraducateDate() {
        return realGraducateDate;
    }

    public void setRealGraducateDate(String realGraducateDate) {
        this.realGraducateDate = realGraducateDate;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public int getInitPfx() {
        return initPfx;
    }

    public void setInitPfx(int initPfx) {
        this.initPfx = initPfx;
    }

    @Override
    public String toString() {
        return "BaseInfo_Class{" +
                "clid=" + clid +
                ", classcode='" + classcode + '\'' +
                ", directionId=" + directionId +
                ", centerId=" + centerId +
                ", classteacherId=" + classteacherId +
                ", beginDate='" + beginDate + '\'' +
                ", preExamGraducateDate='" + preExamGraducateDate + '\'' +
                ", preGraducateDate='" + preGraducateDate + '\'' +
                ", realExamGraducateDate='" + realExamGraducateDate + '\'' +
                ", realGraducateDate='" + realGraducateDate + '\'' +
                ", state='" + state + '\'' +
                ", initPfx=" + initPfx +
                '}';
    }
}
