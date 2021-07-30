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

            var startTime = (now.getFullYear() - 1) + "-" + (month)  +  "-" +(day);
            startTime="2000-01-01"

            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#attenceStartTime_search').val(startTime);
            $('#attenceEndTime_search').val(today);

            $('#startTime_search2').val(startTime);
            $('#endTime_search2').val(today);

            $('#attenceStartTime_search2').val(startTime);
            $('#attenceEndTime_search2').val(today);

            $('#startTime_search3').val(startTime);
            $('#endTime_search3').val(today);


            $("#centers_search").change(function () {
                var centerId = $("#centers_search").val()
                var ctid = -1;

                //界面已经隐藏这两个控件，为了不改变原来代码。赋值全部

                $.post(
                        "/procedure/getClassCodeByCondition_1",
                        {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                        function (data) {
                            if (data != null) {
                                $("#classteachers_search").empty()
                                var str = ""
                                var length = data.classTeachers.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classTeachers[i].ctid + "'>" + data.classTeachers[i].ctname + "</option>"
                                }

                                $("#classteachers_search").append(str)

                                $("#classcodes_search").empty()
                                var str = ""
                                var length = data.classcodes.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                }

                                $("#classcodes_search").append(str)
                            }
                        }
                );
            })

            $("#classteachers_search").change(function () {
                var centerId = $("#centers_search").val()
                var ctid = $("#classteachers_search").val();

                if (ctid > 0) {
                    $.post(
                            "/procedure/getClassCodeByCondition_1",
                            {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                            function (data) {
                                if (data != null) {
                                    if (data != null) {
                                        $("#classcodes_search").empty()
                                        var str = ""
                                        var length = data.classcodes.length
                                        for (var i = 0; i < length; i++) {
                                            str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                        }

                                        $("#classcodes_search").append(str)
                                    }
                                }

                            }
                    );
                }

            })

            $("#centers_search2").change(function () {
                var centerId = $("#centers_search2").val()
                var ctid = -1;

                $.post(
                        "/procedure/getClassCodeByCondition_1",
                        {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                        function (data) {
                            if (data != null) {
                                $("#classteachers_search2").empty()
                                var str = ""
                                var length = data.classTeachers.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classTeachers[i].ctid + "'>" + data.classTeachers[i].ctname + "</option>"
                                }

                                $("#classteachers_search2").append(str)

                                $("#classcodes_search2").empty()
                                var str = ""
                                var length = data.classcodes.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                }

                                $("#classcodes_search2").append(str)
                            }
                        }
                );
            })

            $("#classteachers_search2").change(function () {
                var centerId = $("#centers_search2").val()
                var ctid = $("#classteachers_search2").val();

                if (ctid > 0) {
                    $.post(
                            "/procedure/getClassCodeByCondition_1",
                            {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                            function (data) {
                                if (data != null) {
                                    if (data != null) {
                                        $("#classcodes_search2").empty()
                                        var str = ""
                                        var length = data.classcodes.length
                                        for (var i = 0; i < length; i++) {
                                            str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                        }

                                        $("#classcodes_search2").append(str)
                                    }
                                }

                            }
                    );
                }

            })

            $("#centers_search3").change(function () {
                var centerId = $("#centers_search3").val()
                var ctid = -1

                $.post(
                        "/procedure/getClassCodeByCondition_1",
                        {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                        function (data) {
                            if (data != null) {
                                $("#classteachers_search3").empty()
                                var str = ""
                                var length = data.classTeachers.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classTeachers[i].ctid + "'>" + data.classTeachers[i].ctname + "</option>"
                                }

                                $("#classteachers_search3").append(str)

                                $("#classcodes_search3").empty()
                                var str = ""
                                var length = data.classcodes.length
                                for (var i = 0; i < length; i++) {
                                    str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                }

                                $("#classcodes_search3").append(str)
                            }
                        }
                );
            })

            $("#classteachers_search3").change(function () {
                var centerId = $("#centers_search3").val()
                var ctid = $("#classteachers_search3").val();

                if (ctid > 0) {
                    $.post(
                            "/procedure/getClassCodeByCondition_1",
                            {"centerId": centerId, "ctid": ctid, "startTime": startTime, "endTime": today},
                            function (data) {
                                if (data != null) {
                                    if (data != null) {
                                        $("#classcodes_search3").empty()
                                        var str = ""
                                        var length = data.classcodes.length
                                        for (var i = 0; i < length; i++) {
                                            str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                                        }

                                        $("#classcodes_search3").append(str)
                                    }
                                }

                            }
                    );
                }

            })


            $('.form_datetime').datetimepicker({
                format: 'yyyy-mm',
                autoclose: true,
                todayBtn: true,
                startView: 'year',
                minView:'year',
                maxView:'decade',
                language:  'zh-CN',
            });


            $('#attenceSumbit').submit(function (event) {
                //首先验证文件格式
                var fileName = $(this).find("input[name=excelFile]").val();
                if (fileName === '') {
                    alert('请选择文件');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'xls' && fileType !== 'xlsx') {
                    alert('文件格式不正确，excel文件！');
                    return;
                }
                event.preventDefault();
                var form = $(this);
                if (form.hasClass('upload')) {
                    //普通表单
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: form.serialize(),
                        dataType: "JSON"
                    }).success(function () {
                        //成功提交
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        //错误信息
                    });
                }
                else {
                    // mulitipart form,如文件上传类
                    var formData = new FormData(this);
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: formData,
                        dataType: "JSON",
                        mimeType: "multipart/form-data",
                        contentType: false,
                        cache: false,
                        processData: false,
                        error : function(XHR, textStatus, errorThrown) {
                            alert("网络错误！XHR=" + XHR + "\ntextStatus=" + textStatus
                                    + "\nerrorThrown=" + errorThrown);
                        },
                        success : function(data) {
                            if(data.result == "success"){
                                var processAttenceOriginals = data.processAttenceOriginals;
                                showAttenceOriginal(processAttenceOriginals)

                            }else{
                                alert(data.result + "->" + data.reason)
                            }

                        }
                    });
                }

                return false;
            });



            var $fixTable = $('#cardRecord .table-responsive');
            $('#cardRecord').scroll(function() {
                var id = '#' + this.id;
                var scrollTop = $(id).scrollTop() || $(id).get(0).scrollTop,
                        style = {
                            'position': 'absolute',
                            'left': '0',
                            'right': '0',
                            'top': scrollTop + 'px'
                        };
                if ($fixTable.length) {
                    (scrollTop === 0) ? $fixTable.addClass('hidden') : $fixTable.removeClass('hidden');
                    $fixTable.css(style);
                } else {
                    var html = $(id + ' .scrollTable thead').get(0).innerHTML;
                    var table = $('<table class="table table-bordered fixTable"><thead>' + html + '</thead></table>');
                    table.css(style);
                    $(id).append(table);
                    $fixTable = $(this).find('.table-responsive');
                }
            });


        })





        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




        function query(){
            var classcode = $('#classcodes_search').val()
            var startTime = $('#attenceStartTime_search').val();
            var endTime = $('#attenceEndTime_search').val();
            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/procedure/getAttenceOriginals",
                        {"classcode":classcode,"startTime":startTime,"endTime":endTime},
                        function (processAttenceOriginals) {
                            showAttenceOriginal(processAttenceOriginals)
                        }
                );
            }
        }

        function mohuquery() {
            var name = $('#name_search').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/procedure/getAttenceOriginalsByName",
                    {"name":name},
                    function (processAttenceOriginals) {
                        showAttenceOriginal(processAttenceOriginals)
                    }
            );

        }

        function showAttenceOriginal(processAttenceOriginals) {
            if(null != processAttenceOriginals){
                var length = processAttenceOriginals.length
                $('#tbody_originals').empty()
                for(var i = 0; i < length; i++){
//
                    var processAttenceOriginal = processAttenceOriginals[i]

                    var str = "<tr>"
                    var index = i+1
                    str = str + "<td>" + index + "</td>"
                    str = str + "<td>" + processAttenceOriginal.code + "</td>"
                    str = str + "<td>" + processAttenceOriginal.name  + "</td>"
                    str = str + "<td>" + processAttenceOriginal.classcode + "</td>"
                    str = str + "<td>" + processAttenceOriginal.datee + "</td>"

                    str = str + "<td>" + processAttenceOriginal.week + "</td>"
                    str = str + "<td>" + processAttenceOriginal.timee + "</td>"
                    str = str + "<td>" + processAttenceOriginal.clickTime + "</td>"

                    str = str + "<td>" + processAttenceOriginal.clickResult + "</td>"
                    str = str + "<td>" + processAttenceOriginal.clickAddress + "</td>"
                    if(processAttenceOriginal.clickComment == null){
                        processAttenceOriginal.clickComment = ""
                    }
                    str = str + "<td>" + processAttenceOriginal.clickComment + "</td>"
                    str = str + "<td>" + processAttenceOriginal.clickDevice + "</td>"


                    str = str + "</tr>"

                    $('#tbody_originals').append(str)

                }
            }
        }

        function queryDay(){
            var classcode = $('#classcodes_search2').val()
            var startTime = $('#attenceStartTime_search2').val();
            var endTime = $('#attenceEndTime_search2').val();
            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/procedure/getAttenceDays",
                        {"classcode":classcode,"startTime":startTime,"endTime":endTime},
                        function (processAttenceDays) {
                            showAttenceDays(processAttenceDays)
                        }
                );
            }
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


        function mohuquery2() {
            var name = $('#name_search2').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }
            var startChar = name.substr(0,3).toUpperCase().charAt(0);
            if (startChar >= 'A' && startChar <= 'Z') {
                $.post(
                    "/procedure/getAttenceDaysByCode",
                    {"code":name},
                    function (processAttenceDays) {
                        showAttenceDays(processAttenceDays)
                    }
                );
            } else {
                $.post(
                    "/procedure/getAttenceDaysByName",
                    {"name":name},
                    function (processAttenceDays) {
                        showAttenceDays(processAttenceDays)
                    }
                );
            }
        }


        function summarQuery(){
            var classcode = $('#classcodes_search3').val()
            var month = $('#month3').val();

            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/procedure/getSummary",
                        {"classcode":classcode,"month":month},
                        function (processAttenceSummarys) {
                            showAttenceSummarys(processAttenceSummarys, month);
                        }
                )
            }

        }

        function showAttenceSummarys(processAttenceSummarys, month) {
            $('#tbody_summary').empty()
            var length = processAttenceSummarys.length
            for(var i = 0; i < length; i++){
                var processAttenceSummary = processAttenceSummarys[i]
                var index = i+1
                var str = "<tr>"
                str = str + "<td>" + index +"</td>"
                str = str + "<td>" + processAttenceSummary.code +"</td>"
                str = str + "<td>" + processAttenceSummary.name +"</td>"
                str = str + "<td>" + processAttenceSummary.classcode +"</td>"
                if(month != null && month.length > 0){
                    str = str + "<td>" + month +"</td>"
                }else{
                    str = str + "<td>" + processAttenceSummary.month +"</td>"
                }

                str = str + "<td>" + processAttenceSummary.days +"</td>"
                str = str + "<td>" + processAttenceSummary.lates +"</td>"
                str = str + "<td>" + processAttenceSummary.lateTimes +"</td>"
                str = str + "<td>" + processAttenceSummary.earlyLefts +"</td>"
                str = str + "<td>" + processAttenceSummary.earlyLeftTimes +"</td>"
                str = str + "<td>" + processAttenceSummary.lackClicks_1 +"</td>"
                str = str + "<td>" + processAttenceSummary.lackClicks_2 +"</td>"

                str = str + "<td>" + processAttenceSummary.absentDays +"</td>"
                str = str + "<td>" + processAttenceSummary.absent_things +"</td>"
                str = str + "<td>" + processAttenceSummary.absent_ills +"</td>"
                str = str + "</tr>"

                $('#tbody_summary').append(str)

            }

        }

        function mohuquery3() {
            var name = $('#name_search3').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            var startChar = name.substr(0,3).toUpperCase().charAt(0);
            if (startChar >= 'A' && startChar <= 'Z') {
                $.post(
                    "/procedure/getAttenceSummaryByCode",
                    {"code":name},
                    function (processAttenceSummarys) {
                        showAttenceSummarys(processAttenceSummarys,null)
                    }
                );
            } else {
                $.post(
                    "/procedure/getAttenceSummaryByName",
                    {"name":name},
                    function (processAttenceSummarys) {
                        showAttenceSummarys(processAttenceSummarys,null)
                    }
                );
            }
        }



        function onDownload() {
            //window.open("/corporiate/onDownload");
            window.location.href="/procedure/onDownload";
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
                <h1 class="page-header">学员考勤</h1>
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
                            <li class="active"><a href="#clickrecord" data-toggle="tab">打卡记录</a>
                            </li>
                            <li><a href="#everyday" data-toggle="tab">每日统计</a>
                            </li>
                            <li><a href="#monthsummary" data-toggle="tab">月度汇总</a>
                            </li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="margin-top: 30px">
                            <div class="tab-pane fade in active" id="clickrecord">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="col-lg-9" style="background: #dddddd">

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
                                                        <td>班级:</td>
                                                        <td>
                                                            <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                                                <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                                    <option value="${classcode}">${classcode}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td>开始:</td>
                                                        <td>
                                                            <input type="date" id="attenceStartTime_search" class = "form-control" placeholder = "开始时间" style="display: inline;min-width: 150px">
                                                        </td>
                                                        <td>结束:</td>
                                                        <td>
                                                            <input type="date" id="attenceEndTime_search" class = "form-control" placeholder = "结束时间" style="display: inline;min-width: 150px">
                                                        </td>

                                                        <td></td>
                                                        <td>
                                                            <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">条件查询</button>
                                                        </td>
                                                    </tr>
                                                </table>


                                            </div>
                                            <div class="col-lg-3" style="background: #eeeeee">
                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                                    <tr>

                                                        <td>
                                                            &emsp; &emsp; <input  id="name_search" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;display: inline;">
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
                                <div class="row">
                                    <div class="panel-body">
                                        <div class="table-responsive" style="height: 600px">
                                            <table id="cardRecord" class="table table-striped table-bordered table-hover">
                                                <thead >
                                                    <tr>
                                                        <th>#</th>
                                                        <th>学员编号</th>
                                                        <th>学员姓名</th>
                                                        <th>班级编号</th>
                                                        <th>考勤日期</th>
                                                        <th>星期</th>
                                                        <th>考勤时间</th>
                                                        <th>打卡时间</th>
                                                        <th>打卡结果</th>
                                                        <th>打卡地址</th>
                                                        <th>打卡备注</th>
                                                        <th>打卡设备</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="tbody_originals">
                                                </tbody>
                                            </table>

                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                </div>
                                <div class="row" >
                                    <div class="col-lg-12" style="float:right">
                                        <form id='attenceSumbit' class="form-inline" role="form"   action="/procedure/importAttence" method="post" enctype="multipart/form-data" style="float:right;">
                                            <div class="panel panel-default">
                                                <div class="panel-body">
                                                    <button type="button" class="btn btn-primary" onclick="onDownload()" style="margin-right: 50px;">标准学员信息模板下载</button>
                                                    </select> <input type="file" name="excelFile" id="excelFile" class="file-loading" multiple accept=".xls,.xlsx" style="display: inline">
                                                    <input type="submit" name="upload" value="导入学员信息" class="btn btn-primary">
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="everyday">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="col-lg-9" style="background: #dddddd">

                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                    <tr>
                                                        <td>中心:</td>
                                                        <td>
                                                            <select  class="form-control" id="centers_search2" style="min-width: 150px">
                                                                <option value="-1">全部</option>
                                                                <c:forEach var="center" items="${requestScope.centers}" >
                                                                    <option value="${center.cid}">${center.cname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>班主任:</td>
                                                        <td>
                                                            <select class="form-control" id="classteachers_search2" style="min-width: 150px">

                                                                <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                                    <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>班级:</td>
                                                        <td>
                                                            <select class="form-control" id="classcodes_search2" style="min-width: 150px">
                                                                <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                                    <option value="${classcode}">${classcode}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td>开始:</td>
                                                        <td>
                                                            <input type="date" id="attenceStartTime_search2" class = "form-control" placeholder = "开始时间" style="display: inline;min-width: 150px">
                                                        </td>
                                                        <td>结束:</td>
                                                        <td>
                                                            <input type="date" id="attenceEndTime_search2" class = "form-control" placeholder = "结束时间" style="display: inline;min-width: 150px">
                                                        </td>

                                                        <td></td>
                                                        <td>
                                                            <button type="button" class="btn btn-primary" onclick="queryDay()" style="min-width: 150px">条件查询</button>
                                                        </td>
                                                    </tr>
                                                </table>


                                            </div>
                                            <div class="col-lg-3" style="background: #eeeeee">
                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                                    <tr>

                                                        <td>
                                                            &emsp; &emsp; <input  id="name_search2" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;display: inline;">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&emsp; &emsp; <button type="button" class="btn btn-primary"  onclick="mohuquery2()" style="width: 150px;display: inline;">模糊查询</button></td>
                                                    </tr>
                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="panel-body">
                                        <div class="table-responsive" style="height: 600px">
                                            <table class="table table-striped table-bordered table-hover">
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
                                                <tbody id="tbody_days">
                                                </tbody>
                                            </table>

                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                </div>
                            </div>
                            <div class="tab-pane fade" id="monthsummary">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="panel panel-default">
                                                <div class="col-lg-9" style="background: #dddddd">

                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td>中心:</td>
                                                            <td>
                                                                <select  class="form-control" id="centers_search3" style="min-width: 150px">
                                                                    <option value="-1">全部</option>
                                                                    <c:forEach var="center" items="${requestScope.centers}" >
                                                                        <option value="${center.cid}">${center.cname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td>班主任:</td>
                                                            <td>
                                                                <select class="form-control" id="classteachers_search3" style="min-width: 150px">

                                                                    <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                                        <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td>班级:</td>
                                                            <td>
                                                                <select class="form-control" id="classcodes_search3" style="min-width: 150px">
                                                                    <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                                        <option value="${classcode}">${classcode}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>

                                                        </tr>
                                                        <tr>
                                                            <td>月份:</td>
                                                            <td>
                                                                <input id="month3" class = "form-control form_datetime" type="text" style="display: inline;min-width: 150px">
                                                            </td>


                                                            <td></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="summarQuery()" style="min-width: 150px">条件查询</button>
                                                            </td>
                                                        </tr>
                                                    </table>


                                                </div>
                                                <div class="col-lg-3" style="background: #eeeeee">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                                        <tr>

                                                            <td>
                                                                &emsp; &emsp; <input  id="name_search3" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;display: inline;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&emsp; &emsp; <button type="button" class="btn btn-primary"  onclick="mohuquery3()" style="width: 150px;display: inline;">模糊查询</button></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="panel-body">
                                        <div class="table-responsive" style="height: 600px">
                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>学员编号</th>
                                                    <th>学员姓名</th>
                                                    <th>班级编号</th>
                                                    <th>考勤月份</th>
                                                    <th>出勤天数</th>
                                                    <th>迟到次数</th>
                                                    <th>迟到时长(分钟)</th>
                                                    <th>早退次数</th>
                                                    <th>早退时长(分钟)</th>
                                                    <th>上班缺卡次数</th>
                                                    <th>下班缺卡次数</th>
                                                    <th>矿工天数</th>
                                                    <th>事假(小时)</th>
                                                    <th>病假(小时)</th>
                                                </tr>
                                                </thead>
                                                <tbody id="tbody_summary">
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
