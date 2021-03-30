package com.haitong.youcai.entity;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class BaseinfoForTraineeExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public BaseinfoForTraineeExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    public boolean isDistinct() {
        return distinct;
    }

    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        protected void addCriterionForJDBCDate(String condition, Date value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            addCriterion(condition, new java.sql.Date(value.getTime()), property);
        }

        protected void addCriterionForJDBCDate(String condition, List<Date> values, String property) {
            if (values == null || values.size() == 0) {
                throw new RuntimeException("Value list for " + property + " cannot be null or empty");
            }
            List<java.sql.Date> dateList = new ArrayList<java.sql.Date>();
            Iterator<Date> iter = values.iterator();
            while (iter.hasNext()) {
                dateList.add(new java.sql.Date(iter.next().getTime()));
            }
            addCriterion(condition, dateList, property);
        }

        protected void addCriterionForJDBCDate(String condition, Date value1, Date value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            addCriterion(condition, new java.sql.Date(value1.getTime()), new java.sql.Date(value2.getTime()), property);
        }

        public Criteria andIdIsNull() {
            addCriterion("id is null");
            return (Criteria) this;
        }

        public Criteria andIdIsNotNull() {
            addCriterion("id is not null");
            return (Criteria) this;
        }

        public Criteria andIdEqualTo(Integer value) {
            addCriterion("id =", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotEqualTo(Integer value) {
            addCriterion("id <>", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThan(Integer value) {
            addCriterion("id >", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThanOrEqualTo(Integer value) {
            addCriterion("id >=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThan(Integer value) {
            addCriterion("id <", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThanOrEqualTo(Integer value) {
            addCriterion("id <=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdIn(List<Integer> values) {
            addCriterion("id in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotIn(List<Integer> values) {
            addCriterion("id not in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdBetween(Integer value1, Integer value2) {
            addCriterion("id between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotBetween(Integer value1, Integer value2) {
            addCriterion("id not between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andCodeIsNull() {
            addCriterion("code is null");
            return (Criteria) this;
        }

        public Criteria andCodeIsNotNull() {
            addCriterion("code is not null");
            return (Criteria) this;
        }

        public Criteria andCodeEqualTo(String value) {
            addCriterion("code =", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeNotEqualTo(String value) {
            addCriterion("code <>", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeGreaterThan(String value) {
            addCriterion("code >", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeGreaterThanOrEqualTo(String value) {
            addCriterion("code >=", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeLessThan(String value) {
            addCriterion("code <", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeLessThanOrEqualTo(String value) {
            addCriterion("code <=", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeLike(String value) {
            addCriterion("code like", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeNotLike(String value) {
            addCriterion("code not like", value, "code");
            return (Criteria) this;
        }

        public Criteria andCodeIn(List<String> values) {
            addCriterion("code in", values, "code");
            return (Criteria) this;
        }

        public Criteria andCodeNotIn(List<String> values) {
            addCriterion("code not in", values, "code");
            return (Criteria) this;
        }

        public Criteria andCodeBetween(String value1, String value2) {
            addCriterion("code between", value1, value2, "code");
            return (Criteria) this;
        }

        public Criteria andCodeNotBetween(String value1, String value2) {
            addCriterion("code not between", value1, value2, "code");
            return (Criteria) this;
        }

        public Criteria andNameIsNull() {
            addCriterion("name is null");
            return (Criteria) this;
        }

        public Criteria andNameIsNotNull() {
            addCriterion("name is not null");
            return (Criteria) this;
        }

        public Criteria andNameEqualTo(String value) {
            addCriterion("name =", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameNotEqualTo(String value) {
            addCriterion("name <>", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameGreaterThan(String value) {
            addCriterion("name >", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameGreaterThanOrEqualTo(String value) {
            addCriterion("name >=", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameLessThan(String value) {
            addCriterion("name <", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameLessThanOrEqualTo(String value) {
            addCriterion("name <=", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameLike(String value) {
            addCriterion("name like", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameNotLike(String value) {
            addCriterion("name not like", value, "name");
            return (Criteria) this;
        }

        public Criteria andNameIn(List<String> values) {
            addCriterion("name in", values, "name");
            return (Criteria) this;
        }

        public Criteria andNameNotIn(List<String> values) {
            addCriterion("name not in", values, "name");
            return (Criteria) this;
        }

        public Criteria andNameBetween(String value1, String value2) {
            addCriterion("name between", value1, value2, "name");
            return (Criteria) this;
        }

        public Criteria andNameNotBetween(String value1, String value2) {
            addCriterion("name not between", value1, value2, "name");
            return (Criteria) this;
        }

        public Criteria andGenderIsNull() {
            addCriterion("gender is null");
            return (Criteria) this;
        }

        public Criteria andGenderIsNotNull() {
            addCriterion("gender is not null");
            return (Criteria) this;
        }

        public Criteria andGenderEqualTo(String value) {
            addCriterion("gender =", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderNotEqualTo(String value) {
            addCriterion("gender <>", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderGreaterThan(String value) {
            addCriterion("gender >", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderGreaterThanOrEqualTo(String value) {
            addCriterion("gender >=", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderLessThan(String value) {
            addCriterion("gender <", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderLessThanOrEqualTo(String value) {
            addCriterion("gender <=", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderLike(String value) {
            addCriterion("gender like", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderNotLike(String value) {
            addCriterion("gender not like", value, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderIn(List<String> values) {
            addCriterion("gender in", values, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderNotIn(List<String> values) {
            addCriterion("gender not in", values, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderBetween(String value1, String value2) {
            addCriterion("gender between", value1, value2, "gender");
            return (Criteria) this;
        }

        public Criteria andGenderNotBetween(String value1, String value2) {
            addCriterion("gender not between", value1, value2, "gender");
            return (Criteria) this;
        }

        public Criteria andDirectionidIsNull() {
            addCriterion("directionId is null");
            return (Criteria) this;
        }

        public Criteria andDirectionidIsNotNull() {
            addCriterion("directionId is not null");
            return (Criteria) this;
        }

        public Criteria andDirectionidEqualTo(Integer value) {
            addCriterion("directionId =", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidNotEqualTo(Integer value) {
            addCriterion("directionId <>", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidGreaterThan(Integer value) {
            addCriterion("directionId >", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidGreaterThanOrEqualTo(Integer value) {
            addCriterion("directionId >=", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidLessThan(Integer value) {
            addCriterion("directionId <", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidLessThanOrEqualTo(Integer value) {
            addCriterion("directionId <=", value, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidIn(List<Integer> values) {
            addCriterion("directionId in", values, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidNotIn(List<Integer> values) {
            addCriterion("directionId not in", values, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidBetween(Integer value1, Integer value2) {
            addCriterion("directionId between", value1, value2, "directionid");
            return (Criteria) this;
        }

        public Criteria andDirectionidNotBetween(Integer value1, Integer value2) {
            addCriterion("directionId not between", value1, value2, "directionid");
            return (Criteria) this;
        }

        public Criteria andCardIsNull() {
            addCriterion("card is null");
            return (Criteria) this;
        }

        public Criteria andCardIsNotNull() {
            addCriterion("card is not null");
            return (Criteria) this;
        }

        public Criteria andCardEqualTo(String value) {
            addCriterion("card =", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardNotEqualTo(String value) {
            addCriterion("card <>", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardGreaterThan(String value) {
            addCriterion("card >", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardGreaterThanOrEqualTo(String value) {
            addCriterion("card >=", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardLessThan(String value) {
            addCriterion("card <", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardLessThanOrEqualTo(String value) {
            addCriterion("card <=", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardLike(String value) {
            addCriterion("card like", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardNotLike(String value) {
            addCriterion("card not like", value, "card");
            return (Criteria) this;
        }

        public Criteria andCardIn(List<String> values) {
            addCriterion("card in", values, "card");
            return (Criteria) this;
        }

        public Criteria andCardNotIn(List<String> values) {
            addCriterion("card not in", values, "card");
            return (Criteria) this;
        }

        public Criteria andCardBetween(String value1, String value2) {
            addCriterion("card between", value1, value2, "card");
            return (Criteria) this;
        }

        public Criteria andCardNotBetween(String value1, String value2) {
            addCriterion("card not between", value1, value2, "card");
            return (Criteria) this;
        }

        public Criteria andClassidIsNull() {
            addCriterion("classId is null");
            return (Criteria) this;
        }

        public Criteria andClassidIsNotNull() {
            addCriterion("classId is not null");
            return (Criteria) this;
        }

        public Criteria andClassidEqualTo(Integer value) {
            addCriterion("classId =", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidNotEqualTo(Integer value) {
            addCriterion("classId <>", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidGreaterThan(Integer value) {
            addCriterion("classId >", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidGreaterThanOrEqualTo(Integer value) {
            addCriterion("classId >=", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidLessThan(Integer value) {
            addCriterion("classId <", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidLessThanOrEqualTo(Integer value) {
            addCriterion("classId <=", value, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidIn(List<Integer> values) {
            addCriterion("classId in", values, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidNotIn(List<Integer> values) {
            addCriterion("classId not in", values, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidBetween(Integer value1, Integer value2) {
            addCriterion("classId between", value1, value2, "classid");
            return (Criteria) this;
        }

        public Criteria andClassidNotBetween(Integer value1, Integer value2) {
            addCriterion("classId not between", value1, value2, "classid");
            return (Criteria) this;
        }

        public Criteria andDiplomaIsNull() {
            addCriterion("diploma is null");
            return (Criteria) this;
        }

        public Criteria andDiplomaIsNotNull() {
            addCriterion("diploma is not null");
            return (Criteria) this;
        }

        public Criteria andDiplomaEqualTo(String value) {
            addCriterion("diploma =", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaNotEqualTo(String value) {
            addCriterion("diploma <>", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaGreaterThan(String value) {
            addCriterion("diploma >", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaGreaterThanOrEqualTo(String value) {
            addCriterion("diploma >=", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaLessThan(String value) {
            addCriterion("diploma <", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaLessThanOrEqualTo(String value) {
            addCriterion("diploma <=", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaLike(String value) {
            addCriterion("diploma like", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaNotLike(String value) {
            addCriterion("diploma not like", value, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaIn(List<String> values) {
            addCriterion("diploma in", values, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaNotIn(List<String> values) {
            addCriterion("diploma not in", values, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaBetween(String value1, String value2) {
            addCriterion("diploma between", value1, value2, "diploma");
            return (Criteria) this;
        }

        public Criteria andDiplomaNotBetween(String value1, String value2) {
            addCriterion("diploma not between", value1, value2, "diploma");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeIsNull() {
            addCriterion("graducateTime is null");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeIsNotNull() {
            addCriterion("graducateTime is not null");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeEqualTo(Date value) {
            addCriterionForJDBCDate("graducateTime =", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeNotEqualTo(Date value) {
            addCriterionForJDBCDate("graducateTime <>", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeGreaterThan(Date value) {
            addCriterionForJDBCDate("graducateTime >", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeGreaterThanOrEqualTo(Date value) {
            addCriterionForJDBCDate("graducateTime >=", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeLessThan(Date value) {
            addCriterionForJDBCDate("graducateTime <", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeLessThanOrEqualTo(Date value) {
            addCriterionForJDBCDate("graducateTime <=", value, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeIn(List<Date> values) {
            addCriterionForJDBCDate("graducateTime in", values, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeNotIn(List<Date> values) {
            addCriterionForJDBCDate("graducateTime not in", values, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeBetween(Date value1, Date value2) {
            addCriterionForJDBCDate("graducateTime between", value1, value2, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andGraducatetimeNotBetween(Date value1, Date value2) {
            addCriterionForJDBCDate("graducateTime not between", value1, value2, "graducatetime");
            return (Criteria) this;
        }

        public Criteria andProfessionIsNull() {
            addCriterion("profession is null");
            return (Criteria) this;
        }

        public Criteria andProfessionIsNotNull() {
            addCriterion("profession is not null");
            return (Criteria) this;
        }

        public Criteria andProfessionEqualTo(String value) {
            addCriterion("profession =", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionNotEqualTo(String value) {
            addCriterion("profession <>", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionGreaterThan(String value) {
            addCriterion("profession >", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionGreaterThanOrEqualTo(String value) {
            addCriterion("profession >=", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionLessThan(String value) {
            addCriterion("profession <", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionLessThanOrEqualTo(String value) {
            addCriterion("profession <=", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionLike(String value) {
            addCriterion("profession like", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionNotLike(String value) {
            addCriterion("profession not like", value, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionIn(List<String> values) {
            addCriterion("profession in", values, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionNotIn(List<String> values) {
            addCriterion("profession not in", values, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionBetween(String value1, String value2) {
            addCriterion("profession between", value1, value2, "profession");
            return (Criteria) this;
        }

        public Criteria andProfessionNotBetween(String value1, String value2) {
            addCriterion("profession not between", value1, value2, "profession");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollIsNull() {
            addCriterion("graduate_scholl is null");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollIsNotNull() {
            addCriterion("graduate_scholl is not null");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollEqualTo(Integer value) {
            addCriterion("graduate_scholl =", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollNotEqualTo(Integer value) {
            addCriterion("graduate_scholl <>", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollGreaterThan(Integer value) {
            addCriterion("graduate_scholl >", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollGreaterThanOrEqualTo(Integer value) {
            addCriterion("graduate_scholl >=", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollLessThan(Integer value) {
            addCriterion("graduate_scholl <", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollLessThanOrEqualTo(Integer value) {
            addCriterion("graduate_scholl <=", value, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollIn(List<Integer> values) {
            addCriterion("graduate_scholl in", values, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollNotIn(List<Integer> values) {
            addCriterion("graduate_scholl not in", values, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollBetween(Integer value1, Integer value2) {
            addCriterion("graduate_scholl between", value1, value2, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andGraduateSchollNotBetween(Integer value1, Integer value2) {
            addCriterion("graduate_scholl not between", value1, value2, "graduateScholl");
            return (Criteria) this;
        }

        public Criteria andTelIsNull() {
            addCriterion("tel is null");
            return (Criteria) this;
        }

        public Criteria andTelIsNotNull() {
            addCriterion("tel is not null");
            return (Criteria) this;
        }

        public Criteria andTelEqualTo(String value) {
            addCriterion("tel =", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelNotEqualTo(String value) {
            addCriterion("tel <>", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelGreaterThan(String value) {
            addCriterion("tel >", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelGreaterThanOrEqualTo(String value) {
            addCriterion("tel >=", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelLessThan(String value) {
            addCriterion("tel <", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelLessThanOrEqualTo(String value) {
            addCriterion("tel <=", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelLike(String value) {
            addCriterion("tel like", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelNotLike(String value) {
            addCriterion("tel not like", value, "tel");
            return (Criteria) this;
        }

        public Criteria andTelIn(List<String> values) {
            addCriterion("tel in", values, "tel");
            return (Criteria) this;
        }

        public Criteria andTelNotIn(List<String> values) {
            addCriterion("tel not in", values, "tel");
            return (Criteria) this;
        }

        public Criteria andTelBetween(String value1, String value2) {
            addCriterion("tel between", value1, value2, "tel");
            return (Criteria) this;
        }

        public Criteria andTelNotBetween(String value1, String value2) {
            addCriterion("tel not between", value1, value2, "tel");
            return (Criteria) this;
        }

        public Criteria andEmailIsNull() {
            addCriterion("email is null");
            return (Criteria) this;
        }

        public Criteria andEmailIsNotNull() {
            addCriterion("email is not null");
            return (Criteria) this;
        }

        public Criteria andEmailEqualTo(String value) {
            addCriterion("email =", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailNotEqualTo(String value) {
            addCriterion("email <>", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailGreaterThan(String value) {
            addCriterion("email >", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailGreaterThanOrEqualTo(String value) {
            addCriterion("email >=", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailLessThan(String value) {
            addCriterion("email <", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailLessThanOrEqualTo(String value) {
            addCriterion("email <=", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailLike(String value) {
            addCriterion("email like", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailNotLike(String value) {
            addCriterion("email not like", value, "email");
            return (Criteria) this;
        }

        public Criteria andEmailIn(List<String> values) {
            addCriterion("email in", values, "email");
            return (Criteria) this;
        }

        public Criteria andEmailNotIn(List<String> values) {
            addCriterion("email not in", values, "email");
            return (Criteria) this;
        }

        public Criteria andEmailBetween(String value1, String value2) {
            addCriterion("email between", value1, value2, "email");
            return (Criteria) this;
        }

        public Criteria andEmailNotBetween(String value1, String value2) {
            addCriterion("email not between", value1, value2, "email");
            return (Criteria) this;
        }

        public Criteria andContactIsNull() {
            addCriterion("contact is null");
            return (Criteria) this;
        }

        public Criteria andContactIsNotNull() {
            addCriterion("contact is not null");
            return (Criteria) this;
        }

        public Criteria andContactEqualTo(String value) {
            addCriterion("contact =", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactNotEqualTo(String value) {
            addCriterion("contact <>", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactGreaterThan(String value) {
            addCriterion("contact >", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactGreaterThanOrEqualTo(String value) {
            addCriterion("contact >=", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactLessThan(String value) {
            addCriterion("contact <", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactLessThanOrEqualTo(String value) {
            addCriterion("contact <=", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactLike(String value) {
            addCriterion("contact like", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactNotLike(String value) {
            addCriterion("contact not like", value, "contact");
            return (Criteria) this;
        }

        public Criteria andContactIn(List<String> values) {
            addCriterion("contact in", values, "contact");
            return (Criteria) this;
        }

        public Criteria andContactNotIn(List<String> values) {
            addCriterion("contact not in", values, "contact");
            return (Criteria) this;
        }

        public Criteria andContactBetween(String value1, String value2) {
            addCriterion("contact between", value1, value2, "contact");
            return (Criteria) this;
        }

        public Criteria andContactNotBetween(String value1, String value2) {
            addCriterion("contact not between", value1, value2, "contact");
            return (Criteria) this;
        }

        public Criteria andContactTelIsNull() {
            addCriterion("contact_tel is null");
            return (Criteria) this;
        }

        public Criteria andContactTelIsNotNull() {
            addCriterion("contact_tel is not null");
            return (Criteria) this;
        }

        public Criteria andContactTelEqualTo(String value) {
            addCriterion("contact_tel =", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelNotEqualTo(String value) {
            addCriterion("contact_tel <>", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelGreaterThan(String value) {
            addCriterion("contact_tel >", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelGreaterThanOrEqualTo(String value) {
            addCriterion("contact_tel >=", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelLessThan(String value) {
            addCriterion("contact_tel <", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelLessThanOrEqualTo(String value) {
            addCriterion("contact_tel <=", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelLike(String value) {
            addCriterion("contact_tel like", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelNotLike(String value) {
            addCriterion("contact_tel not like", value, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelIn(List<String> values) {
            addCriterion("contact_tel in", values, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelNotIn(List<String> values) {
            addCriterion("contact_tel not in", values, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelBetween(String value1, String value2) {
            addCriterion("contact_tel between", value1, value2, "contactTel");
            return (Criteria) this;
        }

        public Criteria andContactTelNotBetween(String value1, String value2) {
            addCriterion("contact_tel not between", value1, value2, "contactTel");
            return (Criteria) this;
        }

        public Criteria andLendWayIsNull() {
            addCriterion("lend_way is null");
            return (Criteria) this;
        }

        public Criteria andLendWayIsNotNull() {
            addCriterion("lend_way is not null");
            return (Criteria) this;
        }

        public Criteria andLendWayEqualTo(String value) {
            addCriterion("lend_way =", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayNotEqualTo(String value) {
            addCriterion("lend_way <>", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayGreaterThan(String value) {
            addCriterion("lend_way >", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayGreaterThanOrEqualTo(String value) {
            addCriterion("lend_way >=", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayLessThan(String value) {
            addCriterion("lend_way <", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayLessThanOrEqualTo(String value) {
            addCriterion("lend_way <=", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayLike(String value) {
            addCriterion("lend_way like", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayNotLike(String value) {
            addCriterion("lend_way not like", value, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayIn(List<String> values) {
            addCriterion("lend_way in", values, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayNotIn(List<String> values) {
            addCriterion("lend_way not in", values, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayBetween(String value1, String value2) {
            addCriterion("lend_way between", value1, value2, "lendWay");
            return (Criteria) this;
        }

        public Criteria andLendWayNotBetween(String value1, String value2) {
            addCriterion("lend_way not between", value1, value2, "lendWay");
            return (Criteria) this;
        }

        public Criteria andPayproofIsNull() {
            addCriterion("payproof is null");
            return (Criteria) this;
        }

        public Criteria andPayproofIsNotNull() {
            addCriterion("payproof is not null");
            return (Criteria) this;
        }

        public Criteria andPayproofEqualTo(String value) {
            addCriterion("payproof =", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofNotEqualTo(String value) {
            addCriterion("payproof <>", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofGreaterThan(String value) {
            addCriterion("payproof >", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofGreaterThanOrEqualTo(String value) {
            addCriterion("payproof >=", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofLessThan(String value) {
            addCriterion("payproof <", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofLessThanOrEqualTo(String value) {
            addCriterion("payproof <=", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofLike(String value) {
            addCriterion("payproof like", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofNotLike(String value) {
            addCriterion("payproof not like", value, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofIn(List<String> values) {
            addCriterion("payproof in", values, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofNotIn(List<String> values) {
            addCriterion("payproof not in", values, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofBetween(String value1, String value2) {
            addCriterion("payproof between", value1, value2, "payproof");
            return (Criteria) this;
        }

        public Criteria andPayproofNotBetween(String value1, String value2) {
            addCriterion("payproof not between", value1, value2, "payproof");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgIsNull() {
            addCriterion("diploma_img is null");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgIsNotNull() {
            addCriterion("diploma_img is not null");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgEqualTo(String value) {
            addCriterion("diploma_img =", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgNotEqualTo(String value) {
            addCriterion("diploma_img <>", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgGreaterThan(String value) {
            addCriterion("diploma_img >", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgGreaterThanOrEqualTo(String value) {
            addCriterion("diploma_img >=", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgLessThan(String value) {
            addCriterion("diploma_img <", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgLessThanOrEqualTo(String value) {
            addCriterion("diploma_img <=", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgLike(String value) {
            addCriterion("diploma_img like", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgNotLike(String value) {
            addCriterion("diploma_img not like", value, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgIn(List<String> values) {
            addCriterion("diploma_img in", values, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgNotIn(List<String> values) {
            addCriterion("diploma_img not in", values, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgBetween(String value1, String value2) {
            addCriterion("diploma_img between", value1, value2, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andDiplomaImgNotBetween(String value1, String value2) {
            addCriterion("diploma_img not between", value1, value2, "diplomaImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgIsNull() {
            addCriterion("employ_img is null");
            return (Criteria) this;
        }

        public Criteria andEmployImgIsNotNull() {
            addCriterion("employ_img is not null");
            return (Criteria) this;
        }

        public Criteria andEmployImgEqualTo(String value) {
            addCriterion("employ_img =", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgNotEqualTo(String value) {
            addCriterion("employ_img <>", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgGreaterThan(String value) {
            addCriterion("employ_img >", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgGreaterThanOrEqualTo(String value) {
            addCriterion("employ_img >=", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgLessThan(String value) {
            addCriterion("employ_img <", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgLessThanOrEqualTo(String value) {
            addCriterion("employ_img <=", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgLike(String value) {
            addCriterion("employ_img like", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgNotLike(String value) {
            addCriterion("employ_img not like", value, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgIn(List<String> values) {
            addCriterion("employ_img in", values, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgNotIn(List<String> values) {
            addCriterion("employ_img not in", values, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgBetween(String value1, String value2) {
            addCriterion("employ_img between", value1, value2, "employImg");
            return (Criteria) this;
        }

        public Criteria andEmployImgNotBetween(String value1, String value2) {
            addCriterion("employ_img not between", value1, value2, "employImg");
            return (Criteria) this;
        }

        public Criteria andCardImg1IsNull() {
            addCriterion("card_img_1 is null");
            return (Criteria) this;
        }

        public Criteria andCardImg1IsNotNull() {
            addCriterion("card_img_1 is not null");
            return (Criteria) this;
        }

        public Criteria andCardImg1EqualTo(String value) {
            addCriterion("card_img_1 =", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1NotEqualTo(String value) {
            addCriterion("card_img_1 <>", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1GreaterThan(String value) {
            addCriterion("card_img_1 >", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1GreaterThanOrEqualTo(String value) {
            addCriterion("card_img_1 >=", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1LessThan(String value) {
            addCriterion("card_img_1 <", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1LessThanOrEqualTo(String value) {
            addCriterion("card_img_1 <=", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1Like(String value) {
            addCriterion("card_img_1 like", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1NotLike(String value) {
            addCriterion("card_img_1 not like", value, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1In(List<String> values) {
            addCriterion("card_img_1 in", values, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1NotIn(List<String> values) {
            addCriterion("card_img_1 not in", values, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1Between(String value1, String value2) {
            addCriterion("card_img_1 between", value1, value2, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg1NotBetween(String value1, String value2) {
            addCriterion("card_img_1 not between", value1, value2, "cardImg1");
            return (Criteria) this;
        }

        public Criteria andCardImg2IsNull() {
            addCriterion("card_img_2 is null");
            return (Criteria) this;
        }

        public Criteria andCardImg2IsNotNull() {
            addCriterion("card_img_2 is not null");
            return (Criteria) this;
        }

        public Criteria andCardImg2EqualTo(String value) {
            addCriterion("card_img_2 =", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2NotEqualTo(String value) {
            addCriterion("card_img_2 <>", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2GreaterThan(String value) {
            addCriterion("card_img_2 >", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2GreaterThanOrEqualTo(String value) {
            addCriterion("card_img_2 >=", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2LessThan(String value) {
            addCriterion("card_img_2 <", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2LessThanOrEqualTo(String value) {
            addCriterion("card_img_2 <=", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2Like(String value) {
            addCriterion("card_img_2 like", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2NotLike(String value) {
            addCriterion("card_img_2 not like", value, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2In(List<String> values) {
            addCriterion("card_img_2 in", values, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2NotIn(List<String> values) {
            addCriterion("card_img_2 not in", values, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2Between(String value1, String value2) {
            addCriterion("card_img_2 between", value1, value2, "cardImg2");
            return (Criteria) this;
        }

        public Criteria andCardImg2NotBetween(String value1, String value2) {
            addCriterion("card_img_2 not between", value1, value2, "cardImg2");
            return (Criteria) this;
        }
    }

    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}