package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/8.
 */
public class Xueji {
    private int id;
    private String code;
    private String name;
    private String classcode;
    private String type;
    private String content;
    private String reason;
    private String result;
    private String timee;
    private String imgProof;
    private String targetClasscode;//目标班，对应转班和重修


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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getTimee() {
        return timee;
    }

    public void setTimee(String timee) {
        this.timee = timee;
    }

    public String getImgProof() {
        return imgProof;
    }

    public void setImgProof(String imgProof) {
        this.imgProof = imgProof;
    }

    public String getTargetClasscode() {
        return targetClasscode;
    }

    public void setTargetClasscode(String targetClasscode) {
        this.targetClasscode = targetClasscode;
    }
}
