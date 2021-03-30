package com.haitong.youcai.utils;

import com.haitong.youcai.entity.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2019/4/2.
 */
public class Tool {
    public static HashMap<String,Integer> scoreNameMap = new HashMap<>();
    public static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    public static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ");
    public static String serverAddress = "http://localhost:8080";
    //public static String serverAddress = "http://210.22.77.130:8081";

    static {
        scoreNameMap.put("se质检1(java基本语法)",0);
        scoreNameMap.put("OO三大特征和接口(自测)",1);
        scoreNameMap.put("se质检2(集合+IO)",2);
        scoreNameMap.put("se项目",3);
        scoreNameMap.put("ee质检1(动态网页技术)",4);
        scoreNameMap.put("ee质检2(SSMH)",5);
        scoreNameMap.put("数据库mysql和oracle(自测)",6);
        scoreNameMap.put("ee项目",7);
        scoreNameMap.put("结业考试",8);

        scoreNameMap.put("C语法和函数(自测)",0);
        scoreNameMap.put("质检1(数组,指针)",1);
        scoreNameMap.put("质检2(结构体和链表)",2);
        scoreNameMap.put("c项目",3);
        scoreNameMap.put("C高级lsd(自测)",4);
        scoreNameMap.put("质检3(c++和oo)",5);
        scoreNameMap.put("qt(自测)",6);
        scoreNameMap.put("c++项目",7);
        scoreNameMap.put("毕业项目",8);
        scoreNameMap.put("结业考试",9);
    }

    public static String getCurrentDate(){
        return sdf.format(new Date());//结束时间
    }

    public static String getCurrentDetailDate(){
        return sdf2.format(new Date());//结束时间
    }

    public static String addNewToOldContent(String oldContent, String newContent){
        if(oldContent == null || oldContent.length() == 0){
            return newContent;
        }else{
            if(newContent == null || newContent.length() == 0){
                return oldContent;
            }else if(oldContent.contains(newContent)){
                return oldContent;
            }else{
                return oldContent + "/" + newContent;
            }
        }
    }

    public static String getLastMonthDate(){
        Calendar now = Calendar.getInstance();
        now.add(Calendar.DAY_OF_MONTH, -30);
        String t = new SimpleDateFormat("yyyy-MM-dd").format(now.getTime());
        return t;
    }

    public static String getLastYearDate(){
        String ymd = sdf.format(new Date());
        String[] arr = ymd.split("-");
        int y = Integer.parseInt(arr[0]) - 1;
        return y + "-" + arr[1]  + "-" + arr[2];
    }


    public static List<String> getMonthBetween(String minDate, String maxDate) throws ParseException {
        ArrayList<String> result = new ArrayList<String>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");//格式化为年月

        Calendar min = Calendar.getInstance();
        Calendar max = Calendar.getInstance();

        min.setTime(sdf.parse(minDate));
        min.set(min.get(Calendar.YEAR), min.get(Calendar.MONTH), 1);

        max.setTime(sdf.parse(maxDate));
        max.set(max.get(Calendar.YEAR), max.get(Calendar.MONTH), 2);

        Calendar curr = min;
        while (curr.before(max)) {
            result.add(sdf.format(curr.getTime()));
            curr.add(Calendar.MONTH, 1);
        }

        return result;
    }


    public static String getValueByKey(List<KVStr> kvStrs, String key){
        String v = null;
        for(KVStr kvStr:kvStrs){
            if(kvStr.getK().equals(key)){
                v= kvStr.getV();
                break;
            }
        }

        return v;
    }

    public static String[] getDefaultTimeSection(){
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(d);

        String[] ymr = today.split("-");
        String year = ymr[0];
        //int lastYear = Integer.parseInt(year) - 1;
       // String lastDay = lastYear + "-" + ymr[1] + "-" + ymr[2];
        String lastDay = "2000-01-01";

        return new String[]{lastDay,today};

    }

    public static Set<String> getDeliminateSet(List<String> list){
        Set<String> set = new HashSet<>();
        for(String v:list){
            set.add(v);
        }

        return set;
    }

    public static Map<String, List<Score>> getSortedMapCodeAsKey(List<Score> scores){
        Map<String, List<Score>> map = new TreeMap<>();
        String code;
        List<Score> codeScores;
        for(Score score:scores){
            code = score.getCode();
            codeScores = map.get(code);
            if(codeScores == null){
                codeScores = new ArrayList<Score>();
                codeScores.add(score);
                map.put(code, codeScores);
            }else{
                codeScores.add(score);
            }
        }
        for (Map.Entry<String,  List<Score>> entry : map.entrySet()) {
            codeScores = entry.getValue();
            Collections.sort(codeScores);
        }

        return map;

    }


    public static List<ComprehensiveScore> ConvertToComprehenssiveScores(Map<String, List<Score>> map) {
        List<ComprehensiveScore> comprehensiveScores = new ArrayList<>();
        List<Score> codeScores;

        for (Map.Entry<String,  List<Score>> entry : map.entrySet()) {

            ComprehensiveScore c = new ComprehensiveScore();
            Float[] tests = c.getTests();
            Integer index = 0;
            codeScores = entry.getValue();
            for(Score score:codeScores){
                if(c.getCode() == null || c.getCode().length() == 0){
                    c.setCode(score.getCode());
                    c.setClasscode(score.getClasscode());
                }

                index = scoreNameMap.get(score.getTname());
                if(index != null){
                    tests[index] = score.getTscore();
                }

            }

            comprehensiveScores.add(c);


        }

        return comprehensiveScores;
    }

    public static void copyContentToComprehensiveScore(ComprehensiveScore_baseinfo comprehensiveScore_baseinfo, ComprehensiveScore comprehensiveScore) {
        System.out.println("--------------------------------------");
        System.out.println(comprehensiveScore_baseinfo );
        System.out.println(comprehensiveScore );
        System.out.println(comprehensiveScore_baseinfo.getCorporation() );

        comprehensiveScore.setCorporation(comprehensiveScore_baseinfo.getCorporation());
        comprehensiveScore.setSalary(comprehensiveScore.getSalary());

        comprehensiveScore.setDiploma(comprehensiveScore_baseinfo.getDiploma());
        comprehensiveScore.setEnery_employ(comprehensiveScore_baseinfo.getEnery_employ());
        comprehensiveScore.setGraduateTime(comprehensiveScore_baseinfo.getGraduateTime());
        comprehensiveScore.setPrefession(comprehensiveScore_baseinfo.getPrefession());

        comprehensiveScore.setType(comprehensiveScore_baseinfo.getType());
        comprehensiveScore.setName(comprehensiveScore_baseinfo.getName());

    }

    public static Map<String,String> convertListToMap(List<KVStr> kvStrs) {
        TreeMap<String,String> map = new TreeMap<>();
        if(kvStrs != null){
            for(KVStr kv:kvStrs){
                map.put(kv.getK(), kv.getV());
            }
        }
        return map;
    }

    public static boolean isExistCTName(List<SummaryTalk> summaryTalks, String ctname) {
        if(summaryTalks == null || summaryTalks.size() == 0){
            return false;
        }
        for(SummaryTalk s:summaryTalks){
            if(s.getCtname().equals(ctname)){
                return true;
            }
        }

        return false;
    }

    public static SummaryTalk getSummaryTalkByCTName(List<SummaryTalk> summaryTalks, String ctname) {
        if(summaryTalks == null || summaryTalks.size() == 0 || ctname == null || ctname.length() == 0){
            return null;
        }

        for(SummaryTalk s:summaryTalks){
            if(s.getCtname().equals(ctname)){
                return s;
            }
        }

        return null;
    }

    public static int getSuccessCount_wandan(List<SimpleTalkSummary> simpleTalkSummaries_success, String classcode, String month){
        if(simpleTalkSummaries_success == null || simpleTalkSummaries_success.size() == 0){
            return 0;
        }

        for(SimpleTalkSummary s:simpleTalkSummaries_success){
            if(s.getClasscode().equals(classcode) && s.getMonth().equals(month) && s.getTalkType().equals("退费挽单")){
                return s.getCount();
            }
        }

        return 0;
    }

    public static int getSuccessCount_koubei(List<SimpleTalkSummary> simpleTalkSummaries_success, String classcode, String month){
        if(simpleTalkSummaries_success == null || simpleTalkSummaries_success.size() == 0){
            return 0;
        }

        for(SimpleTalkSummary s:simpleTalkSummaries_success){
            if(s.getClasscode().equals(classcode) && s.getMonth().equals(month) && s.getTalkType().equals("口碑")){
                return s.getCount();
            }
        }

        return 0;
    }

    public static int getSuccessCount_yunwei(List<SimpleTalkSummary> simpleTalkSummaries_success, String classcode, String month){
        if(simpleTalkSummaries_success == null || simpleTalkSummaries_success.size() == 0){
            return 0;
        }

        for(SimpleTalkSummary s:simpleTalkSummaries_success){
            if(s.getClasscode().equals(classcode) && s.getMonth().equals(month) && s.getTalkType().equals("转运维")){
                return s.getCount();
            }
        }

        return 0;
    }

    public static float getAvgPeriods(List<KV> code_periods) {

        if(code_periods != null && code_periods.size() > 0){
            int count = 0;
            for(KV kv:code_periods){
                count = count + kv.getV();
            }
            return (1.0f*count)/code_periods.size();
        }

        return 0;
    }

    public static float getAvgInterviewTimes(Integer allcenter_interviewTimes, Integer allcenter_tNumbers) {
        if(allcenter_tNumbers == null || allcenter_tNumbers == 0){
            return 0;
        }

        return (1.0f*allcenter_interviewTimes)/allcenter_tNumbers;
    }

    public static float getAllCenterDevPercent(List<KV> center_devNumbers, List<KV> center_workNumbers) {
        int devNumbers = 0;
        int workNumbers = 0;
        for(KV kv:center_devNumbers){
            devNumbers = devNumbers + kv.getV();
        }

        for(KV kv:center_workNumbers){
            workNumbers = workNumbers + kv.getV();
        }

        if(workNumbers == 0){
            return 0;
        }

        return (1f*devNumbers)/workNumbers*100;
    }

    public static String getSubString(String str, int length){
        if(str.length() <= length){
            return str;
        }
        return str.substring(0,length);
    }

}

