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

    <!-- Morris Charts CSS -->
    <link href="/vendor/morrisjs/morris.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>


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

    <style type="text/css">
        .table {table-layout:fixed;}
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }
    </style>

    <script type="text/javascript">
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime = "2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);


            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_search").html("");
                                var length = data.length
                                var str =""
                                for(var i = 0; i < length; i++){
                                    var classTeacher = data[i]
                                    str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                                }
                                $("#classteachers_search").append(str)
                            }
                        }
                );
            })
        });

        function onQuery() {
            var centerId=$("#centers_search").val()
            var classteacherId = $("#classteachers_search").val()
            var classstate = $("#classstates_search").val()
            var startTime = $("#startTime_search").val()
            var endTime = $('#endTime_search').val()

            $.post(
                    "/class/classDetailsByCondition",
                    {"centerId":centerId,"classteacherId":classteacherId, "classstate":classstate,"startTime":startTime, "endTime":endTime },
                    function (data) {
                        if(data != null){
                            var classTeachers = data.classTeachers
                            var generalInfos = data.generalInfos
                            var classstates = data.classstates
                            var length = generalInfos.length
                            $('#tbody_course').empty()
                            for(var i = 0; i < length; i++){
                                var generalInfo = generalInfos[i]

                                var str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td><a href='javascript:void(0);' onclick='editClass("+ generalInfo.clid + "," + i + ")'>编辑</a><a href='javascript:void(0);' onclick='saveClass(" + generalInfo.clid + "," + i + ")' style='margin-left: 30px'>保存</a></td>"
                                str = str + "<td>" + generalInfo.classcode + "</td>"
                                str = str + "<td>" + generalInfo.dname + "</td>"
                                str = str + "<td>" + generalInfo.cname + "</td>"

                                str = str + "<td ><select type='select'  class='form-control' width='150px' disabled>"
                                for(var j = 0; j < classTeachers.length; j++){
                                    var classteacher = classTeachers[j]
                                    if(classteacher.ctid == generalInfo.classteacherId){
                                        str = str + "<option value='" + classteacher.ctid +"' selected='selected'>" + classteacher.ctname + "</option>"
                                    }else{
                                        str = str + "<option value='" + classteacher.ctid +"'>" + classteacher.ctname + "</option>"
                                    }
                                }
                                str = str + "</select></td>"

                                str = str + "<td><input type='date' value='" + generalInfo.beginDate + "' class='form-control' readonly='readonly'></td>"
                                str = str + "<td ><input type='number'  class='form-control' readonly='readonly' value='" + generalInfo.initPfx+"'></td>"


                                str = str + "<td ><select type='select'  class='form-control' width='150px' disabled>"
                                for(var j = 0; j < classstates.length; j++){
                                    if(generalInfo.state == classstates[j]){
                                        str = str + "<option value='" + classstates[j] +"' selected='selected'>" + classstates[j] + "</option>"
                                    }else{
                                        str = str + "<option value='" + classstates[j] +"'>" + classstates[j] + "</option>"
                                    }
                                }
                                str = str + "</select></td>"

                                str = str + "<td>" + generalInfo.realExamGraducateDate + "</td>"

                                for(var k = 0; k < generalInfo.courseItems2.length; k++){
                                    var courseItem = generalInfo.courseItems2[k]
                                    str = str + "<td id='" + courseItem.courseId + "'>" + courseItem.cname + "</td>"

                                    str = str + "<td><select type='select'  class='form-control' disabled>"
                                    for(var m = 0; m < courseItem.teachers.length; m++){
                                        var teacher = courseItem.teachers[m]
                                        if(teacher.tid == courseItem.teacher.tid){
                                            str = str + "<option value='" + teacher.tid +"' selected='selected'>" + teacher.tname + "</option>"
                                        }else{
                                            str = str + "<option value='" + teacher.tid +"' >" + teacher.tname + "</option>"
                                        }
                                    }
                                    str = str + "</select></td>"

                                    str = str + "<td><input type='date' value='" + courseItem.realBeginDate + "' class='form-control' readonly='readonly'></td>"
                                    str = str + "<td><input type='date' value='" + courseItem.realEndDate + "' class='form-control' readonly='readonly'></td>"
                                    str = str + "<td><input type='date' value='" + courseItem.realProEndDate + "' class='form-control' readonly='readonly'></td>"
                                }

                                str = str + "</tr>"
                                $('#tbody_course').append(str)
                            }

                        }
                    }
            );
        }

        //弹出对话框，在对话框中编辑
        function editClass(clid, index){
            var rows = $('#tbody_course').find("tr")
            var tdArr = rows.eq(index).find("td");
            var length = tdArr.length

            tdArr.eq(5).find("select").removeAttr("disabled");
            tdArr.eq(6).find("input").attr("readonly",false)
            tdArr.eq(7).find("input").attr("readonly",false)
            tdArr.eq(8).find("select").removeAttr("disabled");

            var i = 9;
            while( i < length){
                i = i+2;
                tdArr.eq(i).find("select").removeAttr("disabled");
                for(var j = 0; j < 3; j++){
                    i = i+1
                    tdArr.eq(i).find("input").attr("readonly",false)
                }

            }
        }



        function saveClass(clid , index ){

            var rows = $('#tbody_course').find("tr")
            var tdArr = rows.eq(index).find("td");
            var length = tdArr.length

            //获取界面值
            var ctid = tdArr.eq(5).find("select").val()
            var beginDate = tdArr.eq(6).find("input").val()
            var initPfx = tdArr.eq(7).find("input").val()
            var state = tdArr.eq(8).find("select").val()

            var i = 9;

            var courseItems = new Array()
            var j = 0
            while( i + 1 < length){
                i = i+1;
                var coid = tdArr.eq(i).attr("id")
                i = i+1;
                var tid = tdArr.eq(i).find("select").val()//授课老师
                var dates = new Array()
                for(var k = 0; k < 3; k++){
                    i = i+1
                    dates[k] = tdArr.eq(i).find("input").val()
                }
                courseItems[j]={"coid":coid,"tid":tid, "dates":dates}
                j++
            }

            var json =
            {
                "clid":clid,
                "courseItems":courseItems, "ctid":ctid, "beginDate":beginDate, "initPfx":initPfx, "state":state
            }

            $.post(
                    "/class/update",
                    {"data":JSON.stringify(json)},
                    function (data) {
                        
                        console.log(data)
                        tdArr.eq(5).find("select").attr("disabled","disabled")
                        tdArr.eq(6).find("input").attr("readonly",true)
                        tdArr.eq(7).find("input").attr("readonly",true)
                        tdArr.eq(8).find("select").attr("disabled","disabled")


                        var i = 9;
                        while( i < rows[index].cells.length){
                            i = i+2;
                            tdArr.eq(i).find("select").attr("disabled","disabled")
                            for(var j = 0; j < 3; j++){
                                i = i+1
                                tdArr.eq(i).find("input").attr("readonly",true)
                            }

                        }
                    });

        }

    </script>



</head>

<body>

    <div id="wrapper" >

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

        <div id="page-wrapper" >
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">班级基本信息</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="col-lg-9" style="background: #dddddd">
                            <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                <tr>
                                    <td style="text-align:right;">中心:</td>
                                    <td>
                                        <select  class="form-control" id="centers_search" style="min-width: 150px;">
                                            <option value="-1">全部</option>
                                            <c:forEach var="center" items="${requestScope.centers}" >
                                                <option value="${center.cid}">${center.cname}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td style="text-align:right;">班主任:</td>
                                    <td>
                                        <select class="form-control" id="classteachers_search" style="min-width: 150px;">
                                            <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <td style="text-align:right;">状态:</td>
                                    <td>
                                        <select class="form-control" id="classstates_search" style="min-width: 150px">
                                            <option value="全部">全部</option>
                                            <c:forEach var="state" items="${requestScope.states}">
                                                <option value="${state}">${state}</option>
                                            </c:forEach>
                                        </select>
                                    </td>


                                </tr>
                                <tr>
                                    <td style="text-align:right;">开始:</td>
                                    <td>
                                        <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                    </td>
                                    <td style="text-align:right;">结束:</td>
                                    <td>
                                        <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                    </td>


                                    <td style="text-align:right;"></td>
                                    <td><button type="button" class="btn btn-primary" onclick="onQuery()" style="min-width: 150px">条件查询</button></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-lg-3" style="background: #eeeeee">

                            <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                <tr>
                                    <td>
                                        &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
                                    </td>
                                    <td>
                                        <input  id="name_search" class = "form-control" placeholder = "学员名" style="width: 150px;visibility:hidden;">
                                    </td>
                                </tr>
                                <tr>
                                    <td>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</td>
                                    <td><button type="button" class="btn btn-primary"  style="width: 150px;visibility:hidden;">模糊查询</button></td>
                                </tr>
                            </table>
                        </div>


                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>

            </div>
            <!-- /.row -->


            <div class="row" >

                <div class="col-lg-12">
                    <div class="table-responsive">
                                <div style="width:5800px;height: 600px;margin-top: 20px;">
                                <table class="table table-striped table-bordered table-hover text-nowrap" >
                                    <thead>
                                        <tr >
                                            <th width="50px">#</th>
                                            <th width="100px">操作</th>
                                            <th width="100px">班级编号</th>
                                            <th width="100px">方向</th>
                                            <th width="150px">中心</th>
                                            <th width="150px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;班主任&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                            <th width="200px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;开班时间&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                            <th width="150px">初始班级人数</th>
                                            <th width="150px">班级状态&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>

                                            <th width="100px">毕业考试时间</th>

                                            <th width="100px">课程1名</th>
                                            <th width="150px">课程1授课老师</th>

                                            <th width="200px">课程1开课日期</th>
                                            <th width="200px">课程1结课日期</th>
                                            <th width="200px">课程1实际结项日期</th>

                                            <th width="100px">课程2课程名</th>
                                            <th width="150px">课程2授课老师</th>

                                            <th width="200px">课程2开课日期</th>
                                            <th width="200px">课程2结课日期</th>
                                            <th width="200px">课程2结项日期</th>

                                            <th width="100px">课程3课程名</th>
                                            <th width="150px">课程3授课老师</th>

                                            <th width="200px">课程3开课日期</th>
                                            <th width="200px">课程3结课日期</th>
                                            <th width="200px">课程3结项日期</th>

                                            <th width="100px">课程4课程名</th>
                                            <th width="150px">课程4授课老师</th>

                                            <th width="150px">课程4开课日期</th>
                                            <th width="150px">课程4结课日期</th>
                                            <th width="150px">课程4结项日期</th>

                                            <th width="100px">课程5课程名</th>
                                            <th width="150px">课程5授课老师</th>

                                            <th width="150px">课程5开课日期</th>
                                            <th width="150px">课程5结课日期</th>
                                            <th width="150px">课程5结项日期</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody_course">
                                    <c:forEach var="generalInfo" items="${requestScope.generalInfos}"  varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td><a href="javascript:void(0);" onclick="editClass(${generalInfo.clid}, ${status.index} )">编辑</a><a href="javascript:void(0);" onclick="saveClass(${generalInfo.clid},${status.index})" style="margin-left: 30px">保存</a></td>
                                            <td>${generalInfo.classcode}</td>
                                            <td>${generalInfo.dname} </td>
                                            <td>${generalInfo.cname} </td>

                                            <td >
                                                <select type='select'  class='form-control' width='150px' disabled>
                                                    <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                        <c:choose>
                                                            <c:when test="${classteacher.ctid == generalInfo.classteacherId}">
                                                                <option value="${classteacher.ctid}" selected='selected'>${classteacher.ctname}</option>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <option value="${classteacher.ctid}" >${classteacher.ctname}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td>

                                            <td><input type="date" value="${generalInfo.beginDate}" class="form-control" readonly="readonly"></td>
                                            <td ><input type="number"  class="form-control" readonly="readonly" value="${generalInfo.initPfx}"></td>


                                            <td >
                                                <select type='select'  class='form-control' width='150px' disabled>
                                                    <c:forEach var="classstate" items="${requestScope.states}" >
                                                        <c:choose>
                                                            <c:when test="${classstate == generalInfo.state}">
                                                                <option value="${classstate}" selected='selected'>${classstate}</option>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <option value="${classstate}">${classstate}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td>

                                            <td>${generalInfo.realExamGraducateDate}</td>

                                            <c:forEach var="courseItem" items="${generalInfo.courseItems2}" >
                                                <td id='${courseItem.courseId}'> ${courseItem.cname} </td>
                                                <td>
                                                    <select type='select'  class='form-control' disabled>
                                                        <c:forEach var="teacher" items="${courseItem.teachers}" >
                                                            <c:choose>
                                                                <c:when test="${teacher.tid == courseItem.teacher.tid}">
                                                                    <option value="${teacher.tid}" selected='selected'>${teacher.tname}</option>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <option value="${teacher.tid}" >${teacher.tname}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                                <td><input type='date' value='${courseItem.realBeginDate} ' class='form-control' readonly='readonly'></td>
                                                <td><input type='date' value='${courseItem.realEndDate} ' class='form-control' readonly='readonly'></td>
                                                <td><input type='date' value='${courseItem.realProEndDate} ' class='form-control' readonly='readonly'></td>


                                            </c:forEach>


                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                </div>
                            </div>
                </div>


            </div>





        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->



</body>

</html>
