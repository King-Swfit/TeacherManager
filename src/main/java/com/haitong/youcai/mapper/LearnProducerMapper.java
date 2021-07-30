package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/4/1.
 */
@Repository
public interface LearnProducerMapper {

    List<String> listTalkTypes();

    List<BaseinfoForTrainee> getBaseinfoForTraineeByClassCode(String classcode);

    List<BaseinfoForTrainee> getBaseinfoForTraineeByCondition(String classcode, String talkType);

    List<String> getClassCodesByCondition(int centerId, int ctid, String startTime, String endTime);

    List<String> listLearnStates();

    int saveTalkInfo(Talk talk);

    int updateTalkInfo(Talk talk);

    List<Talk> getTalksByClassCode(String classcode);

    List<Talk> getTalksByClassCodeAndTalkType(String classcode, String talkType);



    List<SummaryTalk> summaryTalkInfos();

    List<SummaryTalk> summaryTalkInfosByCtid(int ctid);

    List<String> getScore_items_java();

    List<String> getScore_types_java();

    List<String> getScore_items_ai();

    List<String> getScore_types_ai();

    int createTraineeScores_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees);

    int createTraineeScore(BaseinfoForTrainee baseinfoForTrainee);

    List<ProcessScoreForTrainee> listProcessTraineeScores(String classcode);

    int updateScoreItem_java(String code, String timee, int score, String detail, String check_item);
    int updateScoreItem_ai(String code, String timee, int score, String detail, String check_item);

    int updateScoreItem2_java(String code, int score, String score_detail, String item);

    int updateScoreItem2_ai(String code, int score, String score_detail, String item);

    int saveAttenceOriginals(List<ProcessAttenceOriginal> processAttenceOriginals);

    int saveAttenceDays(List<ProcessAttenceDay> processAttencedays);

    String getMaxAttenceDate(String classcode);

    List<ProcessAttenceOriginal> getAttenceOriginals(String classcode, String startTime, String endTime);

    List<ProcessAttenceDay> getAttenceDays(String classcode, String startTime, String endTime);

    List<ProcessAttenceMSummary> getAttenceSummarys(String classcode, String month);

    List<SimpleTalkSummary> getTalkSummaryByCondition(String classteacherId, String month);
    List<SimpleTalkSummary> getTalkSummaryByCondition2(String classteacherId, String month);

    List<KV> getTalkSummaryByCondition3(String classteacherId, String month);

    int deleteTalk(int tid);

    List<ClassTeacher> getClassTeacherByCid(int centerId);

    List<SimpleTalkCount> getTalkCountByClasscode(String classcode);

    String getTrnameByCode(String code);

    List<Talk> getTalkDetailByCode(String code);

    SimpleTalkCount getTalkCountByCode(String code);

    List<SimpleScoreCount> getScoreCountByClasscode(String classcode);

    List<Score> getScoreDetailByCode(String code);

    void saveNewScore(Score score);
    SimpleScoreCount getScoreCountByCode(String code);

    List<ProcessAttenceOriginal> getAttenceOriginalsByName(String name);

    List<ProcessAttenceOriginal> getAttenceOriginalsByCode(String code);

    List<ProcessAttenceDay> getAttenceDaysByName(String name);

    List<KVStr> getCodeNameInAtteceDays(String name);

    List<String> getDatesByCode(String code);

    List<ProcessAttenceMSummary> getAttenceSummarysByName(String name);

    List<ProcessAttenceMSummary> getAttenceSummarysByCode(String code);

    List<ProcessAttenceDay> getAttenceDaysByCode(String code);

    List<Score> getScoreDetailByClasscode(String classcode);

    ComprehensiveScore_baseinfo getComprehensiveScoreBaseinfoByCode(String code);

    List<SimpleTalkSummary> getTalkSummaryBySection(String classteacherId, String startTime, String endTime);

    List<SimpleTalkSummary> getTalkSummaryBySection2(String classteacherId, String startTime, String endTime);

    int updateScoreItem(Score score);
}
