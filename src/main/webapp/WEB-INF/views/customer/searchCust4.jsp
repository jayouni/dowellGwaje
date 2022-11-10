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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=4">
<meta charset="UTF-8">
<title>매장조회4</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

	
	
	
	
	
	
	
		$(document).ready(function(){
	
		
		var cust_no = opener.$("#cust_no").val(); //부모창 검색창 ID = cust_no 에 입력된 값 가져오기
		$("#cust_nm").val(cust_no); 			  //자식창에 id=cust_nm 에 cust_no 값 넣기
		
		//바로 ajax 실행
		searchCust();
		
		//큰 돋보기 눌렀을 때 함수 실행
		$("#search").click(function(){
			searchCust();
		}); 
	
		//창 닫기 버튼
		$("#cancel").click(function(){
			window.close();
		});
		
		//부모 창 닫을시 팝업창 닫기
 	    $(opener).one('beforeunload', function() {                    
			window.close();                                      
		});
		
		//적용 버튼 눌렀을 때
		$("#submit").click(function(){
			
			// 체크 하지 않고 적용버튼 누르면 알럿
			let is_check = $("input:checkbox[name='checkbox']").is(":checked");
			if(!is_check){
				alert("항목을 선택 하시지 않았습니다.");
				return false;
			}
			
			//id에 담긴 값 넣기
			var cust_no = $("input[name='checkbox']:checked").attr('id');
			//노드 찾아서 값 넣기
			var cust_nm = $("input[name='checkbox']:checked").parent().parent().children().eq(2).text();
			var avb_pnt = $("input[name='checkbox']:checked").parent().parent().children().eq(5).val();
			
			//창이 닫히면서 부모창에 들어갈 아이디에 값 넣기
	    	$("#cust_no_dis", opener.document).val(cust_no); 	 			
	    	$("#cust_no", opener.document).val(cust_nm);
	    	$("#avb_pnt", opener.document).val(avb_pnt);
	    	$("#custNmHide", opener.document).val(cust_nm);
	    	applyClose();
			
		});
		
		
		//엔터시 바로 함수 실행
		$("#cust_nm").keydown(function(event){					
			if(event.keyCode == 13) { 									
				searchCust();					
				
			}
		}); 
		
		//엔터시 바로 함수 실행
		$("#mbl_no").keydown(function(event){					
			if(event.keyCode == 13) { 									
				searchCust();					
			}
		}); 
		
		
		
	});	// ready function end.
	
		
		//창닫기
		function applyClose(){
		window.close();
		
		}
	
	
		
		//다중 선택 불가
		function checkOne(a){
			
			var check = document.getElementsByName("checkbox");
		  
			for(var i=0; i<check.length; i++){
				
				if(check[i] != a){
					
					check[i].checked= false;
				}
			}
			
		} //end checkOne
	
	
	
	
	
		//고객 조회 ajax
		function searchCust(){
			
			var cust_nm = $("#cust_nm").val();
			var mbl_no = $("#mbl_no").val();
			
			//alert("알럿" + cust_nm , mbl_no);
			
			// 고객 두자 이하 팝업
	  		if(cust_nm.trim() != '' && cust_nm.trim().length < 2) {
				alert('고객 번호나 이름을 두글자 이상 입력하세요.');
				$('#cust_nm').focus();
				return false;
			 }  
			
			// 번호 10자리 이하 불가
	  		if(mbl_no.trim() != '' && mbl_no.trim().length < 10) {
				alert('정확한 번호를 입력하셔야 합니다.');
				$('#mbl_no').focus();
				return false;
			 }  
			
			
			$.ajax({
				url:"<%= request.getContextPath()%>/search/searchcust4",
				data: {"cust_nm": cust_nm,
						"mbl_no": mbl_no} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					let html = "";
					if(json.length > 0){
						$.each(json,function(index, item){
							
							//console.log(json);

							
							html += "<tr style='width: 100%;'>";  
							html += "<td class='center border_left' ondblclick='dbl_cust()'><input type='checkbox' name='checkbox' id='"+item.CUST_NO+"' onclick='checkOne(this)' /></td>";
							html += "<td class='center' ondblclick='dbl_cust()' id='CUST_NO' >"+item.CUST_NO+"</td>";
							html += "<td class='center' ondblclick='dbl_cust()' id='CUST_NM' >"+item.CUST_NM+"</td>";
							html += "<td class='center' ondblclick='dbl_cust()' id='MBL_NO' >"+item.MBL_NO+"</td>";
							html += "<td class='center' ondblclick='dbl_cust()' id='CUST_SS_CD' >"+item.CUST_SS_CD+"</td>";
							html += "<input type='hidden' id='avb_pnt' value='" + item.AVB_PNT + "'/>";
							html += "</tr>";
							
						});
						
					}
					else {
						html += "<tr>";
						html += "<td colspan='5' class='center'>검색조건에 맞는 고객이 존재하지 않습니다 .</td>";
						html += "</tr>";
					}
					
					$("tbody#sch_cust_body").html(html); 							
	
				},
				error: function( error){
					
					alert("실패"+ error);
				}
					
			});
			
			
			
		}
		
		
		//창 닫기
		function cancel(){
			
			window.close();
			
		}
	
		
		//더블 클릭 액션
		function dbl_cust() {
			const $target = $(event.target);											
			var tr = $target.parent();													
			var td = tr.children();														
			
			var custNo = td.eq(1).text();												
		    var custNm = td.eq(2).text();
		    var avbPnt = td.eq(5).val();

	
			$("#cust_no_dis", opener.document).val(custNo); 								
		    $("#cust_no", opener.document).val(custNm);
		    $("#avb_pnt", opener.document).val(avbPnt);
		    $("#custNmHide", opener.document).val(custNm);
		 	window.close();
		 	

		    
			
	
		}
	



</script>
</head>
<body>
	<h3>고객조회</h3>
	
	<table id="sc_cust">
		<tr>
			<td>고객이름<input type="text" name="cust_nm" id="cust_nm"></td>
			<td>핸드폰번호<input type="text" name="mbl_no" id="mbl_no"></td>
			<td><button type="button" id="search"><img src="../resources/image/dott.png" id="sub_btn4"></button></td>
		</tr>
	</table>
	
	
	<div id="popup_cust" style="overflow:auto; /* width:820px; */ height:300px;" >
	<form>
	<table  id="sc_cust_rslt" cellspacing="0">
	<thead id="cust_sel_head" style="width:90%">
		<tr id="sc_cust_tr">
			<th>선택</th>
			<th>고객번호</th>
			<th>고객명</th>
			<th>핸드폰번호</th>
			<th>고객상태</th>
		</tr>
		</thead>
		<tbody id="sch_cust_body"/>
	</table>
	</form>
	</div>
	
	<div id="btn_div" style="margin-left:330px; margin-top:50px;">
		<input style="width:65px; height:35px;" type="button" id="cancel" value="닫기" ">
		<input style="width:65px; height:35px;" type="button" id="submit" value="적용" ">	
	</div>
</body>
</html>