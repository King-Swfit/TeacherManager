package com.haitong.youcai.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.haitong.youcai.entity.*;
import com.haitong.youcai.service.ClassService;
import com.haitong.youcai.service.CorporiationService;
import com.haitong.youcai.service.JiaoWuService;
import com.haitong.youcai.utils.ExcelUtil;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.HandlerAdapter;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2019/5/22.
 */
@Controller
@RequestMapping("/corporiate") //在类上使用RequestMapping，里面设置的value就是方法的父路径
public class CorporiationController {
    @Autowired
    private JiaoWuService jiaoWuService;
    @Autowired
    private CorporiationService corporiationService;

    @Autowired
    private ClassService classService;


    @RequestMapping(value = "/connectRecord")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/corporiate/connectRecord','y')")
    public String getCenterInfo(Map<String, Object> model) {


        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        //班主任
        List<ClassTeacher> classTeachers = classService.getClassTeachersByCenterId(-1);
        model.put("classteachers", classTeachers);

        ClassQueryCondition classQueryCondition = new ClassQueryCondition();
        String[] days = Tool.getDefaultTimeSection();
        classQueryCondition.setCenterId(-1);
        classQueryCondition.setClassteacherId(-1);
        classQueryCondition.setStartTime(days[0]);
        classQueryCondition.setEndTime(days[1]);
        classQueryCondition.setClassstate("全部");
        List<String> classcodes = classService.getClassGeneralInfoByCondition3(classQueryCondition);
        model.put("classcodes",classcodes);



        //公司
        List<Corporiation> corporiations = corporiationService.getCorporiationsByCtid(classTeachers.get(0).getCtid());
        model.put("corporiations",corporiations);

        if(corporiations != null && corporiations.size() > 0){
            model.put("corporiation",corporiations.get(0));
        }

        List<String> diplomaStates = classService.getDiplomaStates();
        model.put("diplomaStates", diplomaStates);

        return "corporiation_connectRecord";
    }






    @RequestMapping(value = "/corporationBaseInfo")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/corporiate/corporationBaseInfo','y')")
    public String corporationBaseInfo(Map<String, Object> model) {
        //班主任
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        model.put("classteachers", classTeachers);

        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        //公司
        List<Corporiation> corporiations = corporiationService.getSimpleCorporiationInfos();
        model.put("corporiations", corporiations);

        return "corporiation_baseinfo";
    }


    @RequestMapping(value = "/getSimpleCorporiationsByCtid")
    @ResponseBody
    public List<Corporiation> getSimpleCorporiationsByCtid(int ctid) {
        List<Corporiation> corporiations = corporiationService.getSimpleCorporiationsByCtid(ctid);
        return corporiations;
    }

    @RequestMapping(value = "/getCorporiationsByCtid")
    @ResponseBody
    public List<Corporiation> getCorporiationsByCtid(int ctid) {
        List<Corporiation> corporiations = corporiationService.getCorporiationsByCtid(ctid);
        return corporiations;
    }




    @RequestMapping(value = "/getCorporiationByCid")
    @ResponseBody
    public Corporiation getCorporiationByCid(int cid) {
        Corporiation corporiation = corporiationService.getCorporiationByCid(cid);
        return corporiation;
    }




    @RequestMapping(value = "/saveNewCorporiation")
    @ResponseBody
    public Corporiation saveNewCorporiation(Corporiation corporiation) {
        int result = corporiationService.saveNewCorporiation(corporiation);
        if(result > 0){
            return corporiation;
        }
        return null;
    }


    /*SELECT classcode, SUM(CASE WHEN result='成功' THEN 1 END) AS cn FROM process_employ_interview GROUP BY classcode;*/
    @RequestMapping(value = "/listCorporiationBseInos")
    @ResponseBody
    public List<Corporiation> listCorporiationBseInos(int numbers, String isEnroll, String startTime, String endTime) {
        List<Corporiation> corporiations = corporiationService.listCorporiationBseInos(numbers, isEnroll, startTime, endTime);
        if(corporiations != null && corporiations.size() > 0){
            for(Corporiation corporiation:corporiations){
                int tid = corporiation.getTid();
                String ctname = classService.getCtnameByCtid(tid);
                corporiation.setTname(ctname);
            }
        }

        return corporiations;
    }

    @RequestMapping(value = "/listCorporiationsByName")
    @ResponseBody
    public List<Corporiation> listCorporiationsByName(String name) {
        List<Corporiation> corporiations = corporiationService.listCorporiationsByName(name);
        return corporiations;
    }




    @RequestMapping(value = "/updateCorporiationInfo")
    @ResponseBody
    public String updateCorporiationInfo(Corporiation corporiation) {
        int result = corporiationService.updateCorporiationInfo(corporiation);
        if(result > 0){
            return "success";
        }
        return "fail";
    }



    @RequestMapping(value = "/saveNewConnectRecord")
    @ResponseBody
    public int saveNewConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed) {
        int result = corporiationService.saveNewConnectRecord(corporiationConnectRecoed);
        if(result > 0){
            int cid = corporiationConnectRecoed.getCorporiationId();
            Corporiation corporiation = corporiationService.getCorporiationByCid(cid);
            combinConnectInfo(corporiation, corporiationConnectRecoed);
            corporiationService.updateAddConnectionInfo(corporiation);
            return corporiationConnectRecoed.getCcrid();
        }
        return -1;
    }

    private void combinConnectInfo(Corporiation corporiation, CorporiationConnectRecoed corporiationConnectRecoed){
        String contact_new = corporiationConnectRecoed.getContectName();
        String contact_old = corporiation.getContectName();
        String contactName = Tool.addNewToOldContent(contact_old,contact_new);
        corporiation.setContectName(contactName);

        String contactPosition_new = corporiationConnectRecoed.getContactPosition();
        String contactPosition_old = corporiation.getContactPosition();
        String contactPosition = Tool.addNewToOldContent(contactPosition_old,contactPosition_new);
        corporiation.setContactPosition(contactPosition);

        String hrmanager_new = corporiationConnectRecoed.getHrmanager();
        String hrmanager_old = corporiation.getHrmanager();
        String hrmanager = Tool.addNewToOldContent(hrmanager_old,hrmanager_new);
        corporiation.setHrmanager(hrmanager);

        String tel_new = corporiationConnectRecoed.getTel();
        String tel_old = corporiation.getTel();
        String tel = Tool.addNewToOldContent(tel_old,tel_new);
        corporiation.setTel(tel);

        String phone_new = corporiationConnectRecoed.getPhone();
        String phone_old = corporiation.getPhone();
        String phone = Tool.addNewToOldContent(phone_old,phone_new);
        corporiation.setPhone(phone);

        String qq_new = corporiationConnectRecoed.getQq();
        String qq_old = corporiation.getQq();
        String qq = Tool.addNewToOldContent(qq_old,qq_new);
        corporiation.setQq(qq);

        String weichat_new = corporiationConnectRecoed.getWeichat();
        String weichat_old = corporiation.getWeichat();
        String email = Tool.addNewToOldContent(weichat_old,weichat_new);
        corporiation.setWeichat(email);
    }




    @RequestMapping(value = "/updateConnectRecord")
    @ResponseBody
    public String updateConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed) {
        int result = corporiationService.updateConnectRecord(corporiationConnectRecoed);
        if(result > 0){
            return "success";
        }
        return "fail";
    }


    @RequestMapping(value = "/getCorporiationsByName")
    @ResponseBody
    public List<Corporiation> getCorporiationsByName(String name) {
        List<Corporiation> corporiations = corporiationService.getCorporiationsByName(name);
        return corporiations;
    }




    @RequestMapping(value = "/listConnectRecords")
    @ResponseBody
    public List<CorporiationConnectRecoed> listConnectRecords(int centerId,int classteacherId, String startTime, String endTime) {
        List<CorporiationConnectRecoed> corporiationConnectRecoeds = corporiationService.listConnectRecords(centerId,classteacherId,startTime,endTime);

        //班主任
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        Map<Integer,String> ctmap = new HashMap<>();
        for(ClassTeacher ct:classTeachers){
            ctmap.put(ct.getCtid(), ct.getCtname());
        }

        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();
        Map<Integer,String> cemap = new HashMap<>();
        for(Center center:centers){
            cemap.put(center.getCid(), center.getCname());
        }

        //公司
        List<Corporiation> corporiations = corporiationService.getSimpleCorporiationInfos();
        Map<Integer,String> comap = new HashMap<>();
        for(Corporiation corporiation:corporiations){
            comap.put(corporiation.getCid(), corporiation.getCname());
        }

        for(CorporiationConnectRecoed corporiationConnectRecoed:corporiationConnectRecoeds){
            corporiationConnectRecoed.setCename(cemap.get(corporiationConnectRecoed.getCenterId()));
            corporiationConnectRecoed.setCtname(ctmap.get(corporiationConnectRecoed.getClassTeacherId()));
            corporiationConnectRecoed.setCorporiationName(comap.get(corporiationConnectRecoed.getCorporiationId()));
        }


        return corporiationConnectRecoeds;
    }



    @RequestMapping(value = "/assignCorporation")
    @PreAuthorize("hasPermission('/corporiate/assignCorporation','y')")
    public String assignCorporation(Map<String, Object> model) {
        List<ClassTeacher> classteachers = classService.getValidClassTeachers();
        model.put("classteachers", classteachers);

        if(classteachers != null && classteachers.size() > 0){
            List<String> cnames = corporiationService.getCoporiationsByMasterId(classteachers.get(0).getCtid());
            model.put("cnames", cnames);
        }

        List<String> notcnames = corporiationService.getCoporiationsNoMaster();
        model.put("notcnames", notcnames);

        return "assignCorporiation";
    }



    @RequestMapping(value = "/getCoporiationsByMasterId")
    @ResponseBody
    public List<String> getCoporiationsByMasterId(int masterid) {
        List<String> cnames = corporiationService.getCoporiationsByMasterId(masterid);
        return cnames;
    }


    @RequestMapping(value = "/assignCoporiations")
    @ResponseBody
    public String assignCoporiations(@RequestParam("data") String data) {
        JSONObject jsonObject = JSONObject.parseObject(data);
        int ctid = Integer.parseInt(jsonObject.get("ctid").toString());
        JSONArray arr =  jsonObject.getJSONArray("ckr");
        int length = arr.size();
        int result = 0;
        for(int i = 0; i < length; i++){
            String cname = arr.get(i).toString();
            result = result + corporiationService.updateCoporiationMasterId(cname, ctid);
        }
        if(length == result){
            return "success";
        }

        return "fail";
    }


    @RequestMapping(value = "/releaseCoporiations")
    @ResponseBody
    public String releaseCoporiations(@RequestParam("data") String data) {
        JSONObject jsonObject = JSONObject.parseObject(data);
        JSONArray arr =  jsonObject.getJSONArray("ckl");

        int length = arr.size();
        int result = 0;
        for(int i = 0; i < length; i++){
            String cname = arr.getString(i);
            result = result + corporiationService.updateCoporiationNotMaster(cname);
        }
        if(length == result){
            return "success";
        }

        return "fail";
    }


    @RequestMapping(value = "/getCoporiationsNoMaster")
    @ResponseBody
    public List<String> getCoporiationsNoMaster() {
        List<String> notcnames = corporiationService.getCoporiationsNoMaster();
        return notcnames;
    }


    @RequestMapping(value = "/importCorporiations", method = RequestMethod.POST)
    @ResponseBody
    public String importCorporiations(@RequestParam(value = "excelFile", required = false) MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html; charset=utf-8");
        JSONObject json = new JSONObject();
        Object obj = request.getParameter("tidhid");
        Integer tid = null;
        if(null != obj){
            tid = Integer.parseInt(obj.toString());
        }else{
            tid = -1;
        }

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
                        int result = corporiationService.insertCorporiations(datas, tid);
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

    @RequestMapping(value = "/manageCorporation")  //如果方法上的RequestMapping没有value，则此方法默认被父路径调用
    @PreAuthorize("hasPermission('/corporiate/manageCorporation','y')")
    public String manageCorporation(Map<String, Object> model) {
        //班主任
        List<ClassTeacher> classTeachers = jiaoWuService.getClassTeacherList();
        model.put("classteachers", classTeachers);

        //查询数据库，获取教学中心信息
        List<Center> centers = jiaoWuService.getCenterList();
        model.put("centers", centers);

        //公司
        List<Corporiation> corporiations = corporiationService.getSimpleCorporiationInfos();
        model.put("corporiations", corporiations);

        return "corporiation_manage";
    }






    //实现Spring Boot 的文件下载功能，映射网址为/download
    @RequestMapping("/onDownload")
    public String downloadFile(HttpServletRequest request,
                               HttpServletResponse response) throws UnsupportedEncodingException {

        String fileName = "企业基础信息模板.xlsx"; //下载的文件名

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
            }
        }
        return null;
    }



    @RequestMapping("/downloadCorporations")
    public String downloadCorporations(HttpServletResponse response, int numbers, String isEnroll, String startTime, String endTime)  {
        String fileName = "企业信息_" + numbers + isEnroll + startTime + endTime + "_" + Tool.getCurrentDate() + ".xlsx";
        String filePth = "C:/teach-upload/" + fileName;
        File file = new File(filePth);
        try {
            if(!file.exists()){
                List<Corporiation> corporiations = listCorporiationBseInos(numbers, isEnroll, startTime, endTime);
                ExcelUtil.createCorporiationFile(filePth, corporiations);
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
