package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/6/4.
 */
public class EmploySummary {
    private String classcode;
    private String dname;//学习方向
    private String ctname;//班主任名字
    private String cname;//中心名字
    private String pname;//岗位

    private float avgSalary_zhuan;//专科平均工资
    private float avgSalary_ben;//本科平均工资
    private float avgInterviewTimes;//人均面试次数
    private float avgEmployPeriod;//平均就业周期
    private float percentDevlop;//开发岗比例
    private float percentNoDevlop;//非开发岗比例
    private int count;//人数总数

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public float getAvgSalary_zhuan() {
        return avgSalary_zhuan;
    }

    public void setAvgSalary_zhuan(float avgSalary_zhuan) {
        this.avgSalary_zhuan = avgSalary_zhuan;
    }

    public float getAvgSalary_ben() {
        return avgSalary_ben;
    }

    public void setAvgSalary_ben(float avgSalary_ben) {
        this.avgSalary_ben = avgSalary_ben;
    }

    public float getAvgInterviewTimes() {
        return avgInterviewTimes;
    }

    public void setAvgInterviewTimes(float avgInterviewTimes) {
        this.avgInterviewTimes = avgInterviewTimes;
    }

    public float getAvgEmployPeriod() {
        return avgEmployPeriod;
    }

    public void setAvgEmployPeriod(float avgEmployPeriod) {
        this.avgEmployPeriod = avgEmployPeriod;
    }

    public float getPercentDevlop() {
        return percentDevlop;
    }

    public void setPercentDevlop(float percentDevlop) {
        this.percentDevlop = percentDevlop;
    }

    public float getPercentNoDevlop() {
        return percentNoDevlop;
    }

    public void setPercentNoDevlop(float percentNoDevlop) {
        this.percentNoDevlop = percentNoDevlop;
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

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }
}
