package com.haitong.youcai.controller;

/**
 * Created by Administrator on 2019/3/28.
 */

import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.ClassService;
import com.haitong.youcai.service.CorporiationService;
import com.haitong.youcai.service.JiaoWuService;
import com.haitong.youcai.service.LearnProdurceService;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.*;

@Controller
public class PageController {
    @Autowired
    private JiaoWuService jiaoWuService;

    @Autowired
    private LearnProdurceService learnProdurceService;

    @Autowired
    private ClassService classService;

    @Autowired
    private CorporiationService corporiationService;


    @RequestMapping(value = "/page")
    public String page(){
        return "page";
    }

    @RequestMapping(value = "/work/summary")
    @PreAuthorize("hasPermission('/work/summary','y')")
    public String workSummary(Map<String, Object> model){
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        model.put("classteachers", classTeachers);
        return "work_summary";
    }



    @RequestMapping(value = "/work/querySummary")
    @ResponseBody
    public List<WorkSummary> querySummary(String classteacherId, String month){
        List<WorkSummary> workSummaries = new ArrayList<>();

        ////////////////////////////////////////////////////////访谈//////////////////////////////////////////////////////////////////
        List<KVStr> kvStrs = classService.getClasscodeCTName();
        List<KV> kvs1 = learnProdurceService.getTalkSummaryByCondition3(classteacherId, month);
        for(KV kv:kvs1){
            WorkSummary workSummary = new WorkSummary();
            workSummary.setClasscode(kv.getK());
            workSummary.setTalkCount(kv.getV());
            workSummaries.add(workSummary);
        }
        for(WorkSummary workSummary:workSummaries){
            String classcode = workSummary.getClasscode();
            for(KVStr kvStr:kvStrs){
                if(kvStr.getK().equals(classcode)){
                    workSummary.setCtname(kvStr.getV());
                    break;
                }
            }
        }


        ////////////////////////////////////////////////////////就业推荐////////////////////////////////////////////////////////
        List<KV> kvs2 = classService.getInterviewCountForClass2(classteacherId, month);//每个班面试的总次数
        List<KV> kvs3 = classService.getCountForInterviewSuccess2(classteacherId, month);//每个班面试成功
        for(WorkSummary workSummary:workSummaries){
            String classcode = workSummary.getClasscode();
            int count = 0;
            for(KV kv:kvs2){
                if(kv.getK().equals(classcode)){
                    count =  kv.getV();
                    break;
                }
            }

            int count2=0;
            for(KV kv:kvs3){
                if(kv.getK().equals(classcode)){
                    count2=kv.getV();
                    break;
                }
            }

            workSummary.setRecommandResult(count2 + "/" + count);
        }



        ///////////////////////////////////////////////////////////企业联系///////////////////////////////////////////////////////
        List<CorporiationConnectRecoed> corporiationConnectRecoeds = corporiationService.listConnectRecords2(classteacherId,month);
        List<CorporiationConnectRecoed> corporiationConnectRecoeds2 = corporiationService.listConnectRecords3(classteacherId,month);

        //班主任
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        Map<Integer,String> ctmap = new HashMap<>();
        for(ClassTeacher ct:classTeachers){
            ctmap.put(ct.getCtid(), ct.getCtname());
        }
        for(CorporiationConnectRecoed corporiationConnectRecoed:corporiationConnectRecoeds){
            corporiationConnectRecoed.setCtname(ctmap.get(corporiationConnectRecoed.getClassTeacherId()));
        }

        for(CorporiationConnectRecoed corporiationConnectRecoed:corporiationConnectRecoeds2){
            corporiationConnectRecoed.setCtname(ctmap.get(corporiationConnectRecoed.getClassTeacherId()));
        }

        for(WorkSummary workSummary:workSummaries){
            String ctname = workSummary.getCtname();
            int count = 0;
            for(CorporiationConnectRecoed corporiationConnectRecoed:corporiationConnectRecoeds){
                if(corporiationConnectRecoed.getCtname().equals(ctname)){
                    count++;
                }
            }
            int count2 = 0;
            for(CorporiationConnectRecoed corporiationConnectRecoed:corporiationConnectRecoeds2){
                if(corporiationConnectRecoed.getCtname().equals(ctname)){
                    count2++;
                }
            }

            workSummary.setConnectResult(count2 + "/" + count);
        }

        return workSummaries;
    }

}