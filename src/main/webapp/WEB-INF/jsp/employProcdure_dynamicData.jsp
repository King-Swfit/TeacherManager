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


    <%--<script src="/js/jquery.js" ></script>--%>
    <%--<link  rel="stylesheet"  type="text/css"  href="/css/jquery.editable-select.css"/>--%>
    <%--<script src="/js/jquery.editable-select.js" ></script>--%>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <%--<script src="/jquery/jquery-1.10.2.min.js"></script>--%>
    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src='/datetimepicker/js/bootstrap-datetimepicker.min.js'></script>
    <script src="/datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <link href="/datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet">

    <%--<link type="text/css" rel="stylesheet" href="/jdate/test/jeDate-test.css">--%>
    <link type="text/css" rel="stylesheet" href="/jdate/skin/jedate.css">
    <script type="text/javascript" src="/jdate/src/jedate.js"></script>

    <script type="text/javascript">
        var rowIndex = -1
        var today
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime = "2000-01-01"

            $('#startTime_d').val((now.getFullYear() - 1) + "-" + (month) + "-" + (day));
            $('#endTime_d').val(today);
            $("#directions_d").attr("disabled","disabled");
            $("#classcodes_d").attr("disabled","disabled");




            $('#time_iv').datetimepicker({
                format: 'yyyy-mm-dd hh:ii'      /*此属性是显示顺序，还有显示顺序是mm-dd-yyyy*/
            });




            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=-1;
                var type = $('#types_search').val()
                var result = $('#results_search').val()

                $.post(
                        "/employ/getClassCodeByCondition",
                        {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":today,"type":type,"result":result},
                        function (data) {
                            if(data != null && data.classcodes != null){
                                refreshUI(data)
                            }
                        }
                );
            })

            $("#classteachers_search").change(function(){
                var centerId=$("#centers_search").val()
                var ctid=$("#classteachers_search").val();
                var type = $('#types_search').val()
                var result = $('#results_search').val()

                if(ctid > 0){
                    $.post(
                            "/employ/getClassCodeByCondition",
                            {"centerId":centerId,"ctid":ctid, "startTime":startTime,"endTime":today,"type":type,"result":result},
                            function (data) {
                                if(data != null && data.classcodes != null){
                                    refreshUI(data)
                                }

                            }
                    );
                }

            })


            $("#classcodes_search").change(function(){
                var classcode=$("#classcodes_search").val()
                var type = $('#types_search').val()
                var result = $('#results_search').val()

                if(classcode != null && classcode.length > 0){
                    $.post(
                            "/employ/listProcessEmployInterviewRecordByCondition",
                            {"classcode":classcode,"type":type,"result":result},
                            function (processEmployInterviewRecords) {
                                showInterviewSummary(processEmployInterviewRecords)
                            }
                    );
                }else{
                    alert("请选择正确的的班级编号");
                }

            })


            $('#employInfosSumbit').submit(function (event) {
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

            //上传图片
            $('#uploadImgSumbit').submit(function (event) {
                //首先验证文件格式
                var fileName = $(this).find("input[name=imgFile]").val();
                if (fileName === '') {
                    alert('请选择文件');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'jpg' && fileType !== 'jpeg' && fileType !== 'bmp'&& fileType !== 'png') {
                    alert('文件格式不正确，图片文件！');
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
                            if(data.result.length > 0){
                                $("#img_new").attr("src", data.address)
                                $("#imgurl").val(data.result)

                                return false;

                            }else{
                                alert("图片上传失败")
                            }
                        }
                    });
                }

                return false;
            });


            //上传图片
            $('#uploadImgSumbit2').submit(function (event) {
                //首先验证文件格式
                var fileName = $(this).find("input[name=imgFile2]").val();
                if (fileName === '') {
                    alert('请选择文件');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'jpg' && fileType !== 'jpeg' && fileType !== 'bmp'&& fileType !== 'png') {
                    alert('文件格式不正确，图片文件！');
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
                            if(data.result.length > 0){
                                $("#img_upload2").attr("src", data.address)
                                $("#imgurl2").val(data.result)

                                return false;

                            }else{
                                alert("图片上传失败")
                            }
                        }
                    });
                }

                return false;
            });

        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        function refreshUI(data){

            var str = ""
            var length


            if(data.classTeachers != null){
                $("#classteachers_search").empty()
                str = ""
                length = data.classTeachers.length
                for(var i = 0; i < length; i++){
                    str = str + "<option value='" + data.classTeachers[i].ctid + "'>" + data.classTeachers[i].ctname + "</option>"
                }
                $("#classteachers_search").append(str)
            }

            $("#classcodes_search").empty()
            if(data.classcodes != null){
                str = ""
                length = data.classcodes.length
                for(var i = 0; i < length; i++){
                    str = str + "<option value='" + data.classcodes[i] + "'>" + data.classcodes[i] + "</option>"
                }
                $("#classcodes_search").append(str)
            }

            showInterviewSummary(data.processEmployInterviewRecords)

        }

        function showInterviewSummary(processEmployInterviewRecords) {
            $('#tbody_interviews').empty()
            if(processEmployInterviewRecords != null){
                length = processEmployInterviewRecords.length
                for(var i = 0; i < length; i++){
                    str = "<tr>"
                    str = str + "<td>" + processEmployInterviewRecords[i].code +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].name +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].classcode +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].dname +  "</td>"


                    if(processEmployInterviewRecords[i].result != null && processEmployInterviewRecords[i].result == "成功"){
                        str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"

                        str = str + "<td>" + processEmployInterviewRecords[i].entertimee +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].corporiation +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].position +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].realSalary +  "</td>"

                        if(processEmployInterviewRecords[i].employProof != null && processEmployInterviewRecords[i].employProof.length > 0){
                            str = str + "<td><a href='javascript:void(0)' onclick='employProof( \"" + processEmployInterviewRecords[i].code + "\")'>点击查看</a></td>"
                        }else{
                            str = str + "<td>无</td>"
                        }

                    }else{
                        if(processEmployInterviewRecords[i].type == null){
                            processEmployInterviewRecords[i].type = "未知"
                        }
                        str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"

                        str = str + "<td>未知</td>"
                        str = str + "<td>未知</td>"
                        str = str + "<td>未知</td>"
                        str = str + "<td>未知</td>"

                        str = str + "<td>无</td>"
                    }


                    var code = processEmployInterviewRecords[i].code
                    var name = processEmployInterviewRecords[i].name
                    str = str + "<td><a href='javascript:void(0)' onclick='interviewDetail(\"" +  code  + "\")'>面试详情</a></td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='addInterviewDlg(\"" +  code  + "\",\"" + name + "\")'>新增面试</a></td>"

                    str = str + "<td>" + processEmployInterviewRecords[i].graducateTime +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].diploma +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].graduateSchool +  "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].profession +  "</td>"


                    str = str + "</tr>"

                    $('#tbody_interviews').append(str)
                }
            }

        }

        function showInterviewDetails(processEmployInterviewRecords) {
            if (null != processEmployInterviewRecords) {

                $('#tbody_interviews_detail').empty()
                var length = processEmployInterviewRecords.length
                for (var i = 0; i < length; i++) {
                    str = "<tr>"
                    str = str + "<td>" + processEmployInterviewRecords[i].peiid + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].code + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].name + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].classcode + "</td>"

                    str = str + "<td>" + processEmployInterviewRecords[i].datetimee + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].entertimee + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].corporiation + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].position + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].salary + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].result + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].realSalary + "</td>"
                    str = str + "<td>" + processEmployInterviewRecords[i].fuli + "</td>"

                    if(processEmployInterviewRecords[i].result=="成功"){
                        if(processEmployInterviewRecords[i].employProof != null && processEmployInterviewRecords[i].employProof.length > 0){
                            str = str + "<td><a href='javascript:void(0)' onclick='employProofByPeiid(\" " + processEmployInterviewRecords[i].peiid + "\")'>点击查看</a></td>"
                        }else{
                            str = str + "<td><a href='javascript:void(0)' onclick='uploadEmployProof(\" " + processEmployInterviewRecords[i].code + "\")'>上传就业依据</a></td>"
                        }

                    }else{
                        str = str + "<td>无</td>"
                    }

                    str = str + "<td><a href='javascript:void(0)' onclick='deleteInterviewRecord( " + processEmployInterviewRecords[i].peiid + ",\"" + processEmployInterviewRecords[i].code + "\")'>删除</a></td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='editInterviewRecord( " + processEmployInterviewRecords[i].peiid + ",\"" + processEmployInterviewRecords[i].code + "\")'>编辑</a></td>"


                    str = str + "</tr>"

                    $('#tbody_interviews_detail').append(str)
                }

            } else {
                $('#tbody_interviews_detail').empty()
            }
        }

        function addInterviewDlg(code,name) {
            //清除痕迹，用户名，学号覆盖
            $("#code_new").html(code)
            $("#name_new").html(name)

            $("#img_new").attr("src", "/img/default.jpg")
            $("#code").val(code)
            $("#imgurl").val("")

            $("#iv_time_new").val("")
            $("#iv_entertime_new").val("")
            $("#iv_coporiation_new").val("")

            $("#iv_position_new").val("")

            $('#types_new option:first').prop('selected', 'selected');
            $("#iv_salary_new").val("")

            $('#result_new option:first').prop('selected', 'selected');


            $("#iv_fuli_new").val("")






            $("#employModal_new").modal()
        }


        function uploadEmployProof(code) {
            $("#img_upload2").attr("src", "/img/default.jpg")
            $("#imgurl2").val("")
            $("#code2").val(code)


            $("#imgModal_upload").modal()

        }


        function saveEmployProof() {
            var proof = $("#imgurl2").val()
            var code = $("#code2").val()

            $.post(
                    "/employ/insertInterviewImgurl",
                    {
                        "code":code,"employProof":proof
                    },
                    function (result) {
                        if(result == "success"){
                            //更新状态
                            var trs = $('#tbody_interviews_detail').find("tr")
                            var length = trs.length
                            for(var i = 0; i < length; i++){
                                var val = trs.eq(i).find("td").eq(10).html()
                                if(val == "成功"){
                                    trs.eq(i).find("td").eq(13).html("<td><a href='javascript:void(0)' onclick='employProof(\" " + code + "\")'>点击查看</a></td>")
                                    break
                                }
                            }
                            $("#imgModal_upload").modal('hide')
                            alert("上传图片依据成功!")
                        }else{
                            alert("上传图片依据失败!")
                        }
                    }
            );
        }


        function querydown() {
            var classcode = $('#classcodes_search').val()
            var type = $('#types_search').val()
            var result = $('#results_search').val()
            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                window.location.href="/employ/downloadEmployInfo?classcode=" + classcode + "&type=" +type + "&result="+result;

            }
        }



        function query(){
            querySummary()
            $('#tbody_interviews_detail').empty()
        }

        function querySummary(){
            var classcode = $('#classcodes_search').val()
            var type = $('#types_search').val()
            var result = $('#results_search').val()
            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/employ/listProcessEmployInterviewRecordByCondition",
                        {"classcode":classcode,"type":type,"result":result},
                        function (processEmployInterviewRecords) {
                            showInterviewSummary(processEmployInterviewRecords)
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
                    "/employ/getProcessEmployInterviewRecordsByName",
                    {"name":name},
                    function (processEmployInterviewRecords) {
                        showInterviewSummary(processEmployInterviewRecords)
                        $('#tbody_interviews_detail').empty()
                    }
            );
        }

        function mohuquery_coporiation() {
            var name = $('#iv_coporiation_new_mohu').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/corporiate/getCorporiationsByName",
                    {"name":name},
                    function (corporiations) {
                        if(corporiations != null){
                            var length = corporiations.length
                            $("#iv_coporiation_new").empty()
                            var str
                            for(var i = 0; i < length; i++){
                                str = str + "<option value='" + corporiations[i].cname + "'>" +   corporiations[i].cname +  "</option>"
                            }
                            $("#iv_coporiation_new").append(str)
                        }
                    }
            );
        }

        function interviewDetail(code) {

            $.post(
                    "/employ/listProcessEmployInterviewRecordByCode",
                    {"code":code},
                    function (processEmployInterviewRecords) {
                        showInterviewDetails(processEmployInterviewRecords)
                    }
            );
        }





        function saveNewInterview(){

            var code = $("#code_new").text()
            var name =  $("#name_new").text()

            var datetimee =  $("#iv_time_new").val()
            var entertimee =  $("#iv_entertime_new").val()

            var corporiation_m =  $("#iv_coporiation_new_mohu").val()
            var corporiation =  $("#iv_coporiation_new").val()

            if(corporiation != null && corporiation.length > 0 ){
                corporiation_m = corporiation
            }

            var position=  $("#iv_position_new").val()
            var type =  $("#types_new").val()

            var salary =  $("#iv_salary_new").val()
            var result =  $("#result_new").val()

            var realSalary=  $("#iv_realSalary_new").val()
            var fuli =  $("#iv_fuli_new").val()

            if(salary == null || salary.length == 0){
                salary = 0
            }
            if(realSalary == null || realSalary.length == 0){
                realSalary = 0
            }
            if(datetimee == null || datetimee.length == 0){
                datetimee = '0001-01-01'
            }

            if(entertimee == null || entertimee.length == 0){
                entertimee = '0001-01-01'
            }

            var proof = $("#imgurl").val()
            if((type == "自主" && result != "成功") || (type == "推荐"&& result != "成功" )  || (type == "自主择业") || (type == "延迟就业")){

            }else{
                proof = ""
            }



            $.post(
                    "/employ/insertInterviewRecord",
                    {"datetimee":datetimee,"entertimee":entertimee, "corporiation":corporiation_m,
                        "position":position,"type":type,"salary":salary,
                        "result":result,"realSalary":realSalary,"fuli":fuli,"code":code,"employProof":proof
                    },
                    function (processEmployInterviewRecords) {
                        if(processEmployInterviewRecords != null){
                            showInterviewDetails(processEmployInterviewRecords)
                            query()

                            $("#employModal_new").modal('hide')
                        }else{
                            alert("保存数据失败")
                        }
                    }
            );

        }


        //显示图片
        function employProof(code) {
            $.post(
                    "/employ/getImgurlByCode",
                    {"code":code},
                    function (imgurl) {
                        if(imgurl != null){
                            $("#showImg").attr("src",imgurl);
                            $('#showImageModal').modal();
                        }else{
                            alert("获取图片失败")
                        }

                    }
            );
        }


        function employProofByPeiid(peiid){
            $.post(
                    "/employ/getImgurlByPeiid",
                    {"peiid":peiid},
                    function (imgurl) {
                        if(imgurl != null){
                            $("#showImg").attr("src",imgurl);
                            $('#showImageModal').modal();
                        }else{
                            alert("获取图片失败")
                        }

                    }
            );
        }

        function deleteInterviewRecord(peiid,code) {
            if(peiid == null){
                alert("面试记录id为空!无法删除")
                return
            }

            if(confirm("您确定删除该面试记录吗?")){
                //点击确定后操作
                $.post(
                        "/employ/deleteInterViewRecordByPeiid",
                        {"peiid":peiid},
                        function (result) {
                            if(result == null || result == "fail"){
                                alert("面试记录删除失败")
                            }else{
                                interviewDetail(code)
                                updateInterviewRecordInWhole(code)
                                alert("面试记录删除成功")
                            }

                        }
                );

            }


        }


        function edit_mohuquery_coporiation() {
            var name = $('#iv_coporiation_edit_mohu').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/corporiate/getCorporiationsByName",
                    {"name":name},
                    function (corporiations) {
                        if(corporiations != null){
                            var length = corporiations.length
                            $("#iv_coporiation_edit").empty()
                            var str
                            for(var i = 0; i < length; i++){
                                str = str + "<option value='" + corporiations[i].cname + "'>" +   corporiations[i].cname +  "</option>"
                            }
                            $("#iv_coporiation_edit").append(str)
                        }
                    }
            );
        }
        function editInterviewRecord(peiid,code) {
            if(peiid == null){
                alert("面试记录id为空!无法编辑")
                return
            }

            $.post(
                    "/employ/getInterviewRecordByPeiid",
                    {"peiid":peiid},
                    function (interviewRecord) {
                        if(interviewRecord == null || interviewRecord == "fail"){
                            alert("面试记录查询失败")
                        }else{
                            $("#code_edit").text(interviewRecord.code)
                            $("#name_edit").text(interviewRecord.name)
                            $("#iv_time_edit").val(interviewRecord.datetimee)
                            if(interviewRecord.type=='自主'){
                                 $("#tr_coporiation_edit").val(interviewRecord.corporiation)
                                $("#iv_coporiation_edit").empty()
                            }else{
                                $("#iv_coporiation_edit").empty()
                                var str = str + "<option value='" + interviewRecord.corporiation + "'>" +interviewRecord.corporiation + "</option>"
                                $("#iv_coporiation_edit").append(str)
                                
                                $("#tr_coporiation_edit").val("")
                            }

                            $("#iv_position_edit").val(interviewRecord.position)
                            $("#types_edit").val(interviewRecord.type)
                            $("#iv_salary_edit").val(interviewRecord.salary)
                            $("#result_edit").val(interviewRecord.result)

                            $("#iv_realSalary_edit").val(interviewRecord.realSalary)
                            $("#iv_fuli_edit").val(interviewRecord.fuli)
                            $("#iv_entertime_edit").val(interviewRecord.entertimee)


                            $("#peiid_edit").val(peiid)


                            $("#img_edit").attr('src', interviewRecord.imgurl)
                            $("#imgurl_edit").attr('src', interviewRecord.employProof)




                            $("#employModal_edit").modal()




                        }

                    }
            );

        }
        
        function updateInterview() {
            var peiid = $("#peiid_edit").val()
            var code = $("#code_edit").text()
            var datetimee = $("#iv_time_edit").val()
            var entertimee = $("#iv_entertime_edit").val()

            var corporiation = $("#iv_coporiation_edit").val()
            var corporiation_m = $("#iv_coporiation_edit_mohu").val()
            if(corporiation != null || corporiation.length > 0){
                corporiation_m = corporiation
            }

            var position = $("#iv_position_edit").val()
            var type = $("#types_edit").val()

            var result = $("#result_edit").val()

            var salary = $("#iv_salary_edit").val()
            var realSalary = $("#iv_realSalary_edit").val()


            var fuli = $("#iv_fuli_edit").val()
            var proof = $("#imgurl_edit").val()

            if(salary == null || salary.length == 0){
                salary = 0
            }
            if(realSalary == null || realSalary.length == 0){
                realSalary = 0
            }
            if(datetimee == null || datetimee.length == 0){
                datetimee = '0001-01-01'
            }

            if(entertimee == null || entertimee.length == 0){
                entertimee = '0001-01-01'
            }

            var proof = $("#imgurl_edit").val()
            if((type == "自主" && result != "成功") || (type == "推荐"&& result != "成功" )  || (type == "自主择业") || (type == "延迟就业")){

            }else{
                proof = ""
            }




            $.post(
                    "/employ/updateInterviewRecord2",
                    {"datetimee":datetimee,"entertimee":entertimee, "corporiation":corporiation_m,
                        "position":position,"type":type,"salary":salary,
                        "result":result,"realSalary":realSalary,"fuli":fuli,"peiid":peiid,"code":code, "employProof":proof
                    },
                    function (processEmployInterviewRecords) {
                        if(processEmployInterviewRecords != null){
                            querySummary()
                            showInterviewDetails(processEmployInterviewRecords)

                            $("#employModal_edit").modal('hide')
                        }else{
                            alert("保存数据失败")
                        }
                    }
            );
        }






        function updateInterviewRecordInWhole(code) {
            //找到该用户信息
//            $.post(
//                    "/employ/geInterViewRecordBtyPeiid",
//                    {"peiid":peiid},
//                    function (result) {
//                        if(result == null || result == "fail"){
//                            alert("面试记录删除失败")
//                        }else{
//                            interviewDetail(code)
//                            updateInterviewRecordInWhole(code)
//                            alert("面试记录删除成功")
//                        }
//
//                    }
//            );

            //更新对应行
        }

        function regionSelect(region) {
            $("#centers_d").attr("disabled","disabled");
            $("#directions_d").attr("disabled","disabled");
            $("#classcodes_d").attr("disabled","disabled");
            switch(region) {
                case "center":
                    $("#centers_d").removeAttr("disabled");
                    break;
                case "direction":
                    $("#directions_d").removeAttr("disabled");
                    break;
                case "class":
                    $("#classcodes_d").removeAttr("disabled");
                    break;
            }
        }

        function downloadEmployInfoDlg() {
            $("#exportEmployInfoModal").modal()
        }

        function onRefreshDate() {
            var startTime = $("#startTime_d").val()
            var endTime = $("#endTime_d").val()

            $.post(
                    "/jiaowu/getCenterDirectionClasscodesForTime",
                    {"startTime":startTime,"endTime":endTime},
                    function (data) {
                        if(data  != null){
                            var centers = data.centers_recent
                            var directions = data.directions_recent
                            var classcodes = data.classcodes_recent

                            $("#classcodes_d").empty()
                            var str = ""
                            if(classcodes != null){
                                for(var i = 0; i < classcodes.length; i++){
                                    str = "<option value='" + classcodes[i] +  "'>"+classcodes[i] + "</option>"
                                }
                            }
                            $("#classcodes_d").append(str)


                            $("#centers_d").empty()
                            str = ""
                            if(centers != null){
                                for(var i = 0; i < centers.length; i++){
                                    str = "<option value='" + centers[i].cid +  "'>"+centers[i].cname + "</option>"
                                }
                            }
                            $("#centers_d").append(str)


                            $("#directions_d").empty()
                            str = ""
                            if(directions != null){
                                for(var i = 0; i < directions.length; i++){
                                    str = "<option value='" + directions[i].did +  "'>"+directions[i].dname + "</option>"
                                }
                            }
                            $("#directions_d").append(str)



                        }else{
                            alert("刷新失败!")
                        }
                    }
            )

        }

        function exportEmployInfo() {
            region = $("input[name='region']:checked").val();
            var way = -1
            var value= -1
            alert(region)
            switch(region) {
                case "center":
                    value=$("#centers_d").val();
                    way=0
                    break;
                case "direction":
                    value=$("#directions_d").val()
                    way=1
                    break;
                case "center":
                    value=$("#classcodes_d").val()
                    way=2
                    break;
            }

            var startTime= $("#startTime_d").val()
            var endTime= $("#endTime_d").val()

            var type=$("#types_d").val()
            var result=$("#results_d").val()


            window.location.href="/employ/exportEmployInfo?way="+way+"&value=" + value + "&startTime="+startTime + "&endTime=" + endTime + "&type=" + type + "&result=" + result;
            $("#exportEmployInfoModal").modal("hide")

        }


        
        



    </script>


</head>

<body>

<div class="modal fade" id="showImageModal" tabindex="-1" role="dialog" aria-labelledby="imageModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">图片显示</h4>
            </div>
            <div class="modal-body" style="text-align: center">
                <img id="showImg" src="" width="400px" height="400px"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="employModal_new" tabindex="-1" role="dialog" aria-labelledby="employModal_new">
    <div class="modal-dialog" role="document" style="width: 55%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">新增面试记录</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody id="interview_new">
                    <tr>
                        <td>学员编号</td>
                        <td id="code_new"></td>
                        <td>姓名</td>
                        <td id="name_new"></td>
                    </tr>

                    <tr>
                        <td>面试时间</td>
                        <%--<td><input class="form-control" type="datetime" id="iv_time_new"></td>--%>
                        <td><input type="text" class="jeinput form-control" id="iv_time_new" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td>面试公司</td>
                        <td>
                            <table border=1 width="100%" frame=void rules=none style="border-collapse:separate; border-spacing:0px 10px;">
                                <tr>
                                    <td>
                                        <input  id="iv_coporiation_new_mohu" class="form-control" style="border-bottom-right-radius: 0;border-top-right-radius: 0" placeholder="公司名，点击‘匹配’时会自动匹配全名"/>
                                    </td>
                                    <td>
                                        <button type="button"  class="btn btn-primary"   onclick="mohuquery_coporiation()" style="border-bottom-left-radius: 0;border-top-left-radius: 0">匹配</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="iv_coporiation_new" class="form-control"></select>
                                    </td>
                                    <td>公司全名</td>
                                </tr>

                                <%--<tr>--%>
                                    <%--<td>--%>
                                        <%--<input id="tr_coporiation_new" class="form-control" placeholder="自助择业时，在此填公司" />--%>
                                    <%--</td>--%>
                                    <%--<td>自主公司</td>--%>
                                <%--</tr>--%>
                            </table>


                        </td>
                    </tr>

                    <tr>
                        <td>面试岗位</td>
                        <td><input class="form-control" id="iv_position_new"></td>
                        <td>面试类型</td>
                        <td>
                            <select id="types_new" class="form-control">
                                <c:forEach var="employType" items="${requestScope.employTypes}" >
                                    <option value="${employType}">${employType}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>预计薪资</td>
                        <td><input class="form-control" type="number" id="iv_salary_new"></td>
                        <td>面试结果</td>
                        <td>
                            <select class="form-control" id="result_new">
                                <option value="未知">未知</option>
                                <option value="成功">成功</option>
                                <option value="失败">失败</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>实际薪资</td>
                        <td><input class="form-control" type="number" id="iv_realSalary_new"></td>
                        <td>福利</td>
                        <td><input class="form-control" id="iv_fuli_new"></td>
                    </tr>
                    <tr>
                        <td>入职时间</td>
                        <td><input type="text" class="jeinput form-control" id="iv_entertime_new" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td>就业依据</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit' class="form-horizontal"  action="/employ/uploadImg" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile" id="imgFile" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_new"/>
                                <input type="submit" name="upload" value="上传" class="btn btn-primary">
                                <input type="hidden"  name="code" id="code" value="" />
                                <input type="hidden"  name="imgurl" id="imgurl" value="" />
                            </form>
                        </td>
                    </tr>

                    </tbody>
                </table>
                <h3 style="color: #003399">注意：面试类型为自主、推荐时，只有面试结果为成功时，才可以上传图片。否则无效! </h3>
                <h3 style="color: #003399">面试类型为自主择业、延迟就业时，可以直接上传图片</h3>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveNewInterview()">保存</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="employModal_edit" tabindex="-1" role="dialog" aria-labelledby="employModal_edit">
    <div class="modal-dialog" role="document" style="width: 55%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">面试记录编辑</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody id="interview_edit">
                    <tr>
                        <td>学员编号</td>
                        <td id="code_edit"></td>
                        <td>姓名</td>
                        <td id="name_edit"></td>
                    </tr>

                    <tr>
                        <td>面试时间</td>
                        <%--<td><input class="form-control" type="datetime" id="iv_time_new"></td>--%>
                        <td><input type="text" class="jeinput form-control" id="iv_time_edit" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td>面试公司</td>
                        <td>
                            <table border=1 width="100%" frame=void rules=none style="border-collapse:separate; border-spacing:0px 10px;">
                                <tr>
                                    <td>
                                        <input  id="iv_coporiation_edit_mohu" class="form-control" style="border-bottom-right-radius: 0;border-top-right-radius: 0" placeholder="公司名，点击‘匹配’时会自动匹配全名"/>
                                    </td>
                                    <td>
                                        <button type="button"  class="btn btn-primary"   onclick="edit_mohuquery_coporiation()" style="border-bottom-left-radius: 0;border-top-left-radius: 0">查询</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="iv_coporiation_edit" class="form-control"></select>
                                    </td>
                                    <td>公司全名</td>
                                </tr>

                                <%--<tr>--%>
                                    <%--<td>--%>
                                        <%--<input id="tr_coporiation_edit" class="form-control" placeholder="自助择业时，在此填公司" /><button>匹配</button>--%>
                                    <%--</td>--%>
                                    <%--<td>自主公司</td>--%>
                                <%--</tr>--%>
                            </table>


                        </td>
                    </tr>

                    <tr>
                        <td>面试岗位</td>
                        <td><input class="form-control" id="iv_position_edit"></td>
                        <td>面试类型</td>
                        <td>
                            <select id="types_edit" class="form-control">
                                <c:forEach var="employType" items="${requestScope.employTypes}" >
                                    <option value="${employType}">${employType}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>预计薪资</td>
                        <td><input class="form-control" type="number" id="iv_salary_edit"></td>
                        <td>面试结果</td>
                        <td>
                            <select class="form-control" id="result_edit">
                                <option value="未知">未知</option>
                                <option value="成功">成功</option>
                                <option value="失败">失败</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>实际薪资</td>
                        <td><input class="form-control" type="number" id="iv_realSalary_edit"></td>
                        <td>福利</td>
                        <td><input class="form-control" id="iv_fuli_edit"></td>
                    </tr>
                    <tr>
                        <td>入职时间</td>
                        <td><input type="text" class="jeinput form-control" id="iv_entertime_edit" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td>就业依据</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit_edit' class="form-horizontal"  action="/employ/uploadImg" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile" id="imgFile_edit" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_edit"/>
                                <input type="submit" name="upload" value="上传" class="btn btn-primary">
                                <input type="hidden"  name="imgurl" id="imgurl_edit" value="" />
                                <input type="hidden"  name="code" id="peiid_edit" value="" />
                            </form>
                        </td>
                    </tr>

                    </tbody>
                </table>
                <h3 style="color: #003399">注意：面试类型为自主、推荐时，只有面试结果为成功时，才可以上传图片。否则无效! </h3>
                <h3 style="color: #003399">面试类型为自主择业、延迟就业时，可以直接上传图片</h3>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="updateInterview()">保存</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="imgModal_upload" tabindex="-1" role="dialog" aria-labelledby="imgModal_upload">
    <div class="modal-dialog" role="document" style="width: 35%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">上传就业依据</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody>

                    <tr>
                        <td>就业依据</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit2' class="form-horizontal"  action="/employ/uploadImg2" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile2" id="imgFile2" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_upload2"/>
                                <input type="submit" name="upload2" value="上传" class="btn btn-primary">
                                <input type="hidden"  name="code2" id="code2" value="" />
                                <input type="hidden"  name="imgurl2" id="imgurl2" value="" />

                            </form>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="saveEmployProof()">保存</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="exportEmployInfoModal" tabindex="-1" role="dialog" aria-labelledby="exportEmployInfoModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">就业跟踪信息下载对话框</h4>
            </div>
            <div class="modal-body"  >
                <label style="margin-top: 10px;">1、请选择时间范围</label>
                <div style="margin-left: 20px;margin-top: 10px;">
                    <div class="form-inline" >
                        <label>开始时间:</label><input type="date" id="startTime_d" class = "form-control"  >
                        <label style="margin-left: 20px;">结束时间:</label><input type="date" id="endTime_d" class = "form-control"  >
                        <input  style="margin-left: 20px;" onclick="onRefreshDate()" type="button" value="刷新" />
                    </div>
                </div  >
                <label style="margin-top: 20px;">2、请从中选择您希望的下载范围</label>
                <div style="margin-left: 20px;margin-top:20px;">
                    <div class="form-inline">
                        <input type="radio" checked="checked" name="region" value="center" onclick="regionSelect('center')"/><label style="width: 50px;">校区</label>
                        <select  class="form-control" id="centers_d" style="min-width: 150px;">
                            <option value="-1">全部</option>
                            <c:forEach var="center" items="${requestScope.centers_recent}" >
                                <option value="${center.cid}">${center.cname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="direction" onclick="regionSelect('direction')" /><label style="width: 50px;">方向:</label>
                        <select  class="form-control" id="directions_d" style="min-width: 150px;">
                            <%--<option value="-1">全部</option>--%>
                            <c:forEach var="direction" items="${requestScope.directions_recent}" >
                                <option value="${direction.did}">${direction.dname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="class" onclick="regionSelect('class')"/><label style="width: 50px;">班级:</label>
                        <select class="form-control" id="classcodes_d" style="min-width: 150px;" >
                            <c:forEach var="classcode" items="${requestScope.classcodes_recent}" >
                                <option value="${classcode}" >${classcode}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <label style="margin-top: 20px;">3、请选择面试类型和面试结果</label>
                <div class="form-inline" style="margin-top: 20px;margin-left: 20px;">

                    <label>面试类型:</label>
                    <select  class="form-control" id="types_d" style="min-width: 150px" >
                        <option value="全部">全部</option>
                        <c:forEach var="employType" items="${requestScope.employTypes}" >
                            <option value="${employType}">${employType}</option>
                        </c:forEach>
                    </select>


                    <label style="margin-left: 20px;">结果:</label>

                    <select class="form-control" id="results_d" style="min-width: 150px">
                        <option value="全部">全部</option>
                        <option value="失败">失败</option>
                        <option value="成功">成功</option>
                    </select>
                </div>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="exportEmployInfo()">导出</button>
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
                <h1 class="page-header">动态就业数据</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div >

                    <div class="panel-body">

                        <div class="row">
                            <div class="col-lg-12">
                                <div class="panel panel-default">
                                    <div class="col-lg-9" style="background: #dddddd">
                                        <table  style="border-collapse:separate; border-spacing:20px 20px;"  rules=none >
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
                                                <td style="text-align:right;">班级:</td>
                                                <td>
                                                    <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                                        <c:forEach var="classcode" items="${requestScope.classcodes}">
                                                            <option value="${classcode}">${classcode}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                            </tr>


                                            <tr>


                                                <td style="text-align:right;">面试类型:</td>
                                                <td>
                                                    <select  class="form-control" id="types_search" style="min-width: 150px" >
                                                        <option value="全部">全部</option>
                                                        <c:forEach var="employType" items="${requestScope.employTypes}" >
                                                            <option value="${employType}">${employType}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                                <td style="text-align:right;">结果:</td>
                                                <td>
                                                    <select class="form-control" id="results_search" style="min-width: 150px">
                                                        <option value="全部">全部</option>
                                                        <option value="失败">失败</option>
                                                        <option value="成功">成功</option>
                                                    </select>
                                                </td>

                                                <td></td>
                                                <td><button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">条件查询</button> </td>
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
                                <div class="table-responsive" >
                                    <label>班级面试概要</label>
                                    <div style="height: 500px;border: 1px solid #ddd">
                                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                                            <thead >

                                            <th>学号</th>
                                            <th>姓名</th>
                                            <th>班级</th>
                                            <th>方向</th>
                                            <th>就业结果</th>

                                            <th>录取时间</th>
                                            <th>录取公司</th>
                                            <th>录取岗位</th>
                                            <th>录取薪资</th>

                                            <th>就业凭证</th>

                                            <th>就业详情</th>
                                            <th>新增推荐</th>

                                            <th>毕业时间</th>
                                            <th>学历</th>
                                            <th>毕业学校</th>
                                            <th>专业</th>

                                            </thead>
                                            <tbody id="tbody_interviews">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- /.table-responsive -->
                            </div>
                            <!-- /.panel-body -->
                        </div>

                        <div class="row">
                            <div class="panel-body">
                                <div class="table-responsive" >
                                    <label>学员面试详情</label>
                                    <div style="height: 300px;border: 1px solid #ddd;">

                                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                                            <thead>

                                            <th>id</th>
                                            <%--<th>编辑</th>--%>
                                            <th>学号</th>
                                            <th>姓名</th>

                                            <th>班级</th>
                                            <th>面试时间</th>
                                            <th>入职时间</th>
                                            <th>面试公司</th>
                                            <th>面试岗位</th>
                                            <th>面试类型</th>
                                            <th>预计薪资</th>
                                            <th>面试结果</th>
                                            <th>实际薪资</th>
                                            <th>福利</th>
                                            <th>就业凭证</th>
                                            <th>操作1</th>
                                            <th>操作2</th>

                                            </thead>
                                            <tbody id="tbody_interviews_detail">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- /.table-responsive -->
                            </div>
                            <!-- /.panel-body -->
                        </div>

                        <div class="row" style="margin-top: 10px;">
                            <div class="panel-body">
                                <div class="panel panel-default" style="float:left;left: 30px;">
                                    <div class="panel-body">
                                        <form id='employInfosSumbit' class="form-inline" role="form"   action="/employ/importEmployInfos" method="post" enctype="multipart/form-data"  style="display:inline;">
                                            <input type="file" name="excelFile" id="excelFile" class="file-loading" multiple accept=".xls,.xlsx" style="display: inline">
                                            <input type="submit" name="upload" value="导入动态就业数据" class="btn btn-primary">
                                            <%--<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>--%>
                                        </form>
                                    </div>
                                </div>
                                <div class="panel panel-default" style="float:right;">
                                    <div class="panel-body">
                                        <a href="javascript:void(0)" onclick="downloadEmployInfoDlg()" style="float:right;right: 30px;">下载就业跟踪信息<img src="/img/down.png" style="width: 30px;"/></a>
                                    </div>
                                </div>
                                <div style="clear: both"></div>
                            </div>
                        </div>

                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
            </div>
        <!-- /#page-wrapper -->
        </div>

    <!-- /#wrapper -->
    </div>
</div>
    <!-- /#page-wrapper -->
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
    <script type="text/javascript">
        jeDate("#iv_time_new",{
            festival:true,
            minDate:"1900-01-01",              //最小日期
            maxDate:"2099-12-31",              //最大日期
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_entertime_new",{
            festival:true,
            minDate:"1900-01-01",              //最小日期
            maxDate:"2099-12-31",              //最大日期
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_time_edit",{
            festival:true,
            minDate:"1900-01-01",              //最小日期
            maxDate:"2099-12-31",              //最大日期
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_entertime_edit",{
            festival:true,
            minDate:"1900-01-01",              //最小日期
            maxDate:"2099-12-31",              //最大日期
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });


    </script>

</body>

</html>
