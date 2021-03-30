package com.haitong.youcai.entity;

import java.util.Date;

public class BaseinfoForTrainee {
    private Integer id;
    private String code;

    private String name;

    private String gender;
    private Integer directionId;
    private String dname;//方向名
    private Integer CenterId;
    private String card;
    private String classcode;
    private String ctname;//班主任
    private String diploma;
    private String graducateTime;
    private String profession;
    private String graduateSchool;

    private String cname;

    private String tel;
    private String email;
    private String contact;
    private String contactTel;

    private String lendWay;

    private String payproof;
    private String diplomaImg;
    private String employImg;
    private String cardImg1;
    private String cardImg2;

    private String state;

    private EmployInfoForTrainee employInfoForTrainee;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code == null ? null : code.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getCard() {
        return card;
    }

    public void setCard(String card) {
        this.card = card == null ? null : card.trim();
    }

    public String getDiploma() {
        return diploma;
    }

    public void setDiploma(String diploma) {
        this.diploma = diploma == null ? null : diploma.trim();
    }

    public Integer getDirectionId() {
        return directionId;
    }

    public void setDirectionId(Integer directionId) {
        this.directionId = directionId;
    }

    public String getProfession() {
        return profession;
    }

    public void setProfession(String profession) {
        this.profession = profession == null ? null : profession.trim();
    }



    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel == null ? null : tel.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact == null ? null : contact.trim();
    }

    public String getContactTel() {
        return contactTel;
    }

    public void setContactTel(String contactTel) {
        this.contactTel = contactTel == null ? null : contactTel.trim();
    }

    public String getLendWay() {
        return lendWay;
    }

    public void setLendWay(String lendWay) {
        this.lendWay = lendWay == null ? null : lendWay.trim();
    }

    public String getPayproof() {
        return payproof;
    }

    public void setPayproof(String payproof) {
        this.payproof = payproof == null ? null : payproof.trim();
    }

    public String getDiplomaImg() {
        return diplomaImg;
    }

    public void setDiplomaImg(String diplomaImg) {
        this.diplomaImg = diplomaImg == null ? null : diplomaImg.trim();
    }

    public String getEmployImg() {
        return employImg;
    }

    public void setEmployImg(String employImg) {
        this.employImg = employImg == null ? null : employImg.trim();
    }

    public String getCardImg1() {
        return cardImg1;
    }

    public void setCardImg1(String cardImg1) {
        this.cardImg1 = cardImg1 == null ? null : cardImg1.trim();
    }

    public String getCardImg2() {
        return cardImg2;
    }

    public void setCardImg2(String cardImg2) {
        this.cardImg2 = cardImg2 == null ? null : cardImg2.trim();
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public String getGraducateTime() {
        return graducateTime;
    }

    public void setGraducateTime(String graducateTime) {
        this.graducateTime = graducateTime;
    }

    public String getGraduateSchool() {
        return graduateSchool;
    }

    public void setGraduateSchool(String graduateSchool) {
        this.graduateSchool = graduateSchool;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public Integer getCenterId() {
        return CenterId;
    }

    public void setCenterId(Integer centerId) {
        CenterId = centerId;
    }



    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public EmployInfoForTrainee getEmployInfoForTrainee() {
        return employInfoForTrainee;
    }

    public void setEmployInfoForTrainee(EmployInfoForTrainee employInfoForTrainee) {
        this.employInfoForTrainee = employInfoForTrainee;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }
}