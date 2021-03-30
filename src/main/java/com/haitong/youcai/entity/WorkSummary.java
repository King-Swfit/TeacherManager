package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/6/14.
 */
public class WorkSummary {
    private String classcode;
    private String ctname;
    private int talkCount;
    private String recommandResult;
    private String connectResult;

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

    public int getTalkCount() {
        return talkCount;
    }

    public void setTalkCount(int talkCount) {
        this.talkCount = talkCount;
    }

    public String getRecommandResult() {
        return recommandResult;
    }

    public void setRecommandResult(String recommandResult) {
        this.recommandResult = recommandResult;
    }

    public String getConnectResult() {
        return connectResult;
    }

    public void setConnectResult(String connectResult) {
        this.connectResult = connectResult;
    }
}
