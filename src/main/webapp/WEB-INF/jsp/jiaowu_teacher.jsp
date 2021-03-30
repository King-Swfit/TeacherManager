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

    <!-- Custom Fonts -->
    <link href="/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

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

    <script type="text/javascript">
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
            var startTime = (now.getFullYear() - 5)+"-"+(month)+"-"+(day) ;
            //完成赋值
            $('#startTime_q').val(startTime);
            $('#endTime_q').val(today);
            $('#startTime_u').val(startTime);
            $('#endTime_u').val(today);

            $('#date_create').val(today)


            $('.nav-tabs li').click(function(){
                var _id = $(this).attr('id');

                switch(_id){
                    case "q":
                        $.get(
                                "/jiaowu/teacherList",
                                function (teachers) {
                                    efreshQueryUI(teachers);
                                }
                        );
                        break;
                    case "c":
                        break;
                    case "u":
                        $.get(
                                "/jiaowu/teacherList",
                                function (teachers) {
                                    efreshQueryUI(teachers);
                                }
                        );
                        break;
                }
            });

        });
        
        function query() {
            var startTime = $('#startTime_q').val()
            var endTime = $('#endTime_q').val()
            var pid = $('#positions_query').val()
            var tid = $('#teachers_query').val()

            //保存到服务器
            $.post(
                    "/jiaowu/getTeacherByCondition",
                    {"startTime": startTime, "endTime": endTime, "pid":pid,"tid":tid},
                    function (teachers) {
                        efreshQueryUI(teachers)
                    }
            );
        }

        function query_u() {
            var startTime = $('#startTime_u').val()
            var endTime = $('#endTime_u').val()
            var pid = $('#positions_u').val()
            var tid = $('#teachers_u').val()

            //保存到服务器
            $.post(
                    "/jiaowu/getTeacherByCondition2",
                    {"startTime": startTime, "endTime": endTime, "pid":pid,"tid":tid},
                    function (data) {
                        refreshUpdateUI(data)
                    }
            );
        }

        function onCreate(){

            var tname = $('#tname_create').val()
            var gender = $('#gender_create').val()
            var age = $('#age_create').val()
            var tel = $('#tel_create').val()
            var email = $('#email_create').val()

            var directionId = $('#direction_create').val()
            var positionId = $('#position_create').val()

            var school = $('#scholl_create').val()
            var diploma = $('#diploma_create').val()
            var profession = $('#profession_create').val()
            var graduateDate = $('#graducateDate_create').val()

            var experience = $('#experience_create').val()
            var hireDate = $('#date_create').val()

            if(null == tname || 0 == tname.length || null == tel || 0 == tel.length || null == diploma || 0 == diploma.length){
                alert("请填写完信息!");
            }else{
                $.post(
                        "/jiaowu/new_teacher",
                        {"tname":tname, "gender":gender, "age":age, "tel":tel, "email":email, "directionId":directionId, "positionId":positionId,
                            "school":school, "diploma":diploma,"profession":profession, "graduateDate":graduateDate,
                            "experience":experience, "hireDate":hireDate,"state":"在职"
                        },
                        function (data) {
                            if(data == "success"){
                                alert("创建教师成功！");
                                $('#tname_create').val("")
                                $('#gender_create').val("男")
                                $('#age_create').val("")
                                $('#tel_create').val("")
                                $('#email_create').val("")

                                $('#direction_create').val()
                                $('#position_create').val()

                                $('#scholl_create').val("")
                                $('#profession_create').val("")
                                $('#graducateDate_create').attr("")

                                $('#experience_create').val("")
                            }else{
                                alert("创建教师失败！");
                            }

                        }
                );
            }

        }


        function onReset(){
            $('#tname_create').val("")
            $('#gender_create').val("男")
            $('#age_create').val("")
            $('#tel_create').val("")
            $('#email_create').val("")

            $('#direction_create').val()
            $('#position_create').val()

            $('#scholl_create').val("")
            $('#profession_create').val("")
            $('#graducateDate_create').attr("")

            $('#experience_create').val("")
        }

        function onEdit(tid){
            var eid = "#" + tid+"_tname"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_age"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_genders"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_positions"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_directions"
            $(eid).removeAttr("disabled");



            eid = "#" + tid+"_school"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_diplomas"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_profession"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_graduateDate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_experience"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_hiredate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_tel"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_email"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leavedate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leaveReason"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leaveReason"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_states"
            $(eid).removeAttr("disabled");

        }


        function onSave(tid){
            var eid = "#" + tid+"_tname"
            var tname = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_age"
            var age = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_genders"
            var gender = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_positions"
            var positionId = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_directions"
            var directionId = $(eid).val()
            $(eid).attr("disabled","disabled")



            eid = "#" + tid+"_school"
            var school = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_diplomas"
            var diploma = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_profession"
            var profession = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_graduateDate"
            var graduateDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_experience"
            var experience = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_hiredate"
            var hireDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_tel"
            var tel = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_email"
            var email = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_leavedate"
            var leaveDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_leaveReason"
            var leaveReason = $(eid).val()
            $(eid).attr("readonly",true)


            eid = "#" + tid+"_states"
            var state = $(eid).val()
            $(eid).attr("disabled","disabled")

            if(null == tname || 0 == tname.length || null == tel || 0 == tel.length || null == diploma || 0 == diploma.length){
                alert("请填写完信息!");
            }else {

                $.post(
                        "/jiaowu/update_teacher",
                        {
                            "tid":tid,
                            "tname": tname,
                            "age": age,
                            "gender": gender,
                            "directionId": directionId,
                            "positionId": positionId,
                            "tel": tel,
                            "email": email,

                            "school": school,
                            "diploma": diploma,
                            "profession": profession,
                            "graduateDate": graduateDate,

                            "experience": experience,
                            "hireDate": hireDate,
                            "state": state,
                            "leaveDate":leaveDate,
                            "leaveReason":leaveReason
                        },
                        function (data) {
                            alert(data);
                        }
                );
            }

        }

        function efreshQueryUI(teachers) {
            $("#query_tbody").empty();

            for (var i = 0; i < teachers.length; i++) {
                var teacher = teachers[i];
                var str = "<tr class='even gradeA'>";
                var index = i + 1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td>" + teacher.tname + "</td>";
                str = str + "<td>" + teacher.gender + "</td>";
                str = str + "<td>" + teacher.age + "</td>";
                str = str + "<td>" + teacher.direction.dname + "</td>";
                str = str + "<td>" + teacher.position.pname + "</td>";
                str = str + "<td>" + teacher.tel + "</td>";
                str = str + "<td>" + teacher.email + "</td>";
                str = str + "<td>" + teacher.school + "</td>";
                str = str + "<td>" + teacher.diploma + "</td>";
                str = str + "<td>" + teacher.profession + "</td>";
                if(teacher.graduateDate == null){
                    teacher.graduateDate = ""
                }
                str = str + "<td>" + teacher.graduateDate + "</td>";
                str = str + "<td>" + teacher.experience + "</td>";

                str = str + "<td>" + teacher.hireDate + "</td>";
                str = str + "<td>" + teacher.leaveDate + "</td>";
                str = str + "<td>" + teacher.leaveReason + "</td>";
                str = str + "</tr>";

                $("#query_tbody").append(str);
            }
        }

        function refreshUpdateUI(jsonObject){
            var positions = jsonObject.positions;
            var directions = jsonObject.directions;
            var teachers = jsonObject.teachers;
            $("#update_tbody").empty();

            for (var i = 0; i < teachers.length; i++) {
                var teacher = teachers[i];
                var str = "<tr class='even gradeA'>";
                var index = i + 1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td><input id='" + teacher.tid +"_tname'  value='" + teacher.tname +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid+ "_genders' class='form-control' disabled>";
                if(teacher.gender == '男'){
                    str = str + "<option value='男' selected='selected'>男</option> <option value='女'>女</option>";
                }else{
                    str = str + "<option value='男' >男</option> <option value='女' selected='selected'>女</option>";
                }

                str = str + "<td><input id='" + teacher.tid +"_age' value='" + teacher.age + "' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_directions' class='form-control' disabled>";
                for(var j = 0; j < directions.length; j++){
                    var direction = directions[j];
                    if(direction.did == teacher.direction.did){
                        str = str + "<option value='" + direction.did +"' selected='selected'>" + direction.dname + "</option>";
                    }else{
                        str = str + "<option value='" + direction.did +"'>" + direction.dname + "</option>";
                    }
                }

                str = str + "<td><select id='" + teacher.tid + "_positions' class='form-control' disabled>";
                for(var j = 0; j < positions.length; j++){
                    var position = positions[j];
                    if(position.pid == teacher.position.pid){
                        str = str + "<option value='" + position.pid +"' selected='selected'>" + position.pname + "</option>";
                    }else{
                        str = str + "<option value='" + position.pid +"'>" + position.pname + "</option>";
                    }
                }

                str = str + "<td><input id='" + teacher.tid + "_tel' value='" + teacher.tel +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_email' value='" + teacher.email +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_school' value='" + teacher.school +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_diplomas' class='form-control' disabled>";
                if('专科' == teacher.diploma){
                    str = str + "<option value='专科' selected='selected'>专科</option> <option value='本科'>本科</option> <option value='硕士'>硕士</option> <option value='博士'>博士</option>";
                }else if('本科' == teacher.diploma){
                    str = str + "<option value='专科'>专科</option> <option value='本科'  selected='selected'>本科</option> <option value='硕士'>硕士</option> <option value='博士'>博士</option>";
                }else if('硕士' == teacher.diploma){
                    str = str + "<option value='专科'>专科</option> <option value='本科'>本科</option> <option value='硕士'  selected='selected'>硕士</option> <option value='博士'>博士</option>";
                }else if('博士' == teacher.diploma){
                    str = str + "<option value='专科'>专科</option> <option value='本科'>本科</option> <option value='硕士'>硕士</option> <option value='博士' selected='selected'>博士</option>";
                }else{
                    str = str + "<option value='专科'>专科</option> <option value='本科'>本科</option> <option value='硕士'>硕士</option> <option value='博士'>博士</option>";
                }

                str = str + "<td><input id='" + teacher.tid + "_profession' value='" + teacher.profession +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_graduateDate' value='" + teacher.graduateDate +"' type='date' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_experience' value='" + teacher.experience +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_hiredate' value='" + teacher.hireDate +"' type='date' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_states' class='form-control' disabled>";
                if(teacher.state == '在职'){
                    str = str + "<option value='在职' selected='selected'>在职</option> <option value='离职'>离职</option>"
                }else if(teacher.state == '离职'){
                    str = str + "<option value='在职' >在职</option> <option value='离职' selected='selected'>离职</option>"
                }else{
                    str = str + "<option value='在职' >在职</option> <option value='离职' >离职</option>"
                }

                str = str + "<td><input id='" + teacher.tid + "_leavedate' value='" + teacher.leaveDate +"' type='date' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_leaveReason' value='" + teacher.leaveReason +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><button type='button' class='btn btn-default' onclick='onEdit(" + teacher.tid + ")'>编辑</button><button type='button' class='btn btn-default' style='margin-left: 20px' onclick='onSave(" + teacher.tid + ")'>保存</button></td>";

                $("#update_tbody").append(str);
            }
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
                    <h1 class="page-header">教员信息</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">

                        <div class="panel-body">
                            <!-- Nav tabs -->
                            <ul class="nav nav-tabs">
                                <li id="q" class="active"><a href="#query" data-toggle="tab">查询</a>
                                </li>
                                <li id="c"><a href="#create" data-toggle="tab">新增</a>
                                </li>
                                <li id="u"><a href="#update" data-toggle="tab">编辑</a>
                                </li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="margin-top: 30px">
                                <div class="tab-pane fade in active" id="query">
                                    <h4 style=" text-align:center;">教员信息查询</h4>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">开始时间:</td>
                                                            <td>
                                                                <input type="date" id="startTime_q" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                                            </td>
                                                            <td style="text-align:right;">结束时间:</td>
                                                            <td>
                                                                <input type="date" id="endTime_q" class = "form-control" placeholder = "结束时间" style="min-width: 150px">
                                                            </td>

                                                            <td style="text-align:right;">职位:</td>
                                                            <td>
                                                                <select type="select" id="positions_query" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="position" items="${requestScope.positions}" >
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">姓名:</td>
                                                            <td>
                                                                <select type="select" id="teachers_query" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="teacher" items="${requestScope.teachers}" >
                                                                        <option value="${teacher.tid}">${teacher.tname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">条件查询</button>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </div>

                                                <!-- /.panel-body -->
                                            </div>
                                            <!-- /.panel -->
                                        </div>

                                    </div>
                                    <!-- /.panel-heading -->
                                    <div class="row">
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>姓名</th>
                                                    <th>性别</th>
                                                    <th>年龄</th>
                                                    <th>方向</th>
                                                    <th>职位</th>
                                                    <th>手机号</th>
                                                    <th>邮箱</th>
                                                    <th>毕业院校</th>
                                                    <th>学历</th>
                                                    <th>专业</th>
                                                    <th>毕业时间</th>
                                                    <th>工作经验</th>
                                                    <th>入职时间</th>
                                                    <th>离职时间</th>
                                                    <th>离职原因</th>
                                                </tr>
                                                </thead>
                                                <tbody id="query_tbody">
                                                <c:forEach var="teacher" items="${requestScope.teachers}" begin="0" step="1" varStatus="i">
                                                    <tr>
                                                        <td>${i.index + 1}</td>
                                                        <td>${teacher.tname}</td>
                                                        <td>${teacher.gender}</td>
                                                        <td>${teacher.age}</td>

                                                        <td>${teacher.direction.dname}</td>
                                                        <td>${teacher.position.pname}</td>

                                                        <td>${teacher.tel}</td>
                                                        <td>${teacher.email}</td>
                                                        <td>${teacher.school}</td>
                                                        <td>${teacher.diploma}</td>
                                                        <td>${teacher.profession}</td>
                                                        <td>${teacher.graduateDate}</td>
                                                        <td>${teacher.experience}</td>
                                                        <td>${teacher.hireDate}</td>
                                                        <td>${teacher.leaveDate}</td>
                                                        <td>${teacher.leaveReason}</td>
                                                    </tr>
                                                </c:forEach>

                                                </tbody>
                                            </table>




                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="create" >
                                    <h4 style=" text-align:center;">添加教员信息</h4>

                                    <table class="table table-striped table-bordered table-hover">
                                        <tbody>
                                        <tr>
                                            <td>姓名</td>
                                            <td><input id="tname_create" class="form-control" placeholder="输入文字"></td>
                                            <td>性别</td>
                                            <td>
                                                <select id="gender_create" class="form-control">
                                                    <option value="男">男</option>
                                                    <option value="女">女</option>
                                                </select>
                                            </td>
                                            <td>年龄</td>
                                            <td>
                                                <input id="age_create" type="number" class="form-control" placeholder="请输入代表年龄的数字">
                                            </td>
                                            <td>手机号</td>
                                            <td><input id="tel_create" type="number" class="form-control" placeholder="请输入手机号的11位数字"></td>
                                        </tr>
                                        <tr>
                                            <td>邮箱</td>
                                            <td><input id="email_create" type="email" class="form-control" placeholder="请输入邮箱"></td>
                                            <td>教学方向</td>
                                            <td>
                                                <select id="direction_create" class="form-control">
                                                    <c:forEach var="direction" items="${requestScope.directions}">
                                                        <option value="${direction.did}">${direction.dname}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>职位</td>
                                            <td>
                                                <select id="position_create" class="form-control">
                                                    <c:forEach var="position" items="${requestScope.positions}">
                                                        <option value="${position.pid}">${position.pname}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>毕业院校</td>
                                            <td><input id="scholl_create" class="form-control" placeholder="输入文字"></td>
                                        </tr>
                                        <tr>
                                            <td>学历</td>
                                            <td>
                                                <select id="diploma_create" class="form-control">
                                                    <option value="专科">专科</option>
                                                    <option value="本科">本科</option>
                                                    <option value="硕士">硕士</option>
                                                    <option value="博士">博士</option>
                                                </select>
                                            </td>
                                            <td>
                                                专业
                                            </td>
                                            <td>
                                                <input  id="profession_create" class="form-control" placeholder="输入文字">
                                            </td>
                                            <td>毕业时间</td>
                                            <td><input id="graducateDate_create" type="date" class="form-control" placeholder="输入文字"></td>
                                            <td>工作经验</td>
                                            <td><input  id="experience_create" class="form-control" placeholder="输入文字"></td>
                                        </tr>
                                        <tr>
                                            <td>入职时间</td>
                                            <td><input id="date_create" type="date" class="form-control" ></td>
                                        </tr>

                                        </tbody>
                                    </table>
                                    <row>
                                        <div class="col-lg-12">
                                            <div class="col-lg-3" style="text-align:center;">
                                                <button  class="btn btn-default" onclick="onCreate()" style="min-width: 100px">提    交</button>
                                            </div>
                                            <div class="col-lg-3" style="text-align:center;">
                                                <button  class="btn btn-default" onclick="onReset()" style="min-width: 100px">重    置</button>
                                            </div>
                                        </div>
                                    </row>




                                </div>
                                <div class="tab-pane fade" id="update">
                                    <h4 style=" text-align:center;">教员信息编辑</h4>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">开始时间:</td>
                                                            <td>
                                                                <input type="date" id="startTime_u" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                                            </td>
                                                            <td style="text-align:right;">结束时间:</td>
                                                            <td>
                                                                <input type="date" id="endTime_u" class = "form-control" placeholder = "结束时间" style="min-width: 150px">
                                                            </td>

                                                            <td style="text-align:right;">职位:</td>
                                                            <td>
                                                                <select type="select" id="positions_u" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="position" items="${requestScope.positions}" >
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">姓名:</td>
                                                            <td>
                                                                <select type="select" id="teachers_u" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="teacher" items="${requestScope.teachers}" >
                                                                        <option value="${teacher.tid}">${teacher.tname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query_u()" style="min-width: 150px">条件查询</button>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </div>

                                                <!-- /.panel-body -->
                                            </div>
                                            <!-- /.panel -->
                                        </div>

                                    </div>
                                    <!-- /.panel-heading -->
                                    <div class="row">
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <div style="width:3000px;  overflow:scroll;">
                                                <table class="table table-striped table-bordered table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th width="50px">#</th>
                                                        <th width="120px">姓名</th>
                                                        <th width="100px">性别</th>
                                                        <th width="100px">年龄</th>
                                                        <th width="180px">方向</th>
                                                        <th width="200px">职位</th>
                                                        <th width="200px">手机号</th>
                                                        <th width="200px">邮箱</th>
                                                        <th width="200px">毕业院校</th>
                                                        <th width="100px">学历</th>
                                                        <th width="200px">专业</th>
                                                        <th width="200px">毕业时间</th>
                                                        <th width="100px">工作经验</th>
                                                        <th width="200px">入职时间</th>
                                                        <th width="100px">状态</th>
                                                        <th width="200px">离职时间</th>
                                                        <th width="400px">离职原因</th>
                                                        <th width="200px">操作</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="update_tbody">
                                                    <c:forEach var="teacher" items="${requestScope.teachers}" begin="0" step="1" varStatus="i">
                                                    <tr>
                                                        <td>${i.index + 1}</td>
                                                        <td><input id="${teacher.tid}_tname"  value="${teacher.tname}" readonly="true" class="form-control"/></td>
                                                        <td>
                                                            <select id="${teacher.tid}_genders" class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${teacher.gender=='男'}">
                                                                        <option value="男" selected="selected">男</option>
                                                                        <option value="女">女</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="男">男</option>
                                                                        <option value="女" selected="selected">女</option>
                                                                    </c:otherwise>
                                                                </c:choose>

                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_age"  value="${teacher.age}" readonly="true" class="form-control"/></td>
                                                        <td>
                                                        <select id="${teacher.tid}_directions" class="form-control" disabled>
                                                            <c:forEach var="direction" items="${requestScope.directions}" >
                                                                <c:choose>
                                                                    <c:when test="${direction.did == teacher.direction.did}">
                                                                        <option value="${direction.did}" selected="selected">${direction.dname}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${direction.did}" >${direction.dname}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </select>
                                                        </td>
                                                        <td>
                                                        <select id="${teacher.tid}_positions" class="form-control" disabled>
                                                            <c:forEach var="position" items="${requestScope.positions}" >
                                                                <c:choose>
                                                                    <c:when test="${position.pid == teacher.position.pid}">
                                                                        <option value="${position.pid}" selected="selected">${position.pname}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_tel"  value="${teacher.tel}" readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_email"  value="${teacher.email} " readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_school"  value="${teacher.school} " readonly="true" class="form-control"/></td>


                                                        <td>
                                                            <select id="${teacher.tid}_diplomas" class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${'专科' == teacher.diploma}">
                                                                        <option value="专科" selected="selected">专科</option>
                                                                        <option value="本科">本科</option>
                                                                        <option value="硕士">硕士</option>
                                                                        <option value="博士">博士</option>
                                                                    </c:when>
                                                                    <c:when test="${'本科' == teacher.diploma}">
                                                                        <option value="专科">专科</option>
                                                                        <option value="本科" selected="selected">本科</option>
                                                                        <option value="硕士">硕士</option>
                                                                        <option value="博士">博士</option>
                                                                    </c:when>
                                                                    <c:when test="${'硕士' == teacher.diploma}">
                                                                        <option value="专科">专科</option>
                                                                        <option value="本科">本科</option>
                                                                        <option value="硕士" selected="selected">硕士</option>
                                                                        <option value="博士">博士</option>
                                                                    </c:when>
                                                                    <c:when test="${'博士' == teacher.diploma}">
                                                                        <option value="专科">专科</option>
                                                                        <option value="本科">本科</option>
                                                                        <option value="硕士">硕士</option>
                                                                        <option value="博士" selected="selected">博士</option>
                                                                    </c:when>

                                                                </c:choose>

                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_profession"  value="${teacher.profession} " readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_graduateDate"  value="${teacher.graduateDate} " type="date" readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_experience"  value="${teacher.experience} " readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_hiredate"  value="${teacher.hireDate} " type="date" readonly="true" class="form-control"/></td>
                                                        <td>
                                                            <select id="${teacher.tid}_states"   class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${classTeacher.state=='在职'}">
                                                                        <option value="在职" selected="selected">在职</option>
                                                                        <option value="离职">离职</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="在职">在职</option>
                                                                        <option value="离职" selected="selected">离职</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_leavedate"  value="${teacher.leaveDate} " type="date" readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_leaveReason"  value="${teacher.leaveReason} "  readonly="true" class="form-control"/></td>


                                                        <td><button type="button" class="btn btn-default" onclick="onEdit(${teacher.tid})">编辑</button><button type="button" class="btn btn-default" style="margin-left: 20px" onclick="onSave(${teacher.tid})">保存</button></td>
                                                    </tr>
                                                    </c:forEach>
                                                    </tbody>

                                                </table>
                                                </div>




                                            </div>
                                            <!-- /.table-responsive -->
                                        </div>
                                        <!-- /.panel-body -->
                                    </div>

                                </div>
                            </div>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>

            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->



</body>

</html>
