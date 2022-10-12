<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%
	request.setCharacterEncoding("UTF-8");

	String contextPath = request.getContextPath();
	
	
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=1">
<meta charset="UTF-8">
<title>메인화면</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

			
		var prt_nm = "";
		var se_prt_cd = "";
		var se_prt_nm = "";
		var se_prt_dt_cd = "";
		
		
		//날짜 계산
		//일주일 전 
		var d = new Date();
		
		let weekDate = d.getTime() - (7*24*60*60*1000);
		d.setTime(weekDate);
	
		let weekYear = d.getFullYear();
		let weekMonth = d.getMonth() + 1;
		let weekDay = d.getDate();
	
		if(weekMonth < 10) {weekMonth = "0" + weekMonth};
		if(weekDay < 10) {weekDay = "0" + weekDay};
	
		let seven = weekYear + "-" + weekMonth + "-" + weekDay;
		
		//console.log(seven);
		
		//today
		var d = new Date();
	
		var year = d.getFullYear();
		var month = ('0' + (d.getMonth() + 1)).slice(-2);
		var day = ('0' + d.getDate()).slice(-2);
		
		var today = year + '-' + month  + '-' + day;
		
		//console.log(today);
		//날짜 계산 끝
	
		
		$(document).ready(function() {
			
			
			prt_cd_nm = $("#prt_cd_nm").val();						// 매장검색란의 value값을 받아온다
			se_prt_cd = $("#se_prt_cd").val();						// session 저장된 로그인유저의 매장코드
			se_prt_nm = $("#se_prt_nm").val();						// session 저장된 로그인유저의 매장명
			se_user_dt_cd = $("#se_user_dt_cd").val();				// session 저장된 로그인유저의 거래처구분코드
			

			//가입 날짜 세팅
			$("#jn_to").val(today);
			$("#jn_from").val(seven);
			$("#jn_to").attr("max",today);
			$("#jn_from").attr("max",today);
			
			//console.log(jn_to.value);
			//console.log(jn_from.value);
			
			defaultSearch();
			
			
			//사용자 구분 코드가 본사일 경우 신규 가입 버튼 막기
			if(se_user_dt_cd != 2 ) {									

				$("#newMem_btn").attr('disabled', true);				
				
			}
			
			
			//큰 돋보기 눌렀을 떄 함수 실행 
			$("#mainSearch").click(function(){
				mainTable();
			}); 
			
			
			//엔터시 바로 매장 찾는 함수 실행
	 		$("#prt_cd_nm").keydown(function(event){					
				if(event.keyCode == 13) { 									
					check_prt_data();			
					
				}
			});
			
	 		//엔터시 바로 고객 찾는 함수 실행
			$("#cust_no").keydown(function(event){					
				if(event.keyCode == 13) { 									
					check_cust_data();					
					
				}
			}); 
			
	 		//고객 옆 작은 돋보기 눌렀을 때 팝업
			$("#btn_cust").click(function(){
		
				popUp_cust();
						
			}); 
			
			//매장 옆 작은 돋보기 눌렀을 때 팝업
			$("#btn_prt").click(function(){

				popUp_prt();
				
			}); 
			

			
			//신규 가입 버튼
	 		$("#newMem_btn").click(function(){
	 			
	 			popUp_newCust();
	 		
	 		}); 
	 		
	 		
	 		
	 		//매장 명 지웠을때 매장 코드도 같이 없앤다
	 		$("#prt_cd_nm").keyup(function(event){                  
	 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
	 	            if( $("#prt_cd_nm").val() == "" ) {            
	 	               $("#prt_cd").val("");                  
	 	            } 
	
	 	         }
	 	      }); // end key up
	 		
	 		
	 	      
	 	   //고객명 지웠을때 고객 코드도 같이 없앤다
	 	 	$("#cust_no").keyup(function(event){                  
	 	 		if(event.keyCode == 8 || event.keyCode == 46) {  // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
	 	           if($("#cust_no").val() == "") {               
	 		             $("#cust_no_dis").val("");                     
	 		          }
	 	 	         
	 	 	       }
	 	 	 });// end key up
	 		
	 	 	      
	 	 	      
	 	 	     
	 	 	      
 	 	    //가입 날짜 유효성 검사용  
  	 	    $("#jn_to").change(function(){
 	 	    	  
		    	  var to = $("#jn_to").val();
		    	  var from = $("#jn_from").val();
			    	  
		    	  	//유효한 날짜인지 확인 용
			    	  if(!checkValidDate(to)){
			    		  
			    		  alert("유효한 날짜를 입력해주세요");
			    		  $("#jn_to").val("");
			    		  $("#jn_to").focus();
			    		  
			    		  return false;
			    		  
			    	  }
			    	  
					  var ch_to = new Date(to);
					  var ch_from = new Date(from);
	 				
					  //가입 앞 뒤 날짜를 비교함
			    	  if(ch_to < ch_from){
			    		  
			    		  alert("날짜 입력 값이 너무 적습니다. 다시 날짜를 찾아주세요.");
			    		  $("#jn_to").val("");
			    		  $("#jn_to").focus();

			    		  
			    		  return false;
			    	  } 
 	 	      
			}); // end change jn to
		
			
			 
		      $("#jn_from").change(function(){
			    	
		    	  	  var from = $("#jn_from").val();
		    		  var to = $("#jn_to").val();
		    		  
		    		  //유효한 날짜인지 확인 용
			    	  if(!checkValidDate(from)){
			    		  
			    		  alert("유효한 날짜를 입력해주세요");
			    		  $("#jn_from").val("");
			    		  $("#jn_from").focus();

			    		  return false;
			    	  }
						
			    	  
					  var ch_to = new Date(to);
					  var ch_from = new Date(from);
	 					
					  //가입 앞 뒤 날짜를 비교함
			    	  if(ch_to < ch_from){
			    		  
			    		  alert("날짜 값이 너무 많습니다. 다시 날짜를 찾아주세요.");
			    		  $("#jn_from").val("");
			    		  $("#jn_from").focus();
			    		  
			    		  return false;
			    		  
			    	  } 
		    	  
		    	  
			      
			}); // end change jn from 가입 날짜 유효성 검사
	 
	
	
 	 	      
 	 	      
	 }); //document ready end
		 
		 
		// 기본 조건 함수
		function defaultSearch() {
			
			$("#cust_no_dis").val("");								
			$("#cust_no").val("");									
			
			$('input:radio[id=all]').prop("checked", true);
			
			if(prt_nm == '' && se_user_dt_cd == 2 ) {				
				$("#prt_cd").val(se_prt_cd);				
				$("#prt_cd_nm").val(se_prt_nm);				
			} 
			
			console.log(se_user_dt_cd);
		} //default end
		
		
		
		
		//리프레쉬 버튼
		function refresh(){ 
			
			prt_cd_nm = $("#prt_cd_nm").val();						// 매장검색란의 value값을 받아온다
			se_prt_cd = $("#se_prt_cd").val();						// session 저장된 로그인유저의 매장코드
			se_prt_nm = $("#se_prt_nm").val();						// session 저장된 로그인유저의 매장명
			se_user_dt_cd = $("#se_user_dt_cd").val();
			
			
			//사용자 구분 코드가 본사 일 경우 매장 코드와 매장명을 날림
			if(se_user_dt_cd == 1){
				$("#prt_cd").val("");								
				$("#prt_cd_nm").val("");
				
			}else{
			
			$("#prt_cd").val(se_prt_cd);								
			$("#prt_cd_nm").val(se_prt_nm);
			}
			
			$("#cust_no_dis").val("");								
			$("#cust_no").val("");	
			
			$('input:radio[id=all]').prop("checked", true);
			
			$("#jn_to").val(today);
			$("#jn_from").val(seven);
			
			$("#main_body").hide();
			
		} //refresh end
		
	
		 
		 //가입 날짜 유효성 검사용
		 function checkValidDate(value) {
				var result = true;
				try {
				    var date = value.split("-");
				    var y = parseInt(date[0], 10),
				        m = parseInt(date[1], 10),
				        d = parseInt(date[2], 10);
				    
				    var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
				    result = dateRegex.test(d+'-'+m+'-'+y);
				} catch (err) {
					result = false;
				}    
			    return result;
			}
		 
		
		
		
			//큰 돋보기 클릭 시 조회
			function mainTable(){
				
			 $("#main_body").show();
			 
				var prt_cd = $("#prt_cd").val();
				var prt_cd_nm = $("#prt_cd_nm").val();
				var cust_no_dis = $("#cust_no_dis").val();
				var cust_no = $("#cust_no").val();
				var cust_ss_cd = $('input:radio[name=cust_ss_cd]:checked').val();
				var jn_from = $("#jn_from").val();
				var jn_to = $("#jn_to").val();
				
				
				 // 고객 두자 이하 팝업
		 		if(cust_no.trim() != '' && cust_no.trim().length < 2) {
					alert('고객 번호나 이름을 두글자 이상 입력하세요.');
					$('#cust_no').focus();
					return false;
				 } 
				
				 //가입 날짜 없으면 팝업
				if(jn_to == '' || jn_from == ''){
					alert('날짜가 맞는지 다시 확인 바랍니다.');
					return false;
				}
	
		 		
			$.ajax({
				url:"<%= request.getContextPath()%>/search/shopcust",
				data: {"prt_cd": prt_cd,
						"prt_cd_nm":prt_cd_nm,
						"cust_no_dis":cust_no_dis,
						"cust_no":cust_no,
						"prt_cd_nm":prt_cd_nm,
						"cust_ss_cd":cust_ss_cd,
						"jn_from":jn_from,
						"jn_to":jn_to} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					let html = "";
					if(json.length > 0){
						$.each(json,function(index, item){
							
							html += "<tr style='width: 100%;'>";
							html += "<td class='left' id='CUST_NO'>"+item.CUST_NO+"<button id='cust_his' onclick='custHist("+JSON.stringify(item)+")'>변경이력</button></td>";
							html += "<td class='left' id='CUST_NM'>"+item.CUST_NM+"<button id='cust_mod' onclick='custMod("+item.CUST_NO+")'>상세</button></td>";
							html += "<td class='center' id='MBL_NO'>"+item.MBL_NO+"</td>";
							html += "<td class='center' id='CUST_SS_CD'>"+item.CUST_SS_CD+"</td>";
							html += "<td class='center' id='JS_DT'>"+item.JS_DT+"</td>";
							html += "<td class='left' id='PRT_NM'>"+item.PRT_NM+"</td>";
							html += "<td class='left' id='USER_NM'>"+item.USER_NM+"</td>";
							html += "<td class='center' id='LST_UPD_DT'>"+item.LST_UPD_DT+"</td>";
							html += "</tr>";
							
						});
					}
					else {
						html += "<tr>";
						html += "<td  colspan='8' class='center'>검색조건에 맞는 고객이 존재하지 않습니다.</td>";
						html += "</tr>";
					}
					
					$("tbody#main_body").html(html);					
		
				},
				error: function( error){
					
					alert("실패"+ error);
				}
					
			});
			
		} // main table () end
	
		
	
				
			// 엔터 or 클릭시 매장 데이타 검색
			 function check_prt_data(){
				
				var check_prt = $("#prt_cd_nm").val();
				
				//매장명에 값이 있는데 두자 미만일경우
				if(check_prt.trim() != '' && check_prt.trim().length < 2) {
						alert('매장 코드나 매장 이름을 두글자 이상 입력하셔야 합니다.');
						$('#prt_cd_nm').focus();
						return false;
				}
				
				$.ajax({
					url:"<%= request.getContextPath()%>/search/searchshop6",
					data: {"in_prt": check_prt} ,
					type: 'post',
					dataType: "JSON",
					async: false,
					success: function(json){
						console.log(json);
						//alert("성공");
						if(json.length == 1){
							var prtCd = json[0].PRT_CD; // => 매장값 꺼냄
							var prtNm = json[0].PRT_NM; // => 매장명 꺼냄
							
							$('#prt_cd').val(prtCd);
							$('#prt_cd_nm').val(prtNm);
							
						} else {
							alert('일치하는 값이 없거나 두개 이상입니다');
							popUp_prt();
						}
			
					},
					error: function( error){
						
						alert("전송 실패");
					}
						
				}); 
				
			}//end check_prt_data
		
		
		
			
		
	
		// 엔터 클릭시 회원 이름 가져오기
		function check_cust_data() {
			
			var check_cust = $("#cust_no").val();
			var mbl_no = "";
			//console.log(check_cust);
			
			//고객명에 값이 있는데 자릿수가 두자 미만 일 경우
			 if(check_cust.trim() != '' && check_cust.trim().length < 2) {
				alert('고객 번호나 이름을 두글자 이상 입력하세요.');
				$('#cust_no').focus();
				return false;
			 } 
			 
			
			$.ajax({
				url:"<%= request.getContextPath()%>/search/searchcust4",
				data: {"cust_nm": check_cust,
					"mbl_no" : mbl_no} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					if(json.length == 1){
						var custNo = json[0].CUST_NO; // => 매장값 꺼냄
						var custNm = json[0].CUST_NM; // => 매장명 꺼냄
						
						$('#cust_no_dis').val(custNo);
						$('#cust_no').val(custNm);
						
					} else {
						alert('일치하는 값이 없거나 두개 이상입니다');
						popUp_cust();
					}
	
				},
				error: function( error){
					
					alert("전송 실패");
				}
					
			}); 
			
		
		} //end check_cust_data
	
		
	 	
		
		//5번 페이지 
		function custHist(item){
			
				var cust_his =item.CUST_NO;
				$("#cust_history").val(cust_his);
				popUp_detail(item); 
			
		}
		
		
		//2번 상세 페이지
		function custMod(CUST_NO){
			
			var cust_mod = CUST_NO;
			$("#cust_mod").val(cust_mod);
			
			//popUp_mod(cust_mod);
			location.href = 'http://localhost:8080/gwaje/search/custmod?cust_mod=' + cust_mod;
			
		}
		
		
		
		
		//팝팝
		function popUp_prt(){
			
			var url = "http://localhost:8080/gwaje/search/searchshop";
			var title = "popUp_prt";
			var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
			window.open(url, title, status);
			
		}
		
		function popUp_cust(){
			
			var url = "http://localhost:8080/gwaje/search/customer";
			var title = "popup_cust";
			var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
			window.open(url, title, status);
		}
		
		
	 	function popUp_detail(item){

			  var salDtPop= document.salDtPop;    
			  var url = 'http://localhost:8080/gwaje/search/custdetail';
			  var title = "popup";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=1010, height=600, top=100,left=250";
			  window.open('',title,status);            
			  dtPop.action = url;     
			  dtPop.target = title; //window,open()의 두번째 인수와 같아야 하며 필수다.  
			  dtPop.method="post"; 
			  dtPop.CUST_NO.value = item.CUST_NO;    
			  dtPop.CUST_NM.value = item.CUST_NM;
			  dtPop.submit(); 
			  
		} 
	 	
	 	
	 	function popUp_newCust(){
			  var url = "http://localhost:8080/gwaje/search/newcust";
			  var title = "popup";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=900, height=800, top=80,left=300"; 
			  //alert(cust_his);
			  window.open(url,title,status);
			  
		} 
	 	
	 	
	 	//빈값 체크
	 	function isEmpty(value){
	 		if(value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length)){
	 			return true
	 		} else {
	 			return false
		}
	 	
	 }// 빈 값 체크 end
		
	

	
	

</script>
</head>
<body>
<div style="width: 70%; margin-top:20px; margin-left:170px;">
	<table style="padding-bottom: 10px;">
		<tr>
			<td><img src="../resources/image/star.jpg" height ="15" width="15"></td>
			<th>고객조회</th>
			<td><button id="refresh" onclick="refresh()"><img src="../resources/image/refresh.png" height ="15" width="15"></button></td>
		</tr>
	
	</table>
	
	<table id="check_cust">
	<tr>
		<td>매장<input type="text" name="prt_cd" id="prt_cd" class="prt" disabled>
		<button type="button" id="btn_prt" ><img src="../resources/image/dott.png" id="search_shop"></button>
		<input type="text" class="prt_22" name="prt_cd_nm" id="prt_cd_nm"  autofocus></td>
		<td>고객번호<input type="text" name="cust_no_dis" id="cust_no_dis" disabled>
		<button type="button" id="btn_cust" ><img src="../resources/image/dott.png" id="search_cust"></button>
		<input type="text" name="cust_no" id="cust_no" style="width:135px;"></td>
		<td><button type="button" id="mainSearch" ><img src="../resources/image/dott.png" id="sub_btn"></button></td>
	</tr>
	<tr>
		<td ><i class="redstar" style="color:red;">*</i>고객상태
			<input class="gogek" type="radio" value="" name="cust_ss_cd" id="all" checked>전체
			<input class="gogek" type="radio" value="10" name="cust_ss_cd">정상
			<input class="gogek" type="radio" value="80" name="cust_ss_cd">중지
			<input class="gogek" type="radio" value="90" name="cust_ss_cd">해지
		</td>
		<!-- <td>가입일자<input type="date" name="js_dt"><input type="date" name="js_dt"></td> -->
		
		<td><i class="redstar" style="color:red;">*</i>가입일자<input type="date" class="Text_date" id="jn_from" width="10px;">
			<input type="date" class="Text_date" id="jn_to" ></td> 
		</tr>
		
	</table>
	
	<input type="button" name="newMember" id="newMem_btn" value="신규등록" />
		

		</div>
		
		<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" />
		<input type="hidden" name="se_user_dt_cd" id="se_user_dt_cd" value="${sessionScope.member.user_dt_cd}" />
		<input type="hidden" name="se_prt_nm" id="se_prt_nm" value="${sessionScope.member.prt_nm}" />
		<input type="hidden" name="cust_history" id="cust_history" value="" />
		<input type="hidden" name="cust_mod" id="cust_mod" value="" />
		


	<div id="mainTable" style="overflow:auto; width:70%; height:300px; margin-top:20px; margin-left:170px;  clear: both;" >
	<table border="1" id="first_table" >
		<thead id="main_table">
		<tr id="first_tbl_tr">
			<th class='center'>고객번호</th>
			<th class='center'>고객이름</th>
			<th class='center'>휴대폰번호</th>
			<th class='center'>고객상태</th>
			<th class='center'>가입일자</th>
			<th class='center'>가입매장</th>
			<th class='center'>등록자</th>
			<th class='center'>수정일자</th>
		</tr>
		</thead>
		<tbody id="main_body"/>
	</table>
	</div>
	
	
		<form name="dtPop">
		<input type="hidden" name="CUST_NO">
		<input type="hidden" name="CUST_NM">
		</form>

</body>
</html>