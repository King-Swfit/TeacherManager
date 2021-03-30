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
            startTime = "2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#startTime_summary').val(startTime);
            $('#endTime_summary').val(today);

            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=-1;
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();

                $.post(
                        "/procedure/getClassCodeByCondition_1",
                        {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":endTime},
                        function (data) {
                            if(data != null){
                                var classTeachers = data.classTeachers
                                $("#classteachers_search").empty()
                                var str = ""
                                var length = classTeachers.length
                                for(var i = 0; i < length; i++){
                                    str = str + "<option value='" + classTeachers[i].ctid + "'>" + classTeachers[i].ctname + "</option>"
                                }
                                $("#classteachers_search").append(str)


                                var classcodes = data.classcodes
                                $("#classcodes_search").empty()
                                str = ""
                                length = classcodes.length
                                for(var i = 0; i < length; i++){
                                    str = str + "<option value='" + classcodes[i] + "'>" + classcodes[i] + "</option>"
                                }

                                $("#classcodes_search").append(str)
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
                            "/procedure/getClassCodeByCondition_1",
                            {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    if(data != null){
                                        $("#classcodes_search").empty()
                                        var str = ""
                                        var classcodes = data.classcodes;
                                        var length = classcodes.length
                                        for(var i = 0; i < length; i++){
                                            str = str + "<option value='" + classcodes[i] + "'>" + classcodes[i] + "</option>"
                                        }

                                        $("#classcodes_search").append(str)
                                    }
                                }

                            }
                    );
                }

            })


            $("#directions_s").change(function(){
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();
                var ctid=$("#classteachers_s").val();
                var did = $("#directions_s").val();
                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClidTime",
                            {"ctid":ctid,"did":did, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_s").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_s").append(str)

                                }

                            }
                    );
                }

            })



            ///////////////////////////////////////统计/////////////////////////////////////////
            $("#centers_summary").change(function(){
                var centerId=$("#centers_summary").val()
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_summary").html("");
                                var length = data.length
                                var str ="<option value='全部'>全部</option>"
                                for(var i = 0; i < length; i++){
                                    var classTeacher = data[i]
                                    str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                                }
                                $("#classteachers_summary").append(str)
                            }

                        }
                );
            })


            $("#classteachers_summary").change(function(){
                var startTime = $('#startTime_summary').val();
                var endTime = $('#endTime_summary').val();
                var ctid=$("#classteachers_summary").val();

                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClidTime",
                            {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_summary").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_summary").append(str)
                                }

                            }
                    );
                }

            })


            $("#directions_summary").change(function(){
                var startTime = $('#startTime_summary').val();
                var endTime = $('#endTime_summary').val();
                var ctid=$("#classteachers_summary").val();
                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClidTime",
                            {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_summary").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_summary").append(str)

                                }

                            }
                    );
                }

            })
        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        function showDetail(code,name) {
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






        function showNewTalkDlg(code, name){
            showDetail(code,name)

            $('#code_new').text(code + "-" + name)

            var now = new Date();
            var day = ("0" + now.getDate()).slice(-2);
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            $('#createTime_new').val(today);

            $('#content_new').val("")

            $('#talkModal_new').modal();

        }

        function saveNewTalk(){
            var classcode = $('#classcodes_search').val()
            var info = $('#code_new').text();
            var code = info.split("-")[0]
            var name = info.split("-")[1]
            var timee = $('#createTime_new').val()

            var learnState_new = $('#learnState_new').val()

            var types_new =  $('#types_new').val()

            var content_new =  $('#content_new').val()

            var result_new =  $('#results_new').val()

            $.post(
                    "/procedure/saveTalkInfo",
                    {"classcode":classcode,"code":code,"ttime":timee,"learnState":learnState_new,"talkType":types_new,"tcontent":content_new,"result":result_new},
                    function (tid) {
                        if(tid > -1){
                            //追加数据
                            var rows_edit = $("#tbody_talkDetail").find("tr")
                            var str = "<tr>"
                            str = str + "<td>" + tid + "</td>"
                            str = str + "<td>" + code + "</td>"
                            str = str + "<td>" + name + "</td>"
                            str = str + "<td>" + learnState_new + "</td>"

                            str = str + "<td>" + timee + "</td>"
                            str = str + "<td>" + types_new + "</td>"
                            str = str + "<td>" + content_new + "</td>"
                            str = str + "<td>" + result_new + "</td>"

                            str = str + "</tr>"

                            $("#tbody_talkDetail").append(str)



                            //更新 总访谈次数
                            var trList = $("#tbody_talks").children("tr")
                            for (var i=0;i<trList.length;i++) {
                                var tdArr = trList.eq(i).find("td");
                                var code_u = tdArr.eq(0).text();
                                if(code == code_u){
                                    var ct = Number(tdArr.eq(4).text()) + 1
                                    tdArr.eq(4).text(ct)
                                    break
                                }


                            }

                            $('#talkModal_new').modal('hide')


                        }else{
                            alert("添加访谈失败!")
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
                "/procedure/getTalkCountByName",
                {"name":name},
                function (simpleTalkCounts) {
                    showTalks(simpleTalkCounts)
                    $("#tbody_talkDetail").empty()
                }
            );


        }

        function query(){
            var classcode = $('#classcodes_search').val()
            var ctname=$("#classteachers_search option:selected").text()

            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/procedure/getTalkCountByClasscode",
                        {"classcode":classcode, "ctname":ctname},
                        function (simpleTalkCounts) {
                            showTalks(simpleTalkCounts)
                            $("#tbody_talkDetail").empty()
                        }
                );
            }
        }



        function showTalks(simpleTalkCounts) {
            if(null != simpleTalkCounts){
                var length = simpleTalkCounts.length
                $('#tbody_talks').empty()
                for(var i = 0; i < length; i++){

                    var simpleTalkCount = simpleTalkCounts[i]

                    var str = "<tr>"
                    str = str + "<td>" + simpleTalkCount.code + "</td>"
                    str = str + "<td>" + simpleTalkCount.name + "</td>"
                    str = str + "<td>" + simpleTalkCount.classcode + "</td>"
                    str = str + "<td>" + simpleTalkCount.ctname + "</td>"

                    str = str + "<td>" + simpleTalkCount.count + "</td>"

                    str = str + "<td><a href=\" javascript:void(0)\" onclick=\" showNewTalkDlg('" + simpleTalkCount.code + "','" + simpleTalkCount.name + "')\">新增访谈</a></td>"
                    str = str + "<td><a href=\" javascript:void(0)\" onclick=\" showDetail('" + simpleTalkCount.code + "','" + simpleTalkCount.name + "')\">查看详情</a></td>"

                    str = str + "</tr>"

                    $('#tbody_talks').append(str)

                }
            }
        }

        // function edit(row){
        //     rowIndex = row
        //     var rows_edit = $("#tbody_talks").find("tr")
        //     var tdArrs = rows_edit.eq(rowIndex).find("td");
        //     var tid = tdArrs.eq(0).text()
        //     var timee = tdArrs.eq(2).text()
        //     var code = tdArrs.eq(3).text()
        //     var name = tdArrs.eq(4).text()
        //     var learnState = tdArrs.eq(5).text()
        //     var classcode = tdArrs.eq(6).text()
        //     var talkType = tdArrs.eq(7).text()
        //     var content = tdArrs.eq(8).text()
        //     var result = tdArrs.eq(9).text()
        //
        //
        //     $('#time_edit').html(timee);
        //     $('#code_edit').html(code + "--" +name);
        //     $('#learnState_edit').val(learnState);
        //
        //     $('#types_edit').val(talkType)
        //     $('#content_edit').val(content)
        //     $('#results_edit').val(result)
        //
        //     $('#talkModal_edit').modal();
        // }



        // function deleteTalk(tid){
        //     var classcode = $('#classcodes_search').val()
        //     var talkType = $('#talktypes_search').val()
        //     $.post(
        //         "/procedure/deleteTalk",
        //         {"tid":tid,"classcode":classcode,"talkType":talkType},
        //         function (data) {
        //             if(data.result=="success"){
        //                 var talks = data.talks
        //                 showTalks(talks)
        //                 alert("删除数据成功!")
        //             }else {
        //                 alert("删除数据失败!")
        //             }
        //
        //         }
        //     );
        // }



        // function saveTalkUpdate(){
        //     var info = $('#code_edit').text()
        //     var code = info.split("--")[0]
        //
        //     var rows_edit = $("#tbody_talks").find("tr")
        //     var tdArrs = rows_edit.eq(rowIndex).find("td");
        //     var tid = tdArrs.eq(0).text()
        //
        //     var learnState = $('#learnState_edit').val()
        //     var talkType = $('#types_edit').val()
        //     var content = $('#content_edit').val()
        //     var result = $('#results_edit').val()
        //
        //
        //     $.post(
        //             "/procedure/updateTalkInfo",
        //             {"tid":tid,"code":code,"learnState":learnState,"talkType":talkType,"tcontent":content,"result":result},
        //             function (data) {
        //                 if(data == "success"){
        //
        //                     tdArrs.eq(5).text(learnState)
        //                     tdArrs.eq(7).text(talkType)
        //                     tdArrs.eq(8).text(content)
        //                     tdArrs.eq(9).text(result)
        //                     alert("保存数据成功!")
        //
        //                 }else{
        //                     alert("保存数据失败!")
        //                 }
        //             }
        //     );
        //
        // }

        function query_summary() {
            var classteacherId = $('#classteachers_summary').val()
            var startTime = $('#startTime_summary').val()
            var endTime = $('#endTime_summary').val()

            $.post(
                    "/procedure/summaryTalkInfos",
                    {"startTime":startTime,"endTime":endTime, "classteacherId":classteacherId},
                    function (summaryTalks) {
                        $('#tbody_summary').empty()
                        if(null != summaryTalks){
                           var i = 0;
                            var length = summaryTalks.length
                            for(var j= 0; j <  length; j++){
                                var summaryTalk = summaryTalks[j]
                                var classTalkSummaryMap = summaryTalk.classTalkSummaryMap
                                for (var classcode in classTalkSummaryMap)
                                {
                                    var monthTalkMap = classTalkSummaryMap[classcode]
                                    for(var month in monthTalkMap){
                                        var str = "<tr>"
                                        var index = i+1
                                        str = str + "<td>" + index + "</td>"
                                        str = str + "<td>" + classcode + "</td>"
                                        str = str + "<td>" + summaryTalk.ctname + "</td>"
                                        str = str + "<td>" + month + "</td>"

                                        var classTalkSummary = monthTalkMap[month]
                                        str = str + "<td>" + classTalkSummary.modi + "</td>"
                                        str = str + "<td>" + classTalkSummary.chuqin_except_count + "</td>"
                                        str = str + "<td>" + classTalkSummary.zuoye_except_count + "</td>"
                                        str = str + "<td>" + classTalkSummary.score_except_count + "</td>"
                                        str = str + "<td>" + classTalkSummary.wandan_count + "/" + classTalkSummary.wandan_change +  "</td>"
                                        str = str + "<td>" + classTalkSummary.koubei_count + "/" + classTalkSummary.koubei_signup +  "</td>"
                                        str = str + "<td>" + classTalkSummary.yunwei_count + "/" + classTalkSummary.yunwei_change +  "</td>"

                                        str = str + "<td>" + classTalkSummary.xuejichange + "</td>"
                                        str = str + "<td>" + classTalkSummary.jiuye_intention + "</td>"
                                        str = str + "<td>" + classTalkSummary.jiuyezhidao + "</td>"

                                        str = str + "</tr>"
                                        $('#tbody_summary').append(str)
                                        i = i+1

                                    }

                                }



                            }

                        }
                    }
            );
        }

    </script>

</head>

<body>


<div class="modal fade" id="talkModal_new" tabindex="-1" role="dialog" aria-labelledby="imageModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">新增访谈信息</h4>
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
                            <label>学习状态</label>
                            <select id="learnState_new" class="form-control">
                                <c:forEach var="learnState" items="${requestScope.learnStates}" >
                                    <option value="${learnState}">${learnState}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>访谈类型</label>
                            <select id="types_new" class="form-control">
                                <c:forEach var="talkType" items="${requestScope.talkTypes}" >
                                    <option value="${talkType}">${talkType}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>访谈内容</label>
                            <textarea id="content_new" class="form-control" rows="5"  placeholder="输入文字">
                            </textarea>
                        </div>

                        <div class="form-group">
                            <label>访谈结果</label>
                            <select id="results_new" class="form-control">
                                <option value="目标达成">目标达成</option>
                                <option value="目标未达成">目标未达成</option>
                            </select>
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveNewTalk()">保存</button>
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
                <h1 class="page-header">访谈工作</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div >

                    <div class="panel-body">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#query" data-toggle="tab">访谈工作操作</a>
                            </li>
                            <li><a href="#summary" data-toggle="tab">访谈工作统计</a>
                            </li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="margin-top: 30px">
                            <div class="tab-pane fade in active" id="query">
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
                                                        <td style="text-align:right;">开始:</td>
                                                        <td>
                                                            <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td style="text-align:right;">结束:</td>
                                                        <td>
                                                            <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                                        </td>

                                                        <td style="text-align:right;">班级:</td>
                                                        <td>
                                                            <select class="form-control" id="classcodes_search" style="min-width: 150px;">
                                                                <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                                    <option value="${classcode}">${classcode}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td style="text-align:right;"></td>
                                                        <td><button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">条件查询</button></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-lg-3" style="background: #eeeeee">

                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                                    <tr>

                                                        <td>
                                                            &emsp; &emsp; <input  id="name_search" class = "form-control" placeholder = "学员名字" style="width: 150px;display: inline;">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&emsp; &emsp; <button type="button" class="btn btn-primary"  onclick="mohuquery()" style="width: 150px;display: inline;">模糊查询</button></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <!-- /.panel-heading -->
                                <div class="row">
                                    <div class="panel-body">
                                        <label style="margin-top: 10px;">班级访谈概要:</label>
                                        <div class="table-responsive" style="height: 500px">

                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                <tr>
                                                    <th>学号</th>
                                                    <th>姓名</th>
                                                    <th>班级</th>
                                                    <th>班主任</th>
                                                    <th>访谈次数</th>
                                                    <th>新增访谈</th>
                                                    <th>访谈详情</th>
                                                </tr>
                                                </thead>
                                                <tbody id="tbody_talks">
                                                <c:forEach var="simpleTalkCount" items="${requestScope.simpleTalkCounts}">
                                                    <tr>
                                                        <td>${simpleTalkCount.code}</td>
                                                        <td>${simpleTalkCount.name}</td>
                                                        <td>${simpleTalkCount.classcode}</td>
                                                        <td>${simpleTalkCount.ctname}</td>
                                                        <td>${simpleTalkCount.count}</td>
                                                        <td><a href="javascript:void(0)" onclick="showNewTalkDlg('${simpleTalkCount.code}', '${simpleTalkCount.name}')">新增访谈</a></td>
                                                        <td><a href="javascript:void(0)" onclick="showDetail('${simpleTalkCount.code}', '${simpleTalkCount.name}')">查看详情</a></td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>

                                        </div>
                                        <!-- /.table-responsive -->
                                        <label style="margin-top: 10px;">学员访谈详情:</label>
                                        <div class="table-responsive" style="height: 300px">
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
                                    <!-- /.panel-body -->
                                </div>
                                <%--<div class="row">--%>
                                    <%--<a href="javascript:void(0)" onclick="showNewTalkDlg()" style="margin-left: 30px">新增访谈信息<img src="/img/add3.png"/></a>--%>
                                <%--</div>--%>
                            </div>
                            <div class="tab-pane fade" id="summary">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="col-lg-9" style="background: #dddddd">
                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                    <tr>

                                                        <td style="text-align:right;">班主任:</td>
                                                        <td>
                                                            <select class="form-control" id="classteachers_summary" style="min-width: 150px;">
                                                                <option value="-1">全部</option>
                                                                <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                                    <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td style="text-align:right;">开始:</td>
                                                        <td>
                                                            <input type="date" id="startTime_summary" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td style="text-align:right;">结束:</td>
                                                        <td>
                                                            <input type="date" id="endTime_summary" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                                        </td>


                                                        <td style="text-align:right;"></td>
                                                        <td><button type="button" class="btn btn-primary" onclick="query_summary()" style="min-width: 150px">条件查询</button></td>
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
                                                            <input  id="search" class = "form-control" placeholder = "学员名字" style="width: 150px;visibility:hidden;">
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
                                            <div style="width:2500px;height: 600px">
                                                <table class="table table-striped table-bordered table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th >#</th>
                                                        <th >班级编号</th>
                                                        <th >班主任</th>
                                                        <th >月份</th>

                                                        <th >首次摸底访谈</th>
                                                        <th >出勤异常(总人次)</th>
                                                        <th >作业异常(总人次)</th>
                                                        <th >成绩异常(总人次)</th>
                                                        <th >退费挽单(总人次/改进人次)</th>
                                                        <th >口碑访谈(总人次/提交量)</th>
                                                        <th >转运维访谈(总人次/转化人次)</th>
                                                        <th >学籍变更</th>
                                                        <th >就业意向</th>
                                                        <th >就业指导</th>

                                                    </tr>
                                                    </thead>
                                                    <tbody id="tbody_summary">

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
