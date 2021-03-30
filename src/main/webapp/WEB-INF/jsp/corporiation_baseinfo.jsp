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
    <script src="/js/jquery.form.js"></script>

    <script type="text/javascript">
        var rowIndex = -1
        var cid;
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#startTime_summary').val(startTime);
            $('#endTime_summary').val(today);

            $('#time_new').text(today);

            $('#corporiationSumbit').submit(function (event) {
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
                                query()

                            }else{
                                alert( data.result + "-->" + data.reason);
                            }
                        }
                    });
                }

                return false;
            });


            $("#classteachers").change(function(){
                var ctid=$("#classteachers").val()
                $("#tidhid").val(ctid)
            })

//            $("#hidden_frame").load(function(){
//                var tempText=$(this);
//                var returnJson=tempText[0].contentDocument.body.textContent;  //从后台传过来的数据，拿到就可以做相应的业务代码了
//                alert(returnJson)
//            })



        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        function onAddNew() {
            $('#corporiations_new').val("")
            $('#address_new').val("")
            $('#contact_new').val("")
            $('#contactPosition_new').val("")
            $('#hrManager_new').val("")

            $('#tel_new').val("")
            $('#phone_new').val("")
            $('#qq_new').val("")
            $('#weichat_new').val("")

            $('#isQiyeQQ_new').val("否")
            $('#isEnroll_new').val("否")

            $('#describe_new').val("")
        }


        function onSaveNew() {
            var cname = $('#corporiations_new').val()
            var caddress = $('#address_new').val()
            var contectName = $('#contact_new').val()
            var contactPosition = $('#contactPosition_new').val()
            var hrmanager = $('#hrManager_new').val()

            var tel = $('#tel_new').val()
            var phone = $('#phone_new').val()
            var qq = $('#qq_new').val()
            var weichat = $('#weichat_new').val()

            var isQiyeQQ = $('#isQiyeQQ_new').val()
            var isEnroll = $('#isEroll_new').val()
            var describe = $('#describe_new').val()

            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var timee = now.getFullYear() + "-" + (month) + "-" + (day);

            var tid = $('#classteachers').val()

            if( (tel == null || tel.length == 0 )&&(phone == null || phone.length == 0) &&
                    (qq == null || qq.length == 0) && (weichat == null || weichat.length == 0)){
                alert("固话 手机 qq 微信您至少应填写一项")
                return
            }

            if(
                    cname == null || cname.length == 0 ||
                    caddress == null || caddress.length == 0 ||
                    contectName == null || contectName.length == 0 ||
                    contactPosition == null || contactPosition.length == 0 ||
                    describe == null || describe.length == 0
            ){
                alert("请您填写所有必填项(*)")
                return
            }



            $.post(
                    "/corporiate/saveNewCorporiation",
                    {"cname":cname,"caddress":caddress, "contectName":contectName,"contactPosition":contactPosition, "hrmanager":hrmanager,
                        "tel":tel,"phone":phone, "qq":qq, "weichat":weichat, "isQiyeQQ":isQiyeQQ,
                        "describee":describe,"timee":timee,"tid":tid,"isEnroll":isEnroll},
                    function (corporiation) {
                        if(corporiation != null){
                            var str = "<tr>"
                            str = str + "<td>" + corporiation.cid + "</td>"
                            str = str + "<td><a href='javascript:void(0)' onclick='edit( " + corporiation.cid + ")'>编辑</a></td>"
                            str = str + "<td>" + corporiation.cname + "</td>"
                            str = str + "<td>" + corporiation.caddress + "</td>"
                            str = str + "<td>" + corporiation.describee + "</td>"
                            str = str + "<td>" + corporiation.contectName + "</td>"
                            str = str + "<td>" + corporiation.contactPosition + "</td>"

                            str = str + "<td>" + corporiation.hrmanager + "</td>"
                            str = str + "<td>" + corporiation.tel + "</td>"
                            str = str + "<td>" + corporiation.phone + "</td>"
                            str = str + "<td>" + corporiation.qq + "</td>"
                            str = str + "<td>" + corporiation.weichat + "</td>"

                            str = str + "<td>" + corporiation.isQiyeQQ + "</td>"
                            str = str + "<td>" + corporiation.isEnroll + "</td>"
                            str = str + "<td>0</td>"
                            str = str + "<td>0</td>"
                            str = str + "<td>" + corporiation.timee + "</td>"

                            var recorder = $('#classteachers').find("option:selected").text();
                            str = str + "<td>" + recorder + "</td>"


                            str = str + "</tr>"
                            $('#tbody_corporiation').append(str)

                            alert("新增企业保存成功!")
                        }
                    }
            );


        }

        function mohuquery() {
            var name = $('#name_search').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的企业名!")
                return
            }

            $.post(
                    "/corporiate/listCorporiationsByName",
                    {"name":name},
                    function (corporiations) {
                        showCorporiations(corporiations)
                    }
            );
        }

        function querydown() {
            var numbers = $('#numbers').val()
            var isEnroll = $('#isEnroll_search').val()
            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            if(numbers < 0){
                alert("入职人数应该 >=0")
                return
            }else{
                window.location.href="/corporiate/downloadCorporations?numbers=" + numbers + "&isEnroll=" +isEnroll + "&startTime="+startTime+"&endTime="+endTime;
            }
        }




        function query(){
            var numbers = $('#numbers').val()
            var isEnroll = $('#isEnroll_search').val()
            var startTime = $('#startTime_search').val()
            var endTime = $('#endTime_search').val()

            if(numbers < 0){
                alert("入职人数应该 >=0")
                return
            }else{
                $.post(
                        "/corporiate/listCorporiationBseInos",
                        {"numbers":numbers,"isEnroll":isEnroll,"startTime":startTime,"endTime":endTime},
                        function (corporiations) {
                            showCorporiations(corporiations)
                        }
                );
            }
        }

        function showCorporiations(corporiations) {
            if(null != corporiations){
                var length = corporiations.length
                $('#tbody_corporiation').empty()

                for(var i = 0; i < length; i++){
                    var corporiation = corporiations[i]

                    var str = "<tr>"
                    str = str + "<td>" + corporiation.cid + "</td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='edit( " + corporiation.cid + ")'>编辑</a></td>"
                    str = str + "<td>" + corporiation.cname + "</td>"
                    str = str + "<td>" + corporiation.caddress + "</td>"
                    str = str + "<td>" + corporiation.describee + "</td>"

                    str = str + "<td>" + corporiation.contectName + "</td>"
                    str = str + "<td>" + corporiation.contactPosition + "</td>"
                    str = str + "<td>" + corporiation.hrmanager + "</td>"
                    str = str + "<td>" + corporiation.tel + "</td>"

                    str = str + "<td>" + corporiation.phone + "</td>"
                    str = str + "<td>" + corporiation.qq + "</td>"
                    str = str + "<td>" + corporiation.weichat + "</td>"
                    str = str + "<td>" + corporiation.isQiyeQQ + "</td>"

                    str = str + "<td>" + corporiation.isEnroll + "</td>"
                    str = str + "<td>" + corporiation.stuNumbers + "</td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='showYearNumber( " + corporiation.cid + ")'>年度详情</a></td>"
                    str = str + "<td>" + corporiation.timee + "</td>"
                    str = str + "<td>" + corporiation.tname + "</td>"


                    str = str + "</tr>"

                    $('#tbody_corporiation').append(str)

                }
            }

        }

        function getRowIndex(id){
            var rows = $("#tbody_corporiation").find("tr")
            var length = rows.length
            for(var i = 0; i < length; i++){
                var tds = rows.eq(i).find("td")
                if(tds.eq(0).text() == id){
                    return tds
                }
            }
            return null;
        }

        function edit(id){
            cid = id
            var tds = getRowIndex(id)
            if(tds != null){
                $("#cname_e").val(tds.eq(2).text())
                $("#cadress_e").val(tds.eq(3).text())
                $("#describe_e").val(tds.eq(4).text())
                $("#contactNmae_e").val(tds.eq(5).text())
                $("#contactPosition_e").val(tds.eq(6).text())
                $("#hrmanager_e").val(tds.eq(7).text())
                $("#tel_e").val(tds.eq(8).text())
                $("#phone_e").val(tds.eq(9).text())
                $("#qq_e").val(tds.eq(10).text())
                $("#weichat_e").val(tds.eq(11).text())
                $("#isQiye_e").val(tds.eq(12).text())
                $("#isEnroll_e").val(tds.eq(13).text())
            }

            $("#corporiationModal_edit").modal()

        }


        function saveCorporiationUpdate(){
            var cname = $("#cname_e").val()
            var caddress = $("#cadress_e").val()
            var describee = $("#describe_e").val()
            var connectName = $("#contactNmae_e").val()
            var contactPosition = $("#contactPosition_e").val()
            var hrmanager = $("#hrmanager_e").val()
            var tel = $("#tel_e").val()
            var phone = $("#phone_e").val()
            var qq = $("#qq_e").val()
            var weichat = $("#weichat_e").val()

            var isQiye = $("#isQiye_e").val()
            var isEnroll = $("#isEnroll_e").val()
            $.post(
                    "/corporiate/updateCorporiationInfo",
                    {"cname":cname,"caddress":caddress,"describee":describee,"contectName":connectName,"contactPosition":contactPosition,"hrmanager":hrmanager,
                        "tel":tel,"phone":phone,"qq":qq,"weichat":weichat, "isQiyeQQ":isQiye,"isEnroll":isEnroll,"cid":cid
                    },
                    function (data) {
                        if(data == "success"){
                            var tds = getRowIndex(cid)
                            tds.eq(2).text(cname)
                            tds.eq(3).text(caddress)
                            tds.eq(4).text(describee)
                            tds.eq(5).text(connectName)
                            tds.eq(6).text(contactPosition)
                            tds.eq(7).text(hrmanager)
                            tds.eq(8).text(tel)
                            tds.eq(9).text(phone)
                            tds.eq(10).text(qq)
                            tds.eq(11).text(weichat)
                            tds.eq(12).text(isQiye)
                            tds.eq(13).text(isEnroll)

                            alert("保存数据成功")
                        }else{
                            alert("保存数据失败")
                        }
                    }
            );

        }

        function onDownload() {
            //window.open("/corporiate/onDownload");
            window.location.href="/corporiate/onDownload";
        }


    </script>

</head>

<body>

<div class="modal fade" id="corporiationModal_edit" tabindex="-1" role="dialog" aria-labelledby="corporiationModal_edit">
    <div class="modal-dialog" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">企业信息编辑</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody>
                    <tr>
                        <td>公司名</td>
                        <td><input class="form-control" id="cname_e"></td>
                        <td>公司地址</td>
                        <td><input class="form-control" id="cadress_e"></td>
                    </tr>

                    <tr>
                        <td>公司介绍</td>
                        <td colspan="3"><textarea rows="5" class="form-control" id="describe_e"></textarea></td>
                    </tr>

                    <tr>
                        <td>联系人名</td>
                        <td><input class="form-control" id="contactNmae_e"></td>
                        <td>职位</td>
                        <td><input class="form-control" id="contactPosition_e"></td>
                    </tr>

                    <tr>
                        <td>hr经理</td>
                        <td><input class="form-control" id="hrmanager_e"></td>
                        <td>固定电话</td>
                        <td><input class="form-control" id="tel_e"></td>
                    </tr>

                    <tr>
                        <td>手机</td>
                        <td><input class="form-control" id="phone_e"></td>
                        <td>QQ</td>
                        <td><input class="form-control" id="qq_e"></td>
                    </tr>
                    <tr>
                        <td>微信</td>
                        <td><input class="form-control" id="weichat_e"></td>
                        <td>加入企业QQ</td>
                        <td>
                            <select class="form-control" id="isQiye_e">
                                <option value="否">否</option>
                                <option value="是">是</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>是否签约</td>
                        <td>
                            <select class="form-control" id="isEnroll_e">
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
                <button type="button"  class="btn btn-primary" onclick="saveCorporiationUpdate()">保存</button>
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
                <h1 class="page-header">企业基础信息</h1>
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
                                <td style="text-align:right;">入职人数>=:</td>
                                <td>
                                    <input  class="form-control" id="numbers" type="number" value="0" style="display: inline;width: 150px">
                                </td>
                                <td style="text-align:right;">是否签约:</td>
                                <td>
                                    <select class="form-control" id="isEnroll_search" style="min-width: 150px">
                                        <option value="全部">全部</option>
                                        <option value="是">是</option>
                                        <option value="否">否</option>
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
                                <td style="text-align:right;"><img src="/img/down.png" onclick="querydown()" style="width: 32px;"/></td>
                                <td>
                                    <button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px;">条件查询</button>
                                </td>
                            </tr>

                        </table>
                    </div>
                    <div class="col-lg-3" style="background: #eeeeee;text-align: center;">

                        <table  style="border-collapse:separate; border-spacing:30px 20px;margin:auto"  rules=none  >
                            <tr>
                                <td>
                                    <input  id="name_search" class = "form-control" placeholder = "企业名字" style="width: 150px;">
                                </td>
                            </tr>
                            <tr>
                                <td><button type="button" class="btn btn-primary" onclick="mohuquery()" style="width: 150px;">模糊查询</button></td>
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
                    <div style="width:2000px;height: 500px;border: 1px solid #ddd">
                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                            <thead id="thead_talks">
                            <th>id</th>
                            <th>编辑</th>
                            <th>公司名</th>
                            <th>公司地址</th>
                            <th>公司介绍</th>
                            <th>联系人姓名</th>
                            <th>联系人职位</th>
                            <th>hr经理</th>
                            <th>固定电话</th>
                            <th>手机</th>
                            <th>qq</th>
                            <th> 微信</th>
                            <th>进入企业QQ</th>
                            <th>是否签约企业</th>
                            <th>累计录用学生数</th>
                            <th>年度录用学生数</th>
                            <th>录入时间</th>
                            <th>录入人</th>
                            </thead>
                            <tbody id="tbody_corporiation">
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- /.table-responsive -->
            </div>
            <!-- /.panel-body -->
        </div>
        <div class="row" style="margin-top: 10px;">
            <label style="margin-left: 50px" >企业规划师:</label>
            <select id="classteachers" class="from-inline">
                <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                    <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                </c:forEach>
            </select>
            <label style="color: red;margin-left: 400px;">注意:手机、固话、微信、QQ须填写一个; 优选固话.</label>
        </div>
        <div class="row">
            <div style="border: 1px solid #ddd">
                <div class="col-lg-12" style="padding-left: 0px;padding-right: 0px;">
                    <table  class="table table-striped table-bordered table-hover text-nowrap">
                        <tbody id="tbody_new">
                        <tr>
                            <td width="8%">公司名(*):</td>
                            <td width="12%"><input id="corporiations_new" class="form-control"></td>
                            <td width="8%">公司地址(*): </td>
                            <td width="12%"><input id="address_new" class="form-control"/></td>
                            <td width="8%">联系人姓名(*):</td>
                            <td width="12%"><input id="contact_new" class="form-control"></td>
                            <td width="8%">联系人职位(*):</td>
                            <td width="12%"><input id="contactPosition_new" class="form-control"></td>
                            <td width="8%">hr经理:</td>
                            <td width="12%"><input id="hrManager_new" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>固定电话: </td>
                            <td><input id="tel_new"  class="form-control" style="background:  #eff7ff;" /></td>
                            <td>手机: </td>
                            <td><input id="phone_new" class="form-control" style="background:  #eff7ff;" /></td>
                            <td>qq: </td>
                            <td><input id="qq_new" class="form-control" placeholder="qq号" style="background:  #eff7ff;" /></td>
                            <td>微信: </td>
                            <td><input id="weichat_new" class="form-control" placeholder="微信号" style="background:  #eff7ff;" /></td>

                            <td>加入企业QQ: </td>
                            <td >
                                <select id="isQiyeQQ_new"  class="form-control" >
                                    <option value="否">否</option>
                                    <option value="是">是</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td>是否签约企业:</td>
                            <td>
                                <select id="isEroll_new"  class="form-control" >
                                    <option value="否">否</option>
                                    <option value="是">是</option>
                                </select>
                            </td>
                            <td>公司介绍(*):</td>
                            <td colspan="9"><input id="describe_new" class="form-control"></td>

                        </tr>

                        </tbody>
                    </table>
                </div>
                <div class="col-lg-12" style="padding-left: 0px;padding-right: 0px;">
                    <div class="panel panel-default" style="float:left;">
                        <div class="panel-body">
                            <button type="button" class="btn btn-default" onclick="onAddNew()" style="margin-right: 50px">新增企业信息</button>
                            <button type="button" class="btn btn-default" onclick="onSaveNew()" style="margin-left: 50px">保存企业信息</button>
                        </div>
                    </div>
                    <div class="panel panel-default" style="float:right;">

                        <div class="panel-body">
                            <button type="button" class="btn btn-primary" onclick="onDownload()" style="margin-right: 50px;">标准企业模板下载</button>
                            <form id='corporiationSumbit' class="form-inline" role="form"   action="/corporiate/importCorporiations" method="post" enctype="multipart/form-data"  style="display:inline;">
                                <input id="tidhid" name="tidhid"  type="hidden" value="${requestScope.classteachers[0].ctid}">
                                <input type="file" name="excelFile" id="excelFile" class="file-loading" multiple accept=".xls,.xlsx" style="display: inline">
                                <input type="submit" name="upload" value="导入企业信息" class="btn btn-primary">
                                <%--<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>--%>
                            </form>
                        </div>
                    </div>
                </div>
                <div style="clear: both"></div>
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
