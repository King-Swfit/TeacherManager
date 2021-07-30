<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>TeachManager v0.1</title>

    <!-- Bootstrap Core CSS -->
    <link href="/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="/css/custom.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="/vendor/morrisjs/morris.css" rel="stylesheet">

    <style type="text/css">
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }
    </style>

    <!-- Custom Fonts -->
    <link href="/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script src="/jquery/jquery-1.10.2.min.js"></script>

    <script type="text/javascript">
        var rowIndex = -1
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime ="2000-01-01"

            //完成赋值


        })

        function selectTrainee() {
            var info = $("#userinfo").find("option:selected").text();
            if(info != null && info.length > 0)
                $("#showTraineeModal").modal("hide")
            var arr = info.split("-");
            var code = arr[0]
            var name = arr[1]
            var dname = arr[2]
            var classcode = arr[3]

            queryBaseInfo(code,classcode)
            showDetail_talk(code,name)
            showDetail_score(code,name)
            queryAttence(code)
            interviewDetail(code)


        }

        function mohuquery() {
            var name = $('#name_search').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/class/mohuQueryByName",
                    {"name":name},
                    function (trainees) {
                        $("#userinfo").empty()
                        if(trainees != null){
                            var length = trainees.length
                            var str = ""
                            for(var i = 0; i < length; i++){
                                //加载用户信息
                                var info = trainees[i].code + "-" + trainees[i].name + "-" + trainees[i].dname + "-" + trainees[i].classcode + "-" + trainees[i].graduateSchool
                                str = str + "<option value='" + trainees[i].code + "'>" + info + "</option>"

                            }
                            $("#userinfo").append(str)
                            $("#showTraineeModal").modal()
                        }
                    }
            );
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //基本情况
        function queryBaseInfo(code,classcode) {

            $.post(
                    "/class/getBaseInfoForTraineeByCode",
                    {"code":code,"classcode":classcode},
                    function (baseinfoForTrainee) {
                        if(baseinfoForTrainee != null){
                            $("#tbody_trainee").empty()

                            var str = "<tr>"

                            str = str + "<td>" + baseinfoForTrainee.code + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.name + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.gender + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.card + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.classcode + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.ctname + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.dname + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.cname + "</td>"
                            if(baseinfoForTrainee.state == null){
                                baseinfoForTrainee.state = "未知"
                            }
                            str = str + "<td>" + baseinfoForTrainee.state + "</td>"

                            str = str + "<td>" + baseinfoForTrainee.diploma + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.profession + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.graduateSchool + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.graducateTime + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.tel + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.email + "</td>"

                            str = str + "<td>" + baseinfoForTrainee.contact + "</td>"
                            str = str + "<td>" + baseinfoForTrainee.contactTel + "</td>"

                            str = str + "</tr>"
                            $("#tbody_trainee").append(str)

                        }

                    }
            );



        }


        //访谈详情
        function showDetail_talk(code,name) {
            $.post(
                    "/procedure/getTalkDetailByCode",
                    {"code":code},
                    function (talks) {
                        var length = talks.length
                        $('#tbody_talkDetail').empty()
                        var str = ""
                        for(var i = 0; i < length; i++){
                            str = ""
                            var talk = talks[i]
                            str = str + "<tr>"
                            str = str + "<td>" + talk.tid + "</td>"
                            str = str + "<td>" + talk.code + "</td>"
                            str = str + "<td>" + name + "</td>"
                            str = str + "<td>" + talk.learnState + "</td>"
                            str = str + "<td>" + talk.ttime + "</td>"
                            str = str + "<td>" + talk.talkType + "</td>"
                            str = str + "<td>" + talk.tcontent + "</td>"
                            str = str + "<td>" + talk.result + "</td>"
                            str = str + "</tr>"

                            $('#tbody_talkDetail').append(str)
                        }



                    }
            );
        }

        //考试成绩
        function showDetail_score(code,name) {
            $.post(
                    "/procedure/getScoreDetailByCode",
                    {"code":code},
                    function (scores) {
                        var length = scores.length
                        $('#tbody_examDetail').empty()
                        var str = ""
                        for(var i = 0; i < length; i++){
                            str = ""
                            var score = scores[i]
                            str = str + "<tr>"
                            str = str + "<td>" + score.tid + "</td>"
                            str = str + "<td>" + score.code + "</td>"
                            str = str + "<td>" + name + "</td>"
                            str = str + "<td>" + score.ttime + "</td>"
                            str = str + "<td>" + score.tname + "</td>"
                            str = str + "<td>" + score.tscore + "</td>"
                            str = str + "<td>" + score.detail + "</td>"
                            str = str + "</tr>"

                            $('#tbody_examDetail').append(str)
                        }



                    }
            );
        }

        //考勤
        function queryAttence(code) {
            $.post(
                    "/procedure/getAttenceDaysByCode",
                    {"code":code},
                    function (processAttenceDays) {
                        showAttenceDays(processAttenceDays)
                    }
            );
        }
        function showAttenceDays(processAttenceDays){
            if(null != processAttenceDays){
                var length = processAttenceDays.length
                $('#tbody_days').empty()
                for(var i = 0; i < length; i++){
//
                    var processAttenceDay = processAttenceDays[i]

                    var str = "<tr>"
                    var index = i+1
                    str = str + "<td>" + index + "</td>"
                    str = str + "<td>" + processAttenceDay.code + "</td>"
                    str = str + "<td>" + processAttenceDay.name  + "</td>"
                    str = str + "<td>" + processAttenceDay.classcode + "</td>"
                    str = str + "<td>" + processAttenceDay.datee + "</td>"
                    str = str + "<td>" + processAttenceDay.week + "</td>"
                    str = str + "<td>" + processAttenceDay.turn + "</td>"
                    if(processAttenceDay.clickTime_1 == null){
                        processAttenceDay.clickTime_1 = ""
                    }
                    str = str + "<td>" + processAttenceDay.clickTime_1 + "</td>"
                    if(processAttenceDay.clickResult_1 == null){
                        processAttenceDay.clickResult_1 = ""
                    }
                    str = str + "<td>" + processAttenceDay.clickResult_1 + "</td>"
                    if(processAttenceDay.clickTime_2 == null){
                        processAttenceDay.clickTime_2 = ""
                    }
                    str = str + "<td>" + processAttenceDay.clickTime_2 + "</td>"
                    if(processAttenceDay.clickResult_2 == null){
                        processAttenceDay.clickResult_2 = ""
                    }
                    str = str + "<td>" + processAttenceDay.clickResult_2 + "</td>"
                    if(processAttenceDay.workTime == null){
                        processAttenceDay.workTime = ""
                    }
                    str = str + "<td>" + processAttenceDay.workTime + "</td>"

                    if(processAttenceDay.earlyLefts == null){
                        processAttenceDay.earlyLefts = ""
                    }
                    str = str + "<td>" + processAttenceDay.earlyLefts + "</td>"

                    if(processAttenceDay.earlyLeftTime == null){
                        processAttenceDay.earlyLeftTime = ""
                    }
                    str = str + "<td>" + processAttenceDay.earlyLeftTime + "</td>"

                    if(processAttenceDay.free_thing == null){
                        processAttenceDay.free_thing = ""
                    }
                    str = str + "<td>" + processAttenceDay.free_thing + "</td>"

                    if(processAttenceDay.free_ill == null){
                        processAttenceDay.free_ill = ""
                    }
                    str = str + "<td>" + processAttenceDay.free_ill + "</td>"

                    if(processAttenceDay.lates == null){
                        processAttenceDay.lates = ""
                    }
                    str = str + "<td>" + processAttenceDay.lates + "</td>"

                    if(processAttenceDay.lateTime == null){
                        processAttenceDay.lateTime = ""
                    }
                    str = str + "<td>" + processAttenceDay.lateTime + "</td>"

                    if(processAttenceDay.lacks_1 == null){
                        processAttenceDay.lacks_1 = ""
                    }
                    str = str + "<td>" + processAttenceDay.lacks_1 + "</td>"

                    if(processAttenceDay.lacks_2 == null){
                        processAttenceDay.lacks_2 = ""
                    }
                    str = str + "<td>" + processAttenceDay.lacks_2 + "</td>"

                    if(processAttenceDay.absents == null){
                        processAttenceDay.absents = ""
                    }
                    str = str + "<td>" + processAttenceDay.absents + "</td>"


                    str = str + "</tr>"

                    $('#tbody_days').append(str)

                }
            }
        }

        //就业详情
        function interviewDetail(code) {

            $.post(
                    "/employ/listProcessEmployInterviewRecordByCode",
                    {"code":code},
                    function (processEmployInterviewRecords) {
                        showInterviewDetails(processEmployInterviewRecords)
                    }
            );
        }
        function showInterviewDetails(processEmployInterviewRecords) {
            if (null != processEmployInterviewRecords) {

                $('#tbody_interviews_detail').empty()
                var length = processEmployInterviewRecords.length
                for (var i = 0; i < length; i++) {
                    str = "<tr>"
                    str = str + "<td>" + processEmployInterviewRecords[i].peiid + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].code + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].name + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].classcode + "</td>"

                    str = str + "<td>" + processEmployInterviewRecords[i].datetimee + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].corporiation + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].position + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].salary + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].result + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].realSalary + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].fuli + "</td>"

                    if(processEmployInterviewRecords[i].result=="成功"){
                        if(processEmployInterviewRecords[i].employProof != null && processEmployInterviewRecords[i].employProof.length > 0){
                            str = str + "<td><a href='javascript:void(0)' onclick='employProof(\" " + processEmployInterviewRecords[i].code + "\")'>点击查看</a></td>"
                        }else{
                            str = str + "<td><a href='javascript:void(0)' onclick='uploadEmployProof(\" " + processEmployInterviewRecords[i].code + "\")'>上传就业依据</a></td>"
                        }

                    }else{
                        str = str + "<td>无</td>"
                    }


                    str = str + "</tr>"

                    $('#tbody_interviews_detail').append(str)
                }

            } else {
                $('#tbody_interviews_detail').empty()
            }
        }

        function show() {
//            var s = $("#attenceTable").attr("display")
//            if(s=="none"){
//                $("#attenceTable").attr("display","block")
//                $("#attence").text("显示内容")
//            }else{
//                $("#attenceTable").attr("display", "none")
//                $("#attence").text("隐藏内容")
//            }

        }


    </script>

</head>

<body>



    <div id="wrapper">
        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <a class="navbar-brand" href="/page">TeachManager v0.1</a>
            </div>
            <div class="nav navbar-top-links navbar-right" style="margin: 10px">
                当前用户:<sec:authentication property="name"/>
            </div>
            <!-- /.navbar-header -->


            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">

                        <li>
                            <a href="#"><i class="fa fa-sitemap fa-fw"></i> 班级管理<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/class/new">新建班级</a>
                                </li>
                                <li>
                                    <a href="/class/baseInfo">班级概况</a>
                                </li>
                                <li>
                                    <a href="/class/trainee">班级学员</a>
                                </li>
                                <li>
                                    <a href="/class/activity">班级活动</a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-cubes fa-fw"></i> 学习过程管理<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/procedure/talkwork">学员访谈</a>
                                </li>
                                <li>
                                    <a href="/procedure/score">学员成绩</a>
                                </li>
                                <li>
                                    <a href="/procedure/attence">学员出勤</a>
                                </li>
                            </ul>
                            <!-- /.nav-second-level -->
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-rocket fa-fw"></i> 就业过程管理<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/employ/dynamicData">动态就业数据</a>
                                </li>

                                <li>
                                    <a href="/employ/summary">就业统计</a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> 企业信息管理<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/corporiate/connectRecord">企业联系记录</a>
                                </li>
                                <li>
                                    <a href="/corporiate/corporationBaseInfo">企业基础信息</a>
                                </li>
                                <li>
                                    <a href="/corporiate/assignCorporation">企业分配操作</a>
                                </li>
                                <li>
                                    <a href="/corporiate/manageCorporation">企业管理操作</a>
                                </li>
                                <li>
                                    <a href="/corporiate/manageCorporation">企业管理操作</a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-th fa-fw"></i> 班主任工作<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/work/summary">工作统计</a>
                                </li>
                            </ul>
                            <!-- /.nav-second-level -->
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-gears fa-fw"></i> 教务工作<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/jiaowu/xueji">学籍管理</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/score">毕业成绩</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/traineeInfo">学员信息查询</a>
                                </li>

                            </ul>
                            <!-- /.nav-second-level -->
                        </li>

                        <li>
                            <a href="#"><i class="fa  fa-empire fa-fw"></i> 结构<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="/jiaowu/center">教学中心</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/direction">课程方向</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/course">培训课程</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/teacher">教员</a>
                                </li>
                                <li>
                                    <a href="/jiaowu/classteacher">班主任</a>
                                </li>

                            </ul>
                            <!-- /.nav-second-level -->
                        </li>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">学员信息查询</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="col-lg-12" style="background: #dddddd">
                            <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                <tr>
                                    <td style="text-align:left;">1、请输入您要查询的学员名(支持模糊查询)</td>
                                    <td>
                                        <input  id="name_search" class = "form-control" placeholder = "学员名字/学号" style="min-width: 150px;display: inline">
                                    </td>
                                    <td><button type="button" class="btn btn-primary"  onclick="mohuquery()" style="min-width: 150px;display: inline">模糊查询</button></td>

                                </tr>
                                <tr>

                                    <td style="text-align: left">2、请选择您要查询的具体用户</td>
                                    <td><select id="userinfo" class="form-control" style="display: inline"></select></td>
                                    <td><button type="button"  class="btn btn-primary" onclick="selectTrainee()" style="min-width: 150px;display: inline">去查询</button></td>
                                </tr>
                            </table>
                        </div>

                    </div>
                </div>

            </div>

            <div class="row " >
                <div class="col-lg-12">
                    <div >
                        <h4 class="page-header">基本信息</h4>
                        <table class="table table table-striped table-bordered table-hover" >
                            <thead>
                            <tr >
                                <th width="150px">学员学号</th>
                                <th width="150px">姓名</th>
                                <th width="100px">性别</th>
                                <th width="150px">身份证号码</th>
                                <th width="150px">班级编号</th>
                                <th width="200px">班主任</th>

                                <th width="150px">学习方向</th>
                                <th width="150px">教学中心</th>

                                <th width="150px">学籍状态</th>
                                <th width="150px">学历</th>
                                <th width="200px">专业</th>
                                <th width="200px">毕业学校</th>
                                <th width="200px">毕业年份</th>
                                <th width="200px">联系电话</th>
                                <th width="200px">常用邮箱</th>
                                <th width="100px">紧急联系人</th>
                                <th width="200px">紧急联系人电话</th>


                            </tr>
                            </thead>
                            <tbody id="tbody_trainee">

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <div >
                        <h4 class="page-header" >访谈信息</h4>
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>id</th>
                                <th>学号</th>
                                <th>姓名</th>
                                <th>学习状态</th>
                                <th>访谈时间</th>
                                <th>访谈类型</th>
                                <th>访谈内容</th>
                                <th>访谈结果</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_talkDetail"></tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <div >
                        <h4 class="page-header">考试成绩</h4>
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>id</th>
                                <th>学号</th>
                                <th>姓名</th>
                                <th>考试时间</th>
                                <th>学习阶段</th>
                                <th>考试成绩</th>
                                <th>成绩详情</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_examDetail">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-lg-12">
                    <div >
                        <h4 class="page-header">就业推荐</h4>
                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                            <thead>

                            <th>id</th>
                            <%--<th>编辑</th>--%>
                            <th>学号</th>
                            <th>姓名</th>

                            <th>班级</th>
                            <th>面试时间</th>
                            <th>面试公司</th>
                            <th>面试岗位</th>
                            <th>面试类型</th>
                            <th>预计薪资</th>
                            <th>面试结果</th>
                            <th>实际薪资</th>
                            <th>福利</th>
                            <th>就业凭证</th>

                            </thead>
                            <tbody id="tbody_interviews_detail">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div >
                        <h4 class="page-header" >考勤信息</h4>
                        <%--<a href="javascript:void(0);" id="attence" onclick="show()" style="margin-right: 50px;">隐藏内容</a>--%>

                        <table class="table table-striped table-bordered table-hover" id="attenceTable" >
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>学员编号</th>
                                <th>学员姓名</th>
                                <th>班级编号</th>
                                <th>考勤日期</th>
                                <th>星期</th>
                                <th>班次</th>
                                <th>上班打卡</th>
                                <th>上班打卡结果</th>
                                <th>下班打卡</th>
                                <th>下班打卡结果</th>
                                <th>工作时长</th>
                                <th>早退次数</th>
                                <th>早退时长</th>
                                <th>事假时间</th>
                                <th>病假时间</th>

                                <th>迟到次数</th>
                                <th>迟到时长</th>
                                <th>上班缺卡次数</th>
                                <th>下班缺卡次数</th>
                                <th>旷工天数</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_days" >
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Morris Charts JavaScript -->
    <script src="/vendor/raphael/raphael.min.js"></script>
    <script src="/vendor/morrisjs/morris.min.js"></script>
    <script src="/data/morris-data.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/dist/js/sb-admin-2.js"></script>

</body>

</html>
