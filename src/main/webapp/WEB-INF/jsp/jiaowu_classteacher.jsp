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
    <script src="/jquery/jquery-1.10.2.min.js"></script>

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
            startTime="2000-01-01"
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
                                "/jiaowu/classteacherList",
                                function (classTeachers) {
                                    refreshQueryUI(classTeachers);
                                }
                        );
                        break;
                    case "c":
                        break;
                    case "u":
                        $.get(
                                "/jiaowu/classteachers2",
                                function (data) {
                                    refreshUpdateUI(data.classTeachers, data.centers);
                                }
                        );
                        break;
                }
            });


        })

        function query() {
            var startTime = $('#startTime_q').val()
            var endTime = $('#endTime_q').val()
            var cid = $('#centers_q').val()
            var ctid = $('#classTeachers_q').val()

            //保存到服务器
            $.post(
                    "/jiaowu/getClassteacherByCondition",
                    {"startTime": startTime, "endTime": endTime, "cid":cid,"ctid":ctid},
                    function (classteachers) {
                        refreshQueryUI(classteachers)
                    }
            );
        }

        function query_u() {
            var startTime = $('#startTime_u').val()
            var endTime = $('#endTime_u').val()
            var cid = $('#centers_update').val()
            var ctid = $('#classTeachers_update').val()

            //保存到服务器
            $.post(
                    "/jiaowu/getClassteacherByCondition2",
                    {"startTime": startTime, "endTime": endTime, "cid":cid,"ctid":ctid},
                    function (data) {
                        refreshUpdateUI(data.classTeachers, data.centers)
                    }
            );
        }

        function onCreate() {
            var ctname = $('#ctname_create').val();
            var gender = $('#gender_create').val();
            var tel = $('#tel_create').val();
            var email = $('#email_create').val();
            var centerId = $('#centers_create').val();
            var createTime = $('#date_create').val();

            if(centerId == null){
                centerId = -1
            }
            if(null == ctname || 0 == ctname.length || null == tel || 0 == tel.length ){
                alert("请填写完信息!");
            }else{
                $.post(
                        "/jiaowu/new_classteacher",
                        {"ctname":ctname, "gender":gender, "tel":tel, "email":email, "centerId":centerId, "createTime":createTime},
                        function (data) {
                            alert(data);

                            $('#ctname_create').val("");
                            $('#gender_create').val("男");
                            $('#tel_create').val("");
                            $('#email_create').val("");
                        }
                );
            }

        }

        function onReset() {
            $('#ctname_create').val("");
            $('#gender_create').val("男");
            $('#tel_create').val("");
            $('#email_create').val("");

        }

        function onEdit(ctid){
            var eid = "#" + ctid+"_ctname"
            var ctname = $(eid).attr("readonly",false)

            eid = "#" + ctid+"_tel"
            var tel = $(eid).attr("readonly",false)

            eid = "#" + ctid+"_email"
            var email = $(eid).attr("readonly",false)

            eid = "#" + ctid+"_leavedate"
            var leavedate = $(eid).attr("readonly",false)

            eid = "#" + ctid+"_leaveReason"
            var _leaveReason = $(eid).attr("readonly",false)

        }

        function onSave(ctid){
            var eid = "#" + ctid+"_ctname"
            var ctname = $(eid).val();

            eid = "#" + ctid+"_tel"
            var tel = $(eid).val();

            eid = "#" + ctid+"_email"
            var email = $(eid).val();


            eid = "#" + ctid+"_leavedate"
            var leavedate = $(eid).val();

            eid = "#" + ctid+"_leaveReason"
            var leaveReason = $(eid).val();


            eid = "#" + ctid+"_genders"
            var gender = $(eid).find("option:selected").text();

            eid = "#" + ctid+"_centers"
            var centerId = $(eid).val();

            eid = "#" + ctid+"_states"
            var state = $(eid).find("option:selected").text();


            $.post(
                    "/jiaowu/update_classteacher",
                    {"ctid":ctid, "ctname":ctname,  "tel":tel, "email":email, "leavedate":leavedate, "leaveReason":leaveReason, "centerId":centerId, "state":state, "gender":gender,},
                    function (data) {
                        alert(data);
                        var eid = "#" + ctid+"_ctname"
                        var ctname = $(eid).attr("readonly",true)

                        eid = "#" + ctid+"_tel"
                        var tel = $(eid).attr("readonly",true)

                        eid = "#" + ctid+"_email"
                        var email = $(eid).attr("readonly",true)

                        eid = "#" + ctid+"_leavedate"
                        var leavedate = $(eid).attr("readonly",true)

                        eid = "#" + ctid+"_leaveReason"
                        var _leaveReason = $(eid).attr("readonly",true)
                    }
            );
        }


        function refreshQueryUI(classTeachers){
            $("#query_tbody").empty();

            for (var i = 0; i < classTeachers.length; i++) {
                var classTeacher = classTeachers[i];
                var str = "<tr class='even gradeA'>";
                var index = i+1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td>" + classTeacher.ctname + "</td>";
                str = str + "<td>" + classTeacher.gender + "</td>";
                str = str + "<td>" + classTeacher.tel + "</td>";
                str = str + "<td>" + classTeacher.email + "</td>";
                str = str + "<td>" + classTeacher.center.cname + "</td>";
                str = str + "<td>" + classTeacher.hiredate + "</td>";

                if(classTeacher.state == null){
                    classTeacher.state = ""
                }
                str = str + "<td>" + classTeacher.state + "</td>";

                if(classTeacher.leavedate == null){
                    classTeacher.leavedate = ""
                }
                str = str + "<td>" + classTeacher.leavedate + "</td>";
                if(classTeacher.leaveReason == null){
                    classTeacher.leaveReason = ""
                }
                str = str + "<td>" + classTeacher.leaveReason + "</td>";
                str = str + "</tr>";

                $("#query_tbody").append(str);

            }
        }

        function refreshUpdateUI(classTeachers, centers){
            $("#update_tbody").empty();

            for (var i = 0; i < classTeachers.length; i++) {
                var classTeacher = classTeachers[i];

                var str = "<tr class='even gradeA'>";
                var index = i+1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td><input id='" + classTeacher.ctid + "_ctname'  value='" +classTeacher.ctname +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id=" + classTeacher.ctid + "_genders' class='form-control' readonly='true'>" ;
                if(classTeacher.gender=="男"){
                    str = str + "<option value='0' selected='selected'>男</option> <option value='1'>女</option>"
                }else{
                    str = str + "<option value='0'>男</option> <option value='1'  selected='selected'>女</option>"
                }
                str = str + "</select> </td>";

                str = str +"<td><input id='"+classTeacher.ctid+"_tel' value='" +classTeacher.tel +"' readonly='true' class='form-control'/></td>";
                str = str +"<td><input id='"+classTeacher.ctid+"_email' value='" +classTeacher.email+"' readonly='true' class='form-control'/></td>";

                str = str + "<td> <select id='" +classTeacher.ctid + "_centers' class='form-control' readonly='true'> ";
                for (var j = 0; j < centers.length; j++) {
                    var center = centers[j];
                    str = str + "<option value='" +center.cid +"'>"+center.cname + "</option>";
                }
                str = str + "</select> </td>";

                str = str + "<td>"+classTeacher.hiredate+"</td>";

                str = str + "<td> <select id='"+classTeacher.ctid+"_states' class='form-control' readonly='true'>";
                if(classTeacher.state=="在职"){
                    str = str + "<option value='0' selected='selected'>在职</option> <option value='1'>离职</option>"
                }else{
                    str = str + "<option value='0'>在职</option> <option value='1'  selected='selected'>离职</option>"
                }
                str = str + "</select> </td>";

                str = str + "<td><input id='" + classTeacher.ctid +"_leavedate' type='date'  value='" + classTeacher.leavedate + "' readonly='true' class='form-control'/></td>";
                if(classTeacher.leaveReason == null){
                    classTeacher.leaveReason = ""
                }
                str = str + "<td><input id='" + classTeacher.ctid +"_leaveReason' value='" + classTeacher.leaveReason + "' readonly='true' class='form-control'/></td>";

                str = str + "<td><button type='button' class='btn btn-default' onclick='onEdit(" + classTeacher.ctid + ")'>编辑</button><button type='button' class='btn btn-default' style='margin-left: 20px' onclick=onSave(" +classTeacher.ctid + ")>保存</button></td>";


                str = str + "</tr>";
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
                    <h1 class="page-header">班主任</h1>
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
                                <li id="q" class="active"><a href="#query" data-toggle="tab">查询</a></li>
                                <li id="c"><a href="#create" data-toggle="tab">新增</a></li>
                                <li id="u"><a href="#update" data-toggle="tab">编辑</a></li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="margin-top: 30px">
                                <div class="tab-pane fade in active" id="query">
                                    <h4 style=" text-align:center;">班主任查询</h4>

                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">开始时间:</td>
                                                            <td>
                                                                <input type="date" id="startTime_q" class = "form-control" placeholder = "开始时间" style="min-width: 150px;">
                                                            </td>
                                                            <td style="text-align:right;">结束时间:</td>
                                                            <td>
                                                                <input type="date" id="endTime_q" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                                            </td>

                                                            <td style="text-align:right;">所属中心:</td>
                                                            <td>
                                                                <select id="centers_q" class="form-control" style="min-width: 150px;">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="center" items="${requestScope.centers}">
                                                                        <option value="${center.cid}">${center.cname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">姓名:</td>
                                                            <td>
                                                                <select id="classTeachers_q" class="form-control" style="min-width: 150px;">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="classTeacher" items="${requestScope.classTeachers}">
                                                                        <option value="${classTeacher.ctid}">${classTeacher.ctname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query()" style="margin-left:80px;min-width: 150px;">条件查询</button>
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
                                                    <th>手机号</th>
                                                    <th>邮箱</th>
                                                    <th>所属中心</th>
                                                    <th>入职时间</th>
                                                    <th>状态</th>
                                                    <th>离职时间</th>
                                                    <th>离职原因</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tbody id="query_tbody">
                                                    <c:forEach var="classTeacher" items="${requestScope.classTeachers}" begin="0" step="1" varStatus="i">
                                                        <tr>
                                                            <td>${i.index + 1}</td>
                                                            <td>${classTeacher.ctname}</td>
                                                            <td>${classTeacher.gender}</td>
                                                            <td>${classTeacher.tel}</td>
                                                            <td>${classTeacher.email}</td>
                                                            <td>${classTeacher.center.cname}</td>
                                                            <td>${classTeacher.hiredate}</td>
                                                            <td>${classTeacher.state}</td>
                                                            <td>${classTeacher.leavedate}</td>
                                                            <td>${classTeacher.leaveReason}</td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>

                                                </tbody>
                                            </table>

                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="create" >
                                    <h4 style=" text-align:center;">添加班主任信息</h4>


                                        <div class="form-group">
                                            <label>姓名</label>
                                            <input id="ctname_create" class="form-control" placeholder="输入文字">
                                        </div>
                                        <div class="form-group">
                                            <label>性别</label>
                                            <select id="gender_create" class="form-control">
                                                <option value="男">男</option>
                                                <option value="女">女</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>手机号</label>
                                            <input id="tel_create"  class="form-control" placeholder="输入文字">
                                        </div>
                                        <div class="form-group">
                                            <label>邮箱</label>
                                            <input id="email_create" type="email" class="form-control" placeholder="输入文字">
                                        </div>
                                        <div class="form-group">
                                            <label>所属中心</label>
                                            <select id="centers_create" class="form-control">
                                                <c:forEach var="center" items="${requestScope.centers}">
                                                    <option value="${center.cid}">${center.cname}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>入职时间</label>
                                            <input id="date_create" type="date" class="form-control" >
                                        </div>

                                        <div class="col-lg-6" style="text-align:center;">
                                            <button type="submit" class="btn btn-default" onclick="onCreate()" style="min-width: 100px">提&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交</button>
                                        </div>
                                        <div class="col-lg-6" style="text-align:center;">
                                            <button type="reset" class="btn btn-default" onclick="onReset()" style="min-width: 100px">重&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;置</button>
                                        </div>

                                </div>
                                <div class="tab-pane fade" id="update">
                                    <h4 style=" text-align:center;">班主任信息编辑</h4>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">开始时间:</td>
                                                            <td>
                                                                <input type="date" id="startTime_u" class = "form-control" placeholder = "开始时间" style="min-width: 150px;">
                                                            </td>
                                                            <td style="text-align:right;">结束时间:</td>
                                                            <td>
                                                                <input type="date" id="endTime_u" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                                            </td>

                                                            <td style="text-align:right;">所属中心:</td>
                                                            <td>
                                                                <select id="centers_update" class="form-control" style="min-width: 150px;">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="center" items="${requestScope.centers}">
                                                                        <option value="${center.cid}">${center.cname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">姓名:</td>
                                                            <td>
                                                                <select id="classTeachers_update" class="form-control" style="min-width: 150px;">
                                                                    <option value="-1">所有</option>
                                                                    <c:forEach var="classTeacher" items="${requestScope.classTeachers}">
                                                                        <option value="${classTeacher.ctid}">${classTeacher.ctname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query_u()" style="min-width: 150px;">条件查询</button>
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
                                        <div class="table-responsive" style="margin-top: 30px;">
                                            <div style="width:1600px;">
                                                <table class="table table-striped table-bordered table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th width="50px">#</th>
                                                        <th width="100px">姓名</th>
                                                        <th width="100px">性别</th>
                                                        <th width="150px">手机号</th>
                                                        <th width="200px">邮箱</th>
                                                        <th width="150px">中心</th>
                                                        <th width="150px">入职时间</th>
                                                        <th width="100px">状态</th>
                                                        <th width="200px">离职时间</th>
                                                        <th width="200px">离职原因</th>
                                                        <th width="200px">操作</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="update_tbody">
                                                    <c:forEach var="classTeacher" items="${requestScope.classTeachers}" begin="0" step="1" varStatus="i">
                                                        <tr>
                                                            <td>${i.index + 1}</td>
                                                            <td><input id="${classTeacher.ctid}_ctname"  value="${classTeacher.ctname}" readonly="true" class="form-control"/></td>
                                                            <td>
                                                                <select id="${classTeacher.ctid}_genders" class="form-control" readonly="true">
                                                                    <c:choose>
                                                                        <c:when test="${classTeacher.gender=='男'}">
                                                                            <option value="0" selected="selected">男</option>
                                                                            <option value="1">女</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="0">男</option>
                                                                            <option value="1" selected="selected">女</option>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                                </select>
                                                            </td>

                                                            <td><input id="${classTeacher.ctid}_tel"  value="${classTeacher.tel}" readonly="true" class="form-control"/></td>
                                                            <td><input id="${classTeacher.ctid}_email"  value="${classTeacher.email} " readonly="true" class="form-control"/></td>
                                                            <td>
                                                                <select id="${classTeacher.ctid}_centers" class="form-control" readonly="true">
                                                                    <c:forEach var="center" items="${requestScope.centers}">
                                                                        <c:choose>
                                                                            <c:when test="${center.cid==classTeacher.centerId}">
                                                                                <option value="${center.cid}" selected="selected">${center.cname}</option>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <option value="${center.cid}">${center.cname}</option>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td>${classTeacher.hiredate}</td>
                                                                <select id="${classTeacher.ctid}_states"   class="form-control" readonly="true">
                                                                    <c:choose>
                                                                        <c:when test="${classTeacher.state=='在职'}">
                                                                            <option value="0" selected="selected">在职</option>
                                                                            <option value="1">离职</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="0">在职</option>
                                                                            <option value="1" selected="selected">离职</option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </select>
                                                            </td>
                                                            <td><input id="${classTeacher.ctid}_leavedate" type="date"  value="${classTeacher.leavedate}" readonly="true" class="form-control"/></td>
                                                            <td><input id="${classTeacher.ctid}_leaveReason"  value="${classTeacher.leaveReason}" readonly="true" class="form-control"/></td>
                                                            <td><button type="button" class="btn btn-default" onclick="onEdit(${classTeacher.ctid})">编辑</button><button type="button" class="btn btn-default" style="margin-left: 20px" onclick="onSave(${classTeacher.ctid})">保存</button></td>
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
