package com.haitong.youcai.entity;

import java.util.List;

/**
 * Created by Administrator on 2019/4/11.
 */
public class Course {
    private int cid;
    private String cname;
    private String describe;
    private String createTime;
    private int posInDirection;
    private Direction direction;
    private List<Chapter> chapters;

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

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public Direction getDirection() {
        return direction;
    }

    public void setDirection(Direction direction) {
        this.direction = direction;
    }

    public List<Chapter> getChapters() {
        return chapters;
    }

    public void setChapters(List<Chapter> chapters) {
        this.chapters = chapters;
    }

    public int getPosInDirection() {
        return posInDirection;
    }

    public void setPosInDirection(int posInDirection) {
        this.posInDirection = posInDirection;
    }
}
