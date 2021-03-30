package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/7.
 */
public class ComprehensiveScore {
    private int id;
    private String code;
    private String name;
    private String classcode;
    private String dname;//所学方向

    private String type;

    private int diploma;
    private int graduateTime;
    private int prefession;
    private int enery_employ;

    private String corporation;
    private int salary;

    private Float[] tests = new Float[10];



    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getDiploma() {
        return diploma;
    }

    public void setDiploma(int diploma) {
        this.diploma = diploma;
    }

    public int getGraduateTime() {
        return graduateTime;
    }

    public void setGraduateTime(int graduateTime) {
        this.graduateTime = graduateTime;
    }

    public int getPrefession() {
        return prefession;
    }

    public void setPrefession(int prefession) {
        this.prefession = prefession;
    }

    public int getEnery_employ() {
        return enery_employ;
    }

    public void setEnery_employ(int enery_employ) {
        this.enery_employ = enery_employ;
    }

    public String getCorporation() {
        return corporation;
    }

    public void setCorporation(String corporation) {
        this.corporation = corporation;
    }

    public int getSalary() {
        return salary;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public Float[] getTests() {
        return tests;
    }

    public void setTests(Float[] tests) {
        this.tests = tests;
    }
}


