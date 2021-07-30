package com.haitong.youcai.service;

import com.haitong.youcai.entity.*;
import com.haitong.youcai.mapper.JiaoWuMapper;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Administrator on 2019/3/27.
 */
@Service
public class JiaoWuService {
    @Autowired
    private JiaoWuMapper jiaoWuMapper;


    public List<Center> getCenterList(){
        //return jiaoWuMapper.getCenterList();
        List<Center> centers = getCenterList2();
        for(Center c:centers){
            Integer tid = c.getChargerId();
            if(tid != null){
                Teacher teacher = getTeacherByTid(tid);
                c.setCharger(teacher);
            }
        }
        return centers;
    }

    public List<Teacher> getTeacherList(){
        return jiaoWuMapper.getTeacherList();
        //return jiaoWuMapper.getTeacherList2();
    }

    public int insertNewCenter(String cname, String caddress, String ctel) {
        if(ctel == ""){
            String cdate = Tool.getCurrentDate();
            return jiaoWuMapper.insertNewCenter2(cname, caddress, cdate);
        }else{
            int tid = jiaoWuMapper.getTeacherIdBytel(ctel);
            String cdate = Tool.getCurrentDate();
            return jiaoWuMapper.insertNewCenter(cname, caddress, tid, cdate);
        }


    }

    public Center getCenterById(int cid) {
        //return jiaoWuMapper.getCenterById(cid);
        Center c = jiaoWuMapper.getCenterById2(cid);
        Integer tid = c.getChargerId();
        if(tid != null){
            Teacher teacher = getTeacherByTid(tid);
            c.setCharger(teacher);

        }
        return c;
    }

    public int updateCenter(int cid, String cname, String caddress, int chargerId) {
        return jiaoWuMapper.updateCenter(cid, cname, caddress, chargerId);
    }

    public int deleteCenter(int cid) {
        return jiaoWuMapper.deleteCenter(cid);
    }


    public List<Direction> getDirectionInfo() {
//        return jiaoWuMapper.getDirectionInfo();
        List<Direction> directions = jiaoWuMapper.getDirectionInfo2();
        for(Direction d:directions){
            Integer tid = d.getChargerId();
            if(null != tid){
                Teacher teacher = getTeacherByTid(tid);
                d.setCharger(teacher);
            }

        }

        return directions;
    }

    public int insertNewDirection(String dname, String describe, String tel) {
        int tid = jiaoWuMapper.getTeacherIdBytel(tel);
        String ddate = Tool.getCurrentDate();
        return jiaoWuMapper.insertNewDirection(dname, describe, tid, ddate);
    }

    public int insertNewDirection2(String dname, String describe) {
        String ddate = Tool.getCurrentDate();
        return jiaoWuMapper.insertNewDirection2(dname, describe,ddate);
    }

    public int updateDirection(int did, String dname, String describe, Integer chargerId) {
        return jiaoWuMapper.updateDirection(did, dname, describe, chargerId);
    }

    public int deleteDirection(int did) {
        return jiaoWuMapper.deleteDirection(did);
    }

//    public List<Direction> getDirectionList() {
//        return jiaoWuMapper.getDirectionList();
//    }

    public Direction getDirectionById(int did) {
        //return jiaoWuMapper.getDirectionById(did);
        Direction d =  jiaoWuMapper.getDirectionById2(did);
        Integer tid = d.getChargerId();
        if(null != tid){
            Teacher teacher = getTeacherByTid(tid);
            d.setCharger(teacher);
        }
        return d;
    }

    public List<ClassTeacher> getClassTeacherList() {
        return jiaoWuMapper.getClassTeacherList();
    }

    public int insertNewClassTeacher(String ctname, String gender, String tel, String email, int centerId, String createTime) {
        return jiaoWuMapper.insertNewClassTeacher(ctname, gender, tel, email, centerId, createTime);
    }

    public int updateClassteacher(int ctid, String ctname, String tel, String email, String leavedate, String leaveReason, String centerId, String state, String gender) {
        return jiaoWuMapper.updateClassteacher(ctid, ctname, tel, email, leavedate,leaveReason, centerId,state,gender);
    }

    public List<Position> getPositionList() {
        return jiaoWuMapper.getPositionList();
    }

    public int insertNewTeacher(Teacher_t teacher_t) {
        return jiaoWuMapper.insertNewTeacher(teacher_t);
    }

    public int updateTeacher(Teacher_t teacher_t) {
        return jiaoWuMapper.updateTeacher(teacher_t);
    }

    public List<Course> getCourseList() {
        return jiaoWuMapper.getCourseList();
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public boolean insertNewCourse(Course_t course_t) {
        boolean isSuccess = false;
        int result = jiaoWuMapper.insertNewCourse(course_t);
        if(result > 0){
            int cid = jiaoWuMapper.getCourseId(course_t.getDirectionId(),course_t.getCname());
            List<Chapter> chapters = course_t.getChapters();
            for(Chapter chapter:chapters){
                chapter.setCourseId(cid);
            }

            jiaoWuMapper.insertChapters(chapters);
            isSuccess = true;
        }

        return isSuccess;
    }

    public List<Chapter> getChaptersByCid(int cid) {
        return jiaoWuMapper.getChaptersByCid(cid);
    }

    public Center getCenterByPartCName(String info) {
        return jiaoWuMapper.getCenterByPartCName(info);
    }

    public Direction getDirectionByPartDName(String info) {
        return jiaoWuMapper.getDirectionByPartDName(info);
    }

    public List<BaseinfoForTrainee> getXuejiInfoByClassCode(String classcode) {
        return jiaoWuMapper.getXuejiInfoByClassCode(classcode);
    }

    public int saveXuejiInfo(Xueji xueji) {
        int result = -1;
        result = jiaoWuMapper.saveXuejiInfo(xueji);
        if(result > 0){
            String type = xueji.getType();
            if(type.equals("转班")||type.equals("重修")){
                jiaoWuMapper.saveSwitchTo(xueji);

                String classcode = xueji.getTargetClasscode();
                String code = xueji.getCode();
                //更新三个和班级相关状态
                jiaoWuMapper.updateTraineeClasscode(code,classcode);

//                jiaoWuMapper.updateScoreClasscode(code,classcode);
//                jiaoWuMapper.updateInterviewClasscode(code,classcode);
            }
            //先修改班级学员状态
            result = jiaoWuMapper.updateTraineeState(xueji.getCode(), xueji.getType());
        }

        return result;
    }

    public List<Xueji> getXuejiInfo(String classcode) {
        return jiaoWuMapper.getXuejiInfo(classcode);
    }

    public int updateXuejiInfo(Xueji xueji) {
        int result = -1;
        result = jiaoWuMapper.updateXuejiInfo(xueji);
        if(result > 0){
            String type = xueji.getType();
            if(type.equals("转班")||type.equals("重修")){
                jiaoWuMapper.saveSwitchTo(xueji);

                String classcode = xueji.getTargetClasscode();
                String code = xueji.getCode();
                //更新三个和班级相关状态
                jiaoWuMapper.updateTraineeClasscode(code,classcode);
//                jiaoWuMapper.updateScoreClasscode(code,classcode);
//                jiaoWuMapper.updateInterviewClasscode(code,classcode);
            }
            result = jiaoWuMapper.updateTraineeState(xueji.getCode(), xueji.getType());
        }
        return result;
    }

    public Center getCenterByCenterId(int centerId) {
        return jiaoWuMapper.getCenterByCenterId(centerId);
    }

    public Direction getDirectionByDirectionId(int directionId) {
        return jiaoWuMapper.getDirectionByDirectionId(directionId);
    }


    public Xueji getXuejiById(String id) {
        return jiaoWuMapper.getXuejiById(id);
    }



    public int createXueji(Xueji xueji) {
        return jiaoWuMapper.createXueji(xueji);
    }

    public int updateXuejiImage(String id, String newFileName) {
        return jiaoWuMapper.updateXuejiImage(id, newFileName);
    }

    public String getImgProofById(int id) {
        return jiaoWuMapper.getImgProofById(id);
    }

    public List<Xueji> getXuejiDetail(String classcode){
        return jiaoWuMapper.getXuejiDetail(classcode);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int updateCourse(Course_t course_t) {
        int result = -1;
        result = jiaoWuMapper.updateCourse(course_t);
        if(result > 0){
            List<Chapter> chapters = course_t.getChapters();
            List<Chapter> chapters2 = jiaoWuMapper.getChaptersByCid(course_t.getCid());
            for(int i = 0; i < chapters.size(); i++){
                chapters.get(i).setCpid(chapters2.get(i).getCpid());
            }

            result = jiaoWuMapper.updateChapters(chapters);
        }
        return result;
    }

    public List<Teacher> getTeacherByCondition(String startTime, String endTime, int pid, int tid) {
        return jiaoWuMapper.getTeacherByCondition(startTime, endTime, pid, tid);
    }

    public List<ClassTeacher> getClassTeachersByCondition(String startTime, String endTime, int cid, int ctid) {
        return jiaoWuMapper.getClassTeachersByCondition(startTime, endTime, cid, ctid);
    }

    public List<KV> getXiuxueFuXue_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getXiuxueFuXue_XuejiSummary(xuejiCondition);
    }

    public List<KV> getChongxiuRuban_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getChongxiuRuban_XuejiSummary(xuejiCondition);
    }

    public List<KV> getZhuanruBenban_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getZhuanruBenban_XuejiSummary(xuejiCondition);
    }

    public List<KV> getZhuanquBieban_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getZhuanquBieban_XuejiSummary(xuejiCondition);
    }

    public List<KV> getChongxiuLiban_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getChongxiuLiban_XuejiSummary(xuejiCondition);
    }

    public List<KV> getXiuxueLiban_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getXiuxueLiban_XuejiSummary(xuejiCondition);
    }

    public List<KV> getZizhuZeye_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getZizhuZeye_XuejiSummary(xuejiCondition);
    }

    public List<KV> getTuifeiRenshu_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getTuifeiRenshu_XuejiSummary(xuejiCondition);
    }

    public List<KV> getShilianRenshu_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getShilianRenshu_XuejiSummary(xuejiCondition);
    }

    public List<KV> getTuixueRenshu_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getTuixueRenshu_XuejiSummary(xuejiCondition);
    }

    public List<KV> getZizhuZeyeForNot3_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getZizhuZeyeForNot3_XuejiSummary(xuejiCondition);
    }

    public List<KV> getTuifeiRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getTuifeiRenshuForNot3_XuejiSummary(xuejiCondition);
    }

    public List<KV> getShilianRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getShilianRenshuForNot3_XuejiSummary(xuejiCondition);
    }

    public List<KV> getXiuxuebufuxueForNot3_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getXiuxuebufuxueForNot3_XuejiSummary(xuejiCondition);
    }

    public List<KV> getTuixueRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getTuixueRenshuForNot3_XuejiSummary(xuejiCondition);
    }

    public List<KV> getJiebanRenshu_Summary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getJiebanRenshu_Summary(xuejiCondition);
    }

    public List<KV> getKaibanRenshu_Summary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getKaibanRenshu_Summary(xuejiCondition);
    }

    public List<KV> getTuichiJiuye_Summary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getTuichiJiuye_Summary(xuejiCondition);
    }

    public List<KV> getJinrujiuyeRenshu_Summary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getJinrujiuyeRenshu_Summary(xuejiCondition);
    }

    public List<KV> getYijiuyeRenshu_Summary(XuejiCondition xuejiCondition) {
        return jiaoWuMapper.getYijiuyeRenshu_Summary(xuejiCondition);
    }


    public List<Center> getCenterList2() {
        return jiaoWuMapper.getCenterList2();
    }

    public Teacher getTeacherByTid(int tid) {
        return jiaoWuMapper.getTeacherByTid(tid);
    }

    public List<Integer> getCourseIdByDirectionId(int did) {
        return jiaoWuMapper.getCourseIdByDirectionId(did);
    }

    public List<Direction> getDirectionInfo2() {
        return jiaoWuMapper.getDirectionInfo2();
    }

    public List<Xueji> getXuejiByName(String name) {
        return jiaoWuMapper.getXuejiByName(name);
    }

    public List<Xueji> getXuejiByCode(String code) {
        return jiaoWuMapper.getXuejiByCode(code);
    }

    public List<Xueji> getSwitchXuejiDetail(String classcode) {
        return jiaoWuMapper.getSwitchXuejiDetail(classcode);
    }


    public List<Xueji> getXuejiDetailFromCenterId(int value) {
        return jiaoWuMapper.getXuejiDetailFromCenterId(value);
    }

    public List<Xueji> getSwitchXuejiDetailFromCenterId(int value) {
        return jiaoWuMapper.getSwitchXuejiDetailFromCenterId(value);

    }

    public List<Xueji> getXuejiDetailFromDirectionId(Integer value) {
        return jiaoWuMapper.getXuejiDetailFromDirectionId(value);
    }

    public List<Xueji> getSwitchXuejiDetailFromDirectionId(Integer value) {
        return jiaoWuMapper.getSwitchXuejiDetailFromDirectionId(value);
    }

    public List<Xueji> getXuejiDetailFromClassteacherId(Integer value) {
        return jiaoWuMapper.getXuejiDetailFromClassteacherId(value);
    }

    public List<Xueji> getSwitchXuejiDetailFromClassteacherId(Integer value) {
        return jiaoWuMapper.getSwitchXuejiDetailFromClassteacherId(value);
    }

    public List<Teacher> getTeacherListForRecent() {
        String endTime=Tool.getCurrentDate();
        String startTime=Tool.getLastYearDate();
        return jiaoWuMapper.getTeacherListForBetweenTime(startTime, endTime);
    }

    public List<Teacher> getTeacherListForBetweenTime(String startTime, String endTime) {
        return jiaoWuMapper.getTeacherListForBetweenTime(startTime, endTime);
    }

    public List<Direction> getDirectionInfoForBetweenTime(String startTime, String endTime) {
        return jiaoWuMapper.getDirectionInfoForBetweenTime(startTime, endTime);
    }
}
