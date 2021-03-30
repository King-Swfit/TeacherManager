<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>文章编辑</title>

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


</head>
<body>
    <div class="col-lg-12" style="text-align: center;margin: 10px">
        <div class="text-center">
            <input id="title" class="col-lg-6" placeholder="文章标题">
        </div>
    </div>

    <div id="editor" >
        <p>欢迎使用 <b>wangEditor</b> 富文本编辑器</p>
    </div>
    <div class="col-lg-12" style="align-content: center">
        <div style="text-align:center">
            <Button id="save" class="btn btn-default" onclick="save()" style="margin-top: 10px">保存页面内容</Button>
        </div>

    </div>

    <link href="/wangEditor.css" rel="stylesheet">
<!-- 注意， 只需要引用 JS，无需引用任何 CSS ！！！-->
<script type="text/javascript" src="/wangEditor.min.js"></script>
<script src="/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript">
    var E = window.wangEditor
    var editor = new E('#editor')
    // 或者 var editor = new E( document.getElementById('editor') )

    // 隐藏“网络图片”tab
    editor.customConfig.showLinkImg = false
    // 关闭粘贴内容中的样式
    editor.customConfig.pasteFilterStyle = false
    // 忽略粘贴内容中的图片
    editor.customConfig.pasteIgnoreImg = false


    // 将图片大小限制为 10M
    editor.customConfig.uploadImgMaxSize = 10 * 1024 * 1024
    // 限制一次最多上传 1 张图片
    editor.customConfig.uploadImgMaxLength = 5
    editor.customConfig.uploadImgServer = '/class/upload'
    editor.customConfig.uploadFileName = 'myFileName'

    editor.customConfig.uploadImgHooks = {
        customInsert: function (insertImg, result, editor) {
            var url =result.data;//获取后台返回的url
            insertImg("${sessionScope.server}" + "/" + url);

        }
    };

    editor.create()

    function save(){
        var html = editor.txt.html();
        var title = $("#title").val()
        $.post(
                "/class/news",
                {"html":html,"title":title},
                function (data) {
                    alert(data)
                    if(data == "success"){
                        window.location.href="/class/activity";
                    }

                }
        );

    }
</script>
</body>
</html>