package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/4/1.
 */
@Repository
public interface ClassMapper {
    List<Center> getCenterList();

    List<Direction> getDirectionList();

    List<ClassTeacher> getClassTeachersByCenterId(@Param("cid") Integer cid);

    List<Course_t> getCourseIdsByDirectionId(int directionId);

    List<SimpleTeacher> getTeachersByCid(Integer cid);

    Integer insertBaseInfos(BaseInfo_Class baseInfo_class);

    void insertCoursePlanItems(List<CoursePlanItem_Class> coursePlanItems);

    List<ClassGeneralInfo> getClassGeneralInfo();

    BaseInfo_Class getBaseInfoByClid(int clid);

    Integer updateBaseInfos(BaseInfo_Class baseInfo_class);

    void updateCoursePlanItems(@Param(value = "coursePlanItems") List<CoursePlanItem_Class> coursePlanItems);


    List<String> getClassCodesByCtid(int ctid);

    List<String> getClassCodesByCtidState(int ctid, String state);

//    List<String> getClassCodes(int ctid);

    List<String> getClassCodes();

    List<String> getClassCodesByState(int ctid, String state);

    List<BaseinfoForTrainee> getTrainBaseInfo(String classcode, String traineestate);

    Integer insertBaseInfos_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees);

    BaseInfo_Class getClidByClassCode(String classcode);

    ClassTeacher getClassTeacherByCtName(String ctname);


    Integer updatePayproofState(String classcode, String value);

    Integer updateDiplomaState(String classcode, String value);

    Integer updateWorkproofState(String classcode, String value);

    Integer updateCard1State(String classcode, String value);

    Integer updateCard2State(String classcode, String value);

    String getPhotoNameByCodeType_pay(String code);

    String getPhotoNameByCodeType_diploma(String code);

    String getPhotoNameByCodeType_work(String code);

    String getPhotoNameByCodeType_card1(String code);

    String getPhotoNameByCodeType_card2(String code);

    Integer createNews(News news);

    void createImgForNews(String uploadFileName, int newsId);

    void updateNews(int newsId, String title, String html);

    List<News> listNews(String classcode);

    String getNewsContentByNewsId(int newsId);

    List<String> getClassCodesByClidTime(int ctid, String startTime, String endTime);

    List<ComprehensiveScore_java> getComprehensiveScoreByClassCode_java(String classcode);

    List<ComprehensiveScore_ai> getComprehensiveScoreByClassCode_ai(String classcode);

    void createComprehensiveScoreInfos_batchTrainee_java(List<BaseinfoForTrainee> baseinfoForTrainees);

    void createComprehensiveScoreInfos_batchTrainee_ai(List<BaseinfoForTrainee> baseinfoForTrainees);

    void createComprehensiveBaseInfos_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees);

    void createEmployInfos_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees);

    Integer updateComprehensiveScoreByClassCode_java(ComprehensiveScore_java comprehensiveScore_java);

    Integer updateComprehensiveScoreByClassCode_ai(ComprehensiveScore_ai comprehensiveScore_ai);

    Integer updateComprehensiveScoreByClassCode_baseInfo(ComprehensiveScore_baseinfo comprehensivesScore_baseInfo);

    List<ClassGeneralInfo> getClassGeneralInfoByCondition(ClassQueryCondition classQueryCondition);

    List<String> listClassStates();

    List<String> getTraineeStates();

    List<String> getPayWays();

    List<String> getEmployWays();

    List<String> getDiplomaStates();

    List<BaseinfoForTrainee> getBaseInfoForTraineeByClassCode(String classcode);

    Integer getClassTeacherIdByClassCode(String classcode);

    String getCtnameByCtid(int ctid);

    Integer getDirectionIdByClassCode(String classcode);

    String getDnameByDid(int did);

    void insertBaseInfoForTrainee(BaseinfoForTrainee baseinfoForTrainee);

    int insertEmployInfoForTrainee(EmployInfoForTrainee employInfoForTrainee);

    BaseinfoForTrainee getBaseInfoForTraineeByCode(String code);

    void updateBaseInfoForTrainee(BaseinfoForTrainee baseinfoForTrainee);

    void updateEmployInfoForTrainee(EmployInfoForTrainee employInfoForTrainee);

    Integer createPayproofState(String code, String value);

    Integer createDiplomaState(String code, String value);

    Integer createWorkproofState(String code, String value);

    Integer createCard1State(String code, String value);

    Integer createCard2State(String code, String value);

    Integer createEmployInfo(String code);

    Integer createComprehensiveBaseInfo(String code);

    Integer createComprehensiveScoreInfo_java(String code);

    Integer createComprehensiveScoreInfo_ai(String code);

    Integer getCenterIdByCname(String cname);

    Integer createTraineeScores_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees);

    Integer createTraineeScore(BaseinfoForTrainee baseinfoForTrainee);

    List<String> listClasscode();

    List<KV> getInterviewCountForClass(int centerId, String startTime, String endTime);

    List<AvgSalary> getAvgSalaryForZhuan(int centerId, String startTime, String endTime);

    List<AvgSalary> getAvgSalaryForBen(int centerId, String startTime, String endTime);

    List<KV> getClassCount(String startTime, String endTime);

    List<InterviewPeriod> getInterviewPeriod(String startTime, String endTime);

    List<KV> getCountForInterviewSuccess(String startTime, String endTime);

    List<KV> getCountForDevSuccess(String startTime, String endTime);

    List<ClassGeneralInfo> getClassBaseInfo();

    List<KVStr> getClasscodeCTName();

    Integer updateScoreItem_java(String code, String timee, int score, String detail, String check_item);

    Integer updateScoreItem_ai(String code, String timee, int score, String detail, String check_item);

    List<KV> getInterviewCountForClass2(String classteacherId, String month);

    List<AvgSalary> getAvgSalaryForZhuan2(String classteacherId, String month);

    List<AvgSalary> getAvgSalaryForBen2(String classteacherId, String month);

    List<InterviewPeriod> getInterviewPeriod2(String classteacherId, String month);

    List<KV> getCountForInterviewSuccess2(String classteacherId, String month);

    List<KV> getCountForDevSuccess2(String classteacherId, String month);

    List<String> getClassStates();

    String getCNameByClasscode(String classcode);

    List<ClassGeneralInfo> getClassGeneralInfoByCondition2(ClassQueryCondition classQueryCondition);

    List<CoursePlanItem_Class> getCoursePlanByClasscode(String classcode);

    String getCourseNameByCourseId(int courseId);

    String getTeacherNameByTeacherId(int teacherId);

    List<String> getClassGeneralInfoByCondition3(ClassQueryCondition classQueryCondition);

    List<KVStr> getTrcodeCcodeByTrname(String name);

    List<KVStr> getTrcodeCcodeByCode(String code);

    String getTrnameByCode(String code);

    String getDirectionNameByClassCode(String classcode);

    List<String> getSectionsByDid(int did);

    String getDirectionNameByCode(String code);

    List<FKV> getCenterBenAvgSalary(String startTime, String endTime);

    List<FKV> getCenterZhuanAvgSalary(String startTime, String endTime);

    List<KV> getCenterInterviewTimes(String startTime, String endTime);

    List<KV> getCenterTraineeNumbers(String startTime, String endTime);

    List<KV> getTrcodePeriod(String startTime, String endTime);

    List<KVStr> listCodeCname(String startTime, String endTime);

    List<KV> getCnameDevNumbers(String startTime, String endTime);

    List<KV> getCnameWorkNumbers(String startTime, String endTime);

    List<FKV> getDirectionBenAvgSalary(String startTime, String endTime);

    List<FKV> getDirectionZhuanAvgSalary(String startTime, String endTime);

    List<KV> getDirectionInterviewTimes(String startTime, String endTime);

    List<KV> getDirectionTraineeNumbers();

    List<KVStr> listCodeDname(String startTime, String endTime);

    List<KV> getDnameDevNumbers(String startTime, String endTime);

    List<KV> getDnameWorkNumbers(String startTime, String endTime);


    Float getDevBenAvgSalary(String startTime, String endTime);

    Float getDevZhuanAvgSalary(String startTime, String endTime);

    Float getNotDevBenAvgSalary(String startTime, String endTime);

    Float getNotDevZhuanAvgSalary(String startTime, String endTime);

    Float getDevInterviewTimes(String startTime, String endTime);

    Float getDevTraineeNumbers(String startTime, String endTime);

    Float getNotDevInterviewTimes(String startTime, String endTime);

    Float getNotDevTraineeNumbers(String startTime, String endTime);

    List<Float> getDevTrcodePeriod(String startTime, String endTime);

    List<Float> getNotDevTrcodePeriod(String startTime, String endTime);

    String getCTNameByClassCode(String classcode);

    List<KV> getClassNumbers();

    List<BaseinfoForTrainee> mohuQueryByName(String name);

    List<BaseinfoForTrainee> mohuQueryByCode(String code);

    List<ComprehensiveScore_java> getComprehensiveScoreByCode_java(String code);

    List<ComprehensiveScore_ai> getComprehensiveScoreByCode_ai(String code);

    BaseinfoForTrainee getBaseInfoForTraineeByCode2(String code);

    Integer updateComprehensiveBaseinfo(ComprehensiveScore_baseinfo comprehensiveScore_baseinfo);

    ExistFile selectFileName(String fileNmae);

    Integer insertFileName(ExistFile e);


    String getClassCodesByClid2(int clid);

    void updateTraineeReadingByClasscode(String classcode);

    void updateTraineeEndClassByClasscode(String classcode);

    void updateClassExamDate(String classcode, String ttime);

    List<ClassTeacher> getValidClassTeachers();


    String getBeginDateByCode(String code);

    void updateTraineeClasscode(String code, String classcode);

    void saveArchiveForCodeClasscode(String code, String classcode);

    Integer insertBaseInfos_batchTrainee_one(BaseinfoForTrainee baseinfoForTrainee);

    Integer getAllCenterZhuanAvgSalary(String startTime, String endTime);

    Integer getAllCenterInterviewTimes(String startTime, String endTime);

    Integer getAllCenterTraineeNumbers(String startTime, String endTime);

    Integer getAllCenterBenAvgSalary(String startTime, String endTime);

    Integer getComprehensiveScoreIdByCode(String tmpCode);

    List<String> listClasscodeForBetweenTime(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<ClassTeacher> getClassTeachersForBetweenTime(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<String> getClasscodeByTid(int tid);

    List<Center> getCenterListForBetweenTime(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<String> getClasscodeByDirectionIdTime(@Param("did") int did, @Param("startTime") String startTime, @Param("endTime") String endTime);

    List<String> getClassCodesByCenterIdTime(@Param("cid") int cid, @Param("startTime") String startTime, @Param("endTime") String endTime);

    Integer getCenterIdByClasscode(String classcode);

}