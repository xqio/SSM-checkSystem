<%--
  Created by IntelliJ IDEA.
  User: artmaster
  Date: 2022/3/30
  Time: 15:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="../js/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $(function () {
        updateClassList()
        $("#btn-add").on("click",function () {
            $(".lookCheck").hide()
            $(".addCheck").show()
        })
        $("#btn-look").on("click",function () {
            $(".lookCheck").show()
            $(".addCheck").hide()
            $.post("${pageContext.request.contextPath}/tcheck/getCheck",{tId:${sessionScope.teacher.id}},startList,"json")
        })

        $("#addCheck").on("click",function () {
            const course = $("#courseList").val();
            const password=$("#password").val();
            const rePassword=$("#rePassword").val();
            if (password!==rePassword){
                alert("两次密码不同，请重新输入！")
            }else {
                $.post("${pageContext.request.contextPath}/tcheck/addCheck",{tId:${sessionScope.teacher.id},cId:course,password:password},function (data) {
                    alert(data.message);
                    $("#password").val("");
                    $("#rePassword").val("");
                },"json")
            }
        })
    })
    function startList(dataList) {
        $("#checkList").empty()
        $.each(dataList,function (i,data) {
            const checkDiv = $("<div></div>").addClass("checkItem").addClass("p-4").addClass("rounded");
            const cName = $("<span></span>").append(data.courseName);
            const time = $("<span></span>").append(getMyDate(data.checkOpenTime));
            const number = $("<span></span>").append(data.checkNumber + "/" + data.allNumber);
            const btn1 = $("<button></button>").addClass("bnt").addClass("btn-primary").addClass("mx-4").addClass("lookBtn").append("查看详情").attr("checkID",data.checkId);
            const btn2 = $("<button></button>").addClass("bnt").addClass("btn-primary").addClass("mx-4").addClass("deleteBtn").append("删除签到").attr("checkID",data.checkId);
            $("#checkList").append(checkDiv.append(cName,time,number,btn1,btn2));
        })
        $(".lookBtn").on("click",function () {
            const checkId = $(this).attr("checkId");
            $(location).attr("href","${pageContext.request.contextPath}/tcheck/look?checkId="+checkId);
        })
        $(".deleteBtn").on("click",function () {
            const checkId = $(this).attr("checkId");
            $.post("${pageContext.request.contextPath}/tcheck/delete",{checkId:checkId},function (data) {
                alert(data.message);
                $.post("${pageContext.request.contextPath}/tcheck/getCheck",{tId:${sessionScope.teacher.id}},startList,"json")
            },"json")
        })
    }
    function updateClassList() {
        $.post("${pageContext.request.contextPath}/tcheck/updateCourseList",{tId:${sessionScope.teacher.id}},function (courseList) {
            $("#courseList").empty()
            $.each(courseList,function (i,course) {
                $("#courseList").append("<option value=\""+course.id+"\">"+course.name+"</option>")
            })
        },"json")
    }
    function getMyDate(str){
        const oDate = new Date(str),
            oYear = oDate.getFullYear(),
            oMonth = oDate.getMonth() + 1,
            oDay = oDate.getDate(),
            oHour = oDate.getHours(),
            oMin = oDate.getMinutes(),
            oSen = oDate.getSeconds();//最后拼接时间
        return oYear + '-' + getzf(oMonth) + '-' + getzf(oDay) + ' ' + getzf(oHour) + ':' + getzf(oMin) + ':' + getzf(oSen);
    }
    //补0操作
    function getzf(num){
        if(parseInt(num) < 10){
            num = '0'+num;
        }
        return num;
    }
</script>
<style>
    .bodyDiv {
        background-color: #e6dbb9;
        padding-bottom: 40px;
    }
    .lookCheck{
        display: none;
    }
    .checkItem{
        background-color: burlywood;
        margin-top: 30px;
        height: 80px;
        width: 65%;
    }
    .checkItem>span{
        margin-left: 30px;
    }
    a{
        text-decoration: none;
        color: mediumpurple;
    }
</style>
<body>
<div class="container">
    <nav aria-label="breadcrumb" class="mt-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">Home</li>
        </ol>
        <span>欢迎您！${sessionScope.teacher.name}</span><span class="ms-2"><a href="${pageContext.request.contextPath}/tcheck/logout">[退出登录]</a></span>
    </nav>
    <div class="p-2  mt-4">
        <button type="button" class="btn btn-primary ms-3" id="btn-add">发布签到</button>
        <button type="button" class="btn btn-primary ms-2" id="btn-look">查看签到</button>
    </div>
    <div class="bodyDiv rounded">
        <div class="row mx-4 pt-3 addCheck">
            <div class="col-2">
                <label for="courseList">课程</label>
                <select class="form-control" id="courseList">
                    <option value="1">语文</option>
                    <option value="2">数学</option>
                    <option value="3">C++</option>
                </select>
            </div>
            <div class="col-2">
                <label for="password">密码</label>
                <input type="password" class="form-control" placeholder="签到密码" id="password">
            </div>
            <div class="col-2">
                <label for="rePassword">确认密码</label>
                <input type="password" class="form-control" placeholder="请确认..." id="rePassword">
            </div>
            <div class="col-2 offset-2">
                <button type="button" class="btn btn-primary mt-4" id="addCheck">发布</button>
            </div>
        </div>
        <div class="lookCheck mx-4 pt-2" id="checkList">

        </div>
    </div>
</div>
</body>
</html>