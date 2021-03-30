package com.haitong.youcai.entity;

import java.io.Serializable;

/**
 * Created by Administrator on 2019/4/11.
 */
public class Chapter implements Serializable{
    private int cpid;
    private String cpname;
    private String cpdescribe;
    private int courseId;
    private int posInCourse;
    private int period;

    public int getCpid() {
        return cpid;
    }

    public void setCpid(int cpid) {
        this.cpid = cpid;
    }

    public String getCpname() {
        return cpname;
    }

    public void setCpname(String cpname) {
        this.cpname = cpname;
    }

    public String getCpdescribe() {
        return cpdescribe;
    }

    public void setCpdescribe(String cpdescribe) {
        this.cpdescribe = cpdescribe;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getPosInCourse() {
        return posInCourse;
    }

    public void setPosInCourse(int posInCourse) {
        this.posInCourse = posInCourse;
    }

    public int getPeriod() {
        return period;
    }

    public void setPeriod(int period) {
        this.period = period;
    }
}
