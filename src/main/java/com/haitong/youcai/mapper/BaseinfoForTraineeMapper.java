package com.haitong.youcai.mapper;

import com.haitong.youcai.entity.BaseinfoForTrainee;
import com.haitong.youcai.entity.BaseinfoForTraineeExample;
import java.util.List;

public interface BaseinfoForTraineeMapper {
    int countByExample(BaseinfoForTraineeExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(BaseinfoForTrainee record);

    int insertSelective(BaseinfoForTrainee record);

    List<BaseinfoForTrainee> selectByExample(BaseinfoForTraineeExample example);

    BaseinfoForTrainee selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BaseinfoForTrainee record);

    int updateByPrimaryKey(BaseinfoForTrainee record);
}