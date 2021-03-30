package com.haitong.youcai.entity;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2019/5/19.
 */
public class ProcessAttenceMSummaryDays {
    private int pamdid;
    private String code;
    private String name;
    private String classcode;
    private String month;


    private List<String> days;

    public int getPamdid() {
        return pamdid;
    }

    public void setPamdid(int pamdid) {
        this.pamdid = pamdid;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public List<String> getDays() {
        return days;
    }

    public void setDays(List<String> days) {
        this.days = days;
    }
}
