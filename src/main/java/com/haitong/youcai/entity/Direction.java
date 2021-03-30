package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/4/4.
 */
public class Direction {
    private int did;
    private String dname;
    private String describe;
    private Teacher charger;
    private Integer chargerId;
    private String createTime;

    private String thumb;

    public int getDid() {
        return did;
    }

    public void setDid(int did) {
        this.did = did;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }

    public Teacher getCharger() {
        return charger;
    }

    public void setCharger(Teacher charger) {
        this.charger = charger;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    public Integer getChargerId() {
        return chargerId;
    }

    public void setChargerId(Integer chargerId) {
        this.chargerId = chargerId;
    }


}
