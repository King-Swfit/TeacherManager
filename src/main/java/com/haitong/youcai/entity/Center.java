package com.haitong.youcai.entity;

import java.util.Date;

/**
 * Created by Administrator on 2019/4/1.
 */
public class Center {
    private int cid;
    private String cname;
    private String address;
    private String createTime;
    private Teacher charger;//负责人,暂定负责人为教师中的一个
    private Integer chargerId;
    private String thumb;

    public Center(){
        cid = -1;
        cname = "";
        address="";
        createTime= "";
        //charger = new Teacher();
    }

    public int getCid() {
        return cid;
    }

    public void setCid(int cid) {
        this.cid = cid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public Teacher getCharger() {
        return charger;
    }

    public void setCharger(Teacher charger) {
        this.charger = charger;
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
        if(chargerId == null){
            this.chargerId = 0;
        }else{
            this.chargerId = chargerId;
        }

    }
}
