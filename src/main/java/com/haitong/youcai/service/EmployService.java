package com.haitong.youcai.service;

import com.haitong.youcai.entity.*;
import com.haitong.youcai.mapper.EmployMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2019/5/20.
 */
@Service
public class EmployService {
    @Autowired
    private EmployMapper employMapper;

    public List<String> getEmployTypes() {
        return employMapper.getEmployTypes();
    }

    public List<BaseinfoForTrainee> listBaseinfoForTraineeByClassCode(String classcode) {
        return employMapper.listBaseinfoForTraineeByClassCode(classcode);
    }

    public BaseinfoForTrainee getBaseinfoForTraineeByCode(String classcode, String code) {
        return employMapper.getBaseinfoForTraineeByCode(classcode, code);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int saveNewInterview(ProcessEmployInterview processEmployInterview) {
        int result = 0;

        result = employMapper.saveNewInterview(processEmployInterview);
        if(result > 0){
            if(processEmployInterview.getResult().equals("成功")){
                result = employMapper.updateEmployInfo(processEmployInterview);
            }
        }
        return result;
    }

    public List<ProcessEmployInterviewRecord> listInterviewRecordByClassCode(String classcode) {
        return employMapper.listInterviewRecordByClassCode(classcode);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int updateInterviewRecord(ProcessEmployInterview processEmployInterview) {
        int result = 0;
        result = employMapper.updateEmployInfo(processEmployInterview);
        if(result > 0){
            result = employMapper.updateInterviewRecord(processEmployInterview);
        }
        return result;
    }

    public List<ProcessEmployInterviewRecord> listInterviewRecordByCondition(String classcode, String type, String result) {
        return employMapper.listInterviewRecordByCondition(classcode,type,result);
    }

    public int updateInterviewEmployProof(String code, String newFileName) {
        return employMapper.updateInterviewEmployProof(code,newFileName);
    }

    public String getPhotoNameByPeiid(int peiid) {
        return employMapper.getPhotoNameByPeiid(peiid);
    }

    public List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByCode(String code) {
        return employMapper.listProcessEmployInterviewRecordByCode(code);
    }

    public int insertInterviewRecord(ProcessEmployInterview processEmployInterview) {

        int result = employMapper.insertInterviewRecord(processEmployInterview);
        if(result > 0){
            return employMapper.updateComprehensiveBaseInfo(processEmployInterview);
        }
        return 0;
    }

    public List<String> getImgurlByCode(String code) {
        return employMapper.getImgurlByCode(code);
    }

    public List<ProcessEmployInterviewRecord> listInterviewRecordByName(String name) {
        return employMapper.listInterviewRecordByName(name);
    }

    public int saveInterviewEmployProof(String code, String employProof) {
        return employMapper.saveInterviewEmployProof(code, employProof);
    }

    public int deleteInterViewRecordByPeiid(int peiid) {
        return employMapper.deleteInterViewRecordByPeiid(peiid);
    }

    public ProcessEmployInterviewRecord getInterviewRecordByPeiid(int peiid) {
        return employMapper.getInterviewRecordByPeiid(peiid);
    }

    public int updateInterviewRecord2(ProcessEmployInterview processEmployInterview) {
        int result = employMapper.updateInterviewRecord(processEmployInterview);
        if(result > 0){
            employMapper.updateComprehensiveBaseInfo(processEmployInterview);
        }
        return result;
    }

    public String getImgurlByPeiid(int peiid) {
        return employMapper.getImgurlByPeiid(peiid);
    }

    public int deleteScoreByTid(int tid) {
        return employMapper.deleteScoreByTid(tid);
    }

    public KVStr getcodeNameByTid(int tid) {
        return employMapper.getcodeNameByTid(tid);
    }

    public Score getScoreByTid(int tid) {
        return employMapper.getScoreByTid(tid);
    }


    public int insertInterviewRecords(List<List<String>> datas) {
        int result = 0;
        String tmp;
        if(datas != null && datas.size() > 1){
            for(int i=1; i< datas.size(); i++){
                ProcessEmployInterview employInterview = new ProcessEmployInterview();
                List<String> data = datas.get(i);
                tmp=data.get(0);
                if(tmp == null || tmp.length() == 0){
                    continue;
                }
                employInterview.setCode(tmp);

                tmp=data.get(1);
                if(tmp == null || tmp.length() == 0){
                    continue;
                }
                employInterview.setClasscode(tmp);

                tmp=data.get(2);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setDatetimee("1900-01-01");
                }else{
                    employInterview.setDatetimee(data.get(2));
                }

                tmp=data.get(3);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setEntertimee("1900-01-01");
                }else{
                    employInterview.setEntertimee(tmp);
                }

                tmp=data.get(4);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setCorporiation("");
                }else{
                    employInterview.setCorporiation(tmp);
                }

                tmp=data.get(5);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setPosition("");
                }else{
                    employInterview.setPosition(tmp);
                }

                tmp=data.get(6);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setType("");
                }else{
                    employInterview.setType(tmp);
                }

                tmp=data.get(7);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setSalary(-1);
                }else{
                    employInterview.setSalary(Integer.parseInt(tmp));
                }

                tmp=data.get(8);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setResult("");
                }else{
                    employInterview.setResult(tmp);
                }

                tmp=data.get(9);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setRealSalary(-1);
                }else{
                    employInterview.setRealSalary(Integer.parseInt(tmp));
                }

                tmp=data.get(10);
                if(tmp == null || tmp.length() == 0){
                    employInterview.setFuli("");
                }else{
                    employInterview.setFuli(tmp);
                }


                result = result + employMapper.insertInterviewRecord(employInterview);
            }
        }

        return result;
    }
}
