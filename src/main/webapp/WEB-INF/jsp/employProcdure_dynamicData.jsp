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
            //???????????????????????????9????????????0
            var day = ("0" + now.getDate()).slice(-2);
            //???????????????????????????9????????????0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //????????????????????????
            today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime = "2000-01-01"

            $('#startTime_d').val((now.getFullYear() - 1) + "-" + (month) + "-" + (day));
            $('#endTime_d').val(today);
            $("#directions_d").attr("disabled","disabled");
            $("#classcodes_d").attr("disabled","disabled");




            $('#time_iv').datetimepicker({
                format: 'yyyy-mm-dd hh:ii'      /*????????????????????????????????????????????????mm-dd-yyyy*/
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
                    alert("?????????????????????????????????");
                }

            })


            $('#employInfosSumbit').submit(function (event) {
                //????????????????????????
                var fileName = $(this).find("input[name=excelFile]").val();
                if (fileName === '') {
                    alert('???????????????');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'xls' && fileType !== 'xlsx') {
                    alert('????????????????????????excel?????????');
                    return;
                }


                event.preventDefault();
                var form = $(this);
                if (form.hasClass('upload')) {
                    //????????????
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: form.serialize(),
                        dataType: "JSON"
                    }).success(function () {
                        //????????????
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        //????????????
                    });
                }
                else {
                    // mulitipart form,??????????????????
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
                            alert("???????????????XHR=" + XHR + "\ntextStatus=" + textStatus
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

            //????????????
            $('#uploadImgSumbit').submit(function (event) {
                //????????????????????????
                var fileName = $(this).find("input[name=imgFile]").val();
                if (fileName === '') {
                    alert('???????????????');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'jpg' && fileType !== 'jpeg' && fileType !== 'bmp'&& fileType !== 'png') {
                    alert('???????????????????????????????????????');
                    return;
                }
                event.preventDefault();
                var form = $(this);
                if (form.hasClass('upload')) {
                    //????????????
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: form.serialize(),
                        dataType: "JSON"
                    }).success(function () {
                        //????????????
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        //????????????
                    });
                }
                else {
                    // mulitipart form,??????????????????
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
                            alert("???????????????XHR=" + XHR + "\ntextStatus=" + textStatus
                                    + "\nerrorThrown=" + errorThrown);

                        },
                        success : function(data) {
                            if(data.result.length > 0){
                                $("#img_new").attr("src", data.address)
                                $("#imgurl").val(data.result)

                                return false;

                            }else{
                                alert("??????????????????")
                            }
                        }
                    });
                }

                return false;
            });


            //????????????
            $('#uploadImgSumbit2').submit(function (event) {
                //????????????????????????
                var fileName = $(this).find("input[name=imgFile2]").val();
                if (fileName === '') {
                    alert('???????????????');
                    return;
                }
                var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
                if (fileType !== 'jpg' && fileType !== 'jpeg' && fileType !== 'bmp'&& fileType !== 'png') {
                    alert('???????????????????????????????????????');
                    return;
                }
                event.preventDefault();
                var form = $(this);
                if (form.hasClass('upload')) {
                    //????????????
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: form.serialize(),
                        dataType: "JSON"
                    }).success(function () {
                        //????????????
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        //????????????
                    });
                }
                else {
                    // mulitipart form,??????????????????
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
                            alert("???????????????XHR=" + XHR + "\ntextStatus=" + textStatus
                                    + "\nerrorThrown=" + errorThrown);

                        },
                        success : function(data) {
                            if(data.result.length > 0){
                                $("#img_upload2").attr("src", data.address)
                                $("#imgurl2").val(data.result)

                                return false;

                            }else{
                                alert("??????????????????")
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


                    if(processEmployInterviewRecords[i].result != null && processEmployInterviewRecords[i].result == "??????"){
                        str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"

                        str = str + "<td>" + processEmployInterviewRecords[i].entertimee +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].corporiation +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].position +  "</td>"
                        str = str + "<td>" + processEmployInterviewRecords[i].realSalary +  "</td>"

                        if(processEmployInterviewRecords[i].employProof != null && processEmployInterviewRecords[i].employProof.length > 0){
                            str = str + "<td><a href='javascript:void(0)' onclick='employProof( \"" + processEmployInterviewRecords[i].code + "\")'>????????????</a></td>"
                        }else{
                            str = str + "<td>???</td>"
                        }

                    }else{
                        if(processEmployInterviewRecords[i].type == null){
                            processEmployInterviewRecords[i].type = "??????"
                        }
                        str = str + "<td>" + processEmployInterviewRecords[i].type + "</td>"

                        str = str + "<td>??????</td>"
                        str = str + "<td>??????</td>"
                        str = str + "<td>??????</td>"
                        str = str + "<td>??????</td>"

                        str = str + "<td>???</td>"
                    }


                    var code = processEmployInterviewRecords[i].code
                    var name = processEmployInterviewRecords[i].name
                    str = str + "<td><a href='javascript:void(0)' onclick='interviewDetail(\"" +  code  + "\")'>????????????</a></td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='addInterviewDlg(\"" +  code  + "\",\"" + name + "\")'>????????????</a></td>"

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

                    if(processEmployInterviewRecords[i].result=="??????"){
                        if(processEmployInterviewRecords[i].employProof != null && processEmployInterviewRecords[i].employProof.length > 0){
                            str = str + "<td><a href='javascript:void(0)' onclick='employProofByPeiid(\" " + processEmployInterviewRecords[i].peiid + "\")'>????????????</a></td>"
                        }else{
                            str = str + "<td><a href='javascript:void(0)' onclick='uploadEmployProof(\" " + processEmployInterviewRecords[i].code + "\")'>??????????????????</a></td>"
                        }

                    }else{
                        str = str + "<td>???</td>"
                    }

                    str = str + "<td><a href='javascript:void(0)' onclick='deleteInterviewRecord( " + processEmployInterviewRecords[i].peiid + ",\"" + processEmployInterviewRecords[i].code + "\")'>??????</a></td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='editInterviewRecord( " + processEmployInterviewRecords[i].peiid + ",\"" + processEmployInterviewRecords[i].code + "\")'>??????</a></td>"


                    str = str + "</tr>"

                    $('#tbody_interviews_detail').append(str)
                }

            } else {
                $('#tbody_interviews_detail').empty()
            }
        }

        function addInterviewDlg(code,name) {
            //???????????????????????????????????????
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
                            //????????????
                            var trs = $('#tbody_interviews_detail').find("tr")
                            var length = trs.length
                            for(var i = 0; i < length; i++){
                                var val = trs.eq(i).find("td").eq(10).html()
                                if(val == "??????"){
                                    trs.eq(i).find("td").eq(13).html("<td><a href='javascript:void(0)' onclick='employProof(\" " + code + "\")'>????????????</a></td>")
                                    break
                                }
                            }
                            $("#imgModal_upload").modal('hide')
                            alert("????????????????????????!")
                        }else{
                            alert("????????????????????????!")
                        }
                    }
            );
        }


        function querydown() {
            var classcode = $('#classcodes_search').val()
            var type = $('#types_search').val()
            var result = $('#results_search').val()
            if(classcode == null){
                alert("??????????????????????????????")
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
                alert("??????????????????????????????")
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
                alert("??????????????????????????????!")
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
                alert("??????????????????????????????!")
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
            if((type == "??????" && result != "??????") || (type == "??????"&& result != "??????" )  || (type == "????????????") || (type == "????????????")){

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
                            alert("??????????????????")
                        }
                    }
            );

        }


        //????????????
        function employProof(code) {
            $.post(
                    "/employ/getImgurlByCode",
                    {"code":code},
                    function (imgurl) {
                        if(imgurl != null){
                            $("#showImg").attr("src",imgurl);
                            $('#showImageModal').modal();
                        }else{
                            alert("??????????????????")
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
                            alert("??????????????????")
                        }

                    }
            );
        }

        function deleteInterviewRecord(peiid,code) {
            if(peiid == null){
                alert("????????????id??????!????????????")
                return
            }

            if(confirm("??????????????????????????????????")){
                //?????????????????????
                $.post(
                        "/employ/deleteInterViewRecordByPeiid",
                        {"peiid":peiid},
                        function (result) {
                            if(result == null || result == "fail"){
                                alert("????????????????????????")
                            }else{
                                interviewDetail(code)
                                updateInterviewRecordInWhole(code)
                                alert("????????????????????????")
                            }

                        }
                );

            }


        }


        function edit_mohuquery_coporiation() {
            var name = $('#iv_coporiation_edit_mohu').val()
            if(name == null && name.length == 0){
                alert("??????????????????????????????!")
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
                alert("????????????id??????!????????????")
                return
            }

            $.post(
                    "/employ/getInterviewRecordByPeiid",
                    {"peiid":peiid},
                    function (interviewRecord) {
                        if(interviewRecord == null || interviewRecord == "fail"){
                            alert("????????????????????????")
                        }else{
                            $("#code_edit").text(interviewRecord.code)
                            $("#name_edit").text(interviewRecord.name)
                            $("#iv_time_edit").val(interviewRecord.datetimee)
                            if(interviewRecord.type=='??????'){
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
            if((type == "??????" && result != "??????") || (type == "??????"&& result != "??????" )  || (type == "????????????") || (type == "????????????")){

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
                            alert("??????????????????")
                        }
                    }
            );
        }






        function updateInterviewRecordInWhole(code) {
            //?????????????????????
//            $.post(
//                    "/employ/geInterViewRecordBtyPeiid",
//                    {"peiid":peiid},
//                    function (result) {
//                        if(result == null || result == "fail"){
//                            alert("????????????????????????")
//                        }else{
//                            interviewDetail(code)
//                            updateInterviewRecordInWhole(code)
//                            alert("????????????????????????")
//                        }
//
//                    }
//            );

            //???????????????
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
                            alert("????????????!")
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
                <h4 class="modal-title">????????????</h4>
            </div>
            <div class="modal-body" style="text-align: center">
                <img id="showImg" src="" width="400px" height="400px"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="employModal_new" tabindex="-1" role="dialog" aria-labelledby="employModal_new">
    <div class="modal-dialog" role="document" style="width: 55%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">??????????????????</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody id="interview_new">
                    <tr>
                        <td>????????????</td>
                        <td id="code_new"></td>
                        <td>??????</td>
                        <td id="name_new"></td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <%--<td><input class="form-control" type="datetime" id="iv_time_new"></td>--%>
                        <td><input type="text" class="jeinput form-control" id="iv_time_new" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td>????????????</td>
                        <td>
                            <table border=1 width="100%" frame=void rules=none style="border-collapse:separate; border-spacing:0px 10px;">
                                <tr>
                                    <td>
                                        <input  id="iv_coporiation_new_mohu" class="form-control" style="border-bottom-right-radius: 0;border-top-right-radius: 0" placeholder="??????????????????????????????????????????????????????"/>
                                    </td>
                                    <td>
                                        <button type="button"  class="btn btn-primary"   onclick="mohuquery_coporiation()" style="border-bottom-left-radius: 0;border-top-left-radius: 0">??????</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="iv_coporiation_new" class="form-control"></select>
                                    </td>
                                    <td>????????????</td>
                                </tr>

                                <%--<tr>--%>
                                    <%--<td>--%>
                                        <%--<input id="tr_coporiation_new" class="form-control" placeholder="?????????????????????????????????" />--%>
                                    <%--</td>--%>
                                    <%--<td>????????????</td>--%>
                                <%--</tr>--%>
                            </table>


                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" id="iv_position_new"></td>
                        <td>????????????</td>
                        <td>
                            <select id="types_new" class="form-control">
                                <c:forEach var="employType" items="${requestScope.employTypes}" >
                                    <option value="${employType}">${employType}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" type="number" id="iv_salary_new"></td>
                        <td>????????????</td>
                        <td>
                            <select class="form-control" id="result_new">
                                <option value="??????">??????</option>
                                <option value="??????">??????</option>
                                <option value="??????">??????</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" type="number" id="iv_realSalary_new"></td>
                        <td>??????</td>
                        <td><input class="form-control" id="iv_fuli_new"></td>
                    </tr>
                    <tr>
                        <td>????????????</td>
                        <td><input type="text" class="jeinput form-control" id="iv_entertime_new" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td>????????????</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit' class="form-horizontal"  action="/employ/uploadImg" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile" id="imgFile" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_new"/>
                                <input type="submit" name="upload" value="??????" class="btn btn-primary">
                                <input type="hidden"  name="code" id="code" value="" />
                                <input type="hidden"  name="imgurl" id="imgurl" value="" />
                            </form>
                        </td>
                    </tr>

                    </tbody>
                </table>
                <h3 style="color: #003399">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????! </h3>
                <h3 style="color: #003399">????????????????????????????????????????????????????????????????????????</h3>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button"  class="btn btn-primary" onclick="saveNewInterview()">??????</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="employModal_edit" tabindex="-1" role="dialog" aria-labelledby="employModal_edit">
    <div class="modal-dialog" role="document" style="width: 55%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">??????????????????</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody id="interview_edit">
                    <tr>
                        <td>????????????</td>
                        <td id="code_edit"></td>
                        <td>??????</td>
                        <td id="name_edit"></td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <%--<td><input class="form-control" type="datetime" id="iv_time_new"></td>--%>
                        <td><input type="text" class="jeinput form-control" id="iv_time_edit" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td>????????????</td>
                        <td>
                            <table border=1 width="100%" frame=void rules=none style="border-collapse:separate; border-spacing:0px 10px;">
                                <tr>
                                    <td>
                                        <input  id="iv_coporiation_edit_mohu" class="form-control" style="border-bottom-right-radius: 0;border-top-right-radius: 0" placeholder="??????????????????????????????????????????????????????"/>
                                    </td>
                                    <td>
                                        <button type="button"  class="btn btn-primary"   onclick="edit_mohuquery_coporiation()" style="border-bottom-left-radius: 0;border-top-left-radius: 0">??????</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="iv_coporiation_edit" class="form-control"></select>
                                    </td>
                                    <td>????????????</td>
                                </tr>

                                <%--<tr>--%>
                                    <%--<td>--%>
                                        <%--<input id="tr_coporiation_edit" class="form-control" placeholder="?????????????????????????????????" /><button>??????</button>--%>
                                    <%--</td>--%>
                                    <%--<td>????????????</td>--%>
                                <%--</tr>--%>
                            </table>


                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" id="iv_position_edit"></td>
                        <td>????????????</td>
                        <td>
                            <select id="types_edit" class="form-control">
                                <c:forEach var="employType" items="${requestScope.employTypes}" >
                                    <option value="${employType}">${employType}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" type="number" id="iv_salary_edit"></td>
                        <td>????????????</td>
                        <td>
                            <select class="form-control" id="result_edit">
                                <option value="??????">??????</option>
                                <option value="??????">??????</option>
                                <option value="??????">??????</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>????????????</td>
                        <td><input class="form-control" type="number" id="iv_realSalary_edit"></td>
                        <td>??????</td>
                        <td><input class="form-control" id="iv_fuli_edit"></td>
                    </tr>
                    <tr>
                        <td>????????????</td>
                        <td><input type="text" class="jeinput form-control" id="iv_entertime_edit" placeholder="YYYY-MM-DD hh:mm:ss"></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td>????????????</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit_edit' class="form-horizontal"  action="/employ/uploadImg" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile" id="imgFile_edit" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_edit"/>
                                <input type="submit" name="upload" value="??????" class="btn btn-primary">
                                <input type="hidden"  name="imgurl" id="imgurl_edit" value="" />
                                <input type="hidden"  name="code" id="peiid_edit" value="" />
                            </form>
                        </td>
                    </tr>

                    </tbody>
                </table>
                <h3 style="color: #003399">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????! </h3>
                <h3 style="color: #003399">????????????????????????????????????????????????????????????????????????</h3>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button"  class="btn btn-primary" onclick="updateInterview()">??????</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="imgModal_upload" tabindex="-1" role="dialog" aria-labelledby="imgModal_upload">
    <div class="modal-dialog" role="document" style="width: 35%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">??????????????????</h4>
            </div>

            <div class="modal-body">

                <table class="table table-striped table-bordered table-hover">
                    <tbody>

                    <tr>
                        <td>????????????</td>
                        <td colspan="3">
                            <form id='uploadImgSumbit2' class="form-horizontal"  action="/employ/uploadImg2" method="post" enctype="multipart/form-data" >
                                <input type="file" name="imgFile2" id="imgFile2" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                <img src='${requestScope.imgDefault}' style="width: 100px;margin-right: 50px" id="img_upload2"/>
                                <input type="submit" name="upload2" value="??????" class="btn btn-primary">
                                <input type="hidden"  name="code2" id="code2" value="" />
                                <input type="hidden"  name="imgurl2" id="imgurl2" value="" />

                            </form>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button"  class="btn btn-primary" onclick="saveEmployProof()">??????</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="exportEmployInfoModal" tabindex="-1" role="dialog" aria-labelledby="exportEmployInfoModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">?????????????????????????????????</h4>
            </div>
            <div class="modal-body"  >
                <label style="margin-top: 10px;">1????????????????????????</label>
                <div style="margin-left: 20px;margin-top: 10px;">
                    <div class="form-inline" >
                        <label>????????????:</label><input type="date" id="startTime_d" class = "form-control"  >
                        <label style="margin-left: 20px;">????????????:</label><input type="date" id="endTime_d" class = "form-control"  >
                        <input  style="margin-left: 20px;" onclick="onRefreshDate()" type="button" value="??????" />
                    </div>
                </div  >
                <label style="margin-top: 20px;">2??????????????????????????????????????????</label>
                <div style="margin-left: 20px;margin-top:20px;">
                    <div class="form-inline">
                        <input type="radio" checked="checked" name="region" value="center" onclick="regionSelect('center')"/><label style="width: 50px;">??????</label>
                        <select  class="form-control" id="centers_d" style="min-width: 150px;">
                            <option value="-1">??????</option>
                            <c:forEach var="center" items="${requestScope.centers_recent}" >
                                <option value="${center.cid}">${center.cname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="direction" onclick="regionSelect('direction')" /><label style="width: 50px;">??????:</label>
                        <select  class="form-control" id="directions_d" style="min-width: 150px;">
                            <%--<option value="-1">??????</option>--%>
                            <c:forEach var="direction" items="${requestScope.directions_recent}" >
                                <option value="${direction.did}">${direction.dname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="class" onclick="regionSelect('class')"/><label style="width: 50px;">??????:</label>
                        <select class="form-control" id="classcodes_d" style="min-width: 150px;" >
                            <c:forEach var="classcode" items="${requestScope.classcodes_recent}" >
                                <option value="${classcode}" >${classcode}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <label style="margin-top: 20px;">3???????????????????????????????????????</label>
                <div class="form-inline" style="margin-top: 20px;margin-left: 20px;">

                    <label>????????????:</label>
                    <select  class="form-control" id="types_d" style="min-width: 150px" >
                        <option value="??????">??????</option>
                        <c:forEach var="employType" items="${requestScope.employTypes}" >
                            <option value="${employType}">${employType}</option>
                        </c:forEach>
                    </select>


                    <label style="margin-left: 20px;">??????:</label>

                    <select class="form-control" id="results_d" style="min-width: 150px">
                        <option value="??????">??????</option>
                        <option value="??????">??????</option>
                        <option value="??????">??????</option>
                    </select>
                </div>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button"  class="btn btn-primary" onclick="exportEmployInfo()">??????</button>
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
                <h1 class="page-header">??????????????????</h1>
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
                                                <td style="text-align:right;">??????:</td>
                                                <td>
                                                    <select  class="form-control" id="centers_search" style="min-width: 150px;">
                                                        <option value="-1">??????</option>
                                                        <c:forEach var="center" items="${requestScope.centers}" >
                                                            <option value="${center.cid}">${center.cname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td style="text-align:right;">?????????:</td>
                                                <td>
                                                    <select class="form-control" id="classteachers_search" style="min-width: 150px;">
                                                        <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                                            <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td style="text-align:right;">??????:</td>
                                                <td>
                                                    <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                                        <c:forEach var="classcode" items="${requestScope.classcodes}">
                                                            <option value="${classcode}">${classcode}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                            </tr>


                                            <tr>


                                                <td style="text-align:right;">????????????:</td>
                                                <td>
                                                    <select  class="form-control" id="types_search" style="min-width: 150px" >
                                                        <option value="??????">??????</option>
                                                        <c:forEach var="employType" items="${requestScope.employTypes}" >
                                                            <option value="${employType}">${employType}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                                <td style="text-align:right;">??????:</td>
                                                <td>
                                                    <select class="form-control" id="results_search" style="min-width: 150px">
                                                        <option value="??????">??????</option>
                                                        <option value="??????">??????</option>
                                                        <option value="??????">??????</option>
                                                    </select>
                                                </td>

                                                <td></td>
                                                <td><button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px">????????????</button> </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-lg-3" style="background: #eeeeee">

                                        <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                            <tr>

                                                <td>
                                                    &emsp; &emsp; <input  id="name_search" class = "form-control" placeholder = "????????????/??????" style="width: 150px;display: inline;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&emsp; &emsp; <button type="button" class="btn btn-primary"  onclick="mohuquery()" style="width: 150px;display: inline;">????????????</button></td>
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
                                    <label>??????????????????</label>
                                    <div style="height: 500px;border: 1px solid #ddd">
                                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                                            <thead >

                                            <th>??????</th>
                                            <th>??????</th>
                                            <th>??????</th>
                                            <th>??????</th>
                                            <th>????????????</th>

                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>

                                            <th>????????????</th>

                                            <th>????????????</th>
                                            <th>????????????</th>

                                            <th>????????????</th>
                                            <th>??????</th>
                                            <th>????????????</th>
                                            <th>??????</th>

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
                                    <label>??????????????????</label>
                                    <div style="height: 300px;border: 1px solid #ddd;">

                                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                                            <thead>

                                            <th>id</th>
                                            <%--<th>??????</th>--%>
                                            <th>??????</th>
                                            <th>??????</th>

                                            <th>??????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>????????????</th>
                                            <th>??????</th>
                                            <th>????????????</th>
                                            <th>??????1</th>
                                            <th>??????2</th>

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
                                            <input type="submit" name="upload" value="????????????????????????" class="btn btn-primary">
                                            <%--<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>--%>
                                        </form>
                                    </div>
                                </div>
                                <div class="panel panel-default" style="float:right;">
                                    <div class="panel-body">
                                        <a href="javascript:void(0)" onclick="downloadEmployInfoDlg()" style="float:right;right: 30px;">????????????????????????<img src="/img/down.png" style="width: 30px;"/></a>
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
            minDate:"1900-01-01",              //????????????
            maxDate:"2099-12-31",              //????????????
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_entertime_new",{
            festival:true,
            minDate:"1900-01-01",              //????????????
            maxDate:"2099-12-31",              //????????????
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_time_edit",{
            festival:true,
            minDate:"1900-01-01",              //????????????
            maxDate:"2099-12-31",              //????????????
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });

        jeDate("#iv_entertime_edit",{
            festival:true,
            minDate:"1900-01-01",              //????????????
            maxDate:"2099-12-31",              //????????????
            method:{
                choose:function (params) {

                }
            },
            format: "YYYY-MM-DD hh:mm:ss"
        });


    </script>

</body>

</html>
