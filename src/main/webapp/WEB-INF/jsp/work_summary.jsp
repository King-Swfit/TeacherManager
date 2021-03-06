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
            //???????????????????????????9????????????0
            var day = ("0" + now.getDate()).slice(-2);
            //???????????????????????????9????????????0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //????????????????????????
            var today = now.getFullYear() + "-" + (month);


            $('.form_datetime').datetimepicker({
                format: 'yyyy-mm',
                autoclose: true,
                todayBtn: true,
                startView: 'year',
                minView:'year',
                maxView:'decade',
                language:  'zh-CN',
            });
            $('#month_search').val(today);

        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        function query(){
            var classteacherId = $('#classteachers_search').val()
            var month = $('#month_search').val()

            $.post(
                    "/work/querySummary",
                    {"classteacherId":classteacherId,"month":month},
                    function (workSummaries) {
                        if (null != workSummaries) {

                            $('#tbody_summarys').empty()
                            var length = workSummaries.length
                            for (var i = 0; i < length; i++) {
                                var workSummarie = workSummaries[i]
                                str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + workSummarie.ctname + "</td>"
                                str = str + "<td>" + workSummarie.classcode + "</td>"

                                str = str + "<td>" + workSummarie.talkCount + "</td>"
                                str = str + "<td>" + workSummarie.recommandResult + "</td>"
                                str = str + "<td>" + workSummarie.connectResult + "</td>"


                                str = str + "</tr>"

                                $('#tbody_summarys').append(str)
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

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">?????????????????????</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">

                    <div class="panel-body">

                        <div class="row">
                            <div class="col-lg-12">
                                <div class="panel panel-default">

                                    <div class="panel-body">
                                        <div class="col-lg-3">
                                            <div class = "form-inline">
                                                <label>?????????:</label>
                                                <select  class="form-control" id="classteachers_search" style="min-width: 150px">
                                                    <option value="-1">??????</option>
                                                    <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                        <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-lg-4">
                                            <div class = "form-inline">
                                                <label >????????????:</label>
                                                <input id="month_search" class = "form-control form_datetime" type="text" style="display: inline;min-width: 150px">
                                            </div>
                                        </div>


                                        <div class="col-lg-2" style="text-align: right">
                                            <button type="button" class="btn btn-primary" style="min-width: 150px" onclick="query()">????????????</button>
                                        </div>

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
                                            <thead id="thead_talks">
                                                <th>#</th>
                                                <th>?????????</th>
                                                <th>??????</th>
                                                <th>????????????</th>
                                                <th>????????????</th>
                                                <th>????????????</th>

                                            </thead>
                                            <tbody id="tbody_summarys">
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
