package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/6/4.
 */
public class AvgSalary {
    private String classcode;
    private String ctname;
    private int avgSalaryForZhuan;
    private int avgSalaryForBen;

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public int getAvgSalaryForZhuan() {
        return avgSalaryForZhuan;
    }

    public void setAvgSalaryForZhuan(int avgSalaryForZhuan) {
        this.avgSalaryForZhuan = avgSalaryForZhuan;
    }

    public int getAvgSalaryForBen() {
        return avgSalaryForBen;
    }

    public void setAvgSalaryForBen(int avgSalaryForBen) {
        this.avgSalaryForBen = avgSalaryForBen;
    }
}
