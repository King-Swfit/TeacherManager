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

    <![endif]-->
    <script src="/jquery/jquery-1.10.2.min.js"></script>

    <script type="text/javascript">
        $(function(){

            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
            //完成赋值
            $('#classTime').val(today);

            $('.nav-tabs li').click(function(){
                var _id = $(this).attr('id');

                switch(_id){
                    case "q":
                        $.get(
                                "/jiaowu/centerList",
                                function (data) {
                                    refreshQueryUI(data);
                                }
                        );
                        break;
                    case "c":
                        break;
                    case "u":
                        $.get(
                                "/jiaowu/centerList",
                                function (data) {
                                    refreshUpdateUI(data);
                                }
                        );
                        break;
                    case "d":
                        $.get(
                                "/jiaowu/centerList",
                                function (data) {
                                    refreshDeleteUI(data);
                                }
                        );
                        break;
                }
            });



            $("#new_teachers").change(function(){
                var value=$("#new_teachers").val();
                var arr =value.toString().split("&&");
                $("#new_tel").val(arr[0]);
                $("#new_email").val(arr[1]);

            })

            $("#teachers_edit").change(function(){
                var value=$("#teachers_edit").val();
                var arr =value.toString().split("&&");
                $("#tel_edit").val(arr[1]);
                $("#email_edit").val(arr[2]);

            })

            $("#centers_edit").change(function(){
                var cid=$("#centers_edit").val();

                $.get(
                        "/jiaowu/getCenterById",
                        {"cid":cid},
                        function (data) {
                            updateModifyUI(data);
                        }
                );
            })

            $("#centers_delete").change(function(){
                var value=$("#centers_delete").val();
                var arr = value.split("&&");

                $("#cname_delete").val(arr[1]);
                $("#address_delete").val(arr[2]);
                $("#tname_delete").val(arr[3]);
                $("#tel_delete").val(arr[4]);
                $("#email_delete").val(arr[5]);
            })
        })


        function onCreateClassNb(){
            var centerId = $("#centers_base").val()
            var directionId = $("#directions_base").val()
            var classTime = $("#classTime").val()
            var classType = $("#classtypes").val()

            $.post(
                    "/class/getClassTeachersByCenterId",
                    {"cid":centerId,"directionId":directionId,"classType":classType},
                    function (data) {

                        $("#classNb").val(data.classcode)

                        var classTeachers = data.classTeachers
                        $("#classteachers").empty()
                        var length = classTeachers.length

                        for(var i = 0; i < length; i++){
                            var str = ""
                            var classTeacher = classTeachers[i]
                            str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                            $("#classteachers").append(str)
                        }

                        var courseteachersJsonArray = data.courseTeachers_sets
                        $("#tbody_course").empty()
                        length = courseteachersJsonArray.length
                        for(var i = 0; i < length; i++){
                            var courseteachersJson = courseteachersJsonArray[i]
                            var index = i+1
                            var str = "<tr><td>" + index + "</td>"
                            str = str + "<td>" + courseteachersJson.cname +"</td>"
                            str = str + "<td><select class='form-control' id='" + courseteachersJson.cid + "'>"

                            var courseteachers = courseteachersJson.courseteachers
                            for(var j = 0; j < courseteachers.length; j++){
                                str = str + "<option value='"+ courseteachers[j].tid + "'>" + courseteachers[j].tname + "</option>"
                            }
                            str = str + "</select></td>"

                            str = str + "<td><input type='date' class='form-control' id='" + courseteachersJson.cid + "_startTime'/></td>"
                            str = str + "<td><input type='date' class='form-control' id='" + courseteachersJson.cid + "_endTime'/></td>"
                            str = str + "<td><input type='date' class='form-control' id='" + courseteachersJson.cid + "_pro_endTime'/></td>"

                            $("#tbody_course").append(str)
                        }





                    }
            );

        }

        function onNewClass(){
            var directionId =  $("#directions_base").val()
            var centerId =  $("#centers_base").val()
            var classTime =  $("#classTime").val()
            var classcode = $("#classNb").val()

            var ctid = $("#classteachers").val()
            var graduateExamDate = $("#graduateExamDate").val()
            var graduateDate = $("#graduateDate").val()


            var courseItems=new Array()
            var trList =$("#tbody_course").children("tr")
            for (var i=0;i<trList.length;i++) {
                var tdArr = trList.eq(i).find("td");
                var cid = tdArr.eq(2).find("select").attr('id')
                var tid = tdArr.eq(2).find("select").val()
                var startDate = tdArr.eq(3).find("input").val()
                var endDate = tdArr.eq(4).find("input").val()
                var proEndDate = tdArr.eq(5).find("input").val()

                courseItems[i] = {"cid":cid,"tid":tid,"startDate":startDate,"endDate":endDate,"proEndDate":proEndDate}
            }

            var json =  {
                "directionId":directionId,
                "centerId": centerId,
                "classTime": classTime,
                "classcode": classcode,
                "ctid": ctid,
                "graduateExamDate":graduateExamDate,
                "graduateDate":graduateDate,
                "courseItems": courseItems
            }

            $.post(
                    "/class/create",
                    {"data":JSON.stringify(json)},
                    function (data) {
                        alert(data);
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
                    <h1 class="page-header">新建班级</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            班级基本信息
                        </div>
                        <div class="panel-body">

                            <div class="col-lg-9" style="background: #dddddd">
                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                    <tr>
                                        <td style="text-align:right;">方向:</td>
                                        <td>
                                            <select class="form-control" id="directions_base" style="min-width: 150px">
                                                <c:forEach var="direction" items="${requestScope.directions}">
                                                    <option value="${direction.did}">${direction.dname}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td style="text-align:right;">中心:</td>
                                        <td>
                                            <select class="form-control" id="centers_base" style="min-width: 150px">
                                                <c:forEach var="center" items="${requestScope.centers}">
                                                    <option value="${center.cid}">${center.cname}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td style="text-align:right;">开班时间:</td>
                                        <td>
                                            <input type="date" id="classTime" class = "form-control"  style="min-width: 150px">
                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="text-align:right;">班级:</td>
                                        <td>
                                            <select id="classtypes" class = "form-control"  style="min-width: 150px">
                                                <option value="q">全日班</option>
                                                <option value="z">周末班</option>
                                            </select>
                                        </td>

                                        <td></td>
                                        <td style="text-align:right;"> <button type="button" class="btn btn-primary" onclick="onCreateClassNb()" style="min-width: 150px">生成班级编号</button></td>

                                        <td style="text-align:right;">班级编号:</td>
                                        <td> <input placeholder="点击按钮自动生成" id="classNb" class = "form-control"  readonly="true" style="width: 150px"/></td>
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


                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>

            </div>
            <!-- /.row -->

            <div class="row" style="margin-top: 30px">
                <div class="col-lg-12">
                    <div class="form-inline">
                        <label style="display: inline;">班主任:</label>
                        <select  id="classteachers" class="form-control" style="min-width:150px;display: inline;" >
                            <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

            </div>

            <div class="row" style="margin-top: 50px">

                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            课程安排
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" >
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>课程名</th>
                                        <th>授课老师</th>
                                        <th>预计课程开始时间</th>
                                        <th>预计课程结束时间</th>
                                        <th>预计项目结束时间</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_course">

                                    </tbody>
                                </table>
                            </div>
                            <div class="col-lg-12">
                                <div class="col-lg-6">
                                    <div class = "form-inline">
                                        <label style="display: inline">预计毕业考试时间:</label>
                                        <input type="date" id="graduateExamDate" class = "form-control"  >
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class = "form-inline">
                                        <label>预计毕业时间:</label>
                                        <input type="date" id="graduateDate" class = "form-control"  >
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->


                </div>


            </div>

            <div class="row" style="margin-top: 30px">
                <div class="col-lg-12" style="text-align:center;">
                    <div class="col-lg-6">
                        <button  onclick="onRset()" class="btn btn-default">重&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;置</button>
                    </div>
                    <div class="col-lg-6">
                        <button  onclick="onNewClass()" class="btn btn-default">确&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;定</button>
                    </div>
                </div>
            </div>
            <div/>
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
