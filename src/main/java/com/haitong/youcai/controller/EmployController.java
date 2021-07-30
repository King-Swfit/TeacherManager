package com.haitong.youcai.controller;

import com.alibaba.fastjson.JSONObject;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.*;
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
import java.net.InetAddress;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2019/5/20.
 */
@Controller
@RequestMapping("/employ")
public class EmployController {

    @Autowired
    private ClassService classService;

    @Autowired
    private JiaoWuService jiaoWuService;

    @Autowired
    private LearnProdurceService learnProdurceService;

    @Autowired
    private EmployService employService;

    @Autowired
    private CorporiationService corporiationService;

    @RequestMapping(value = "/dynamicData")
    @PreAuthorize("hasPermission('/employ/dynamicData','y')")
    public String getEmployInfo(Map<String, Object> model, HttpServletRequest request) throws UnknownHostException {

        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

        ClassQueryCondition classQueryCondition = new ClassQueryCondition();
        String[] days = Tool.getDefaultTimeSection();
        classQueryCondition.setCenterId(-1);
        classQueryCondition.setClassteacherId(classTeachers.get(0).getCtid());
        classQueryCondition.setStartTime(days[0]);
        classQueryCondition.setEndTime(days[1]);
        classQueryCondition.setClassstate("全部");
        List<String> classcodes = classService.getClassGeneralInfoByCondition3(classQueryCondition);
        model.put("classcodes",classcodes);


        List<String> employTypes = employService.getEmployTypes();
        model.put("employTypes", employTypes);

        model.put("imgDefault", Tool.serverAddress + "/img/default.jpg");

        List<Corporiation> corporiations = corporiationService.getSimpleCorporiationInfos();
        model.put("corporiations",corporiations);


        String endTime=Tool.getCurrentDate();
        String startTime=Tool.getLastYearDate();
        List<Center> centers_recent = classService.getCenterListForBetweenTime(startTime, endTime);
        model.put("centers_recent", centers_recent);

        List<Direction> directions_recent = jiaoWuService.getDirectionInfoForBetweenTime(startTime, endTime);
        model.put("directions_recent", directions_recent);

        List<String> classcodes_recent = classService.listClasscodeForBetweenTime(startTime, endTime);
        model.put("classcodes_recent", classcodes_recent);

        return "employProcdure_dynamicData";
    }





    @RequestMapping(value = "/getBaseinfoForTraineeByCondition")
    @ResponseBody
    public BaseinfoForTrainee getBaseinfoForTraineeByCode(String classcode, String code){
        BaseinfoForTrainee baseinfoForTrainee = employService.getBaseinfoForTraineeByCode(classcode, code);
        return baseinfoForTrainee;
    }



    @RequestMapping(value = "/saveNewInterview")
    @ResponseBody
    public int saveNewInterview(@RequestParam("data") String data){
        int result = -1;

        JSONObject json = JSONObject.parseObject(data);
        ProcessEmployInterview processEmployInterview = new ProcessEmployInterview();
        processEmployInterview.setCode(json.get("code").toString());
        processEmployInterview.setClasscode(json.get("classcode").toString());
        processEmployInterview.setDatetimee(json.get("datetimee").toString());
        processEmployInterview.setCorporiation(json.get("corporiation").toString());
        processEmployInterview.setPosition(json.get("position").toString());
        processEmployInterview.setType(json.get("type").toString());
        Object sa = json.get("salary");
        if(sa == null){
            processEmployInterview.setSalary(0);
        }else{
            if(sa.toString().length() == 0){
                processEmployInterview.setSalary(0);
            }else{
                processEmployInterview.setSalary(Integer.parseInt(sa.toString()));
            }

        }

        Object res = json.get("result");
        if(res == null){
            processEmployInterview.setResult("未知");
        }else{
            processEmployInterview.setResult(res.toString());
        }

        Object realS = json.get("realSalary");
        if(realS == null ){
            processEmployInterview.setRealSalary(0);
        }else{
            if(realS.toString().length() == 0){
                processEmployInterview.setRealSalary(0);
            }else{
                processEmployInterview.setRealSalary(Integer.parseInt(realS.toString()));
            }

        }

        Object fuli = json.get("fuli");
        if(fuli == null){
            processEmployInterview.setFuli("未知");
        }else{
            processEmployInterview.setFuli(fuli.toString());
        }


        result = employService.saveNewInterview(processEmployInterview);
        if(result > 0){
            return processEmployInterview.getPeiid();
        }

        return -1;
    }


    @RequestMapping(value = "/insertInterviewRecord")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> insertInterviewRecord(ProcessEmployInterview processEmployInterview){
        String code = processEmployInterview.getCode();
        BaseinfoForTrainee baseinfoForTrainee = classService.getBaseInfoForTraineeByCode(code);
        processEmployInterview.setClasscode(baseinfoForTrainee.getClasscode());

        int result = employService.insertInterviewRecord(processEmployInterview);

        //插入成功，显示全部
        if(result > 0){
            return employService.listProcessEmployInterviewRecordByCode(code);
        }
        return null;//失败则不刷新界面
    }


    @RequestMapping(value = "/deleteInterViewRecordByPeiid")
    @ResponseBody
    public String deleteInterViewRecordByPeiid(int peiid){
        int result = employService.deleteInterViewRecordByPeiid(peiid);

        if(result > 0){
            return "success";
        }
        return "fail";//失败则不刷新界面
    }



    @RequestMapping(value = "/updateInterviewRecord2")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> updateInterviewRecord2(ProcessEmployInterview processEmployInterview){
        int result = employService.updateInterviewRecord2(processEmployInterview);
        if(result > 0){
            return employService.listProcessEmployInterviewRecordByCode(processEmployInterview.getCode());
        }
        return null;
    }



    @RequestMapping(value = "/deleteScoreByTid")
    @ResponseBody
    public JSONObject delteScoreByTid(int tid){
        JSONObject json = new JSONObject();
        KVStr kv = null;
        kv =employService.getcodeNameByTid(tid);
        if(kv != null){
            json.put("code", kv.getK());
            json.put("name", kv.getV());
        }

        int result = employService.deleteScoreByTid(tid);
        if(result > 0){
            json.put("result","success");
        }else{
            json.put("result","fail");
        }
        return json;//失败则不刷新界面
    }


    @RequestMapping(value = "/getScoreByTid")
    @ResponseBody
    public JSONObject getScoreByTid(int tid){
        JSONObject json = new JSONObject();
        Score score = employService.getScoreByTid(tid);
        json.put("score", score);

        int did = classService.getDirectionIdByClassCode(score.getClasscode());
        List<String> items = classService.getSectionsByDid(did);
        json.put("items", items);
        return json;//失败则不刷新界面
    }


    @RequestMapping(value = "/getClassCodeByCondition")
    @ResponseBody
    public JSONObject getClassCodeByCondition(int centerId, int ctid, String startTime, String endTime, String type, String result){
        JSONObject jsonObject = new JSONObject();

        if(ctid == -1){
            List<ClassTeacher> classTeachers =  classService.getClassTeachersByCenterId(centerId);
            jsonObject.put("classTeachers", classTeachers);

            if(classTeachers != null && classTeachers.size() > 0) {
                ctid = classTeachers.get(0).getCtid();//
            }
        }
        List<String> classcodes = learnProdurceService.getClassCodesByCondition(centerId, ctid,startTime,endTime);//此处centerId无用
        jsonObject.put("classcodes", classcodes);

        if(classcodes != null && classcodes.size() > 0){

            List<ProcessEmployInterviewRecord> processEmployInterviewRecords = listProcessEmployInterviewRecordByCondition_process(classcodes.get(0), type, result);

            jsonObject.put("processEmployInterviewRecords",processEmployInterviewRecords);
        }


        return jsonObject;
    }


    @RequestMapping(value = "/getProcessEmployInterviewRecordsByName")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> getProcessEmployInterviewRecordsByName(String name){
        return listProcessEmployInterviewRecordByName(name);
    }

    private List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByName(String name) {

        //所有的面试记录

        List<ProcessEmployInterviewRecord> processEmployInterviewRecords;

        if (name.substring(0,3).toUpperCase().charAt(0) >= 'A' && name.substring(0,3).toUpperCase().charAt(0) <= 'Z') {
            processEmployInterviewRecords  = employService.listInterviewRecordByCode(name);
        } else {
            processEmployInterviewRecords  = employService.listInterviewRecordByName(name);
        }

        if(processEmployInterviewRecords != null){
            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords){
                String dname = classService.getDirectionNameByCode(processEmployInterviewRecord.getCode());
                processEmployInterviewRecord.setDname(dname);
            }

            List<ProcessEmployInterviewRecord> processEmployInterviewRecords_success = new ArrayList<>();
            Map<String, ProcessEmployInterviewRecord> processEmployInterviewRecords_summary_map = new HashMap<>();

            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords){
                if(processEmployInterviewRecord.getResult() != null && processEmployInterviewRecord.getResult().equals("成功")){
                    processEmployInterviewRecords_success.add(processEmployInterviewRecord);
                }else{
                    processEmployInterviewRecords_summary_map.put(processEmployInterviewRecord.getCode(), processEmployInterviewRecord);//不成功的去重
                }
            }

            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords_success){
                processEmployInterviewRecords_summary_map.put(processEmployInterviewRecord.getCode(), processEmployInterviewRecord);//覆盖上成功的
            }

            //提取所有去重的记录
            List<ProcessEmployInterviewRecord> processEmployInterviewRecords_result = new ArrayList<>();
            for(String key : processEmployInterviewRecords_summary_map.keySet()){
                ProcessEmployInterviewRecord value = processEmployInterviewRecords_summary_map.get(key);
                processEmployInterviewRecords_result.add(value);
            }


            return processEmployInterviewRecords_result;
        }

        return null;
    }


    @RequestMapping(value = "/listProcessEmployInterviewRecordByCondition")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByCondition(String classcode, String type, String result){
        return listProcessEmployInterviewRecordByCondition_process(classcode, type, result);
    }

    private List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByCondition_process(String classcode, String type, String result){
        int directionId = classService.getDirectionIdByClassCode(classcode);
        String dname = classService.getDnameByDid(directionId);

        //所有的面试记录
        List<ProcessEmployInterviewRecord> processEmployInterviewRecords = employService.listInterviewRecordByCondition(classcode, type, result);
        if(processEmployInterviewRecords != null){
            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords){
                processEmployInterviewRecord.setDname(dname);
            }

            List<ProcessEmployInterviewRecord> processEmployInterviewRecords_success = new ArrayList<>();
            Map<String, ProcessEmployInterviewRecord> processEmployInterviewRecords_summary_map = new HashMap<>();

            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords){
                if(processEmployInterviewRecord.getResult() != null && processEmployInterviewRecord.getResult().equals("成功")){
                    processEmployInterviewRecords_success.add(processEmployInterviewRecord);
                }else{
                    processEmployInterviewRecords_summary_map.put(processEmployInterviewRecord.getCode(), processEmployInterviewRecord);//不成功的去重
                }
            }

            for(ProcessEmployInterviewRecord processEmployInterviewRecord:processEmployInterviewRecords_success){
                processEmployInterviewRecords_summary_map.put(processEmployInterviewRecord.getCode(), processEmployInterviewRecord);//覆盖上成功的
            }

            //提取所有去重的记录
            List<ProcessEmployInterviewRecord> processEmployInterviewRecords_result = new ArrayList<>();
            for(String key : processEmployInterviewRecords_summary_map.keySet()){
                ProcessEmployInterviewRecord value = processEmployInterviewRecords_summary_map.get(key);
                processEmployInterviewRecords_result.add(value);
            }


            return processEmployInterviewRecords_result;
        }

        return null;

    }

    @RequestMapping(value = "/listProcessEmployInterviewRecordByCode")
    @ResponseBody
    public List<ProcessEmployInterviewRecord> listProcessEmployInterviewRecordByCode(String code){
        List<ProcessEmployInterviewRecord> processEmployInterviewRecords = employService.listProcessEmployInterviewRecordByCode(code);
        return processEmployInterviewRecords;
    }


    @RequestMapping(value = "/getInterviewRecordByPeiid")
    @ResponseBody
    public ProcessEmployInterviewRecord getInterviewRecordByPeiid(int peiid, HttpServletRequest request) throws UnknownHostException {
        ProcessEmployInterviewRecord processEmployInterviewRecord = employService.getInterviewRecordByPeiid(peiid);
        if(processEmployInterviewRecord != null ){
            String proof = processEmployInterviewRecord.getEmployProof();
            if(proof != null){
                processEmployInterviewRecord.setImgurl(Tool.serverAddress + "/" + proof);
            }

        }
        return processEmployInterviewRecord;
    }



    @RequestMapping(value = "/getProcessEmployInterviewRecordCodeByClasscode")
    @ResponseBody
    public JSONObject getProcessEmployInterviewRecordCodeByClasscode(String classcode){

        JSONObject jsonObject = new JSONObject();
        int directionId = classService.getDirectionIdByClassCode(classcode);
        String dname = classService.getDnameByDid(directionId);
        jsonObject.put("directionId", directionId);
        jsonObject.put("dname", dname);

        List<BaseinfoForTrainee> baseinfoForTrainees = employService.listBaseinfoForTraineeByClassCode(classcode);
        jsonObject.put("baseinfoForTrainees", baseinfoForTrainees);

        List<ProcessEmployInterviewRecord> processEmployInterviewRecords = employService.listInterviewRecordByClassCode(classcode);
        jsonObject.put("processEmployInterviewRecords",processEmployInterviewRecords);


        return jsonObject;
    }






    @RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject uploadFile(MultipartFile imgFile, HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException {
        response.setContentType("text/html; charset=utf-8");
        JSONObject jsonObject = new JSONObject();
        // 原始名称
        String oldFileName = imgFile.getOriginalFilename(); // 获取上传文件的原名
        //获取服务器指定文件存取路径 
        String savedDir = "C:\\teach-upload\\";


        // 上传图片
        if (imgFile != null && oldFileName != null && oldFileName.length() > 0) {

            String code = request.getParameter("code");
            if(code != null && code.length() > 0){
                // 新的图片名称
                String newFileName ="employ" +  code  + "_" + oldFileName;
                // 新图片
                File newFile = new File(savedDir + "\\" + newFileName);
                // 将内存中的数据写入磁盘
                imgFile.transferTo(newFile);

                jsonObject.put("address",Tool.serverAddress + "/" + newFileName) ;
                jsonObject.put("result", newFileName) ;
            }else {
                jsonObject.put("result", "") ;
            }



        }

        return jsonObject;
    }


    @RequestMapping(value = "/uploadImg2", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject uploadFile2(MultipartFile imgFile2, HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException {
        response.setContentType("text/html; charset=utf-8");
        JSONObject jsonObject = new JSONObject();
        // 原始名称
        String oldFileName = imgFile2.getOriginalFilename(); // 获取上传文件的原名
        //获取服务器指定文件存取路径 
        String savedDir = "C:\\teach-upload\\";


        // 上传图片
        if (imgFile2 != null && oldFileName != null && oldFileName.length() > 0) {

            String code = request.getParameter("code2");
            if(code != null && code.length() > 0){
                // 新的图片名称
                String newFileName ="employ" +  code  + "_" + oldFileName;
                // 新图片
                File newFile = new File(savedDir + "\\" + newFileName);
                // 将内存中的数据写入磁盘
                imgFile2.transferTo(newFile);

                jsonObject.put("address", Tool.serverAddress + "/" + newFileName) ;
                jsonObject.put("result", newFileName) ;
            }else {
                jsonObject.put("result", "") ;
            }



        }

        return jsonObject;
    }



    @RequestMapping(value = "/insertInterviewImgurl")
    @ResponseBody
    public String insertInterviewImgurl( String code, String employProof){
       if(code != null && employProof != null && code.length() > 0 && employProof.length() > 0){
           code = code.trim();
           employProof = employProof.trim();
           int result = employService.saveInterviewEmployProof(code, employProof);
           if(result > 0){
               return "success";
           }else{
               return "fail";
           }
       }
       return "fail";
    }




    @RequestMapping(value = "/getPhotoNameByPeiid")
    @ResponseBody
    public String getPhotoNameByPeiid( int peiid, HttpServletRequest request) throws UnknownHostException {
        String fileName = employService.getPhotoNameByPeiid(peiid);
        if(fileName != null && fileName.length() > 0){

            fileName = Tool.serverAddress + "/" + fileName;
        }
        return fileName;
    }

    @RequestMapping(value = "/getImgurlByCode")
    @ResponseBody
    public String getImgurlByCode( String code, HttpServletRequest request) throws UnknownHostException {
        String imgurlll = null;
        code=code.trim();
        System.out.println(code);
        List<String> imgurls = employService.getImgurlByCode(code);
        if(imgurls != null && imgurls.size() > 0){
           for(String imgurl:imgurls){
               if(imgurl != null && imgurl.length() > 0){
                   imgurlll =  Tool.serverAddress + "/" + imgurl;
                   break;
               }

           }

        }
        return imgurlll;
    }


    @RequestMapping(value = "/getImgurlByPeiid")
    @ResponseBody
    public String getImgurlByPeiid( int peiid, HttpServletRequest request) throws UnknownHostException {

        String imgurl = employService.getImgurlByPeiid(peiid);
        if(imgurl != null && imgurl.length() > 0){
            return Tool.serverAddress + "/" + imgurl;
        }
        return null;
    }


    @RequestMapping(value = "/summary")
    @PreAuthorize("hasPermission('/employ/summary','y')")
    public String summary(Map<String, Object> model){

        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);
        return "employProcdure_summary";
    }


    @RequestMapping(value = "/querySummary_class")
    @ResponseBody
    public List<EmploySummary> querySummary_class( String startTime, String endTime){

        int centerId = -1;
        List<EmploySummary> employSummarys = new ArrayList<>();

        //每个班面试的总次数
        List<KV> kvs = classService.getInterviewCountForClass(centerId, startTime, endTime);
        for(KV kv:kvs){
            EmploySummary employSummary = new EmploySummary();
            employSummary.setClasscode(kv.getK());
            employSummary.setCount(kv.getV());
            String dname = classService.getDirectionNameByClassCode(employSummary.getClasscode());
            employSummary.setDname(dname);

            employSummarys.add(employSummary);
        }



        List<AvgSalary> avgSalarys = classService.getAvgSalaryForZhuan(centerId, startTime, endTime);
        for(AvgSalary avgSalary:avgSalarys){
            String classcode = avgSalary.getClasscode();
            for(EmploySummary employSummary:employSummarys){
                if(employSummary.getClasscode().equals(classcode)){
                    employSummary.setAvgSalary_zhuan(avgSalary.getAvgSalaryForZhuan());
                    String ctname = classService.getCTNameByClassCode(classcode);
                    employSummary.setCtname(ctname);
                    break;
                }
            }

        }

        List<AvgSalary> avgSalarys2 = classService.getAvgSalaryForBen(centerId, startTime, endTime);
        for(AvgSalary avgSalary:avgSalarys2){
            String classcode = avgSalary.getClasscode();
            for(EmploySummary employSummary:employSummarys){
                if(employSummary.getClasscode().equals(classcode)){
                    employSummary.setAvgSalary_ben(avgSalary.getAvgSalaryForBen());
                    String ctname = classService.getCTNameByClassCode(classcode);
                    employSummary.setCtname(ctname);
                    break;
                }
            }

        }

        List<KV> kv1 = classService.getClassNumbers();

        List<KV> kvs2 = classService.getClassCount(startTime, endTime);
        for(KV kv:kvs2){
            String classcode = kv.getK();
            int pNumbers = 0;
            for(KV classcodeNumbers:kv1){
                if(classcodeNumbers.getK().equals(classcode)){
                    pNumbers = classcodeNumbers.getV();
                    break;
                }
            }
            for(EmploySummary employSummary:employSummarys){
                if(employSummary.getClasscode().equals(classcode) && pNumbers > 0){
                    employSummary.setAvgInterviewTimes(kv.getV()*1.0f/pNumbers );
                    break;
                }
            }
        }



        Map<String,KVI> kviMap = new HashMap<>();
        List<InterviewPeriod> interviewPeriods = classService.getInterviewPeriod(startTime, endTime);
        for(InterviewPeriod interviewPeriod:interviewPeriods){
            if(null == kviMap.get(interviewPeriod.getClasscode1())){
                KVI kvi= new KVI();
                kvi.setNum(1);
                kvi.setCount(interviewPeriod.getPeriod());

                kviMap.put(interviewPeriod.getClasscode1(), kvi);
            }else{
                KVI kvi=kviMap.get(interviewPeriod.getClasscode1());
                kvi.setNum(kvi.getNum()+1);
                kvi.setCount(kvi.getCount()+interviewPeriod.getPeriod());
                kviMap.put(interviewPeriod.getClasscode1(), kvi);
            }
        }

        for(EmploySummary employSummary:employSummarys){
            KVI kvi = kviMap.get(employSummary.getClasscode());
            if(null != kvi && kvi.getNum() !=0){
                float period = kvi.getCount()*1.0f/kvi.getNum();
                employSummary.setAvgEmployPeriod(period);
            }
        }



        List<KV> kvs3 = classService.getCountForInterviewSuccess(startTime, endTime);
        List<KV> kvs4 = classService.getCountForDevSuccess(startTime, endTime);
        for(EmploySummary employSummary:employSummarys){
            String classcode = employSummary.getClasscode();
            int v3 = 0;
            int v4 = 0;
            for(KV kv:kvs3){
                if(kv.getK().equals(classcode)){
                    v3 = kv.getV();
                    break;
                }
            }

            for(KV kv:kvs4){
                if(kv.getK().equals(classcode)){
                    v4 = kv.getV();
                    break;
                }
            }

            if(v3 > 0){
                employSummary.setPercentDevlop(v4*1f/v3*100);
                employSummary.setPercentNoDevlop((1-v4*1f/v3)*100);
            }
        }



        return employSummarys;
    }

    @RequestMapping(value = "/querySummary_center")
    @ResponseBody
    public List<EmploySummary> querySummary_center( String startTime, String endTime){

        List<EmploySummary> employSummarys = new ArrayList<>();
        List<Center> centers = jiaoWuService.getCenterList2();
        for(Center center: centers){
            EmploySummary employSummary = new EmploySummary();
            employSummary.setCname(center.getCname());
            employSummarys.add(employSummary);
        }
        EmploySummary allEmploySummary = new EmploySummary();
        allEmploySummary.setCname("所有中心");

        //中心本科平均工资
        List<FKV> center_ben_avgsalarys = classService.getCenterBenAvgSalary(startTime, endTime);
        Integer allCenterBenAvgSalary = classService.getAllCenterBenAvgSalary(startTime, endTime);
        if(allCenterBenAvgSalary == null){
            allCenterBenAvgSalary = 0;
        }
        allEmploySummary.setAvgSalary_ben(allCenterBenAvgSalary);
        //中心专科平均工资
        List<FKV> center_zhuan_avgsalarys = classService.getCenterZhuanAvgSalary(startTime, endTime);
        Integer allCenterZhuanAvgSalary = classService.getAllCenterZhuanAvgSalary(startTime, endTime);
        if(allCenterZhuanAvgSalary == null){
            allCenterZhuanAvgSalary = 0;
        }
        allEmploySummary.setAvgSalary_zhuan(allCenterZhuanAvgSalary);



        //中心面试次数
        List<KV> center_interviewTimes = classService.getCenterInterviewTimes(startTime, endTime);
        //中心人数
        List<KV> center_tNumbers = classService.getCenterTraineeNumbers(startTime, endTime);

        Integer allcenter_interviewTimes = classService.getAllCenterInterviewTimes(startTime, endTime);
        Integer allcenter_tNumbers = classService.getAllCenterTraineeNumbers(startTime, endTime);
        float allcenter_avgInterviewTimes = Tool.getAvgInterviewTimes(allcenter_interviewTimes, allcenter_tNumbers);
        allEmploySummary.setAvgInterviewTimes(allcenter_avgInterviewTimes);


        //每个学员找工作周期
        List<KV> code_periods = classService.getTrcodePeriod(startTime, endTime);
        //每个学员所在中心
        List<KVStr> code_cnames = classService.listCodeCname(startTime, endTime);

        float allcenter_avgPeriods = Tool.getAvgPeriods(code_periods);
        allEmploySummary.setAvgEmployPeriod(allcenter_avgPeriods);



        //每个中心找到开发岗位的人数
        List<KV> center_devNumbers = classService.getCnameDevNumbers(startTime, endTime);
        //每个中心找到工作的人数
        List<KV> center_workNumbers = classService.getCnameWorkNumbers(startTime, endTime);

        float allcenter_devPercent = Tool.getAllCenterDevPercent(center_devNumbers, center_workNumbers);
        float allcenter_notdevPercent = 100 - allcenter_devPercent;
        allEmploySummary.setPercentDevlop(allcenter_devPercent);
        allEmploySummary.setPercentNoDevlop(allcenter_notdevPercent);



        //赋值
        for(FKV centerBenSalary:center_ben_avgsalarys){
            for(EmploySummary employSummary:employSummarys){
                if(centerBenSalary.getK().equals(employSummary.getCname())){
                    employSummary.setAvgSalary_ben((int)centerBenSalary.getV());
                    break;
                }
            }
        }
        for(FKV centerZhuanSalary:center_zhuan_avgsalarys){
            for(EmploySummary employSummary:employSummarys){
                if(centerZhuanSalary.getK().equals(employSummary.getCname())){
                    employSummary.setAvgSalary_zhuan((int)centerZhuanSalary.getV());
                    break;
                }
            }
        }

        float avgInterviewTimes = 0f;
        for(KV centerInterviewTime:center_interviewTimes){
            for(KV centerTNumber:center_tNumbers){
                if(centerInterviewTime.getK().equals(centerTNumber.getK())){
                    avgInterviewTimes = centerInterviewTime.getV()*1.0f/centerTNumber.getV();
                }
            }

            for(EmploySummary employSummary:employSummarys){
                if(centerInterviewTime.getK().equals(employSummary.getCname())){
                    employSummary.setAvgInterviewTimes(avgInterviewTimes);
                    break;
                }
            }
        }





        Map<String,Integer> centerTimeMap = new HashMap<>();//每个中心的人次
        for(KV codePeriod:code_periods){
            for(KVStr codeCName:code_cnames){
                if(codePeriod.getK().equals(codeCName.getK())){
                    for(EmploySummary employSummary:employSummarys){
                        if(codeCName.getV().equals(employSummary.getCname())){

                            //累计每个中心的面试周期之和
                            float avgInterviewPeriods =employSummary.getAvgEmployPeriod();
                            avgInterviewPeriods = avgInterviewPeriods + codePeriod.getV();
                            employSummary.setAvgEmployPeriod(avgInterviewPeriods);

                            //统计每个中心的人数
                            Integer times = centerTimeMap.get(codeCName.getV());
                            if(times == null){
                                centerTimeMap.put(codeCName.getV(), 1);
                            }else{
                                times++;
                                centerTimeMap.put(codeCName.getV(), times);
                            }
                            break;
                        }
                    }
                    break;
                }
            }


        }
        for(EmploySummary employSummary:employSummarys){
            Integer times = centerTimeMap.get(employSummary.getCname());
            if(times != null){
                employSummary.setAvgEmployPeriod(employSummary.getAvgEmployPeriod()/times);
            }

        }


        for(KV centerWorkNumber:center_workNumbers){
            int cnt = 0;
            for(KV centerDevNumber:center_devNumbers){
                if(centerDevNumber.getK().equals(centerWorkNumber.getK())){
                    cnt = centerDevNumber.getV();
                    break;
                }

            }

            for(EmploySummary employSummary:employSummarys){
                if(employSummary.getCname().equals(centerWorkNumber.getK())){
                    employSummary.setPercentDevlop(100*1f*cnt/centerWorkNumber.getV());
                    employSummary.setPercentNoDevlop(100*(1-1f*cnt/centerWorkNumber.getV()));
                    break;
                }
            }


        }

        employSummarys.add(allEmploySummary);


        return employSummarys;
    }

    @RequestMapping(value = "/querySummary_direction")
    @ResponseBody
    public List<EmploySummary> querySummary_direction( String startTime, String endTime){

        List<Direction> directions = jiaoWuService.getDirectionInfo2();
        List<EmploySummary> employSummarys = new ArrayList<>();
        for(Direction direction: directions){
            EmploySummary employSummary = new EmploySummary();
            employSummary.setDname(direction.getDname());
            employSummarys.add(employSummary);
        }

        //方向本科平均工资
        List<FKV> direction_ben_avgsalarys = classService.getDirectionBenAvgSalary(startTime, endTime);
        //方向专科平均工资
        List<FKV> direction_zhuan_avgsalarys = classService.getDirectionZhuanAvgSalary(startTime, endTime);

        //方向面试次数
        List<KV> direction_interviewTimes = classService.getDirectionInterviewTimes(startTime, endTime);
        //方向人数
        List<KV> direction_tNumbers = classService.getDirectionTraineeNumbers();

        //每个学员找工作周期
        List<KV> code_periods = classService.getTrcodePeriod(startTime, endTime);
        //每个学员所在方向
        List<KVStr> code_dnames = classService.listCodeDname(startTime, endTime);

        //每个方向找到开发岗位的人数
        List<KV> direction_devNumbers = classService.getDnameDevNumbers(startTime, endTime);
        //每个方向找到工作的人数
        List<KV> direction_workNumbers = classService.getDnameWorkNumbers(startTime, endTime);


        //赋值
        for(FKV directionBenSalary:direction_ben_avgsalarys){
            for(EmploySummary employSummary:employSummarys){
                if(directionBenSalary.getK().equals(employSummary.getDname())){
                    employSummary.setAvgSalary_ben((int)directionBenSalary.getV());
                    break;
                }
            }
        }
        for(FKV directionZhuanSalary:direction_zhuan_avgsalarys){
            for(EmploySummary employSummary:employSummarys){
                if(directionZhuanSalary.getK().equals(employSummary.getDname())){
                    employSummary.setAvgSalary_zhuan((int)directionZhuanSalary.getV());
                    break;
                }
            }
        }

        float avgInterviewTimes = 0f;
        for(KV directionInterviewTime:direction_interviewTimes){
            for(KV directionTNumber:direction_tNumbers){
                if(directionInterviewTime.getK().equals(directionTNumber.getK())){
                    avgInterviewTimes = directionInterviewTime.getV()*1.0f/directionTNumber.getV();
                }
            }

            for(EmploySummary employSummary:employSummarys){
                if(directionInterviewTime.getK().equals(employSummary.getDname())){
                    employSummary.setAvgInterviewTimes(avgInterviewTimes);
                    break;
                }
            }
        }





        Map<String,Integer> directionTimeMap = new HashMap<>();//每个中心的人次
        for(KV codePeriod:code_periods){
            for(KVStr codeDName:code_dnames){
                if(codePeriod.getK().equals(codeDName.getK())){
                    for(EmploySummary employSummary:employSummarys){
                        if(codeDName.getV().equals(employSummary.getDname())){

                            //累计每个中心的面试周期之和
                            float avgInterviewPeriods =employSummary.getAvgEmployPeriod();
                            avgInterviewPeriods = avgInterviewPeriods + codePeriod.getV();
                            employSummary.setAvgEmployPeriod(avgInterviewPeriods);

                            //统计每个中心的人数
                            Integer times = directionTimeMap.get(codeDName.getV());
                            if(times == null){
                                directionTimeMap.put(codeDName.getV(), 1);
                            }else{
                                times++;
                                directionTimeMap.put(codeDName.getV(), times);
                            }
                            break;
                        }
                    }
                    break;
                }
            }


        }
        for(EmploySummary employSummary:employSummarys){
            Integer times = directionTimeMap.get(employSummary.getDname());
            if(times != null){
                employSummary.setAvgEmployPeriod(employSummary.getAvgEmployPeriod()/times);
            }

        }


        for(KV directionWorkNumber:direction_workNumbers){
            int cnt = 0;
            for(KV directionDevNumber:direction_devNumbers){
                if(directionDevNumber.getK().equals(directionWorkNumber.getK())){
                    cnt = directionDevNumber.getV();
                    break;
                }

            }

            for(EmploySummary employSummary:employSummarys){
                if(employSummary.getDname().equals(directionWorkNumber.getK())){
                    employSummary.setPercentDevlop(100*cnt/directionWorkNumber.getV());
                    employSummary.setPercentNoDevlop(100*(1-cnt/directionWorkNumber.getV()));
                    break;
                }
            }


        }




        return employSummarys;
    }

    @RequestMapping(value = "/querySummary_position")
    @ResponseBody
    public List<EmploySummary> querySummary_position( String startTime, String endTime){

        List<EmploySummary> employSummarys = new ArrayList<>();
        EmploySummary devSummary = new EmploySummary();
        devSummary.setPname("开发岗位");
        EmploySummary notDevSummary = new EmploySummary();
        notDevSummary.setPname("非开发岗位");



        //开发岗位本科平均工资
        Float dev_ben_avgsalarys = classService.getDevBenAvgSalary(startTime, endTime);
        //开发岗位专科平均工资
        Float dev_zhuan_avgsalarys = classService.getDevZhuanAvgSalary(startTime, endTime);
        if(dev_ben_avgsalarys != null){
            devSummary.setAvgSalary_ben( dev_ben_avgsalarys);
        }
        if(dev_zhuan_avgsalarys != null){
            devSummary.setAvgSalary_zhuan(dev_zhuan_avgsalarys);
        }


        //非开发岗位本科平均工资
        Float notdev_ben_avgsalarys = classService.getNotDevBenAvgSalary(startTime, endTime);
        //非开发岗位专科平均工资
        Float notdev_zhuan_avgsalarys = classService.getNotDevZhuanAvgSalary(startTime, endTime);
        if(notdev_ben_avgsalarys != null){
            notDevSummary.setAvgSalary_ben(notdev_ben_avgsalarys);
        }
        if(notdev_zhuan_avgsalarys != null){
            notDevSummary.setAvgSalary_zhuan(notdev_zhuan_avgsalarys);
        }


        //开发岗位面试次数
        Float dev_interviewTimes = classService.getDevInterviewTimes(startTime, endTime);
        //开发岗位人数
        Float dev_tNumbers = classService.getDevTraineeNumbers(startTime, endTime);
        if(dev_tNumbers != null && dev_tNumbers > 0){
            devSummary.setAvgInterviewTimes(dev_interviewTimes/dev_tNumbers);
            devSummary.setCount((int)dev_tNumbers.floatValue());
        }else{
            devSummary.setAvgInterviewTimes(0);
        }


        //开发岗位面试次数
        Float notdev_interviewTimes = classService.getNotDevInterviewTimes(startTime, endTime);
        //非开发岗位人数
        Float notdev_tNumbers = classService.getNotDevTraineeNumbers(startTime, endTime);


        if(notdev_tNumbers != null && notdev_tNumbers > 0){
            notDevSummary.setAvgInterviewTimes(notdev_interviewTimes/notdev_tNumbers);
            notDevSummary.setCount((int)notdev_tNumbers.floatValue());
        }else{
            notDevSummary.setAvgInterviewTimes(0);
        }


        //开发岗位找工作周期之和
        List<Float> dev_periods = classService.getDevTrcodePeriod(startTime, endTime);
        List<Float> notdev_periods = classService.getNotDevTrcodePeriod(startTime, endTime);
        if(notdev_tNumbers != null && notdev_tNumbers > 0){
            float count = 0;
            for(Float c:dev_periods){
                count = count + c;
            }
            devSummary.setAvgEmployPeriod(count/notdev_tNumbers);
        }else{
            devSummary.setAvgEmployPeriod(0);
        }
        if(notdev_tNumbers != null && notdev_tNumbers > 0){
            float count = 0;
            for(Float c:notdev_periods){
                count = count + c;
            }
            notDevSummary.setAvgEmployPeriod(count/notdev_tNumbers);
        }else{
            notDevSummary.setAvgEmployPeriod(0);
        }


        employSummarys.add(devSummary);
        employSummarys.add(notDevSummary);



        return employSummarys;
    }


//    @RequestMapping(value = "/downloadEmployInfo")
//    @ResponseBody
//    public List<ProcessEmployInterviewRecord> downloadEmployInfo(HttpServletResponse response, String classcode, String type, String result){
//
//        String fileName = "就业信息_" + classcode + type + result + "_" + Tool.getCurrentDate() + ".xlsx";
//        String filePth = "C:/teach-upload/" + fileName;
//        File file = new File(filePth);
//        try {
//            if(!file.exists()){
//                List<ProcessEmployInterviewRecord> processEmployInterviewRecords = listProcessEmployInterviewRecordByCondition_process(classcode, type, result);
//                ExcelUtil.createEmployFile(filePth, processEmployInterviewRecords);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//
//        // 如果文件名存在，则进行下载
//        // 配置文件下载
//        response.setHeader("content-type", "application/octet-stream");
//        response.setContentType("application/octet-stream");
//        // 下载文件能正常显示中文
//        try {
//            response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//
//        // 实现文件下载
//        byte[] buffer = new byte[1024];
//        FileInputStream fis = null;
//        BufferedInputStream bis = null;
//        try {
//            fis = new FileInputStream(file);
//            bis = new BufferedInputStream(fis);
//            OutputStream os = response.getOutputStream();
//            int i = bis.read(buffer);
//            while (i != -1) {
//                os.write(buffer, 0, i);
//                i = bis.read(buffer);
//            }
//            System.out.println("Download successfully!");
//        }
//        catch (Exception e) {
//            System.out.println("Download failed!");
//        }
//        finally {
//            if (bis != null) {
//                try {
//                    bis.close();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//            if (fis != null) {
//                try {
//                    fis.close();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//
//        return null;
//
//    }


    @RequestMapping(value = "/exportEmployInfo")          //way--- 0中心  1方向   2班级
    public String exportEmployInfo(HttpServletResponse response, String startTime, String endTime,  Integer way, String value, String type, String result){
        if(value == null){
            return null;
        }

        String fileName = "就业信息_" + startTime + endTime + way+"" + value + Tool.getCurrentDate() + ".xlsx";
        String filePth = "C:/teach-upload/" + fileName;
        File file = new File(filePth);

        List<List<ProcessEmployInterviewRecord>> processEmployInterviewRecords_all = new ArrayList<>();
        List<String> classcodes = new ArrayList<>();

        try {

            switch(way){
                case 2:
                    classcodes.add(value);
                    break;
                case 1:
                    int did = Integer.parseInt(value);
                    classcodes = classService.getClasscodeByDirectionIdTime(did, startTime, endTime);
                    break;
                case 0:
                    int cid = Integer.parseInt(value);
                    classcodes = classService.getClassCodesByCenterIdTime(cid, startTime, endTime);
                    break;
            }

            if(classcodes.size() > 0 ){
                for(String classcode:classcodes){
                    List<ProcessEmployInterviewRecord> processEmployInterviewRecords = listProcessEmployInterviewRecordByCondition_process(classcode, type, result);
                    processEmployInterviewRecords_all.add(processEmployInterviewRecords);
                }

                ExcelUtil.createEmployFile(filePth, processEmployInterviewRecords_all);

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




    @RequestMapping(value = "/importEmployInfos", method = RequestMethod.POST)
    @ResponseBody
    public String importEmployInfos(@RequestParam(value = "excelFile", required = false) MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();


        try {
            MultipartRequest multipartRequest = (MultipartRequest) request;
            MultipartFile excelFile = multipartRequest.getFile("excelFile");

            if (excelFile != null) {
                String fileNmae = excelFile.getOriginalFilename();
                if(true == classService.isExistFile(fileNmae)){
                    json.put("result", "fail");
                    json.put("reason","该文件数据已经存在，不能重复导入");

                    return json.toString();
                }else{
                    List<List<String>> datas = ExcelUtil.readExcel(excelFile.getInputStream());
                    if (datas != null && datas.size() > 0) {
                        int result = employService.insertInterviewRecords(datas);
                        if(result > 0){
                            json.put("result", "success");
                        }else{
                            json.put("result", "fail");
                        }

                    }
                }

            } else {
                json.put("result", "fail");
            }


        } catch (Exception e) {
            json.put("result", "exception");
        }

        return json.toString();
    }





}
