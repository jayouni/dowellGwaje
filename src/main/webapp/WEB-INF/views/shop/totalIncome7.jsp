<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
request.setCharacterEncoding("UTF-8");

/* 	Object o_prt_cd = session.getAttribute("prt_cd");
	Object o_prt_cd_nm = session.getAttribute("prt_cd_nm");
	Object o_se_user_dt_cd = session.getAttribute("se_user_dt_cd");
	
	String sse_prt_cd = (String)o_prt_cd;
	String sse_prt_nm = (String)o_prt_cd_nm;
	String sse_user_dt_cd =(String)o_se_user_dt_cd; */

	
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<%-- <jsp:include page="${contextPath }/member/mainCheck1.jsp"/> --%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=7">
<meta charset="UTF-8">
<title>매장실적7</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	
		var prt_cd = "";
		var prt_nm ="";
		var se_prt_cd = "";
		var se_prt_nm = "";
		var se_user_dt_cd = "";
		var se_user_nm = "";
		
		
		
		
		$(document).ready(function() {
			
		$("#prt_cd_nm").focus();
	
		
	  	var prt_cd = $("#prt_cd").val();
		var prt_cd_nm = $("#prt_cd_nm").val();
		var se_user_nm = $("#se_user_nm").val();
		var se_prt_cd = $("#ssse_prt_cd").val();						// session 저장된 로그인유저의 매장코드
		var se_prt_cd_nm = $("#ssse_prt_cd_nm").val();						// session 저장된 로그인유저의 매장명
		var se_user_dt_cd = $("#ssse_user_dt_cd").val();  
		
	 	console.log(se_prt_cd);
		console.log(se_prt_cd_nm);
		console.log(se_user_dt_cd); 
		
		
		var month = new Date().toISOString().slice(0, 7);
		$("#wol").val(month);
		$("#wol").attr("max",month);

		
	
		defaultSearch();
	
		
		//세션 저장 된 사용자 구분 코드가 매장일 경우
	 	if(se_user_dt_cd != 1){
	
			$("#btn_prt").attr("disabled", true);
			$("#prt_cd_nm").attr("disabled", true);
			$("#search_shop7").attr("disabled", true);
			
		} 
	 	
		//세션 저장 된 사용자 구분 코드가 본사일 경우
	 	if(se_user_dt_cd != 2){
	
	 		$("#in_prt").val("");
			$("#prt_cd_nm").val("");
			
			
		}
		
	 	//큰 돋보기 눌렀을 때
		$("#total_btn").click(function(){
			getTotal();
		}); 
	 	
		
	 	//매장 팝업 작은 돋보기 눌렀을때
		$("#btn_prt").click(function(){
			
			popUp_prt();
		}); 
		
		
		//엔터시 자동으로 매장 찾기
		$("#prt_cd_nm").keydown(function(event){					
		if(event.keyCode == 13) { 									
				
			check_prt_data();			
				
			}
		});
	
	
 		//인풋창에서 값 지웠을때 코드 
 		$("#prt_cd_nm").keyup(function(event){                  
 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
 	            if( $("#prt_cd_nm").val() == "" ) {            
 	               $("#in_prt").val("");                  
 	           } 
 	         

 	        }
 	     });
	
	
	
	}); //end  ready document

			
			//default로 설정 될 값들
			function defaultSearch(){
					
				if(se_user_dt_cd == 1) {
					$(".in_7").val("");								
					$(".prt_1").val("");
						
				}
					
			}
		
				
		// 엔터 or 클릭시 매장 데이타 검색
		function check_prt_data(){
			
			var prt_cd_nm = $("#prt_cd_nm").val();
			
			console.log(prt_cd_nm);
			$.ajax({
				url:"<%= request.getContextPath()%>/search/searchshop6",
				data: {"in_prt": prt_cd_nm} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					if(json.length == 1){
						var prtCd = json[0].PRT_CD; // => 매장값 꺼냄
						var prtNm = json[0].PRT_NM; // => 매장명 꺼냄
						
						$('#in_prt').val(prtCd);
						$('#prt_cd_nm').val(prtNm);
						
					} else {
						alert('일치하는 값이 없거나 두개 이상입니다');
						popUp_prt();
					}
			
				},
				error: function( error){
					
					alert("실패"+ error);
				}
					
			}); 
			
			}//end check_prt_data

	
			
			
		// 큰 돋보기 ajax
		function getTotal(){
			
			var in_prt = $("#in_prt").val();
			var wol = $("#wol").val();
			var ym = wol.replace("-", "");
			
			//console.log(ym);
			//console.log(in_prt);
			$.ajax({
				url:"<%= request.getContextPath()%>/search/getTotal77",
				data: {"in_prt": in_prt,
						   "ym": ym} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					
					//alert("성공");
					let html = "";
					//console.log(json.length);
					console.log(json[0].PRT_CD);
					if(json.length > 0 && json[0].PRT_CD != '총합'){
						$.each(json,function(index, item){
						
						
						html += "<tr style='width: 100%;'>";
						
						   if(item.PRT_NM != '합계'){
			                     html += "<td class='left border_left'>"+item.PRT_CD+"</td>";//매장코드
			                     html += "<td class='left'>"+item.PRT_NM+"</td>";//매장명
			                  }
			                  if(item.PRT_NM == '합계'){

			                     html += "<td colspan='2' class='center border_left' >"+item.PRT_NM+"</td>";//매장명
			                  }
						

						html += "<td class='right' id='SAL_1_QTY'>"+item.SAL_1_QTY+"</td>";
						html += "<td class='right' id='SAL_2_QTY'>"+item.SAL_2_QTY+"</td>";
						html += "<td class='right' id='SAL_3_QTY'>"+item.SAL_3_QTY+"</td>";
						html += "<td class='right' id='SAL_4_QTY'>"+item.SAL_4_QTY+"</td>";
						html += "<td class='right' id='SAL_5_QTY'>"+item.SAL_5_QTY+"</td>";
						html += "<td class='right' id='SAL_6_QTY'>"+item.SAL_6_QTY+"</td>";
						html += "<td class='right' id='SAL_7_QTY'>"+item.SAL_7_QTY+"</td>";
						html += "<td class='right' id='SAL_8_QTY'>"+item.SAL_8_QTY+"</td>";
						html += "<td class='right' id='SAL_9_QTY'>"+item.SAL_9_QTY+"</td>";
						html += "<td class='right' id='SAL_10_QTY'>"+item.SAL_10_QTY+"</td>";
						html += "<td class='right' id='SAL_11_QTY'>"+item.SAL_11_QTY+"</td>";
						html += "<td class='right' id='SAL_12_QTY'>"+item.SAL_12_QTY+"</td>";
						html += "<td class='right' id='SAL_13_QTY'>"+item.SAL_13_QTY+"</td>";
						html += "<td class='right' id='SAL_14_QTY'>"+item.SAL_14_QTY+"</td>";
						html += "<td class='right' id='SAL_15_QTY'>"+item.SAL_15_QTY+"</td>";
						html += "<td class='right' id='SAL_16_QTY'>"+item.SAL_16_QTY+"</td>";
						html += "<td class='right' id='SAL_17_QTY'>"+item.SAL_17_QTY+"</td>";
						html += "<td class='right' id='SAL_18_QTY'>"+item.SAL_18_QTY+"</td>";
						html += "<td class='right' id='SAL_19_QTY'>"+item.SAL_19_QTY+"</td>";
						html += "<td class='right' id='SAL_20_QTY'>"+item.SAL_20_QTY+"</td>";
						html += "<td class='right' id='SAL_21_QTY'>"+item.SAL_21_QTY+"</td>";
						html += "<td class='right' id='SAL_22_QTY'>"+item.SAL_22_QTY+"</td>";
						html += "<td class='right' id='SAL_23_QTY'>"+item.SAL_23_QTY+"</td>";
						html += "<td class='right' id='SAL_24_QTY'>"+item.SAL_24_QTY+"</td>";
						html += "<td class='right' id='SAL_25_QTY'>"+item.SAL_25_QTY+"</td>";
						html += "<td class='right' id='SAL_26_QTY'>"+item.SAL_26_QTY+"</td>";
						html += "<td class='right' id='SAL_27_QTY'>"+item.SAL_27_QTY+"</td>";
						html += "<td class='right' id='SAL_28_QTY'>"+item.SAL_28_QTY+"</td>";
						html += "<td class='right' id='SAL_29_QTY'>"+item.SAL_29_QTY+"</td>";
						html += "<td class='right' id='SAL_30_QTY'>"+item.SAL_30_QTY+"</td>";
						html += "<td class='right' id='SAL_31_QTY'>"+item.SAL_31_QTY+"</td>";
						html += "<td class='right' id='TOT_SAL_QTY'>"+item.TOT_SAL_QTY+"</td>";
						html += "</tr>"; 
					});
				}
				else {
					html += "<tr>";
					html += "<td colspan='34' class='center' >검색조건에 맞는 자료가 존재하지 않습니다.</td>";
					html += "</tr>";
				}
				
				$("tbody#mae_body").html(html); 							

			},
			error: function( error){
				
				alert("실패"+ error);
			}
				
		});
		
	}//end check_prt_data


	

	//매장 팝업 url
	function popUp_prt(){
		
		var url = "http://localhost:8080/gwaje/search/searchshop";
		var title = "popUp_prt";
		var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=50,left=100";
		window.open(url, title, status);
		
	}



</script>
</head>
<body>
<h3>매장월별실적조회</h3>
	
	
	<table id="mae_tbl">
		<tr>
			<td><i class="redstar" style="color:red;">*</i>매출월 
			<input type="month" name="wol" id="wol"/>
			</td>
			<td>매장<input class="in_7"type="text" name="in_prt" id="in_prt" value="${sessionScope.prt_cd }" disabled>
			<button type="button" id="btn_prt" ><img src="../resources/image/dott.png" id="search_shop7"></button>
			<input type="text" class="prt_1" name="prt_cd_nm" id="prt_cd_nm" value="${sessionScope.prt_cd_nm}"></td>
			<td><button type="button" id="total_btn"><img src="../resources/image/dott.png" id="sub_btn7"></button></td>
		</tr>
	</table>
		
	<%-- <input type="hidden" name="se_user_nm" id="se_user_nm" value="${sessionScope.member.user_nm}" />
		<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" /> --%>
		<%-- <input type="hidden" name="se_user_dt_cd" id="se_user_dt_cd" value="${sessionScope.member.user_dt_cd}" /> --%>
		<input type="hidden" name="ssse_prt_cd" id="ssse_prt_cd" value="${sessionScope.prt_cd}" />
		<input type="hidden" name="ssse_prt_cd_nm" id="ssse_prt_cd_nm" value="${sessionScope.prt_cd_nm}" />
		<input type="hidden" name="ssse_user_dt_cd" id="ssse_user_dt_cd" value="${sessionScope.se_user_dt_cd}" />
	
	<div id="mae_tbl_div" style="width:100%; overflow:auto;">
	<form>
	<table id="mae_tbl2" style="white-space: nowrap;" cellspacing="0">
		<thead id="mae_thead">
		<tr id="mae_tbl_tr">
			<th>매장코드</th>
			<th>매장명</th>
			<th>1일</th>
			<th>2일</th>
			<th>3일</th>
			<th>4일</th>
			<th>5일</th>
			<th>6일</th>
			<th>7일</th>
			<th>8일</th>
			<th>9일</th>
			<th>10일</th>
			<th>11일</th>
			<th>12일</th>
			<th>13일</th>
			<th>14일</th>
			<th>15일</th>
			<th>16일</th>
			<th>17일</th>
			<th>18일</th>
			<th>19일</th>
			<th>20일</th>
			<th>21일</th>
			<th>22일</th>
			<th>23일</th>
			<th>24일</th>
			<th>25일</th>
			<th>26일</th>
			<th>27일</th>
			<th>28일</th>
			<th>29일</th>
			<th>30일</th>
			<th>31일</th>
			<th>합계</th>
			</tr>
			</thead>
		<tbody id="mae_body"/>
	</table>
	</form>
</div>

	

</body>
</html>