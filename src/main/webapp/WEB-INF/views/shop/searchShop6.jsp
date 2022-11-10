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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=6">
<meta charset="UTF-8">
<title>매장조회6</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
		
	
		
		$(document).ready(function(){
			
			//매장 명 칸에 바로 들어오자마자 포커스
			$("#in_prt").focus();
			
			var prt_cd_nm = opener.$("#prt_cd_nm").val(); //부모창 검색창 ID = prt_cd_nm 에 입력된 값 가져오기
			$("#in_prt").val(prt_cd_nm); //자식창에 id=in_prt 에 prt_nm 값 넣기
			
			//창 뜨자마자 값 나오게
			searchShop();
			
			//매장 찾는 버튼 누르면 searchShop() 실행
			$("#search").click(function(){
				searchShop();
			});
			
			//cancel 버튼 클릭시 창닫히게
			$("#cancel").click(function(){
				window.close();
			});
			
			//부모 창 닫을시 팝업창 닫기
	 	    $(opener).one('beforeunload', function() {                    
				window.close();                                      
			});
			
			//적용 버튼 누를때
			$("#submit").click(function(){
				
				//체크박스 값 체크 안하고 누르면 적용 안되게
				let is_check = $("input:checkbox[name='checkbox']").is(":checked");
				if(!is_check){
					alert("항목을 선택을 하시지 않았습니다.");
					return false;
				}
				
				//checkbox에 parent = td , parent = tr , children = td , eq (1) = 첫번째에 , text() = 텍스트 ;
				var prt_cd = $("input[name='checkbox']:checked").parent().parent().children().eq(1).text();
				var prt_cd_nm = $("input[name='checkbox']:checked").attr('id');
				
		    	$("#prt_cd", opener.document).val(prt_cd);
		    	$("#in_prt", opener.document).val(prt_cd); 
		    	$("#prt_cd_nm", opener.document).val(prt_cd_nm); 		 		
		    	applyClose();
				
			});
			
			
			//엔터시 바로 함수 실행
			$("#in_prt").keydown(function(event){					
				if(event.keyCode == 13) { 									
					searchShop();				
				
				}
			}); 
	
			
		}); //end of document ready
		
		
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
		
		
		
		//매장 찾기 ajax
		function searchShop(){
			
			var in_prt = $("#in_prt").val();
			
			// 매장 두자 이하 팝업
	 		if(in_prt.trim() != '' && in_prt.trim().length < 2) {
				alert('매장 코드나 매장 이름을 두글자 이상 입력하셔야 합니다.');
				$('#prt_cd_nm').focus();
				return false;
			 }
		
		$.ajax({
			url:"<%= request.getContextPath()%>/search/searchshop6",
			data: {"in_prt": in_prt} ,
			type: 'post',
			dataType: "JSON",
			async: false,
			success: function(json){
				console.log(json);
				//alert("성공");
				let html = "";
				if(json.length > 0){
					$.each(json,function(index, item){
						
						html += "<tr >";  
						html += "<td class='center border_left' ondblclick='dbl_shop()' ><input type='checkbox' name='checkbox'id='"+item.PRT_NM+"' onclick='checkOne(this)'/></td>";
						html += "<td class='center' ondblclick='dbl_shop()' id='PRT_CD'>"+item.PRT_CD+"</td>";
						html += "<td class='center' ondblclick='dbl_shop()' id='PRT_NM'>"+item.PRT_NM+"</td>";
						html += "<td class='center' ondblclick='dbl_shop()' id='PRT_SS_CD'>"+item.PRT_SS_CD+"</td>";
						html += "</tr>";
						
					});
				}
				else {
					html += "<tr>";
					html += "<td colspan='4' class='center'>검색조건에 맞는 매장이 존재하지 않습니다.</td>";
					html += "</tr>";
				}
				
				$("tbody#sch_shop_body").html(html); 							
	
			},
			error: function( error){
				
				alert("실패"+ error);
			}
				
		});
		
	} //end searchshop ajax
	
	
	
	
		
		//더블 클릭 액션
		function dbl_shop() {
			//ondblclick="dbl_shop()"
			
			//이벤트가 발생한 요소 = 더블 클릭 
			const $target = $(event.target);
			
			//노드 찾기
			var tr = $target.parent();													
			var td = tr.children();														
			
			//노드 찾아 값 넣어주기
			var prtCd = td.eq(1).text();												
		    var prtNm = td.eq(2).text();												
		
			$("#prt_cd", opener.document).val(prtCd); 					//더블클릭시 1번 페이지로 값 넘기기	
			$("#in_prt", opener.document).val(prtCd); 					//더블클릭시 7번 페이지로 값 넘기기			
		    $("#prt_cd_nm", opener.document).val(prtNm); 	 			//더블클릭시 1,7번 페이지로 값 넘기기					
			
			window.close();
		
		}



</script>
</head>
<body>
<h3>매장조회</h3>
	
	<div id="sch_div">
	<table id="sch_shop">
		<tr>
			<td id="sch_td">매장<input class="in_6"type="text" id="in_prt" name="in_prt" placeholder="매장명 또는 매장코드"></td>
			<td><button type="button" id="search"><img src="../resources/image/dott.png" id="sub_btn6"></button></td>
		</tr>
	</table>
	</div>
	
	
	
	
	<div id="popup_shp" style="overflow:auto; /* width:820px; */ height:300px;">
	<form>
	<table id="shp_sel" style="" cellspacing="0">
		<thead id="shp_sel_head" style="width:90%">
		<tr id="shp_sel_tr">
			<th>선택</th>
			<th>매장코드</th>
			<th>매장명</th>
			<th>매장상태</th>
		</tr>
		</thead>
		<tbody id="sch_shop_body"/>
	</table>
	</form>
</div>


<div id="btn_div" style="margin-left:330px; margin-top:50px; ">
	<button style="width:65px; height:35px;" type="button" id="cancel">닫기</button>
	<button style="width:65px; height:35px;" type="button" id="submit">적용</button>
</div>

	

</body>
</html>