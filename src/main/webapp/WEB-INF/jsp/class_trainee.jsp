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
    <%--<script src="/jquery/jquery-1.10.2.min.js"></script>--%>

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

    <style type="text/css">
        .table {table-layout:fixed;}
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }
    </style>

    <script type="text/javascript">
        //# sourceURL=dynamicScript.js

        var rowIndex_cur = -1
        var operator_type = "none"

        $(function(){

            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val();
                $.post(
                    "/class/classteachersInCenter",
                    {"centerId":centerId},
                    function (data) {
                        $("#classteachers_search").empty()
                        var length = data.length
                        var str = "<option value='-1'>??????</option>"
                        for(var i = 0; i < length; i++){
                            var classTeacher = data[i]
                            str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                        }
                        $("#classteachers_search").append(str)

                    }
                 );


            })

            $("#classteachers_search").change(function(){
                var ctid=$("#classteachers_search").val();
                var state=$("#classstates_search").val();
                $.post(
                        "/class/classcodesByCtidState",
                        {"ctid":ctid,"state":state},
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



            })



            $("#classstates_search").change(function(){
                var ctid=$("#classteachers_search").val();
                var state=$("#classstates_search").val();
                $.post(
                        "/class/classcodesByCtidState",
                        {"ctid":ctid,"state":state},
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



            })





            $('#formSumbit').submit(function (event) {
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
                                $("#tbody_trainee").empty();
                                var direction = data.direction
                                var center = data.center
                                var length = data.datas.length
                                for(var i = 1; i < length; i++){
                                    var dataArr = data.datas[i]
                                    var str = "<tr>"
                                    str = str + "<td>" + i + "</td>"
                                    var row = i - 1
                                    str = str + "<td><a href=javascript:void(0)' onclick='edit(" + row +")'>??????</a></td>"
                                    for(var j = 0; j < 6; j++){
                                        str = str + "<td>" + dataArr[j] + "</td>"
                                    }
                                    str = str + "<td>" + direction.dname + "</td>"
                                    str = str + "<td>" + center.cname + "</td>"
                                    for(var j = 6; j < 22 - 1 ; j++){
                                        if(j == 22 - 3){
                                            continue
                                        }
                                        str = str + "<td>" + dataArr[j] + "</td>"
                                    }


                                    for(var k = 0; k < 5; k++){
                                        str = str + "<td>?????????</td>"
                                    }
                                    str = str + "</tr>"
                                    $("#tbody_trainee").append(str)

                                }
                            }else{
                                alert( data.result + "-->" + data.reason);
                            }
                        }
                    });
                }

                return false;
            });

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
                            if(data.result == "success"){
                                $('#info').text("??????????????????")
                                var rows_edit = $("#tbody_edit").find("tr")
                                var tdArrs2 = rows_edit.eq(2).find("td");
                                switch(data.type){
                                    case "0":
                                        tdArrs2.eq(5).html("<a href='javascript:void(0)' onclick='showPhoto(0,-1)'>????????????</a>")
                                        break;
                                    case "1":
                                        tdArrs2.eq(7).html("<a href='javascript:void(0)' onclick='showPhoto(1,-1)'>????????????</a>")
                                        break;
                                    case "2":
                                        tdArrs2.eq(9).html("<a href='javascript:void(0)' onclick='showPhoto(2,-1)'>????????????</a>")
                                        break;
                                    case "3":
                                        tdArrs2.eq(11).html("<a href='javascript:void(0)' onclick='showPhoto(3,-1)'>????????????</a>")
                                        break;
                                    case "4":
                                        tdArrs2.eq(13).html("<a href='javascript:void(0)' onclick='showPhoto(4,-1)'>????????????</a>")
                                        break;
                                }

                            }else{
                                $('#info').text("??????????????????")
                            }
                        }
                    });
                }

                return false;
            });


        });


        function edit(rowIndex){
            operator_type = "edit"
            rowIndex_cur = rowIndex
            var rows_edit = $("#tbody_edit").find("tr")
            var tdArrs0 = rows_edit.eq(0).find("td");
            var tdArrs1 = rows_edit.eq(1).find("td");
            var tdArrs2 = rows_edit.eq(2).find("td");

            var rows_trainee = $("#tbody_trainee").find("tr")
            var tdArrs_trainee = rows_trainee.eq(rowIndex).find("td");

            $("#labclasscode").html(tdArrs_trainee.eq(6).text())
            $("#direction").html(tdArrs_trainee.eq(8).text())
            $("#center").html(tdArrs_trainee.eq(9).text())
            $("#classteacher").html(tdArrs_trainee.eq(7).text())


            tdArrs0.eq(1).html(tdArrs_trainee.eq(2).text())
            tdArrs0.eq(3).find("input").val(tdArrs_trainee.eq(3).text())
            tdArrs0.eq(5).find("select").val(tdArrs_trainee.eq(4).text())
            tdArrs0.eq(7).find("input").val(tdArrs_trainee.eq(5).text())

            tdArrs0.eq(9).find("select").val(tdArrs_trainee.eq(11).text())
            tdArrs0.eq(11).find("input").val(tdArrs_trainee.eq(12).text())
            tdArrs0.eq(13).find("input").val(tdArrs_trainee.eq(13).text())
            tdArrs0.eq(15).find("input").val(tdArrs_trainee.eq(14).text())


            tdArrs1.eq(1).find("select").val(tdArrs_trainee.eq(10).text())
            tdArrs1.eq(3).find("input").val(tdArrs_trainee.eq(15).text())
            tdArrs1.eq(5).find("input").val(tdArrs_trainee.eq(16).text())
            tdArrs1.eq(7).find("input").val(tdArrs_trainee.eq(17).text())

            tdArrs1.eq(9).find("input").val(tdArrs_trainee.eq(18).text())
            tdArrs1.eq(11).find("select").val(tdArrs_trainee.eq(19).text())
            tdArrs1.eq(13).find("select").val(tdArrs_trainee.eq(20).text())
            tdArrs1.eq(15).find("input").val(tdArrs_trainee.eq(21).text())

            tdArrs2.eq(1).find("input").val(tdArrs_trainee.eq(22).text())
            tdArrs2.eq(3).find("input").val(tdArrs_trainee.eq(23).text())

            if(tdArrs_trainee.eq(24).text() == "?????????"){
                var str = "<td><a href='javascript:void(0)' onclick='uploadPhotoDlg(0)'>?????????</a></td>"
                tdArrs2.eq(5).html(str)
            }else{
                var str = "<td><a href='javascript:void(0)' onclick='showPhoto(0," +  rowIndex_cur + ")'>????????????</a></td>"
                tdArrs2.eq(5).html(str)
            }
            if(tdArrs_trainee.eq(25).text() == "?????????"){
                var str = "<td><a href='javascript:void(0)' onclick='uploadPhotoDlg(1)'>?????????</a></td>"
                tdArrs2.eq(7).html(str)
            }else{
                var str = "<td><a href='javascript:void(0)' onclick='showPhoto(1," +  rowIndex_cur + ")'>????????????</a></td>"
                tdArrs2.eq(7).html(str)
            }
            if(tdArrs_trainee.eq(26).text() == "?????????"){
                var str = "<td><a href='javascript:void(0)' onclick='uploadPhotoDlg(2)'>?????????</a></td>"
                tdArrs2.eq(9).html(str)
            }else{
                var str = "<td><a href='javascript:void(0)' onclick='showPhoto(2," +  rowIndex_cur + ")'>????????????</a></td>"
                tdArrs2.eq(9).html(str)
            }
            if(tdArrs_trainee.eq(27).text() == "?????????"){
                var str = "<td><a href='javascript:void(0)' onclick='uploadPhotoDlg(3)'>?????????</a></td>"
                tdArrs2.eq(11).html(str)
            }else{
                var str = "<td><a href='javascript:void(0)' onclick='showPhoto(3," +  rowIndex_cur + ")'>????????????</a></td>"
                tdArrs2.eq(11).html(str)
            }
            if(tdArrs_trainee.eq(28).text() == "?????????"){
                var str = "<td><a href='javascript:void(0)' onclick='uploadPhotoDlg(4)'>?????????</a></td>"
                tdArrs2.eq(13).html(str)
            }else{
                var str = "<td><a href='javascript:void(0)' onclick='showPhoto(4," +  rowIndex_cur + ")'>????????????</a></td>"
                tdArrs2.eq(13).html(str)
            }

        }

        function onUpdateTrainee(){
            if(operator_type != "edit"){
                alert("?????????????????????????????????????????????????????????????????????")
                return
            }
            var rows_trainee = $("#tbody_trainee").find("tr")
            var tdArrs_trainee = rows_trainee.eq(rowIndex_cur).find("td");

            var rows_edit = $("#tbody_edit").find("tr")
            var tdArrs0 = rows_edit.eq(0).find("td");
            var tdArrs1 = rows_edit.eq(1).find("td");
            var tdArrs2 = rows_edit.eq(2).find("td");

            var name = tdArrs0.eq(3).find("input").val()
            var gender = tdArrs0.eq(5).find("select").val()
            var card = tdArrs0.eq(7).find("input").val()
            var diploma = tdArrs0.eq(9).find("select").val()
            var profession = tdArrs0.eq(11).find("input").val()
            var school = tdArrs0.eq(13).find("input").val()
            var graducateDate = tdArrs0.eq(15).find("input").val()

            tdArrs_trainee.eq(3).text(name)
            tdArrs_trainee.eq(4).text(gender)
            tdArrs_trainee.eq(5).text(card)
            tdArrs_trainee.eq(11).text(diploma)
            tdArrs_trainee.eq(12).text(profession)
            tdArrs_trainee.eq(13).text(school)
            tdArrs_trainee.eq(14).text(graducateDate)



            var state = tdArrs1.eq(1).find("select").val()
            var tel = tdArrs1.eq(3).find("input").val()
            var email = tdArrs1.eq(5).find("input").val()
            var contact = tdArrs1.eq(7).find("input").val()
            var contactTel = tdArrs1.eq(9).find("input").val()
            var payWay = tdArrs1.eq(11).find("select").val()

            var worWay = tdArrs1.eq(13).find("select").val()
            var worDate = tdArrs1.eq(15).find("input").val()

            tdArrs_trainee.eq(10).text(state)
            tdArrs_trainee.eq(15).text(tel)
            tdArrs_trainee.eq(16).text(email)
            tdArrs_trainee.eq(17).text(contact)
            tdArrs_trainee.eq(18).text(contactTel)
            tdArrs_trainee.eq(19).text(payWay)

            tdArrs_trainee.eq(20).text(worWay)
            tdArrs_trainee.eq(21).text(worDate)


            var corporation = tdArrs2.eq(1).find("input").val()
            var salary = tdArrs2.eq(3).find("input").val()
            tdArrs_trainee.eq(22).text(worWay)
            tdArrs_trainee.eq(23).text(worDate)

            //???????????????????????????????????????????????????  ??????
            if(tdArrs2.eq(5).find("a").text() == '?????????'){
                tdArrs_trainee.eq(24).text("?????????")
            }else{
                var alink = document.createElement('a');
                alink.href = 'javascript:void(0)';
                alink.onclick = function () {
                    showPhoto(0,rowIndex_cur )
                    return false;//????????????
                };
                alink.innerHTML = '????????????';
                tdArrs_trainee.eq(24).html(alink);
            }

            if(tdArrs2.eq(7).find("a").text() == '?????????'){
                tdArrs_trainee.eq(25).text("?????????")
            }else{
                var alink = document.createElement('a');
                alink.href = 'javascript:void(0)';
                alink.onclick = function () {
                    showPhoto(1,rowIndex_cur )
                    return false;//????????????
                };
                alink.innerHTML = '????????????';
                tdArrs_trainee.eq(25).html(alink);
            }

            if(tdArrs2.eq(9).find("a").text() == '?????????'){
                tdArrs_trainee.eq(26).text("?????????")
            }else{
                var alink = document.createElement('a');
                alink.href = 'javascript:void(0)';
                alink.onclick = function () {
                    showPhoto(2,rowIndex_cur )
                    return false;//????????????
                };
                alink.innerHTML = '????????????';
                tdArrs_trainee.eq(26).html(alink);
            }

            if(tdArrs2.eq(11).find("a").text() == '?????????'){
                tdArrs_trainee.eq(27).text("?????????")
            }else{
                var alink = document.createElement('a');
                alink.href = 'javascript:void(0)';
                alink.onclick = function () {
                    showPhoto(3,rowIndex_cur )
                    return false;//????????????
                };
                alink.innerHTML = '????????????';
                tdArrs_trainee.eq(27).html(alink);
            }

            if(tdArrs2.eq(13).find("a").text() == '?????????'){
                tdArrs_trainee.eq(28).text("?????????")
            }else{
                var alink = document.createElement('a');
                alink.href = 'javascript:void(0)';
                alink.onclick = function () {
                    showPhoto(4,rowIndex_cur )
                    return false;//????????????
                };
                alink.innerHTML = '????????????';
                tdArrs_trainee.eq(28).html(alink);
            }

            var rows_edit = $("#tbody_edit").find("tr")
            var tdArrs0 = rows_edit.eq(0).find("td");
            var code = tdArrs0.eq(1).find("input").val();

            var cname = $("#center").text()

            var classcode = $("#labclasscode").text()

            //???????????????
            var data = {
                "code":code,"name":name,"gender":gender,"card":card,"diploma":diploma,"profession":profession,"school":school,
                "graducateDate":graducateDate, "state":state,"tel":tel,"email":email,"contact":contact,"contactTel":contactTel,
                "cname":cname,"classcode":classcode, "payWay":payWay,
                "employWay":worWay,"employDate":worDate, "corporation":corporation,"salary":salary
            }

            $.post(
                    "/class/updateBaseInfoForTrainee",
                    {"data":JSON.stringify(data)},
                    function (data) {
                        alert(data)
                    }
            )

        }


        function uploadPhotoDlg(type){
            var rows_edit = $("#tbody_edit").find("tr")
            var tdArrs0 = rows_edit.eq(0).find("td");
            var code = tdArrs0.eq(1).text()
            var classcode =  $("#classcodes_search").val();

            $("input[name='code_dlg']").val(code)
            $("input[name='type_dlg']").val(type)
            $("input[name='classcode_dlg']").val(classcode)
            $('#info').text("")

            $('#imageModal').modal();
        }

        function showPhoto(type, rowIndex){
            var code
            if(rowIndex == -1){//??????????????????
                var rows_edit = $("#tbody_edit").find("tr")
                var tdArrs0 = rows_edit.eq(0).find("td");
                code = tdArrs0.eq(1).text()
            }else{
                var rows_trainee = $("#tbody_trainee").find("tr")
                var tdArrs_trainee = rows_trainee.eq(rowIndex).find("td");
                code = tdArrs_trainee.eq(2).text()
            }

            $.post(
                    "/class/getPhotoNameByCodeType",
                    {"code":code,"type":type},
                    function (fileName) {
                        if(fileName != null){
                            $("#showImg").attr("src",fileName);
                            $('#showImageModal').modal();
                        }

                    }
            );

        }




        function onQuery() {
            var classcode = $("#classcodes_search").val()
            if(classcode == null){
                alert("???????????????????????????!")
                return
            }

            var centerName = $("#centers_search").find("option:selected").text();
            var classTeaterName = $("#classteachers_search").find("option:selected").text();

            $.post(
                    "/class/getBaseInfoForTraineeByClassCode",
                    {"classcode":classcode},
                    function (baseinfoForTrainees) {
                        if(baseinfoForTrainees != null){
                            $("#tbody_trainee").empty()

                            var length = baseinfoForTrainees.length
                            for(var i = 0; i < length; i++){
                                var baseinfoForTrainee = baseinfoForTrainees[i]
                                var str = "<tr>"
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td><a href=javascript:void(0)' onclick='edit(" + i +")'>??????</a></td>"

                                str = str + "<td>" + baseinfoForTrainee.code + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.name + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.gender + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.card + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.classcode + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.ctname + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.dname + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.cname + "</td>"
                                if(baseinfoForTrainee.state == null){
                                    baseinfoForTrainee.state = "??????"
                                }
                                str = str + "<td>" + baseinfoForTrainee.state + "</td>"

                                str = str + "<td>" + baseinfoForTrainee.diploma + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.profession + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.graduateSchool + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.graducateTime + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.tel + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.email + "</td>"

                                str = str + "<td>" + baseinfoForTrainee.contact + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.contactTel + "</td>"
                                str = str + "<td>" + baseinfoForTrainee.lendWay + "</td>"

                                if(baseinfoForTrainee.employInfoForTrainee == null){
                                    str = str + "<td>??????</td>"
                                    str = str + "<td>??????</td>"
                                    str = str + "<td>??????</td>"
                                    str = str + "<td>??????</td>"
                                }else{
                                    str = str + "<td>" + baseinfoForTrainee.employInfoForTrainee.state + "</td>"
                                    str = str + "<td>" + baseinfoForTrainee.employInfoForTrainee.employ_time + "</td>"
                                    str = str + "<td>" + baseinfoForTrainee.employInfoForTrainee.employ_unit + "</td>"
                                    str = str + "<td>" + baseinfoForTrainee.employInfoForTrainee.employ_salary + "</td>"
                                }


                                if(baseinfoForTrainee.payproof == "?????????"){
                                    str = str + "<td>?????????</td>"
                                }else{
                                    str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(0," +  i + ")'>????????????</a></td>"
                                }

                                if(baseinfoForTrainee.diplomaImg == "?????????"){
                                    str = str + "<td>?????????</td>"
                                }else{
                                    str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(1," +  i + ")'>????????????</a></td>"
                                }

                                if(baseinfoForTrainee.employImg == "?????????"){
                                    str = str + "<td>?????????</td>"
                                }else{
                                    str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(2," +  i + ")'>????????????</a></td>"
                                }
                                if(baseinfoForTrainee.cardImg1 == "?????????"){
                                    str = str + "<td>?????????</td>"
                                }else{
                                    str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(3," +  i + ")'>????????????</a></td>"
                                }
                                if(baseinfoForTrainee.cardImg2 == "?????????"){
                                    str = str + "<td>?????????</td>"
                                }else{
                                    str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(4," +  i + ")'>????????????</a></td>"
                                }


                                str = str + "</tr>"
                                $("#tbody_trainee").append(str)
                            }
                        }

                    }
            );



        }


        function onAddTrainee(){
            var classcode = $("#classcodes_search").val()
            if(classcode == null || classcode.length == 0){
                alert("????????????????????????????????????????????????")
                return
            }

            $.post(
                "/class/getNextCode",
                {"classcode":classcode},
                function (code_new) {
                    alert(code_new);
                    operator_type = "new"
                    var rows_edit = $("#tbody_edit").find("tr")
                    var tdArrs0 = rows_edit.eq(0).find("td");
                    var tdArrs1 = rows_edit.eq(1).find("td");
                    var tdArrs2 = rows_edit.eq(2).find("td");

                    tdArrs0.eq(1).find("input").val(code_new);
                    tdArrs0.eq(3).find("input").val("")
                    tdArrs0.eq(5).find("select").val("???")
                    tdArrs0.eq(7).find("input").val("")

                    tdArrs0.eq(11).find("input").val("")
                    tdArrs0.eq(13).find("input").val("")
                    tdArrs0.eq(15).find("input").val("")

                    tdArrs1.eq(3).find("input").val("")
                    tdArrs1.eq(5).find("input").val("")
                    tdArrs1.eq(7).find("input").val("")

                    tdArrs1.eq(9).find("input").val("")
                    tdArrs1.eq(15).find("input").val("")

                    tdArrs2.eq(1).find("input").val("")
                    tdArrs2.eq(3).find("input").val("")

                    tdArrs2.eq(5).html("<a href='javascript:void(0)' onclick='uploadPhotoDlg(0)'>?????????</a>")
                    tdArrs2.eq(7).html("<a href='javascript:void(0)' onclick='uploadPhotoDlg(1)'>?????????</a>")
                    tdArrs2.eq(9).html("<a href='javascript:void(0)' onclick='uploadPhotoDlg(2)'>?????????</a>")
                    tdArrs2.eq(11).html("<a href='javascript:void(0)' onclick='uploadPhotoDlg(3)'>?????????</a>")
                    tdArrs2.eq(13).html("<a href='javascript:void(0)' onclick='uploadPhotoDlg(4)'>?????????</a>")
                }
            );
        }


        function onSaveAddTrainee() {
            if(operator_type != "new"){
                alert("?????????????????? ???????????????????????? ?????????")
                return
            }
            //??????????????????
            var classcode = $("#classcodes_search").val()
            if(classcode == null || classcode.toString().length == 0){
                alert("????????????????????????????????????????????????????????????")
                return
            }
            var ctname = $("#classteachers_search").find("option:selected").text();
            var cname = $("#centers_search").find("option:selected").text();
            //var direction = $("#direction").text();



            var rows_edit = $("#tbody_edit").find("tr")
            var tdArrs0 = rows_edit.eq(0).find("td");
            var tdArrs1 = rows_edit.eq(1).find("td");
            var tdArrs2 = rows_edit.eq(2).find("td");

            var code = tdArrs0.eq(1).find("input").val();
            var name = tdArrs0.eq(3).find("input").val()
            var gender = tdArrs0.eq(5).find("select").val()
            var card = tdArrs0.eq(7).find("input").val()
            var diploma = tdArrs0.eq(9).find("select").val()
            var profession = tdArrs0.eq(11).find("input").val()
            var school = tdArrs0.eq(13).find("input").val()
            var graducateDate = tdArrs0.eq(15).find("input").val()


            var state = tdArrs1.eq(1).find("select").val()
            var tel = tdArrs1.eq(3).find("input").val()
            var email = tdArrs1.eq(5).find("input").val()
            var contact = tdArrs1.eq(7).find("input").val()
            var contactTel = tdArrs1.eq(9).find("input").val()
            var payWay = tdArrs1.eq(11).find("select").val()
            var employWay = tdArrs1.eq(13).find("select").val()
            var employDate = tdArrs1.eq(15).find("input").val()

            var corporation = tdArrs2.eq(1).find("input").val()
            var salary = tdArrs2.eq(3).find("input").val()

            var data = {
                "code":code,"name":name,"gender":gender,"card":card,"diploma":diploma,"profession":profession,"school":school,
                "graducateDate":graducateDate, "state":state,"tel":tel,"email":email,"contact":contact,"contactTel":contactTel,
                "classcode":classcode,
                "payWay":payWay,"employWay":employWay,"employDate":employDate,
                "corporation":corporation,"salary":salary
            }
            //???????????????
            $.post(
                    "/class/saveNewTrainee",
                    {"data":JSON.stringify(data)},
                    function (baseinfoForTrainee2) {
                        if(baseinfoForTrainee2 != null){
                            //???????????????
                            var rows_trainee = $("#tbody_trainee").find("tr")
                            var index = createIndex()
                            var str = "<tr>"
                            str = str + "<td>" + index + "</td>"
                            var curIndex = index - 1
                            str = str + "<td><a href=javascript:void(0)' onclick='edit(" + curIndex +")'>??????</a></td>"
                            str = str + "<td>" + code + "</td>"
                            str = str + "<td>" + name + "</td>"
                            str = str + "<td>" + gender + "</td>"
                            str = str + "<td>" + card + "</td>"
                            str = str + "<td>" + classcode + "</td>"
                            str = str + "<td>" + ctname + "</td>"
                            str = str + "<td>" + cname + "</td>"
                            str = str + "<td>" + state + "</td>"

                            str = str + "<td>" + diploma + "</td>"
                            str = str + "<td>" + profession + "</td>"
                            str = str + "<td>" + school + "</td>"
                            str = str + "<td>" + graducateDate + "</td>"

                            str = str + "<td>" + tel + "</td>"
                            str = str + "<td>" + email + "</td>"
                            str = str + "<td>" + contact + "</td>"
                            str = str + "<td>" + contactTel + "</td>"
                            str = str + "<td>" + payWay + "</td>"
                            str = str + "<td>" + employWay + "</td>"
                            str = str + "<td>" + employDate + "</td>"

                            str = str + "<td>" + corporation + "</td>"
                            str = str + "<td>" + salary + "</td>"

                            if(baseinfoForTrainee2.payproof == "?????????"){
                                str = str + "<td>?????????</td>"
                            }else{
                                str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(0," +  curIndex + ")'>????????????</a></td>"
                            }
                            if(baseinfoForTrainee2.diplomaImg == "?????????"){
                                str = str + "<td>?????????</td>"
                            }else{
                                str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(1," +  curIndex + ")'>????????????</a></td>"
                            }
                            if(baseinfoForTrainee2.employImg == "?????????"){
                                str = str + "<td>?????????</td>"
                            }else{
                                str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(2," +  curIndex + ")'>????????????</a></td>"
                            }
                            if(baseinfoForTrainee2.cardImg1 == "?????????"){
                                str = str + "<td>?????????</td>"
                            }else{
                                str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(3," +  curIndex + ")'>????????????</a></td>"
                            }
                            if(baseinfoForTrainee2.cardImg2 == "?????????"){
                                str = str + "<td>?????????</td>"
                            }else{
                                str = str + "<td><a href='javascript:void(0)' onclick='showPhoto(4," +  curIndex + ")'>????????????</a></td>"
                            }

                            alert("??????????????????????????????!")


                        }else{
                            alert("??????????????????????????????!??????????????????????????????")
                        }

                    }
            );
        }


        function createIndex() {
            var rows_trainee = $("#tbody_trainee").find("tr")
            var length = rows_trainee.length

            if(length > 0){
                var tdArrs_trainee = rows_trainee.eq(length - 1).find("td");
                var lastIndex = tdArrs_trainee.eq(0).text()
                lastIndex = parseInt(lastIndex)
                var newIndex = lastIndex + 1
                return newIndex
            }

            return 0

        }


        function onDownload() {
            //window.open("/corporiate/onDownload");
            window.location.href="/class/onDownload";
        }






    </script>



</head>

<body>

    <div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="imageModal">
        <div class="modal-dialog" role="document" style="text-align: center">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">????????????</h4>
                </div>
                <div class="modal-body">
                    <form id='uploadImgSumbit' class="form-horizontal"  action="/class/uploadImg" method="post" enctype="multipart/form-data" >
                        <input type="file" name="imgFile" id="imgFile" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="margin-right:50px;display: inline"><input type="submit" name="upload" value="??????" class="btn btn-primary">
                        <span id="info" ></span>
                        <input type="hidden"  name="code_dlg" value="" />
                        <input type="hidden"  name="type_dlg" value="" />
                        <input type="hidden"  name="classcode_dlg" value="" />
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                </div>
            </div>
        </div>
    </div>



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
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="col-lg-9" style="background: #dddddd">
                            <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
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
                                        <select class="form-control" id="classstates_search" style="min-width: 150px">
                                        <option value="??????" selected="selected">??????</option>
                                            <c:forEach var="traineeState" items="${requestScope.traineeStates}">
                                                <option value="${traineeState}">${traineeState}</option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                </tr>


                                <tr>
                                    <td style="text-align:right;">??????:</td>
                                    <td>
                                        <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                            <c:forEach var="classcode" items="${requestScope.classcodes}">
                                                <option value="${classcode}">${classcode}</option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <td style="text-align:right;"></td>
                                    <td>

                                    </td>
                                    <td style="text-align:right;"></td>
                                    <td> <button type="button" class="btn btn-primary" onclick="onQuery()"  style="min-width: 150px;float: right">???&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;???</button></td>
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
                                    <input  id="name_search" class = "form-control" placeholder = "?????????" style="width: 150px;visibility:hidden;">
                                </td>
                            </tr>
                            <tr>
                                <td>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</td>
                                <td><button type="button" class="btn btn-primary"  style="width: 150px;visibility:hidden;">????????????</button></td>
                            </tr>
                        </table>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>

            </div>
            <!-- /.row -->

            <div class="row" >
                <div class="col-lg-12">
                    <div class="panel panel-default" style="margin-bottom:0">

                        <div class="panel-body">

                            <div class="table-responsive">
                                <div style="width:4000px;height: 400px">
                                <table class="table table-striped table-bordered table-hover text-nowrap" >
                                    <thead>
                                        <tr >
                                            <th width="50px">#</th>
                                            <th width="100px">??????</th>
                                            <th width="150px">????????????</th>
                                            <th width="150px">??????</th>
                                            <th width="100px">??????</th>
                                            <th width="150px">???????????????</th>
                                            <th width="150px">????????????</th>
                                            <th width="200px">?????????</th>

                                            <th width="150px">????????????</th>
                                            <th width="150px">????????????</th>

                                            <th width="150px">????????????</th>
                                            <th width="150px">??????</th>
                                            <th width="200px">??????</th>
                                            <th width="200px">????????????</th>
                                            <th width="200px">????????????</th>
                                            <th width="200px">????????????</th>
                                            <th width="200px">????????????</th>
                                            <th width="100px">???????????????</th>
                                            <th width="200px">?????????????????????</th>

                                            <th width="100px">????????????</th>
                                            <th width="100px">????????????</th>
                                            <th width="200px">????????????</th>
                                            <th width="200px">????????????</th>
                                            <th width="100px">????????????</th>

                                             <!--?????????????????????????????????????????????????????????????????????-->
                                            <th width="100px">????????????</th>
                                            <th width="100px">????????????</th>
                                            <th width="100px">????????????</th>
                                            <th width="100px">???????????????</th>
                                            <th width="100px">???????????????</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody_trainee">

                                    </tbody>
                                </table>
                                </div>
                            </div>


                        </div>
                        <!-- /.panel-body -->
                    </div>

                </div>
            </div>


            <div class="row" >
                <div class="col-lg-12" style="float:right">
                    <div class="panel panel-default">
                        <div class="panel-body" style="background: #DDDDDD">
                            <form id='formSumbit' class="form-inline" role="form"   action="/class/importExcel" method="post" enctype="multipart/form-data" style="float:right;">

                                ??????:
                                <select class="form-control" name="centers_type">
                                    <c:forEach var="center" items="${requestScope.centers}">
                                        <option value="${center.cid}">${center.cname}</option>
                                    </c:forEach>
                                </select>
                                ??????:
                                <select class="form-control" name="directions_type" style="display: inline;">
                                    <c:forEach var="direction" items="${requestScope.directions}">
                                        <option value="${direction.did}">${direction.dname}</option>
                                    </c:forEach>
                                </select>
                                ????????????:
                                <select class="form-control" name="classstates" style="display: inline;">
                                    <c:forEach var="classstate" items="${requestScope.classstates}">
                                        <option value="${classstate}">${classstate}</option>
                                    </c:forEach>
                                </select>
                                ????????????:
                                <input type="date" name="beginDate" style="display: inline;margin-right: 10px">
                                <input type="file" name="excelFile" id="excelFile" class="file-loading" multiple accept=".xls,.xlsx" style="display: inline">
                                <input type="submit"  value="??????????????????" class="btn btn-primary" style="min-width: 125px;float:right;">
                            </form>


                        </div>
                    </div>

                </div>
                <div class="col-lg-12" style="float:right;">
                    <button type="button" class="btn btn-primary" onclick="onDownload()" style="min-width: 100px;float:right;">????????????????????????</button>
                </div>

                <div class="col-lg-12" style="float:left;margin-top: 20px">
                    ???????????????<label id="labclasscode" style="margin-right: 30px">________</label>
                    ???????????????<label id="direction" style="margin-right: 30px">________</label>
                    ???????????????<label id="center" style="margin-right: 30px">________</label>
                    ????????????<label id="classteacher" >________</label>
                </div>

            </div>

            <div class="row" >
                <div class="col-lg-12">
                    <div class="panel panel-default">

                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover text-nowrap">
                                <tbody id="tbody_edit">
                                    <tr>
                                        <td width="100px">????????????</td>
                                        <td width="150px"><input class = "form-control" placeholder="????????????" id="code"></td>
                                        <td width="100px">??????</td>
                                        <td width="150px"><input class = "form-control" id="traineename"></td>
                                        <td width="100px">??????</td>
                                        <td width="150px">
                                            <select id="genders">
                                                <option value="???">???</option>
                                                <option value="???">???</option>
                                            </select>
                                        </td>
                                        <td width="100px">???????????????</td>
                                        <td width="150px">
                                            <input class = "form-control" id="idcard">
                                        </td>
                                        <td width="100px">??????</td>
                                        <td width="150px">
                                            <select id="diplomas" class="form-control">
                                                <c:forEach var="diplomaState" items="${requestScope.diplomaStates}">
                                                    <option value="${diplomaState}">${diplomaState}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td width="100px">??????</td>
                                        <td width="150px">
                                            <input class = "form-control" id="profession">
                                        </td>
                                        <td width="100px">????????????</td>
                                        <td width="150px">
                                            <input class = "form-control" id="school">
                                        </td>
                                        <td width="100px">????????????</td>
                                        <td width="200px">
                                            <input class = "form-control" id="graduateDate" type="number">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>????????????</td>
                                        <td>
                                            <select id="traineeStates">
                                                <c:forEach var="traineeState" items="${requestScope.traineeStates}">
                                                    <option value="${traineeState}">${traineeState}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <input class = "form-control" id="tel">
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <input class = "form-control" id="email" type="email">
                                        </td>
                                        <td>???????????????</td>
                                        <td>
                                            <input class = "form-control" id="contact">
                                        </td>
                                        <td>???????????????</td>
                                        <td>
                                            <input class = "form-control" id="contact-tel">
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <select id="payWays">
                                                <c:forEach var="payWay" items="${requestScope.payWays}">
                                                    <option value="${payWay}">${payWay}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <select id="employWays">
                                                <c:forEach var="employWay" items="${requestScope.employWays}">
                                                    <option value="${employWay}">${employWay}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <input class = "form-control" type="date" id="work-date">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>????????????</td>
                                        <td>
                                            <input class = "form-control" id="corporiation">
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <input class = "form-control" id="salary" type="number">
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <a href="javascript:void(0)">?????????</a>
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <a href="javascript:void(0)">?????????</a>
                                        </td>
                                        <td>????????????</td>
                                        <td>
                                            <a href="javascript:void(0)">?????????</a>
                                        </td>
                                        <td>???????????????</td>
                                        <td>
                                            <a href="javascript:void(0)">?????????</a>
                                        </td>
                                        <td>???????????????</td>
                                        <td>
                                            <a href="javascript:void(0)">?????????</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>

            <div class="row" style="margin-bottom: 20px">

                <div class="col-lg-12" >
                    <div class="col-lg-6" align="left">
                        <button type="button" class="btn btn-default" onclick="onUpdateTrainee()" style="min-width: 120px">??????????????????</button>
                    </div>
                    <div class="col-lg-6" align="right">
                        <button type="button" class="btn btn-default" onclick="onAddTrainee()" style="min-width: 120px">????????????????????????</button>
                        <button type="button" class="btn btn-default" onclick="onSaveAddTrainee()" style="margin-left: 50px;min-width: 120px">????????????????????????</button>
                    </div>


                </div>

            </div>

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->



</body>

</html>
