package com.haitong.youcai.utils;

import com.haitong.youcai.entity.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2019/4/26.
 */
public class ExcelUtil {


    public static List<List<String>> readXlsx(String path) throws Exception {
        InputStream input = new FileInputStream(path);
        return readExcel(input);
    }


    public static List<List<String>> readExcel(InputStream input) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        //当前页的内容
        List<List<String>> result = new ArrayList<List<String>>();

        Workbook workbook = WorkbookFactory.create(input);
        Iterator<Sheet> sheets =  workbook.iterator();

        if(sheets.hasNext()){
            Sheet sheet = sheets.next();

            boolean isFirstLine = true;
            Iterator<Row> rows =  sheet.iterator();
            while (rows.hasNext()){
                Row row = rows.next();

                int minCellNum = row.getFirstCellNum();
                int maxCellNum = row.getLastCellNum();

                //页内当前行内所有cell中的内容
                List<String> rowList = new ArrayList<String>();
                for (int i = minCellNum; i < maxCellNum; i++) {
                    Cell cell = row.getCell(i);
                    if (cell == null) {
                        rowList.add("-");
                        continue;
                    }
                    if(isFirstLine){
                        rowList.add(getStringVal(cell));
                    }else{
                        String v = getStringVal(cell);
                        if(v == null){
                            rowList.add(getStringVal(cell));
                        }else{
                            if(i == 17){
                                try{
                                    int datei = Integer.parseInt(v);
                                    Calendar calendar = new GregorianCalendar(1900,0,-1);
                                    calendar.add(Calendar.DATE, datei);
                                    String date = sdf.format(calendar.getTime());

                                    rowList.add(date);
                                }catch (Exception e){
                                    String str = rowList.get(rowList.size() - 1);
                                    rowList.add(str);
                                }

                            }else{
                                rowList.add(v);
                            }
                        }

                    }


                }
                result.add(rowList);

                isFirstLine = false;
            }

        }

        return result;
    }

    private static String getStringVal(Cell cell) {

        switch (cell.getCellType()) {
            case Cell.CELL_TYPE_BOOLEAN:
                return cell.getBooleanCellValue() ? "TRUE" : "FALSE";
            case Cell.CELL_TYPE_FORMULA:
                return cell.getCellFormula();
            case Cell.CELL_TYPE_NUMERIC:
                cell.setCellType(Cell.CELL_TYPE_STRING);
                return cell.getStringCellValue();
            case Cell.CELL_TYPE_STRING:
                return cell.getStringCellValue();
            default:
                return null;
        }
    }


    public static List<List<List<String>>> readExcelLoop(InputStream input) throws Exception {
        List<List<List<String>>> results = new ArrayList<List<List<String>>>();
        Workbook workbook = WorkbookFactory.create(input);
        Iterator<Sheet> sheets =  workbook.iterator();

        int sIndex =0;
        while(sheets.hasNext() && sIndex < 3 ){
            Sheet sheet = sheets.next();
            List<List<String>> result = new ArrayList<List<String>>();
            Iterator<Row> rows =  sheet.iterator();
            while (rows.hasNext()){
                Row row = rows.next();

                int minCellNum = row.getFirstCellNum();
                int maxCellNum = row.getLastCellNum();
                List<String> rowList = new ArrayList<String>();
                for (int i = minCellNum; i < maxCellNum; i++) {
                    Cell cell = row.getCell(i);
                    if (cell == null) {
                        rowList.add("-");
                        continue;
                    }
                    rowList.add(getStringVal(cell));
                }
                result.add(rowList);
            }
            results.add(result);
            sIndex++;

        }

        return results;
    }

    private static String[] corporiationHeads = {
            "公司名","公司地址","公司介绍","联系人姓名","联系人职位","hr经理","固定电话",
            "手机","qq","微信","进入企业qq","是否签约企业","累计录用学生","录入时间","录入人"
    };
    private static int[] corporiationHeadWidths={
            20,30,100,20,20,20,20,
            20,20,20,2,2,2,10,10
    };

    public static  void createCorporiationFile(String fName,  List<Corporiation> corporiations) throws Exception {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet("企业信息");

        Row titleRow = sheet.createRow(0);
        for(int i = 0; i < corporiationHeads.length; i++){
            sheet.setColumnWidth(i, (int)(corporiationHeadWidths[i] * 1.2d * 256 > 12 * 256 ? corporiationHeadWidths[i] * 1.2d * 256 : 12 * 256));
            titleRow.createCell(i).setCellValue(corporiationHeads[i]);
        }

        for (Corporiation corporiation : corporiations) {
            int lastRowNum = sheet.getLastRowNum();
            Row row = sheet.createRow(lastRowNum+1);
            row.createCell(0).setCellValue(corporiation.getCname());
            row.createCell(1).setCellValue(corporiation.getCaddress());
            row.createCell(2).setCellValue(corporiation.getDescribee());
            row.createCell(3).setCellValue(corporiation.getContectName());
            row.createCell(4).setCellValue(corporiation.getContactPosition());
            row.createCell(5).setCellValue(corporiation.getHrmanager());
            row.createCell(6).setCellValue(corporiation.getTel());

            row.createCell(7).setCellValue(corporiation.getPhone());
            row.createCell(8).setCellValue(corporiation.getQq());
            row.createCell(9).setCellValue(corporiation.getWeichat());
            row.createCell(10).setCellValue(corporiation.getIsQiyeQQ());
            row.createCell(11).setCellValue(corporiation.getIsEnroll());
            row.createCell(12).setCellValue(corporiation.getStuNumbers());
            row.createCell(13).setCellValue(corporiation.getTimee());
            row.createCell(14).setCellValue(corporiation.getTname());

        }
        File file = new File(fName);
        hssfWorkbook.write(new FileOutputStream(file));
    }

    private static String[] employHeads = {
            "学号", "姓名", "班级", "方向", "就业结果", "录取时间", "录取公司",
            "录取岗位", "录取薪资", "毕业时间", "学历", "毕业学校", "专业"
    };
    private static int[] employHeadWidths={
            20,20,20,10,20,20,20,
            10,10,20,10,10,10
    };
    public static void createEmployFile(String fName, List<List<ProcessEmployInterviewRecord>> processEmployInterviewRecords_all)  {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        for(List<ProcessEmployInterviewRecord> processEmployInterviewRecords:processEmployInterviewRecords_all){

            HSSFSheet sheet = hssfWorkbook.createSheet("就业信息_"+ processEmployInterviewRecords.get(0).getClasscode());

            Row titleRow = sheet.createRow(0);
            for(int i = 0; i < employHeads.length; i++){
                sheet.setColumnWidth(i, (int)(employHeadWidths[i] * 1.2d * 256 > 12 * 256 ? employHeadWidths[i] * 1.2d * 256 : 12 * 256));
                titleRow.createCell(i).setCellValue(employHeads[i]);
            }

            for (ProcessEmployInterviewRecord p : processEmployInterviewRecords) {
                int lastRowNum = sheet.getLastRowNum();
                Row row = sheet.createRow(lastRowNum+1);
                row.createCell(0).setCellValue(p.getCode());
                row.createCell(1).setCellValue(p.getName());
                row.createCell(2).setCellValue(p.getClasscode());
                row.createCell(3).setCellValue(p.getDname());
                if((p.getResult() != null) && (p.getResult().equals("成功"))){
                    row.createCell(4).setCellValue(p.getType());
                    row.createCell(5).setCellValue(p.getEntertimee());
                    row.createCell(6).setCellValue(p.getCorporiation());
                    row.createCell(7).setCellValue(p.getPosition());
                    row.createCell(8).setCellValue(p.getRealSalary());
                }else{
                    if(p.getType() == null){
                        p.setType("未知");
                    }
                    row.createCell(4).setCellValue(p.getType());
                    row.createCell(5).setCellValue("未知");
                    row.createCell(6).setCellValue("未知");
                    row.createCell(7).setCellValue("未知");
                    row.createCell(8).setCellValue("未知");
                }

                row.createCell(9).setCellValue(p.getGraducateTime());
                row.createCell(10).setCellValue(p.getDiploma());
                row.createCell(11).setCellValue(p.getGraduateSchool());
                row.createCell(12).setCellValue(p.getProfession());


            }
        }

        File file = new File(fName);
        try {
            hssfWorkbook.write(new FileOutputStream(file));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String[] scoreHeads = {
            "学号", "姓名", "考试时间", "学习阶段", "考试成绩", "成绩详情","学习方向","班主任"
    };
    private static int[] scoreHeadWidths={
            15,5,10,20,5,100,10,5
    };
    public static void createScoreFile(String filePth, List<Score> scores) {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet("学员成绩");

        Row titleRow = sheet.createRow(0);
        for(int i = 0; i < scoreHeads.length; i++){
            sheet.setColumnWidth(i, (int)(scoreHeadWidths[i] * 1.2d * 256 > 12 * 256 ? scoreHeadWidths[i] * 1.2d * 256 : 12 * 256));
            titleRow.createCell(i).setCellValue(scoreHeads[i]);
        }

        for (Score s : scores) {
            int lastRowNum = sheet.getLastRowNum();
            Row row = sheet.createRow(lastRowNum+1);
            row.createCell(0).setCellValue(s.getCode());
            row.createCell(1).setCellValue(s.getTrname());//?
            row.createCell(2).setCellValue(s.getTtime());
            row.createCell(3).setCellValue(s.getTname());

            row.createCell(4).setCellValue(s.getTscore());
            row.createCell(5).setCellValue(s.getDetail());
            row.createCell(6).setCellValue(s.getDname());//
            row.createCell(7).setCellValue(s.getCtname());
        }
        File file = new File(filePth);
        try {
            hssfWorkbook.write(new FileOutputStream(file));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String[] xuejiHeads = {
            "时间", "姓名", "学号", "班级", "变更类型", "目标班级","变更内容","变更原因","结果"
    };
    private static int[] xuejiHeadWidths={
            15,5,15,20,30,20,100,100,5
    };

    public static void createXuejiFile(String filePth, List<Xueji> xuejis) {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet("学籍变更");

        Row titleRow = sheet.createRow(0);
        for(int i = 0; i < xuejiHeads.length; i++){
            sheet.setColumnWidth(i, (int)(xuejiHeadWidths[i] * 1.2d * 256 > 12 * 256 ? xuejiHeadWidths[i] * 1.2d * 256 : 12 * 256));
            titleRow.createCell(i).setCellValue(xuejiHeads[i]);
        }

        for (Xueji x : xuejis) {
            int lastRowNum = sheet.getLastRowNum();
            Row row = sheet.createRow(lastRowNum+1);
            row.createCell(0).setCellValue(x.getTimee());
            row.createCell(1).setCellValue(x.getName());//?
            row.createCell(2).setCellValue(x.getCode());
            row.createCell(3).setCellValue(x.getClasscode());

            row.createCell(4).setCellValue(x.getType());
            row.createCell(5).setCellValue(x.getTargetClasscode());
            row.createCell(6).setCellValue(x.getContent());//
            row.createCell(7).setCellValue(x.getReason());
            row.createCell(8).setCellValue(x.getResult());
        }
        File file = new File(filePth);
        try {
            hssfWorkbook.write(new FileOutputStream(file));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*
    var head_java = "<th width='50px'>#</th><th width='50px'>操作</th><th width='150px'>编号</th><th width='100px'>姓名</th><th width='100px'>班级</th><th width='100px'>学习方向</th><th width='100px'>分类</th>"+
                "<th width='50px'>学历</th><th width='100px'>毕业年限</th><th th width='50px'>专业</th><th th width='100px'>就业能力</th>"+
                "<th width='200px'>se质检1(java基础语法)</th><th th width='200px'>OO三大特征和接口(自测)</th><th th width='200px'>se质检2(集合+IO)</th>"+
                "<th width='150px'>javase项目</th><th width='200px'>ee质检1(动态网页技术)</th><th width='100px'>ee质检2(ssmh)</th><th th width='200px'>数据库mysql+oracle(自测)</th>"+
                "<th width='100px'>javaee项目</th><th width='100px'>结业考试</th><th width='200px'>公司</th><th width='100px'>待遇</th>"

        var head_w  = "<th width='50px'>#</th><th width='50px'>操作</th><th width='150px'>编号</th><th width='100px'>姓名</th><th width='100px'>班级</th><th width='100px'>学习方向</th><th width='100px'>分类</th>"+
                "<th width='50px'>学历</th><th width='100px'>毕业年限</th><th th width='50px'>专业</th><th th width='100px'>就业能力</th>"+
                "<th width='200px'>c语法和函数(自测)</th><th width='200px'>质检1(数组和结构体)</th><th th width='200px'>质检2(结构体和链表)</th>"+
                "<th width='150px'>c项目</th><th width='200px'>c高级lsd(自测)</th><th width='100px'>质检3(c++和oo)</th><th width='200px'>qt(自测)</th>"+
                "<th width='100px'>c++项目</th><th width='100px'>毕业项目</th><th width='100px'>结业考试</th><th width='200px'>公司</th><th width='100px'>待遇</th>"
     */
    private static String[] javaScoreHeads = {
            "编号", "姓名", "班级", "学习方向", "分类", "学历","毕业年限","专业","就业能力",
            "se质检1(java基础语法)","OO三大特征和接口(自测)","se质检2(集合+IO)", "javase项目","ee质检1(动态网页技术)","ee质检2(ssmh)","数据库mysql+oracle(自测)","javaee项目","结业考试",
            "公司","待遇"
    };
    private static int[] javaScoreHeadWidths={
            15,5,10,10, 5, 5,5,5,5,
            5, 5,5,5,5,5,5,5,5,
            10,5
    };
    private static String[] wuScoreHeads = {
            "编号", "姓名", "班级", "学习方向", "分类", "学历","毕业年限","专业","就业能力",
            "c语法和函数(自测)","质检1(数组和结构体)","质检2(结构体和链表)","c项目","c高级lsd(自测)","质检3(c++和oo)","qt(自测)","c++项目","毕业项目","结业考试",
            "公司","待遇"
    };
    private static int[] wuScoreHeadWidths={
            15,5,10,10, 5, 5,5,5,5,
            5, 5,5,5,5,5,5,5,5,5,
            10,5
    };
    public static void createComprehensiveScoreFile(String filePth, List<List<ComprehensiveScore>> comprehensiveScores_all) {
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();

        for(List<ComprehensiveScore> comprehensives:comprehensiveScores_all){
            if(comprehensives != null && comprehensives.size() > 0){
                String dname = comprehensives.get(0).getDname();
                HSSFSheet sheet = hssfWorkbook.createSheet(comprehensives.get(0).getClasscode()+"-" + dname);
                Row titleRow = sheet.createRow(0);

                if(dname.contains("java")){
                    for(int i = 0; i < javaScoreHeads.length; i++){
                        sheet.setColumnWidth(i, (int)(javaScoreHeadWidths[i] * 1.2d * 256 > 12 * 256 ? javaScoreHeadWidths[i] * 1.2d * 256 : 12 * 256));
                        titleRow.createCell(i).setCellValue(javaScoreHeads[i]);
                    }

                    for (ComprehensiveScore c : comprehensives) {
                        int lastRowNum = sheet.getLastRowNum();
                        Row row = sheet.createRow(lastRowNum+1);
                        row.createCell(0).setCellValue(c.getCode());
                        row.createCell(1).setCellValue(c.getName());//?
                        row.createCell(2).setCellValue(c.getClasscode());
                        row.createCell(3).setCellValue(c.getDname());
                        if(c.getType() == null){
                            row.createCell(4).setCellValue("未定");
                        }else{
                            row.createCell(4).setCellValue(c.getType());
                        }
                        row.createCell(5).setCellValue(c.getDiploma());
                        row.createCell(6).setCellValue(c.getGraduateTime());//
                        row.createCell(7).setCellValue(c.getPrefession());
                        row.createCell(8).setCellValue(c.getEnery_employ());

                        Float[] tests = c.getTests();
                        if(tests[0] != null){
                            row.createCell(9).setCellValue(tests[0]);
                        }else {
                            row.createCell(9).setCellValue(-1);
                        }
                        if(tests[1] != null){
                            row.createCell(10).setCellValue(tests[1]);
                        }else {
                            row.createCell(10).setCellValue(-1);
                        }
                        if(tests[2] != null){
                            row.createCell(11).setCellValue(tests[2]);
                        }else {
                            row.createCell(11).setCellValue(-1);
                        }

                        if(tests[3] != null){
                            row.createCell(12).setCellValue(tests[3]);
                        }else {
                            row.createCell(12).setCellValue(-1);
                        }
                        if(tests[4] != null){
                            row.createCell(13).setCellValue(tests[4]);
                        }else {
                            row.createCell(13).setCellValue(-1);
                        }
                        if(tests[5] != null){
                            row.createCell(14).setCellValue(tests[5]);
                        }else {
                            row.createCell(14).setCellValue(-1);
                        }
                        if(tests[6] != null){
                            row.createCell(15).setCellValue(tests[6]);
                        }else {
                            row.createCell(15).setCellValue(-1);
                        }
                        if(tests[7] != null){
                            row.createCell(16).setCellValue(tests[7]);
                        }else {
                            row.createCell(16).setCellValue(-1);
                        }
                        if(tests[8] != null){
                            row.createCell(17).setCellValue(tests[8]);
                        }else {
                            row.createCell(17).setCellValue(-1);
                        }

                        row.createCell(18).setCellValue(c.getCorporation());
                        row.createCell(19).setCellValue(c.getSalary());




                    }
                }else{
                    for(int i = 0; i < wuScoreHeads.length; i++){
                        sheet.setColumnWidth(i, (int)(wuScoreHeadWidths[i] * 1.2d * 256 > 12 * 256 ? wuScoreHeadWidths[i] * 1.2d * 256 : 12 * 256));
                        titleRow.createCell(i).setCellValue(wuScoreHeads[i]);
                    }

                    for (ComprehensiveScore c : comprehensives) {
                        int lastRowNum = sheet.getLastRowNum();
                        Row row = sheet.createRow(lastRowNum+1);
                        row.createCell(0).setCellValue(c.getCode());
                        row.createCell(1).setCellValue(c.getName());//?
                        row.createCell(2).setCellValue(c.getClasscode());
                        row.createCell(3).setCellValue(c.getDname());
                        if(c.getType() == null){
                            row.createCell(4).setCellValue("未定");
                        }else{
                            row.createCell(4).setCellValue(c.getType());
                        }
                        row.createCell(5).setCellValue(c.getDiploma());
                        row.createCell(6).setCellValue(c.getGraduateTime());//
                        row.createCell(7).setCellValue(c.getPrefession());
                        row.createCell(8).setCellValue(c.getEnery_employ());

                        Float[] tests = c.getTests();
                        if(tests[0] != null){
                            row.createCell(9).setCellValue(tests[0]);
                        }else {
                            row.createCell(9).setCellValue(-1);
                        }
                        if(tests[1] != null){
                            row.createCell(10).setCellValue(tests[1]);
                        }else {
                            row.createCell(10).setCellValue(-1);
                        }
                        if(tests[2] != null){
                            row.createCell(11).setCellValue(tests[2]);
                        }else {
                            row.createCell(11).setCellValue(-1);
                        }

                        if(tests[3] != null){
                            row.createCell(12).setCellValue(tests[3]);
                        }else {
                            row.createCell(12).setCellValue(-1);
                        }
                        if(tests[4] != null){
                            row.createCell(13).setCellValue(tests[4]);
                        }else {
                            row.createCell(13).setCellValue(-1);
                        }
                        if(tests[5] != null){
                            row.createCell(14).setCellValue(tests[5]);
                        }else {
                            row.createCell(14).setCellValue(-1);
                        }
                        if(tests[6] != null){
                            row.createCell(15).setCellValue(tests[6]);
                        }else {
                            row.createCell(15).setCellValue(-1);
                        }
                        if(tests[7] != null){
                            row.createCell(16).setCellValue(tests[7]);
                        }else {
                            row.createCell(16).setCellValue(-1);
                        }
                        if(tests[8] != null){
                            row.createCell(17).setCellValue(tests[8]);
                        }else {
                            row.createCell(17).setCellValue(-1);
                        }
                        if(tests[9] != null){
                            row.createCell(18).setCellValue(tests[9]);
                        }else {
                            row.createCell(18).setCellValue(-1);
                        }


                        row.createCell(19).setCellValue(c.getCorporation());
                        row.createCell(20).setCellValue(c.getSalary());
                    }
                }



            }

        }

        File file = new File(filePth);
        try {
            hssfWorkbook.write(new FileOutputStream(file));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}













