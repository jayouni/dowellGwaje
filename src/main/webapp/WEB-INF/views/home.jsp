<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
%> 
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>

	<h3>고객조회pg2</h3>

	<form name="searchCust" method="post" action="">
	<table border="0" id="check_cust">
	
	<tr>
		<td>매장<input type="text" name="PRT_CD"></td>
		<td>고객번호<input type="text" name="CUST_NO"></td>
		<td><input  type="image" name="submitForm" onclick="submitForm()" id="sub_btn" src="src/main/webapp/WEB-INF/image/dott.png"></td>
	</tr>
	<tr>
		<td>고객상태
			<input type="radio" value="all" name="CUST_SS_CD" checked>전체
			<input type="radio" value="ok" name="CUST_SS_CD">정상
			<input type="radio" value="stop" name="CUST_SS_CD">중지
			<input type="radio" value="del" name="CUST_SS_CD">해지
		</td>
		<td>가입일자<input type="date" name="DATE"></td>
		</tr>
		<br>
	</table>
	<input type="button" name="newMember" onclick="newMember()" id="newMem_btn" value="신규등록">
	</form>
	
	<table border="1" id="cust_table">
	<tr>
		<td>고객번호</td>
		<td>고객이름</td>
		<td>휴대폰번호</td>
		<td>고객상태</td>
		<td>가입일자</td>
		<td>가입매장</td>
		<td>등록자</td>
		<td>수정일자</td>
	</tr>
</body>
</html>
