package com.haitong.youcai.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.ClassService;
import com.haitong.youcai.service.JiaoWuService;
import com.haitong.youcai.service.LearnProdurceService;
import com.haitong.youcai.utils.ExcelUtil;
import com.haitong.youcai.utils.Tool;
import jdk.nashorn.internal.runtime.options.Options;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.HandlerMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2019/3/27.
 */
@Controller
@RequestMapping("/class") //在类上使用RequestMapping，里面设置的value就是方法的父路径
public class ClassController {
    @Autowired
    private ClassService classService;

    @Autowired
    private JiaoWuService jiaoWuService;

    @Autowired
    private LearnProdurceService learnProdurceService;


    @RequestMapping(value = "/new")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/class/new','y')")
    public String getCenterInfo(Map<String, Object> model) {
        //查询数据库，获取教学中心信息
        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        return "class_new";



    }

    @RequestMapping(value = "/getNextCode", method = RequestMethod.POST)  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @ResponseBody
    public String getNextCode(String classcode) {

        String max = "00";
        String code = null;
        String sub_first10 = null;
        String sub_second2 = null;

       List<BaseinfoForTrainee> baseinfoForTrainees = classService.getBaseInfoForTraineeByClassCode(classcode);
       if(baseinfoForTrainees != null && baseinfoForTrainees.size() > 0){
           for(BaseinfoForTrainee b:baseinfoForTrainees){
               code = b.getCode();
               if(code.length() == 12){
                   if(null == sub_first10){
                       sub_first10 = code.substring(0, 10);
                   }
                   sub_second2 = code.substring(10, 12);
                   if(max.compareTo(sub_second2) < 0){
                       max = sub_second2;
                   }
               }
           }
           if(sub_first10 != null){
               int nb = Integer.parseInt(sub_second2);
               nb = nb+1;
               if(nb > 9){
                   return sub_first10 + nb;
               }else{
                   return sub_first10 + "0" + nb;
               }
           }
       }

        return classcode + new Date().getTime();

    }



    @RequestMapping(value = {"/getClassTeachersByCenterId"})
    @ResponseBody
    public JSONObject getClassTeachersByCenterId(int cid, int directionId, String classType) {
        JSONObject result = new JSONObject();

        //查询数据库，获取教学中心信息
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        result.put("classTeachers", classTeachers);

        List<Course_t> course_ts = classService.getCourseIdsByDirectionId(directionId);

        JSONArray jsonArray = new JSONArray();
        for (Course_t course_t : course_ts) {
            JSONObject teachersJson = new JSONObject();

            List<SimpleTeacher> teachers = classService.getTeachersByCid(course_t.getCid());
            teachersJson.put("cid", course_t.getCid());
            teachersJson.put("cname", course_t.getCname());
            teachersJson.put("courseteachers", teachers);

            jsonArray.add(teachersJson);
        }

        result.put("courseTeachers_sets", jsonArray);
        String classcode = createClasscode(cid, directionId, classType);
        result.put("classcode", classcode);

        return result;

    }

    private String createClasscode(int cid, int directionId, String classType){
        if(classType.equals("q")){
            classType = "";
        }
        Center center = jiaoWuService.getCenterByCenterId(cid);
        String cthumb = center.getThumb();
        Direction direction = jiaoWuService.getDirectionByDirectionId(directionId);
        String dthumb = direction.getThumb();

        Calendar cal = Calendar.getInstance();
        int year = cal.get(Calendar.YEAR);
        year = year%100;
        String cnPrefix = cthumb+dthumb+classType+year;

        int max = 0;
        List<String> classcodes = classService.listClasscode();
        for(String classcode:classcodes){
            if(classcode.contains(cnPrefix)){
                String last2 = classcode.substring(classcode.length() - 2);
                int seq = Integer.parseInt(last2);
                if(seq > max){
                    max = seq;
                }
            }
        }
        max = max + 1;
        if(max < 10){
            return cnPrefix+"0"+max;
        }

        return  cnPrefix+max;
    }



    @RequestMapping(value = {"/getClassGeneralInfoByClid"})
    @ResponseBody
    public JSONObject getClassGeneralInfoByClid(int clid) {
        JSONObject result = new JSONObject();

        BaseInfo_Class baseInfo_class = classService.getBaseInfoByClid(clid);
        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(baseInfo_class.getCenterId());
        result.put("classTeachers", classTeachers);

        List<Course_t> course_ts = classService.getCourseIdsByDirectionId(baseInfo_class.getDirectionId());

        JSONArray jsonArray = new JSONArray();
        for (Course_t course_t : course_ts) {
            JSONObject teachersJson = new JSONObject();

            List<SimpleTeacher> teachers = classService.getTeachersByCid(course_t.getCid());
            teachersJson.put("cid", course_t.getCid());
            teachersJson.put("cname", course_t.getCname());
            teachersJson.put("courseteachers", teachers);

            jsonArray.add(teachersJson);
        }

        result.put("courseTeachers_sets", jsonArray);


        return result;


    }



    @RequestMapping(value = "/create")
    @ResponseBody
    public String createNewCenter(@RequestParam("data") String data) {
        //查询数据库，获取教学中心信息
        BaseInfo_Class baseInfo_class = new BaseInfo_Class();
        JSONObject jsonObject = JSONObject.parseObject(data);

        short directionId = Short.parseShort(jsonObject.get("directionId").toString());
        short centerId = Short.parseShort(jsonObject.get("centerId").toString());
        String classTime = jsonObject.get("classTime").toString();
        String classcode = jsonObject.get("classcode").toString();
        short ctid = Short.parseShort(jsonObject.get("ctid").toString());

        String graduateExamDate = jsonObject.get("graduateExamDate").toString();
        String graduateDate = jsonObject.get("graduateDate").toString();


        baseInfo_class.setDirectionId(directionId);
        baseInfo_class.setCenterId(centerId);
        baseInfo_class.setClasscode(classcode);
        baseInfo_class.setClassteacherId(ctid);
        baseInfo_class.setBeginDate(classTime);

        baseInfo_class.setPreExamGraducateDate("".equals(graduateExamDate)?null:graduateExamDate);
        baseInfo_class.setRealGraducateDate("".equals(graduateDate)?null:graduateDate);


        List<CoursePlanItem_Class> coursePlanItems = new ArrayList<>();
        String courseItems_strs = jsonObject.get("courseItems").toString();
        JSONArray jsonArray = JSONArray.parseArray(courseItems_strs);
        for (int i = 0; i < jsonArray.size(); i++) {
            CoursePlanItem_Class coursePlanItem = new CoursePlanItem_Class();
            coursePlanItem.setClasscode(classcode);

            Object object = jsonArray.get(i);
            JSONObject jsonObj = JSONObject.parseObject(object.toString());
            short cid = Short.parseShort(jsonObj.get("cid").toString());
            short tid = Short.parseShort(jsonObj.get("tid").toString());
            String startTime = jsonObj.get("startDate").toString();
            String endTime = jsonObj.get("endDate").toString();
            String proEndTime = jsonObj.get("proEndDate").toString();

            coursePlanItem.setCourseId(cid);
            coursePlanItem.setTeacherId(tid);
            coursePlanItem.setPreBeginDate(startTime);
            coursePlanItem.setPreEndDate(endTime);
            coursePlanItem.setPreProEndDate(proEndTime);

            coursePlanItems.add(coursePlanItem);

        }
        boolean isSuccess = classService.insertNewClass(baseInfo_class, coursePlanItems);
        if (isSuccess) {
            return "create success";
        }
        return "create fail";
    }



    @RequestMapping(value = "/baseInfo")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/class/baseInfo','y')")
    public String getBaseInfo(Map<String, Object> model) {

        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

        //获取班级状态
        List<String> states = classService.getClassStates();
        model.put("states", states);

//        List<ClassGeneralInfo> generalInfos = classService.getClassGeneralInfo();
//        for (ClassGeneralInfo classGeneralInfo : generalInfos) {
//            int centerId = classGeneralInfo.getCenter().getCid();
//            List<ClassTeacher> classTeachers_inDir = classService.getClassTeachersByCenterId(centerId);
//            classGeneralInfo.setClassTeachers(classTeachers_inDir);//该课程所对应中心的班主任
//            for (CoursePlanItem_Class_f coursePlanItem_class_f : classGeneralInfo.getCourseItems()) {
//                int courseId = coursePlanItem_class_f.getCourse().getCid();
//                List<SimpleTeacher> teachers = classService.getTeachersByCid(courseId);//每个子课程对应的老师
//                coursePlanItem_class_f.setTeachers(teachers);
//            }
//        }
//

        ClassQueryCondition classQueryCondition = new ClassQueryCondition();
        classQueryCondition.setStartTime("2000-01-01");
        classQueryCondition.setEndTime(Tool.getCurrentDate());
        classQueryCondition.setCenterId(-1);
        classQueryCondition.setClassteacherId(-1);
        classQueryCondition.setClassstate("全部");
        List<ClassGeneralInfo> generalInfos = classService.getClassGeneralInfoByCondition2(classQueryCondition);
        generalInfos = getMoreInfoToGeneralInfos(generalInfos);
        model.put("generalInfos", generalInfos);


        return "class_baseinfo";
    }




    @RequestMapping(value = "/classDetailsByCondition")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @ResponseBody
    public JSONObject classDetailsByCondition(ClassQueryCondition classQueryCondition) {
        JSONObject jsonObject = new JSONObject();

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        jsonObject.put("classTeachers",classTeachers);

        List<ClassGeneralInfo> generalInfos = classService.getClassGeneralInfoByCondition2(classQueryCondition);
        generalInfos = getMoreInfoToGeneralInfos(generalInfos);

        jsonObject.put("generalInfos",generalInfos);

        List<String> classstates = classService.listClassStates();
        jsonObject.put("classstates",classstates);

        return jsonObject;
    }

    private List<ClassGeneralInfo> getMoreInfoToGeneralInfos(List<ClassGeneralInfo> generalInfos){
        for(ClassGeneralInfo classGeneralInfo:generalInfos){
            String classcode = classGeneralInfo.getClasscode();
            String cnmae = classService.getCNameByClasscode(classcode);
            int ctid = classGeneralInfo.getClassteacherId();
            String ctname = classService.getCtnameByCtid(ctid);
            int did = classGeneralInfo.getDirectionId();
            String dname = classService.getDnameByDid(did);

            classGeneralInfo.setCtname(ctname);
            classGeneralInfo.setCname(cnmae);
            classGeneralInfo.setDname(dname);

            List<CoursePlanItem_Class> coursePlanItem_classes =  classService.getCoursePlanByClasscode(classcode);
            //若没有手动生成班级，则在此自动关联
            if(coursePlanItem_classes.size() == 0){
                List<Integer> courseIds = jiaoWuService.getCourseIdByDirectionId(did);
                for(Integer courseId:courseIds){
                    CoursePlanItem_Class coursePlanItem_class = new CoursePlanItem_Class();
                    coursePlanItem_class.setCourseId(courseId);
                    coursePlanItem_classes.add(coursePlanItem_class);
                }
            }
            for(CoursePlanItem_Class coursePlanItem_class:coursePlanItem_classes){
                int courseId = coursePlanItem_class.getCourseId();
                List<SimpleTeacher> teachers = classService.getTeachersByCid(courseId);//每个子课程对应的老师
                coursePlanItem_class.setTeachers(teachers);
                String courseNmae = classService.getCourseNameByCourseId(courseId);
                coursePlanItem_class.setCname(courseNmae);

                int teacherId = coursePlanItem_class.getTeacherId();
                String teacherNmae = classService.getTeacherNameByTeacherId(teacherId);
                coursePlanItem_class.setTname(teacherNmae);
            }


            classGeneralInfo.setCourseItems2(coursePlanItem_classes);

        }

        return generalInfos;
    }



    @RequestMapping(value = "/update")
    @ResponseBody
    public String updateCourse(@RequestParam("data") String data) {
        //查询数据库，获取教学中心信息
        BaseInfo_Class baseInfo_class = new BaseInfo_Class();
        JSONObject jsonObject = JSONObject.parseObject(data);

        short clid = Short.parseShort(jsonObject.get("clid").toString());
        short ctid = Short.parseShort(jsonObject.get("ctid").toString());
        String beginDate = jsonObject.get("beginDate").toString();
        short initPfx = Short.parseShort(jsonObject.get("initPfx").toString());
        String state = jsonObject.get("state").toString();

        Object obj ;

        baseInfo_class.setClid(clid);
        baseInfo_class.setClassteacherId(ctid);
        baseInfo_class.setBeginDate(beginDate);
        baseInfo_class.setInitPfx(initPfx);
        baseInfo_class.setState(state);

        List<CoursePlanItem_Class> coursePlanItems = new ArrayList<>();
        String courseItems_strs = jsonObject.get("courseItems").toString();
        JSONArray jsonArray = JSONArray.parseArray(courseItems_strs);
        for (int i = 0; i < jsonArray.size(); i++) {

            CoursePlanItem_Class coursePlanItem = new CoursePlanItem_Class();

            Object object = jsonArray.get(i);
            JSONObject jsonObj = JSONObject.parseObject(object.toString());
            short cid = Short.parseShort(jsonObj.get("coid").toString());//课程名字

            short tid;
            Object o = jsonObj.get("tid");
            if(o != null){
                tid = Short.parseShort(o.toString());//授课老师
            }else{
                tid = -1;
            }


            JSONArray dateArray = JSONArray.parseArray(jsonObj.get("dates").toString());

            coursePlanItem.setCourseId(cid);
            coursePlanItem.setTeacherId(tid);
            o = dateArray.get(0);
            if(o == null){
                coursePlanItem.setRealBeginDate("");
            }else{
                coursePlanItem.setRealBeginDate(o.toString());
            }
            o = dateArray.get(1);
            if(o == null){
                coursePlanItem.setRealEndDate("");
            }else{
                coursePlanItem.setRealEndDate(o.toString());
            }
            o = dateArray.get(2);
            if(o == null){
                coursePlanItem.setRealProEndDate("");
            }else{
                coursePlanItem.setRealProEndDate(o.toString());
            }

            coursePlanItems.add(coursePlanItem);

        }

        boolean isSuccess = classService.updateClass(baseInfo_class, coursePlanItems);
        if (isSuccess) {
            String classcode = classService.getClassCodesByClid2(clid);
            classService.updateTraineeStateByClasscode(classcode, state);
            return "update success";
        }
        return "update fail";
    }



    @RequestMapping(value = "/trainee")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/class/trainee','y')")
    public String getCenterInfo_trainee(Map<String, Object> model) {
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

        List<String> classcodes = classService.listClasscode();
        model.put("classcodes", classcodes);



        List<String> diplomaStates = classService.getDiplomaStates();
        model.put("diplomaStates", diplomaStates);

        List<String> traineeStates = classService.getTraineeStates();
        model.put("traineeStates", traineeStates);

        List<String> payWays = classService.getPayWays();
        model.put("payWays", payWays);

        List<String> employWays = classService.getEmployWays();
        model.put("employWays", employWays);

        List<String> states = classService.getClassStates();
        model.put("classstates", states);


        return "class_trainee";
    }

    @RequestMapping(value = "/classteachersInCenter")
    @ResponseBody
    public List<ClassTeacher> getClassTeachersByCenterId(short centerId) {
        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(centerId);
        return classTeachers;
    }



    @RequestMapping(value = "/classcodesByCtidState")
    @ResponseBody
    public List<String> getClassCodes(int ctid, String state) {
        return classService.getClassCodesByClidState(ctid, state);
    }



    @RequestMapping(value = "/baseInfoForTrainee")
    @ResponseBody
    public List<BaseinfoForTrainee> getTrainBaseInfo(String classcode, String traineestate) {
        return classService.getTrainBaseInfo(classcode, traineestate);
    }



    @RequestMapping(value = "/importExcel", method = RequestMethod.POST)
    @ResponseBody
    public String importExcel(@RequestParam(value = "excelFile", required = false) MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
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
                    int centerId = Integer.parseInt(request.getParameter("centers_type").toString());
                    int directionId = Integer.parseInt(request.getParameter("directions_type").toString());
                    String classstate = request.getParameter("classstates").toString();
                    String beginDate = request.getParameter("beginDate").toString();

                    List<List<String>> datas = ExcelUtil.readExcel(excelFile.getInputStream());
                    if (datas != null && datas.size() > 0) {

                        Center center = getCenterByClassCode(centerId);
                        Direction direction = getDirectionByDirectionId(directionId);

                        if(center != null && direction != null){
                            int result = classService.insertTrainees(datas, centerId, direction, classstate, beginDate);
                            if(result > 0){
                                json.put("result", "success");
                                json.put("datas",datas);
                                json.put("center",center);
                                json.put("direction",direction);
                            }else{
                                json.put("result", "fail");
                            }
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



    @RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
    @ResponseBody
    public String uploadFile(MultipartFile imgFile, HttpServletRequest request,HttpServletResponse response) throws IllegalStateException, IOException {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();

        // 原始名称
        String oldFileName = imgFile.getOriginalFilename(); // 获取上传文件的原名
        //获取服务器指定文件存取路径 
        String savedDir = "C:\\teach-upload\\";


        // 上传图片
        if (imgFile != null && oldFileName != null && oldFileName.length() > 0) {

            String code = request.getParameter("code_dlg");
            String type = request.getParameter("type_dlg");
            String classcode = request.getParameter("classcode_dlg");

            String affix = oldFileName.substring(oldFileName.lastIndexOf("."));//文件后缀(包括.)

            // 新的图片名称
            String newFileName = code + "_" + type + affix;
            // 新图片
            File newFile = new File(savedDir + "\\" + newFileName);
            // 将内存中的数据写入磁盘
            imgFile.transferTo(newFile);//C:\teach-upload\PJ17111222012_0_C:\teach-upload\xueji__用户名_07.png

            //修改数据库
            //先看表中该code是否存在，不存在的话，创建。存在的话更新
            int result = -1;
            BaseinfoForTrainee baseinfoForTrainee2 = classService.getBaseInfoForTraineeByCode(code);
            if(baseinfoForTrainee2 == null){
                result = classService.createTraineePhotoForBaseInfo(code, classcode, Integer.parseInt(type), newFileName);
            }else{
                result = classService.updateTraineePhotoState(code, Integer.parseInt(type), newFileName);
            }

            if(result > 0){
                json.put("result","success");
                json.put("type",type);
            }else{
                json.put("result","fail");
            }

        } else {
            json.put("result","fail");
        }

        return json.toString();
    }



    @RequestMapping(value = "/getPhotoNameByCodeType", method = RequestMethod.POST)
    @ResponseBody
    public String getPhotoNameByCodeType(String code, int type, HttpServletRequest request) throws UnknownHostException {
        String photoName = null;
        photoName = classService.getPhotoNameByCodeType(code, type);
        if(photoName != null && photoName.length() > 0){
            photoName = Tool.serverAddress + "/" +  photoName;
        }

        return photoName;
    }


    public  Center getCenterByClassCode(int centerId){
        Center center = jiaoWuService.getCenterByCenterId(centerId);
        return center;
    }

    public  Direction getDirectionByDirectionId(int directionId){
        Direction direction = jiaoWuService.getDirectionByDirectionId(directionId);
        return direction;
    }



    @RequestMapping(value = "/activity")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/class/activity','y')")
    public String getClassActivitys(Map<String, Object> model) {
        //查询数据库，获取教师员信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(centers.get(0).getCid());
        model.put("classteachers", classTeachers);

        int ctid = classTeachers.get(0).getCtid();
        List<String> classcode = classService.getClassCodesByClid(ctid);

        if(classcode.size() > 0){
            List<News> newses = classService.listNews(classcode.get(0));
            model.put("newses", newses);
        }


        return "class_activity";
    }


    @RequestMapping(value = "/getClassCodesByClid", method = RequestMethod.POST)
    @ResponseBody
    public List<String> getClassCodesByClid(int ctid) {
        List<String> list = classService.getClassCodesByClid(ctid);
        return list;


    }



    @RequestMapping(value = "/getClassCodesByClidTime", method = RequestMethod.POST)
    @ResponseBody
    public List<String> getClassCodesByClidTime(int ctid,  String startTime, String endTime) {
        List<String> list = classService.getClassCodesByClidTime(ctid, startTime,endTime);
        return list;
    }

    @RequestMapping(value = "/getDirectionNameByClassCode", method = RequestMethod.POST)
    @ResponseBody
    public String getDirectionNameByClassCode(String classcode) {
        String dname = classService.getDirectionNameByClassCode(classcode);
        return dname;
    }






    @RequestMapping(value = "/createActivity",  method = RequestMethod.GET)  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    public String createActivity(String classcode, HttpSession httpSession, HttpServletRequest request) throws UnknownHostException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String createTime = sdf.format(new Date());
        News news = new News();
        news.setClasscode(classcode);
        news.setCreateTime(createTime);
        news.setAuthorId(1);
        classService.createNews(news);
        httpSession.setAttribute("newsId",news.getId());
        httpSession.setAttribute("server", Tool.serverAddress);
        return "createActivity";
    }


    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> upload(@RequestParam(value="myFileName") MultipartFile file, HttpServletRequest request){
//        String separator = System.getProperty("file.separator");
//        separator=separator.replaceAll("\\\\","/");
//        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath()+ separator; //获取项目路径+端口号 比如：http://localhost:8080/

        int newsId = Integer.parseInt(request.getSession().getAttribute("newsId").toString());

        try {
            String filePath="";
            //获取源文件
            filePath="C:\\teach-upload" ;//存储地址，此处也可以在application.yml中配置对象用@Value("${*.**}")注解注入内容
            String filename = file.getOriginalFilename();//获取图片名
            String[] names=filename.split("\\.");//获取后缀格式
            String uploadFileName= UUID.randomUUID().toString()+"."+names[names.length-1];//生成新图片
            File targetFile = new File (filePath,uploadFileName);//目标文件
            if (!targetFile.getParentFile().exists()){
                targetFile.getParentFile().mkdirs();
            }
            //传图片一步到位
            file.transferTo(targetFile);
            classService.createImgForNews(uploadFileName, newsId);//将添加的图片插入数据库

            Map<String, String> map = new HashMap<String, String>();
            map.put("data",uploadFileName);//这里应该是项目路径，返回前台url


            return map;
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return  null;
        }

    }



    @RequestMapping(value = "/news", method = RequestMethod.POST)
    @ResponseBody
    public String news(String html, String title, HttpSession httpSession){
        int newsId = Integer.parseInt(httpSession.getAttribute("newsId").toString());
        classService.updateNews(newsId, title, html);
        return "success";
    }



    @RequestMapping(value = "/newsByClasscode", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject newsByClasscode(String classcode){
        JSONObject jsonObject = new JSONObject();
        List<News> newses = classService.listNews(classcode);
        jsonObject.put("newses",newses);
        return jsonObject;
    }



    @RequestMapping(value = "/news_content", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject news_content(int newsId){
        JSONObject jsonObject = new JSONObject();
        String newsContent = classService.getNewsContentByNewsId(newsId);
        jsonObject.put("newsContent",newsContent);
        return jsonObject;
    }


    @RequestMapping(value = "/news_content2", method = RequestMethod.GET)
    public String news_content2(int newsId, Map<String, Object> model){
        if(newsId == -1){
            model.put("newsContent","无内容");
        }else{
            String newsContent = classService.getNewsContentByNewsId(newsId);
            model.put("newsContent",newsContent);
        }

        return "class_activityPlay";
    }





    @RequestMapping(value = "/getComprehensiveScore", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject getComprehensiveScore(String classcode,String dname){
        JSONObject jsonObject = new JSONObject();
        if(dname.contains("java")){
            List<ComprehensiveScore_java> comprehensiveScore_javas = classService.getComprehensiveScoreByClassCode_java(classcode);
            jsonObject.put("comprehensiveScore_javas",comprehensiveScore_javas);
        }else{
            List<ComprehensiveScore_ai> comprehensiveScore_ais = classService.getComprehensiveScoreByClassCode_ai(classcode);
            jsonObject.put("comprehensiveScore_ais",comprehensiveScore_ais);
        }


        return jsonObject;
    }


    @RequestMapping(value = "/getComprehensiveScore20191106", method = RequestMethod.POST)
    @ResponseBody
    public List<ComprehensiveScore> getComprehensiveScore20191106(String classcode){
        List<ComprehensiveScore> comprehensiveScores = null;
        String dname = classService.getDirectionNameByClassCode(classcode);
        if(classcode != null && classcode.length() > 0) {
            List<Score> scores = learnProdurceService.getScoreDetailByClasscode(classcode);
            if(scores != null && scores.size() > 0){
                Map<String, List<Score>> map = Tool.getSortedMapCodeAsKey(scores);
                comprehensiveScores = Tool.ConvertToComprehenssiveScores(map);//获取综合成绩中的测试成绩--固定

                //获取综合基本信息
                for(ComprehensiveScore comprehensiveScore:comprehensiveScores){
                    comprehensiveScore.setDname(dname);
                    String code = comprehensiveScore.getCode();
                    if(code != null && code.length() > 0){
                        System.out.println(code);
                        ComprehensiveScore_baseinfo comprehensiveScore_baseinfo = learnProdurceService.getComprehensiveScoreBaseinfoByCode(code);
                        if(comprehensiveScore_baseinfo != null){
                            Tool.copyContentToComprehensiveScore(comprehensiveScore_baseinfo, comprehensiveScore);
                        }


                    }

                }
            }
        }



        return comprehensiveScores;
    }

    @RequestMapping(value = "/getComprehensiveScoreByCode20191106", method = RequestMethod.POST)
    @ResponseBody
    public List<ComprehensiveScore> getComprehensiveScoreByCode20191106(String code,String dname){
        List<ComprehensiveScore> comprehensiveScores = null;
        if(code != null && code.length() > 0) {
            List<Score> scores = learnProdurceService.getScoreDetailByCode(code);
            if(scores != null && scores.size() > 0){
                Map<String, List<Score>> map = Tool.getSortedMapCodeAsKey(scores);
                comprehensiveScores = Tool.ConvertToComprehenssiveScores(map);//获取综合成绩中的测试成绩--固定

                //获取综合基本信息
                for(ComprehensiveScore comprehensiveScore:comprehensiveScores){
                    ComprehensiveScore_baseinfo comprehensiveScore_baseinfo = learnProdurceService.getComprehensiveScoreBaseinfoByCode(code);
                    Tool.copyContentToComprehensiveScore(comprehensiveScore_baseinfo, comprehensiveScore);

                }
            }
        }



        return comprehensiveScores;
    }


    @RequestMapping(value = "/getTraineeBaseInfoByCode", method = RequestMethod.POST)
    @ResponseBody
    public BaseinfoForTrainee getTraineeBaseInfoByCode(String code){
        BaseinfoForTrainee baseinfoForTrainee = null;
        baseinfoForTrainee = classService.getBaseInfoForTraineeByCode2(code);


        return baseinfoForTrainee;
    }




    @RequestMapping(value = "/getComprehensiveScoreByCode", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject getComprehensiveScoreByCode(String code,String dname){
        JSONObject jsonObject = new JSONObject();
        if(dname.contains("java")){
            List<ComprehensiveScore_java> comprehensiveScore_javas = classService.getComprehensiveScoreByCode_java(code);
            jsonObject.put("comprehensiveScore_javas",comprehensiveScore_javas);
        }else{
            List<ComprehensiveScore_ai> comprehensiveScore_ais = classService.getComprehensiveScoreByCode_ai(code);
            jsonObject.put("comprehensiveScore_ais",comprehensiveScore_ais);
        }


        return jsonObject;
    }







    @RequestMapping(value = "/mohuQueryByName", method = RequestMethod.POST)
    @ResponseBody
    public List<BaseinfoForTrainee> mohuQueryByName(String name){
        // 判断如果上传的是学号就按照学号查询
        List<BaseinfoForTrainee> baseinfoForTrainees;
        if (name.startsWith("P") || name.startsWith("X") || name.startsWith("Z")) {
            baseinfoForTrainees = classService.mohuQueryByCode(name);
        } else {
            baseinfoForTrainees = classService.mohuQueryByName(name);
        }
        baseinfoForTrainees.forEach(System.out::println);
        return baseinfoForTrainees;
    }




    @RequestMapping(value = "/updateComprehensiveScore", method = RequestMethod.POST)
    @ResponseBody
    public String updateComprehensiveScore(@RequestParam("data") String data){
        boolean result = false;
        JSONObject jsonObject = JSONObject.parseObject(data);
        String dname = jsonObject.get("dname").toString();
        if(dname.contains("java")){
            ComprehensiveScore_java comprehensiveScore_java = new ComprehensiveScore_java();
            comprehensiveScore_java.setCode(jsonObject.get("code").toString());
            comprehensiveScore_java.setDiploma(Integer.parseInt(jsonObject.get("diploma").toString()));
            comprehensiveScore_java.setGraduateTime(Integer.parseInt(jsonObject.get("graduateTime").toString()));
            comprehensiveScore_java.setPrefession(Integer.parseInt(jsonObject.get("profession").toString()));
            comprehensiveScore_java.setEnery_employ(Integer.parseInt(jsonObject.get("employ").toString()));
            comprehensiveScore_java.setJava_oo_test(Integer.parseInt(jsonObject.get("java_oo").toString()));
            comprehensiveScore_java.setJava_basegrammer_check(Integer.parseInt(jsonObject.get("java_basegrammer").toString()));
            comprehensiveScore_java.setJava_datastruct_test(Integer.parseInt(jsonObject.get("java_datastruct").toString()));
            comprehensiveScore_java.setSe_pro(Integer.parseInt(jsonObject.get("se_pro").toString()));
            comprehensiveScore_java.setWebpage_check(Integer.parseInt(jsonObject.get("webpage").toString()));
            comprehensiveScore_java.setSsmh_check(Integer.parseInt(jsonObject.get("ssmh").toString()));
            comprehensiveScore_java.setDatabase(Integer.parseInt(jsonObject.get("dbs").toString()));
            comprehensiveScore_java.setEe_pro(Integer.parseInt(jsonObject.get("eepro").toString()));
            comprehensiveScore_java.setCorporation(jsonObject.get("corporation").toString());
            comprehensiveScore_java.setSalary(Integer.parseInt(jsonObject.get("salary").toString()));
            comprehensiveScore_java.setType(jsonObject.get("type").toString());

            result = classService.updateComprehensiveScoreByClassCode_java(comprehensiveScore_java);
        }else{
            ComprehensiveScore_ai comprehensiveScore_ai = new ComprehensiveScore_ai();
            comprehensiveScore_ai.setCode(jsonObject.get("code").toString());
            comprehensiveScore_ai.setDiploma(Integer.parseInt(jsonObject.get("diploma").toString()));
            comprehensiveScore_ai.setGraduateTime(Integer.parseInt(jsonObject.get("graduateTime").toString()));
            comprehensiveScore_ai.setPrefession(Integer.parseInt(jsonObject.get("profession").toString()));
            comprehensiveScore_ai.setEnery_employ(Integer.parseInt(jsonObject.get("employ").toString()));
            comprehensiveScore_ai.setCorporation(jsonObject.get("corporation").toString());
            comprehensiveScore_ai.setSalary(Integer.parseInt(jsonObject.get("salary").toString()));

            comprehensiveScore_ai.setC_grammer_test(Integer.parseInt(jsonObject.get("c_grammer_test").toString()));
            comprehensiveScore_ai.setArray_struct_test(Integer.parseInt(jsonObject.get("array_struct_test").toString()));
            comprehensiveScore_ai.setPointer_check(Integer.parseInt(jsonObject.get("pointer_check").toString()));
            comprehensiveScore_ai.setC_pro(Integer.parseInt(jsonObject.get("c_pro").toString()));
            comprehensiveScore_ai.setLsd_test(Integer.parseInt(jsonObject.get("lsd_test").toString()));
            comprehensiveScore_ai.setCplusplus_oo_check(Integer.parseInt(jsonObject.get("cplusplus_oo_check").toString()));
            comprehensiveScore_ai.setQt_test(Integer.parseInt(jsonObject.get("qt_test").toString()));
            comprehensiveScore_ai.setCplusplus_pro(Integer.parseInt(jsonObject.get("cplusplus_pro").toString()));
            comprehensiveScore_ai.setPro(Integer.parseInt(jsonObject.get("pro").toString()));

            comprehensiveScore_ai.setType(jsonObject.get("type").toString());

            result = classService.updateComprehensiveScoreByClassCode_ai(comprehensiveScore_ai);
        }

        if(result){
            return "success";
        }

        return "fail";
    }



    @RequestMapping(value = "/updateComprehensiveBaseinfo", method = RequestMethod.POST)
    @ResponseBody
    public String updateComprehensiveBaseinfo(ComprehensiveScore_baseinfo comprehensiveScore_baseinfo){
       int result = classService.updateComprehensiveBaseinfo(comprehensiveScore_baseinfo);
        if(result > 0){
            return "success";
        }

        return "fail";
    }




    @RequestMapping(value = "/getBaseInfoForTraineeByClassCode", method = RequestMethod.POST)
    @ResponseBody
    public List<BaseinfoForTrainee> getBaseInfoForTraineeByClassCode(String classcode){
        int did = classService.getDirectionIdByClassCode(classcode);
        String dname = classService.getDnameByDid(did);
        int ctid = classService.getClassTeacherIdByClassCode(classcode);
        String ctname = classService.getCtnameByCtid(ctid);
        String cname = classService.getCNameByClasscode(classcode);
        List<BaseinfoForTrainee> baseinfoForTrainees = classService.getBaseInfoForTraineeByClassCode(classcode);
        for(BaseinfoForTrainee baseinfoForTrainee:baseinfoForTrainees){
            baseinfoForTrainee.setDname(dname);
            baseinfoForTrainee.setCtname(ctname);
            baseinfoForTrainee.setCname(cname);
        }

        return baseinfoForTrainees;
    }


    @RequestMapping(value = "/getBaseInfoForTraineeByCode", method = RequestMethod.POST)
    @ResponseBody
    public BaseinfoForTrainee getBaseInfoForTraineeByCode(String code, String classcode){
        int did = classService.getDirectionIdByClassCode(classcode);
        String dname = classService.getDnameByDid(did);
        int ctid = classService.getClassTeacherIdByClassCode(classcode);
        String ctname = classService.getCtnameByCtid(ctid);
        String cname = classService.getCNameByClasscode(classcode);

        BaseinfoForTrainee baseinfoForTrainee = classService.getBaseInfoForTraineeByCode2(code);
        baseinfoForTrainee.setDname(dname);
        baseinfoForTrainee.setCtname(ctname);
        baseinfoForTrainee.setCname(cname);

        return baseinfoForTrainee;
    }



    @RequestMapping(value = "/saveNewTrainee", method = RequestMethod.POST)
    @ResponseBody
    public BaseinfoForTrainee saveNewTrainee(@RequestParam("data") String data){
        JSONObject jsonObject = JSONObject.parseObject(data);
        BaseinfoForTrainee baseinfoForTrainee = new BaseinfoForTrainee();
        String code = null;
        Object o= jsonObject.get("code");
        if(o != null){
            code = o.toString();
        }

        String name;
        o= jsonObject.get("name");
        if(o != null){
            name = o.toString();
        }else{
            name = "";
        }

        String gender;
        o= jsonObject.get("gender");
        if(o != null){
            gender = o.toString();
        }else{
            gender = "";
        }
        String classcode;
        o= jsonObject.get("classcode");
        if(o != null){
            classcode = o.toString();
        }else{
            classcode = "";
        }

        Integer centerId = -1;
        if(classcode.length() > 0){
            centerId = classService.getCenterIdByClasscode(classcode);
        }

        String card;
        o= jsonObject.get("card");
        if(o != null){
            card = o.toString();
        }else{
            card = "";
        }

        if(card.length() == 0 || centerId <=0 || classcode.length() == 0 || code.length() == 0 || name.length() == 0 ){

            return null;
        }



        String diploma;
        o= jsonObject.get("diploma");
        if(o != null){
            diploma = o.toString();
        }else{
            diploma = "";
        }

        String graducateTime;
        o= jsonObject.get("graducateTime");
        if(o != null){
            graducateTime = o.toString();
        }else{
            graducateTime = "8000-01-01";
        }

        String profession;
        o= jsonObject.get("profession");
        if(o != null){
            profession = o.toString();
        }else{
            profession = "";
        }

        String graduateSchool;
        o= jsonObject.get("graduateSchool");
        if(o != null){
            graduateSchool = o.toString();
        }else{
            graduateSchool = "";
        }


        String tel;
        o= jsonObject.get("tel");
        if(o != null){
            tel = o.toString();
        }else{
            tel = "";
        }

        String email;
        o= jsonObject.get("email");
        if(o != null){
            email = o.toString();
        }else{
            email = "";
        }

        String contact;
        o= jsonObject.get("contact");
        if(o != null){
            contact = o.toString();
        }else{
            contact = "";
        }

        String contactTel;
        o= jsonObject.get("contactTel");
        if(o != null){
            contactTel = o.toString();
        }else{
            contactTel = "";
        }

        String lendWay;
        o= jsonObject.get("lendWay");
        if(o != null){
            lendWay = o.toString();
        }else{
            lendWay = "";
        }


        //中心id未传过来
        int directionId = classService.getDirectionIdByClassCode(classcode);
        baseinfoForTrainee.setCode(code);
        baseinfoForTrainee.setName(name);
        baseinfoForTrainee.setGender(gender);
        baseinfoForTrainee.setDirectionId(directionId);
        baseinfoForTrainee.setCenterId(centerId);
        baseinfoForTrainee.setCard(card);
        baseinfoForTrainee.setClasscode(classcode);
        baseinfoForTrainee.setDiploma(diploma);

        baseinfoForTrainee.setGraducateTime(graducateTime);
        baseinfoForTrainee.setProfession(profession);
        baseinfoForTrainee.setGraduateSchool(graduateSchool);
        baseinfoForTrainee.setTel(tel);
        baseinfoForTrainee.setEmail(email);
        baseinfoForTrainee.setContact(contact);
        baseinfoForTrainee.setContactTel(contactTel);
        baseinfoForTrainee.setLendWay(lendWay);
////////////////////////////////////////////////////////////////////////

        String employWay;
        o= jsonObject.get("employWay");
        if(o != null){
            employWay = o.toString();
        }else{
            employWay = "";
        }

        String employDate;
        o= jsonObject.get("employDate");
        if(o != null && o.toString().length() == 0){
            employDate = o.toString();
        }else{
            employDate = "8000-01-01";
        }

        String corporation;
        o= jsonObject.get("corporation");
        if(o != null){
            corporation = o.toString();
        }else{
            corporation = "";
        }


        int salary=0;
        o= jsonObject.get("salary");
        if(o != null ){
            try{
                salary = Integer.parseInt(o.toString());
            }catch(Exception e){
                salary=0;
            }

        }


        EmployInfoForTrainee employInfoForTrainee = new EmployInfoForTrainee();
        employInfoForTrainee.setCode(code);
        employInfoForTrainee.setState(employWay);
        employInfoForTrainee.setEmploy_time(employDate);
        employInfoForTrainee.setEmploy_unit(corporation);
        employInfoForTrainee.setEmploy_salary(salary);
        employInfoForTrainee.setEmploy_position("");
        employInfoForTrainee.setComment("");

        classService.insertTraineeForSwitch(baseinfoForTrainee,employInfoForTrainee);
        //新增学籍改变
        Xueji  xueji = new Xueji();
        xueji.setCode(code);
        xueji.setClasscode(classcode);
        xueji.setTargetClasscode(classcode);
        xueji.setName(name);
        xueji.setTimee(Tool.getCurrentDate());
        xueji.setType("转入");
        xueji.setContent("线上转入线下");
        xueji.setReason("");
        xueji.setResult("");
        jiaoWuService.saveXuejiInfo(xueji);

        return baseinfoForTrainee;
    }


    @RequestMapping(value = "/updateBaseInfoForTrainee", method = RequestMethod.POST)
    @ResponseBody
    public String updateBaseInfoForTrainee(@RequestParam("data") String data){
        JSONObject jsonObject = JSONObject.parseObject(data);
        BaseinfoForTrainee baseinfoForTrainee = new BaseinfoForTrainee();

        String code = null;
        Object o= jsonObject.get("code");
        if(o != null){
            code = o.toString();
        }

        String name;
        o= jsonObject.get("name");
        if(o != null){
            name = o.toString();
        }else{
            name = "";
        }

        String cname;
        o= jsonObject.get("cname");
        if(o != null){
            cname = o.toString();
        }else{
            cname = "";
        }

        String gender;
        o= jsonObject.get("gender");
        if(o != null){
            gender = o.toString();
        }else{
            gender = "";
        }



        String card;
        o= jsonObject.get("card");
        if(o != null){
            card = o.toString();
        }else{
            card = "";
        }

        String classcode;
        o= jsonObject.get("classcode");
        if(o != null){
            classcode = o.toString();
        }else{
            classcode = "";
        }

        String diploma;
        o= jsonObject.get("diploma");
        if(o != null){
            diploma = o.toString();
        }else{
            diploma = "";
        }

        String graducateTime;
        o= jsonObject.get("graducateTime");
        if(o != null){
            graducateTime = o.toString();
        }else{
            graducateTime = "";
        }

        String profession;
        o= jsonObject.get("profession");
        if(o != null){
            profession = o.toString();
        }else{
            profession = "";
        }

        String graduateSchool;
        o= jsonObject.get("graduateSchool");
        if(o != null){
            graduateSchool = o.toString();
        }else{
            graduateSchool = "";
        }




        String tel;
        o= jsonObject.get("tel");
        if(o != null){
            tel = o.toString();
        }else{
            tel = "";
        }

        String email;
        o= jsonObject.get("email");
        if(o != null){
            email = o.toString();
        }else{
            email = "";
        }

        String contact;
        o= jsonObject.get("contact");
        if(o != null){
            contact = o.toString();
        }else{
            contact = "";
        }

        String contactTel;
        o= jsonObject.get("contactTel");
        if(o != null){
            contactTel = o.toString();
        }else{
            contactTel = "";
        }

        String lendWay;
        o= jsonObject.get("lendWay");
        if(o != null){
            lendWay = o.toString();
        }else{
            lendWay = "";
        }


        //中心id未传过来
        int directionId = classService.getDirectionIdByClassCode(classcode);
        int centerId = classService.getCenterIdByCname(cname);
        baseinfoForTrainee.setCode(code);
        baseinfoForTrainee.setName(name);
        baseinfoForTrainee.setGender(gender);
        baseinfoForTrainee.setDirectionId(directionId);
        baseinfoForTrainee.setCenterId(centerId);
        baseinfoForTrainee.setCard(card);
        baseinfoForTrainee.setClasscode(classcode);
        baseinfoForTrainee.setDiploma(diploma);

        baseinfoForTrainee.setGraducateTime(graducateTime);
        baseinfoForTrainee.setProfession(profession);
        baseinfoForTrainee.setGraduateSchool(graduateSchool);
        baseinfoForTrainee.setTel(tel);
        baseinfoForTrainee.setEmail(email);
        baseinfoForTrainee.setContact(contact);
        baseinfoForTrainee.setContactTel(contactTel);
        baseinfoForTrainee.setLendWay(lendWay);
        classService.updateBaseInfoForTrainee(baseinfoForTrainee);

        String employWay;
        if(jsonObject.get("employWay") == null){
            employWay = "";
        }else{
            employWay = jsonObject.get("employWay").toString();
        }

        String employDate;
        if(jsonObject.get("employDate") == null){
            employDate = "";
        }else{
            employDate = jsonObject.get("employDate").toString();
        }

        String corporation = jsonObject.get("corporation").toString();
        int salary = Integer.parseInt(jsonObject.get("salary").toString());

        EmployInfoForTrainee employInfoForTrainee = new EmployInfoForTrainee();
        employInfoForTrainee.setCode(code);
        employInfoForTrainee.setState(employWay);
        employInfoForTrainee.setEmploy_time(employDate);
        employInfoForTrainee.setEmploy_unit(corporation);
        employInfoForTrainee.setEmploy_salary(salary);
        classService.updateEmployInfoForTrainee(employInfoForTrainee);
        return "success";
    }


    @RequestMapping("/onDownload")
    public String downloadFile(HttpServletRequest request,
                               HttpServletResponse response) throws UnsupportedEncodingException {

        String fileName = "学员信息表模板.xlsx"; //下载的文件名

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

















}

