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
            startTime="2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#startTime_summary').val(startTime);
            $('#endTime_summary').val(today);

            $('#time_new').text(today);
            $('#createTime_new').val(today);




            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=-1;
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();

                $.post(
                        "/procedure/getClassCodeByCondition",
                        {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":endTime},
                        function (data) {
                            if(data != null && data.classcodes != null){
                                refreshUI(data)
                            }
                        }
                );
            })

            $("#classteachers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=$("#classteachers_search").val();
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();

                if(ctid > 0){
                    $.post(
                            "/procedure/getClassCodeByCondition",
                            {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null && data.classcodes != null){
                                    refreshUI2(data)
                                }

                            }
                    );
                }

            })




        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        function refreshUI(data){
            $("#classteachers_search").empty()
            var str = ""
            var length = data.classTeachers.length
            for(var i = 0; i < length; i++){
                str = str + "<option value='" + data.classTeachers[i].ctid + "'>" + data.classTeachers[i].ctname + "</option>"
            }
            $("#classteachers_search").append(str)


            $("#classcodes_search").empty()
            var str = ""
            var length = data.classcodes.length
            for(var i = 0; i < length; i++){
                str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
            }
            $("#classcodes_search").append(str)

            //更新界面


        }


        function refreshUI2(data){

            $("#classcodes_search").empty()
            var str = ""
            var length = data.classcodes.length
            for(var i = 0; i < length; i++){
                str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
            }
            $("#classcodes_search").append(str)

            //更新界面


        }

        function deleteScore(tid) {
            $.post(
                    "/employ/deleteScoreByTid",
                    {
                        "tid":tid
                    },
                    function (data) {
                        if(data.result === 'fail'){
                            alert("考试记录删除失败")
                        }else{
                            querySummary()
                            if(data.code != null && data.name != null){
                                var code=data.code
                                var name = data.name
                                showDetail(code,name)
                            }else{
                                $("#tbody_examDetail").empty()
                            }

                            alert("考试记录删除成功")
                        }
                    }
            );
        }

        function editScore(tid,name) {
            $.post(
                    "/employ/getScoreByTid",
                    {
                        "tid":tid
                    },
                    function (data) {
                        if(data == null){
                            alert("获取考试记录失败")
                        }else{
                            var score = data.score
                            var items = data.items
                            $("#createTime_edit").val(score.ttime)
                            $("#code_edit").text(score.code + "-" + name)

                            $("#types_edit").empty()
                            var str = ""
                            for(var i=0; i < items.length; i++){
                                str = str + "<option value='" + items[i] +"'>" + items[i] + "</option>"
                            }
                            $("#types_edit").append(str)
                            $("#types_edit").val(score.tname)

                            $("#score_edit").val(score.tscore)
                            $("#detail_edit").val(score.detail)

                            $("#tid_edit").val(score.tid)


                            $("#scoreModal_edit").modal()

                        }
                    }
            );

        }


        function saveScoreUpdate(){

            var tid = $("#tid_edit").val()

            var ttime = $("#createTime_edit").val()
            var tname = $("#types_edit").val()
            var tscore = $("#score_edit").val()
            var detail = $("#detail_edit").val()

            $.post(
                    "/procedure/updateScoreInfo",
                    {"tid":tid,"ttime":ttime,"tname":tname,"tscore":tscore,"detail":detail},
                    function (kv) {
                        if(kv != null){
                            querySummary()
                            var code = kv.k
                            var name = kv.v
                            showDetail(code, name)
                            $("#scoreModal_edit").modal('hide'               )
                            alert("保存数据成功")

                        }else{
                            alert("保存数据失败")
                        }
                    }
            );

        }

        function querydown() {
            var classcode = $('#classcodes_search').val()
            var ctname=$("#classteachers_search option:selected").text()

            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                window.location.href="/procedure/downloadScoreInfo?classcode=" + classcode + "&ctname=" +ctname;
            }
        }



        function query(){
            querySummary()
            $("#tbody_examDetail").empty()

        }


        function querySummary(){
            var classcode = $('#classcodes_search').val()
            var ctname=$("#classteachers_search option:selected").text()

            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/procedure/getScoreCountByClasscode",
                        {"classcode":classcode, "ctname":ctname},
                        function (simpleScoreCounts) {
                            showScores(simpleScoreCounts)
                        }
                );
            }


        }


        function showScores(simpleScoreCounts) {
            if(null != simpleScoreCounts){
                var length = simpleScoreCounts.length
                $('#tbody_exams').empty()
                for(var i = 0; i < length; i++){

                    var simpleScoreCount = simpleScoreCounts[i]

                    var str = "<tr>"
                    str = str + "<td>" + simpleScoreCount.code + "</td>"
                    str = str + "<td>" + simpleScoreCount.name + "</td>"
                    str = str + "<td>" + simpleScoreCount.classcode + "</td>"
                    str = str + "<td>" + simpleScoreCount.ctname + "</td>"

                    str = str + "<td>" + simpleScoreCount.count + "</td>"

                    str = str + "<td><a href=\" javascript:void(0)\" onclick=\" showNewExamDlg('" + simpleScoreCount.code + "','" + simpleScoreCount.name + "','" + simpleScoreCount.classcode + "')\">新增考试成绩</a></td>"
                    str = str + "<td><a href=\" javascript:void(0)\" onclick=\" showDetail('" + simpleScoreCount.code + "','" + simpleScoreCount.name + "')\">查看考试详情</a></td>"

                    str = str + "</tr>"

                    $('#tbody_exams').append(str)

                }
            }
        }

        function showNewExamDlg(code, name, classcode){
            showDetail(code,name)

            $.post(
                    "/procedure/getPhasesByClasscode",
                    {"classcode":classcode,"code":code},
                    function (sections) {
                      if(sections != null && sections.length > 0){
                          $("#types_new").empty()
                          var str = ""
                          for(var i = 0; i < sections.length; i++){
                              str = str + "<option value='" + sections[i] +"'>" + sections[i] + "</option>"
                          }

                          $("#types_new").append(str)

                          $('#code_new').text(code + "-" + name)
                          var now = new Date();
                          var day = ("0" + now.getDate()).slice(-2);
                          var month = ("0" + (now.getMonth() + 1)).slice(-2);
                          var today = now.getFullYear() + "-" + (month) + "-" + (day);


                          $('#examModal_new').modal();

                      }
                    }
            );

        }

        function showDetail(code,name) {
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
                            str = str + "<td><a href='javascript:void(0)' onclick='deleteScore( " + score.tid + ")'>删除</a></td>"
                            str = str + "<td><a href='javascript:void(0)' onclick='editScore( " + score.tid + ",\"" + name + "\")'>编辑</a></td>"

                            str = str + "</tr>"

                            $('#tbody_examDetail').append(str)
                        }



                    }
            );
        }

        function saveNewScore(){
            var classcode = $('#classcodes_search').val()
            var info = $('#code_new').text();
            var code = info.split("-")[0]
            var name = info.split("-")[1]
            var timee = $('#createTime_new').val()
            var tname =  $('#types_new').val()

            var tscore = $('#score_new').val()
            var detail =  $('#detail_new').val()
            if(tscore == null || tscore.length == 0){
                alert("必须输入成绩!")
                return
            }



            $.post(
                    "/procedure/saveNewScore",
                    {"classcode":classcode,"code":code,"ttime":timee,"tname":tname,"tscore":tscore,"detail":detail},
                    function (score) {
                        if(score != null && score.tid > -1){
                            //追加数据
                            var str = ""
                            str = str + "<tr>"
                            str = str + "<td>" + score.tid + "</td>"
                            str = str + "<td>" + score.code + "</td>"
                            str = str + "<td>" + name + "</td>"
                            str = str + "<td>" + score.ttime + "</td>"
                            str = str + "<td>" + score.tname + "</td>"
                            str = str + "<td>" + score.tscore + "</td>"
                            str = str + "<td>" + score.detail + "</td>"

                            str = str + "<td><a href='javascript:void(0)' onclick='deleteScore( " + score.tid + ")'>删除</a></td>"
                            str = str + "<td><a href='javascript:void(0)' onclick='editScore( " + score.tid + ",\"" + name + "\")'>编辑</a></td>"

                            str = str + "</tr>"

                            $('#tbody_examDetail').append(str)



                            //更新 总访谈次数
                            var trList = $("#tbody_exams").children("tr")
                            for (var i=0;i<trList.length;i++) {
                                var tdArr = trList.eq(i).find("td");
                                var code_u = tdArr.eq(0).text();
                                if(code == code_u){
                                    var ct = Number(tdArr.eq(4).text()) + 1
                                    tdArr.eq(4).text(ct)
                                    break
                                }


                            }

                            $('#examModal_new').modal('hide')
                            alert("添加成绩成功!")


                        }else{
                            alert("添加成绩失败!")
                        }

                    }
            );
        }

        function mohuquery() {
            var name = $('#name_search').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/procedure/getScoreCountByName",
                    {"name":name},
                    function (simpleScoreCounts) {
                        showScores(simpleScoreCounts)
                        $("#tbody_examDetail").empty()
                    }
            );


        }






    </script>

</head>

<body>
<div class="modal fade" id="examModal_new" tabindex="-1" role="dialog" aria-labelledby="imageModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">新增考试成绩</h4>
            </div>

            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="form-group">
                            <label>时间</label>
                            <input id="createTime_new" type="date" class="form-control" placeholder="输入文字" >
                        </div>
                        <div class="form-group">
                            <label>学号--姓名</label>
                            <label id="code_new" class="form-control"></label>
                        </div>

                        <div class="form-group">
                            <label>学习阶段</label>
                            <select id="types_new" class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>考试成绩</label>
                            <input id="score_new" class="form-control" type="number"  placeholder="0"/>
                        </div>

                        <div class="form-group">
                            <label>考试详情</label>
                            <textarea id="detail_new" class="form-control" rows="5">
                            </textarea>
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveNewScore()">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="scoreModal_edit" tabindex="-1" role="dialog" aria-labelledby="scoreModal_edit">
    <div class="modal-dialog" role="document" style="width: 50%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">编辑学员成绩</h4>
            </div>

            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="form-group">
                            <label>时间</label>
                            <input id="createTime_edit" type="date" class="form-control" placeholder="输入文字" >
                        </div>
                        <div class="form-group">
                            <label>学号--姓名</label>
                            <label id="code_edit" class="form-control"></label>
                        </div>

                        <div class="form-group">
                            <label>学习阶段</label>
                            <select id="types_edit" class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>考试成绩</label>
                            <input id="score_edit" class="form-control" type="number"  placeholder="0"/>
                        </div>

                        <div class="form-group">
                            <label>考试详情</label>
                            <textarea id="detail_edit" class="form-control" rows="5">
                            </textarea>
                        </div>
                        <input id="tid_edit"  type="hidden" />

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveScoreUpdate()">保存</button>
            </div>
        </div>
    </div>
</div>


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
                <h1 class="page-header">学员成绩</h1>
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
                                    <div class="col-lg-12" style="background: #dddddd">

                                        <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                            <tr>
                                                <td>中心:</td>
                                                <td>
                                                    <select  class="form-control" id="centers_search" style="min-width: 150px">
                                                        <option value="-1">全部</option>
                                                        <c:forEach var="center" items="${requestScope.centers}" >
                                                            <option value="${center.cid}">${center.cname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td>班主任:</td>
                                                <td>
                                                    <select class="form-control" id="classteachers_search" style="min-width: 150px">

                                                        <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                            <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td>开始:</td>
                                                <td>
                                                    <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="display: inline;min-width: 150px">
                                                </td>
                                                <td ></td>
                                                <td bgcolor="#eeeeee">
                                                    <input  id="name_search" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;display: inline;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>结束:</td>
                                                <td>
                                                    <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="display: inline;min-width: 150px">
                                                </td>
                                                <td>班级:</td>
                                                <td>
                                                    <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                                        <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                            <option value="${classcode}">${classcode}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td style="text-align:right;"><img src="/img/down.png" onclick="querydown()" style="width: 32px;"/></td>
                                                <td>
                                                    <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">条件查询</button>
                                                </td>
                                                <td width="40px" style="text-align:right;"><img src="/img/down2.png" onclick="querydown_center()" style="width: 32px;"/></td>
                                                <td bgcolor="#eeeeee"><button type="button" class="btn btn-primary"  onclick="mohuquery()" style="width: 150px;display: inline;">模糊查询</button></td>
                                            </tr>
                                        </table>


                                    </div>
                                    <%--<div class="col-lg-3" style="background: #eeeeee">--%>
                                        <%--<table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >--%>
                                            <%--<tr>--%>

                                                <%--<td>--%>
                                                    <%--&emsp; &emsp; <input  id="name_search" class = "form-control" placeholder = "学员名字" style="width: 150px;display: inline;">--%>
                                                <%--</td>--%>
                                            <%--</tr>--%>
                                            <%--<tr>--%>
                                                <%--<td>&emsp; &emsp; <button type="button" class="btn btn-primary"  onclick="mohuquery()" style="width: 150px;display: inline;">模糊查询</button></td>--%>
                                            <%--</tr>--%>
                                        <%--</table>--%>
                                    <%--</div>--%>
                                </div>

                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="row">
                            <div class="panel-body">
                                <label style="margin-top: 10px;">测试成绩概要:</label>
                                <div class="table-responsive" style="height: 500px">
                                    <table class="table table-striped table-bordered table-hover" >
                                            <thead>
                                                <tr>
                                                    <th>学号</th>
                                                    <th>姓名</th>
                                                    <th>班级</th>
                                                    <th>班主任</th>
                                                    <th>考试次数</th>
                                                    <th>新增考试</th>
                                                    <th>考试详情</th>
                                                </tr>
                                            </thead>
                                            <tbody id="tbody_exams">
                                                <c:forEach var="simpleScoreCount" items="${requestScope.simpleScoreCounts}">
                                                    <c:if test="${!empty simpleScoreCount.name}">
                                                        <tr>
                                                            <td>${simpleScoreCount.code}</td>
                                                            <td>${simpleScoreCount.name}</td>
                                                            <td>${simpleScoreCount.classcode}</td>
                                                            <td>${simpleScoreCount.ctname}</td>
                                                            <td>${simpleScoreCount.count}</td>
                                                            <td><a href="javascript:void(0)" onclick="showNewExamDlg('${simpleScoreCount.code}', '${simpleScoreCount.name}', '${simpleScoreCount.classcode}')">新增考试成绩</a></td>
                                                            <td><a href="javascript:void(0)" onclick="showDetail('${simpleScoreCount.code}', '${simpleScoreCount.name}')">查看详情</a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                </div>

                                <!-- /.table-responsive -->
                            </div>
                            <!-- /.panel-body -->
                            </div> <label style="margin-top: 10px;">学员成绩详情:</label>
                            <div class="table-responsive" style="height: 300px">

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
                                    <th>操作一</th>
                                    <th>操作二</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_examDetail">
                                </tbody>
                            </table>

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
