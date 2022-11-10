<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
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
<title>header</title>
</head>
<body>


	<header id="headerr">
		<div class="container">
			<div class="inner-contain">

				<ul class="menubar">
					<li><a href="#" id="logid">${member.user_nm }&nbsp;님</a></li>
					<li><a href="/gwaje/member/toMain">고객조회</a></li>
					<li><a href="/gwaje/search/toCustmod">고객정보조회</a></li>
					<li><a href="/gwaje/search/getTotal">매장월별실적조회</a></li> 
					<li><a href="/gwaje/sale/panMain">고객판매조회</a></li>
					<li id="logout"><a href="/gwaje/member/logout">로그아웃</a></li>
					<li>
				</ul>
			</div>
		</div>



	</header>



</body>

</html>