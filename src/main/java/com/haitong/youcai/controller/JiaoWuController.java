package com.haitong.youcai.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.ClassService;
import com.haitong.youcai.service.JiaoWuService;
import com.haitong.youcai.service.LearnProdurceService;
import com.haitong.youcai.utils.ExcelUtil;
import com.haitong.youcai.utils.Tool;
import org.apache.catalina.servlet4preview.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2019/3/27.
 */
@Controller
@RequestMapping("/jiaowu") //在类上使用RequestMapping，里面设置的value就是方法的父路径
public class JiaoWuController {
    @Autowired
    private JiaoWuService jiaoWuService;
    @Autowired
    private ClassService classService;
    @Autowired
    private LearnProdurceService learnProdurceService;


    @RequestMapping(value = {"/center",""})  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/center','y')")
    public String getCenterInfo(Map<String, Object> model){
        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);
        //查询数据库，获取教师员信息
        List<Teacher> teachers = jiaoWuService.getTeacherList();
        model.put("teachers", teachers);

        return "jiaowu_center";
    }


    @RequestMapping(value = {"/centerList"})
    @ResponseBody
    public List<Center> centerList(){
        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();

        return centers;
    }



    @RequestMapping(value = "/new")
    @ResponseBody
    public String createNewCenter(String cname, String caddress,String ctel){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.insertNewCenter(cname,caddress,ctel);
        if(result > 0){
            return "create success";
        }
        return "create fail";
    }


    @RequestMapping(value = "/edit")
    @ResponseBody
    public String editCenter(int cid, String cname, String caddress,int chargerId){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.updateCenter(cid, cname,caddress,chargerId);
        if(result > 0){
            return "edit success";
        }
        return "edit fail";

    }


    @RequestMapping(value = "/delete")
    @ResponseBody
    public String deleteCenter(int cid){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.deleteCenter(cid);
        if(result > 0){
            return "delete success";
        }
        return "delete fail";

    }


    @RequestMapping(value = "/getCenterById")
    @ResponseBody
    public  Center getCenterById(int cid){
        Center center = jiaoWuService.getCenterById(cid);
        return center;
    }




    @RequestMapping(value = "/direction")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/direction','y')")
    public String getDirectionInfo(Map<String, Object> model){
        //查询数据库，获取教学中心信息
        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);
        //查询数据库，获取教师员信息
        List<Teacher> teachers = jiaoWuService.getTeacherList();
        model.put("teachers", teachers);

        return "jiaowu_direction";
    }


    @RequestMapping(value = {"/directionList"})
    @ResponseBody
    public List<Direction> directionList(){
        //查询数据库，获取教学中心信息
        List<Direction> directions = jiaoWuService.getDirectionInfo();
        return directions;
    }


    @RequestMapping(value = "/new_direction")
    @ResponseBody
    public String createNewDirection(String dname, String describe,String tel){
        //查询数据库，获取教学中心信息
        int result;
        if(tel == ""){
            result = jiaoWuService.insertNewDirection2(dname,describe);
            if(result > 0){
                return "create success";
            }
        }else{
            result = jiaoWuService.insertNewDirection(dname,describe,tel);
            if(result > 0){
                return "create success";
            }
        }

        return "create fail";

    }



    @RequestMapping(value = "/direction_edit")
    @ResponseBody
    public String editDirection(int did, String dname, String describe,Integer chargerId){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.updateDirection(did, dname,describe,chargerId);
        if(result > 0){
            return "edit success";
        }
        return "edit fail";

    }


    @RequestMapping(value = "/direction_delete")
    @ResponseBody
    public String deleteDirection(int did){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.deleteDirection(did);
        if(result > 0){
            return "delete success";
        }
        return "delete fail";

    }


    @RequestMapping(value = "/getDirectionById")
    @ResponseBody
    public  Direction getDirectionById(int did){
        Direction direction = jiaoWuService.getDirectionById(did);
        return direction;
    }






    @RequestMapping(value = "/classteacher")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/classteacher','y')")
    public String getClassTeacherInfo(Map<String, Object> model){
        //查询数据库，获取教学中心信息
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        model.put("classTeachers", classTeachers);

        List<Center> centers = jiaoWuService.getCenterList();

        model.put("centers", centers);

        return "jiaowu_classteacher";
    }




    @RequestMapping(value = "/new_classteacher")
    @ResponseBody
    public String createNewClassTeacher(String ctname, String gender,String tel, String email, int centerId, String createTime ){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.insertNewClassTeacher(ctname,gender,tel,email,centerId,createTime);
        if(result > 0){
            return "create success";
        }
        return "create fail";
    }



    @RequestMapping(value = "/update_classteacher")
    @ResponseBody
    public String updateClassteacher(int ctid, String ctname, String tel,String email, String leavedate, String leaveReason, String centerId, String state, String gender){
        int result = jiaoWuService.updateClassteacher(ctid, ctname, tel,email, leavedate, leaveReason, centerId, state, gender);
        if(result > 0){
            return "edit success";
        }
        return "edit fail";

    }



    @RequestMapping(value = "/classteacherList")
    @ResponseBody
    public List<ClassTeacher> listClassTeachers(Map<String, Object> model){
        //查询数据库，获取教学中心信息
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        return classTeachers;
    }



    @RequestMapping(value = "/teacher")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/teacher','y')")
    public String getTeacherInfo(Map<String, Object> model){
        //查询数据库，获取教师员信息
        List<Teacher> teachers = jiaoWuService.getTeacherList();
        model.put("teachers", teachers);

        List<Position> positions = jiaoWuService.getPositionList();
        model.put("positions", positions);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);

        return "jiaowu_teacher";
    }



    @RequestMapping(value = "/new_teacher")
    @ResponseBody
    public String createNewTeacher(Teacher_t teacher_t ){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.insertNewTeacher(teacher_t);
        if(result > 0){
            return "success";
        }
        return "fail";
    }


    @RequestMapping(value = "/update_teacher")
    @ResponseBody
    public String updateTeacher(Teacher_t teacher_t ){
        //查询数据库，获取教学中心信息
        int result = jiaoWuService.updateTeacher(teacher_t);
        if(result > 0){
            return "update success";
        }
        return "update fail";
    }


    @RequestMapping(value = "/teacherList")
    @ResponseBody
    public JSONObject teacherList(){
        //查询数据库，获取教师员信息
        JSONObject result = new JSONObject();
        List<Teacher> teachers = jiaoWuService.getTeacherList();
        result.put("teachers", teachers);

        List<Position> positions = jiaoWuService.getPositionList();
        result.put("positions", positions);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        result.put("directions", directions);

        return result;
    }


    @RequestMapping(value = "/score")
    @PreAuthorize("hasPermission('/jiaowu/score','y')")
    public String getScoreInfo(Map<String, Object> model){

        List<Center> centers = jiaoWuService.getCenterList2();
        model.put("centers", centers);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);



        //获取最近一年的数据
        List<ClassTeacher> classTeachers_recent = classService.getClassTeachersForRecent();
        model.put("classteachers_recent", classTeachers_recent);

        List<Teacher> teachers = jiaoWuService.getTeacherListForRecent();
        model.put("teachers_recent", teachers);

        List<String> classcodes_all = classService.listClasscodeForRecent();
        model.put("classcodes_recent", classcodes_all);
        //获取最近一年的数据

        if(classTeachers != null && classTeachers.size() > 0){
            List<String> classcodes = classService.getClassCodesByClidTime(classTeachers.get(0).getCtid(),"2000-01-01", Tool.getCurrentDate());
            model.put("classcodes", classcodes);

            if(classcodes != null && classcodes.size() > 0){
                String dname = classService.getDirectionNameByClassCode(classcodes.get(0));
                model.put("dname", dname);
            }
        }


        return "jiaowu_comprehensivescore";
    }


    @RequestMapping(value = "/getTeachersClassteachersClasscodesForTime")
    @ResponseBody
    public JSONObject getTeachersClassteachersClasscodesForTime(String startTime, String endTime){
        //查询数据库，获取教师员信息
        JSONObject result = new JSONObject();
        List<ClassTeacher> classTeachers = classService.getClassTeachersForBetweenTime(startTime, endTime);
        result.put("classteachers_recent", classTeachers);

        List<Teacher> teachers = jiaoWuService.getTeacherListForBetweenTime(startTime, endTime);
        result.put("teachers_recent", teachers);

        List<String> classcodes = classService.listClasscodeForBetweenTime(startTime, endTime);
        result.put("classcodes_recent", classcodes);

        return result;
    }


    @RequestMapping(value = "/xueji")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/xueji','y')")
    public String getXuejiInfo(Map<String, Object> model){
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);

        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

        List<String> classcodes = classService.getClassCodesByClid(classTeachers.get(0).getCtid());
        model.put("classcodes", classcodes);

        List<String> allclasscodes = classService.listClasscode();
        model.put("allclasscodes", allclasscodes);

        List<String> updateTypes = classService.getXuejiUpdateTypes();
        model.put("updateTypes", updateTypes);

        return "jiaowu_xueji";
    }


    @RequestMapping(value = "/course")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/jiaowu/course','y')")
    public String getCourseInfo(Map<String, Object> model){
        List<Course> courses = jiaoWuService.getCourseList();
        model.put("courses", courses);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        model.put("directions", directions);

        return "jiaowu_course";
    }


    @RequestMapping(value = "/courseList")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @ResponseBody
    public JSONObject getCourseList(Map<String, Object> model){
        JSONObject jsonObject = new JSONObject();
        List<Course> courses = jiaoWuService.getCourseList();
        jsonObject.put("courses", courses);

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        jsonObject.put("directions", directions);
        return jsonObject;
    }



    @RequestMapping(value = "/new_course")
    @ResponseBody
    public String createNewCourse(HttpServletRequest request){
        String directionId = request.getParameter("directionId");
        String cname = request.getParameter("cname");
        String describe = request.getParameter("describe");
        String createTime = request.getParameter("createTime");
        String chapters_str = request.getParameter("chapters");

        Course_t course_t = new Course_t();
        course_t.setDirectionId(Integer.parseInt(directionId));
        course_t.setCname(cname);
        course_t.setDescribe(describe);
        course_t.setCreateTime(createTime);

        List<Chapter> chapters = new ArrayList<>();
        JSONArray jsonArray = JSONArray.parseArray(chapters_str);
        for(int i = 0; i < jsonArray.size(); i++){
            Chapter chapter = new Chapter();
            JSONObject jsonObject = JSONObject.parseObject(jsonArray.get(i).toString());
            chapter.setCpdescribe(jsonObject.getString("cpdescribe"));
            chapter.setCpname(jsonObject.getString("cpname"));
            chapter.setPeriod(jsonObject.getIntValue("period"));
            chapter.setPosInCourse(jsonObject.getIntValue("posInCourse"));
            chapters.add(chapter);
        }
        course_t.setChapters(chapters);

        boolean isSuccess = jiaoWuService.insertNewCourse(course_t);
        if(isSuccess){
            return "create success";
        }
        return "create fail";
    }




    @RequestMapping(value = "/chapters")
    @ResponseBody
    public List<Chapter> chapterList(int cid){
        List<Chapter> chapters = jiaoWuService.getChaptersByCid(cid);
        return chapters;
    }



    @RequestMapping(value = "/getXuejiInfoByClassCode")
    @ResponseBody
    public List<BaseinfoForTrainee> getXuejiInfoByClassCode(String  classcode){
        List<BaseinfoForTrainee> baseinfoForTrainees = jiaoWuService.getXuejiInfoByClassCode(classcode);
        return baseinfoForTrainees;
    }



    /*
     {"classcode":classcode,"code":code,"timee":timee,"type":type,"content":content,"reason":reason,"result":result},
     */

    @RequestMapping(value = "/saveXuejiInfo")
    @ResponseBody
    public  int saveXuejiInfo(Xueji  xueji){
        System.out.println(xueji.getImgProof()+"-->" + xueji.getTargetClasscode());
        int result = -1;
        int id = xueji.getId();
        if(id > 0){
            result = jiaoWuService.updateXuejiInfo(xueji);
        }else{
            result = jiaoWuService.saveXuejiInfo(xueji);
        }

        if(result > 0){
            return xueji.getId();
        }
        return -1;
    }



    @RequestMapping(value = "/getXuejiDetail")
    @ResponseBody
    public List<Xueji> getXuejiDetail(String  classcode){
        List<Xueji> xuejis = jiaoWuService.getXuejiDetail(classcode);
        List<Xueji> xuejis2 = jiaoWuService.getSwitchXuejiDetail(classcode);
        if(xuejis != null && xuejis2 != null ){
            xuejis.addAll(xuejis2);
        }


        return xuejis;
    }


    @RequestMapping(value = "/getXuejiDetail2")
    @ResponseBody
    public JSONObject getXuejiDetail2(String  classcode){

        JSONObject jsonObject = new JSONObject();

        List<Xueji> xuejis = jiaoWuService.getXuejiDetail(classcode);
        List<Xueji> xuejis2 = jiaoWuService.getSwitchXuejiDetail(classcode);
        if(xuejis != null && xuejis2 != null ){
            xuejis.addAll(xuejis2);
        }

        jsonObject.put("xuejis", xuejis);

        Calendar cal = Calendar.getInstance();
        int year = cal.get(Calendar.YEAR);
        String y2 = (year+"").substring(2);
        List<String> classcodes = classService.listClasscode();
        List<String> classcodes2 = new ArrayList<>();
        for(String ccode:classcodes){
            if(ccode.substring(3,5).equals(y2)){
                classcodes2.add(ccode);
            }
        }
        jsonObject.put("classcodes", classcodes2);


        return jsonObject;
    }

    @RequestMapping(value = "/getXuejiByName")
    @ResponseBody
    public JSONObject getXuejiByName(String  name){

        JSONObject jsonObject = new JSONObject();
        List<Xueji> xuejis;

        // List<Xueji> xuejis = jiaoWuService.getXuejiDetail(classcode);
        if (name.substring(0,3).toUpperCase().charAt(0) >= 'A' && name.substring(0,3).toUpperCase().charAt(0) <= 'Z') {
            xuejis = jiaoWuService.getXuejiByCode(name);
        } else {
            xuejis = jiaoWuService.getXuejiByName(name);
        }

        jsonObject.put("xuejis", xuejis);

        Calendar cal = Calendar.getInstance();
        int year = cal.get(Calendar.YEAR);
        String y2 = (year+"").substring(2);
        List<String> classcodes = classService.listClasscode();
        List<String> classcodes2 = new ArrayList<>();
        for(String ccode:classcodes){
            if(ccode.substring(3,5).equals(y2)){
                classcodes2.add(ccode);
            }
        }
        jsonObject.put("classcodes", classcodes2);


        return jsonObject;
    }



    @RequestMapping(value = "/updateXuejiInfo")
    @ResponseBody
    public String updateXuejiInfo(Xueji  xueji){
        System.out.println(xueji.getImgProof() + "-->" + xueji.getTargetClasscode());
        int result = jiaoWuService.updateXuejiInfo(xueji);
        if(result > 0){
            return "success";
        }
        return "fail";
    }




    @RequestMapping(value = "/newImg", method = RequestMethod.POST)
    @ResponseBody
    public String newImg(MultipartFile imgFile_new, javax.servlet.http.HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();

        // 原始名称
        String oldFileName = imgFile_new.getOriginalFilename(); // 获取上传文件的原名
        //获取服务器指定文件存取路径 
        String savedDir = "C:\\teach-upload\\";


        // 上传图片
        if (imgFile_new != null && oldFileName != null && oldFileName.length() > 0) {

            String id = request.getParameter("id_new");
            String code = request.getParameter("codeee_new");

            // 新的图片名称
            String newFileName = "xueji_" + code + "_" + oldFileName;
            // 新图片
            File newFile = new File(savedDir + "\\" + newFileName);
            // 将内存中的数据写入磁盘
            imgFile_new.transferTo(newFile);

            //修改数据库
            //先看表中该code是否存在，不存在的话，创建。存在的话更新
            int result = -1;
            //Xueji xueji = jiaoWuService.getXuejiById(id);
            if(id == null || id.length() == 0){
                Xueji xueji = new Xueji();
                xueji.setImgProof(newFileName);
                result = jiaoWuService.createXueji(xueji);
                json.put("id",xueji.getId());
            }else{
                result = jiaoWuService.updateXuejiImage(id, newFileName);
                json.put("id",Integer.parseInt(id));
            }

            if(newFileName != null && newFileName.length() > 0){
                json.put("imgurl",newFileName);
                newFileName = Tool.serverAddress + "/" + newFileName;
                json.put("imgProof",newFileName);
            }



            if(result > 0){
                json.put("result","success");
                //json.put("type",type);
            }else{
                json.put("result","fail");
            }

        } else {
            json.put("result","fail");
        }

        return json.toString();
    }




    @RequestMapping(value = "/updateImg", method = RequestMethod.POST)
    @ResponseBody
    public String updateImg(MultipartFile imgFile_update, javax.servlet.http.HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();

        // 原始名称
        String oldFileName = imgFile_update.getOriginalFilename(); // 获取上传文件的原名
        //获取服务器指定文件存取路径 
        String savedDir = "C:\\teach-upload\\";


        // 上传图片
        if (imgFile_update != null && oldFileName != null && oldFileName.length() > 0) {

            String id = request.getParameter("id_update");
            String code = request.getParameter("codeee_update");

            // 新的图片名称
            String newFileName = "xueji_" + code + "_" + oldFileName;
            // 新图片
            File newFile = new File(savedDir + "\\" + newFileName);
            // 将内存中的数据写入磁盘
            imgFile_update.transferTo(newFile);


            int result = -1;
            result = jiaoWuService.updateXuejiImage(id, newFileName);

            if(result > 0){
                json.put("result","success");
                json.put("id",Integer.parseInt(id));

                json.put("imgurl",newFileName);

                if(newFileName != null && newFileName.length() > 0){
                    newFileName = Tool.serverAddress + "/" + newFileName;
                }
                json.put("imgProof",newFileName);
                //json.put("type",type);
            }else{
                json.put("result","fail");
            }

        } else {
            json.put("result","fail");
        }

        return json.toString();
    }




    @RequestMapping(value = "/getImgProofById")
    @ResponseBody
    public JSONObject getImgProofById(int id, HttpServletRequest request) throws UnknownHostException {
        JSONObject jsonObject = new JSONObject();
        String imgProof = jiaoWuService.getImgProofById(id);
        if(imgProof != null && imgProof.length() > 0){
            jsonObject.put("result", "success");

            jsonObject.put("imgurl", imgProof);
            imgProof = Tool.serverAddress + "/" + imgProof;
            jsonObject.put("imgProof", imgProof);

        }else{
            jsonObject.put("imgDefault", Tool.serverAddress + "/img/default.jpg");
            jsonObject.put("result", "fail");
        }
        return jsonObject;
    }


    /*{"cid": cid, "cname": cname, "describe":describe,"directionId":directionId,"chapters":chapters}*/

    @RequestMapping(value = "/updateCourse")
    @ResponseBody
    public String updateCourse(int cid, String cname, String describe,int directionId, String chapters){
        Course_t course_t = new Course_t();
        course_t.setCid(cid);
        course_t.setCname(cname);
        course_t.setDescribe(describe);
        course_t.setDirectionId(directionId);

        List<Chapter> chapterList = new ArrayList<>();
        JSONArray jsonArray = JSONArray.parseArray(chapters);
        for(int i = 0; i < jsonArray.size();i++){
            Chapter chapter = new Chapter();
            JSONObject jsonObject = JSONObject.parseObject(jsonArray.get(i).toString());
            chapter.setCpname(jsonObject.get("cpname").toString());
            chapter.setCpdescribe(jsonObject.get("cpdescribe").toString());
            chapter.setPeriod(Integer.parseInt(jsonObject.get("period").toString()));

            chapterList.add(chapter);
        }
        int result = -1;
        course_t.setChapters(chapterList);
        result = jiaoWuService.updateCourse(course_t);
        if(result > 0){
            return "success";
        }else{
            return "fail";
        }
    }



    @RequestMapping(value = "/getTeacherByCondition")
    @ResponseBody
    public List<Teacher> getTeacherByCondition(String startTime, String endTime, int pid, int tid){

        List<Teacher> teachers = jiaoWuService.getTeacherByCondition(startTime, endTime, pid, tid);
        return teachers;
    }



    @RequestMapping(value = "/getTeacherByCondition2")
    @ResponseBody
    public JSONObject getTeacherByCondition2(String startTime, String endTime, int pid, int tid){
        JSONObject jsonObject = new JSONObject();
        List<Teacher> teachers = jiaoWuService.getTeacherByCondition(startTime, endTime, pid, tid);
        jsonObject.put("teachers",teachers);
        List<Direction> directions = jiaoWuService.getDirectionInfo();
        jsonObject.put("directions",directions);
        List<Position> positions = jiaoWuService.getPositionList();
        jsonObject.put("positions",positions);
        return jsonObject;
    }




    @RequestMapping(value = "/getClassteacherByCondition")
    @ResponseBody
    public List<ClassTeacher> getClassteacherByCondition(String startTime, String endTime, int cid, int ctid){

        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeachersByCondition(startTime, endTime, cid, ctid);
        return classTeachers;
    }




    @RequestMapping(value = "/getClassteacherByCondition2")
    @ResponseBody
    public JSONObject getClassteacherByCondition2(String startTime, String endTime, int cid, int ctid){
        JSONObject jsonObject = new JSONObject();
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeachersByCondition(startTime, endTime, cid, ctid);
        jsonObject.put("classTeachers", classTeachers);
        List<Center> centers = jiaoWuService.getCenterList();
        jsonObject.put("centers", centers);
        return jsonObject;
    }



    @RequestMapping(value = "/classteachers2")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    public JSONObject classteachers2(Map<String, Object> model){
        //查询数据库，获取教学中心信息
        JSONObject jsonObject = new JSONObject();
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        model.put("classTeachers", classTeachers);
        jsonObject.put("classTeachers",classTeachers);

        List<Center> centers = jiaoWuService.getCenterList();
        jsonObject.put("centers",centers);


        return jsonObject;
    }




    @RequestMapping(value = "/getXuejiSummary")
    @ResponseBody
    public List<XuejiSummary> getXuejiSummary(XuejiCondition xuejiCondition){
        List<XuejiSummary> xuejiSummaries = new ArrayList<>();
        List<KV> kvs = jiaoWuService.getXiuxueFuXue_XuejiSummary(xuejiCondition);
        for(KV kv:kvs){
            XuejiSummary xuejiSummary = new XuejiSummary();
            xuejiSummary.setClasscode(kv.getK());
            xuejiSummary.setXiuxuefuxue_add(kv.getV());
            xuejiSummaries.add(xuejiSummary);
        }

        List<KV> kvs2 = jiaoWuService.getChongxiuRuban_XuejiSummary(xuejiCondition);
        boolean isExist = false;
        for(KV kv:kvs2){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setChongxiuruban_add(kv.getV());
                    xuejiSummary.setFuxuerenshu_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setChongxiuruban_add(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }


        }


        List<KV> kvs3 = jiaoWuService.getZhuanruBenban_XuejiSummary(xuejiCondition);
        for(KV kv:kvs3){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setZhuanrubenban_add(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setZhuanrubenban_add(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }


        }



        List<KV> kvs4 = jiaoWuService.getZhuanquBieban_XuejiSummary(xuejiCondition);
        for(KV kv:kvs4){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setZhuanqubieban_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setZhuanqubieban_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        List<KV> kvs5 = jiaoWuService.getChongxiuLiban_XuejiSummary(xuejiCondition);
        for(KV kv:kvs5){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setChongxiuliban_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setChongxiuliban_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs6 = jiaoWuService.getXiuxueLiban_XuejiSummary(xuejiCondition);
        for(KV kv:kvs6){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setXiuxuelibanrenshu_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setXiuxuelibanrenshu_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs7 = jiaoWuService.getZizhuZeye_XuejiSummary(xuejiCondition);
        for(KV kv:kvs7){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setZizhuzeyerenshu_sub(kv.getV());
                    xuejiSummary.setZizhuzeyerenshu_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setZizhuzeyerenshu_sub(kv.getV());
                xuejiSummary.setZizhuzeyerenshu_summary(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs8 = jiaoWuService.getTuifeiRenshu_XuejiSummary(xuejiCondition);
        for(KV kv:kvs8){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuifeirenshu_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuifeirenshu_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs9 = jiaoWuService.getShilianRenshu_XuejiSummary(xuejiCondition);
        for(KV kv:kvs9){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setShilianrenshu_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setShilianrenshu_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs10 = jiaoWuService.getTuixueRenshu_XuejiSummary(xuejiCondition);
        for(KV kv:kvs10){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuixuerenshu_sub(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuixuerenshu_sub(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs11 = jiaoWuService.getZizhuZeyeForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs11){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setWeiman3yuezizhuzeye_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setWeiman3yuezizhuzeye_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs12 = jiaoWuService.getTuifeiRenshuForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs12){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuifeirenshu_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuifeirenshu_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        List<KV> kvs13 = jiaoWuService.getShilianRenshuForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs13){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setShilianrenshu_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setShilianrenshu_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        List<KV> kvs14 = jiaoWuService.getXiuxuebufuxueForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs14){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setXiuxuebufuxue_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setXiuxuebufuxue_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }


        List<KV> kvs15 = jiaoWuService.getTuixueRenshuForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs15){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuifeirenshu_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuifeirenshu_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        List<KV> kvs16 = jiaoWuService.getTuixueRenshuForNot3_XuejiSummary(xuejiCondition);
        for(KV kv:kvs16){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuixuerenshu_liushi(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuixuerenshu_liushi(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }

/////////////////////////////////////////数据统计///////////////////////////////////////////////////////

        List<KV> kvs17 = jiaoWuService.getJiebanRenshu_Summary(xuejiCondition);
        for(KV kv:kvs17){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setJiebanrenshu_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setJiebanrenshu_summary(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }

        List<KV> kvs18 = jiaoWuService.getKaibanRenshu_Summary(xuejiCondition);
        for(XuejiSummary xuejiSummary:xuejiSummaries){
            String classcode = xuejiSummary.getClasscode();
            int jieyerenshu = 0;
            for(KV kv:kvs17){
                if(kv.getK().equals(classcode)){
                    jieyerenshu = kv.getV();
                    break;
                }
            }
            int kaibanrenshu = 0;
            for(KV kv:kvs18){
                if(kv.getK().equals(classcode)){
                    kaibanrenshu = kv.getV();
                    break;
                }
            }

            if(kaibanrenshu > 0){
                xuejiSummary.setLiushilv_summary(1f*jieyerenshu/kaibanrenshu);
            }
        }




        List<KV> kvs19 = jiaoWuService.getTuichiJiuye_Summary(xuejiCondition);
        for(KV kv:kvs19){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setTuichijiuye_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setTuichijiuye_summary(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        List<KV> kvs20 = jiaoWuService.getJinrujiuyeRenshu_Summary(xuejiCondition);
        for(KV kv:kvs20){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setJinrujiuyerenshu_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setJinrujiuyerenshu_summary(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }



        for(XuejiSummary xuejiSummary:xuejiSummaries){
            String classcode = xuejiSummary.getClasscode();
            int jieyerenshu = 0;
            for(KV kv:kvs17){
                if(kv.getK().equals(classcode)){
                    jieyerenshu = kv.getV();
                    break;
                }
            }

            int jinrujiuyerenshu = 0;
            for(KV kv:kvs20){
                if(kv.getK().equals(classcode)){
                    jinrujiuyerenshu = kv.getV();
                    break;
                }
            }

            int weijinrujiuyerenshu = jieyerenshu - jinrujiuyerenshu;
            if(weijinrujiuyerenshu > 0){
                xuejiSummary.setBufuhejiuyerenshu_summary(weijinrujiuyerenshu);
            }
        }


        List<KV> kvs21 = jiaoWuService.getYijiuyeRenshu_Summary(xuejiCondition);
        for(KV kv:kvs21){
            String classcode = kv.getK();
            isExist = false;
            for(XuejiSummary xuejiSummary:xuejiSummaries){
                if(classcode.equals(xuejiSummary.getClasscode())){
                    xuejiSummary.setYijiuyerenshu_summary(kv.getV());
                    isExist = true;
                    break;
                }
            }
            if(false == isExist){
                XuejiSummary xuejiSummary = new XuejiSummary();
                xuejiSummary.setClasscode(kv.getK());
                xuejiSummary.setYijiuyerenshu_summary(kv.getV());
                xuejiSummaries.add(xuejiSummary);
            }

        }





        for(XuejiSummary xuejiSummary:xuejiSummaries){
            String classcode = xuejiSummary.getClasscode();
            int jinrujiuyerenshu = 0;
            for(KV kv:kvs20){
                if(kv.getK().equals(classcode)){
                    jinrujiuyerenshu = kv.getV();
                    break;
                }
            }
            int yijiuyerenshu = 0;
            for(KV kv:kvs21){
                if(kv.getK().equals(classcode)){
                    yijiuyerenshu = kv.getV();
                    break;
                }
            }

            if(jinrujiuyerenshu > 0){
                xuejiSummary.setJiuyelv_summary(1f*yijiuyerenshu/jinrujiuyerenshu);
            }
        }

        List<Direction> directions = jiaoWuService.getDirectionInfo();
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        List<ClassGeneralInfo> classGeneralInfos = classService.getClassBaseInfo();

        for(XuejiSummary xuejiSummary:xuejiSummaries){
            String classcode = xuejiSummary.getClasscode();
            int did = classService.getDirectionIdByClassCode(classcode);
            for(Direction d:directions){
                if(d.getDid() == did){
                    xuejiSummary.setDname(d.getDname());
                    break;
                }
            }

            int ctid = classService.getClassTeacherIdByClassCode(classcode);
            for(ClassTeacher classTeacher:classTeachers){
                if(classTeacher.getCtid() == ctid){
                    xuejiSummary.setCtname(classTeacher.getCtname());
                    break;
                }
            }

            for(ClassGeneralInfo classGeneralInfo:classGeneralInfos){
                if(classGeneralInfo.getClasscode().equals(classcode)){
                    xuejiSummary.setState(classGeneralInfo.getState());
                    break;
                }
            }
        }

        return xuejiSummaries;
    }



    @RequestMapping(value = "/traineeInfo")
    @PreAuthorize("hasPermission('/jiaowu/traineeInfo','y')")
    public String traineeInfo(){
        return "traineeInfo";
    }


    @RequestMapping(value = "/exportXueji")
    public String exportXueji(HttpServletResponse response, String startTime, String endTime, String xuejiType, Integer way, Integer value){

        String fileName = "学籍信息_" + startTime + endTime + xuejiType + way+"" + value + Tool.getCurrentDate() + ".xlsx";
        String filePth = "C:/teach-upload/" + fileName;
        File file = new File(filePth);

        try {
            if(!file.exists()){
                List<Xueji> xuejis = null;
                List<Xueji> xuejis2 = null;
                switch(way){
                    case 0:
                        xuejis = jiaoWuService.getXuejiDetailFromCenterId(value);
                        xuejis2 = jiaoWuService.getSwitchXuejiDetailFromCenterId(value);
                        break;
                    case 1:
                        xuejis = jiaoWuService.getXuejiDetailFromDirectionId(value);
                        xuejis2 = jiaoWuService.getSwitchXuejiDetailFromDirectionId(value);
                        break;
                    case 2:
                        xuejis = jiaoWuService.getXuejiDetailFromClassteacherId(value);
                        xuejis2 = jiaoWuService.getSwitchXuejiDetailFromClassteacherId(value);
                        break;
                }

                if(xuejis != null && xuejis2 != null ){
                    xuejis.addAll(xuejis2);
                }

                ExcelUtil.createXuejiFile(filePth, xuejis);
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




    @RequestMapping(value = "/exportScores")          //way--- 0班级  1老师   2班主任
    public String exportScores(HttpServletResponse response, String startTime, String endTime,  Integer way, String value){
        if(value == null){
            return null;
        }

        String fileName = "综合成绩_" + startTime + endTime + way+"" + value + Tool.getCurrentDate() + ".xlsx";
        String filePth = "C:/teach-upload/" + fileName;
        File file = new File(filePth);

        List<List<ComprehensiveScore>> comprehensiveScores_all = new ArrayList<>();
        List<String> classcodes = new ArrayList<>();

        try {
            if(!file.exists()){

                switch(way){
                    case 0:
                        classcodes.add(value);
                        break;
                    case 1:
                        classcodes = classService.getClasscodeByTid(Integer.parseInt(value));
                        break;
                    case 2:
                        int ctid = Integer.parseInt(value);
                        classcodes = classService.getClassCodesByClidTime(ctid, startTime, endTime);
                        break;
                }

                if(classcodes.size() > 0 ){
                    for(String classcode:classcodes){
                        String dname = classService.getDirectionNameByClassCode(classcode);
                        List<Score> scores = learnProdurceService.getScoreDetailByClasscode(classcode);
                        if(scores != null && scores.size() > 0){
                            Map<String, List<Score>> map = Tool.getSortedMapCodeAsKey(scores);
                            List<ComprehensiveScore> comprehensiveScores = Tool.ConvertToComprehenssiveScores(map);//获取综合成绩中的测试成绩--固定

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

                            comprehensiveScores_all.add(comprehensiveScores);

                        }
                    }

                }

                ExcelUtil.createComprehensiveScoreFile(filePth, comprehensiveScores_all);
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




    @RequestMapping(value = "/getCenterDirectionClasscodesForTime")
    @ResponseBody
    public JSONObject getCenterDirectionClasscodesForTime(String startTime, String endTime){
        //查询数据库，获取教师员信息
        JSONObject result = new JSONObject();
        List<Center> centers = classService.getCenterListForBetweenTime(startTime, endTime);
        result.put("centers_recent", centers);

        List<Direction> directions = jiaoWuService.getDirectionInfoForBetweenTime(startTime, endTime);
        result.put("directions_recent", directions);

        List<String> classcodes = classService.listClasscodeForBetweenTime(startTime, endTime);
        result.put("classcodes_recent", classcodes);

        return result;
    }



    @RequestMapping(value = "/getCenterDirectionClassteachersForTime")
    @ResponseBody
    public JSONObject getCenterDirectionClassteachersForTime(String startTime, String endTime){
        //查询数据库，获取教师员信息
        JSONObject result = new JSONObject();
        List<Center> centers = classService.getCenterListForBetweenTime(startTime, endTime);
        result.put("centers_recent", centers);

        List<Direction> directions = jiaoWuService.getDirectionInfoForBetweenTime(startTime, endTime);
        result.put("directions_recent", directions);

        List<ClassTeacher> classteachers = classService.getClassTeachersForBetweenTime(startTime, endTime);
        result.put("classteachers_recent", classteachers);

        return result;
    }








}
