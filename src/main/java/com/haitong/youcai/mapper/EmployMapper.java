package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.*;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/5/20.
 */
@Repository
public interface EmployMapper {
    List<String> getEmployTypes();

    List<BaseinfoForTrainee> listBaseinfoForTraineeByClassCode(String classcode);

    BaseinfoForTrainee getBaseinfoForTraineeByCode(String classcode, String code);

    int saveNewInterview(ProcessEmployInterview processEmployInterview);

    List<ProcessEmployInterviewRecord> listInterviewRecordByClassCode(String classcode);

    int updateInterviewRecord(ProcessEmployInterview processEmployInterview);

    List<ProcessEmployInterviewRecord> listInterviewRecordByCondition(String classcode, String type, String result);

    int updateInterviewEmployProof(String code, String newFileName);

    String getPhotoNameByPeiid(int peiid);

    int updateEmployInfo(ProcessEmployInterview processEmployInterview);

    List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByCode(String code);

    int insertInterviewRecord(ProcessEmployInterview processEmployInterview);

    List<String> getImgurlByCode(String code);

    List<ProcessEmployInterviewRecord> listInterviewRecordByName(String name);

    int saveInterviewEmployProof(String code, String employProof);

    int updateComprehensiveBaseInfo(ProcessEmployInterview processEmployInterview);

    int deleteInterViewRecordByPeiid(int peiid);

    ProcessEmployInterviewRecord getInterviewRecordByPeiid(int peiid);

    String getImgurlByPeiid(int peiid);

    int deleteScoreByTid(int tid);

    KVStr getcodeNameByTid(int tid);

    Score getScoreByTid(int tid);
}
