package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/17.
 */
public class ProcessAttenceMSummary {
    private int pamid;
    private String code;
    private String classcode;
    private String name;
    private String month;

    private int days;
    private int lates;
    private String lateTimes;
    private int earlyLefts;
    private String earlyLeftTimes;
    private int lackClicks_1;
    private int lackClicks_2;
    private int absentDays;
    private String absent_things;
    private String absent_ills;


    public int getPamid() {
        return pamid;
    }

    public void setPamid(int pamid) {
        this.pamid = pamid;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDays() {
        return days;
    }

    public void setDays(int days) {
        this.days = days;
    }

    public int getLates() {
        return lates;
    }

    public void setLates(int lates) {
        this.lates = lates;
    }



    public int getEarlyLefts() {
        return earlyLefts;
    }

    public void setEarlyLefts(int earlyLefts) {
        this.earlyLefts = earlyLefts;
    }



    public int getLackClicks_1() {
        return lackClicks_1;
    }

    public void setLackClicks_1(int lackClicks_1) {
        this.lackClicks_1 = lackClicks_1;
    }

    public int getLackClicks_2() {
        return lackClicks_2;
    }

    public void setLackClicks_2(int lackClicks_2) {
        this.lackClicks_2 = lackClicks_2;
    }

    public int getAbsentDays() {
        return absentDays;
    }

    public void setAbsentDays(int absentDays) {
        this.absentDays = absentDays;
    }


    public String getLateTimes() {
        return lateTimes;
    }

    public void setLateTimes(String lateTimes) {
        this.lateTimes = lateTimes;
    }

    public String getEarlyLeftTimes() {
        return earlyLeftTimes;
    }

    public void setEarlyLeftTimes(String earlyLeftTimes) {
        this.earlyLeftTimes = earlyLeftTimes;
    }

    public String getAbsent_things() {
        return absent_things;
    }

    public void setAbsent_things(String absent_things) {
        this.absent_things = absent_things;
    }

    public String getAbsent_ills() {
        return absent_ills;
    }

    public void setAbsent_ills(String absent_ills) {
        this.absent_ills = absent_ills;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }
}
