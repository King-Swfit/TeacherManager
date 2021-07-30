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

    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src='/datetimepicker/js/bootstrap-datetimepicker.min.js'></script>
    <script src="/datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <link href="/datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet">

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
            startTime = "2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);



            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=$("#classteachers_search").val();
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();

                $.post(
                        "/employ/getClassCodeByCondition",
                        {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":endTime},
                        function (data) {
                            if(data != null && data.classcodes != null){
                                refreshUI(data)
                            }
                        }
                );
            })



        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        function refreshUI(data){
            $("#classcodes_search").empty()
            var str = ""
            var length
            if(data.classcodes != null){
                length = data.classcodes.length
                for(var i = 0; i < length; i++){
                    str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                }
                $("#classcodes_search").append(str)
            }



            $('#trainee_names').empty()
            length = data.baseinfoForTrainees.length
            str = ""
            for(var i = 0; i < length; i++){
                str = str + "<option value'" + data.baseinfoForTrainees[i].code + ">" + data.baseinfoForTrainees[i].code + "--" + data.baseinfoForTrainees[i].name + "</option>"
            }
            $('#trainee_names').append(str)


            $('#direction_name').text(data.dname)

            var newtrs = $('#tbody_new').find("tr")
            var tds1 = newtrs.eq(0).find("td")
            tds1.eq(1).text(data.baseinfoForTrainees[0].gender)
            tds1.eq(3).text(data.baseinfoForTrainees[0].graducateTime)
            tds1.eq(5).text(data.baseinfoForTrainees[0].diploma)
            tds1.eq(7).text(data.baseinfoForTrainees[0].graduateSchool)
            tds1.eq(9).text(data.baseinfoForTrainees[0].profession)



            $('#tbody_interviews').empty()
            length = data.processEmployInterviewRecords.length
            for(var i = 0; i < length; i++){
                str = "<tr>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].peiid +  "</td>"
                str = str + "<td><a href='javascript:void(0)' onclick='edit( " + i + ")'>编辑</a></td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].code +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].name +  "</td>"

                str = str + "<td>" + data.processEmployInterviewRecords[i].graducateTime +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].diploma +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].graduateSchool +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].profession +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].classcode +  "</td>"

                str = str + "<td>" + data.processEmployInterviewRecords[i].datetimee +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].corporiation +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].position +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].type +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].salary +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].result +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].realSalary +  "</td>"
                str = str + "<td>" + data.processEmployInterviewRecords[i].fuli +  "</td>"
                if(data.processEmployInterviewRecords[i].employProof != null && data.processEmployInterviewRecords[i].employProof.length > 0){
                    str = str + "<td><a href='javascript:void(0)' onclick='employProof( " + i + ")'>点击查看</a></td>"
                }else{
                    str = str + "<td>无</td>"
                }


                str = str + "</tr>"

                $('#tbody_interviews').append(str)
            }

        }


        function summary_class(){

            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            $('#thead_interviews').empty()
            var str = "<th>#</th> <th>班级编号</th> <th>学习方向</th> <th>班主任</th> <th>专科平均工资</th> <th>本科平均工资</th> <th>人均面试次数</th> <th>平均就业周期</th> <th>开发岗就业比</th> <th>非开发岗就业比</th>"
            $('#thead_interviews').append(str)
            $.post(
                    "/employ/querySummary_class",
                    {"startTime":startTime,"endTime":endTime},
                    function (employSummarys) {
                        if (null != employSummarys) {

                            $('#tbody_interviews').empty()
                            var length = employSummarys.length
                            for (var i = 0; i < length; i++) {
                                var employSummary = employSummarys[i]
                                str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + employSummary.classcode + "</td>"
                                str = str + "<td>" + employSummary.dname + "</td>"
                                str = str + "<td>" + employSummary.ctname + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_zhuan + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_ben + "</td>"
                                str = str + "<td>" + employSummary.avgInterviewTimes + "</td>"
                                str = str + "<td>" + employSummary.avgEmployPeriod + "天</td>"
                                str = str + "<td>" + employSummary.percentDevlop + "%</td>"
                                str = str + "<td>" + employSummary.percentNoDevlop + "%</td>"

                                str = str + "</tr>"

                                $('#tbody_interviews').append(str)
                            }

                        } else {
                            $('#tbody_interviews').empty()
                        }
                    }
            );

        }
        function summary_center(){
            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            $('#thead_interviews').empty()
            var str = "<th>#</th> <th>中心<th>专科平均工资</th> <th>本科平均工资</th> <th>人均面试次数</th> <th>平均就业周期</th> <th>开发岗就业比</th> <th>非开发岗就业比</th>"
            $('#thead_interviews').append(str)


            $.post(
                    "/employ/querySummary_center",
                    {"startTime":startTime,"endTime":endTime},
                    function (employSummarys) {
                        if (null != employSummarys) {

                            $('#tbody_interviews').empty()
                            var length = employSummarys.length
                            for (var i = 0; i < length; i++) {
                                var employSummary = employSummarys[i]
                                str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + employSummary.cname + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_zhuan + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_ben + "</td>"
                                str = str + "<td>" + employSummary.avgInterviewTimes + "</td>"
                                str = str + "<td>" + employSummary.avgEmployPeriod + "天</td>"
                                str = str + "<td>" + employSummary.percentDevlop + "%</td>"
                                str = str + "<td>" + employSummary.percentNoDevlop + "%</td>"

                                str = str + "</tr>"

                                $('#tbody_interviews').append(str)
                            }

                        } else {
                            $('#tbody_interviews').empty()
                        }
                    }
            );

        }
        function summary_direction(){
            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            $('#thead_interviews').empty()
            var str = "<th>#</th><th>学习方向</th>  <th>专科平均工资</th> <th>本科平均工资</th> <th>人均面试次数</th> <th>平均就业周期</th> <th>开发岗就业比</th> <th>非开发岗就业比</th>"
            $('#thead_interviews').append(str)

            $.post(
                    "/employ/querySummary_direction",
                    {"startTime":startTime,"endTime":endTime},
                    function (employSummarys) {
                        if (null != employSummarys) {

                            $('#tbody_interviews').empty()
                            var length = employSummarys.length
                            for (var i = 0; i < length; i++) {
                                var employSummary = employSummarys[i]
                                str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + employSummary.dname + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_zhuan + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_ben + "</td>"
                                str = str + "<td>" + employSummary.avgInterviewTimes + "</td>"
                                str = str + "<td>" + employSummary.avgEmployPeriod + "天</td>"
                                str = str + "<td>" + employSummary.percentDevlop + "%</td>"
                                str = str + "<td>" + employSummary.percentNoDevlop + "%</td>"

                                str = str + "</tr>"

                                $('#tbody_interviews').append(str)
                            }

                        } else {
                            $('#tbody_interviews').empty()
                        }
                    }
            );

        }
        function summary_position(){

            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            $('#thead_interviews').empty()
            var str = " <th>#</th><th>岗位类别</th> <th>专科平均工资</th> <th>本科平均工资</th> <th>人均面试次数(包括不成功)</th> <th>平均就业周期</th><th>人数</th> "
            $('#thead_interviews').append(str)

            $.post(
                    "/employ/querySummary_position",
                    {"startTime":startTime,"endTime":endTime},
                    function (employSummarys) {
                        if (null != employSummarys) {

                            $('#tbody_interviews').empty()
                            var length = employSummarys.length
                            for (var i = 0; i < length; i++) {
                                var employSummary = employSummarys[i]
                                str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + employSummary.pname + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_zhuan + "</td>"
                                str = str + "<td>" + employSummary.avgSalary_ben + "</td>"
                                str = str + "<td>" + employSummary.avgInterviewTimes + "</td>"
                                str = str + "<td>" + employSummary.avgEmployPeriod + "天</td>"
                                str = str + "<td>" + employSummary.count + "</td>"

                                str = str + "</tr>"

                                $('#tbody_interviews').append(str)
                            }

                        } else {
                            $('#tbody_interviews').empty()
                        }
                    }
            );

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
                <h1 class="page-header">动态数据统计</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div >

                    <div class="panel-body">

                        <div class="row">
                            <div class="col-lg-12">
                                <div class="panel panel-default">
                                    <div class="col-lg-9" style="background: #dddddd">
                                        <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                            <tr>
                                                <td style="text-align:right;">开始时间:</td>
                                                <td>
                                                    <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="display: inline">
                                                </td>
                                                <td style="text-align:right;">结束时间:</td>
                                                <td>
                                                    <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="display: inline">
                                                </td>

                                            </tr>
                                            <tr>
                                                <td><button type="button" class="btn btn-primary" onclick="summary_class()" style="min-width: 150px;">班级统计</button></td>
                                                <td><button type="button" class="btn btn-primary" onclick="summary_center()" style="min-width: 150px;">中心统计</button></td>
                                                <td><button type="button" class="btn btn-primary" onclick="summary_direction()" style="min-width: 150px;">方向统计</button></td>
                                                <td><button type="button" class="btn btn-primary" onclick="summary_position()" style="min-width: 150px;">岗位统计</button></td>
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
                                                    <input  id="name_search" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;visibility:hidden;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</td>
                                                <td><button type="button" class="btn btn-primary"  style="width: 150px;visibility:hidden;">模糊查询</button></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- /.panel-heading -->
                        <div class="row">
                            <div class="panel-body">
                                <div class="table-responsive" >
                                    <div style="height: 600px">
                                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                                            <thead id="thead_interviews">
                                                <th>#</th>
                                                <th>班级编号</th>
                                                <th>学习方向</th>
                                                <th>班主任</th>
                                                <th>专科平均工资</th>
                                                <th>本科平均工资</th>
                                                <th>人均面试次数</th>
                                                <th>平均就业周期</th>
                                                <th>开发岗就业比</th>
                                                <th>非开发岗就业比</th>

                                            </thead>
                                            <tbody id="tbody_interviews">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- /.table-responsive -->
                            </div>
                            <!-- /.panel-body -->
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
    </div>




</body>

</html>
