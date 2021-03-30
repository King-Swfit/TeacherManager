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

        function onNew() {
            var center_name = $("#new_name").val();
            var center_address = $("#new_address").val();
            var center_tel = $("#new_tel").val();
            if(center_tel == null){
                center_tel = ""
            }

            if(null == center_name || center_name.length == 0 ||
                    null == center_address || center_address.length == 0
            ){
                alert("请将中心信息填写完整");
                return;
            }

            $.post(
                    "/jiaowu/new",
                    {"cname":center_name, "caddress":center_address, "ctel":center_tel},
                    function (data) {
                        alert(data);

                        $("#new_name").val("");
                        $("#new_address").val("");
                    }
            );

        }

        function onDelete(){
            var value=$("#centers_delete").val();
            var arr = value.split("&&");
            var cid = arr[0];

            $.post(
                    "/jiaowu/delete",
                    {"cid":cid},
                    function (data) {
                        alert(data);
                        $.get(
                                "/jiaowu/centerList",
                                function (data) {
                                    refreshDeleteUI(data);
                                }
                        );

                    }
            );
        }

        function onEdit() {
            var center_cid = $("#centers_edit").val();
            var center_name = $("#cname_edit").val();
            var center_address = $("#address_edit").val();
            var chargerId = $("#teachers_edit").val().split("&&")[0];

            if(null == center_name || center_name.length == 0 ||
                    null == center_address || center_address.length == 0
            ){
                alert("请将中心信息填写完整");
                return;
            }

            $.post(
                    "/jiaowu/edit",
                    {"cid":center_cid, "cname":center_name, "caddress":center_address, "chargerId":chargerId},
                    function (data) {
                        alert(data);
                        $.get(
                                "/jiaowu/centerList",
                                function (data) {
                                    refreshUpdateUI(data);
                                }
                        );
                    }
            );

        }

        function updateModifyUI(data) {
            $("#cname_edit").val(data.cname);
            $("#address_edit").val(data.address);

            //负责人
            $("#teachers_edit").val(data.charger.tid+"&&"+data.charger.tel+"&&"+data.charger.email);
            $("#tel_edit").val(data.charger.tel);
            $("#email_edit").val(data.charger.email);
        }


        function refreshQueryUI(data) {
            $("#query_tbody").empty();

            for (var i = 0; i < data.length; i++) {
                var center = data[i];
                var str = "<tr class='even gradeA'>";
                var index = i+1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td>" + center.cname + "</td>";
                str = str + "<td>" + center.address + "</td>";
                if(center.chargerId > 0){
                    str = str + "<td>" + center.charger.tname + "</td>";
                    str = str + "<td>" + center.charger.tel + "</td>";
                    str = str + "<td>" + center.charger.email + "</td>";
                }else{
                    str = str + "<td></td>";
                    str = str + "<td></td>";
                    str = str + "<td></td>";
                }

                str = str + "<td>" + center.createTime + "</td>";
                str = str + "</tr>";

                $("#query_tbody").append(str);

            }
        }


        function refreshUpdateUI(data){
            $("#centers_edit").empty();

            for (var i = 0; i < data.length; i++) {
                var center = data[i];
                if(i == 0){
                    $("#centers_edit").append("<option value='"+ center.cid +"' selected='selected'>" + center.cname + "</option>")
                }else{
                    $("#centers_edit").append("<option value='"+ center.cid +"'>" + center.cname + "</option>")
                }
            }

            if(data.length > 0){
                $("#cname_edit").val(data[0].cname);
                $("#address_edit").val(data[0].address);
                if(data[0].charger != null){
                    $("#teachers_edit").val(data[0].charger.tid + "&&" + data[0].charger.tel + "&&" + data[0].charger.email);
                    $("#tel_edit").val(data[0].charger.tel);
                    $("#email_edit").val(data[0].charger.email);
                }else{
                    $("#teachers_edit").val("");
                    $("#tel_edit").val("");
                    $("#email_edit").val("");
                }

            }

        }

        function refreshDeleteUI(data){
            $("#centers_delete").empty();

            for (var i = 0; i < data.length; i++) {
                var center = data[i];
                if(i == 0){
                    if(center.charge == null){
                        $("#centers_delete").append("<option value='"+ center.cid +"&&" + center.cname + "&&" + center.address +"' selected='selected'>" + center.cname + "</option>")
                    }else{
                        $("#centers_delete").append("<option value='"+ center.cid +"&&" + center.cname + "&&" + center.address + "&&" + center.charger.tname + "&&" + center.charger.tel + "&&" + center.charger.email +"' selected='selected'>" + center.cname + "</option>")
                    }

                }else{
                    if(center.charge == null){
                        $("#centers_delete").append("<option value='"+ center.cid +"&&" + center.cname + "&&" + center.address +"'>" + center.cname + "</option>")
                    }else{
                        $("#centers_delete").append("<option value='"+ center.cid +"&&" + center.cname + "&&" + center.address + "&&" + center.charger.tname + "&&" + center.charger.tel + "&&" + center.charger.email +"'>" + center.cname + "</option>")
                    }

                }
            }

            if(data.length > 0){
                $("#cname_delete").val(data[0].cname);
                $("#address_delete").val(data[0].address);
                if(data[0].charger != null){
                    $("#teachers_delete").val(data[0].charger.tid + "&&" + data[0].charger.tel + "&&" + data[0].charger.email);
                    $("#tel_delete").val(data[0].charger.tel);
                    $("#email_delete").val(data[0].charger.email);
                }else{
                    $("#teachers_delete").val("");
                    $("#tel_delete").val("");
                    $("#email_delete").val("");
                }

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
                    <h1 class="page-header">教学中心</h1>
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
                                <li id="q" class="active"><a href="#query" data-toggle="tab">查询中心</a>
                                </li>
                                <li id="c" ><a href="#create" data-toggle="tab">创建中心</a>
                                </li>
                                <li id="u"><a href="#update" data-toggle="tab">编辑中心</a>
                                </li>
                                <li id="d"><a href="#delete" data-toggle="tab">删除中心</a>
                                </li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="margin-top: 30px">
                                <div class="tab-pane fade in active" id="query">
                                    <h4 style=" text-align:center;">查询中心</h4>
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-bordered table-hover" >
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>中心名称</th>
                                                        <th>中心地址</th>
                                                        <th>中心负责人</th>
                                                        <th>联系电话</th>
                                                        <th>邮箱</th>
                                                        <th>创建时间</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="query_tbody">
                                                    <c:forEach var="center" items="${requestScope.centers}" begin="0" step="1" varStatus="i">
                                                        <tr>
                                                            <td>${i.index + 1}</td>
                                                            <td>${center.cname}</td>
                                                            <td>${center.address}</td>
                                                            <td>${center.charger.tname}</td>
                                                            <td>${center.charger.tel}</td>
                                                            <td>${center.charger.email}</td>
                                                            <td>${center.createTime}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                </div>
                                <div class="tab-pane fade" id="create" >
                                    <h4 style=" text-align:center;">创建中心</h4>
                                    <form role="form">

                                        <div class="form-group">
                                            <label>中心名称</label>
                                            <input id="new_name" class="form-control" placeholder="输入文字">
                                        </div>
                                        <div class="form-group">
                                            <label>中心地址</label>
                                            <input id="new_address" class="form-control" placeholder="输入文字">
                                        </div>
                                        <div class="form-group">
                                            <label>中心负责人</label>
                                            <select type="select" id="new_teachers" class="form-control">
                                                <c:forEach var="teacher" items="${requestScope.teachers}">
                                                    <option value="${teacher.tel}&&${teacher.email}">${teacher.tname}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>联系电话</label>
                                            <input id="new_tel" class="form-control" value="${requestScope.teachers[0].tel}" disabled>
                                        </div>
                                        <div class="form-group">
                                            <label>邮箱</label>
                                            <input id="new_email" class="form-control" placeholder="输入文字" value="${requestScope.teachers[0].email}" disabled>
                                        </div>

                                        <div class="col-lg-6" style="text-align:center;">
                                            <button type="submit" class="btn btn-default" onclick="onNew()">提&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交</button>
                                        </div>
                                        <div class="col-lg-6" style="text-align:center;">
                                            <button type="reset" class="btn btn-default">重&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;置</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="tab-pane fade" id="update">
                                    <h4 style=" text-align:center;">编辑中心</h4>
                                    <div class="form-group">
                                        <label>请选择要编辑的教学中心</label>

                                        <select type="select" id="centers_edit" class="form-control">
                                            <c:forEach var="center" items="${requestScope.centers}" >
                                                <option value="${center.cid}">${center.cname}</option>
                                            </c:forEach>
                                        </select>

                                        <form role="form" style="margin-top: 20px">

                                            <div class="form-group">
                                                <label>中心名称</label>
                                                <input id="cname_edit" class="form-control" placeholder="输入文字" value="${requestScope.centers[0].cname}">
                                            </div>
                                            <div class="form-group">
                                                <label>中心地址</label>
                                                <input id="address_edit" class="form-control" placeholder="输入文字" value="${requestScope.centers[0].address}">
                                            </div>
                                            <div class="form-group">
                                                <label>中心负责人</label>
                                                <select type="select" id="teachers_edit" class="form-control">
                                                    <c:forEach var="teacher" items="${requestScope.teachers}" >
                                                        <c:choose>
                                                            <c:when test="${requestScope.centers[0].charger.tid == teacher.tid}">
                                                                <option value="${teacher.tid}&&${teacher.tel}&&${teacher.email}">${teacher.tname}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${teacher.tid}&&${teacher.tel}&&${teacher.email}">${teacher.tname}</option>
                                                            </c:otherwise>
                                                        </c:choose>

                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>联系电话</label>
                                                <input id="tel_edit" class="form-control" placeholder="输入文字" value="${requestScope.centers[0].charger.tel}" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>邮箱</label>
                                                <input id="email_edit" class="form-control" placeholder="输入文字" value="${requestScope.centers[0].charger.email}" disabled>
                                            </div>
                                            <div class="col-lg-6" style="text-align:center;">
                                                <button type="submit" onclick="onEdit()" class="btn btn-default">提&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交</button>
                                            </div>
                                            <div class="col-lg-6" style="text-align:center;">
                                                <button type="reset" class="btn btn-default">重&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;置</button>
                                            </div>

                                        </form>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="delete">
                                    <h4 style=" text-align:center;">删除中心</h4>
                                    <div class="form-group">
                                        <label>请选择要删除的教学中心</label>
                                        <select type="select" id="centers_delete" class="form-control">
                                            <c:forEach var="center" items="${requestScope.centers}" >
                                                <c:choose>
                                                    <c:when test="${not empty center.charger}">
                                                        <option value="${center.cid}&&${center.cname}&&${center.address}&&${center.charger.tname}&&${center.charger.tel}&&{center.charger.email}">${center.cname}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${center.cid}&&${center.cname}&&${center.address}">${center.cname}</option>
                                                    </c:otherwise>
                                                </c:choose>

                                            </c:forEach>
                                        </select>

                                        <form role="form" style="margin-top: 50px">

                                            <div class="form-group">
                                                <label>中心名称</label>
                                                <input id="cname_delete" class="form-control"  value="${requestScope.centers[0].cname}" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>中心地址</label>
                                                <input id="address_delete" class="form-control"  value="${requestScope.centers[0].address}" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>中心负责人</label>
                                                <input id="tname_delete" class="form-control"  value="${requestScope.centers[0].charger.tname}" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>联系电话</label>
                                                <input id="tel_delete" class="form-control"  value="${requestScope.centers[0].charger.tel}" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>邮箱</label>
                                                <input id="email_delete" class="form-control"  value="${requestScope.centers[0].charger.email}" disabled>
                                            </div>
                                            <div class="col-lg-12" style="text-align:center;">
                                                <button type="submit" onclick="onDelete()" class="btn btn-default">删&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;除</button>
                                            </div>

                                        </form>
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
