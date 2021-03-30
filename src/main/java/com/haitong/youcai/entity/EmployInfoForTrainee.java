package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/10.
 */
public class EmployInfoForTrainee {
    private int eiid;
    private String code;
    //就业状态
    private String state;
    private String employ_time;
    private String employ_unit;
    private String employ_position;
    private int employ_salary;
    private String comment;

    public int getEiid() {
        return eiid;
    }

    public void setEiid(int eiid) {
        this.eiid = eiid;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getEmploy_time() {
        return employ_time;
    }

    public void setEmploy_time(String employ_time) {
        this.employ_time = employ_time;
    }

    public String getEmploy_unit() {
        return employ_unit;
    }

    public void setEmploy_unit(String employ_unit) {
        this.employ_unit = employ_unit;
    }

    public String getEmploy_position() {
        return employ_position;
    }

    public void setEmploy_position(String employ_position) {
        this.employ_position = employ_position;
    }

    public int getEmploy_salary() {
        return employ_salary;
    }

    public void setEmploy_salary(int employ_salary) {
        this.employ_salary = employ_salary;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
