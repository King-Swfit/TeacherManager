package com.haitong.youcai.entity;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2019/5/14.
 */
public class SummaryTalk {
    private int ctid;     //班主任ctid
    private String ctname;//班主任名
    //          classcode     month，    treeMap自定义比较器
    private Map<String, Map<String, ClassTalkSummary>> classTalkSummaryMap;

    public int getCtid() {
        return ctid;
    }

    public void setCtid(int ctid) {
        this.ctid = ctid;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public Map<String, Map<String, ClassTalkSummary>> getClassTalkSummaryMap() {
        return classTalkSummaryMap;
    }

    public void setClassTalkSummaryMap(Map<String, Map<String, ClassTalkSummary>> classTalkSummaryMap) {
        this.classTalkSummaryMap = classTalkSummaryMap;
    }
}
