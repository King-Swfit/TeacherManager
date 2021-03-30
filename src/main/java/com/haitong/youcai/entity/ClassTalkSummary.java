package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/5/14.
 */
public class ClassTalkSummary {
    private String classcode;

    private int modi;//首席摸底访谈
    private int chuqin_except_count;//出勤异常总人次
    private int getChuqin_except_change;//出勤异常改进人次

    private int zuoye_except_count;//作业异常
    private int getZuoye_except_change;

    private int score_except_count;//成绩异常
    private int getScore_except_change;

    private int wandan_count;//退费挽单
    private int wandan_change;

    private int koubei_count;//口碑
    private int koubei_submit;
    private int koubei_signup;

    private int yunwei_count;//转运维
    private int yunwei_change;

    private int xuejichange;//学籍变更
    private int jiuye_intention;//就业意向
    private int jiuyezhidao;//就业指导

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public int getModi() {
        return modi;
    }

    public void setModi(int modi) {
        this.modi = modi;
    }

    public int getChuqin_except_count() {
        return chuqin_except_count;
    }

    public void setChuqin_except_count(int chuqin_except_count) {
        this.chuqin_except_count = chuqin_except_count;
    }

    public int getGetChuqin_except_change() {
        return getChuqin_except_change;
    }

    public void setGetChuqin_except_change(int getChuqin_except_change) {
        this.getChuqin_except_change = getChuqin_except_change;
    }

    public int getZuoye_except_count() {
        return zuoye_except_count;
    }

    public void setZuoye_except_count(int zuoye_except_count) {
        this.zuoye_except_count = zuoye_except_count;
    }

    public int getGetZuoye_except_change() {
        return getZuoye_except_change;
    }

    public void setGetZuoye_except_change(int getZuoye_except_change) {
        this.getZuoye_except_change = getZuoye_except_change;
    }

    public int getScore_except_count() {
        return score_except_count;
    }

    public void setScore_except_count(int score_except_count) {
        this.score_except_count = score_except_count;
    }

    public int getGetScore_except_change() {
        return getScore_except_change;
    }

    public void setGetScore_except_change(int getScore_except_change) {
        this.getScore_except_change = getScore_except_change;
    }

    public int getWandan_count() {
        return wandan_count;
    }

    public void setWandan_count(int wandan_count) {
        this.wandan_count = wandan_count;
    }

    public int getWandan_change() {
        return wandan_change;
    }

    public void setWandan_change(int wandan_change) {
        this.wandan_change = wandan_change;
    }

    public int getKoubei_count() {
        return koubei_count;
    }

    public void setKoubei_count(int koubei_count) {
        this.koubei_count = koubei_count;
    }

    public int getKoubei_submit() {
        return koubei_submit;
    }

    public void setKoubei_submit(int koubei_submit) {
        this.koubei_submit = koubei_submit;
    }

    public int getKoubei_signup() {
        return koubei_signup;
    }

    public void setKoubei_signup(int koubei_signup) {
        this.koubei_signup = koubei_signup;
    }

    public int getYunwei_count() {
        return yunwei_count;
    }

    public void setYunwei_count(int yunwei_count) {
        this.yunwei_count = yunwei_count;
    }

    public int getYunwei_change() {
        return yunwei_change;
    }

    public void setYunwei_change(int yunwei_change) {
        this.yunwei_change = yunwei_change;
    }

    public int getXuejichange() {
        return xuejichange;
    }

    public void setXuejichange(int xuejichange) {
        this.xuejichange = xuejichange;
    }

    public int getJiuye_intention() {
        return jiuye_intention;
    }

    public void setJiuye_intention(int jiuye_intention) {
        this.jiuye_intention = jiuye_intention;
    }

    public int getJiuyezhidao() {
        return jiuyezhidao;
    }

    public void setJiuyezhidao(int jiuyezhidao) {
        this.jiuyezhidao = jiuyezhidao;
    }
}
