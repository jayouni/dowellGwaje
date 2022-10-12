<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
	
%>  
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=1">
<meta charset="UTF-8">
<title>main</title>

<script>

	//페이지 시작되면 아이디에 자동 포커스 
	window.onload = function() {

  	document.getElementById("id").focus();
  
	};
	
	
</script>
</head>

<body id="main_chang">
	<div id="wrap">
 		<div class="center">
 		<h3 id="welcome">welcome</h3>
			<form action="/gwaje/member/login" method="post">
			<input type="text" name="user_id" id="id" placeholder="아이디" ><br>
			<input type="password" name="use_pwd" placeholder="비밀번호"><br>
			<input type="submit" value="로그인" id="log_btn">
			</form>
		</div>
	</div>

	
</body>
</html>