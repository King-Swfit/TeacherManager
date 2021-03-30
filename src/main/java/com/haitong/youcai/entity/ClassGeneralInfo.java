package com.haitong.youcai.entity;

import java.util.List;

/**
 * Created by Administrator on 2019/4/22.
 */
public class ClassGeneralInfo {
    private int clid;
    private int directionId;
    private int centerId;
    private int classteacherId;

    private String  dname;
    private String cname;
    private String ctname;

    private String classcode;
    private Direction direction;
    private Center center;
    private ClassTeacher classteacher;
    private String beginDate;
    private String preExamGraducateDate;
    private String preGraducateDate;
    private String realExamGraducateDate;
    private String realGraducateDate;

    private List<ClassTeacher> classTeachers;//center.cid对应的所有班主任
    private List<CoursePlanItem_Class_f> courseItems;
    private List<CoursePlanItem_Class> courseItems2;

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

    public Direction getDirection() {
        return direction;
    }

    public void setDirection(Direction direction) {
        this.direction = direction;
    }

    public Center getCenter() {
        return center;
    }

    public void setCenter(Center center) {
        this.center = center;
    }

    public ClassTeacher getClassteacher() {
        return classteacher;
    }

    public void setClassteacher(ClassTeacher classteacher) {
        this.classteacher = classteacher;
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

    public List<CoursePlanItem_Class_f> getCourseItems() {
        return courseItems;
    }

    public void setCourseItems(List<CoursePlanItem_Class_f> courseItems) {
        this.courseItems = courseItems;
    }

    public List<ClassTeacher> getClassTeachers() {
        return classTeachers;
    }

    public void setClassTeachers(List<ClassTeacher> classTeachers) {
        this.classTeachers = classTeachers;
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

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public List<CoursePlanItem_Class> getCourseItems2() {
        return courseItems2;
    }

    public void setCourseItems2(List<CoursePlanItem_Class> courseItems2) {
        this.courseItems2 = courseItems2;
    }
}
