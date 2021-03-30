package com.haitong.youcai.entity;

public class SimpleScoreCount {
    private String code;//学员编号
    private String name;//学员姓名
    private int count;//考试次数
    private String classcode;
    private String ctname;

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

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

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

    @Override
    public String toString() {
        return "SimpleTalkCount{" +
                "code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", count=" + count +
                ", classcode='" + classcode + '\'' +
                ", ctname='" + ctname + '\'' +
                '}';
    }
}
