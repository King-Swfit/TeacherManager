package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/14.
 */
public class Score implements Comparable<Score>{
    private int tid;
    private String code;
    private String classcode;
    private String ttime;
    private String tname;
    private float tscore;
    private String detail;
    private int did;

    private String trname;//学员名字
    private String ctname;//班主任名字
    private String dname;//方向名

    public int getTid() {
        return tid;
    }

    public void setTid(int tid) {
        this.tid = tid;
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

    public String getTtime() {
        return ttime;
    }

    public void setTtime(String ttime) {
        this.ttime = ttime;
    }

    public String getTname() {
        return tname;
    }

    public void setTname(String tname) {
        this.tname = tname;
    }

    public float getTscore() {
        return tscore;
    }

    public void setTscore(float tscore) {
        this.tscore = tscore;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public int getDid() {
        return did;
    }

    public void setDid(int did) {
        this.did = did;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public String getTrname() {
        return trname;
    }

    public void setTrname(String trname) {
        this.trname = trname;
    }

    @Override
    public String toString() {
        return "Score{" +
                "tid=" + tid +
                ", code='" + code + '\'' +
                ", classcode='" + classcode + '\'' +
                ", ttime='" + ttime + '\'' +
                ", tname='" + tname + '\'' +
                ", tscore=" + tscore +
                ", detail='" + detail + '\'' +
                ", did=" + did +
                '}';
    }

    @Override
    public int compareTo(Score o) {
        if(ttime.compareTo(o.getTtime()) > 0){
            return 1;
        }else if(ttime.compareTo(o.getTtime()) < 0){
            return  -1;
        }else{
            return 0;
        }
    }
}
