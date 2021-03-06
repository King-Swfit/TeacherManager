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

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

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

    <script type="text/javascript">
        $(function() {
            var now = new Date();
            //???????????????????????????9????????????0
            var day = ("0" + now.getDate()).slice(-2);
            //???????????????????????????9????????????0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //????????????????????????
            var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
            var startTime = (now.getFullYear() - 5)+"-"+(month)+"-"+(day) ;
            //????????????
            $('#startTime_q').val(startTime);
            $('#endTime_q').val(today);
            $('#startTime_u').val(startTime);
            $('#endTime_u').val(today);

            $('#date_create').val(today)


            $('.nav-tabs li').click(function(){
                var _id = $(this).attr('id');

                switch(_id){
                    case "q":
                        $.get(
                                "/jiaowu/teacherList",
                                function (teachers) {
                                    efreshQueryUI(teachers);
                                }
                        );
                        break;
                    case "c":
                        break;
                    case "u":
                        $.get(
                                "/jiaowu/teacherList",
                                function (teachers) {
                                    efreshQueryUI(teachers);
                                }
                        );
                        break;
                }
            });

        });
        
        function query() {
            var startTime = $('#startTime_q').val()
            var endTime = $('#endTime_q').val()
            var pid = $('#positions_query').val()
            var tid = $('#teachers_query').val()

            //??????????????????
            $.post(
                    "/jiaowu/getTeacherByCondition",
                    {"startTime": startTime, "endTime": endTime, "pid":pid,"tid":tid},
                    function (teachers) {
                        efreshQueryUI(teachers)
                    }
            );
        }

        function query_u() {
            var startTime = $('#startTime_u').val()
            var endTime = $('#endTime_u').val()
            var pid = $('#positions_u').val()
            var tid = $('#teachers_u').val()

            //??????????????????
            $.post(
                    "/jiaowu/getTeacherByCondition2",
                    {"startTime": startTime, "endTime": endTime, "pid":pid,"tid":tid},
                    function (data) {
                        refreshUpdateUI(data)
                    }
            );
        }

        function onCreate(){

            var tname = $('#tname_create').val()
            var gender = $('#gender_create').val()
            var age = $('#age_create').val()
            var tel = $('#tel_create').val()
            var email = $('#email_create').val()

            var directionId = $('#direction_create').val()
            var positionId = $('#position_create').val()

            var school = $('#scholl_create').val()
            var diploma = $('#diploma_create').val()
            var profession = $('#profession_create').val()
            var graduateDate = $('#graducateDate_create').val()

            var experience = $('#experience_create').val()
            var hireDate = $('#date_create').val()

            if(null == tname || 0 == tname.length || null == tel || 0 == tel.length || null == diploma || 0 == diploma.length){
                alert("??????????????????!");
            }else{
                $.post(
                        "/jiaowu/new_teacher",
                        {"tname":tname, "gender":gender, "age":age, "tel":tel, "email":email, "directionId":directionId, "positionId":positionId,
                            "school":school, "diploma":diploma,"profession":profession, "graduateDate":graduateDate,
                            "experience":experience, "hireDate":hireDate,"state":"??????"
                        },
                        function (data) {
                            if(data == "success"){
                                alert("?????????????????????");
                                $('#tname_create').val("")
                                $('#gender_create').val("???")
                                $('#age_create').val("")
                                $('#tel_create').val("")
                                $('#email_create').val("")

                                $('#direction_create').val()
                                $('#position_create').val()

                                $('#scholl_create').val("")
                                $('#profession_create').val("")
                                $('#graducateDate_create').attr("")

                                $('#experience_create').val("")
                            }else{
                                alert("?????????????????????");
                            }

                        }
                );
            }

        }


        function onReset(){
            $('#tname_create').val("")
            $('#gender_create').val("???")
            $('#age_create').val("")
            $('#tel_create').val("")
            $('#email_create').val("")

            $('#direction_create').val()
            $('#position_create').val()

            $('#scholl_create').val("")
            $('#profession_create').val("")
            $('#graducateDate_create').attr("")

            $('#experience_create').val("")
        }

        function onEdit(tid){
            var eid = "#" + tid+"_tname"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_age"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_genders"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_positions"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_directions"
            $(eid).removeAttr("disabled");



            eid = "#" + tid+"_school"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_diplomas"
            $(eid).removeAttr("disabled");

            eid = "#" + tid+"_profession"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_graduateDate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_experience"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_hiredate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_tel"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_email"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leavedate"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leaveReason"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_leaveReason"
            $(eid).attr("readonly",false)

            eid = "#" + tid+"_states"
            $(eid).removeAttr("disabled");

        }


        function onSave(tid){
            var eid = "#" + tid+"_tname"
            var tname = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_age"
            var age = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_genders"
            var gender = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_positions"
            var positionId = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_directions"
            var directionId = $(eid).val()
            $(eid).attr("disabled","disabled")



            eid = "#" + tid+"_school"
            var school = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_diplomas"
            var diploma = $(eid).val()
            $(eid).attr("disabled","disabled")

            eid = "#" + tid+"_profession"
            var profession = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_graduateDate"
            var graduateDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_experience"
            var experience = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_hiredate"
            var hireDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_tel"
            var tel = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_email"
            var email = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_leavedate"
            var leaveDate = $(eid).val()
            $(eid).attr("readonly",true)

            eid = "#" + tid+"_leaveReason"
            var leaveReason = $(eid).val()
            $(eid).attr("readonly",true)


            eid = "#" + tid+"_states"
            var state = $(eid).val()
            $(eid).attr("disabled","disabled")

            if(null == tname || 0 == tname.length || null == tel || 0 == tel.length || null == diploma || 0 == diploma.length){
                alert("??????????????????!");
            }else {

                $.post(
                        "/jiaowu/update_teacher",
                        {
                            "tid":tid,
                            "tname": tname,
                            "age": age,
                            "gender": gender,
                            "directionId": directionId,
                            "positionId": positionId,
                            "tel": tel,
                            "email": email,

                            "school": school,
                            "diploma": diploma,
                            "profession": profession,
                            "graduateDate": graduateDate,

                            "experience": experience,
                            "hireDate": hireDate,
                            "state": state,
                            "leaveDate":leaveDate,
                            "leaveReason":leaveReason
                        },
                        function (data) {
                            alert(data);
                        }
                );
            }

        }

        function efreshQueryUI(teachers) {
            $("#query_tbody").empty();

            for (var i = 0; i < teachers.length; i++) {
                var teacher = teachers[i];
                var str = "<tr class='even gradeA'>";
                var index = i + 1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td>" + teacher.tname + "</td>";
                str = str + "<td>" + teacher.gender + "</td>";
                str = str + "<td>" + teacher.age + "</td>";
                str = str + "<td>" + teacher.direction.dname + "</td>";
                str = str + "<td>" + teacher.position.pname + "</td>";
                str = str + "<td>" + teacher.tel + "</td>";
                str = str + "<td>" + teacher.email + "</td>";
                str = str + "<td>" + teacher.school + "</td>";
                str = str + "<td>" + teacher.diploma + "</td>";
                str = str + "<td>" + teacher.profession + "</td>";
                if(teacher.graduateDate == null){
                    teacher.graduateDate = ""
                }
                str = str + "<td>" + teacher.graduateDate + "</td>";
                str = str + "<td>" + teacher.experience + "</td>";

                str = str + "<td>" + teacher.hireDate + "</td>";
                str = str + "<td>" + teacher.leaveDate + "</td>";
                str = str + "<td>" + teacher.leaveReason + "</td>";
                str = str + "</tr>";

                $("#query_tbody").append(str);
            }
        }

        function refreshUpdateUI(jsonObject){
            var positions = jsonObject.positions;
            var directions = jsonObject.directions;
            var teachers = jsonObject.teachers;
            $("#update_tbody").empty();

            for (var i = 0; i < teachers.length; i++) {
                var teacher = teachers[i];
                var str = "<tr class='even gradeA'>";
                var index = i + 1;
                str = str + "<td>" + index + "</td>";
                str = str + "<td><input id='" + teacher.tid +"_tname'  value='" + teacher.tname +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid+ "_genders' class='form-control' disabled>";
                if(teacher.gender == '???'){
                    str = str + "<option value='???' selected='selected'>???</option> <option value='???'>???</option>";
                }else{
                    str = str + "<option value='???' >???</option> <option value='???' selected='selected'>???</option>";
                }

                str = str + "<td><input id='" + teacher.tid +"_age' value='" + teacher.age + "' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_directions' class='form-control' disabled>";
                for(var j = 0; j < directions.length; j++){
                    var direction = directions[j];
                    if(direction.did == teacher.direction.did){
                        str = str + "<option value='" + direction.did +"' selected='selected'>" + direction.dname + "</option>";
                    }else{
                        str = str + "<option value='" + direction.did +"'>" + direction.dname + "</option>";
                    }
                }

                str = str + "<td><select id='" + teacher.tid + "_positions' class='form-control' disabled>";
                for(var j = 0; j < positions.length; j++){
                    var position = positions[j];
                    if(position.pid == teacher.position.pid){
                        str = str + "<option value='" + position.pid +"' selected='selected'>" + position.pname + "</option>";
                    }else{
                        str = str + "<option value='" + position.pid +"'>" + position.pname + "</option>";
                    }
                }

                str = str + "<td><input id='" + teacher.tid + "_tel' value='" + teacher.tel +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_email' value='" + teacher.email +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_school' value='" + teacher.school +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_diplomas' class='form-control' disabled>";
                if('??????' == teacher.diploma){
                    str = str + "<option value='??????' selected='selected'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option>";
                }else if('??????' == teacher.diploma){
                    str = str + "<option value='??????'>??????</option> <option value='??????'  selected='selected'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option>";
                }else if('??????' == teacher.diploma){
                    str = str + "<option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????'  selected='selected'>??????</option> <option value='??????'>??????</option>";
                }else if('??????' == teacher.diploma){
                    str = str + "<option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????' selected='selected'>??????</option>";
                }else{
                    str = str + "<option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option> <option value='??????'>??????</option>";
                }

                str = str + "<td><input id='" + teacher.tid + "_profession' value='" + teacher.profession +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_graduateDate' value='" + teacher.graduateDate +"' type='date' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_experience' value='" + teacher.experience +"' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_hiredate' value='" + teacher.hireDate +"' type='date' readonly='true' class='form-control'/></td>";

                str = str + "<td><select id='" + teacher.tid + "_states' class='form-control' disabled>";
                if(teacher.state == '??????'){
                    str = str + "<option value='??????' selected='selected'>??????</option> <option value='??????'>??????</option>"
                }else if(teacher.state == '??????'){
                    str = str + "<option value='??????' >??????</option> <option value='??????' selected='selected'>??????</option>"
                }else{
                    str = str + "<option value='??????' >??????</option> <option value='??????' >??????</option>"
                }

                str = str + "<td><input id='" + teacher.tid + "_leavedate' value='" + teacher.leaveDate +"' type='date' readonly='true' class='form-control'/></td>";
                str = str + "<td><input id='" + teacher.tid + "_leaveReason' value='" + teacher.leaveReason +"' readonly='true' class='form-control'/></td>";

                str = str + "<td><button type='button' class='btn btn-default' onclick='onEdit(" + teacher.tid + ")'>??????</button><button type='button' class='btn btn-default' style='margin-left: 20px' onclick='onSave(" + teacher.tid + ")'>??????</button></td>";

                $("#update_tbody").append(str);
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
                                <li id="q" class="active"><a href="#query" data-toggle="tab">??????</a>
                                </li>
                                <li id="c"><a href="#create" data-toggle="tab">??????</a>
                                </li>
                                <li id="u"><a href="#update" data-toggle="tab">??????</a>
                                </li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="margin-top: 30px">
                                <div class="tab-pane fade in active" id="query">
                                    <h4 style=" text-align:center;">??????????????????</h4>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">????????????:</td>
                                                            <td>
                                                                <input type="date" id="startTime_q" class = "form-control" placeholder = "????????????" style="min-width: 150px">
                                                            </td>
                                                            <td style="text-align:right;">????????????:</td>
                                                            <td>
                                                                <input type="date" id="endTime_q" class = "form-control" placeholder = "????????????" style="min-width: 150px">
                                                            </td>

                                                            <td style="text-align:right;">??????:</td>
                                                            <td>
                                                                <select type="select" id="positions_query" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">??????</option>
                                                                    <c:forEach var="position" items="${requestScope.positions}" >
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">??????:</td>
                                                            <td>
                                                                <select type="select" id="teachers_query" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">??????</option>
                                                                    <c:forEach var="teacher" items="${requestScope.teachers}" >
                                                                        <option value="${teacher.tid}">${teacher.tname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">????????????</button>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </div>

                                                <!-- /.panel-body -->
                                            </div>
                                            <!-- /.panel -->
                                        </div>

                                    </div>
                                    <!-- /.panel-heading -->
                                    <div class="row">
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-bordered table-hover">
                                                <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>??????</th>
                                                    <th>??????</th>
                                                    <th>??????</th>
                                                    <th>??????</th>
                                                    <th>??????</th>
                                                    <th>?????????</th>
                                                    <th>??????</th>
                                                    <th>????????????</th>
                                                    <th>??????</th>
                                                    <th>??????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                    <th>????????????</th>
                                                </tr>
                                                </thead>
                                                <tbody id="query_tbody">
                                                <c:forEach var="teacher" items="${requestScope.teachers}" begin="0" step="1" varStatus="i">
                                                    <tr>
                                                        <td>${i.index + 1}</td>
                                                        <td>${teacher.tname}</td>
                                                        <td>${teacher.gender}</td>
                                                        <td>${teacher.age}</td>

                                                        <td>${teacher.direction.dname}</td>
                                                        <td>${teacher.position.pname}</td>

                                                        <td>${teacher.tel}</td>
                                                        <td>${teacher.email}</td>
                                                        <td>${teacher.school}</td>
                                                        <td>${teacher.diploma}</td>
                                                        <td>${teacher.profession}</td>
                                                        <td>${teacher.graduateDate}</td>
                                                        <td>${teacher.experience}</td>
                                                        <td>${teacher.hireDate}</td>
                                                        <td>${teacher.leaveDate}</td>
                                                        <td>${teacher.leaveReason}</td>
                                                    </tr>
                                                </c:forEach>

                                                </tbody>
                                            </table>




                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.panel-body -->
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="create" >
                                    <h4 style=" text-align:center;">??????????????????</h4>

                                    <table class="table table-striped table-bordered table-hover">
                                        <tbody>
                                        <tr>
                                            <td>??????</td>
                                            <td><input id="tname_create" class="form-control" placeholder="????????????"></td>
                                            <td>??????</td>
                                            <td>
                                                <select id="gender_create" class="form-control">
                                                    <option value="???">???</option>
                                                    <option value="???">???</option>
                                                </select>
                                            </td>
                                            <td>??????</td>
                                            <td>
                                                <input id="age_create" type="number" class="form-control" placeholder="??????????????????????????????">
                                            </td>
                                            <td>?????????</td>
                                            <td><input id="tel_create" type="number" class="form-control" placeholder="?????????????????????11?????????"></td>
                                        </tr>
                                        <tr>
                                            <td>??????</td>
                                            <td><input id="email_create" type="email" class="form-control" placeholder="???????????????"></td>
                                            <td>????????????</td>
                                            <td>
                                                <select id="direction_create" class="form-control">
                                                    <c:forEach var="direction" items="${requestScope.directions}">
                                                        <option value="${direction.did}">${direction.dname}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>??????</td>
                                            <td>
                                                <select id="position_create" class="form-control">
                                                    <c:forEach var="position" items="${requestScope.positions}">
                                                        <option value="${position.pid}">${position.pname}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>????????????</td>
                                            <td><input id="scholl_create" class="form-control" placeholder="????????????"></td>
                                        </tr>
                                        <tr>
                                            <td>??????</td>
                                            <td>
                                                <select id="diploma_create" class="form-control">
                                                    <option value="??????">??????</option>
                                                    <option value="??????">??????</option>
                                                    <option value="??????">??????</option>
                                                    <option value="??????">??????</option>
                                                </select>
                                            </td>
                                            <td>
                                                ??????
                                            </td>
                                            <td>
                                                <input  id="profession_create" class="form-control" placeholder="????????????">
                                            </td>
                                            <td>????????????</td>
                                            <td><input id="graducateDate_create" type="date" class="form-control" placeholder="????????????"></td>
                                            <td>????????????</td>
                                            <td><input  id="experience_create" class="form-control" placeholder="????????????"></td>
                                        </tr>
                                        <tr>
                                            <td>????????????</td>
                                            <td><input id="date_create" type="date" class="form-control" ></td>
                                        </tr>

                                        </tbody>
                                    </table>
                                    <row>
                                        <div class="col-lg-12">
                                            <div class="col-lg-3" style="text-align:center;">
                                                <button  class="btn btn-default" onclick="onCreate()" style="min-width: 100px">???    ???</button>
                                            </div>
                                            <div class="col-lg-3" style="text-align:center;">
                                                <button  class="btn btn-default" onclick="onReset()" style="min-width: 100px">???    ???</button>
                                            </div>
                                        </div>
                                    </row>




                                </div>
                                <div class="tab-pane fade" id="update">
                                    <h4 style=" text-align:center;">??????????????????</h4>
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="col-lg-12" style="background: #dddddd">
                                                    <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                        <tr>
                                                            <td style="text-align:right;">????????????:</td>
                                                            <td>
                                                                <input type="date" id="startTime_u" class = "form-control" placeholder = "????????????" style="min-width: 150px">
                                                            </td>
                                                            <td style="text-align:right;">????????????:</td>
                                                            <td>
                                                                <input type="date" id="endTime_u" class = "form-control" placeholder = "????????????" style="min-width: 150px">
                                                            </td>

                                                            <td style="text-align:right;">??????:</td>
                                                            <td>
                                                                <select type="select" id="positions_u" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">??????</option>
                                                                    <c:forEach var="position" items="${requestScope.positions}" >
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>


                                                        </tr>
                                                        <tr>
                                                            <td style="text-align:right;">??????:</td>
                                                            <td>
                                                                <select type="select" id="teachers_u" class="form-control" style="display: inline;min-width: 150px">
                                                                    <option value="-1">??????</option>
                                                                    <c:forEach var="teacher" items="${requestScope.teachers}" >
                                                                        <option value="${teacher.tid}">${teacher.tname}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td style="text-align:right;"></td>
                                                            <td></td>
                                                            <td style="text-align:right;"></td>
                                                            <td>
                                                                <button type="button" class="btn btn-primary" onclick="query_u()" style="min-width: 150px">????????????</button>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </div>

                                                <!-- /.panel-body -->
                                            </div>
                                            <!-- /.panel -->
                                        </div>

                                    </div>
                                    <!-- /.panel-heading -->
                                    <div class="row">
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <div style="width:3000px;  overflow:scroll;">
                                                <table class="table table-striped table-bordered table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th width="50px">#</th>
                                                        <th width="120px">??????</th>
                                                        <th width="100px">??????</th>
                                                        <th width="100px">??????</th>
                                                        <th width="180px">??????</th>
                                                        <th width="200px">??????</th>
                                                        <th width="200px">?????????</th>
                                                        <th width="200px">??????</th>
                                                        <th width="200px">????????????</th>
                                                        <th width="100px">??????</th>
                                                        <th width="200px">??????</th>
                                                        <th width="200px">????????????</th>
                                                        <th width="100px">????????????</th>
                                                        <th width="200px">????????????</th>
                                                        <th width="100px">??????</th>
                                                        <th width="200px">????????????</th>
                                                        <th width="400px">????????????</th>
                                                        <th width="200px">??????</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="update_tbody">
                                                    <c:forEach var="teacher" items="${requestScope.teachers}" begin="0" step="1" varStatus="i">
                                                    <tr>
                                                        <td>${i.index + 1}</td>
                                                        <td><input id="${teacher.tid}_tname"  value="${teacher.tname}" readonly="true" class="form-control"/></td>
                                                        <td>
                                                            <select id="${teacher.tid}_genders" class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${teacher.gender=='???'}">
                                                                        <option value="???" selected="selected">???</option>
                                                                        <option value="???">???</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="???">???</option>
                                                                        <option value="???" selected="selected">???</option>
                                                                    </c:otherwise>
                                                                </c:choose>

                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_age"  value="${teacher.age}" readonly="true" class="form-control"/></td>
                                                        <td>
                                                        <select id="${teacher.tid}_directions" class="form-control" disabled>
                                                            <c:forEach var="direction" items="${requestScope.directions}" >
                                                                <c:choose>
                                                                    <c:when test="${direction.did == teacher.direction.did}">
                                                                        <option value="${direction.did}" selected="selected">${direction.dname}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${direction.did}" >${direction.dname}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </select>
                                                        </td>
                                                        <td>
                                                        <select id="${teacher.tid}_positions" class="form-control" disabled>
                                                            <c:forEach var="position" items="${requestScope.positions}" >
                                                                <c:choose>
                                                                    <c:when test="${position.pid == teacher.position.pid}">
                                                                        <option value="${position.pid}" selected="selected">${position.pname}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${position.pid}">${position.pname}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_tel"  value="${teacher.tel}" readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_email"  value="${teacher.email} " readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_school"  value="${teacher.school} " readonly="true" class="form-control"/></td>


                                                        <td>
                                                            <select id="${teacher.tid}_diplomas" class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${'??????' == teacher.diploma}">
                                                                        <option value="??????" selected="selected">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                    </c:when>
                                                                    <c:when test="${'??????' == teacher.diploma}">
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????" selected="selected">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                    </c:when>
                                                                    <c:when test="${'??????' == teacher.diploma}">
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????" selected="selected">??????</option>
                                                                        <option value="??????">??????</option>
                                                                    </c:when>
                                                                    <c:when test="${'??????' == teacher.diploma}">
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????" selected="selected">??????</option>
                                                                    </c:when>

                                                                </c:choose>

                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_profession"  value="${teacher.profession} " readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_graduateDate"  value="${teacher.graduateDate} " type="date" readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_experience"  value="${teacher.experience} " readonly="true" class="form-control"/></td>

                                                        <td><input id="${teacher.tid}_hiredate"  value="${teacher.hireDate} " type="date" readonly="true" class="form-control"/></td>
                                                        <td>
                                                            <select id="${teacher.tid}_states"   class="form-control" disabled>
                                                                <c:choose>
                                                                    <c:when test="${classTeacher.state=='??????'}">
                                                                        <option value="??????" selected="selected">??????</option>
                                                                        <option value="??????">??????</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="??????">??????</option>
                                                                        <option value="??????" selected="selected">??????</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </select>
                                                        </td>
                                                        <td><input id="${teacher.tid}_leavedate"  value="${teacher.leaveDate} " type="date" readonly="true" class="form-control"/></td>
                                                        <td><input id="${teacher.tid}_leaveReason"  value="${teacher.leaveReason} "  readonly="true" class="form-control"/></td>


                                                        <td><button type="button" class="btn btn-default" onclick="onEdit(${teacher.tid})">??????</button><button type="button" class="btn btn-default" style="margin-left: 20px" onclick="onSave(${teacher.tid})">??????</button></td>
                                                    </tr>
                                                    </c:forEach>
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



</body>

</html>
