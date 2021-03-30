package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.Corporiation;
import com.haitong.youcai.entity.CorporiationConnectRecoed;
import com.haitong.youcai.entity.InterviewItem;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2019/5/22.
 */
@Repository
public interface CorporiationMapper {
    List<Corporiation> getSimpleCorporiationInfos();

    int saveNewCorporiation(Corporiation corporiation);

    int updateCorporiationInfo(Corporiation corporiation);

    int saveNewConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed);

    int updateConnectRecord(CorporiationConnectRecoed corporiationConnectRecoed);

    List<CorporiationConnectRecoed> listConnectRecords(int cneterId, int classtecherId, String startTime, String endTime);

    Corporiation getCorporiationByCid(int cid);

    int updateAddConnectionInfo(Corporiation corporiation);

    List<CorporiationConnectRecoed> listConnectRecords2(String classteacherId, String month);

    List<CorporiationConnectRecoed> listConnectRecords3(String classteacherId, String month);

    List<InterviewItem> getInterviewsByCondition(String isEnroll, String startTime, String endTime);

    Corporiation selectCorporiationByCorporiationName(String corporiation);

    List<Corporiation> selectCorporiationByTime(String startTime, String endTime);

    List<Corporiation> getCorporiationsByName(String name);

    List<String> getCoporiationsByMasterId(int ctid);

    List<String> getCoporiationsNoMaster();

    int updateCoporiationMasterId(String cname, int ctid);

    int updateCoporiationNotMaster(String cname);

    List<Corporiation> getSimpleCorporiationsByCtid(int ctid);

    List<Corporiation> listCorporiationsByName(String name);

    List<Corporiation> getCorporiationsByCtid(int ctid);

    int saveNewCorporiation2(Corporiation corporiation);

    Corporiation getCorporiationsByWholeName(String s);
}
