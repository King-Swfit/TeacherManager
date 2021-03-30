package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/14.
 */
public class Talk {
    private int tid;
    private String ttime;
    private String name;
    private String code;
    private String classcode;
    private String talkType;
    private String tcontent;
    private String learnState;
    private String result;//访谈结果：目标达成、目标未达成



    public int getTid() {
        return tid;
    }

    public void setTid(int tid) {
        this.tid = tid;
    }

    public String getTtime() {
        return ttime;
    }

    public void setTtime(String ttime) {
        this.ttime = ttime;
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

    public String getTalkType() {
        return talkType;
    }

    public void setTalkType(String talkType) {
        this.talkType = talkType;
    }

    public String getTcontent() {
        return tcontent;
    }

    public void setTcontent(String tcontent) {
        this.tcontent = tcontent;
    }

    public String getLearnState() {
        return learnState;
    }

    public void setLearnState(String learnState) {
        this.learnState = learnState;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
