<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?v=System.currentTimeMillis()">
<meta charset="UTF-8">
<title>고객이력5</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	
	 	$(document).ready(function(){
			
			var cust_his = opener.$("#cust_history").val(); 
			
			//버튼눌러서 고객이력조회 팝업 뜨면 가지고 온 값 바로 넣고
			$("#gogekhis").val(cust_his); 
			
			//만들어진 ajax 바로 돌려 창 뜨자마자 값 가져오기
			getHistory();
			
			//닫기 버튼 누르면 창 닫기
			$("#close55").click(function(){
				window.close();
			});
	
			
		}); //end of document
	
	
	
	
	
		//고객 이력 조회 ajax
	    function getHistory() {

	    	var cust_no = $("#gogekhis").val();
	    	
	    	    	
	    	$.ajax({
				url:"<%= request.getContextPath()%>/search/memHistory",
				data: {"cust_no":cust_no}, 
				dataType:"JSON", 														
				type:"POST",															
				success:function(json){ 
					//alert("성공");
					let info = "";														
					let html = "";	
				 	
 
					//console.log(json);												
					if(json.length > 0) { 
						
						info = "<td >고객&nbsp;&nbsp;&nbsp;"+json[0].CUST_NO+"&nbsp;&nbsp;&nbsp;"+json[0].CUST_NM+"</td>";
						$("tr#gogekhis").html(info);
						
						$.each(json, function(index, item){								
							
							html += "<tr >";  
							html += "<td class='center border_left' >"+item.CHG_DT+"</td>";
							html += "<td class='center'>"+item.CHG_CD+"</td>";
							html += "<td class='left' >"+item.CHG_BF_CNT+"</td>";
							html += "<td class='left' >"+item.CHG_AFT_CNT+"</td>";
							html += "<td class='left' >"+item.LST_UPD_ID+"</td>";
							html += "<td class='center' >"+item.LST_UPD_DT+"</td>";
							html += "</tr>";
						
						});
					}
					else {
						
						
						html += "<tr>";
						html += "<td colspan='6' class='center' >변경된 고객이력이 존재하지 않습니다.</td>";
						html += "</tr>";
					}
					
					$("tbody#custBody").html(html); 						
					
				},
				error: function(){
					alert("실패");
				}
			}); // end of $.ajax
	    	
	    } // end of  getHistory(cust_no)
    


</script>

</head>
<body>

	
	<table id="cust_nm_tbl">
	<tr id="gogekhis"><td>고객&nbsp;&nbsp;&nbsp;${item.CUST_NO }&nbsp;&nbsp;&nbsp;${item.CUST_NM }</td><td ></td></tr>
	</table>
	
	
	<div id="his_div" style="overflow:auto;width:999px; height:450px; ">
	<form >
	<table id="cust_tbl" cellspacing="0">
		<thead id="custHead" >
		<tr id="cust_tr" >
			<th class="center">변경일자</th>
			<th class="center">변경항목</th>
			<th class="center">변경전</th>
			<th class="center">변경후</th>
			<th class="center">수정자</th>
			<th class="center">수정일시</th>
		</tr>
		</thead>
		
		<tbody id="custBody">
		
		</tbody>
	
	</table>
	</form>
	</div>
	
	
	<div id="btn5_div">
		<button type="button" id="close55" >닫기</button>
	</div>
	
	<input type="hidden" name="custNO" id="custNO" value="" />
	<input type="hidden" name="custName" id="custName" value="" />

</body>
</html>

