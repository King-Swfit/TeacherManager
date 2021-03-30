package com.haitong.youcai.entity;

import java.util.List;

/**
 * Created by Administrator on 2019/5/5.
 */
public class News {
    private int id;
    private String title;
    private String content;
    private String classcode;
    private ClassTeacher classTeacher;
    private int authorId;
    private String createTime;
    private List<NewsImg> imgUrls;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public ClassTeacher getClassTeacher() {
        return classTeacher;
    }

    public void setClassTeacher(ClassTeacher classTeacher) {
        this.classTeacher = classTeacher;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public List<NewsImg> getImgUrls() {
        return imgUrls;
    }

    public void setImgUrls(List<NewsImg> imgUrls) {
        this.imgUrls = imgUrls;
    }
}
