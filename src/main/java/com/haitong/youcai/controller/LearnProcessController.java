package com.haitong.youcai.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.ClassService;
import com.haitong.youcai.service.EmployService;
import com.haitong.youcai.service.JiaoWuService;
import com.haitong.youcai.service.LearnProdurceService;
import com.haitong.youcai.utils.ExcelUtil;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.text.ParseException;
import java.util.*;

/**
 * Created by Administrator on 2019/5/13.
 */
@Controller
@RequestMapping("/procedure") //在类上使用RequestMapping，里面设置的value就是方法的父路径
public class LearnProcessController {

    @Autowired
    private ClassService classService;

    @Autowired
    private JiaoWuService jiaoWuService;

    @Autowired
    private LearnProdurceService learnProdurceService;

    @Autowired
    private EmployService employService;




    @RequestMapping(value = "/talkwork")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/procedure/talkwork','y')")
    public String getCenterInfo(Map<String, Object> model) {
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);//centers.get(0).getCid()
        model.put("classteachers", classTeachers);

        List<String>  talkTypes = learnProdurceService.listTalkTypes();
        model.put("talkTypes", talkTypes);

        List<String>  learnStates = learnProdurceService.listLearnStates();
        model.put("learnStates", learnStates);

        //查询该班主任的班级
        List<String> classcodes = classService.getClassCodesByClid(classTeachers.get(0).getCtid());
        model.put("classcodes", classcodes);

        //获取第一个班级的学员情况，以及访谈次数
        if(classcodes != null && classcodes.size() > 0){
            String classcode = classcodes.get(0);
            List<BaseinfoForTrainee> baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
            List<SimpleTalkCount> simpleTalkCounts = learnProdurceService.getTalkCountByClasscode(classcode);
            boolean isExist = false;
            for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                isExist = false;
                for(SimpleTalkCount simpleTalkCount:simpleTalkCounts){
                    if(simpleTalkCount.getCode().equals(baseinfoForTrainee.getCode())){
                        simpleTalkCount.setClasscode(classcode);
                        simpleTalkCount.setCtname(classTeachers.get(0).getCtname());
                        String trname = learnProdurceService.getTrnameByCode(simpleTalkCount.getCode());
                        simpleTalkCount.setName(trname);

                        isExist = true;
                        break;
                    }

                }
                if(isExist == false){
                    SimpleTalkCount simpleTalkCount = new SimpleTalkCount();
                    simpleTalkCount.setCode(baseinfoForTrainee.getCode());
                    simpleTalkCount.setCount(0);

                    simpleTalkCount.setClasscode(classcode);
                    simpleTalkCount.setCtname(classTeachers.get(0).getCtname());
                    System.out.println(simpleTalkCount.getCode());
                    String trname = learnProdurceService.getTrnameByCode(simpleTalkCount.getCode());
                    simpleTalkCount.setName(trname);

                    simpleTalkCounts.add(simpleTalkCount);

                }
            }


            model.put("simpleTalkCounts", simpleTalkCounts);

        }




        return "learnProcdure_talkwork";
    }

    @RequestMapping(value = "/getTalkCountByClasscode")
    @ResponseBody
    public List<SimpleTalkCount> getTalkCountByClasscode(String classcode, String ctname){

        List<SimpleTalkCount> simpleTalkCounts = null;
        if(classcode != null && classcode.length() > 0){
            List<BaseinfoForTrainee> baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
            simpleTalkCounts = learnProdurceService.getTalkCountByClasscode(classcode);
            if(simpleTalkCounts == null){
                simpleTalkCounts = new ArrayList<SimpleTalkCount>();
            }
            boolean isExist = false;
            for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                isExist = false;
                for(SimpleTalkCount simpleTalkCount:simpleTalkCounts){
                    if(simpleTalkCount.getCode().equals(baseinfoForTrainee.getCode())){
                        simpleTalkCount.setClasscode(classcode);
                        simpleTalkCount.setCtname(ctname);
                        String trname = learnProdurceService.getTrnameByCode(simpleTalkCount.getCode());
                        simpleTalkCount.setName(trname);

                        isExist = true;
                        break;
                    }

                }
                if(isExist == false){
                    SimpleTalkCount simpleTalkCount = new SimpleTalkCount();
                    simpleTalkCount.setCode(baseinfoForTrainee.getCode());
                    simpleTalkCount.setCount(0);

                    simpleTalkCount.setClasscode(classcode);
                    simpleTalkCount.setCtname(ctname);
                    String trname = learnProdurceService.getTrnameByCode(simpleTalkCount.getCode());
                    simpleTalkCount.setName(trname);

                    simpleTalkCounts.add(simpleTalkCount);

                }
            }

        }

        return simpleTalkCounts;
    }

    @RequestMapping(value = "/getTalkCountByName")
    @ResponseBody
    public List<SimpleTalkCount> getTalkCountByName(String name){

        List<SimpleTalkCount> simpleTalkCounts = new ArrayList<>();

        List<KVStr> classcodeCtname = classService.getClasscodeCTName();//班级编号和班主任名字
        List<KVStr> trCodes = classService.getTrcodeCcodeByTrname(name);//学员编号和班级编号
        if(trCodes != null){
            for(KVStr codeclasscode:trCodes){
                String classcode = codeclasscode.getV();
                String ctname = Tool.getValueByKey(classcodeCtname, classcode);//班主任名字

                String code = codeclasscode.getK();
                SimpleTalkCount simpleTalkCount = learnProdurceService.getTalkCountByCode(code);
                simpleTalkCount.setCtname(ctname);
                simpleTalkCount.setClasscode(classcode);

                String trname = classService.getTrnameByCode(code);
                simpleTalkCount.setName(trname);

                simpleTalkCounts.add(simpleTalkCount);




            }
        }


        return simpleTalkCounts;
    }




    @RequestMapping(value = "/getTalkDetailByCode")
    @ResponseBody
    public List<Talk> getTalkDetailByCode(String code){
        List<Talk> talks = learnProdurceService.getTalkDetailByCode(code);
        return talks;
    }




    @RequestMapping(value = "/getBaseinfoForTraineeByCondition")
    @ResponseBody
    public List<BaseinfoForTrainee> getBaseinfoForTraineeByCondition(String classcode, String talktype){
        List<BaseinfoForTrainee> baseinfoForTrainees;
        if(talktype.equals("全部")){
            baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
        }else{
            baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByCondition(classcode,talktype);
        }

        return baseinfoForTrainees;
    }

    @RequestMapping(value = "/getClassCodeByCondition_1")
    @ResponseBody
    public JSONObject getClassCodeByCondition_1(int centerId, int ctid, String startTime, String endTime){
        JSONObject jsonObject = new JSONObject();
        List<ClassTeacher>  classTeachers =  classService.getClassTeachersByCenterId(centerId);
        if(ctid == -1){
            if(classTeachers != null && classTeachers.size() > 0){
                ctid = classTeachers.get(0).getCtid();
            }
        }

        jsonObject.put("classTeachers", classTeachers);

        List<String> classcodes = learnProdurceService.getClassCodesByCondition(centerId, ctid,startTime,endTime);
        jsonObject.put("classcodes", classcodes);
        return jsonObject;
    }



    @RequestMapping(value = "/getClassCodeByCondition")
    @ResponseBody
    public JSONObject getClassCodeByCondition(int centerId, int ctid, String startTime, String endTime){
        JSONObject jsonObject = new JSONObject();
        List<ClassTeacher>  classTeachers =  classService.getClassTeachersByCenterId(centerId);
        if(ctid == -1){
            if(classTeachers != null && classTeachers.size() > 0){
                ctid = classTeachers.get(0).getCtid();
            }
        }
        jsonObject.put("classTeachers", classTeachers);
        List<String> classcodes = learnProdurceService.getClassCodesByCondition(centerId, ctid,startTime,endTime);
        jsonObject.put("classcodes", classcodes);


        return jsonObject;
    }



    @RequestMapping(value = "/getScoresByClasscode")
    @ResponseBody
    public JSONObject getScoresByClasscode(String classcode){
        JSONObject jsonObject = new JSONObject();

        if(classcode != null && classcode.length() > 0){
            int directionId = classService.getDirectionIdByClassCode(classcode);
            String dname = classService.getDnameByDid(directionId);
            jsonObject.put("directionId", directionId);
            jsonObject.put("dname", dname);
            if(dname.contains("大数据")){
                List<String> score_items_java = learnProdurceService.getScore_items_java();
                List<String> score_types_java = learnProdurceService.getScore_types_java();
                jsonObject.put("score_items", score_items_java);
                jsonObject.put("score_types", score_types_java);
            }else if(dname.contains("物联网")){
                List<String> score_items_ai = learnProdurceService.getScore_items_ai();
                List<String> score_types_ai = learnProdurceService.getScore_types_ai();
                jsonObject.put("score_items", score_items_ai);
                jsonObject.put("score_types", score_types_ai);
            }
            List<BaseinfoForTrainee> baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
            List<ProcessScoreForTrainee> processScoreForTrainees =  learnProdurceService.listProcessTraineeScores(classcode);
            for(ProcessScoreForTrainee processScoreForTrainee:processScoreForTrainees){
                for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                    if(processScoreForTrainee.getCode().equals(baseinfoForTrainee.getCode())){
                        processScoreForTrainee.setName(baseinfoForTrainee.getName());
                        break;
                    }
                }
            }
            jsonObject.put("processScoreForTrainees", processScoreForTrainees);
        }

        return jsonObject;
    }







    @RequestMapping(value = "/saveTalkInfo")
    @ResponseBody
    public int saveTalkInfo(Talk talk){
        int id = -1;
        int result = learnProdurceService.saveTalkInfo(talk);
        if(result > 0){
            id = talk.getTid();
        }
        return id;
    }




    @RequestMapping(value = "/updateTalkInfo")
    @ResponseBody
    public String updateTalk(Talk talk){
        int id = -1;
        int result = learnProdurceService.updateTalkInfo(talk);
        if(result > 0){
            return "success";
        }
        return "fail";
    }



    @RequestMapping(value = "/getTalks")
    @ResponseBody
    public List<Talk> getTalks(String classcode, String talkType){
        List<Talk> talks;
        if(talkType.equals("全部")){
            talks = learnProdurceService.getTalksByClassCode(classcode);
        }else{
            talks = learnProdurceService.getTalksByClassCodeAndTalkType(classcode, talkType);
        }

        return talks;
    }



    @RequestMapping(value = "/deleteTalk")
    @ResponseBody
    public JSONObject deleteTalk(int tid, String classcode, String talkType){
        JSONObject jsonObject = new JSONObject();
        if(tid > 0){
             int result = learnProdurceService.deleteTalk(tid);
             if(result > 0){
                 List<Talk> talks;
                 if(talkType.equals("全部")){
                     talks = learnProdurceService.getTalksByClassCode(classcode);
                 }else{
                     talks = learnProdurceService.getTalksByClassCodeAndTalkType(classcode, talkType);
                 }

                 jsonObject.put("result", "success");
                 jsonObject.put("talks", talks);

             }else{
                 jsonObject.put("result", "fail");
             }

        }

        return jsonObject;
    }




    @RequestMapping(value = "/summaryTalkInfos")
    @ResponseBody
    public List<SummaryTalk> summaryTalkInfos(String startTime, String endTime, String classteacherId) throws ParseException {

        List<KVStr> classcodeCTNames = classService.getClasscodeCTName();
        Map<String, String> map = Tool.convertListToMap(classcodeCTNames);
        List<SimpleTalkSummary> simpleTalkSummaries = learnProdurceService.getTalkSummaryBySection(classteacherId,startTime, endTime);
        List<SimpleTalkSummary> simpleTalkSummaries_success = learnProdurceService.getTalkSummaryBySection2(classteacherId,startTime, endTime);

        List<SummaryTalk> summaryTalks = new ArrayList<>();

        if(classcodeCTNames != null && simpleTalkSummaries != null){
            for(SimpleTalkSummary simpleTalkSummary:simpleTalkSummaries){

                SummaryTalk summaryTalk = null;
                String ctname = null;
                boolean isExistSummaryTalk = false;

                boolean isExistCTNmae = false;
                Map<String, Map<String, ClassTalkSummary>> classTalkSummaryMap = null;
                Map<String, ClassTalkSummary> monthTalkSummaryMap = null;
                ClassTalkSummary classTalkSummary = null;

                ctname = map.get(simpleTalkSummary.getClasscode());
                isExistCTNmae = Tool.isExistCTName(summaryTalks  ,ctname);

                if(isExistCTNmae){
                    summaryTalk = Tool.getSummaryTalkByCTName(summaryTalks  ,ctname);
                    classTalkSummaryMap = summaryTalk.getClassTalkSummaryMap();
                    isExistSummaryTalk = true;

                }else{
                    summaryTalk = new SummaryTalk();
                    summaryTalk.setCtname(ctname);
                    classTalkSummaryMap = new TreeMap<String, Map<String, ClassTalkSummary>>();
                    summaryTalk.setClassTalkSummaryMap(classTalkSummaryMap);

                    isExistSummaryTalk = false;
                }


                monthTalkSummaryMap = classTalkSummaryMap.get(simpleTalkSummary.getClasscode());

                if(null == monthTalkSummaryMap){
                    monthTalkSummaryMap = new TreeMap<String, ClassTalkSummary>();
                    classTalkSummaryMap.put(simpleTalkSummary.getClasscode(), monthTalkSummaryMap);
                }

                classTalkSummary = monthTalkSummaryMap.get(simpleTalkSummary.getMonth());
                if(null == classTalkSummary){
                    classTalkSummary = new ClassTalkSummary();
                    monthTalkSummaryMap.put(simpleTalkSummary.getMonth(), classTalkSummary);
                }



                String talkType = simpleTalkSummary.getTalkType();
                int count = simpleTalkSummary.getCount();
                int count_success = 0;
                switch (talkType){
                    case "摸底":
                        classTalkSummary.setModi(count);
                        break;
                    case "出勤异常":
                        classTalkSummary.setChuqin_except_count(count);
                        break;
                    case "作业异常":
                        classTalkSummary.setZuoye_except_count(count);
                        break;
                    case "成绩异常":
                        classTalkSummary.setScore_except_count(count);
                        break;


                    case "退费挽单":
                        classTalkSummary.setWandan_count(count);
                        count_success = Tool.getSuccessCount_wandan(simpleTalkSummaries_success, simpleTalkSummary.getClasscode(), simpleTalkSummary.getMonth());
                        classTalkSummary.setWandan_change(count_success);
                        break;
                    case "口碑":
                        classTalkSummary.setKoubei_count(count);
                        count_success = Tool.getSuccessCount_koubei(simpleTalkSummaries_success, simpleTalkSummary.getClasscode(), simpleTalkSummary.getMonth());
                        classTalkSummary.setKoubei_submit(count_success);
                        break;
                    case "转运维":
                        classTalkSummary.setYunwei_count(count);
                        count_success = Tool.getSuccessCount_yunwei(simpleTalkSummaries_success, simpleTalkSummary.getClasscode(), simpleTalkSummary.getMonth());
                        classTalkSummary.setYunwei_change(count_success);
                        break;


                    case "学籍变更":
                        classTalkSummary.setXuejichange(count);
                        break;
                    case "就业意向":
                        classTalkSummary.setJiuye_intention(count);
                        break;
                    case "就业指导":
                        classTalkSummary.setJiuyezhidao(count);
                        break;
                }

                if(isExistSummaryTalk == false){
                    summaryTalks.add(summaryTalk);
                }


            }




        }





        return summaryTalks;
    }




    @RequestMapping(value = "/score")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/procedure/score','y')")
    public String getScores(Map<String, Object> model) {
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);//centers.get(0).getCid()
        model.put("classteachers", classTeachers);

        //查询该班主任的班级
        List<String> classcodes = classService.getClassCodesByClid(classTeachers.get(0).getCtid());
        model.put("classcodes", classcodes);

        if(classcodes != null && classcodes.size() > 0) {
            String classcode = classcodes.get(0);
            List<BaseinfoForTrainee> baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
            List<SimpleScoreCount> simpleScoreCounts = learnProdurceService.getScoreCountByClasscode(classcode);
            if(simpleScoreCounts == null){
                simpleScoreCounts = new ArrayList<>();
            }
            boolean isExist = false;
            for (BaseinfoForTrainee baseinfoForTrainee : baseinfoForTrainees) {
                isExist = false;
                for (SimpleScoreCount simpleScoreCount : simpleScoreCounts) {
                    if (simpleScoreCount.getCode().equals(baseinfoForTrainee.getCode())) {
                        simpleScoreCount.setClasscode(classcode);
                        simpleScoreCount.setCtname(classTeachers.get(0).getCtname());
                        String trname = learnProdurceService.getTrnameByCode(simpleScoreCount.getCode());
                        simpleScoreCount.setName(trname);

                        isExist = true;
                        break;
                    }

                }
                if (isExist == false) {
                    SimpleScoreCount simpleScoreCount = new SimpleScoreCount();
                    simpleScoreCount.setCode(baseinfoForTrainee.getCode());
                    simpleScoreCount.setCount(0);

                    simpleScoreCount.setClasscode(classcode);
                    simpleScoreCount.setCtname(classTeachers.get(0).getCtname());
                    String trname = learnProdurceService.getTrnameByCode(simpleScoreCount.getCode());
                    simpleScoreCount.setName(trname);

                    simpleScoreCounts.add(simpleScoreCount);

                }
            }

            model.put("simpleScoreCounts", simpleScoreCounts);
        }



        return "learnProcdure_score";
    }

    @RequestMapping(value = "/getScoreCountByClasscode")
    @ResponseBody
    public List<SimpleScoreCount> getScoreCountByClasscode(String classcode, String ctname){

        List<SimpleScoreCount> simpleScoreCounts = null;
        if(classcode != null && classcode.length() > 0){
            List<BaseinfoForTrainee> baseinfoForTrainees = learnProdurceService.getBaseinfoForTraineeByClassCode(classcode);
            simpleScoreCounts = learnProdurceService.getScoreCountByClasscode(classcode);
            if(simpleScoreCounts == null){
                simpleScoreCounts = new ArrayList<SimpleScoreCount>();
            }
            boolean isExist = false;
            for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                isExist = false;
                for(SimpleScoreCount simpleScoreCount:simpleScoreCounts){
                    if(simpleScoreCount.getCode().equals(baseinfoForTrainee.getCode())){
                        simpleScoreCount.setClasscode(classcode);
                        simpleScoreCount.setCtname(ctname);
                        String trname = learnProdurceService.getTrnameByCode(simpleScoreCount.getCode());
                        simpleScoreCount.setName(trname);

                        isExist = true;
                        break;
                    }

                }
                if(isExist == false){
                    SimpleScoreCount simpleScoreCount = new SimpleScoreCount();
                    simpleScoreCount.setCode(baseinfoForTrainee.getCode());
                    simpleScoreCount.setCount(0);

                    simpleScoreCount.setClasscode(classcode);
                    simpleScoreCount.setCtname(ctname);
                    System.out.println(simpleScoreCount.getCode());
                    String trname = learnProdurceService.getTrnameByCode(simpleScoreCount.getCode());
                    simpleScoreCount.setName(trname);

                    simpleScoreCounts.add(simpleScoreCount);

                }
            }

        }

        return simpleScoreCounts;
    }



    @RequestMapping(value = "/getPhasesByClasscode")
    @ResponseBody
    public List<String> getPhasesByClasscode(String classcode, String code){
        int did = classService.getDirectionIdByClassCode(classcode);
        List<String> sections = classService.getSectionsByDid(did);

        List<Score> scores = learnProdurceService.getScoreDetailByCode(code);
        if(scores != null && scores.size() > 0){
            for(Score score:scores){
                for(String section:sections){
                    if(section.equals(score.getTname())){
                        sections.remove(section);
                        break;
                    }
                }
            }
        }


        //

        return sections;
    }


    @RequestMapping(value = "/getScoreDetailByCode")//得到学员的所有成绩
    @ResponseBody
    public List<Score> getScoreDetailByCode(String code){
        List<Score> scores = learnProdurceService.getScoreDetailByCode(code);
        return scores;
    }


    @RequestMapping(value = "/saveNewScore")
    @ResponseBody
    public Score saveNewScore(String code,String classcode, String ttime, String tname, float tscore, String detail){
        Score score = new Score();
        score.setCode(code);
        score.setClasscode(classcode);
        score.setTtime(ttime);
        score.setTname(tname);
        score.setTscore(tscore);
        score.setDetail(detail);
        int did = classService.getDirectionIdByClassCode(classcode);
        score.setDid(did);
        score.setTid(-1);//为了和插入表返回的tid做区分

        learnProdurceService.saveNewScore(score);
        //更新班级考试时间
        classService.updateClassExamDate(classcode, ttime);
        return score;
    }



    @RequestMapping(value = "/getScoreCountByName")
    @ResponseBody
    public List<SimpleScoreCount> getScoreCountByName(String name){

        List<SimpleScoreCount> simpleScoreCounts = new ArrayList<>();

        List<KVStr> classcodeCtname = classService.getClasscodeCTName();//班级编号和班主任名字
        List<KVStr> trCodes = classService.getTrcodeCcodeByTrname(name);//学员编号和班级编号
        if(trCodes != null){
            for(KVStr codeclasscode:trCodes){
                String classcode = codeclasscode.getV();
                String ctname = Tool.getValueByKey(classcodeCtname, classcode);//班主任名字

                String code = codeclasscode.getK();
                SimpleScoreCount simpleScoreCount = learnProdurceService.getScoreCountByCode(code);
                simpleScoreCount.setCtname(ctname);
                simpleScoreCount.setClasscode(classcode);

                String trname = classService.getTrnameByCode(code);
                simpleScoreCount.setName(trname);

                simpleScoreCounts.add(simpleScoreCount);

            }
        }


        return simpleScoreCounts;
    }



//    @RequestMapping(value = "/saveNewScore")
//    @ResponseBody
//    public String saveNewScore(String code, String timee, int score, String score_detail, String check_item,String dname){
//
//        int result = learnProdurceService.updateScoreItem(code, timee, score, score_detail, check_item, dname);
//        if(result > 0){
//            return "success";
//        }
//        return "fail";
//    }



    @RequestMapping(value = "/updateScoreInfo")
    @ResponseBody
    public KVStr updateScoreInfo(Score score){
        KVStr kvStr = null;
        int result = learnProdurceService.updateScoreInfo(score);

        if(result > 0){
            kvStr =employService.getcodeNameByTid(score.getTid());
        }
        return kvStr;
    }



    @RequestMapping(value = "/attence")
    @PreAuthorize("hasPermission('/procedure/attence','y')")
    public String attence(Map<String, Object> model){
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

//        List<String>  talkTypes = learnProdurceService.listTalkTypes();
//        model.put("talkTypes", talkTypes);
//
//        List<String>  learnStates = learnProdurceService.listLearnStates();
//        model.put("learnStates", learnStates);

        List<String> classcodes = classService.getClassCodesByClid(classTeachers.get(0).getCtid());
        model.put("classcodes", classcodes);
        return "learnProcdure_attence";
    }




    @RequestMapping(value = "/importAttence", method = RequestMethod.POST)
    @ResponseBody
    public String importAttence(@RequestParam(value = "excelFile", required = false) MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();

        try {
            MultipartRequest multipartRequest = (MultipartRequest) request;
            MultipartFile excelFile = multipartRequest.getFile("excelFile");

            if (excelFile != null) {
                String name = excelFile.getOriginalFilename();
                if(true == classService.isExistFile(name)){
                    json.put("result", "fail");
                    json.put("reason","该文件数据已经存在，不能重复导入");
                    return json.toString();

                }else{

                    List<List<List<String>>> datas = ExcelUtil.readExcelLoop(excelFile.getInputStream());
                    int result = learnProdurceService.importAttence(datas,json);

                    if(result > 1){
                        json.put("result", "success");
                    }else{
                        json.put("result", "fail");
                    }
                }
            }else{
                json.put("result", "fail");
            }


        } catch (Exception e) {
            json.put("result", "exception");
        }

        return json.toString();
    }



    @RequestMapping(value = "/getAttenceOriginals")
    @ResponseBody
    public List<ProcessAttenceOriginal> getAttenceOriginals(String classcode, String startTime, String endTime){

        List<ProcessAttenceOriginal> processAttenceOriginals = learnProdurceService.getAttenceOriginals(classcode, startTime, endTime);

        return processAttenceOriginals;
    }


    @RequestMapping(value = "/getAttenceOriginalsByName")
    @ResponseBody
    public List<ProcessAttenceOriginal> getAttenceOriginalsByName(String name){

        List<ProcessAttenceOriginal> processAttenceOriginals = learnProdurceService.getAttenceOriginalsByName(name);

        return processAttenceOriginals;
    }



    @RequestMapping(value = "/getAttenceDays")
    @ResponseBody
    public List<ProcessAttenceDay> getAttenceDays(String classcode, String startTime, String endTime){

        List<ProcessAttenceDay> processAttenceDays = learnProdurceService.getAttenceDays(classcode, startTime, endTime);

        return processAttenceDays;
    }



    @RequestMapping(value = "/getAttenceDaysByName")
    @ResponseBody
    public List<ProcessAttenceDay> getAttenceDaysByName(String name){

        List<ProcessAttenceDay> processAttenceDays = learnProdurceService.getAttenceDaysByName(name);

        return processAttenceDays;
    }

    @RequestMapping(value = "/getAttenceDaysByCode")
    @ResponseBody
    public List<ProcessAttenceDay> getAttenceDaysByCode(String code){

        List<ProcessAttenceDay> processAttenceDays = learnProdurceService.getAttenceDaysByCode(code);

        return processAttenceDays;
    }



    @RequestMapping(value = "/getSummary")
    @ResponseBody
    public List<ProcessAttenceMSummary> getSummary(String classcode, String month){

        List<ProcessAttenceMSummary> processAttenceMSummaries = learnProdurceService.getAttenceSummarys(classcode, month);

        return processAttenceMSummaries;
    }



    @RequestMapping(value = "/getAttenceSummaryByName")
    @ResponseBody
    public List<ProcessAttenceMSummary> getAttenceSummaryByName(String name){
        List<ProcessAttenceMSummary> processAttenceMSummaries = learnProdurceService.getAttenceSummarysByName(name);

        return processAttenceMSummaries;
    }



    @RequestMapping(value = "/getClassTeacherByCid")
    @ResponseBody
    public List<ClassTeacher> getClassTeacherByCid(int centerId){

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(centerId);

        return classTeachers;
    }


    @RequestMapping("/onDownload")
    public String downloadFile(HttpServletRequest request,
                               HttpServletResponse response) throws UnsupportedEncodingException {

        String fileName = "考勤报表模板.xlsx"; //下载的文件名

        // 如果文件名不为空，则进行下载
        if (fileName != null) {
            //设置文件路径
            String realPath = "C:/teach-upload/";
            File file = new File(realPath, fileName);

            // 如果文件名存在，则进行下载
            if (file.exists()) {

                // 配置文件下载
                response.setHeader("content-type", "application/octet-stream");
                response.setContentType("application/octet-stream");
                // 下载文件能正常显示中文
                response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));

                // 实现文件下载
                byte[] buffer = new byte[1024];
                FileInputStream fis = null;
                BufferedInputStream bis = null;
                try {
                    fis = new FileInputStream(file);
                    bis = new BufferedInputStream(fis);
                    OutputStream os = response.getOutputStream();
                    int i = bis.read(buffer);
                    while (i != -1) {
                        os.write(buffer, 0, i);
                        i = bis.read(buffer);
                    }
                    System.out.println("Download the song successfully!");
                }
                catch (Exception e) {
                    System.out.println("Download the song failed!");
                }
                finally {
                    if (bis != null) {
                        try {
                            bis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    if (fis != null) {
                        try {
                            fis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
        return null;
    }


    @RequestMapping(value = "/downloadScoreInfo")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> downloadScoreInfo(HttpServletResponse response, String classcode, String ctname){
        String dname = classService.getDirectionNameByClassCode(classcode);
        String trname = null;
        String fileName = "学员成绩_" + classcode + ctname + "_" + Tool.getCurrentDate() + ".xlsx";
        String filePth = "C:/teach-upload/" + fileName;
        File file = new File(filePth);
        try {
            if(!file.exists()){
                List<Score> scores = learnProdurceService.getScoreDetailByClasscode(classcode);
                for(Score s:scores){
                    trname = classService.getTrnameByCode(s.getCode());
                    s.setTrname(trname);
                    s.setCtname(ctname);
                    s.setDname(dname);
                }
                ExcelUtil.createScoreFile(filePth, scores);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        // 如果文件名存在，则进行下载
        // 配置文件下载
        response.setHeader("content-type", "application/octet-stream");
        response.setContentType("application/octet-stream");
        // 下载文件能正常显示中文
        try {
            response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        // 实现文件下载
        byte[] buffer = new byte[1024];
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        try {
            fis = new FileInputStream(file);
            bis = new BufferedInputStream(fis);
            OutputStream os = response.getOutputStream();
            int i = bis.read(buffer);
            while (i != -1) {
                os.write(buffer, 0, i);
                i = bis.read(buffer);
            }
            System.out.println("Download successfully!");
        }
        catch (Exception e) {
            System.out.println("Download failed!");
        }
        finally {
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return null;

    }



}
