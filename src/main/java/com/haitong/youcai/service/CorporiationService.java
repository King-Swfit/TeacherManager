package com.haitong.youcai.service;

import com.haitong.youcai.entity.Corporiation;
import com.haitong.youcai.entity.CorporiationConnectRecoed;
import com.haitong.youcai.entity.InterviewItem;
import com.haitong.youcai.mapper.CorporiationMapper;
import com.haitong.youcai.utils.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2019/5/22.
 */
@Service
public class CorporiationService {
    @Autowired
    private CorporiationMapper corporiationMapper;
    public List<Corporiation> getSimpleCorporiationInfos() {
        return corporiationMapper.getSimpleCorporiationInfos();
    }

    public int saveNewCorporiation(Corporiation corporiation) {
        return corporiationMapper.saveNewCorporiation(corporiation);
    }

    public List<Corporiation> listCorporiationBseInos(int numbers, String isEnroll, String startTime, String endTime) {

        List<Corporiation> corporiations = new ArrayList<>();
        if(numbers > 0){
            List<InterviewItem> interviewItems = corporiationMapper.getInterviewsByCondition(isEnroll, startTime, endTime);
            if(interviewItems.size() > 0){
                for(InterviewItem it:interviewItems){
                    if(it.getCn() >= numbers){
                        Corporiation corporiation = corporiationMapper.selectCorporiationByCorporiationName(it.getCorporiation());
                        if(corporiation != null){
                            corporiation.setStuNumbers(it.getCn());
                            corporiations.add(corporiation);
                        }

                    }
                }
            }

        }

        if(numbers == 0 && isEnroll.equals("全部")){
            List<Corporiation> corporiations2 = corporiationMapper.selectCorporiationByTime(startTime, endTime );
            corporiations.addAll(corporiations2);
        }
        return corporiations;
    }

    public int updateCorporiationInfo(Corporiation corporiation) {
        return corporiationMapper.updateCorporiationInfo(corporiation);
    }

    public int saveNewConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed) {
        return corporiationMapper.saveNewConnectRecord(corporiationConnectRecoed);
    }

    public int updateConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed) {
        return corporiationMapper.updateConnectRecord(corporiationConnectRecoed);
    }

    public List<CorporiationConnectRecoed> listConnectRecords(int cneterId, int classtecherId, String startTime, String endTime) {
        return corporiationMapper.listConnectRecords(cneterId, classtecherId, startTime, endTime);
    }

    public Corporiation getCorporiationByCid(int cid) {
        return corporiationMapper.getCorporiationByCid(cid);
    }

    public int updateAddConnectionInfo(Corporiation corporiation) {
        return corporiationMapper.updateAddConnectionInfo(corporiation);
    }

    public List<CorporiationConnectRecoed> listConnectRecords2(String classteacherId, String month) {
        return corporiationMapper.listConnectRecords2(classteacherId, month);
    }

    public List<CorporiationConnectRecoed> listConnectRecords3(String classteacherId, String month) {
        return corporiationMapper.listConnectRecords3(classteacherId, month);
    }

    public List<Corporiation> getCorporiationsByName(String name) {
        return corporiationMapper.getCorporiationsByName(name);
    }

    public List<String> getCoporiationsByMasterId(int ctid) {
        return corporiationMapper.getCoporiationsByMasterId(ctid);
    }

    public List<String> getCoporiationsNoMaster() {
        return corporiationMapper.getCoporiationsNoMaster();
    }

    public int updateCoporiationMasterId(String cname, int ctid) {
        return corporiationMapper.updateCoporiationMasterId(cname, ctid);
    }

    public int updateCoporiationNotMaster(String cname) {
        return corporiationMapper.updateCoporiationNotMaster(cname);
    }

    public List<Corporiation> getSimpleCorporiationsByCtid(int ctid) {
        return corporiationMapper.getSimpleCorporiationsByCtid(ctid);
    }

    public List<Corporiation> listCorporiationsByName(String name) {
        return corporiationMapper.listCorporiationsByName(name);
    }

    public List<Corporiation> getCorporiationsByCtid(int ctid) {
        return corporiationMapper.getCorporiationsByCtid(ctid);
    }

    public int insertCorporiations(List<List<String>> datas, int tid) {
        int result = 0,r=0;
        String s = null;
        for(int i = 1; i < datas.size(); i++){
            List<String> data = datas.get(i);
            if(data != null && data.size() == 11 && data.get(1) != null && data.get(4) != null && data.get(10) != null){
                s = data.get(1);

                //查找该企业？若不在再添加
                if(s == null){
                    continue;
                }
                Corporiation corporiationResult = corporiationMapper.getCorporiationsByWholeName(s);
                if(corporiationResult != null){
                    continue;
                }

                Corporiation corporiation = new Corporiation();
                corporiation.setCname(Tool.getSubString(s, 90));
                s = data.get(2);
                if(s == null){
                    s = "";
                }
                corporiation.setCaddress(Tool.getSubString(s, 140));



                s = data.get(3);
                if(s == null){
                    s = "";
                }
                corporiation.setContectName(Tool.getSubString(s, 45));

                s = data.get(4);
                if(s == null){
                    s = "";
                }
                corporiation.setContactPosition(Tool.getSubString(s, 45));

                s = data.get(5);
                if(s == null){
                    s = "";
                }
                corporiation.setHrmanager(Tool.getSubString(s, 45));

                s = data.get(6);
                if(s == null){
                    s = "";
                }
                corporiation.setTel(Tool.getSubString(s, 45));

                s = data.get(7);
                if(s == null){
                    s = "";
                }
                corporiation.setPhone(Tool.getSubString(s, 45));

                s = data.get(8);
                if(s == null){
                    s = "";
                }
                corporiation.setQq(Tool.getSubString(s, 45));

                s = data.get(9);
                if(s == null){
                    s = "";
                }
                corporiation.setWeichat(Tool.getSubString(s, 45));

                s = data.get(10);
                if(s == null){
                    s = "";
                }
                corporiation.setDescribee(Tool.getSubString(s, 490));

                corporiation.setIsQiyeQQ("否");
                corporiation.setIsEnroll("否");
                corporiation.setTimee(Tool.getCurrentDate());
                corporiation.setTid(tid);
                r = corporiationMapper.saveNewCorporiation2(corporiation);
                result = result + r;
            }


        }

        return result;

    }


}
