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
        var rowIndex = -1
        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime ="2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#startTime_summary').val(startTime);
            $('#endTime_summary').val(today);

            $('#startTime_d').val(startTime);
            $('#endTime_d').val(today);
            $("#directions_d").attr("disabled","disabled");
            $("#classteachers_d").attr("disabled","disabled");


            $("#tbody_new").find("tr").eq(3).hide()



            $("#types_new").change(function(){
                var type=$("#types_new").val()

                if(type == "转班" || type == "重修" || type=="休学复学"){
                    $("#tbody_new").find("tr").eq(3).show()
                }else{
                    $("#tbody_new").find("tr").eq(3).hide()
                }

            })

            $("#type_update").change(function(){
                var type=$("#type_update").val()
                if(type == "转班" || type == "重修" || type=="休学复学"){
                    $("#tbody_edit").find("tr").eq(4).show()
                }else{
                    $("#tbody_edit").find("tr").eq(4).hide()
                }

            })



            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                $.post(
                    "/class/classteachersInCenter",
                    {"centerId":centerId},
                    function (data) {
                        if(data != null){
                        $("#classteachers_s").html("");
                        var length = data.length
                        var str =""
                        for(var i = 0; i < length; i++){
                        var classTeacher = data[i]
                        str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                        }
                        $("#classteachers_s").append(str)
                        }
                    }
                );
            })

            $("#classteachers_s").change(function(){
                var startTime = $('#startTime_search').val();
                var endTime = $('#endTime_search').val();
                var ctid=$("#classteachers_s").val();
                if(ctid > 0){
                    $.post(
                        "/class/getClassCodesByClidTime",
                        {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                        function (data) {
                            if(data != null){
                                $("#classcodes_s").empty()
                                var str = ""
                                var length = data.length
                                for(var i = 0; i < length; i++){
                                    str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                }

                                $("#classcodes_s").append(str)
                            }

                        }
                    );
                }

            })











            ///////////////////////////////////////统计/////////////////////////////////////////
            $("#centers_summary").change(function(){
                var centerId=$("#centers_summary").val()
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_summary").html("");
                                var length = data.length
                                var str =""

                                for(var i = 0; i < length; i++){
                                    var classTeacher = data[i]
                                    str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                                }
                                $("#classteachers_summary").append(str)
                            }

                        }
                );
            })


            $("#classteachers_summary").change(function(){
                var startTime = $('#startTime_summary').val();
                var endTime = $('#endTime_summary').val();
                var ctid=$("#classteachers_summary").val();

                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClidTime",
                            {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_summary").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_summary").append(str)
                                }

                            }
                    );
                }

            })


            $("#directions_summary").change(function(){
                var startTime = $('#startTime_summary').val();
                var endTime = $('#endTime_summary').val();
                var ctid=$("#classteachers_summary").val();
                if(ctid > 0){
                    $.post(
                            "/class/getClassCodesByClidTime",
                            {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                            function (data) {
                                if(data != null){
                                    $("#classcodes_summary").empty()
                                    var str = ""
                                    var length = data.length
                                    for(var i = 0; i < length; i++){
                                        str = str + "<option value='" + data[i] + "'>" + data[i] + "</option>"
                                    }

                                    $("#classcodes_summary").append(str)

                                }

                            }
                    );
                }

            })


            $('#uploadImgSumbit_new').submit(function (event) {
                //首先验证文件格式
                var fileName = $(this).find("input[name=imgFile_new]").val();
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
                    var code = $('#code_new').val()
                    $('#codeee_new').val(code)

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
                                $('#id_new').val(data.id)
                                $("#img_new").attr("src", data.imgProof);
                                $('#imgurl_new').val(data.imgurl);
                            }else{
                                $('#info').text("图片上传失败")
                            }
                        }
                    });
                }
            });

            $('#uploadImgSumbit_edit').submit(function (event) {
                //首先验证文件格式
                var fileName = $(this).find("input[name=imgFile_update]").val();
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
                            if(data.result == "success"){
                                $("#img_update").attr("src", data.imgProof);
                                $("#imgurl_update").val(data.imgurl);
                            }else{
                                alert("图片上传失败")
                            }

                            return false;
                        }
                    });
                }
            });



        })

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        function showNewXuejiDlg(){
            //获取当前班级编号
            var classcode = $('#classcodes_s').val()
            if(classcode == null || classcode.length == 0){
                alert("您应该首先选中一个班级");
                return
            }
            $('#id_new').val("")
            $('#codeee_new').val("")
            $('#imgurl_new').val("");


            $('#content_new').val("");
            $('#reason_new').val("");
            $('#createTime_new').val("");

            $('#img_new').attr("src", "/img/default.jpg");

            $("#target_new option:first").prop("selected", 'selected');
            $("#types_new option:first").prop("selected", 'selected');
            $("#code_new option:first").prop("selected", 'selected');

            $("#tbody_new").find("tr").eq(3).hide();


            $.post(
                    "/jiaowu/getXuejiInfoByClassCode",
                    {"classcode":classcode},
                    function (data) {
                        var length = data.length
                        $('#code_new').empty()
                        var str = ""
                        for(var i = 0; i < length; i++){
                            var baseinfoForTrainee = data[i]
                            str = str + "<option value='" + baseinfoForTrainee.code + "'>" + baseinfoForTrainee.code + "--" + baseinfoForTrainee.name + "</option>"
                        }
                        $('#code_new').append(str)

                        var now = new Date();
                        var day = ("0" + now.getDate()).slice(-2);
                        var month = ("0" + (now.getMonth() + 1)).slice(-2);
                        var today = now.getFullYear() + "-" + (month) + "-" + (day);
                        $('#createTime_new').val(today);


                        $('#xuejiModal_new').modal();

                    }
            );

        }

        function saveNewXueji(){
            var id = $('#id_new').val()
            if(id==""){
                id=-1
            }

            var classcode = $('#classcodes_s').val()
            var info = $("#code_new").find("option:selected").text();
            var code = info.split("--")[0]
            var name = info.split("--")[1]
            var timee = $('#createTime_new').val()
            var type = $('#types_new').val()
            var targetClasscode=""
            if(type == "转班" || type == "重修" || type =="休学复学"){
                targetClasscode = $("#tbody_new").find("tr").eq(3).find("td").eq(1).find("select").val()
            }

            var imgProof = $('#imgurl_new').val()

            var content =  $('#content_new').val()
            var reason =  $('#reason_new').val()
            var result =  $("#result_new").val();

            $.post(
                    "/jiaowu/saveXuejiInfo",
                    {"id":id,"classcode":classcode,"code":code,"timee":timee,"type":type,"targetClasscode":targetClasscode,"content":content,"reason":reason,"result":result,"imgProof":imgProof},
                    function (data) {
                        if(data > 0){
                            query()
                            $("#xuejiModal_new").modal("hide")

                        }else{
                            alert("保存失败")
                        }

                    }
            );
        }
        function showData(data) {
            if(null != data){
                var length = data.xuejis.length
                $('#tbody_xuejiinfos').empty()
                for(var i = 0; i < length; i++){

                    var xueji = data.xuejis[i]

                    var str = "<tr>"
                    str = str + "<td>" + xueji.id + "</td>"
                    str = str + "<td><a href='javascript:void(0)' onclick='edit( " + i + ")'>编辑</a></td>"
                    str = str + "<td>" + xueji.timee + "</td>"
                    str = str + "<td>" + xueji.name + "</td>"
                    str = str + "<td>" + xueji.code + "</td>"
                    str = str + "<td>" + xueji.classcode + "</td>"
                    str = str + "<td>" + xueji.type + "</td>"
                    if(xueji.targetClasscode == null){
                        xueji.targetClasscode = ""
                    }
                    str = str + "<td>" + xueji.targetClasscode + "</td>"
                    str = str + "<td>" + xueji.content + "</td>"
                    str = str + "<td>" + xueji.reason + "</td>"
                    if(xueji.imgProof == null || xueji.imgProof.length == 0){
                        str = str + "<td>无</td>"
                    }else{
                        str = str + "<td><a href='javascript:void(0)' onclick='showPhoto( " + xueji.id + ")'>点击查看</a></td>"
                    }
                    str = str + "<td>" + xueji.result + "</td>"

                    str = str + "</tr>"

                    $('#tbody_xuejiinfos').append(str)

                }


            }

        }


        function querydown() {
            $('#exportXuejiModal').modal();
        }

        function query(){
            var classcode = $('#classcodes_s').val()
            if(classcode == null){
                alert("请选择正确的班级编号")
                return
            }else{
                $.post(
                        "/jiaowu/getXuejiDetail2",
                        {"classcode":classcode},
                        function (data) {
                            showData(data)
                        }


                        //更新班级
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
                    "/jiaowu/getXuejiByName",
                    {"name":name},
                    function (data) {
                        showData(data)
                    }
            );


        }

        function edit(row){
            rowIndex = row
            var rows_edit = $("#tbody_xuejiinfos").find("tr")
            var tdArrs = rows_edit.eq(rowIndex).find("td");

            var id = tdArrs.eq(0).text()
            $.post(
                    "/jiaowu/getImgProofById",
                    {"id":id},
                    function (data) {
                        if(data.result == "success"){

                            $("#id_update").val(id);
                            $("#img_update").attr("src",data.imgProof);
                            $("#imgurl_update").val(data.imgurl);

                        }else{
                            $("#id_update").val(id);
                            $("#img_update").attr("src",data.imgDefault);
                            $("#imgurl_update").val("");
                        }
                        //var id = tdArrs.eq(0).text()
                        var timee = tdArrs.eq(2).text()
                        var name = tdArrs.eq(3).text()
                        var code = tdArrs.eq(4).text()
                        var classcode = tdArrs.eq(5).text()
                        var type = tdArrs.eq(6).text()
                        var targetClasscode = tdArrs.eq(7).text()
                        var content = tdArrs.eq(8).text()
                        var reason = tdArrs.eq(9).text()
                        var result = tdArrs.eq(11).text()


                        $('#codeee_update').val(code)
                        $('#id_update').val(id)


                        $('#timee_update').text(timee);
                        $('#classcode_update').text(classcode);
                        $('#code_update').text(code + "--" +name);

                        $('#type_update').val(type)
                        if(type == "转班" || type == "重修" || type == "休学复学"){
                            $("#tbody_edit").find("tr").eq(4).show()
                            $("#tbody_edit").find("tr").eq(4).find("td").eq(1).html(targetClasscode)

                        }else{
                            $("#tbody_edit").find("tr").eq(4).hide()
                        }

                        $('#content_update').val(content)
                        $('#reason_update').val(reason)

                        $("#result_edit").val(result);
                    }
            );


            $('#xuejiModal_edit').modal();
        }


        function saveXuejiUpdate(){
            var rows_edit = $("#tbody_xuejiinfos").find("tr")
            var tdArrs = rows_edit.eq(rowIndex).find("td");
            var code = tdArrs.eq(4).text()
            var id = tdArrs.eq(0).text()

            var type = $('#type_update').val()
            var targetClasscode=""
            if(type == "转班" || type == "重修" || type == "休学复学"){
                targetClasscode = $("#tbody_edit").find("tr").eq(4).find("td").eq(1).text()
            }
            var imgProof = $('#imgurl_update').val()

            var content = $('#content_update').val()
            var reason = $('#reason_update').val()
            var result =  $('#result_update').val()

            var rows_edit = $("#tbody_xuejiinfos").find("tr")
            var tdArrs = rows_edit.eq(rowIndex).find("td");

            $.post(
                    "/jiaowu/updateXuejiInfo",
                    {"code":code,"type":type,"targetClasscode":targetClasscode,"imgProof":imgProof, "content":content,"reason":reason,"result":result,"id":id},
                    function (data) {
                        if(data == "success"){
                            $('#xuejiModal_edit').modal("hide");
                            query()
                        }else{
                            alert("保存数据失败")
                        }
                    }
            );

        }


        function showPhoto(id) {
            $.post(
                    "/jiaowu/getImgProofById",
                    {"id":id},
                    function (data) {
                        if(data.result == "success"){
                            $("#imgPhoto").attr("src",data.imgProof);
                        }else{
                            $("#imgPhoto").attr("src",data.imgDefault);

                        }

                        $('#showImageModal').modal();
                    }
            );

        }

        function query_summary() {
            var centerId = $("#centers_summary").val()
            var ctid = $("#classteachers_summary").val()
            var classcode = $("#classcodes_summary").val()
            var startTime = $("#startTime_summary").val()
            var endTime = $("#endTime_summary").val()

            $.post(
                    "/jiaowu/getXuejiSummary",
                    {"centerId":centerId,"ctid":ctid, "classcode":classcode, "startTime":startTime, "endTime":endTime},
                    function (xuejiSummaries) {
                        $("#tbody_summary").empty()
                        if(xuejiSummaries != null){

                            var length = xuejiSummaries.length
                            for(var i = 0; i < length; i++){
                                var xuejiSummarie = xuejiSummaries[i]
                                var str = "<tr>";
                                var index = i+1
                                str = str + "<td>" + index + "</td>"
                                str = str + "<td>" + xuejiSummarie.classcode + "</td>"
                                str = str + "<td>" + xuejiSummarie.dname + "</td>"
                                str = str + "<td>" + xuejiSummarie.ctname + "</td>"
                                str = str + "<td>" + xuejiSummarie.state + "</td>"

                                str = str + "<td>" + xuejiSummarie.xiuxuefuxue_add + "</td>"
                                str = str + "<td>" + xuejiSummarie.chongxiuruban_add + "</td>"
                                str = str + "<td>" + xuejiSummarie.zhuanrubenban_add + "</td>"

                                str = str + "<td>" + xuejiSummarie.zhuanqubieban_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.chongxiuliban_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.xiuxuelibanrenshu_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.zizhuzeyerenshu_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.tuifeirenshu_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.shilianrenshu_sub + "</td>"
                                str = str + "<td>" + xuejiSummarie.tuixuerenshu_sub + "</td>"


                                str = str + "<td>" + xuejiSummarie.weiman3yuezizhuzeye_liushi + "</td>"
                                str = str + "<td>" + xuejiSummarie.tuifeirenshu_liushi + "</td>"
                                str = str + "<td>" + xuejiSummarie.shilianrenshu_liushi + "</td>"
                                str = str + "<td>" + xuejiSummarie.xiuxuebufuxue_liushi + "</td>"
                                str = str + "<td>" + xuejiSummarie.tuixuerenshu_liushi + "</td>"


                                str = str + "<td>" + xuejiSummarie.fuxuerenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.jiebanrenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.liushilv_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.tuichijiuye_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.zizhuzeyerenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.jinrujiuyerenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.bufuhejiuyerenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.yijiuyerenshu_summary + "</td>"
                                str = str + "<td>" + xuejiSummarie.jiuyelv_summary + "</td>"
                                str = str + "<td>0</td>"
                                str = str + "<td>0</td>"
                                str = str + "<td>无</td>"

                                str = str + "</tr>";
                                $("#tbody_summary").append(str)
                            }
                        }
                    }
            );

        }

        function regionSelect(region) {
            $("#centers_d").attr("disabled","disabled");
            $("#directions_d").attr("disabled","disabled");
            $("#classteachers_d").attr("disabled","disabled");
            switch(region) {
                case "center":
                    $("#centers_d").removeAttr("disabled");
                    break;
                case "direction":
                    $("#directions_d").removeAttr("disabled");
                    break;
                case "classteacher":
                    $("#classteachers_d").removeAttr("disabled");
                    break;
            }
        }
        
        function exportXueji() {
            region = $("input[name='region']:checked").val();
            var way = -1
            var v= -1
            switch(region) {
                case "center":
                    v=$("#centers_d").val();
                    way=0
                    break;
                case "direction":
                    v=$("#directions_d").val()
                    way=1
                    break;
                case "classteacher":
                    v=$("#classteachers_d").val()
                    way=2
                    break;
            }

            var startTime=$("#startTime_d").val()
            var endTime = $("#endTime_d").val()
            var xuejiType=$("#xueji_d").val()

            window.location.href="/jiaowu/exportXueji?way="+way+"&value=" + v +"&xuejiType="+xuejiType + "&startTime="+startTime + "&endTime=" + endTime;
            $('#xuejiModal_new').modal("hide");
        }

        function onRefreshDate() {
            var startTime = $("#startTime_d").val()
            var endTime = $("#endTime_d").val()

            $.post(
                    "/jiaowu/getCenterDirectionClassteachersForTime",
                    {"startTime":startTime,"endTime":endTime},
                    function (data) {
                        if(data  != null){
                            var centers = data.centers_recent
                            var directions = data.directions_recent
                            var classteachers = data.classteachers_recent

                            $("#classteachers_d").empty()
                            var str = ""
                            if(classteachers != null){
                                for(var i = 0; i < classteachers.length; i++){
                                    str = "<option value='" + classteachers[i].ctid +  "'>"+classteachers[i].ctname + "</option>"
                                }
                            }
                            $("#classteachers_d").append(str)


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

    </script>

</head>

<body>

    <div class="modal fade" id="xuejiModal_edit" tabindex="-1" role="dialog" aria-labelledby="imageModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">编辑学籍变更信息</h4>
                </div>

                <div class="modal-body">
                    <table class="table table-striped table-bordered table-hover">
                        <tbody id="tbody_edit">
                            <tr>
                                <td width="20%">时间</td>
                                <td width="80%"><label id="timee_update"  ></label></td>
                            </tr>
                            <tr>
                                <td>班级编号</td>
                                <td><label id="classcode_update" class="form-control"></label>
                                </td>
                            </tr>
                            <tr>
                                <td>学号--姓名</td>
                                <td><label id="code_update" class="form-control"></label></td>
                            </tr>
                            <tr>
                                <td>变更类型</td>
                                <td>
                                    <select id="type_update" class="form-control">
                                        <c:forEach var="updateType" items="${requestScope.updateTypes}" >
                                            <option value="${updateType}">${updateType}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr >
                                <td>目标班级</td>
                                <td>
                                    <select id="target_update" class="form-control">
                                        <c:forEach var="classcode" items="${requestScope.allclasscodes}" >
                                            <option value="${classcode}">${classcode}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>变更内容</td>
                                <td><input id="content_update" class="form-control" placeholder="输入文字"></td>
                            </tr>
                            <tr>
                                <td>变更原因</td>
                                <td>
                                    <input id="reason_update" class="form-control" placeholder="输入文字">
                                </td>
                            </tr>
                            <tr>
                                <td>图片凭证</td>
                                <td>
                                    <form id='uploadImgSumbit_edit' class="form-horizontal"  action="/jiaowu/updateImg" method="post" enctype="multipart/form-data" >
                                        <input type="file" id="imgFile_update" name="imgFile_update" id="imgFile_update" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                        <input type="submit" value="上传" class="btn btn-default" style="display: inline">
                                        <img id="img_update" src="/img/default.jpg"  style="height: 100px;display: inline">

                                        <input type="hidden"  id="id_update" name="id_update" value="" />
                                        <input type="hidden"  id="codeee_update" name="codeee_update" value="" />
                                        <input type="hidden"  name="imgurl_update" id="imgurl_update" value="" />

                                    </form>


                                </td>
                            </tr>

                            <tr>
                                <td>变更结果</td>
                                <td>
                                    <select class="form-control" id="result_update">
                                        <option value="未通过">未通过</option>
                                        <option value="通过">通过</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>

                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button"  class="btn btn-primary" onclick="saveXuejiUpdate()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="xuejiModal_new" tabindex="-1" role="dialog" aria-labelledby="imageModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">新增学籍变更信息</h4>
                </div>

                <div class="modal-body">
                     <table class="table table-striped table-bordered table-hover">
                         <tbody id="tbody_new">
                             <tr>
                                 <td width="20%">时间</td>
                                 <td width="80%"><input id="createTime_new" type="date" class="form-control" placeholder="输入文字" ></td>
                             </tr>
                             <tr>
                                 <td>学号--姓名</td>
                                 <td><select id="code_new" class="form-control"></select>
                                 </td>
                             </tr>
                             <tr>
                                 <td>变更类型</td>
                                 <td>
                                     <select id="types_new" class="form-control">
                                         <c:forEach var="updateType" items="${requestScope.updateTypes}" >
                                             <option value="${updateType}">${updateType}</option>
                                         </c:forEach>
                                     </select>
                                 </td>
                             </tr>

                             <tr>
                                 <td>目标班级</td>
                                 <td>
                                     <select id="target_new" class="form-control">
                                         <c:forEach var="classcode" items="${requestScope.allclasscodes}" >
                                             <option value="${classcode}">${classcode}</option>
                                         </c:forEach>
                                     </select>
                                 </td>
                             </tr>

                             <tr>
                                 <td>变更内容</td>
                                 <td><input id="content_new" class="form-control" placeholder="输入文字"></td>
                             </tr>
                             <tr>
                                 <td>变更原因</td>
                                 <td>
                                     <input id="reason_new" class="form-control" placeholder="输入文字">
                                 </td>
                             </tr>



                             <tr>
                                 <td>图片凭证</td>
                                 <td>
                                     <form id='uploadImgSumbit_new' class="form-horizontal"  action="/jiaowu/newImg" method="post" enctype="multipart/form-data" >
                                         <input type="file" name="imgFile_new" id="imgFile_new" class="file-loading" multiple accept=".jpg,.jpeg,.bmp,.png" style="display: inline">
                                         <input type="submit" name="upload_new" value="上传" class="btn btn-default" style="display: inline">
                                         <img id="img_new" src="/img/default.jpg"  style="height: 100px;display: inline">

                                         <input type="hidden"  name="id_new" id="id_new" value="" />
                                         <input type="hidden"  name="codeee_new" id="codeee_new" value="" />
                                         <input type="hidden"  name="imgurl_new" id="imgurl_new" value="" />

                                     </form>
                                 </td>
                             </tr>

                             <tr>
                                 <td>变更结果</td>
                                 <td>
                                     <select class="form-control" id="result_new">
                                         <option value="未通过">未通过</option>
                                         <option value="通过">通过</option>
                                     </select>
                                 </td>
                             </tr>
                         </tbody>

                     </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button"  class="btn btn-primary" onclick="saveNewXueji()">保存</button>
                </div>
            </div>
        </div>
    </div>



    <div class="modal fade" id="showImageModal" tabindex="-1" role="dialog" aria-labelledby="imageModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">图片显示</h4>
                </div>
                <div class="modal-body" style="text-align: center">
                    <img id="imgPhoto" src="" width="400px" height="400px"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="exportXuejiModal" tabindex="-1" role="dialog" aria-labelledby="exportXuejiModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">学籍导出对话框</h4>
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
                    <label style="margin-top: 20px;">2、请选择下载范围</label>
                    <div style="margin-left: 20px;margin-top:10px;">
                        <div class="form-inline">
                            <input type="radio" checked="checked" name="region" value="center" onclick="regionSelect('school')"/><label style="width: 50px;">校区</label>
                            <select  class="form-control" id="centers_d" style="min-width: 150px;">
                                <option value="-1">全部</option>
                                <c:forEach var="center" items="${requestScope.centers}" >
                                    <option value="${center.cid}">${center.cname}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-inline" style="margin-top: 20px;">
                            <input type="radio"  name="region" value="direction" onclick="regionSelect('direction')" /><label style="width: 50px;">方向:</label>
                            <select  class="form-control" id="directions_d" style="min-width: 150px;">
                                <%--<option value="-1">全部</option>--%>
                                <c:forEach var="direction" items="${requestScope.directions}" >
                                    <option value="${direction.did}">${direction.dname}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-inline" style="margin-top: 20px;">
                            <input type="radio"  name="region" value="classteacher" onclick="regionSelect('classteacher')"/><label style="width: 50px;">班主任:</label>
                            <select class="form-control" id="classteachers_d" style="min-width: 150px;" >
                                <c:forEach var="classteacher" items="${requestScope.classteachers}" begin="0" step="1" varStatus="i">
                                    <option value="${classteacher.ctid}" selected="selected">${classteacher.ctname}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <label style="margin-top: 20px;">3、请选择变更类型</label>
                    <div class="form-inline" style="margin-left: 20px;margin-top:20px;">
                        <label >变更类型:</label>
                        <select class="form-control" id="xueji_d"  >
                            <option value="-1">全部</option>
                            <c:forEach var="type" items="${requestScope.updateTypes}" >
                                <option value="${type}">${type}</option>
                            </c:forEach>
                        </select>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button"  class="btn btn-primary" onclick="exportXueji()">导出</button>
                </div>
            </div>
        </div>
    </div>

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
                    <h1 class="page-header">学籍管理</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#query" data-toggle="tab">学籍变更操作</a>
                            </li>
                            <li><a href="#summary" data-toggle="tab">学籍变更统计</a>
                            </li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="margin-top: 30px">
                            <div class="tab-pane fade in active" id="query">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">
                                            <div class="col-lg-9" style="background: #dddddd">
                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                    <tr>

                                                        <td style="text-align:right;">中心:</td>
                                                        <td>
                                                            <select  class="form-control" id="centers_search" style="min-width: 150px">
                                                                <option value="-1">全部</option>
                                                                <c:forEach var="center" items="${requestScope.centers}" >
                                                                    <option value="${center.cid}">${center.cname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td style="text-align:right;">班主任:</td>
                                                        <td>
                                                            <select class="form-control" id="classteachers_s" style="min-width: 150px">
                                                                <c:forEach var="classteacher" items="${requestScope.classteachers}" begin="0" step="1" varStatus="i">
                                                                    <c:choose>
                                                                        <c:when test="${i.index==0}">
                                                                            <option value="${classteacher.ctid}" selected="selected">${classteacher.ctname}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                        </td>

                                                        <td style="text-align:right;">开始:</td>
                                                        <td><input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="min-width: 150px"></td>

                                                    </tr>
                                                    <tr>
                                                        <td style="text-align:right;">结束:</td>
                                                        <td><input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="min-width: 150px"></td>
                                                        <td style="text-align:right;">班级:</td>
                                                        <td>
                                                            <select class="form-control" id="classcodes_s" style="min-width: 150px">
                                                                <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                                                    <option value="${classcode}">${classcode}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td ></td>
                                                        <td><button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px;">条件查询</button></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-lg-3" style="background: #eeeeee;">

                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none  >
                                                    <tr>

                                                        <td>
                                                            &emsp; &emsp; <input  id="name_search" class = "form-control" placeholder = "学员名字/学号" style="width: 150px;display: inline;">
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
                                    <div class="table-responsive" style="height: 500px">
                                        <table class="table table-striped table-bordered table-hover">
                                            <thead>
                                            <tr>
                                                <th>id</th>
                                                <th>操作</th>
                                                <th>时间</th>
                                                <th>姓名</th>
                                                <th>学号</th>
                                                <th>班级</th>
                                                <th>变更类型</th>
                                                <th>目标班级</th>
                                                <th>变更内容</th>
                                                <th>变更原因</th>
                                                <th>图片凭证</th>
                                                <th>结果</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tbody_xuejiinfos">
                                            </tbody>
                                        </table>

                                    </div>
                                    <!-- /.table-responsive -->
                                </div>
                                <!-- /.panel-body -->
                                </div>
                                <div class="row" >
                                    <div class="panel-body" style="background: #FFFFFF;margin-left: 15px;margin-right: 15px;">
                                        <a href="javascript:void(0)" onclick="showNewXuejiDlg()" style="margin-left: 30px;float: left">新增学籍变更信息<img src="/img/add3.png"/></a>
                                        <a href="javascript:void(0)" onclick="querydown()" style="margin-right: 30px;float: right">下载学籍变更信息<img src="/img/down.png" width="30px"/></a>
                                    </div>

                                </div>
                            </div>
                            <div class="tab-pane fade" id="summary" style="clear: both">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="panel panel-default">

                                            <div class="col-lg-9" style="background: #dddddd">
                                                <table  style="border-collapse:separate; border-spacing:30px 20px;"  rules=none >
                                                    <tr>

                                                        <td style="text-align:right;">中心:</td>
                                                        <td>
                                                            <select  class="form-control" id="centers_summary" style="min-width: 150px">
                                                                <option value="-1" selected="selected">全部</option>
                                                                <c:forEach var="center" items="${requestScope.centers}" begin="0" step="1" varStatus="i">
                                                                    <option value="${center.cid}">${center.cname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td style="text-align:right;">班主任:</td>
                                                        <td>
                                                            <select class="form-control" id="classteachers_summary" style="min-width: 150px">
                                                                <option value="-1" selected="selected">全部</option>
                                                                <c:forEach var="classteacher" items="${requestScope.classteachers}" begin="0" step="1" varStatus="i">
                                                                    <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>

                                                        <td style="text-align:right;">班级:</td>
                                                        <td>
                                                            <select class="form-control" id="classcodes_summary" style="min-width: 150px">
                                                                <option value="-1">全部</option>
                                                            </select>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td style="text-align:right;">开始时间:</td>
                                                        <td>
                                                            <input type="date" id="startTime_summary" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                                        </td>


                                                        <td style="text-align:right;">结束时间:</td>
                                                        <td><input type="date" id="endTime_summary" class = "form-control" placeholder = "结束时间" style="min-width: 150px"></td>

                                                        <td style="text-align:right;"></td>
                                                        <td><button type="button" class="btn btn-primary"  onclick="query_summary()" style="min-width: 150px">条件查询</button></td>
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
                                                            <input   class = "form-control" placeholder = "学员名" style="width: 150px;visibility:hidden;">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</td>
                                                        <td><button type="button"  class="btn btn-primary"  style="width: 150px;visibility:hidden;">模糊查询</button></td>
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
                                            <div style="width:2500px;height: 600px">
                                            <table class="table table-striped table-bordered table-hover text-nowrap">
                                                <thead>
                                                <tr>
                                                    <th colspan="5">班级基本信息</th>
                                                    <th colspan="3">增加人数(其他班级转入)</th>
                                                    <th colspan="7">减少人数(本班级转出或者休学)</th>
                                                    <th colspan="5">流失人数（全日制班级学习时间不足3个月；周末班级不足4.5个月的学员人数）</th>
                                                    <th colspan="13">数据统计</th>
                                                </tr>
                                                <tr>
                                                    <th width="50px">#</th>
                                                    <th width="150px">班级编号</th>
                                                    <th width="100px">课程方向</th>
                                                    <th width="100px">班主任</th>
                                                    <th width="100px">班级状态</th>

                                                    <th width="100px">休学复学</th>
                                                    <th width="100px">重修入班</th>
                                                    <th width="100px">转入本班</th>

                                                    <th width="100px">转去别班</th>
                                                    <th width="100px">重修离班</th>
                                                    <th width="120px">休学离班人数</th>

                                                    <th width="120px">自主择业人数</th>
                                                    <th width="100px">退费人数</th>
                                                    <th width="100px">失联人数</th>
                                                    <th width="100px">退学人数</th>

                                                    <th width="150px">未满三个月自主择业</th>
                                                    <th width="100px">退费人数</th>
                                                    <th width="100px">失联人数</th>
                                                    <th width="150px">未满三个月的休学不复学</th>
                                                    <th width="150px">未满三个月的退学人数</th>

                                                    <th width="100px">复学人数</th>
                                                    <th width="100px">结班人数</th>
                                                    <th width="100px">流失率</th>
                                                    <th width="100px">推迟就业</th>
                                                    <th width="120px">自主择业人数</th>
                                                    <th width="120px">进入就业人数</th>
                                                    <th width="200px">高中/中专等不符合包就业人数</th>
                                                    <th width="100px">已就业人数</th>

                                                    <th width="100px">就业率</th>
                                                    <th width="100px">认证合格人数</th>
                                                    <th width="100px">认证合格通过</th>
                                                    <th width="100px">备注</th>



                                                </tr>
                                                </thead>
                                                <tbody id="tbody_summary">

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
