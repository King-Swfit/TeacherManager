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
    </style>

    <script type="text/javascript">
        //        var ue = UM.getEditor('myEditor');
        $(function(){

            $("#classteachers_search").change(function(){
                var ctid=$("#classteachers_search").val();
                if(ctid != null && ctid > 0){
                    $.post(
                            "/corporiate/getCoporiationsByMasterId",
                            {"masterid":ctid},
                            function (cnames) {
                                $("#ctdivcontainer").empty()
                                if(cnames != null){
                                    var length = cnames.length
                                    var str = ""
                                    for(var i = 0; i < length; i++){
                                        str = str + "<div class='checkbox'> <label><input type='checkbox' value='" + cnames[i] +"'>" + cnames[i] + "</label> </div>"
                                    }

                                    $("#ctdivcontainer").append(str)

                                }

                            }
                    );
                }

            })

        });



        function releaseCoriporation() {
            var ctid=$("#classteachers_search").val();
            var ckl = [];
            $("input[name='ckl']:checked").each(
                    function(i){
                        ckl[i] = $(this).val();
                    }
            );

            var json = {"ckl":ckl}
            if(ckl.length > 0){
                $.post(
                        "/corporiate/releaseCoporiations",
                        {"data":JSON.stringify(json)},
                        function (res) {
                            if(res != null && res == "success"){
                                refreshLeft(ctid)
                                refreshRight()
                            }

                        }
                );
            }
        }

        function assignCoriporation() {
            var ctid=$("#classteachers_search").val();

            var ckr = [];
            $("input[name='ckr']:checked").each(
                    function(i){
                        ckr[i] = $(this).val();
                     }
            );

            var json = {"ctid":ctid,"ckr":ckr}
            if(ctid != null && ckr.length > 0){

                $.post(
                        "/corporiate/assignCoporiations",
                        {"data":JSON.stringify(json)},
                        function (res) {
                            if(res != null && res == "success"){
                                refreshLeft(ctid)
                                refreshRight()
                            }

                        }
                );


            }
        }

        function refreshLeft(ctid) {
            $.post(
                    "/corporiate/getCoporiationsByMasterId",
                    {"masterid":ctid},
                    function (cnames) {
                        $("#ctdivcontainer").empty()
                        if(cnames != null){
                            var length = cnames.length
                            var str = ""
                            for(var i = 0; i < length; i++){
                                str = str + "<div class='checkbox'> <label><input type='checkbox' value='" + cnames[i] + "' name='ckl'>" + cnames[i] + "</label> </div>"
                            }

                            $("#ctdivcontainer").append(str)

                        }

                    }
            );
        }

        function refreshRight() {
            $.post(
                    "/corporiate/getCoporiationsNoMaster",
                    {},
                    function (notcnames) {
                        $("#divcontainer").empty()
                        if(notcnames != null){
                            var length = notcnames.length
                            var str = ""
                            for(var i = 0; i < length; i++){
                                str = str + "<div class='checkbox'> <label><input type='checkbox' value='" + notcnames[i] + "' name='ckr'>" +notcnames[i] + "</label> </div>"
                            }

                            $("#divcontainer").append(str)

                        }

                    }
            );
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
            ????????????:<sec:authentication property="name"/>
        </div>
        <!-- /.navbar-header -->


        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">

                    <li>
                        <a href="#"><i class="fa fa-sitemap fa-fw"></i> ????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/class/new">????????????</a>
                            </li>
                            <li>
                                <a href="/class/baseInfo">????????????</a>
                            </li>
                            <li>
                                <a href="/class/trainee">????????????</a>
                            </li>
                            <li>
                                <a href="/class/activity">????????????</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-cubes fa-fw"></i> ??????????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/procedure/talkwork">????????????</a>
                            </li>
                            <li>
                                <a href="/procedure/score">????????????</a>
                            </li>
                            <li>
                                <a href="/procedure/attence">????????????</a>
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-rocket fa-fw"></i> ??????????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/employ/dynamicData">??????????????????</a>
                            </li>
                            <li>
                                <a href="/employ/summary">????????????</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> ??????????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/corporiate/connectRecord">??????????????????</a>
                            </li>
                            <li>
                                <a href="/corporiate/corporationBaseInfo">??????????????????</a>
                            </li>
                            <li>
                                <a href="/corporiate/assignCorporation">??????????????????</a>
                            </li>
                            <li>
                                <a href="/corporiate/manageCorporation">??????????????????</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-th fa-fw"></i> ???????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/work/summary">????????????</a>
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-gears fa-fw"></i> ????????????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">

                            <li>
                                <a href="/jiaowu/xueji">????????????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/score">????????????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/traineeInfo">??????????????????</a>
                            </li>

                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="#"><i class="fa  fa-empire fa-fw"></i> ??????<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/jiaowu/center">????????????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/direction">????????????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/course">????????????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/teacher">??????</a>
                            </li>
                            <li>
                                <a href="/jiaowu/classteacher">?????????</a>
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
                <h1 class="page-header">??????????????????</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-5">
                <select class="form-control" id="classteachers_search" style="height:35px;margin-bottom: 5px;" >
                    <c:forEach var="classteacher" items="${requestScope.classteachers}">
                        <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                    </c:forEach>
                </select>
                <div class="panel panel-default">
                    <div class="panel-body" style="height: 600px;" id="ctdivcontainer">
                        <c:forEach var="cname" items="${requestScope.cnames}">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="${cname}" name="ckl">${cname}
                                </label>
                            </div>
                        </c:forEach>
                    </div>

                </div>
            </div>
            <div class="col-lg-1">
                <div style="text-align: center;margin-top: 200px;">
                    <img src="/img/arrow_left.png" onclick="assignCoriporation()" style="width:80px;margin-bottom: 50px;"></div>
                    <img src="/img/arrow_right.png" onclick="releaseCoriporation()" style="width:80px;margin-top: 50px;"></div>
            <div class="col-lg-6">
                <label style="height: 35px;margin-bottom: 5px;">??????????????????</label>
                <div class="panel panel-default">
                    <div id="divcontainer" class="panel-body" style="height: 600px;overflow:scroll;">
                        <c:forEach var="cname" items="${requestScope.notcnames}">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="${cname}" name="ckr">${cname}
                                </label>
                            </div>

                        </c:forEach>
                    </div>
                </div>
                <!-- /.panel -->
            </div>
        </div>


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
