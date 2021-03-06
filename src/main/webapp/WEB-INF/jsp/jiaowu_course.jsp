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

    <!-- Custom Fonts -->
    <link href="/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="/css/custom.css" rel="stylesheet" type="text/css">

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

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style type="text/css">
        .table {table-layout:fixed;}
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }
    </style>


    <script type="text/javascript">
        $(function() {

            $('.nav-tabs li').click(function(){
                var _id = $(this).attr('id');

                switch(_id){
                    case "q":
                        $.get(
                                "/jiaowu/courseList",
                                function (courseList) {
                                    refreshQueryUI(courseList);
                                }
                        );
                        break;
                    case "c":
                        break;
                    case "u":
                        $.get(
                                "/jiaowu/courseList",
                                function (courseList) {
                                    refreshUpdateUI(courseList);
                                }
                        );
                        break;
                }
            });

        });

        function onEdit(cid){
            var eid = "#" + cid+"_cname"
            $(eid).attr("readonly",false)

            eid = "#" + cid+"_describe"
            $(eid).attr("readonly",false)

            eid = "#" + cid+"_directions"
            $(eid).removeAttr("disabled");


            var trList =$("#tbody_chapter_"+cid).children("tr")
            for (var i=0;i<trList.length;i++) {
                var tdArr = trList.eq(i).find("td");
                tdArr.eq(0).find("input").attr("readonly",false)
                tdArr.eq(1).find("textarea").attr("readonly",false)
                tdArr.eq(2).find("input").attr("readonly",false)
            }

        }

        function onSave(cid) {
            var eid = "#" + cid + "_cname"
            $(eid).attr("readonly", true)
            var cname = $(eid).val()

            eid = "#" + cid + "_describe"
            $(eid).attr("readonly", true)
            var describe = $(eid).val()

            eid = "#" + cid + "_directions"
            $(eid).attr("disabled", "disabled")
            var directionId = $(eid).val()

            var chapters = new Array()
            var trList = $("#tbody_chapter_" + cid).children("tr")
            for (var i = 0; i < trList.length; i++) {
                var tdArr = trList.eq(i).find("td");
                tdArr.eq(0).find("input").attr("readonly", true)
                tdArr.eq(1).find("textarea").attr("readonly", true)
                tdArr.eq(2).find("input").attr("readonly", true)
                chapters[i] = {
                    "cpname": tdArr.eq(0).find("input").val(),
                    "cpdescribe": tdArr.eq(1).find("textarea").val(),
                    "period": tdArr.eq(2).find("input").val()
                }
            }

            //??????????????????
            $.post(
                    "/jiaowu/updateCourse",
                    {"cid": cid, "cname": cname, "describe":describe,"directionId":directionId,"chapters":JSON.stringify(chapters)},
                    function (data) {
                        if (data != null) {
                            if (data=="success") {
                                alert("????????????")
                            }
                        }
                    }
            );
        }

        function newChapter(){
            $('#chapterModal').modal();
        }

        function saveChapter(){
            var cpname = $('#cpname_dlg').val()
            var cpdescribe = $('#cpdescribe_dlg').val()
            var period = $('#period_gld').val()
            if(cpname == null || cpname.length == 0 || cpdescribe == null || cpdescribe.length == 0 || period == null || period.length == 0){
                alert("????????????????????????")
            }else{
                //????????????
                var lowCount = $('#tbody_create').find("tr").length ;
                lowCount = lowCount + 1
                var str = "<tr><td>" + lowCount + "</td>";
                str = str + "<td>" + cpname + "</td>";
                str = str + "<td>" + cpdescribe + "</td>";
                str = str + "<td>" + period + "</td></tr>";
                $('#tbody_create').append(str)
            }
        }

        function saveCourse(){
            var directionId = $('#directions_create').val()
            var cname = $('#cname_create').val()
            var describe = $('#describe_create').val()

            var rows = $('#tbody_create').find("tr")
            var chapters = new Array();
            var i = 0;
            for(var i = 0; i<rows.length; i++ ){
                chapters[i] = {"posInCourse":rows[i].cells[0].innerHTML, "cpname":rows[i].cells[1].innerHTML, "cpdescribe":rows[i].cells[2].innerHTML,"period":rows[i].cells[3].innerHTML }
            }

            var now = new Date();
            //???????????????????????????9????????????0
            var day = ("0" + now.getDate()).slice(-2);
            //???????????????????????????9????????????0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //????????????????????????
            var today = now.getFullYear()+"-"+(month)+"-"+(day) ;

            if(cname == null || cname.length == 0 || describe == null || describe.length == 0){
                alert("???????????????????????????????????????")
            }else{
                $.post(
                        "/jiaowu/new_course",
                        {"directionId":directionId, "cname":cname, "describe":describe,"chapters":JSON.stringify(chapters),"createTime":today},
                        function (data) {
                            alert(data);
                            clearNewCourse()
                        }
                );
            }

        }

        function clearNewCourse() {
            $('#cname_create').val("")
            $('#describe_create').val("")
            $('#tbody_create').empty()
        }

        function chapterContentModal(cid){
            $.get(
                    "/jiaowu/chapters",
                    {"cid":cid},
                    function (data) {
                        if(data == "fail"){
                            alert("??????????????????!")
                        }else{
                            $('#tbody_detail').empty()
                            var count = data.length;
                            for(var i = 0; i < count; i++){
                                var chapter = data[i]
                                var str = "<tr><td>" + chapter.posInCourse + "</td>"
                                str = str + "<td>" + chapter.cpname + "</td>"
                                str = str + "<td>" + chapter.cpdescribe + "</td>"
                                str = str + "<td>" + chapter.period + "</td></tr>"

                                $('#tbody_detail').append(str)
                            }

                            $('#chapterContentModal').modal();
                        }
                    }
            );
        }

        function refreshQueryUI(data) {
            $("#tbody_query").empty()
            if(null != data){
                var courseList = data.courses
                var length = courseList.length
                for(var i = 0; i < length; i++){
                    var course = courseList[i]
                    var index = i+1
                    var str = "<tr>"
                    str = str + "<td>" + index + "</td>"
                    str = str + "<td>" + course.cname + "</td>"
                    str = str + "<td>" + course.describe + "</td>"
                    str = str + "<td>" + course.direction.dname + "</td>"
                    str = str + "<td><a href='javascript:void(0);' onclick='chapterContentModal(" + course.cid + ")'>????????????</a>" + "</td>"
                    str = str + "<td>" + course.createTime + "</td>"
                    str = str + "</tr>"

                    $("#tbody_query").append(str)
                }
            }
        }

        function refreshUpdateUI(data) {
            $("#tbody_update").empty()
            if(null != data){
                var courseList = data.courses
                var directions = data.directions

                var length = courseList.length
                for(var i = 0; i < length; i++){
                    var course = courseList[i]
                    var index = i+1
                    var str = "<tr>"
                    str = str + "<td>" + index + "</td>"
                    str = str + "<td><input id='" + course.cid + "_cname' value='" + course.cname + "' readonly='true' class='form-control'/>" + "</td>"
                    str = str + "<td><textarea id='" + course.cid + "_describe'  readonly='true' class='form-control' rows='3'>" + course.describe + "</textarea></td>"

                    str = str + "<td><select id='" + course.cid + "_directions' class='form-control' disabled>"
                    var length2 = directions.length
                    for(var j = 0; j < length2; j++){
                        var direction = directions[j]
                        if(course.direction.did == direction.did){
                            str = str + "<option value='" + direction.did + "' selected='selected'>" + direction.dname + "</option>"
                        }else{
                            str = str + "<option value='" + direction.did + "'>" + direction.dname + "</option>"
                        }
                    }
                    str = str + "</select></td>"

                    str = str + "<td colspan='3'><table class='table '><tbody id='tbody_chapter_" + course.cid + "'>"
                    var length3 = course.chapters.length
                    for(var k = 0; k < length3; k++){
                        var chapter = course.chapters[k]
                        str = str + "<tr>"
                        str = str + "<td width='30%'><input id='" + chapter.cpid + "_cpname' value='" + chapter.cpname + "' readonly='true' class='form-control'></td>"
                        str = str + "<td width='40%'><textarea id='" + chapter.cpid + "_cpdescribe' rows='3' readonly='true' class='form-control'>" + chapter.cpdescribe + "</textarea></td>"
                        str = str + "<td width='30%'><input id='" + chapter.cpid + "_period' value='" + chapter.period + "' readonly='true' class='form-control'></td>"
                        str = str + "</tr>"
                    }
                    str = str + "</tbody></table> </td>"
                    str = str + "<td>" + course.createTime + "</td>"

                    str = str + "<td>" + "<button type='button' class='btn btn-default' onclick='onEdit(" + course.cid + ")'>??????</button>"
                    str = str + "<button type='button' class='btn btn-default' style='margin-left: 20px' onclick='onSave(" + course.cid + ")'>??????</button>" + "</td>"

                    str = str + "</tr>"

                    $("#tbody_update").append(str)
                }
            }
        }


    </script>

</head>

<body>

<!-- dialog -->
<div class="modal fade" id="chapterModal" tabindex="-1" role="dialog" aria-labelledby="chapterModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">????????????</h4>
            </div>
            <div class="modal-body">
                <table class="table table-striped table-bordered table-hover">
                    <tbody>
                    <tr>
                        <td width="30%">????????????:</td>
                        <td width="70%"><input id="cpname_dlg" class="form-control"  placeholder="????????????"/></td>
                    </tr>
                    <tr>
                        <td>????????????:</td>
                        <td><textarea rows="3" id="cpdescribe_dlg" class="form-control"  placeholder="????????????"></textarea></td>
                    </tr>
                    <tr>
                        <td>????????????(???):</td>
                        <td><input  id="period_gld" type="number" class="form-control"  placeholder="????????????"/></td>
                    </tr>

                    </tbody>
                </table>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button"  class="btn btn-primary" onclick="saveChapter()">??????</button>
            </div>
        </div>
    </div>
</div>
<!-- dialog end-->


<div class="modal fade" id="chapterContentModal" tabindex="-1" role="dialog" aria-labelledby="chapterContentModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">??????????????????</h4>
            </div>
            <div class="modal-body">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th width="20%">????????????</th>
                        <th width="30%">????????????</th>
                        <th width="30%">????????????</th>
                        <th width="20%">????????????(???)</th>
                    </tr>
                    </thead>
                    <tbody id="tbody_detail">

                    </tbody>
                </table>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
            </div>
        </div>
    </div>
</div>
<!-- dialog end-->

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
                    <h1 class="page-header">????????????</h1>
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
                                <li id="q" class="active"><a href="#query" data-toggle="tab">????????????</a>
                                </li>
                                <li id="c"><a href="#create" data-toggle="tab">????????????</a>
                                </li>
                                <li id="u"><a href="#update" data-toggle="tab">????????????</a>
                                </li>
                                <%--<li><a href="#delete" data-toggle="tab">????????????</a>--%>
                                <%--</li>--%>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="margin-top: 30px">
                                <div class="tab-pane fade in active" id="query">
                                    <h4 style=" text-align:center;">????????????</h4>
                                    <!-- /.panel-heading -->
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                </tr>
                                                </thead>
                                                <tbody id="tbody_query">
                                                <c:forEach var="course" items="${requestScope.courses}" begin="0" step="1" varStatus="i">
                                                    <tr>
                                                        <td>${i.index + 1}</td>
                                                        <td>${course.cname}</td>
                                                        <td>${course.describe}</td>
                                                        <td>${course.direction.dname}</td>
                                                        <td><a href="javascript:void(0);" onclick="chapterContentModal(${course.cid})">????????????</a></td>
                                                        <td>${course.createTime}</td>
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
                                    <h4 style=" text-align:center;">???????????????</h4>

                                    <div class="form-group">
                                        <label>????????????</label>
                                        <select id="directions_create" class="form-control">
                                            <c:forEach var="direction" items="${requestScope.directions}">
                                                <option value="${direction.did}">${direction.dname}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label>????????????</label>
                                        <input  id="cname_create" class="form-control" placeholder="????????????">
                                    </div>
                                    <div class="form-group">
                                        <label>????????????</label>
                                        <input id="describe_create" class="form-control" placeholder="????????????">
                                    </div>

                                    <label>??????????????????</label><button class="btn btn-default" style="margin-left: 100px" onclick="newChapter()">??????????????????</button>
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                        </tr>
                                        </thead>
                                        <tbody id="tbody_create"></tbody>
                                    </table>

                                    <div class="col-lg-6" style="text-align:center;">
                                        <button type="submit" class="btn btn-default" onclick="saveCourse()">???&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???</button>
                                    </div>
                                    <div class="col-lg-6" style="text-align:center;">
                                        <button type="reset" class="btn btn-default">???&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???</button>
                                    </div>


                                </div>



                                <div class="tab-pane fade" id="update">
                                    <h4 style=" text-align:center;">????????????</h4>
                                    <!-- /.panel-heading -->
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th width="3%" rowspan="2">#</th>
                                                        <th width="10%" rowspan="2">???????????? </th>
                                                        <th width="20%" rowspan="2">????????????</th>
                                                        <th width="10%" rowspan="2">????????????</th>
                                                        <th width="40%" colspan="3">????????????</th>
                                                        <th width="7%" rowspan="2">????????????</th>
                                                        <th width="10%" rowspan="2">??????</th>
                                                    </tr>
                                                    <tr>
                                                        <th >?????? </th>
                                                        <th>????????????</th>
                                                        <th >????????????(???)</th>
                                                    </tr>
                                                </thead>

                                                <tbody id="tbody_update">
                                                    <c:forEach var="course" items="${requestScope.courses}" begin="0" step="1" varStatus="i">
                                                        <tr>
                                                            <td>${i.index + 1}</td>
                                                            <td><input id="${course.cid}_cname"  value="${course.cname}" readonly="true" class="form-control"/></td>
                                                            <td><textarea id="${course.cid}_describe"  readonly="true" class="form-control" rows="3">${course.describe}</textarea></td>
                                                            <td>
                                                                <select id="${course.cid}_directions" class="form-control" disabled>
                                                                    <c:forEach var="direction" items="${requestScope.directions}">
                                                                        <c:choose>
                                                                            <c:when test="${course.direction.did == direction.did}">
                                                                                <option value="${direction.did}" selected="selected">${direction.dname}</option>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <option value="${direction.did}" >${direction.dname}</option>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>

                                                            <td colspan="3">
                                                                <table class="table ">
                                                                    <tbody id="tbody_chapter_${course.cid}">
                                                                        <c:forEach var="chapter" items="${course.chapters}">
                                                                            <tr>
                                                                                <td width="30%"><input id="${chapter.cpid}_cpname" value="${chapter.cpname}" readonly="true" class="form-control"></td>
                                                                                <td width="40%"><textarea id="${chapter.cpid}_cpdescribe" rows="3" readonly="true" class="form-control">${chapter.cpdescribe}</textarea></td>
                                                                                <td width="30%"><input id="${chapter.cpid}_period" value="${chapter.period}" readonly="true" class="form-control"></td>
                                                                            </tr>
                                                                        </c:forEach>

                                                                    </tbody>

                                                                </table>
                                                            </td>

                                                            <td>${course.createTime}</td>
                                                            <td>
                                                                <button type="button" class="btn btn-default" onclick="onEdit(${course.cid})">??????</button>
                                                                <button type="button" class="btn btn-default" style="margin-left: 20px" onclick="onSave(${course.cid})">??????</button>
                                                            </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- /.table-responsive -->
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



</body>

</html>
