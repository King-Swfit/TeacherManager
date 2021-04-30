package com.haitong.youcai.entity;

import java.util.List;

/**
 * Created by Administrator on 2019/4/19.
 */
public class CoursePlanItem_Class {
    private int ciiid;
    private String classcode;
    private int courseId;
    private int teacherId;
    private String cname;//课程明
    private String tname;//教师名字

    private String preBeginDate;
    private String preEndDate;
    private String preProEndDate;

    private String realBeginDate;
    private String realEndDate;
    private String realProEndDate;

    private List<SimpleTeacher> teachers;

    public int getCiiid() {
        return ciiid;
    }

    public void setCiiid(int ciiid) {
        this.ciiid = ciiid;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getPreBeginDate() {
        return preBeginDate;
    }

    public void setPreBeginDate(String preBeginDate) {
        this.preBeginDate = preBeginDate;
    }

    public String getPreEndDate() {
        return preEndDate;
    }

    public void setPreEndDate(String preEndDate) {
        this.preEndDate = preEndDate;
    }

    public String getPreProEndDate() {
        return preProEndDate;
    }

    public void setPreProEndDate(String preProEndDate) {
        this.preProEndDate = preProEndDate;
    }

    public String getRealBeginDate() {
        return realBeginDate;
    }

    public void setRealBeginDate(String realBeginDate) {
        this.realBeginDate = realBeginDate;
    }

    public String getRealEndDate() {
        return realEndDate;
    }

    public void setRealEndDate(String realEndDate) {
        this.realEndDate = realEndDate;
    }

    public String getRealProEndDate() {
        return realProEndDate;
    }

    public void setRealProEndDate(String realProEndDate) {
        this.realProEndDate = realProEndDate;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getTname() {
        return tname;
    }

    public void setTname(String tname) {
        this.tname = tname;
    }

    public List<SimpleTeacher> getTeachers() {
        return teachers;
    }

    public void setTeachers(List<SimpleTeacher> teachers) {
        this.teachers = teachers;
    }

    @Override
    public String toString() {
        return "CoursePlanItem_Class{" +
                "ciiid=" + ciiid +
                ", classcode='" + classcode + '\'' +
                ", courseId=" + courseId +
                ", teacherId=" + teacherId +
                ", cname='" + cname + '\'' +
                ", tname='" + tname + '\'' +
                ", preBeginDate='" + preBeginDate + '\'' +
                ", preEndDate='" + preEndDate + '\'' +
                ", preProEndDate='" + preProEndDate + '\'' +
                ", realBeginDate='" + realBeginDate + '\'' +
                ", realEndDate='" + realEndDate + '\'' +
                ", realProEndDate='" + realProEndDate + '\'' +
                ", teachers=" + teachers +
                '}';
    }
}
