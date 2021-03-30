package com.haitong.youcai.entity;

/**
 * Created by Administrator on 2019/6/5.
 */
public class XuejiSummary {
    private String classcode;
    private String dname;//课程方向
    private String ctname;//班主任方向
    private String state;//班级状态

    private int xiuxuefuxue_add;//休学复学
    private int chongxiuruban_add;//重修入班
    private int zhuanrubenban_add;//转入本班

    private int zhuanqubieban_sub;//转去别班
    private int chongxiuliban_sub;//重修离班
    private int xiuxuelibanrenshu_sub;//休学离班人数
    private int zizhuzeyerenshu_sub;//自主择业人数
    private int tuifeirenshu_sub;//退费人数
    private int shilianrenshu_sub;//失联人数
    private int tuixuerenshu_sub;//退学人数

    private int weiman3yuezizhuzeye_liushi;//未满3个月自主择业
    private int tuifeirenshu_liushi;//退费人数
    private int shilianrenshu_liushi;//失联人数
    private int xiuxuebufuxue_liushi;//未满3个月的休学不复学
    private int tuixuerenshu_liushi;//未满3个月的退学人数

    private int fuxuerenshu_summary;//复学人数
    private int jiebanrenshu_summary;//结班人数
    private float liushilv_summary;//流失率
    private int tuichijiuye_summary;//推迟就业
    private int zizhuzeyerenshu_summary;//自主择业人数
    private int jinrujiuyerenshu_summary;//进入就业人数
    private int bufuhejiuyerenshu_summary;//不符合就业人数
    private int yijiuyerenshu_summary;//已就业人数
    private float jiuyelv_summary;    //就业率
    private int renzhenghegerenshu_summary;//认证合格人数
    private int renzhenghegetongguo_summary;//认证合格通过
    private String comment_summary;//备注

    public String getClasscode() {
        return classcode;
    }

    public void setClasscode(String classcode) {
        this.classcode = classcode;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

    public String getCtname() {
        return ctname;
    }

    public void setCtname(String ctname) {
        this.ctname = ctname;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public int getXiuxuefuxue_add() {
        return xiuxuefuxue_add;
    }

    public void setXiuxuefuxue_add(int xiuxuefuxue_add) {
        this.xiuxuefuxue_add = xiuxuefuxue_add;
    }

    public int getChongxiuruban_add() {
        return chongxiuruban_add;
    }

    public void setChongxiuruban_add(int chongxiuruban_add) {
        this.chongxiuruban_add = chongxiuruban_add;
    }

    public int getZhuanrubenban_add() {
        return zhuanrubenban_add;
    }

    public void setZhuanrubenban_add(int zhuanrubenban_add) {
        this.zhuanrubenban_add = zhuanrubenban_add;
    }

    public int getZhuanqubieban_sub() {
        return zhuanqubieban_sub;
    }

    public void setZhuanqubieban_sub(int zhuanqubieban_sub) {
        this.zhuanqubieban_sub = zhuanqubieban_sub;
    }

    public int getChongxiuliban_sub() {
        return chongxiuliban_sub;
    }

    public void setChongxiuliban_sub(int chongxiuliban_sub) {
        this.chongxiuliban_sub = chongxiuliban_sub;
    }

    public int getXiuxuelibanrenshu_sub() {
        return xiuxuelibanrenshu_sub;
    }

    public void setXiuxuelibanrenshu_sub(int xiuxuelibanrenshu_sub) {
        this.xiuxuelibanrenshu_sub = xiuxuelibanrenshu_sub;
    }

    public int getZizhuzeyerenshu_sub() {
        return zizhuzeyerenshu_sub;
    }

    public void setZizhuzeyerenshu_sub(int zizhuzeyerenshu_sub) {
        this.zizhuzeyerenshu_sub = zizhuzeyerenshu_sub;
    }

    public int getTuifeirenshu_sub() {
        return tuifeirenshu_sub;
    }

    public void setTuifeirenshu_sub(int tuifeirenshu_sub) {
        this.tuifeirenshu_sub = tuifeirenshu_sub;
    }

    public int getShilianrenshu_sub() {
        return shilianrenshu_sub;
    }

    public void setShilianrenshu_sub(int shilianrenshu_sub) {
        this.shilianrenshu_sub = shilianrenshu_sub;
    }

    public int getTuixuerenshu_sub() {
        return tuixuerenshu_sub;
    }

    public void setTuixuerenshu_sub(int tuixuerenshu_sub) {
        this.tuixuerenshu_sub = tuixuerenshu_sub;
    }

    public int getWeiman3yuezizhuzeye_liushi() {
        return weiman3yuezizhuzeye_liushi;
    }

    public void setWeiman3yuezizhuzeye_liushi(int weiman3yuezizhuzeye_liushi) {
        this.weiman3yuezizhuzeye_liushi = weiman3yuezizhuzeye_liushi;
    }

    public int getTuifeirenshu_liushi() {
        return tuifeirenshu_liushi;
    }

    public void setTuifeirenshu_liushi(int tuifeirenshu_liushi) {
        this.tuifeirenshu_liushi = tuifeirenshu_liushi;
    }

    public int getShilianrenshu_liushi() {
        return shilianrenshu_liushi;
    }

    public void setShilianrenshu_liushi(int shilianrenshu_liushi) {
        this.shilianrenshu_liushi = shilianrenshu_liushi;
    }

    public int getXiuxuebufuxue_liushi() {
        return xiuxuebufuxue_liushi;
    }

    public void setXiuxuebufuxue_liushi(int xiuxuebufuxue_liushi) {
        this.xiuxuebufuxue_liushi = xiuxuebufuxue_liushi;
    }

    public int getTuixuerenshu_liushi() {
        return tuixuerenshu_liushi;
    }

    public void setTuixuerenshu_liushi(int tuixuerenshu_liushi) {
        this.tuixuerenshu_liushi = tuixuerenshu_liushi;
    }

    public int getFuxuerenshu_summary() {
        return fuxuerenshu_summary;
    }

    public void setFuxuerenshu_summary(int fuxuerenshu_summary) {
        this.fuxuerenshu_summary = fuxuerenshu_summary;
    }

    public int getJiebanrenshu_summary() {
        return jiebanrenshu_summary;
    }

    public void setJiebanrenshu_summary(int jiebanrenshu_summary) {
        this.jiebanrenshu_summary = jiebanrenshu_summary;
    }

    public float getLiushilv_summary() {
        return liushilv_summary;
    }

    public void setLiushilv_summary(float liushilv_summary) {
        this.liushilv_summary = liushilv_summary;
    }

    public int getTuichijiuye_summary() {
        return tuichijiuye_summary;
    }

    public void setTuichijiuye_summary(int tuichijiuye_summary) {
        this.tuichijiuye_summary = tuichijiuye_summary;
    }

    public int getZizhuzeyerenshu_summary() {
        return zizhuzeyerenshu_summary;
    }

    public void setZizhuzeyerenshu_summary(int zizhuzeyerenshu_summary) {
        this.zizhuzeyerenshu_summary = zizhuzeyerenshu_summary;
    }

    public int getJinrujiuyerenshu_summary() {
        return jinrujiuyerenshu_summary;
    }

    public void setJinrujiuyerenshu_summary(int jinrujiuyerenshu_summary) {
        this.jinrujiuyerenshu_summary = jinrujiuyerenshu_summary;
    }

    public int getBufuhejiuyerenshu_summary() {
        return bufuhejiuyerenshu_summary;
    }

    public void setBufuhejiuyerenshu_summary(int bufuhejiuyerenshu_summary) {
        this.bufuhejiuyerenshu_summary = bufuhejiuyerenshu_summary;
    }

    public int getYijiuyerenshu_summary() {
        return yijiuyerenshu_summary;
    }

    public void setYijiuyerenshu_summary(int yijiuyerenshu_summary) {
        this.yijiuyerenshu_summary = yijiuyerenshu_summary;
    }

    public float getJiuyelv_summary() {
        return jiuyelv_summary;
    }

    public void setJiuyelv_summary(float jiuyelv_summary) {
        this.jiuyelv_summary = jiuyelv_summary;
    }

    public int getRenzhenghegerenshu_summary() {
        return renzhenghegerenshu_summary;
    }

    public void setRenzhenghegerenshu_summary(int renzhenghegerenshu_summary) {
        this.renzhenghegerenshu_summary = renzhenghegerenshu_summary;
    }

    public int getRenzhenghegetongguo_summary() {
        return renzhenghegetongguo_summary;
    }

    public void setRenzhenghegetongguo_summary(int renzhenghegetongguo_summary) {
        this.renzhenghegetongguo_summary = renzhenghegetongguo_summary;
    }

    public String getComment_summary() {
        return comment_summary;
    }

    public void setComment_summary(String comment_summary) {
        this.comment_summary = comment_summary;
    }
}
