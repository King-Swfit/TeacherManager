package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/21.
 */
public class Corporiation {
    private int cid;
    private String cname;
    private String caddress;
    private String describee;
    private String contectName;//联系人
    private String contactPosition;//联系人职位
    private String hrmanager;
    private String tel;
    private String phone;
    private String qq;
    private String weichat;
    private String isQiyeQQ;
    private String isEnroll;//是否签约企业
    private int stuNumbers;//累计已录用学生数
    private int yearStuNumbers;//年内已录用学生数
    private String timee;//路途时间

    private int tid;//录入人的id
    private String tname;//录入人的名字



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

    public String getCaddress() {
        return caddress;
    }

    public void setCaddress(String caddress) {
        this.caddress = caddress;
    }


    public String getHrmanager() {
        return hrmanager;
    }

    public void setHrmanager(String hrmanager) {
        this.hrmanager = hrmanager;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getWeichat() {
        return weichat;
    }

    public void setWeichat(String weichat) {
        this.weichat = weichat;
    }

    public int getStuNumbers() {
        return stuNumbers;
    }

    public void setStuNumbers(int stuNumbers) {
        this.stuNumbers = stuNumbers;
    }

    public int getYearStuNumbers() {
        return yearStuNumbers;
    }

    public void setYearStuNumbers(int yearStuNumbers) {
        this.yearStuNumbers = yearStuNumbers;
    }

    public String getDescribee() {
        return describee;
    }

    public void setDescribee(String describee) {
        this.describee = describee;
    }

    public String getContectName() {
        return contectName;
    }

    public void setContectName(String contectName) {
        this.contectName = contectName;
    }

    public String getContactPosition() {
        return contactPosition;
    }

    public void setContactPosition(String contactPosition) {
        this.contactPosition = contactPosition;
    }

    public String getIsQiyeQQ() {
        return isQiyeQQ;
    }

    public void setIsQiyeQQ(String isQiyeQQ) {
        this.isQiyeQQ = isQiyeQQ;
    }

    public String getTimee() {
        return timee;
    }

    public void setTimee(String timee) {
        this.timee = timee;
    }

    public String getIsEnroll() {
        return isEnroll;
    }

    public void setIsEnroll(String isEnroll) {
        this.isEnroll = isEnroll;
    }

    public int getTid() {
        return tid;
    }

    public void setTid(int tid) {
        this.tid = tid;
    }

    public String getTname() {
        return tname;
    }

    public void setTname(String tname) {
        this.tname = tname;
    }
}
