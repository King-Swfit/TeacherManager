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




    <style type="text/css">
        .table {table-layout:fixed;}
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }

        table td{
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
        }

        table td:hover { /* 鼠标滑过  显示隐藏的内容  伴有横向的滚动条 */
            width:200px;
            overflow:auto;
            text-overflow:clip;
        }
    </style>

    <script type="text/javascript">
//        var ue = UM.getEditor('myEditor');
        $(function(){

            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_search").empty()
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



            $("#classteachers_search").change(function(){
                var ctid=$("#classteachers_search").val();
                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClid",
                            {"ctid":ctid},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_search").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_search").append(str)
                                }

                            }
                    );
                }

            })


            $("#centers_create").change(function(){
                var centerId=$("#centers_create").val();
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_create").empty()
                                var length = data.length
                                var str = "<option value='0'>无</option>"
                                for(var i = 0; i < length; i++){
                                    var classTeacher = data[i]
                                    str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                                }
                                $("#classteachers_create").append(str)
                            }

                        }
                );
            })


            $("#classteachers_create").change(function(){
                var ctid=$("#classteachers_create").val();
                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClid",
                            {"ctid":ctid},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_create").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_create").append(str)
                                }

                            }
                    );
                }else{
                    alert("请选择正确的班主任")
                }




            })
        });

    function createActivity(){
        var classcode = $("#classcodes_create").val()
        if(null == classcode || classcode.length == 0){
            alert("请选择班级编号")
            return
        }

        window.location.href = "/class/createActivity?classcode="+classcode;

    }

    function queryNews() {
        var classcode = $("#classcodes_search").val()
        $.post(
                "/class/newsByClasscode",
                {"classcode":classcode},
                function (data) {
                    if(data.newses != null){
                        var length = data.newses.length
                        $("#tbody_activity").empty()
                        for(var i = 0; i < length; i++){
                            var news = data.newses[i]
                            var str = "<tr>"
                            var index = i+1
                            str = str + "<td>" + index + "</td>"
                            str = str + "<td>" + news.title + "</td>"
                            str = str + "<td>" + news.createTime + "</td>"
                            str = str + "<td><a href='javascript:void(0)' onclick='news_content(" + news.id + ")'" + ">浏览</a></td>"
                            str = str + "</tr>"

                            $("#tbody_activity").append(str)
                        }

                    }

                }
        );

    }


    function news_content(newsId) {
        $.post(
                "/class/news_content",
                {"newsId":newsId},
                function (data) {
                    $("#play").attr("href", "/class/news_content?newsId="+newsId)
                    if(data != null){

                        $("#play").attr("href", "/class/news_content2?newsId="+newsId)

                        $("#news_container").empty()
                        $("#news_container").html(data.newsContent)
                    }

                }
        );
    }





        //弹出对话框，在对话框中编辑
        function editClass(clid, index){
            var rows = $('#tbody_course').find("tr")
            var tdArr = rows.eq(index).find("td");

            tdArr.eq(5).find("select").removeAttr("disabled");
            tdArr.eq(6).find("input").attr("readonly",false)
            tdArr.eq(7).find("input").attr("readonly",false)
            tdArr.eq(8).find("select").removeAttr("disabled");
            tdArr.eq(9).find("input").attr("readonly",false)
            tdArr.eq(10).find("input").attr("readonly",false)
            tdArr.eq(11).find("input").attr("readonly",false)
            tdArr.eq(12).find("input").attr("readonly",false)

            var i = 12;
            while( i < rows[index].cells.length){
                i = i+2;
                tdArr.eq(i).find("select").removeAttr("disabled");
                for(var j = 0; j < 6; j++){
                    i = i+1
                    tdArr.eq(i).find("input").attr("readonly",false)
                }

            }
        }



        function saveClass(clid , index ){

            var rows = $('#tbody_course').find("tr")
            var tdArr = rows.eq(index).find("td");

            //获取界面值
            var ctid = tdArr.eq(5).find("select").val()
            var beginDate = tdArr.eq(6).find("input").val()
            var initPfx = tdArr.eq(7).find("input").val()
            var state = tdArr.eq(8).find("select").val()
            var preGraducateExamDate = tdArr.eq(9).find("input").val()
            var preGraducateDate = tdArr.eq(10).find("input").val()
            var realGraducateExamDate = tdArr.eq(11).find("input").val()
            var realGraducateDate = tdArr.eq(12).find("input").val()

            var i = 12;

            var courseItems = new Array()
            var j = 0
            while( i < rows[index].cells.length - 8){
                i = i+1;
                var coid = tdArr.eq(i).attr("id")
                i = i+1;
                var tid = tdArr.eq(i).find("select").val()//授课老师
                var dates = new Array()
                for(var k = 0; k < 6; k++){
                    i = i+1
                    dates[k] = tdArr.eq(i).find("input").val()
                }
                courseItems[j]={"coid":coid,"tid":tid, "dates":dates}
                j++
            }

            var json =
            {
                "clid":clid,
                "courseItems":courseItems, "ctid":ctid, "beginDate":beginDate, "initPfx":initPfx, "state":state,
                "preGraducateExamDate":preGraducateExamDate,"preGraducateDate":preGraducateDate,
                "realGraducateExamDate":realGraducateExamDate, "realGraducateDate":realGraducateDate
            }

            $.post(
                    "/class/update",

                    {"data":JSON.stringify(json)},
                    function (data) {
                        alert(data);

                        tdArr.eq(5).find("select").attr("disabled","disabled")
                        tdArr.eq(6).find("input").attr("readonly",true)
                        tdArr.eq(7).find("input").attr("readonly",true)
                        tdArr.eq(8).find("select").attr("disabled","disabled")
                        tdArr.eq(9).find("input").attr("readonly",true)
                        tdArr.eq(10).find("input").attr("readonly",true)
                        tdArr.eq(11).find("input").attr("readonly",true)
                        tdArr.eq(12).find("input").attr("readonly",true)

                        var i = 12;
                        while( i < rows[index].cells.length){
                            i = i+2;
                            tdArr.eq(i).find("select").attr("disabled","disabled")
                            for(var j = 0; j < 6; j++){
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
                    <h1 class="page-header">班级活动</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-5">
                    <div class="panel panel-default">
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="form-inline">

                                <select class="form-control" id="centers_search" >
                                    <c:forEach var="center" items="${requestScope.centers}" begin="0" step="1" varStatus="i">
                                        <c:choose>
                                            <c:when test="${i.index==0}">
                                                <option value="${center.cid}" selected="selected">${center.cname}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${center.cid}">${center.cname}</option>
                                            </c:otherwise>
                                        </c:choose>

                                    </c:forEach>
                                </select>

                                <select class="form-control" id="classteachers_search" >
                                    <c:forEach var="classteacher" items="${requestScope.classteachers}" begin="0" step="1" varStatus="i">
                                        <c:choose>
                                            <c:when test="${i.index==0}">
                                                <option value="${classteacher.ctid}" selected="selected">${classteacher.ctname}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>

                                <select class="form-control" id="classcodes_search" style="width: 100px">
                                </select>
                                <button class="btn btn-default" style="float: right" onclick="queryNews()">查询活动</button>
                            </div>
                            <div class="table-responsive" style="margin-top: 30px;height: 600px">
                                <table class="table  table-hover text-nowrap" >
                                    <thead>
                                        <tr>
                                            <th width="5%">#</th>
                                            <th width="50%">活动标题</th>
                                            <th width="25%">活动时间</th>
                                            <th width="10%">浏览</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody_activity">
                                        <c:if test="${not empty requestScope.newses}">
                                            <c:forEach var="news" items="${requestScope.newses}" begin="0" step="1" varStatus="i">
                                                <tr>
                                                    <td>${i.index + 1}</td>
                                                    <td>${news.title}</td>
                                                    <td>${news.createTime}</td>
                                                    <td><a href="javascript:void(0)" onclick="news_content(${news.id})">浏览</a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <div class="form-inline" style="margin-top: 30px">
                                <select class="form-control" id="centers_create" >
                                    <c:forEach var="center" items="${requestScope.centers}">
                                        <option value="${center.cid}">${center.cname}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-control" id="classteachers_create" >
                                    <c:forEach var="classteacher" items="${requestScope.classteachers}">
                                        <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-control" id="classcodes_create" style="width: 100px">
                                </select>
                                <button class="btn btn-default" style="float: right" onclick="createActivity()">创建活动</button>
                                <%--<a href="javascript:void(0)" onclick="createActivity()" style="float: right">创建活动</a>--%>
                            </div>
                        </div>

                    </div>
                </div>
                    <!-- /.panel -->
                <!-- /.col-lg-6 -->
                <div class="col-lg-7">
                    <div class="panel panel-default">
                        <div id="news_container" class="panel-body" style="width:100%;height: 750px;overflow:scroll;">
                            文章内容
                        </div>
                    </div>
                    <a href="/class/news_content2?newsId=-1" id="play">全屏播放</a>
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
