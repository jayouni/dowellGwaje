<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<c:set var="id" value="${param.id }" />
<c:set var="pwd" value="${param.pwd }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
	
#wrap {
  display: grid;
  place-items: center;
  min-height: 100vh;
}
</style>
<c:choose>
	<c:when test="${result=='loginFailed' }">
		<script>
		window.onload = function(){
			alert('아이디나 비밀번호가 틀렸습니다. 다시 로그인하세요.');
		}
	</script>
	</c:when>
</c:choose>
</head>
<body>
	
	<div id="wrap">
 		<div class="center">
			<form action="/gwaje/member/login" method="post">
			<input type="text" name="user_id" placeholder="아이디" ><br>
			<input type="password" name="use_pwd" placeholder="비밀번호"><br>
			<input type="submit" value="로그인">
			</form>
		</div>
	</div>
	<input type="hidden" name="result" id="result" value="${result}" />

</body>
</html>