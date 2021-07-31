package com.haitong.youcai.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.mapper.ClassMapper;
import com.haitong.youcai.mapper.LearnProducerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Created by Administrator on 2019/5/13.
 */
@Service
public class LearnProdurceService {
    @Autowired
    private LearnProducerMapper learnProducerMapper;

    @Autowired
    private ClassMapper classMapper;

    public List<String> listTalkTypes() {
        return learnProducerMapper.listTalkTypes();
    }

    public List<BaseinfoForTrainee> getBaseinfoForTraineeByClassCode(String classcode) {
        return learnProducerMapper.getBaseinfoForTraineeByClassCode(classcode);

    }

    public List<BaseinfoForTrainee> getBaseinfoForTraineeByCondition(String classcode, String talkType) {
        return learnProducerMapper.getBaseinfoForTraineeByCondition(classcode, talkType);
    }

    public List<String> getClassCodesByCondition(int centerId, int ctid, String startTime, String endTime) {
        return learnProducerMapper.getClassCodesByCondition(centerId, ctid, startTime, endTime);
    }

    public List<String> listLearnStates() {
        return learnProducerMapper.listLearnStates();
    }

    public int saveTalkInfo(Talk talk) {
        return learnProducerMapper.saveTalkInfo(talk);
    }

    public int updateTalkInfo(Talk talk) {
        return learnProducerMapper.updateTalkInfo(talk);
    }

    public List<Talk> getTalksByClassCode(String classcode) {
        return learnProducerMapper.getTalksByClassCode(classcode);
    }

    public List<Talk> getTalksByClassCodeAndTalkType(String classcode, String talkType) {
        return learnProducerMapper.getTalksByClassCodeAndTalkType(classcode, talkType);
    }

    public List<SummaryTalk> summaryTalkInfos() {
        return learnProducerMapper.summaryTalkInfos();
    }

    public List<SummaryTalk> summaryTalkInfosByCtid(int ctid) {
        return learnProducerMapper.summaryTalkInfosByCtid(ctid);
    }

    public List<String> getScore_items_java() {
        return learnProducerMapper.getScore_items_java();
    }

    public List<String> getScore_types_java() {
        return learnProducerMapper.getScore_types_java();
    }

    public List<String> getScore_items_ai() {
        return learnProducerMapper.getScore_items_ai();
    }

    public List<String> getScore_types_ai() {
        return learnProducerMapper.getScore_types_ai();
    }

    public int createTraineeScores_batchTrainee(List<BaseinfoForTrainee> baseinfoForTrainees){
        return learnProducerMapper.createTraineeScores_batchTrainee(baseinfoForTrainees);
    }

    public int createTraineeScore(BaseinfoForTrainee baseinfoForTrainee){
        return learnProducerMapper.createTraineeScore(baseinfoForTrainee);
    }

    public List<ProcessScoreForTrainee> listProcessTraineeScores(String classcode) {
        return learnProducerMapper.listProcessTraineeScores(classcode);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int updateScoreItem(String code, String timee, int score, String detail, String check_item, String dname) {
        int result = -1;
        if(dname.contains("大数据")){
            //更新comprehensivescore_java
            result = learnProducerMapper.updateScoreItem_java(code, timee, score, detail, check_item);
            if(result > 0){
                result = classMapper.updateScoreItem_java(code, timee, score, detail, check_item);
            }

        } else if(dname.contains("物联网")){
            result = learnProducerMapper.updateScoreItem_ai(code, timee, score, detail, check_item);
            if(result > 0){
                result = classMapper.updateScoreItem_ai(code, timee, score, detail, check_item);
            }
        }

        return result;
    }


    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int updateScoreInfo(Score score) {
        int result = learnProducerMapper.updateScoreItem(score);
        return result;
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int importAttence(List<List<List<String>>> datas,JSONObject json) {
        int result = -1;



        if (datas != null && datas.size() > 0) {
            List<ProcessAttenceOriginal> processAttenceOriginals = new ArrayList<>();
            List<List<String>> originalClicks = datas.get(2);

            //String classcode = originalClicks.get(3).get(1).split("-")[1];
            String classcode = originalClicks.get(3).get(1);
            String maxDate = learnProducerMapper.getMaxAttenceDate(classcode);



            for(int i = 3; i < originalClicks.size(); i++){
                String[] arr = originalClicks.get(i).get(6).split(" ");;
                String datee = arr[0];
                if(datee.length() == 8){
                    datee = "20" + datee;
                }
                if((maxDate == null) || (maxDate != null && maxDate.length() == 10 && datee.compareTo(maxDate)>0)){
                    ProcessAttenceOriginal processAttenceOriginal = new ProcessAttenceOriginal();
                    processAttenceOriginal.setDatee(arr[0]);
                    processAttenceOriginal.setWeek(arr[1]);
                    processAttenceOriginal.setName(originalClicks.get(i).get(0));
                    processAttenceOriginal.setClasscode(originalClicks.get(i).get(1));//.split("-")[1]);
                    processAttenceOriginal.setTimee(originalClicks.get(i).get(7));
                    processAttenceOriginal.setClickTime(originalClicks.get(i).get(8));
                    processAttenceOriginal.setClickResult(originalClicks.get(i).get(9));
                    processAttenceOriginal.setClickAddress(originalClicks.get(i).get(10));
                    processAttenceOriginal.setClickComment(originalClicks.get(i).get(11));
                    processAttenceOriginal.setClickDevice(originalClicks.get(i).get(15));

                    processAttenceOriginals.add(processAttenceOriginal);
                }

            }

            List<ProcessAttenceDay> processAttencedays = new ArrayList<>();
            List<List<String>> dayClicks = datas.get(1);
            for(int i = 4; i < dayClicks.size(); i++){

                String[] arr = dayClicks.get(i).get(6).split(" ");
                String datee = arr[0];
                if(datee.length() == 8){
                    datee = "20" + datee;
                }
                if((maxDate == null) || (maxDate != null && maxDate.length() == 10 && datee.compareTo(maxDate)>0)){
                    ProcessAttenceDay processAttenceDay = new ProcessAttenceDay();
                    processAttenceDay.setName(dayClicks.get(i).get(0));
                    processAttenceDay.setClasscode(dayClicks.get(i).get(1));//.split("-")[1]);

                    processAttenceDay.setDatee(arr[0]);
                    processAttenceDay.setWeek(arr[1]);
                    processAttenceDay.setTurn(dayClicks.get(i).get(7));
                    processAttenceDay.setClickTime_1(dayClicks.get(i).get(8));
                    processAttenceDay.setClickResult_1(dayClicks.get(i).get(9));
                    processAttenceDay.setClickTime_2(dayClicks.get(i).get(10));
                    processAttenceDay.setClickResult_2(dayClicks.get(i).get(11));


                    processAttenceDay.setAttence((int)Float.parseFloat(dayClicks.get(i).get(17)));
                    processAttenceDay.setWorkTime((int)Float.parseFloat(dayClicks.get(i).get(19)));
                    processAttenceDay.setLates((int)Float.parseFloat(dayClicks.get(i).get(20)));
                    processAttenceDay.setLateTime((int)Float.parseFloat(dayClicks.get(i).get(21)));
                    processAttenceDay.setEarlyLefts((int)Float.parseFloat(dayClicks.get(i).get(25)));

                    processAttenceDay.setEarlyLeftTime((int)Float.parseFloat(dayClicks.get(i).get(26)));
                    processAttenceDay.setLacks_1((int)Float.parseFloat(dayClicks.get(i).get(27)));
                    processAttenceDay.setLacks_2((int)Float.parseFloat(dayClicks.get(i).get(28)));
                    processAttenceDay.setAbsents((int)Float.parseFloat(dayClicks.get(i).get(29)));

                    String thing = dayClicks.get(i).get(30);
                    if(thing != null && thing.length() > 0){
                        processAttenceDay.setFree_thing(Float.parseFloat(thing));
                    }else{
                        processAttenceDay.setFree_thing(0);
                    }
                    String ill = dayClicks.get(i).get(31);
                    if(ill != null && ill.length() > 0) {
                        processAttenceDay.setFree_ill(Float.parseFloat(ill));
                    }else{
                        processAttenceDay.setFree_ill(0);
                    }

                    processAttencedays.add(processAttenceDay);
                }

            }

            if(processAttenceOriginals.size() > 0){

                List<BaseinfoForTrainee> baseinfoForTrainees = learnProducerMapper.getBaseinfoForTraineeByClassCode(classcode);
                Map<String ,String> namecodeMap = new HashMap<>();
                for(int j = 0; j < baseinfoForTrainees.size(); j++){
                    namecodeMap.put(baseinfoForTrainees.get(j).getName(), baseinfoForTrainees.get(j).getCode());
                }

                for(int k = 0; k < processAttenceOriginals.size(); k++){
                    ProcessAttenceOriginal  pao = processAttenceOriginals.get(k);
                    pao.setCode(namecodeMap.get(pao.getName()));
                }


                for(int k = 0; k < processAttencedays.size(); k++){
                    ProcessAttenceDay pad = processAttencedays.get(k);
                    pad.setCode(namecodeMap.get(pad.getName()));
                }
                json.put("processAttenceOriginals",processAttenceOriginals);


                //写数据库
                result = learnProducerMapper.saveAttenceOriginals(processAttenceOriginals);
                if(result > 0){
                    result = learnProducerMapper.saveAttenceDays(processAttencedays);
                }


            }

        }

        return result;


    }

    public List<ProcessAttenceOriginal> getAttenceOriginals(String classcode, String startTime, String endTime) {
        return learnProducerMapper.getAttenceOriginals(classcode, startTime, endTime);
    }

    public List<ProcessAttenceDay> getAttenceDays(String classcode, String startTime, String endTime) {
        return learnProducerMapper.getAttenceDays(classcode, startTime, endTime);
    }

    public List<ProcessAttenceMSummary> getAttenceSummarys(String classcode, String month) {
        List<ProcessAttenceMSummary> processAttenceMSummarys = learnProducerMapper.getAttenceSummarys(classcode, month);
        return processAttenceMSummarys;
    }

    public List<SimpleTalkSummary> getTalkSummaryByCondition(String classteacherId, String month) {
        return learnProducerMapper.getTalkSummaryByCondition(classteacherId, month);
    }

    public List<SimpleTalkSummary> getTalkSummaryByCondition2(String classteacherId, String month) {
        return learnProducerMapper.getTalkSummaryByCondition2(classteacherId, month);
    }

    public  List<KV> getTalkSummaryByCondition3(String classteacherId, String month) {
        return learnProducerMapper.getTalkSummaryByCondition3(classteacherId, month);
    }

    public int deleteTalk(int tid) {
        return learnProducerMapper.deleteTalk(tid);
    }

    public List<ClassTeacher> getClassTeacherByCid(int centerId) {
        return learnProducerMapper.getClassTeacherByCid(centerId);
    }

    public List<SimpleTalkCount> getTalkCountByClasscode(String classcode) {
        return learnProducerMapper.getTalkCountByClasscode(classcode);
    }

    public String getTrnameByCode(String code) {
        return learnProducerMapper.getTrnameByCode(code);
    }

    public List<Talk> getTalkDetailByCode(String code) {
        return learnProducerMapper.getTalkDetailByCode(code);
    }

    public SimpleTalkCount getTalkCountByCode(String code) {
        return learnProducerMapper.getTalkCountByCode(code);
    }

    /**
     * 通过班级编号查询考试信息
     * @date  2021/7/30 17:22
     * @param classcode 班级编号
     * @return java.util.List<com.haitong.youcai.entity.SimpleScoreCount>
     */
    public List<SimpleScoreCount> getScoreCountByClasscode(String classcode) {
        return learnProducerMapper.getScoreCountByClasscode(classcode);
    }

    public List<Score> getScoreDetailByCode(String code) {
        return learnProducerMapper.getScoreDetailByCode(code);
    }

    public void saveNewScore(Score score) {
        learnProducerMapper.saveNewScore(score);
    }

    public SimpleScoreCount getScoreCountByCode(String code) {
        return learnProducerMapper.getScoreCountByCode(code);
    }

    public List<ProcessAttenceOriginal> getAttenceOriginalsByName(String name) {
        return learnProducerMapper.getAttenceOriginalsByName(name);
    }

    public List<ProcessAttenceOriginal> getAttenceOriginalsByCode(String code) {
        return learnProducerMapper.getAttenceOriginalsByCode(code);
    }

    public List<ProcessAttenceDay> getAttenceDaysByName(String name) {
        return learnProducerMapper.getAttenceDaysByName(name);
    }


    public List<KVStr> getCodeNameInAtteceDays(String name) {
        return learnProducerMapper.getCodeNameInAtteceDays(name);
    }

    public List<String> getDatesByCode(String code) {
        return learnProducerMapper.getDatesByCode(code);
    }

    public List<ProcessAttenceMSummary> getAttenceSummarysByName(String name) {
        return learnProducerMapper.getAttenceSummarysByName(name);
    }

    public List<ProcessAttenceMSummary> getAttenceSummarysByCode(String code) {
        return learnProducerMapper.getAttenceSummarysByCode(code);
    }

    public List<ProcessAttenceDay> getAttenceDaysByCode(String code) {
        return learnProducerMapper.getAttenceDaysByCode(code);
    }

    public List<Score> getScoreDetailByClasscode(String classcode) {
        return learnProducerMapper.getScoreDetailByClasscode(classcode);
    }

    public ComprehensiveScore_baseinfo getComprehensiveScoreBaseinfoByCode(String code) {
        return learnProducerMapper.getComprehensiveScoreBaseinfoByCode(code);
    }

    public List<SimpleTalkSummary> getTalkSummaryBySection(String classteacherId, String startTime, String endTime) {
        return learnProducerMapper.getTalkSummaryBySection(classteacherId, startTime, endTime);

    }

    public List<SimpleTalkSummary> getTalkSummaryBySection2(String classteacherId, String startTime, String endTime) {
        return learnProducerMapper.getTalkSummaryBySection2(classteacherId, startTime, endTime);
    }
}
