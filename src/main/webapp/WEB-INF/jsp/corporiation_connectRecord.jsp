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
        var ccrid_c
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

                $.post(
                        "/procedure/getClassTeacherByCid",
                        {"centerId":centerId},
                        function (classTeachers) {
                            if(classTeachers != null){
                                var str = ""
                                $("#classteachers_search").empty()
                                var length = classTeachers.length
                                if(centerId == -1){
                                    str = str + "<option value='-1'>全部</option>"
                                }
                                for(var i = 0; i < length; i++){
                                    str = str + "<option value='" + classTeachers[i].ctid + "'>" + classTeachers[i].ctname + "</option>"
                                }
                                $("#classteachers_search").append(str)
                            }
                        }
                );
            })



            $("#centers").change(function(){
                var centerId=$("#centers").val()

                $.post(
                    "/procedure/getClassTeacherByCid",
                    {"centerId":centerId},
                    function (classTeachers) {
                        if(classTeachers != null && classTeachers.length > 0){

                            var str = ""
                            $("#classteachers").empty()
                            var length = classTeachers.length

                            for(var i = 0; i < length; i++){
                                str = str + "<option value='" + classTeachers[i].ctid + "'>" + classTeachers[i].ctname + "</option>"
                            }
                            $("#classteachers").append(str)

                            clearCorporiationInfo()

                            $.post(
                                    "/corporiate/getSimpleCorporiationsByCtid",
                                    {"ctid":classTeachers[0].ctid},
                                    function (corporiations) {
                                        updateClassteacherInfo(corporiations)
                                    }
                            );


                        }
                    }
                );
            })


            $("#classteachers").change(function(){
                var ctid = $("#classteachers").val()
                if(ctid != null){
                    $.post(
                            "/corporiate/getSimpleCorporiationsByCtid",
                            {"ctid":ctid},
                            function (corporiations) {
                                updateClassteacherInfo(corporiations)
                            }
                    );
                }
            })


            $("#corporiations_new").change(function(){
                var cid = $("#corporiations_new").val()
                if(cid != null){
                    $.post(
                            "/corporiate/getCorporiationByCid",
                            {"cid":cid},
                            function (corporiation) {
                                updateCorporiationInfo(corporiation)
                            }
                    );
                }
            })

        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        function updateClassteacherInfo(corporiations) {
            $("#corporiations_new").empty()
            clearCorporiationInfo()
            if(corporiations != null && corporiations.length > 0){
                var str = ""
                var length = corporiations.length
                for(var i = 0; i < length; i++){
                    str = str + "<option value='" + corporiations[i].cid + "'>" + corporiations[i].cname + "</option>"
                }
                $("#corporiations_new").append(str)



                $.post(
                        "/corporiate/getCorporiationByCid",
                        {"cid":corporiations[0].cid},
                        function (corporiation) {
                            updateCorporiationInfo(corporiation)
                        }
                );
            }

        }

        function clearCorporiationInfo() {
            $("#contact_new").val("")
            $("#contactPhone_new").val("")
            $("#hrmanager_new").val("")
            $("#tel_new").val("")

            $("#phone_new").val("")
            $("#qq_new").val("")
            $("#weichat_new").val("")
        }
        function updateCorporiationInfo(corporiation) {
            clearCorporiationInfo()
            if(corporiation != null){
                $("#contact_new").val(corporiation.contectName)
                $("#contactPhone_new").val(corporiation.phone)
                $("#hrmanager_new").val(corporiation.hrmanager)
                $("#tel_new").val(corporiation.tel)

                $("#phone_new").val(corporiation.phone)
                $("#qq_new").val(corporiation.qq)
                $("#weichat_new").val(corporiation.weichat)

            }
        }


        function onAddNew() {
            $('#contact_new').val("")
            $('#contactPhone_new').val("")
            $('#hrmanager_new').val("")
            $('#tel_new').val("")
            $('#phone_new').val("")

            $('#qq_new').val("")
            $('#weichat_new').val("")
            $('#job_new').val("")
            $('#require_new').val("")

            $('#salary_1_new').val("")
            $('#salary_2_new').val("")
            $('#shiyongqi_new').val("")
            $('#shixi_new').val("")
            $('#fuli_new').val("")

        }


        function onSaveNew() {
            var centerId = $('#centers').val()
            var cename = $('#centers').find("option:selected").text();
            var classTeacherId = $('#classteachers').val()
            var ctname = $('#classteachers').find("option:selected").text();

            var corporiationId = $('#corporiations_new').val()
            var coname = $('#corporiations_new').find("option:selected").text();
            var contectName= $('#contact_new').val()
            var contactPosition = $('#contactPhone_new').val()
            var hrmanager = $('#hrmanager_new').val()
            var tel = $('#tel_new').val()
            var phone = $('#phone_new').val()

            var qq = $('#qq_new').val()
            var weichat = $('#weichat_new').val()
            var diploma = $('#diploma_new').val()
            var job = $('#job_new').val()
            var require = $('#require_new').val()

            var salary_1 = $('#salary_1_new').val()
            var salary_2 = $('#salary_2_new').val()
            var shiyongqi = $('#shiyongqi_new').val()
            var shixi = $('#shixi_new').val()
            var fuli = $('#fuli_new').val()
            var isQiyeQQ = $('#isQiqq_new').val()

            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var timee = now.getFullYear() + "-" + (month) + "-" + (day);

            if(
                    contectName == null || contectName.length == 0 ||
                    contactPosition == null || contactPosition.length == 0 ||
                    job == null || job.length == 0 ||
                    diploma == null || diploma.length == 0 ||
                    require == null || require.length == 0 ||
                    contectName == null || contectName.length == 0

            ){
                alert("您应填写所有所有*标注的项!")
                return
            }
            if((weichat == null || weichat.length == 0 )&&(qq == null || qq.length == 0) && (phone == null || phone.length == 0 )&&(tel == null || tel.length == 0)){
                alert("注意：手机，固定电话，微信和QQ您至少应填写一项")
                return
            }

            if((shiyongqi == null || shiyongqi.length == 0) && (shixi == null || shixi.length == 0) && (salary_1 == null || salary_1.length == 0) && (salary_2 == null || salary_2.length == 0)){
                alert("注意：试用期和实习您至少应填写一项")
                return
            }

            $.post(
                    "/corporiate/saveNewConnectRecord",
                    {"centerId":centerId,"classTeacherId":classTeacherId, "corporiationId":corporiationId,"contectName":contectName, "contactPosition":contactPosition,
                        "hrmanager":hrmanager,"tel":tel, "phone":phone,"qq":qq, "weichat":weichat,"diploma":diploma,"job":job,"timee":timee,
                        "require":require,"salary_1":salary_1, "salary_2":salary_2,"shiyongqi":shiyongqi, "shixi":shixi,"fuli":fuli,"isQiyeQQ":isQiyeQQ
                    },
                    function (ccrid) {
                        if(ccrid > 0){
                            var str = "<tr>"
                            str = str + "<td>" + ccrid +"</td>"
                            str = str + "<td><a href='javascript:void(0)' onclick='edit( " + ccrid + ")'>编辑</a></td>"
                            str = str + "<td>" + ctname +"</td>"
                            str = str + "<td>" + cename +"</td>"
                            str = str + "<td>" + timee +"</td>"
                            str = str + "<td>" + coname +"</td>"
                            str = str + "<td>" + contectName +"</td>"
                            str = str + "<td>" + contactPosition +"</td>"

                            str = str + "<td>" + hrmanager +"</td>"
                            str = str + "<td>" + tel +"</td>"
                            str = str + "<td>" + phone +"</td>"
                            str = str + "<td>" + qq +"</td>"
                            str = str + "<td>" + weichat +"</td>"

                            str = str + "<td>" + job +"</td>"
                            str = str + "<td>" + diploma +"</td>"
                            str = str + "<td>" + require +"</td>"
                            str = str + "<td>" + salary_1 +"</td>"
                            str = str + "<td>" + salary_2 +"</td>"

                            str = str + "<td>" + shiyongqi +"</td>"
                            str = str + "<td>" + shixi +"</td>"
                            str = str + "<td>" + fuli +"</td>"
                            str = str + "<td>" + isQiyeQQ +"</td>"

                            str = str + "</tr>"
                            $('#tbody_connectRecoed').append(str)
                            alert("数据保存成功")
                        }else{
                            alert("数据保存失败")
                        }
                    }
            );


        }




        function query(){
            var centerId = $('#centers_search').val()
            var classteacherId = $('#classteachers_search').val()
            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()
            if(centerId == null || classteacherId == null || startTime == null || endTime == null){
                alert("请选择正确x信息")
                return
            }else{
                $.post(
                        "/corporiate/listConnectRecords",
                        {"centerId":centerId,"classteacherId":classteacherId,"startTime":startTime,"endTime":endTime},
                        function (corporiationConnectRecoeds) {
                            if(null != corporiationConnectRecoeds){
                                var length = corporiationConnectRecoeds.length
                                $('#tbody_connectRecoed').empty()
                                for(var i = 0; i < length; i++){
//
                                    var corporiationConnectRecoed = corporiationConnectRecoeds[i]

                                    var str = "<tr>"
                                    str = str + "<td>" + corporiationConnectRecoed.ccrid + "</td>"
                                    str = str + "<td><a href='javascript:void(0)' onclick='edit( " + corporiationConnectRecoed.ccrid + ")'>编辑</a></td>"
                                    str = str + "<td>" + corporiationConnectRecoed.ctname + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.cename + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.timee + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.corporiationName + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.contectName + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.contactPosition + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.hrmanager + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.tel + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.phone + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.qq + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.weichat + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.job + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.diploma + "</td>"
                                    if(corporiationConnectRecoed.requiree == null){
                                        corporiationConnectRecoed.requiree = ""
                                    }
                                    str = str + "<td>" + corporiationConnectRecoed.requiree + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.salary_1 + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.salary_2 + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.shiyongqi + "</td>"
                                    str = str + "<td>" + corporiationConnectRecoed.shixi + "</td>"
                                    if(corporiationConnectRecoed.fuli == null ){
                                        corporiationConnectRecoed.fuli = ""
                                    }
                                    str = str + "<td>" + corporiationConnectRecoed.fuli + "</td>"

                                    str = str + "<td>" + corporiationConnectRecoed.isQiyeQQ + "</td>"

                                    str = str + "</tr>"

                                    $('#tbody_connectRecoed').append(str)

                                }
                            }

                        }
                );
            }
        }

        function getRowIndex(id){
            var rows = $("#tbody_connectRecoed").find("tr")
            var length = rows.length
            for(var i = 0; i < length; i++){
                var tds = rows.eq(i).find("td")
                if(tds.eq(0).text() == id){
                    return tds
                }
            }
            return null;
        }

        function edit(ccrid){
            ccrid_c = ccrid
            var tds = getRowIndex(ccrid)
            if(tds != null){

                var tds_e =  $("#tbody_e").find("tr").eq(0).find("td")
                tds_e.eq(1).html(tds.eq(5).text())

                $("#contact_e").val(tds.eq(6).text())
                $("#contactPhone_e").val(tds.eq(7).text())

                $("#hrmanager_e").val(tds.eq(8).text())
                $("#tel_e").val(tds.eq(9).text())
                $("#phone_e").val(tds.eq(10).text())

                $("#qq_e").val(tds.eq(11).text())
                $("#weichat_e").val(tds.eq(12).text())
                $("#diploma_e").val(tds.eq(14).text())

                $("#job_e").val(tds.eq(13).text())
                $("#require_e").val(tds.eq(15).text())

                $("#salary_1_e").val(tds.eq(16).text())
                $("#salary_2_e").val(tds.eq(17).text())
                $("#shiyongqi_e").val(tds.eq(18).text())

                $("#shixi_e").val(tds.eq(19).text())
                $("#fuli_e").val(tds.eq(20).text())
                $("#isQiqq_e").val(tds.eq(21).text())
            }

            $("#connectRecordModal_edit").modal()
        }


        /*
         {"contectName":contectName, "contactPosition":contactPosition,
         "hrmanager":hrmanager,"tel":tel, "phone":phone,"qq":qq, "email":email,"diploma":diploma,"job":job,"timee":timee,
         "require":require,"salary_1":salary_1, "salary_2":salary_2,"shiyongqi":shiyongqi, "shixi":shixi,"fuli":fuli,"isQiyeQQ":isQiyeQQ
         },
         */
        function saveaConnectRecordUpdate(){
            var contectName = $("#contact_e").val()
            var contactPosition = $("#contactPhone_e").val()

            var hrmanager = $("#hrmanager_e").val()
            var tel = $("#tel_e").val()
            var phone = $("#phone_e").val()

            var qq = $("#qq_e").val()
            var email = $("#weichat_e").val()
            var diploma = $("#diploma_e").val()

            var job = $("#job_e").val()
            var requiree = $("#require_e").val()

            var salary_1 = $("#salary_1_e").val()
            var salary_2 = $("#salary_2_e").val()
            var shiyongqi = $("#shiyongqi_e").val()

            var shixi = $("#shixi_e").val()
            var fuli = $("#fuli_e").val()
            var isQiyeQQ = $("#isQiqq_e").val()


            $.post(
                    "/corporiate/updateConnectRecord",
                    {"contectName":contectName, "contactPosition":contactPosition,"ccrid":ccrid_c,
                        "hrmanager":hrmanager,"tel":tel, "phone":phone,"qq":qq, "email":email,"diploma":diploma,"job":job,
                        "requiree":requiree,"salary_1":salary_1, "salary_2":salary_2,"shiyongqi":shiyongqi, "shixi":shixi,"fuli":fuli,"isQiyeQQ":isQiyeQQ
                    },
                    function (data) {
                        if(data == "success"){
                            //更新数据
                            var tds = getRowIndex(ccrid_c)
                            tds.eq(6).text(contectName)
                            tds.eq(7).text(contactPosition)
                            tds.eq(8).text(hrmanager)
                            tds.eq(9).text(tel)
                            tds.eq(10).text(phone)

                            tds.eq(11).text(qq)
                            tds.eq(12).text(email)
                            tds.eq(13).text(job)
                            tds.eq(14).text(diploma)
                            tds.eq(15).text(requiree)

                            tds.eq(16).text(salary_1)
                            tds.eq(17).text(salary_2)
                            tds.eq(18).text(shiyongqi)
                            tds.eq(19).text(shixi)
                            tds.eq(20).text(fuli)

                            tds.eq(21).text(isQiyeQQ)



                            alert("保存数据成功")
                        }else{
                            alert("保存数据失败")
                        }
                    }
            );

        }


    </script>

</head>

<body>

<div class="modal fade" id="connectRecordModal_edit" tabindex="-1" role="dialog" aria-labelledby="connectRecordModal_edit">
    <div class="modal-dialog" role="document" style="width: 50%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">企业联系记录编辑</h4>
            </div>

            <div class="modal-body">


                        <table class="table table-striped table-bordered table-hover">
                            <tbody id="tbody_e">
                            <tr>
                                <td>联系企业</td>
                                <td></td>
                                <td>联系人</td>
                                <td><input id="contact_e" class="form-control"/></td>
                                <td>职位</td>
                                <td><input id="contactPhone_e" class="form-control"></td>
                            </tr>
                            <tr>
                                <td>hr经理</td>
                                <td><input id="hrmanager_e" class="form-control"></td>
                                <td>固定电话</td>
                                <td><input id="tel_e" class="form-control"></td>
                                <td>手机</td>
                                <td><input id="phone_e" class="form-control"></td>
                            </tr>
                            <tr>
                                <td>qq</td>
                                <td><input id="qq_e"  class="form-control" /></td>
                                <td>微信</td>
                                <td><input id="weichat_e" class="form-control" type="email" /></td>
                                <td>学历要求</td>
                                <td>
                                    <select id="diploma_e" class="form-control" >
                                        <c:forEach var="diplomaState" items="${requestScope.diplomaStates}" >
                                            <option value="${diplomaState}">${diplomaState}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                            </tr>
                            <tr>
                                <td>招聘岗位</td>
                                <td><input id="job_e"  class="form-control" /></td>
                                <td>用人要求</td>
                                <td colspan="3"><input id="require_e"  class="form-control" /></td>

                            </tr>
                            <tr>
                                <td>工资下限</td>
                                <td><input id="salary_1_e" class="form-control" type="number" value="0"/></td>
                                <td>工资上限</td>
                                <td><input id="salary_2_e" class="form-control" type="number" value="0"/></td>
                                <td>试用期工资</td>
                                <td><input id="shiyongqi_e"  class="form-control" type="number" value="0"/></td>

                            </tr>
                            <tr>
                                <td>实习工资</td>
                                <td><input id="shixi_e" class="form-control" type="number" value="0"/></td>
                                <td>福利</td>
                                <td><input id="fuli_e"  class="form-control" /></td>
                                <td>加入企业qq</td>
                                <td>
                                    <select id="isQiqq_e" class="form-control" >
                                        <option value="否">否</option>
                                        <option value="是">是</option>
                                    </select>
                                </td>
                            </tr>
                            </tbody>
                        </table>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveaConnectRecordUpdate()">保存</button>
            </div>
        </div>
    </div>
</div>


<div id="wrapper">
    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="container-fluid"/>
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
                <h1 class="page-header">企业联系记录</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
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
                                        <option value="-1">全部</option>
                                        <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                            <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                            </tr>
                            <tr>
                                <td style="text-align:right;">开始时间:</td>
                                <td>
                                    <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="display: inline">
                                </td>
                                <td style="text-align:right;">结束时间:</td>
                                <td>
                                    <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="display: inline">
                                </td>
                                <td style="text-align:right;"></td>
                                <td>
                                    <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px;">条件查询</button>
                                </td>
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
                    <div style="width:2000px;height: 500px">
                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                            <thead >
                            <th>id</th>
                            <th>操作</th>
                            <th>企业规划师</th>
                            <th>教学中心</th>
                            <th>联系时间</th>
                            <th>联系企业</th>
                            <th>联系人</th>
                            <th>联系人职位</th>
                            <th>hr经理</th>
                            <th>固定电话</th>
                            <th>手机</th>
                            <th>qq</th>
                            <th>微信</th>
                            <th>招聘岗位</th>
                            <th>学历要求</th>
                            <th>用人要求</th>
                            <th>工资范围上限</th>
                            <th>工资范围下限</th>
                            <th>试用期工资</th>
                            <th>实习工资</th>
                            <th>福利</th>
                            <th>是否加入企业qq</th>
                            </thead>
                            <tbody id="tbody_connectRecoed">
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- /.table-responsive -->
            </div>
            <!-- /.panel-body -->
        </div>
        <div class="row" style="margin-top: 10px">
            <label style="margin-left: 50px" >教学中心:</label>
            <select id="centers" class="from-inline" >
                <option value="-1">全部</option>
                <c:forEach var="center" items="${requestScope.centers}" >
                    <option value="${center.cid}">${center.cname}</option>
                </c:forEach>
            </select>
            <label style="margin-left: 50px" >企业规划师:</label>
            <select id="classteachers" class="from-inline">
                <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                    <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                </c:forEach>
            </select>
            <a href="/corporiate/corporationBaseInfo" style="margin-left: 50px" style="margin-left: 100px">添加企业信息</a>
            <label style="color: red;margin-left: 200px;">注意:手机、固话、微信、QQ须填写一个; 优选固话.</label>
        </div>
        <div class="row">
            <div class="table-responsive" >
                <div style="width:1500px;">
                    <table  class="table table-striped table-bordered table-hover text-nowrap">
                        <tbody id="tbody_new">
                            <tr>
                                <td width="100px">联系企业:</td>
                                <td width="150px">
                                    <select id="corporiations_new" class="form-control">
                                        <c:forEach var="corporiation" items="${requestScope.corporiations}" >
                                            <option value="${corporiation.cid}">${corporiation.cname}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td width="100px">联系人(*): </td>
                                <td width="150px"><input id="contact_new" class="form-control" value="${requestScope.corporiation.contectName}"/></td>
                                <td width="100px">职位(*):</td>
                                <td width="150px"><input id="contactPhone_new" class="form-control" value="${requestScope.corporiation.contactPosition}"></td>
                                <td width="100px">hr经理:</td>
                                <td width="150px"><input id="hrmanager_new" class="form-control" value="${requestScope.corporiation.hrmanager}"></td>
                                <td width="100px">固定电话:</td>
                                <td width="150px"><input id="tel_new" class="form-control" style="background:  #eff7ff;" value="${requestScope.corporiation.tel}"></td>
                                <td width="100px">手机:</td>
                                <td width="150px"><input id="phone_new" class="form-control" style="background:  #eff7ff;" value="${requestScope.corporiation.phone}"></td>
                            </tr>
                            <tr>
                                <td>qq: </td>
                                <td><input id="qq_new"  class="form-control" style="background: #eff7ff" value="${requestScope.corporiation.qq}"/></td>
                                <td>微信: </td>
                                <td><input id="weichat_new" class="form-control" type="text" style="background: #eff7ff" value="${requestScope.corporiation.weichat}" /></td>
                                <td>学历要求(*): </td>
                                <td>
                                    <select id="diploma_new" class="form-control" >
                                        <c:forEach var="diplomaState" items="${requestScope.diplomaStates}" >
                                            <option value="${diplomaState}">${diplomaState}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td>招聘岗位(*): </td>
                                <td><input id="job_new"  class="form-control" /></td>

                                <td>用人要求(*): </td>
                                <td colspan="3"><input id="require_new"  class="form-control" /></td>
                            </tr>

                            <tr>
                                <td>工资下限(): </td>
                                <td><input id="salary_1_new" class="form-control" type="number" value="0"/></td>
                                <td>工资上限(): </td>
                                <td><input id="salary_2_new" class="form-control" type="number" value="0"/></td>

                                <td>试用期工资: </td>
                                <td><input id="shiyongqi_new"  class="form-control" type="number" value="0"/></td>
                                <td>实习工资: </td>
                                <td><input id="shixi_new" class="form-control" type="number" value="0"/></td>

                                <td>福利: </td>
                                <td><input id="fuli_new"  class="form-control" /></td>
                                <td>加入企业qq(*): </td>
                                <td>
                                    <select id="isQiqq_new" class="form-control" >
                                        <option value="否">否</option>
                                        <option value="是">是</option>
                                    </select>
                                </td>

                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="row" >
            <div class="col-lg-12">
                <button type="button" class="btn btn-default" onclick="onAddNew()" style="margin-left: 50px">新增企业联系记录</button>
                <button type="button" class="btn btn-default" onclick="onSaveNew()" style="margin-left: 50px">保存企业联系记录</button>
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
