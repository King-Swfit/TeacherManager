package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/4/1.
 */
@Repository
public interface JiaoWuMapper {

    List<Center> getCenterList();

    List<Teacher> getTeacherList();
    int getTeacherIdBytel(String tel);
    int insertNewCenter(String cname, String address, int tid, String cdate);

    Center getCenterById(int cid);
    Center getCenterById2(int cid);

    int updateCenter(int cid, String cname, String address, int chargerId);

    int deleteCenter(int cid);

    List<Direction> getDirectionInfo();

    int insertNewDirection(String dname, String describe, int tid, String ddate);

    int updateDirection(int did, String dname, String describe, Integer chargerId);

    int deleteDirection(int did);

    List<Direction> getDirectionList();

    Direction getDirectionById(int did);

    List<ClassTeacher> getClassTeacherList();

    int insertBeforeClassTeacher(ClassTeacher classTeacher);
    int insertNewClassTeacher(String ctname, String gender, String tel, String email, int centerId, String createTime);

    int updateClassteacher(int ctid, String ctname, String tel, String email, String leavedate, String leaveReason, String centerId, String state, String gender);

    List<Position> getPositionList();

    int insertNewTeacher(Teacher_t teacher_t);

    int updateTeacher(Teacher_t teacher_t);

    List<Course> getCourseList();

    int insertNewCourse(Course_t course_t);

    int getCourseId(int directionId, String cname);

    int insertChapters(List<Chapter> chapters);

    List<Chapter> getChaptersByCid(int cid);

    Center getCenterByPartCName(String info);

    Direction getDirectionByPartDName(String info);

    List<String> getXuejiUpdateTypes();

    List<BaseinfoForTrainee> getXuejiInfoByClassCode(String classcode);

    int saveXuejiInfo(Xueji xueji);

    List<Xueji> getXuejiInfo(String classcode);

    int updateXuejiInfo(Xueji xueji);

    List<ClassGeneralInfo> getClassGeneralInfoByCondition(ClassQueryCondition classQueryCondition);

    Center getCenterByCenterId(int centerId);

    Direction getDirectionByDirectionId(int directionId);

    Xueji getXuejiById(String id);

    int createXueji(Xueji xueji);


    int updateXuejiImage(String id, String newFileName);

    String getImgProofById(int id);
    List<Xueji> getXuejiDetail(String classcode);

    int updateCourse(Course_t course_t);

    int updateChapters(List<Chapter> chapters);

    List<Teacher> getTeacherByCondition(String startTime, String endTime, int pid, int tid);

    List<ClassTeacher> getClassTeachersByCondition(String startTime, String endTime, int cid, int ctid);


    List<KV> getXiuxueFuXue_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getChongxiuRuban_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getZhuanruBenban_XuejiSummary(XuejiCondition xuejiCondition);


    List<KV> getZhuanquBieban_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getChongxiuLiban_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getXiuxueLiban_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getZizhuZeye_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getTuifeiRenshu_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getShilianRenshu_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getTuixueRenshu_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getZizhuZeyeForNot3_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getTuifeiRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getShilianRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getXiuxuebufuxueForNot3_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getTuixueRenshuForNot3_XuejiSummary(XuejiCondition xuejiCondition);

    List<KV> getJiebanRenshu_Summary(XuejiCondition xuejiCondition);

    List<KV> getKaibanRenshu_Summary(XuejiCondition xuejiCondition);

    List<KV> getTuichiJiuye_Summary(XuejiCondition xuejiCondition);

    List<KV> getJinrujiuyeRenshu_Summary(XuejiCondition xuejiCondition);

    List<KV> getYijiuyeRenshu_Summary(XuejiCondition xuejiCondition);

    int updateTraineeState(String code, String type);

    int insertNewCenter2(String cname, String caddress, String cdate);

    int insertNewDirection2(String dname, String describe,String ddate);

    List<Center> getCenterList2();

    Teacher getTeacherByTid(int tid);

    List<Direction> getDirectionInfo2();

    List<Teacher> getTeacherList2();

    Direction getDirectionById2(int did);

    List<Integer> getCourseIdByDirectionId(int did);

    List<Xueji> getXuejiByName(String name);

    void updateTraineeClasscode(String code, String classcode);

    void updateScoreClasscode(String code, String classcode);

    void updateInterviewClasscode(String code, String classcode);

    void saveSwitchTo(Xueji xueji);

    List<Xueji> getSwitchXuejiDetail(String classcode);
    

    List<Xueji> getXuejiDetailFromCenterId(@Param("centerId") int centerId);

    List<Xueji> getSwitchXuejiDetailFromCenterId(@Param("centerId") int centerId);

    List<Xueji> getXuejiDetailFromDirectionId(@Param("directionId") int directionId);

    List<Xueji> getSwitchXuejiDetailFromDirectionId(@Param("directionId") int directionId);

    List<Xueji> getXuejiDetailFromClassteacherId(@Param("classteacherId") int classteacherId);

    List<Xueji> getSwitchXuejiDetailFromClassteacherId(@Param("classteacherId") int classteacherId);


    List<Teacher> getTeacherListForBetweenTime(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<Direction> getDirectionInfoForBetweenTime(@Param("startTime") String startTime, @Param("endTime") String endTime);
}
