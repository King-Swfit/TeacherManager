<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <style type="text/css">
        .table th, .table td {
            text-align: center;
            vertical-align: middle!important;
        }
    </style>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="/jquery/jquery-1.10.2.min.js"></script>

    <script type="text/javascript">
        var width = -1
        var  height = -1
        var topp = -1
        var leftt = -1

        var step_r = -1

        var rowedit = -1
        var paper = null

        var arr = new Array();
        var ais=new Array(
//                "学历","毕业年限","专业","就业能力",
//                "c基本语法和函数(自测分数)","数组和结构体(自测分数)","指针和链表(自测分数)","c项目",
//                "c高级(lsd)(自测分数)","c++语法和OO(c++质检)","qt(自测分数)","c++项目","毕业项目"

        "质检2\n(结构体和链表)","质检1\n(数组和指针)","c基本语法和\n函数(自测)",
                "就业\n能力", "专业","毕业年限","学历","毕业项目","c++项目",
                "qt(自测)","质检3\n(c++语法和OO)","c高级(lsd)\n(自测)","c项目"
        )

        var javas=new Array(
//                "学历","毕业年限","专业","就业能力",
//                "java基本语法\n(se质检1)","OO三大特征和接口\n(自测分数)","集合-数据结构和算法\n(自测分数)","javase项目",
//                "动态网页技术\n(ee质检1)","SSMH(ee质检2)","数据库mysql+oracle\n(自测分数)","javaee项目"


                "se质检2\n(集合+IO)","OO三大特征和接口\n(自测)","se质检1\n(java基本语法)","就业\n能力","专业","毕业年限","学历",
                "javaee项目","数据库mysql+oracle\n(自测)","ee质检2\n(SSMH)","ee质检1\n(动态网页技术)","javase项目"
        )

        var head_java = "<th width='50px'>#</th><th width='50px'>操作</th><th width='150px'>编号</th><th width='100px'>姓名</th><th width='100px'>班级</th><th width='100px'>学习方向</th><th width='100px'>分类</th>"+
                "<th width='50px'>学历</th><th width='100px'>毕业年限</th><th th width='50px'>专业</th><th th width='100px'>就业能力</th>"+
                "<th width='200px'>se质检1(java基础语法)</th><th th width='200px'>OO三大特征和接口(自测)</th><th th width='200px'>se质检2(集合+IO)</th>"+
                "<th width='150px'>javase项目</th><th width='200px'>ee质检1(动态网页技术)</th><th width='100px'>ee质检2(ssmh)</th><th th width='200px'>数据库mysql+oracle(自测)</th>"+
                "<th width='100px'>javaee项目</th><th width='100px'>结业考试</th><th width='200px'>公司</th><th width='100px'>待遇</th>"

        var head_w  = "<th width='50px'>#</th><th width='50px'>操作</th><th width='150px'>编号</th><th width='100px'>姓名</th><th width='100px'>班级</th><th width='100px'>学习方向</th><th width='100px'>分类</th>"+
                "<th width='50px'>学历</th><th width='100px'>毕业年限</th><th th width='50px'>专业</th><th th width='100px'>就业能力</th>"+
                "<th width='200px'>c语法和函数(自测)</th><th width='200px'>质检1(数组和结构体)</th><th th width='200px'>质检2(结构体和链表)</th>"+
                "<th width='150px'>c项目</th><th width='200px'>c高级lsd(自测)</th><th width='100px'>质检3(c++和oo)</th><th width='200px'>qt(自测)</th>"+
                "<th width='100px'>c++项目</th><th width='100px'>毕业项目</th><th width='100px'>结业考试</th><th width='200px'>公司</th><th width='100px'>待遇</th>"



        $(function() {
            var now = new Date();
            //格式化日，如果小于9，前面补0
            var day = ("0" + now.getDate()).slice(-2);
            //格式化月，如果小于9，前面补0
            var month = ("0" + (now.getMonth() + 1)).slice(-2);
            //拼装完整日期格式
            var today = now.getFullYear() + "-" + (month) + "-" + (day);
            var startTime = (now.getFullYear() - 1) + "-" + (month) + "-" + (day);
            startTime="2000-01-01"
            //完成赋值
            $('#startTime_search').val(startTime);
            $('#endTime_search').val(today);

            $('#startTime_d').val((now.getFullYear() - 1) + "-" + (month) + "-" + (day));
            $('#endTime_d').val(today);
            $("#teachers_d").attr("disabled","disabled");
            $("#classteachers_d").attr("disabled","disabled");




            $("#centers_search").change(function(){
                var centerId=$("#centers_search").val()
                $.post(
                        "/class/classteachersInCenter",
                        {"centerId":centerId},
                        function (data) {
                            if(data != null){
                                $("#classteachers_search").html("");
                                var length = data.length
                                var str =""
                                for(var i = 0; i < length; i++){
                                    var classTeacher = data[i]
                                    str = str + "<option value='" + classTeacher.ctid + "'>" + classTeacher.ctname + "</option>"
                                }
                                $("#classteachers_search").append(str)

                                showClassTeacherChange()
                            }
                        }
                );
            })

            $("#classteachers_search").change(function(){
                showClassTeacherChange()
            })

            $("#classcodes_search").change(function(){
                var classcode = $("#classcodes_search").val()
                $.post(
                        "/class/getDirectionNameByClassCode",
                        {"classcode":classcode},
                        function (dname) {
                            if(dname.search("java") != -1){
                                $('#theadtr').empty()
                                $('#theadtr').append(head_java)
                                $('#divj').css("display","block")
                                $('#divw').css("display","none")

                                drawBk(12, javas)
                            }else{
                                $('#theadtr').empty()
                                $('#theadtr').append(head_w)
                                $('#divj').css("display","none")
                                $('#divw').css("display","block")

                                drawBk(13, ais)
                            }
                            query()

                        }
                );

            })

        })






        function showClassTeacherChange(){
            var startTime = $('#startTime_search').val();
            var endTime = $('#endTime_search').val();
            var ctid=$("#classteachers_search").val();
            if(ctid > 0){
                $.post(
                        "/class/getClassCodesByClidTime",
                        {"ctid":ctid, "startTime":startTime,"endTime":endTime},
                        function (classcodes) {
                            $("#classcodes_search").empty()
                            if(classcodes != null){
                                var str = ""
                                var length = classcodes.length
                                for(var i = 0; i < length; i++){
                                    str = str + "<option value='" + classcodes[i] + "'>" + classcodes[i] + "</option>"
                                }
                                $("#classcodes_search").append(str)

                                $.post(
                                        "/class/getDirectionNameByClassCode",
                                        {"classcode":classcodes[0]},
                                        function (dname) {
                                            if(dname.search("java") != -1){
                                                $('#theadtr').empty()
                                                $('#theadtr').append(head_java)
                                                $('#divj').css("display","block")
                                                $('#divw').css("display","none")

                                                drawBk(12, javas)
                                            }else{
                                                $('#theadtr').empty()
                                                $('#theadtr').append(head_w)
                                                $('#divj').css("display","none")
                                                $('#divw').css("display","block")

                                                drawBk(13, ais)
                                            }

                                            query()

                                        }
                                );


                            }

                        }
                );
            }





        }


        function query() {
            var classcode = $('#classcodes_search').val();
            $.post(
                    "/class/getDirectionNameByClassCode",
                    {"classcode":classcode},
                    function (dname) {

                        $("#ddlregtype").find("option:selected").text();
                        if(classcode != null || dname != null){
                            $.post(
                                    "/class/getComprehensiveScore20191106",
                                    {"classcode":classcode},
                                    function (comprehensiveScores) {
                                        showComprehensiveScores(comprehensiveScores)
                                    }
                            );
                        }else {
                            alert("请选择正确的班级编号和学习方向")
                        }

                    }

            );

        }


        function showComprehensiveScores(comprehensiveScores) {
            $('#tbody_comprehensiveScores').empty()
            if(comprehensiveScores != null && comprehensiveScores.length > 0){
                if(comprehensiveScores[0].dname.search("java") != -1){
                    $('#theadtr').empty()
                    $('#theadtr').append(head_java)


                    var comprehensiveScore_javas = comprehensiveScores
                    var length = comprehensiveScore_javas.length
                    for(var i = 0; i < length;i++){
                        var comprehensiveScore_java = comprehensiveScore_javas[i]
                        var k = i+1
                        var str2 = "<tr>"
                        str2 = str2 + "<td>"+ k +"</td>"
                        str2 = str2 + "<td><a href='javascript:void(0)' onclick='edit(" + i + ")'>编辑</a>"+"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.code +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.name +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.classcode +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.dname +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.type +"</td>"

                        str2 = str2 + "<td>"+ comprehensiveScore_java.diploma +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.graduateTime +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.prefession +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.enery_employ +"</td>"

                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[0] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[1] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[2] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[3] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[4] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[5] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[6] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[7] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.tests[8] +"</td>"


                        str2 = str2 + "<td>"+ comprehensiveScore_java.corporation +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_java.salary +"</td>"

                        str2 = str2 + "</tr>"
                        $('#tbody_comprehensiveScores').append(str2)
                    }


                    drawBk(12,javas)

                }else{
                    $('#theadtr').empty()
                    $('#theadtr').append(head_w)

                    $('#tbody_comprehensiveScores').empty()
                    var comprehensiveScore_ais = comprehensiveScores
                    var length = comprehensiveScore_ais.length
                    for(var i = 0; i < length;i++){
                        var comprehensiveScore_ai = comprehensiveScore_ais[i]
                        var k = i+1
                        var str2 = "<tr>"
                        str2 = str2 + "<td>"+ k +"</td>"
                        str2 = str2 + "<td><a href='javascript:void(0)' onclick='edit(" + i + ")'>编辑</a>"+"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.code +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.name +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.classcode +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.dname +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.type +"</td>"

                        str2 = str2 + "<td>"+ comprehensiveScore_ai.diploma +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.graduateTime +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.prefession +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.enery_employ +"</td>"

                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[0] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[1] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[2] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[3] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[4] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[5] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[6] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[7] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[8] +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.tests[9] +"</td>"

                        str2 = str2 + "<td>"+ comprehensiveScore_ai.corporation +"</td>"
                        str2 = str2 + "<td>"+ comprehensiveScore_ai.salary +"</td>"


                        str2 = str2 + "</tr>"
                        $('#tbody_comprehensiveScores').append(str2)
                    }


                    drawBk(13,ais)
                }

            }
        }

        function selectTrainee() {
            var info = $("#userinfo").find("option:selected").text();
            if(info != null && info.length > 0)
                $("#showTraineeModal").modal("hide")
            var arr = info.split("-");
            $.post(
                    "/class/getComprehensiveScoreByCode20191106",
                    {"code":arr[0],"dname":arr[2]},
                    function (comprehensiveScores) {
                        showComprehensiveScores(comprehensiveScores)
                    }
            )

        }

        function mohuquery() {
            var name = $('#name_search').val()
            if(name == null && name.length == 0){
                alert("请输入要查询的用户名!")
                return
            }

            $.post(
                    "/class/mohuQueryByName",
                    {"name":name},
                    function (trainees) {
                        $("#userinfo").empty()
                        if(trainees != null){
                            var length = trainees.length
                            var str = ""
                            for(var i = 0; i < length; i++){
                                //加载用户信息
                                var info = trainees[i].code + "-" + trainees[i].name + "-" + trainees[i].dname + "-" + trainees[i].classcode + "-" + trainees[i].graduateSchool
                                str = str + "<option value='" + trainees[i].code + "'>" + info + "</option>"

                            }
                            $("#userinfo").append(str)
                            $("#showTraineeModal").modal()
                        }
                    }
            );
        }

        function drawBk(num, datas) {
            width = $("#graph_container").width()
            height = $("#graph_container").height()
            topp = $("#graph_container").offset().top
            leftt = $("#graph_container").offset().left


            arr.length = 0;

            if(null == paper){
                paper = Raphael(leftt+20, topp , width - 40, height );

            }
            paper.clear()

            var r = height/2-30
            step_r = r/9;
            var i = 0
            for(var cur_r = step_r; cur_r <= r; cur_r = cur_r + step_r){
                arr[i] = getPointsInCircle(cur_r, width/2, height/2, num)
                i=i+1
            }

            for(var j = 0; j < arr.length; j++){
                var arr_circle = arr[j]
                var s = ""
                for(var k = 0; k < arr_circle.length; k++){
                    if(k == 0){
                        s = s+"M" + arr_circle[k].x+","+arr_circle[k].y
                    }else{
                        s = s+"L" + arr_circle[k].x+","+arr_circle[k].y
                    }
                }
                s=s+"z"
                paper.path(s).attr({
                    "stroke":"#AAAAAA", // the color of the border
                    "stroke-width":1 // the size of the border
                });
                paper.text(width/2, height/2 - j*step_r, j+"").attr('fill', 'gray');
            }

            paper.text(width/2, height/2 - arr.length*step_r, j+"").attr('fill', 'gray');

            var arr_circle_outer = arr[arr.length - 1]
            if(arr_circle_outer.length == 12){
                paper.text(arr_circle_outer[0].x, arr_circle_outer[0].y + 12, datas[0]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[1].x + 40, arr_circle_outer[1].y + 8, datas[1]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[2].x + 20, arr_circle_outer[2].y + 4, datas[2]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[3].x +10, arr_circle_outer[3].y, datas[3]).attr({'fill': 'gray',});

                paper.text(arr_circle_outer[4].x + 20, arr_circle_outer[4].y - 4, datas[4]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[5].x + 20, arr_circle_outer[5].y - 8, datas[5]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[6].x, arr_circle_outer[6].y -12, datas[6]).attr({'fill': 'gray'});

                paper.text(arr_circle_outer[7].x - 20, arr_circle_outer[7].y - 8, datas[7]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[8].x-40, arr_circle_outer[8].y - 4, datas[8]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[9].x - 40, arr_circle_outer[9].y, datas[9]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[10].x - 40, arr_circle_outer[10].y + 4, datas[10]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[11].x - 20, arr_circle_outer[11].y + 8, datas[11]).attr({'fill': 'gray'});

                drawGraph_javaee_passline();
                drawGraph_javaee_excellentline();

            }else if(arr_circle_outer.length == 13){
                paper.text(arr_circle_outer[0].x, arr_circle_outer[0].y + 12, datas[0]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[1].x + 40, arr_circle_outer[1].y + 8, datas[1]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[2].x + 20, arr_circle_outer[2].y + 4, datas[2]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[3].x +10, arr_circle_outer[3].y, datas[3]).attr({'fill': 'gray',});
                paper.text(arr_circle_outer[4].x + 20, arr_circle_outer[4].y - 4, datas[4]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[5].x + 20, arr_circle_outer[5].y - 8, datas[5]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[6].x, arr_circle_outer[6].y -12, datas[6]).attr({'fill': 'gray'});

                paper.text(arr_circle_outer[7].x - 20, arr_circle_outer[7].y - 8, datas[7]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[8].x-40, arr_circle_outer[8].y - 4, datas[8]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[9].x - 40, arr_circle_outer[9].y, datas[9]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[10].x - 30, arr_circle_outer[10].y + 4, datas[10]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[11].x - 20, arr_circle_outer[11].y + 8, datas[11]).attr({'fill': 'gray'});
                paper.text(arr_circle_outer[12].x , arr_circle_outer[12].y + 12, datas[12]).attr({'fill': 'gray'});

                drawGraph_ai_passline();
                drawGraph_ai_excellentline();
            }


            paper.rect(20,20,50,2).attr("fill","blue").attr("stroke","none")
            paper.text(85, 20, "优秀").attr('fill', 'gray');
            paper.rect(20,35,50,2).attr("fill","red").attr("stroke","none");
            paper.text(85, 35, "及格").attr('fill', 'gray');
            paper.rect(20,50,50,2).attr("fill","#006400").attr("stroke","none");
            paper.text(85, 50, "当前值").attr('fill', 'gray');


        }

        function getPointsInCircle(r, ox, oy, count){
            var arr_circle = new Array()
            var radians = (Math.PI / 180) * Math.round(360 / count), i = 0;
            for(; i < count; i++){
                var x = ox + r * Math.sin(radians * i), y = oy + r * Math.cos(radians * i);
                x = parseInt(x)
                y = parseInt(y)
                arr_circle[i] = {"x":x,"y":y} //为保持数据顺时针
            }
            return arr_circle
        }

        function drawGraph_javaee_passline(){
            var diploma = 7
            var graduateTime = 6
            var profession = 7
            var employ = 5

            var java_basegrammer = 7
            var java_oo = 6
            var java_datastruct = 6
            var se_pro = 6
            var webpage = 6
            var ssmh = 6
            var dbs = 7
            var eepro = 6

            var s = "M"+arr[java_datastruct - 1][0].x +","+ arr[java_datastruct - 1][0].y
            s = s+"L"+arr[java_oo - 1][1].x +","+ arr[java_oo - 1][1].y
            s = s+"L"+arr[java_basegrammer - 1][2].x +","+ arr[java_basegrammer - 1][2].y
            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y

            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y
            s = s+"L"+arr[eepro - 1][7].x +","+ arr[eepro - 1][7].y

            s = s+"L"+arr[dbs - 1][8].x +","+ arr[dbs - 1][8].y
            s = s+"L"+arr[ssmh - 1][9].x +","+ arr[ssmh - 1][9].y
            s = s+"L"+arr[webpage - 1][10].x +","+ arr[webpage - 1][10].y
            s = s+"L"+arr[se_pro - 1][11].x +","+ arr[se_pro - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"red", // the color of the border
                "stroke-width":2 // the size of the border
            });
        }
        function drawGraph_ai_passline(){
            var diploma = 7
            var graduateTime = 6
            var profession = 7
            var employ = 5

            var c_grammer = 7
            var c_arrstruct = 7
            var c_pointer = 6
            var c_pro = 6
            var c_lsd = 5
            var cplus_oo = 6
            var qt = 6
            var cplusplus_pro = 6
            var pro = 6

            var s = "M"+arr[c_pro - 1][12].x +","+ arr[c_pro - 1][12].y
            s = s+"L"+arr[c_pointer - 1][0].x +","+ arr[c_pointer - 1][0].y
            s = s+"L"+arr[c_arrstruct - 1][1].x +","+ arr[c_arrstruct - 1][1].y
            s = s+"L"+arr[c_grammer - 1][2].x +","+ arr[c_grammer - 1][2].y

            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y
            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y

            s = s+"L"+arr[pro - 1][7].x +","+ arr[pro - 1][7].y
            s = s+"L"+arr[cplusplus_pro - 1][8].x +","+ arr[cplusplus_pro - 1][8].y
            s = s+"L"+arr[qt - 1][9].x +","+ arr[qt - 1][9].y
            s = s+"L"+arr[cplus_oo - 1][10].x +","+ arr[cplus_oo - 1][10].y
            s = s+"L"+arr[c_lsd - 1][11].x +","+ arr[c_lsd - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"red", // the color of the border
                "stroke-width":2 // the size of the border
            });
        }

        function drawGraph_javaee_excellentline(){
            var diploma = 8
            var graduateTime = 8
            var profession = 8
            var employ = 8

            var java_basegrammer = 9
            var java_oo = 8
            var java_datastruct = 8
            var se_pro = 8
            var webpage = 8
            var ssmh = 8
            var dbs = 9
            var eepro = 8

            var s = "M"+arr[java_datastruct - 1][0].x +","+ arr[java_datastruct - 1][0].y
            s = s+"L"+arr[java_oo - 1][1].x +","+ arr[java_oo - 1][1].y
            s = s+"L"+arr[java_basegrammer - 1][2].x +","+ arr[java_basegrammer - 1][2].y
            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y

            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y
            s = s+"L"+arr[eepro - 1][7].x +","+ arr[eepro - 1][7].y

            s = s+"L"+arr[dbs - 1][8].x +","+ arr[dbs - 1][8].y
            s = s+"L"+arr[ssmh - 1][9].x +","+ arr[ssmh - 1][9].y
            s = s+"L"+arr[webpage - 1][10].x +","+ arr[webpage - 1][10].y
            s = s+"L"+arr[se_pro - 1][11].x +","+ arr[se_pro - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"blue", // the color of the border
                "stroke-width":2 // the size of the border
            });
        }
        function drawGraph_ai_excellentline(){
            var diploma = 8
            var graduateTime = 8
            var profession = 8
            var employ = 8

            var c_grammer = 9
            var c_arrstruct = 9
            var c_pointer = 8
            var c_pro = 8
            var c_lsd = 7
            var cplus_oo = 8
            var qt = 8
            var cplusplus_pro = 8
            var pro = 8


            var s = "M"+arr[c_pro - 1][12].x +","+ arr[c_pro - 1][12].y
            s = s+"L"+arr[c_pointer - 1][0].x +","+ arr[c_pointer - 1][0].y
            s = s+"L"+arr[c_arrstruct - 1][1].x +","+ arr[c_arrstruct - 1][1].y
            s = s+"L"+arr[c_grammer - 1][2].x +","+ arr[c_grammer - 1][2].y

            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y
            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y

            s = s+"L"+arr[pro - 1][7].x +","+ arr[pro - 1][7].y
            s = s+"L"+arr[cplusplus_pro - 1][8].x +","+ arr[cplusplus_pro - 1][8].y
            s = s+"L"+arr[qt - 1][9].x +","+ arr[qt - 1][9].y
            s = s+"L"+arr[cplus_oo - 1][10].x +","+ arr[cplus_oo - 1][10].y
            s = s+"L"+arr[c_lsd - 1][11].x +","+ arr[c_lsd - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"blue", // the color of the border
                "stroke-width":2 // the size of the border
            });
        }

        function drawGraph_javaee(data){
            var diploma = data.diploma
            var graduateTime = data.graduateTime
            var profession = data.profession
            var employ = data.employ

            diploma = deal(diploma)
            graduateTime = deal(graduateTime)
            profession = deal(profession)
            employ = deal(employ)

            var java_basegrammer = data.java_basegrammer
            var java_oo = data.java_oo
            var java_datastruct = data.java_datastruct
            var se_pro = data.se_pro
            var webpage = data.webpage
            var ssmh = data.ssmh
            var dbs = data.dbs
            var eepro = data.eepro

            java_basegrammer = deal(java_basegrammer)
            java_oo = deal(java_oo)
            java_datastruct = deal(java_datastruct)
            se_pro = deal(se_pro)
            webpage = deal(webpage)
            ssmh = deal(ssmh)
            dbs = deal(dbs)
            eepro = deal(eepro)

            var s = "M"+arr[java_datastruct - 1][0].x +","+ arr[java_datastruct - 1][0].y
            s = s+"L"+arr[java_oo - 1][1].x +","+ arr[java_oo - 1][1].y
            s = s+"L"+arr[java_basegrammer - 1][2].x +","+ arr[java_basegrammer - 1][2].y
            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y

            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y
            s = s+"L"+arr[eepro - 1][7].x +","+ arr[eepro - 1][7].y

            s = s+"L"+arr[dbs - 1][8].x +","+ arr[dbs - 1][8].y
            s = s+"L"+arr[ssmh - 1][9].x +","+ arr[ssmh - 1][9].y
            s = s+"L"+arr[webpage - 1][10].x +","+ arr[webpage - 1][10].y
            s = s+"L"+arr[se_pro - 1][11].x +","+ arr[se_pro - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"#006400", // the color of the border
                "stroke-width":2 // the size of the border
            });


        }

        function drawGraph_ai(data){
            var diploma = data.diploma
            var graduateTime = data.graduateTime
            var profession = data.profession
            var employ = data.employ

            diploma = deal(diploma)
            graduateTime = deal(graduateTime)
            profession = deal(profession)
            employ = deal(employ)

            var c_grammer = data.c_grammer
            if(null == c_grammer){
                c_grammer = data.c_grammer_test
            }
            var c_arrstruct = data.c_arrstruct
            var c_pointer = data.c_pointer
            var c_pro = data.c_pro
            var c_lsd = data.c_lsd
            var cplus_oo = data.cplus_oo
            var qt = data.qt
            var cplusplus_pro = data.cplusplus_pro
            var pro = data.pro

            c_grammer = deal(c_grammer)
            c_arrstruct = deal(c_arrstruct)
            c_pointer = deal(c_pointer)
            c_pro = deal(c_pro)
            c_lsd = deal(c_lsd)
            cplus_oo = deal(cplus_oo)
            qt = deal(qt)
            cplusplus_pro = deal(cplusplus_pro)
            pro = deal(pro)

            var s = "M"+arr[c_pro - 1][12].x +","+ arr[c_pro - 1][12].y
            s = s+"L"+arr[c_pointer - 1][0].x +","+ arr[c_pointer - 1][0].y
            s = s+"L"+arr[c_arrstruct - 1][1].x +","+ arr[c_arrstruct - 1][1].y
            s = s+"L"+arr[c_grammer - 1][2].x +","+ arr[c_grammer - 1][2].y

            s = s+"L"+arr[employ - 1][3].x +","+ arr[employ - 1][3].y
            s = s+"L"+arr[profession - 1][4].x +","+ arr[profession - 1][4].y
            s = s+"L"+arr[graduateTime - 1][5].x +","+ arr[graduateTime - 1][5].y
            s = s+"L"+arr[diploma - 1][6].x +","+ arr[diploma - 1][6].y

            s = s+"L"+arr[pro - 1][7].x +","+ arr[pro - 1][7].y
            s = s+"L"+arr[cplusplus_pro - 1][8].x +","+ arr[cplusplus_pro - 1][8].y
            s = s+"L"+arr[qt - 1][9].x +","+ arr[qt - 1][9].y
            s = s+"L"+arr[cplus_oo - 1][10].x +","+ arr[cplus_oo - 1][10].y
            s = s+"L"+arr[c_lsd - 1][11].x +","+ arr[c_lsd - 1][11].y

            s = s+"z"
            paper.path(s).attr({
                "stroke":"#006400", // the color of the border
                "stroke-width":2 // the size of the border
            });

        }

        function deal(iv){
            if(iv > 9){
                iv = 9;
            }else if(iv < 1){
                iv = 1;
            }

            return iv
        }

        function edit(rowIndex) {
            rowedit = rowIndex
            var rows = $("#tbody_comprehensiveScores").find("tr")
            var tdArrs = rows.eq(rowIndex).find("td");

            var code = tdArrs.eq(2).text()
            var trname = tdArrs.eq(3).text()
            var dname = tdArrs.eq(5).text()
            var type = tdArrs.eq(6).text()
            $("#labcode").html(code)
            $("#labname").html(trname)
            $("#labtype").html(type)

            var diploma = tdArrs.eq(7).text()
            var graduateTime = tdArrs.eq(8).text()
            var profession = tdArrs.eq(9).text()
            var employ = tdArrs.eq(10).text()

            if(dname.search("java") != -1){
                $('#divj').css("display","block")
                $('#divw').css("display","none")

                $("#diploma_java").val(diploma)
                $("#graduateTime_java").val(graduateTime)
                $("#profession_java").val(profession)
                $("#employ_java").val(employ)



                var java_basegrammer = tdArrs.eq(11).text()
                var java_oo = tdArrs.eq(12).text()
                var java_datastruct = tdArrs.eq(13).text()
                var se_pro = tdArrs.eq(14).text()
                var webpage = tdArrs.eq(15).text()
                var ssmh = tdArrs.eq(16).text()
                var dbs = tdArrs.eq(17).text()
                var eepro = tdArrs.eq(18).text()
                var examScore = tdArrs.eq(19).text()

                if(java_basegrammer == null){
                    java_basegrammer = 0
                }
                if(java_oo == "null"){
                    java_oo = 0
                }
                if(java_datastruct == "null"){
                    java_datastruct = 0
                }
                if(se_pro == "null"){
                    se_pro = 0
                }
                if(webpage == "null"){
                    webpage = 0
                }
                if(ssmh == "null"){
                    ssmh = 0
                }
                if(dbs == "null"){
                    dbs = 0
                }
                if(eepro == "null"){
                    eepro = 0
                }
                if(examScore == "null"){
                    examScore = 0
                }


                $("#java_basegrammar_java").html(java_basegrammer)
                $("#java_oo_java").html(java_oo)
                $("#java_dastruct_java").html(java_datastruct)
                $("#java_sepro_java").html(se_pro)
                $("#java_webpage_java").html(webpage)
                $("#java_ssmh_java").html(ssmh)
                $("#java_dbs_java").html(dbs)
                $("#java_eepro_java").html(eepro)
                $("#examScore_java").html(examScore)

                var corporation = tdArrs.eq(20).text()
                var salary = tdArrs.eq(21).text()
                $("#corporation_java").html(corporation)
                $("#salary_java").html(salary)


                var updateData = {
                    "diploma":diploma,"graduateTime":graduateTime,"profession":profession,"employ":employ,
                    "java_basegrammer":java_basegrammer,"java_oo":java_oo,"java_datastruct":java_datastruct,"se_pro":se_pro,
                    "webpage":webpage,"ssmh":ssmh,"dbs":dbs,"eepro":eepro

                }

                drawBk(12,javas)
                drawGraph_javaee(updateData)


            }else {
                $('#divj').css("display","none")
                $('#divw').css("display","block")

                $("#diploma_w").val(diploma)
                $("#graduateTime_w").val(graduateTime)
                $("#profession_w").val(profession)
                $("#employ_w").val(employ)


                var c_grammer = tdArrs.eq(11).text()
                var c_arrstruct = tdArrs.eq(12).text()
                var c_pointer = tdArrs.eq(13).text()
                var c_pro = tdArrs.eq(14).text()
                var c_lsd = tdArrs.eq(15).text()
                var cplus_oo = tdArrs.eq(16).text()
                var qt = tdArrs.eq(17).text()
                var cplusplus_pro = tdArrs.eq(18).text()

                if(c_grammer == "null"){
                    c_grammer = 0
                }
                if(c_arrstruct == "null"){
                    c_arrstruct = 0
                }
                if(c_pointer == "null"){
                    c_pointer = 0
                }
                if(c_pro == "null"){
                    c_pro = 0
                }
                if(c_lsd == "null"){
                    c_lsd = 0
                }
                if(cplus_oo == "null"){
                    cplus_oo = 0
                }
                if(qt == "null"){
                    qt = 0
                }
                if(qt == "null"){
                    qt = 0
                }
                if(cplusplus_pro == "null"){
                    cplusplus_pro = 0
                }

                $("#cfun_w").html(c_grammer)
                $("#arrstruct_w").html(c_arrstruct)
                $("#pt_w").html(c_pointer)
                $("#cpro_w").html(c_pro)
                $("#lsd_w").html(c_lsd)
                $("#cplusoo_w").html(cplus_oo)
                $("#qt_w").html(qt)
                $("#cpluspro_w").html(cplusplus_pro)

                var pro = tdArrs.eq(19).text()
                var examScore = tdArrs.eq(20).text()

                var corporation = tdArrs.eq(21).text()
                var salary = tdArrs.eq(22).text()
                if(pro == "null"){
                    pro = 0
                }
                if(examScore == "null"){
                    examScore = 0
                }
                $("#pro_w").html(pro)
                $("#examScore_w").html(examScore)
                $("#corporation_w").html(corporation)
                $("#salary_w").html(salary)

                var updateData = {
                    "diploma":diploma,"graduateTime":graduateTime,"profession":profession,"employ":employ,
                    "c_grammer":c_grammer,"c_arrstruct":c_arrstruct,"c_pointer":c_pointer,"c_pro":c_pro,
                    "c_lsd":c_lsd,"cplus_oo":cplus_oo,"qt":qt,"cplusplus_pro":cplusplus_pro,
                    "pro":pro

                }


                drawBk(13,ais)
                drawGraph_ai(updateData)
            }

            $.post(
                    "/class/getTraineeBaseInfoByCode",
                    {"code":code},
                    function (baseinfoForTrainee) {
                        if(baseinfoForTrainee != null){
                            $("#ldiploma").text(baseinfoForTrainee.diploma)
                            $("#lprofession").text(baseinfoForTrainee.profession)
                            $("#lschool").text(baseinfoForTrainee.graduateSchool)
                            $("#lgraduTime").text(baseinfoForTrainee.graducateTime)

                        }else{
                            alert("学员信息为空")
                        }
                    }
            );


        }

        function saveUpdate_java() {

            var rows = $("#tbody_comprehensiveScores").find("tr")
            var tdArrs = rows.eq(rowedit).find("td");
            var code = tdArrs.eq(2).text()

            var type = $("#labtype").text()

            var diploma = $("#diploma_java").val()
            var graduateTime = $("#graduateTime_java").val()
            var profession = $("#profession_java").val()
            var employ = $("#employ_java").val()


            tdArrs.eq(7).text(diploma)
            tdArrs.eq(8).text(graduateTime)
            tdArrs.eq(9).text(profession)
            tdArrs.eq(10).text(employ)
            tdArrs.eq(18).text(dbs)

            var java_basegrammer = $("#java_basegrammar_java").text()
            var java_oo = $("#java_oo_java").text()
            var java_datastruct = $("#java_dastruct_java").text()
            var se_pro = $("#java_sepro_java").text()

            var webpage = $("#java_webpage_java").text()
            var ssmh = $("#java_ssmh_java").text()
            var dbs = $("#java_dbs_java").text()
            var eepro = $("#java_eepro_java").text()

            var corporation = $("#corporation_java").text()
            var salary = $("#salary_java").text()

            var updateData = {
                "diploma":diploma,"graduateTime":graduateTime,"profession":profession,"employ":employ,
                "java_basegrammer":java_basegrammer,"java_oo":java_oo,"java_datastruct":java_datastruct,"se_pro":se_pro,
                "webpage":webpage,"ssmh":ssmh,"dbs":dbs,"eepro":eepro

            }


            $.post(
                    "/class/updateComprehensiveBaseinfo",
                    {"code":code,"diploma":diploma,"graduateTime":graduateTime,"prefession":profession,"enery_employ":employ, "database_java":dbs,"type":type},
                    function (data) {
                        if(data=="success"){
                            drawBk(12,javas)
                            drawGraph_javaee(updateData)
                        }else{
                            alert("保存失败")
                        }

                    }
            )


        }

        function saveUpdate_w() {

            var rows = $("#tbody_comprehensiveScores").find("tr")
            var tdArrs = rows.eq(rowedit).find("td");
            var code = tdArrs.eq(2).text()

            var type = $("#labtype").text()

            var diploma = $("#diploma_w").val()
            var graduateTime = $("#graduateTime_w").val()
            var profession = $("#profession_w").val()
            var employ = $("#employ_w").val()

            tdArrs.eq(7).text(diploma)
            tdArrs.eq(8).text(graduateTime)
            tdArrs.eq(9).text(profession)
            tdArrs.eq(10).text(employ)

            var c_grammer = $("#cfun_w").text()
            var c_arrstruct = $("#arrstruct_w").text()
            var c_pointer = $("#pt_w").text()
            var c_pro = $("#cpro_w").text()

            var c_lsd = $("#lsd_w").text()
            var cplus_oo = $("#cplusoo_w").text()
            var qt = $("#qt_w").text()
            var cplusppro = $("#pluspro_w").text()
            var pro = $("#pro_w").text()

            var corporation = $("#corporation_w").text()
            var salary = $("#salary_w").text()

            //更新数据库
            var updateData = {
                "diploma":diploma,"graduateTime":graduateTime,"profession":profession,"employ":employ,
                "c_grammer":c_grammer,"c_arrstruct":c_arrstruct,"c_pointer":c_pointer,"c_pro":c_pro,
                "c_lsd":c_lsd,"cplus_oo":cplus_oo,"qt":qt,"cplusplus_pro":cplusppro,
                "pro":pro

            }



            //更新数据库
            $.post(
                    "/class/updateComprehensiveBaseinfo",
                    {"code":code,"diploma":diploma,"graduateTime":graduateTime,"prefession":profession,"enery_employ":employ,"type":type},
                    function (data) {
                        if(data=="success"){
                            drawBk(13,ais)
                            drawGraph_ai(updateData)
                        }else{
                            alert("保存失败")
                        }
                    }
            )

        }

        function regionSelect(region) {
            $("#classes_d").attr("disabled","disabled");
            $("#teachers_d").attr("disabled","disabled");
            $("#classteachers_d").attr("disabled","disabled");
            switch(region) {
                case "class":
                    $("#classes_d").removeAttr("disabled");
                    break;
                case "teacher":
                    $("#teachers_d").removeAttr("disabled");
                    break;
                case "classteacher":
                    $("#classteachers_d").removeAttr("disabled");
                    break;
            }
        }

        function downloadScoreDlg() {
            $("#exportComprehensiveScoreModal").modal()
        }

        function exportComprehensiveScore() {
            region = $("input[name='region']:checked").val();
            var way = -1
            var value= -1
            switch(region) {
                case "class":
                    value=$("#classes_d").val();
                    way=0
                    break;
                case "teacher":
                    value=$("#teachers_d").val()
                    way=1
                    break;
                case "classteacher":
                    value=$("#classteachers_d").val()
                    way=2
                    break;
            }

            var startTime= $("#startTime_d").val()
            var endTime= $("#endTime_d").val()


            window.location.href="/jiaowu/exportScores?way="+way+"&value=" + value + "&startTime="+startTime + "&endTime=" + endTime;



        }

        function onRefreshDate() {
            var startTime = $("#startTime_d").val()
            var endTime = $("#endTime_d").val()

            $.post(
                    "/jiaowu/getTeachersClassteachersClasscodesForTime",
                    {"startTime":startTime,"endTime":endTime},
                    function (data) {
                        if(data  != null){
                            var classteachers = data.classteachers_recent
                            var teachers = data.teachers_recent
                            var classcodes = data.classcodes

                            $("#classcodes_d").empty()
                            var str = ""
                            if(classcodes != null){
                                for(var i = 0; i < classcodes.length; i++){
                                    str = "<option value='" + classcodes[i] +  "'>"+classcodes[i] + "</option>"
                                }
                            }
                            $("#classcodes_d").append(str)


                            $("#teachers_d").empty()
                            str = ""
                            if(teachers != null){
                                for(var i = 0; i < teachers.length; i++){
                                    str = "<option value='" + teachers[i].tid +  "'>"+teachers[i].tname + "</option>"
                                }
                            }
                            $("#teachers_d").append(str)


                            $("#classteachers_d").empty()
                            str = ""
                            if(classteachers != null){
                                for(var i = 0; i < classteachers.length; i++){
                                    str = "<option value='" + classteachers[i].ctid +  "'>"+classteachers[i].ctname + "</option>"
                                }
                            }
                            $("#classteachers_d").append(str)



                        }else{
                            alert("刷新失败!")
                        }
                    }
            )


        }

    </script>

</head>

<body>

<div class="modal fade" id="showTraineeModal" tabindex="-1" role="dialog" aria-labelledby="showTraineeModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">请从下面用户中选择您要查看的用户</h4>
            </div>
            <div class="modal-body" style="text-align: center">
                用户信息：
                <select id="userinfo" class="form-control" style="display: inline">
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="selectTrainee()">去查询</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="exportComprehensiveScoreModal" tabindex="-1" role="dialog" aria-labelledby="exportComprehensiveScoreModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">综合成绩导出对话框</h4>
            </div>
            <div class="modal-body" >

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
                        <input type="radio" checked="checked" name="region" value="class" onclick="regionSelect('class')"/><label style="width: 50px;">班级</label>
                        <select  class="form-control" id="classes_d" style="min-width: 150px;">
                            <c:forEach var="classcode" items="${requestScope.classcodes_recent}" >
                                <option value="${classcode}">${classcode}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="teacher" onclick="regionSelect('teacher')" /><label style="width: 50px;">老师:</label>
                        <select  class="form-control" id="teachers_d" style="min-width: 150px;">
                            <c:forEach var="teacher" items="${requestScope.teachers_recent}" >
                                <option value="${teacher.tid}">${teacher.tname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-inline" style="margin-top: 20px;">
                        <input type="radio"  name="region" value="classteacher" onclick="regionSelect('classteacher')"/><label style="width: 50px;">班主任:</label>
                        <select class="form-control" id="classteachers_d" style="min-width: 150px;" >
                            <c:forEach var="classteacher" items="${requestScope.classteachers_recent}" begin="0" step="1" varStatus="i">
                                <option value="${classteacher.ctid}" selected="selected">${classteacher.ctname}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button"  class="btn btn-primary" onclick="exportComprehensiveScore()">导出</button>
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
                <h1 class="page-header">毕业生综合成绩</h1>
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
                                        <c:forEach var="classteacher" items="${requestScope.classteachers}" >
                                            <option value="${classteacher.ctid}">${classteacher.ctname}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td style="text-align:right;">开始:</td>
                                <td>
                                    <input type="date" id="startTime_search" class = "form-control" placeholder = "开始时间" style="min-width: 150px">
                                </td>


                            </tr>
                            <tr>

                                <td style="text-align:right;">结束:</td>
                                <td>
                                    <input type="date" id="endTime_search" class = "form-control" placeholder = "结束时间" style="min-width: 150px;">
                                </td>

                                <td style="text-align:right;">班级:</td>
                                <td>
                                    <select class="form-control" id="classcodes_search" style="min-width: 150px">
                                        <c:forEach var="classcode" items="${requestScope.classcodes}" >
                                            <option value="${classcode}">${classcode}</option>
                                        </c:forEach>
                                    </select>
                                </td>


                                <td ></td>
                                <td><button type="button" class="btn btn-primary" onclick="query()" style="min-width: 150px" >条件查询</button></td>
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

        <div class="row">
            <div class="panel-body">
                <div class="table-responsive">
                    <div style="width:2550px;height: 400px">
                        <table class="table table-striped table-bordered table-hover text-nowrap" >
                            <thead>
                            <tr id="theadtr">
                                <th>#</th>
                                <th>编号</th>
                                <th>姓名</th>

                                <th>学习方向</th>
                                <th>分类</th>
                                <th>学历</th>
                                <th>毕业年限</th>
                                <th>专业</th>
                                <th>就业能力</th>
                                <th>se质检1(java基础语法)</th>
                                <th>OO特征和接口(自测)</th>
                                <th>se质检2(集合+IO)</th>
                                <th>javase项目</th>
                                <th>ee质检1(动态网页技术)</th>
                                <th>ee质检2(ssmh)</th>
                                <th>数据库mysql+oracle(自测)</th>
                                <th>javaee项目</th>

                                <th>结业考试</th>

                                <th>就业企业</th>
                                <th>待遇</th>

                            </tr>
                            </thead>
                            <tbody id="tbody_comprehensiveScores">

                            </tbody>
                        </table>
                    </div>




                </div>
            </div>
        </div>

        <div class="row" >
            <div class="col-lg-12">
                <div class="col-lg-7">
                    学员基本信息(作为打分参考)
                    <div class="panel panel-default">

                        <table  style="border-collapse:separate; border-spacing:12px 12px;"  rules=none  >
                        <tr>
                            <td>编号:</td>
                            <td>
                                <label id="labcode" >________</label>
                            </td><td>姓名:</td>
                            <td>
                                <label id="labname" >________</label>
                            </td>
                            <td>分类:</td>
                            <td>
                                <label id="labtype" >________</label>
                            </td>

                        </tr>
                        <tr>
                            <td>学历</td>
                            <td><label id="ldiploma" ></label></td>
                            <td>专业</td>
                            <td><label id="lprofession"></label></td>
                            <td>学校</td>
                            <td><label id="lschool" ></label></td>
                            <td>毕业时间</td>
                            <td><label id="lgraduTime" ></label></td>
                        </tr>
                    </table>
                    </div>


                    <c:if test="${fn:contains(dname,'java')}" >
                    <div class="panel panel-default" id="divj" style="display: block">
                    </c:if>
                    <c:if test="${fn:contains(dname,'物')}" >
                        <div class="panel panel-default" id="divj" style="display: none">
                     </c:if>


                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover text-nowrap">
                                <tbody id="tbody_edit_java">
                                <tr>
                                    <td width="120px">学历</td>
                                    <td width="100px"><input type="number" class = "form-control" id="diploma_java"></td>
                                    <td width="120px">毕业年限</td>
                                    <td width="100px"><input type="number" class = "form-control" id="graduateTime_java"></td>
                                    <td width="120px">专业</td>
                                    <td width="100px"><input type="number" class = "form-control" id="profession_java"></td>
                                </tr>
                                <tr>
                                    <td width="120px">就业能力</td>
                                    <td width="100px"><input type="number" class = "form-control" id="employ_java"></td>
                                    <td>se质检1(java基础语法)</td>
                                    <td ><label   id="java_basegrammar_java"></label></td>
                                    <td >oo特征和接口(自测)</td>
                                    <td ><label  id="java_oo_java"></label></td>
                                </tr>

                                <tr>
                                    <td>se质检2(集合+IO)</td>
                                    <td ><label  id="java_dastruct_java"></label></td>
                                    <td>javase项目</td>
                                    <td ><label  id="java_sepro_java"></label></td>
                                    <td>ee质检1(动态网页)</td>
                                    <td ><label  id="java_webpage_java"></label></td>
                                </tr>
                                <tr>

                                    <td>ee质检2(SSMH)</td>
                                    <td ><label  id="java_ssmh_java"></label></td>
                                    <td >数据库mysql+oracle(自测)</td>
                                    <td ><label  id="java_dbs_java"></label></td>
                                    <td>javaee项目</td>
                                    <td ><label  id="java_eepro_java"></label></td>
                                </tr>
                                <tr>
                                    <td >结业考试</td>
                                    <td ><label   id="examScore_java"></label></td>
                                    <td >公司</td>
                                    <td ><label   id="corporation_java"></label></td>
                                    <td >待遇</td>
                                    <td ><label  id="salary_java"></label></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-2"  style="margin: 10px">
                            <button type="button" class="btn btn-default" onclick="saveUpdate_java()" >保存修改信息</button>
                        </div>
                    </div>

                    <c:if test="${fn:contains(dname,'java')}" >
                        <div class="panel panel-default" id="divw" style="display: none">
                    </c:if>
                    <c:if test="${fn:contains(dname,'物')}" >
                        <div class="panel panel-default" id="divw" style="display: block">
                    </c:if>

                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover text-nowrap">
                                <tbody id="tbody_edit_w">
                                <tr>
                                    <td width="120px">学历</td>
                                    <td width="100px"><input type="number" class = "form-control" id="diploma_w"></td>
                                    <td width="120px">毕业年限</td>
                                    <td width="100px"><input type="number" class = "form-control" id="graduateTime_w"></td>
                                    <td width="120px">专业</td>
                                    <td width="100px"><input type="number" class = "form-control" id="profession_w"></td>
                                </tr>
                                <tr>
                                    <td width="120px">就业能力</td>
                                    <td width="100px"><input type="number" class = "form-control" id="employ_w"></td>
                                    <td>c语法和函数(自测)</td>
                                    <td ><label   id="cfun_w"></label></td>
                                    <td>质检1(数组和指针)</td>
                                    <td ><label   id="arrstruct_w"></label></td>
                                </tr>

                                <tr>
                                    <td >质检2(结构体和链表)</td>
                                    <td ><label  id="pt_w"></label></td>
                                    <td>c项目</td>
                                    <td ><label  id="cpro_w"></label></td>
                                    <td>c高级lsd(自测)</td>
                                    <td ><label  id="lsd_w"></label></td>
                                </tr>
                                <tr>
                                    <td>质检3(c++和oo)</td>
                                    <td ><label  id="cplusoo_w"></label></td>
                                    <td>qt(自测)</td>
                                    <td ><label  id="qt_w"></label></td>
                                    <td>c++项目</td>
                                    <td ><label  id="cpluspro_w"></label></td>
                                </tr>
                                <tr>
                                    <td >毕业项目</td>
                                    <td ><label  id="pro_w"></label></td>
                                    <td >结业考试</td>
                                    <td ><label   id="examScore_w"></label></td>
                                    <td >公司</td>
                                    <td ><label   id="corporation_w"></label></td>

                                </tr>
                                <tr>
                                    <td >待遇</td>
                                    <td ><label  id="salary_w"></label></td>
                                    <td ></td>
                                    <td ></td>
                                    <td ></td>
                                    <td ></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-2"  style="margin: 10px">
                            <button type="button" class="btn btn-default" onclick="saveUpdate_w()" >保存修改信息</button>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5" id="graph_container" style="height: 400px">

                </div>
            </div>
        </div>



        <div class="row" style="margin-top: 10px;">
            <a href="javascript:void(0)" onclick="downloadScoreDlg()" style="margin-left: 30px;">下载综合毕业成绩<img src="/img/down.png" width="30px"/></a>
        </div>
            </div>
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
<script src="/raphael.js"></script>

</body>

</html>
