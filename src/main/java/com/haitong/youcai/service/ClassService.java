package com.haitong.youcai.service;

import com.haitong.youcai.entity.*;
import com.haitong.youcai.mapper.ClassMapper;
import com.haitong.youcai.mapper.JiaoWuMapper;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Administrator on 2019/3/27.
 */
@Service
public class ClassService {
    @Autowired
    private ClassMapper classMapper;

    @Autowired
    private JiaoWuMapper jiaoWuMapper;

    public List<Center> getCenterList(){
        return classMapper.getCenterList();
    }


    public List<Direction> getDirectionList() {
        return classMapper.getDirectionList();
    }

    public List<ClassTeacher> getClassTeachersByCenterId(int cid) {
        return classMapper.getClassTeachersByCenterId(cid);
    }

    public List<Course_t> getCourseIdsByDirectionId(int directionId) {
        return classMapper.getCourseIdsByDirectionId(directionId);
    }


    public List<SimpleTeacher> getTeachersByCid(Integer cid) {
        return classMapper.getTeachersByCid(cid);
    }



    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public boolean insertNewClass(BaseInfo_Class baseInfo_class, List<CoursePlanItem_Class> coursePlanItems) {
        boolean isSuccess = false;
        int result = classMapper.insertBaseInfos(baseInfo_class);
        if(result > 0 && coursePlanItems!=null && !coursePlanItems.isEmpty()){
            classMapper.insertCoursePlanItems(coursePlanItems);
            isSuccess = true;
        }

        return isSuccess;
    }

    public List<ClassGeneralInfo> getClassGeneralInfo() {
        return classMapper.getClassGeneralInfo();
    }

    public BaseInfo_Class getBaseInfoByClid(int clid) {
        return classMapper.getBaseInfoByClid(clid);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public boolean updateClass(BaseInfo_Class baseInfo_class, List<CoursePlanItem_Class> coursePlanItems) {
        boolean isSuccess = false;
        int result = classMapper.updateBaseInfos(baseInfo_class);
        if(result > 0){
            if(coursePlanItems != null && coursePlanItems.size() > 0){
                classMapper.updateCoursePlanItems(coursePlanItems);

            }
            isSuccess = true;

        }

        return isSuccess;
    }

    public List<String> getClassCodesByClidState(int ctid, String state) {
        List<String> list = null;

        if(0 != ctid){
            if("全部".equals(state)){
                list = classMapper.getClassCodesByCtid(ctid);
            }else{
                list = classMapper.getClassCodesByCtidState(ctid, state);
            }

        }

        return list;
    }

    public List<String> getClassCodesByClid(int ctid) {
        return classMapper.getClassCodesByCtid(ctid);
    }

    public List<BaseinfoForTrainee> getTrainBaseInfo(String classcode, String traineestate) {
        return classMapper.getTrainBaseInfo(classcode, traineestate);
    }

    public int insertTrainees(List<List<String>> datas, int centerId, Direction direction,String classstate, String beginDate) {
        List<BaseinfoForTrainee> baseinfoForTrainees = new ArrayList<>();
        List<EmployInfoForTrainee> employInfoForTrainees = new ArrayList<>();
        if(datas.size() > 1){
            String classcode = datas.get(1).get(4);
            String ctname = datas.get(1).get(5);
            int ctid =-1;

            //班级不存在的话，先创建班级
            BaseInfo_Class baseInfo_class = classMapper.getClidByClassCode(classcode);
            if(baseInfo_class == null){

                //班主任不存在的话，创建班主任
                ClassTeacher classTeacher = classMapper.getClassTeacherByCtName(ctname);
                if(classTeacher == null){
                    ClassTeacher classTeacher2 = new ClassTeacher();
                    classTeacher2.setCenterId(centerId);
                    classTeacher2.setCtname(ctname);
                    int result = jiaoWuMapper.insertBeforeClassTeacher(classTeacher2);//创建班主任
                    if(result > 0){
                        ctid = classTeacher2.getCtid();
                    }
                }else{
                    ctid = classTeacher.getCtid();
                }

                baseInfo_class = new BaseInfo_Class();
                baseInfo_class.setClassteacherId(ctid);
                baseInfo_class.setClasscode(classcode);
                baseInfo_class.setBeginDate(beginDate);
                baseInfo_class.setState(classstate);
                baseInfo_class.setDirectionId(direction.getDid());
                baseInfo_class.setCenterId(centerId);

                classMapper.insertBaseInfos(baseInfo_class);//创建班级
            }

            String tmp;
            //插入学员表
            for(int i = 1; i < datas.size(); i++){

                List<String> list = datas.get(i);
                if(list.size() < 7 ){
                    continue;
                }

                BaseinfoForTrainee baseinfoForTrainee = new BaseinfoForTrainee();
                baseinfoForTrainee.setCode(list.get(0));
                baseinfoForTrainee.setName(list.get(1));
                baseinfoForTrainee.setGender(list.get(2));
                baseinfoForTrainee.setCard(list.get(3));
                baseinfoForTrainee.setClasscode(list.get(4));
                baseinfoForTrainee.setCtname(list.get(5));
                baseinfoForTrainee.setState(list.get(6));

                if(list.size() > 7){
                    tmp = list.get(7);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 5){
                        tmp = tmp.substring(0, 5);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setDiploma(tmp);

                if(list.size() > 8){
                    tmp = list.get(8);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 25){
                        tmp = tmp.substring(0, 25);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setProfession(tmp);

                if(list.size() > 9){
                    tmp = list.get(9);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 25){
                        tmp = tmp.substring(0, 25);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setGraduateSchool(tmp);

                if(list.size() > 10){
                    tmp = list.get(10);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 20){
                        tmp = tmp.substring(0, 20);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setGraducateTime(tmp);

                if(list.size() > 11){
                    tmp = list.get(11);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 30){
                        tmp = tmp.substring(0, 30);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setTel(tmp);

                if(list.size() > 12){
                    tmp = list.get(12);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 30){
                        tmp = tmp.substring(0, 30);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setEmail(tmp);

                if(list.size() > 13){
                    tmp = list.get(13);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 30){
                        tmp = tmp.substring(0, 30);
                    }
                }else{
                    tmp = "";
                }
                baseinfoForTrainee.setContact(tmp);

                if(list.size() > 14){
                    tmp = list.get(14);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 30){
                        tmp = tmp.substring(0, 30);
                    }
                }else{
                    tmp = "";
                }

                baseinfoForTrainee.setContactTel(tmp);

                if(list.size() > 15){
                    tmp = list.get(15);
                    if(tmp == null){
                        tmp = "";
                    }
                    if(tmp.length() > 20){
                        tmp = tmp.substring(0, 20);
                    }
                }else{
                    tmp = "";
                }

                baseinfoForTrainee.setLendWay(tmp);

                baseinfoForTrainee.setDirectionId(direction.getDid());
                baseinfoForTrainee.setCenterId(centerId);

                baseinfoForTrainees.add(baseinfoForTrainee);


                if(list.size() >= 20){
                    EmployInfoForTrainee employInfoForTrainee = new EmployInfoForTrainee();
                    employInfoForTrainee.setCode(list.get(0));
                    if(list.get(16) != null){
                        employInfoForTrainee.setState(list.get(16));
                    }else{
                        employInfoForTrainee.setState("未定");
                    }

                    if(list.get(17) != null){
                        employInfoForTrainee.setEmploy_time(list.get(17));
                    }else{
                        employInfoForTrainee.setEmploy_time("8000-01-01");
                    }

                    if(list.get(18) != null){
                        employInfoForTrainee.setEmploy_unit(list.get(18));
                    }else{
                        employInfoForTrainee.setEmploy_unit("未定");
                    }

                    if(list.get(19) != null){
                        employInfoForTrainee.setEmploy_position(list.get(19));
                    }else{
                        employInfoForTrainee.setEmploy_position("未定");
                    }

                    String salary = list.get(20);
                    if(salary != null){
                        if(salary.length() == 0){
                            employInfoForTrainee.setEmploy_salary(0);
                        }else{
                            if(salary.contains("-")){
                                salary = salary.split("-")[1];
                            }
                            employInfoForTrainee.setEmploy_salary(Integer.parseInt(salary));
                        }
                    }else{
                        employInfoForTrainee.setEmploy_salary(0);
                    }


                    if(list.size() > 21 && list.get(21) != null){
                        employInfoForTrainee.setComment(list.get(21));
                    }

                    employInfoForTrainees.add(employInfoForTrainee);

                }else{
                    EmployInfoForTrainee employInfoForTrainee = new EmployInfoForTrainee();
                    employInfoForTrainee.setCode(list.get(0));
                    employInfoForTrainee.setState("未定");
                    employInfoForTrainee.setEmploy_time("8000-01-01");
                    employInfoForTrainee.setEmploy_unit("未定");
                    employInfoForTrainee.setEmploy_position("未定");
                    employInfoForTrainee.setEmploy_salary(0);
                    employInfoForTrainee.setComment("未定");

                    employInfoForTrainees.add(employInfoForTrainee);
                }

            }

            //成绩
            classMapper.createComprehensiveBaseInfos_batchTrainee(baseinfoForTrainees);//comprehensivescore_baseinfo_trainee(code)--教务，综合成绩


            //班级存档，包括转班学员
            for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                classMapper.saveArchiveForCodeClasscode(baseinfoForTrainee.getCode(), baseinfoForTrainee.getClasscode());
            }

            //对之前存在学员的存在。处理方案：不再插入。只根据情况更改班级编号
            Iterator<BaseinfoForTrainee> it = baseinfoForTrainees.iterator();
            String code;
            while(it.hasNext()){
                BaseinfoForTrainee baseinfoForTrainee = it.next();
                classcode = baseinfoForTrainee.getClasscode();
                code = baseinfoForTrainee.getCode();
                String timee = classMapper.getBeginDateByCode(code);//该学员已经存在，timee之前开班时间
                if(timee != null && timee.length() > 0){
                    if(beginDate.compareTo(timee) > 0){
                        classMapper.updateTraineeClasscode(code, classcode);
                    }
                    it.remove();
                }
            }

            //int result = classMapper.insertBaseInfos_batchTrainee(baseinfoForTrainees);//baseinfo_trainee(code, trname, gender, directionId,centerId, card, classcode,diploma,graducateTime,profession,graduateSchool,tel,email,contact,contactTel,lendWay)
            int result = 0;
            for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
                if(baseinfoForTrainee != null && baseinfoForTrainee.getName() != null){
                    System.out.println(baseinfoForTrainee.getName());
                    result =  result + classMapper.insertBaseInfos_batchTrainee_one(baseinfoForTrainee);
                }

            }

            String tmpCode;
            Integer id;
            for(int i = 0; i < employInfoForTrainees.size(); i++){
                EmployInfoForTrainee employInfoForTrainee = employInfoForTrainees.get(i);
                tmpCode = employInfoForTrainee.getCode();
                if(tmpCode != null && tmpCode.length() > 0){
                    result = classMapper.insertEmployInfoForTrainee(employInfoForTrainee);// employinfo_trainee(code, state, employ_time, employ_unit,employ_position,employ_salary,comment)
                }



            }

            return result;

        }

        return -1;

    }


    //线上转入学员
    public void insertTraineeForSwitch(BaseinfoForTrainee baseinfoForTrainee, EmployInfoForTrainee employInfoForTrainee) {

        //综合成绩
        classMapper.createComprehensiveBaseInfo(baseinfoForTrainee.getCode());

        //班级存档，包括转班学员
        classMapper.saveArchiveForCodeClasscode(baseinfoForTrainee.getCode(), baseinfoForTrainee.getClasscode());

        //baseinfo_trainee
        if(baseinfoForTrainee.getName() != null){
           classMapper.insertBaseInfos_batchTrainee_one(baseinfoForTrainee);
        }

        String code;
        Integer id;
        code = employInfoForTrainee.getCode();
        if(code != null && code.length() > 0){
            id = classMapper.getComprehensiveScoreIdByCode(code);//避免重复导入
            if(id == null){
                //求职信息
                // employinfo_trainee(code, state, employ_time, employ_unit,employ_position,employ_salary,comment)
                classMapper.insertEmployInfoForTrainee(employInfoForTrainee);
            }
        }



    }

    public Integer updateTraineePhotoState(String code,  int type, String value) {
        int result = -1;
        switch (type){
            case 0:
                result = classMapper.updatePayproofState(code, value);
                break;
            case 1:
                result = classMapper.updateDiplomaState(code, value);
                break;
            case 2:
                result = classMapper.updateWorkproofState(code, value);
                break;
            case 3:
                result = classMapper.updateCard1State(code, value);
                break;
            case 4:
                result = classMapper.updateCard2State(code, value);
                break;
        }
        return result;
    }


    public String getPhotoNameByCodeType(String code, int type) {
        String fileName = null;
        switch (type){
            case 0:
                fileName = classMapper.getPhotoNameByCodeType_pay(code);
                break;
            case 1:
                fileName = classMapper.getPhotoNameByCodeType_diploma(code);
                break;
            case 2:
                fileName = classMapper.getPhotoNameByCodeType_work(code);
                break;
            case 3:
                fileName = classMapper.getPhotoNameByCodeType_card1(code);
                break;
            case 4:
                fileName = classMapper.getPhotoNameByCodeType_card2(code);
                break;
        }
        return fileName;
    }

    public Integer createNews(News news) {
        return classMapper.createNews(news);
    }

    public void createImgForNews(String uploadFileName, int newsId) {
        classMapper.createImgForNews(uploadFileName, newsId);
    }

    public void updateNews(int newsId, String title, String html) {
        classMapper.updateNews(newsId, title, html);
    }

    public List<News> listNews(String classcode) {
        return classMapper.listNews(classcode);
    }

    public String getNewsContentByNewsId(int newsId) {
        return classMapper.getNewsContentByNewsId(newsId);
    }

    public List<String> getClassCodesByClidTime(int ctid, String startTime, String endTime) {
        return classMapper.getClassCodesByClidTime(ctid, startTime,endTime);
    }


    public List<ComprehensiveScore_java> getComprehensiveScoreByClassCode_java(String classcode) {
        return classMapper.getComprehensiveScoreByClassCode_java(classcode);
    }

    public List<ComprehensiveScore_ai> getComprehensiveScoreByClassCode_ai(String classcode) {
        return classMapper.getComprehensiveScoreByClassCode_ai(classcode);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public boolean updateComprehensiveScoreByClassCode_java(ComprehensiveScore_java comprehensiveScore_java) {
        boolean isSuccess = false;
        ComprehensiveScore_baseinfo comprehensivesScore_baseInfo = new ComprehensiveScore_baseinfo();
        comprehensivesScore_baseInfo.setCode(comprehensiveScore_java.getCode());
        comprehensivesScore_baseInfo.setDiploma(comprehensiveScore_java.getDiploma());
        comprehensivesScore_baseInfo.setGraduateTime(comprehensiveScore_java.getGraduateTime());
        comprehensivesScore_baseInfo.setEnery_employ(comprehensiveScore_java.getEnery_employ());
        comprehensivesScore_baseInfo.setPrefession(comprehensiveScore_java.getPrefession());
        comprehensivesScore_baseInfo.setSalary(comprehensiveScore_java.getSalary());
        comprehensivesScore_baseInfo.setCorporation(comprehensiveScore_java.getCorporation());
        comprehensivesScore_baseInfo.setType(comprehensiveScore_java.getType());

        int result = classMapper.updateComprehensiveScoreByClassCode_baseInfo(comprehensivesScore_baseInfo);
        if(result > 0){
            classMapper.updateComprehensiveScoreByClassCode_java(comprehensiveScore_java);
            isSuccess = true;
        }

        return isSuccess;

    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public boolean updateComprehensiveScoreByClassCode_ai(ComprehensiveScore_ai comprehensiveScore_ai) {
        boolean isSuccess = false;
        ComprehensiveScore_baseinfo comprehensivesScore_baseInfo = new ComprehensiveScore_baseinfo();
        comprehensivesScore_baseInfo.setCode(comprehensiveScore_ai.getCode());
        comprehensivesScore_baseInfo.setDiploma(comprehensiveScore_ai.getDiploma());
        comprehensivesScore_baseInfo.setGraduateTime(comprehensiveScore_ai.getGraduateTime());
        comprehensivesScore_baseInfo.setEnery_employ(comprehensiveScore_ai.getEnery_employ());
        comprehensivesScore_baseInfo.setPrefession(comprehensiveScore_ai.getPrefession());
        comprehensivesScore_baseInfo.setSalary(comprehensiveScore_ai.getSalary());
        comprehensivesScore_baseInfo.setCorporation(comprehensiveScore_ai.getCorporation());
        comprehensivesScore_baseInfo.setType(comprehensiveScore_ai.getType());

        int result = classMapper.updateComprehensiveScoreByClassCode_baseInfo(comprehensivesScore_baseInfo);
        if(result > 0){
            classMapper.updateComprehensiveScoreByClassCode_ai(comprehensiveScore_ai);
            isSuccess = true;
        }

        return isSuccess;

    }

    public List<String> getXuejiUpdateTypes() {
        return jiaoWuMapper.getXuejiUpdateTypes();
    }

    public List<ClassGeneralInfo> getClassGeneralInfoByCondition(ClassQueryCondition classQueryCondition) {
        return classMapper.getClassGeneralInfoByCondition(classQueryCondition);
    }

    public List<String> listClassStates() {
        return classMapper.listClassStates();
    }

    public List<String> getTraineeStates() {
        return classMapper.getTraineeStates();
    }

    public List<String> getPayWays() {
        return classMapper.getPayWays();
    }

    public List<String> getEmployWays() {
        return classMapper.getEmployWays();
    }


    public List<String> getDiplomaStates() {
        return classMapper.getDiplomaStates();
    }

    public List<BaseinfoForTrainee> getBaseInfoForTraineeByClassCode(String classcode) {
        return classMapper.getBaseInfoForTraineeByClassCode(classcode);
    }


    public int getClassTeacherIdByClassCode(String classcode) {
        return classMapper.getClassTeacherIdByClassCode(classcode);
    }

    public String getCtnameByCtid(int ctid) {
        return classMapper.getCtnameByCtid(ctid);
    }

    public int getDirectionIdByClassCode(String classcode) {
        return classMapper.getDirectionIdByClassCode(classcode);
    }

    public String getDnameByDid(int did) {
        return classMapper.getDnameByDid(did);
    }

    public void insertBaseInfoForTrainee(BaseinfoForTrainee baseinfoForTrainee) {
        classMapper.insertBaseInfoForTrainee(baseinfoForTrainee);
    }

    public void insertEmployInfoForTrainee(EmployInfoForTrainee employInfoForTrainee) {
        classMapper.insertEmployInfoForTrainee(employInfoForTrainee);
    }

    public BaseinfoForTrainee getBaseInfoForTraineeByCode(String code) {
        return classMapper.getBaseInfoForTraineeByCode(code);
    }

    public void updateBaseInfoForTrainee(BaseinfoForTrainee baseinfoForTrainee) {
        classMapper.updateBaseInfoForTrainee(baseinfoForTrainee);
    }

    public void updateEmployInfoForTrainee(EmployInfoForTrainee employInfoForTrainee) {
        classMapper.updateEmployInfoForTrainee(employInfoForTrainee);
    }

    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.DEFAULT,timeout=36000,rollbackFor=Exception.class)
    public int createTraineePhotoForBaseInfo(String code,  String classcode, int type, String value) {
        int result = -1;
        switch (type){
            case 0:
                result = classMapper.createPayproofState(code, value);
                break;
            case 1:
                result = classMapper.createDiplomaState(code, value);
                break;
            case 2:
                result = classMapper.createWorkproofState(code, value);
                break;
            case 3:
                result = classMapper.createCard1State(code, value);
                break;
            case 4:
                result = classMapper.createCard2State(code, value);
                break;
        }


        result = classMapper.createEmployInfo(code);

        result = classMapper.createComprehensiveBaseInfo(code);

        int directionId = classMapper.getDirectionIdByClassCode(classcode);
        if(directionId == 2){
            result = classMapper.createComprehensiveScoreInfo_java(code);
        }else if(directionId == 3){
            result = classMapper.createComprehensiveScoreInfo_ai(code);
        }

        BaseinfoForTrainee baseinfoForTrainee = new BaseinfoForTrainee();
        baseinfoForTrainee.setCode(code);
        baseinfoForTrainee.setClasscode(classcode);
        result = classMapper.createTraineeScore(baseinfoForTrainee);

        return result;
    }

    public Integer getCenterIdByCname(String cname) {
        return classMapper.getCenterIdByCname(cname);
    }

//    public Integer saveNewTranee(BaseinfoForTrainee baseinfoForTrainee, EmployInfoForTrainee employInfoForTrainee){
//
//        insertBaseInfoForTrainee(baseinfoForTrainee);
//        insertEmployInfoForTrainee(employInfoForTrainee);
//
//        int directionId = baseinfoForTrainee.getDirectionId();
//        classMapper.createComprehensiveBaseInfo(baseinfoForTrainee.getCode());
//        if(directionId == 13){
//            classMapper.createComprehensiveScoreInfo_java(baseinfoForTrainee.getCode());
//        }else if(directionId == 12){
//            classMapper.createComprehensiveScoreInfo_ai(baseinfoForTrainee.getCode());
//        }
//
//        return classMapper.createTraineeScore(baseinfoForTrainee);//学习期间质检和考试成绩
//    }


    public List<String> listClasscode(){
        return classMapper.listClasscode();
    }

    public List<KV> getInterviewCountForClass(int centerId, String startTime, String endTime) {
        return classMapper.getInterviewCountForClass(centerId, startTime, endTime);
    }

    public List<AvgSalary> getAvgSalaryForZhuan(int centerId, String startTime, String endTime) {
        return classMapper.getAvgSalaryForZhuan(centerId, startTime, endTime);
    }

    public List<AvgSalary> getAvgSalaryForBen(int centerId, String startTime, String endTime) {
        return classMapper.getAvgSalaryForBen(centerId, startTime, endTime);
    }

    public List<KV> getClassCount(String startTime, String endTime) {
        return classMapper.getClassCount(startTime, endTime);
    }

    public List<InterviewPeriod> getInterviewPeriod(String startTime, String endTime) {
        return classMapper.getInterviewPeriod(startTime,endTime);
    }

    public List<KV> getCountForInterviewSuccess(String startTime, String endTime) {
        return classMapper.getCountForInterviewSuccess(startTime,endTime);
    }

    public List<KV> getCountForDevSuccess(String startTime, String endTime) {
        return classMapper.getCountForDevSuccess(startTime,endTime);
    }

    public List<ClassGeneralInfo> getClassBaseInfo() {
        return classMapper.getClassBaseInfo();
    }

    public List<KVStr> getClasscodeCTName() {
        return classMapper.getClasscodeCTName();
    }

    public List<KV> getInterviewCountForClass2(String classteacherId, String month) {
        return classMapper.getInterviewCountForClass2(classteacherId,month);
    }

    public List<AvgSalary> getAvgSalaryForZhuan2(String classteacherId, String month) {
        return classMapper.getAvgSalaryForZhuan2(classteacherId,month);
    }

    public List<AvgSalary> getAvgSalaryForBen2(String classteacherId, String month) {
        return classMapper.getAvgSalaryForBen2(classteacherId,month);
    }

    public List<InterviewPeriod> getInterviewPeriod2(String classteacherId, String month) {
        return classMapper.getInterviewPeriod2(classteacherId,month);
    }

    public List<KV> getCountForInterviewSuccess2(String classteacherId, String month) {
        return classMapper.getCountForInterviewSuccess2(classteacherId,month);
    }

    public List<KV> getCountForDevSuccess2(String classteacherId, String month) {
        return classMapper.getCountForDevSuccess2(classteacherId,month);
    }

    public List<String> getClassStates() {
        return classMapper.getClassStates();
    }

    public String getCNameByClasscode(String classcode) {
        return classMapper.getCNameByClasscode(classcode);
    }

    public List<ClassGeneralInfo> getClassGeneralInfoByCondition2(ClassQueryCondition classQueryCondition) {
        return classMapper.getClassGeneralInfoByCondition2(classQueryCondition);
    }

    public List<String> getClassGeneralInfoByCondition3(ClassQueryCondition classQueryCondition) {
        return classMapper.getClassGeneralInfoByCondition3(classQueryCondition);
    }

    public List<CoursePlanItem_Class> getCoursePlanByClasscode(String classcode) {
        return classMapper.getCoursePlanByClasscode(classcode);
    }

    public String getCourseNameByCourseId(int courseId) {
        return classMapper.getCourseNameByCourseId(courseId);
    }

    public String getTeacherNameByTeacherId(int teacherId) {
        return classMapper.getTeacherNameByTeacherId(teacherId);
    }

    public List<KVStr> getTrcodeCcodeByTrname(String name) {
        return classMapper.getTrcodeCcodeByTrname(name);
    }

    public List<KVStr> getTrcodeCcodeByCode(String code) {
        return classMapper.getTrcodeCcodeByCode(code);
    }

    public String getTrnameByCode(String code) {
        return classMapper.getTrnameByCode(code);
    }

    public String getDirectionNameByClassCode(String classcode) {
        return classMapper.getDirectionNameByClassCode(classcode);
    }

    public List<String> getSectionsByDid(int did) {
        return classMapper.getSectionsByDid(did);
    }

    public String getDirectionNameByCode(String code) {
        return classMapper.getDirectionNameByCode(code);
    }

    public List<FKV> getCenterBenAvgSalary(String startTime, String endTime) {
        return classMapper.getCenterBenAvgSalary(startTime, endTime);
    }

    public List<FKV> getCenterZhuanAvgSalary(String startTime, String endTime) {
        return classMapper.getCenterZhuanAvgSalary(startTime, endTime);
    }

    public List<KV> getCenterInterviewTimes(String startTime, String endTime) {
        return classMapper.getCenterInterviewTimes(startTime, endTime);
    }

    public List<KV> getCenterTraineeNumbers(String startTime, String endTime) {
        return classMapper.getCenterTraineeNumbers(startTime, endTime);
    }

    public List<KV> getTrcodePeriod(String startTime, String endTime) {
        return classMapper.getTrcodePeriod(startTime, endTime);
    }

    public List<KVStr> listCodeCname(String startTime, String endTime) {
        return classMapper.listCodeCname(startTime, endTime);
    }

    public List<KV> getCnameDevNumbers(String startTime, String endTime) {
        return classMapper.getCnameDevNumbers(startTime, endTime);
    }

    public List<KV> getCnameWorkNumbers(String startTime, String endTime) {
        return classMapper.getCnameWorkNumbers(startTime, endTime);
    }

    public List<FKV> getDirectionBenAvgSalary(String startTime, String endTime) {
        return classMapper.getDirectionBenAvgSalary(startTime, endTime);
    }
    public List<FKV> getDirectionZhuanAvgSalary(String startTime, String endTime) {
        return classMapper.getDirectionZhuanAvgSalary(startTime, endTime);
    }

    public List<KV> getDirectionInterviewTimes(String startTime, String endTime) {
        return classMapper.getDirectionInterviewTimes(startTime, endTime);
    }


    public List<KV> getDirectionTraineeNumbers() {
        return classMapper.getDirectionTraineeNumbers();
    }

    public List<KVStr> listCodeDname(String startTime, String endTime) {
        return classMapper.listCodeDname(startTime, endTime);
    }

    public List<KV> getDnameDevNumbers(String startTime, String endTime) {
        return classMapper.getDnameDevNumbers(startTime, endTime);
    }

    public List<KV> getDnameWorkNumbers(String startTime, String endTime) {
        return classMapper.getDnameWorkNumbers(startTime, endTime);
    }



    public Float getDevBenAvgSalary(String startTime, String endTime) {
        return classMapper.getDevBenAvgSalary(startTime, endTime);
    }

    public Float getDevZhuanAvgSalary(String startTime, String endTime) {
        return classMapper.getDevZhuanAvgSalary(startTime, endTime);
    }

    public Float getNotDevBenAvgSalary(String startTime, String endTime) {
        return classMapper.getNotDevBenAvgSalary(startTime, endTime);
    }

    public Float getNotDevZhuanAvgSalary(String startTime, String endTime) {
        return classMapper.getNotDevZhuanAvgSalary(startTime, endTime);
    }

    public Float getDevInterviewTimes(String startTime, String endTime) {
        return classMapper.getDevInterviewTimes(startTime, endTime);
    }


    public Float getDevTraineeNumbers(String startTime, String endTime) {
        return classMapper.getDevTraineeNumbers(startTime, endTime);
    }

    public Float getNotDevInterviewTimes(String startTime, String endTime) {
        return classMapper.getNotDevInterviewTimes(startTime, endTime);
    }

    public Float getNotDevTraineeNumbers(String startTime, String endTime) {
        return classMapper.getNotDevTraineeNumbers(startTime, endTime);
    }

    public List<Float> getDevTrcodePeriod(String startTime, String endTime) {
        return classMapper.getDevTrcodePeriod(startTime, endTime);
    }

    public List<Float> getNotDevTrcodePeriod(String startTime, String endTime) {
        return classMapper.getNotDevTrcodePeriod(startTime, endTime);
    }

    public String getCTNameByClassCode(String classcode) {
        return classMapper.getCTNameByClassCode(classcode);
    }

    public List<KV> getClassNumbers() {
        return classMapper.getClassNumbers();
    }

    public List<BaseinfoForTrainee> mohuQueryByName(String name) {
        return classMapper.mohuQueryByName(name);
    }

    public List<BaseinfoForTrainee> mohuQueryByCode(String code) {
        return classMapper.mohuQueryByCode(code);
    }

    public List<ComprehensiveScore_java> getComprehensiveScoreByCode_java(String code) {
        return classMapper.getComprehensiveScoreByCode_java(code);
    }

    public List<ComprehensiveScore_ai> getComprehensiveScoreByCode_ai(String code) {
        return classMapper.getComprehensiveScoreByCode_ai(code);
    }

    public BaseinfoForTrainee getBaseInfoForTraineeByCode2(String code) {
        return classMapper.getBaseInfoForTraineeByCode2(code);
    }

    public int updateComprehensiveBaseinfo(ComprehensiveScore_baseinfo comprehensiveScore_baseinfo) {
        return classMapper.updateComprehensiveBaseinfo(comprehensiveScore_baseinfo);
    }

    public boolean isExistFile(String fileNmae) {
        ExistFile existFile = classMapper.selectFileName(fileNmae);
        if(existFile != null){
            return true;
        }else{
            String timee = Tool.getCurrentDetailDate();
            ExistFile e = new ExistFile();
            e.setName(fileNmae);
            e.setTimee(timee);
            int result = classMapper.insertFileName(e);
            if(result > 0){
                return false;
            }
        }
        return true;
    }

    public void updateTraineeStateByClasscode(String classcode, String state) {
        if("在读".equals(state)){
            classMapper.updateTraineeReadingByClasscode(classcode);
        }else if("已结班".equals(state)){
            classMapper.updateTraineeEndClassByClasscode(classcode);
        }
    }

    public String getClassCodesByClid2(int clid) {
        return classMapper.getClassCodesByClid2(clid);
    }

    public void updateClassExamDate(String classcode, String ttime) {
        classMapper.updateClassExamDate(classcode, ttime);
    }

    public Integer getAllCenterBenAvgSalary(String startTime, String endTime) {
        return classMapper.getAllCenterBenAvgSalary(startTime, endTime);
    }

    public List<ClassTeacher> getValidClassTeachers() {
        return classMapper.getValidClassTeachers();
    }


    public Integer getAllCenterZhuanAvgSalary(String startTime, String endTime) {
        return classMapper.getAllCenterZhuanAvgSalary(startTime,endTime);
    }

    public Integer getAllCenterInterviewTimes(String startTime, String endTime) {
        return classMapper.getAllCenterInterviewTimes(startTime,endTime);
    }

    public Integer getAllCenterTraineeNumbers(String startTime, String endTime) {
        return classMapper.getAllCenterTraineeNumbers(startTime,endTime);
    }

    public List<String> listClasscodeForRecent() {
        String endTime=Tool.getCurrentDate();
        String startTime=Tool.getLastYearDate();
        return classMapper.listClasscodeForBetweenTime(startTime,endTime);


    }


    public List<ClassTeacher> getClassTeachersForRecent() {
        String endTime=Tool.getCurrentDate();
        String startTime=Tool.getLastYearDate();
        return classMapper.getClassTeachersForBetweenTime(startTime,endTime);
    }

    public List<String> listClasscodeForBetweenTime(String startTime,String endTime) {
        return classMapper.listClasscodeForBetweenTime(startTime,endTime);
    }


    public List<ClassTeacher> getClassTeachersForBetweenTime(String startTime, String endTime) {
        return classMapper.getClassTeachersForBetweenTime(startTime,endTime);
    }


    public List<String> getClasscodeByTid(int tid) {
        return classMapper.getClasscodeByTid(tid);
    }

    public List<Center> getCenterListForBetweenTime(String startTime, String endTime) {
        return classMapper.getCenterListForBetweenTime(startTime, endTime);
    }

    public List<String> getClasscodeByDirectionIdTime(int did, String startTime, String endTime) {
        return classMapper.getClasscodeByDirectionIdTime(did, startTime, endTime);
    }

    public List<String> getClassCodesByCenterIdTime(int cid, String startTime, String endTime) {
        return classMapper.getClassCodesByCenterIdTime(cid, startTime, endTime);
    }


    public Integer getCenterIdByClasscode(String classcode) {
        return classMapper.getCenterIdByClasscode(classcode);
    }
}
