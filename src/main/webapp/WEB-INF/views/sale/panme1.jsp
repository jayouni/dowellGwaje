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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/common.css?ver=1">
<meta charset="UTF-8">
<title>고객판매조회</title>
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
			
			
		  	var prt_cd = $("#prt_cd").val();
			var prt_cd_nm = $("#prt_cd_nm").val();
			var se_user_nm = $("#se_user_nm").val();
			var se_prt_cd = $("#se_prt_cd").val();								// session 저장된 로그인유저의 매장코드
			var se_prt_cd_nm = $("#se_prt_nm").val();							// session 저장된 로그인유저의 매장명
			var se_user_dt_cd = $("#se_user_dt_cd").val(); 
			
			//화면에 세션 값 넣기
			$("#prt_cd").val(se_prt_cd);
			$("#prt_cd_nm").val(se_prt_cd_nm);
		
			//판매일자세팅 날짜 
			$("#sal_to").val(today);
			$("#sal_from").val(seven);
			$("#sal_from").attr("max",today);
			
			console.log("session" + se_user_dt_cd);
			console.log("sess se_prt_cd" + se_prt_cd);
			console.log("ssee se_prt_cd_nm" + se_prt_cd_nm);
			
			//판매 등록 버튼
			$("#panmeBtn").click(function(){
				popUp_sugum2();
			});
			
			
			//본사 로그인 일때
			if(se_user_dt_cd == 1 ) {
				$("#prt_cd").val("");
				$("#prt_cd_nm").val("");
				$("#panmeBtn").attr('disabled', true);
				$("#prt_cd").attr('disabled', true);
				$("#cust_no_dis").attr('disabled', true);
				$("#prtBtn").attr('disabled', false);
				$("#prt_cd_nm").attr('disabled', false);
				
			}
			
			//매장 로그인 일때
			if(se_user_dt_cd == 2 ) {									
				$("#cust_no_dis").attr('disabled', true);
				$("#prt_cd").attr('disabled', true);
				$("#prtBtn").attr('disabled', true);
				$("#prt_cd_nm").attr('disabled', true);
				
			}

			
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
	 	      
	 	      
	 	      
			//큰 돋보기 버튼
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
			$("#custBtn").click(function(){
				
				popUp_cust();
						
			}); 
			
			//매장 옆 작은 돋보기 눌렀을 때 팝업
			$("#prtBtn").click(function(){
				
				popUp_prt();
			}); 
			
			
			//refresh
			$("#refresh").click(function(){
				
				refresh();
			}); 
			
			
			
 	 	    // 날짜 유효성 검사용  
  	 	    $("#sal_to").change(function(){
 	 	    	  
		    	  var to = $("#sal_to").val();
		    	  var from = $("#sal_from").val();
			    	  
		    	  	//유효한 날짜인지 확인 용
			    	  if(!checkValidDate(to)){
			    		  
			    		  alert("유효한 날짜를 입력해주세요");
			    		  $("#sal_to").val("");
			    		  $("#sal_to").focus();
			    		  
			    		  return false;
			    		  
			    	  }
			    	  
					  var ch_to = new Date(to);
					  var ch_from = new Date(from);
	 				
					  //앞 뒤 날짜를 비교함
			    	  if(ch_to < ch_from){
			    		  
			    		  alert("날짜 입력 값이 너무 적습니다. 다시 날짜를 찾아주세요.");
			    		  $("#sal_to").val(today);
			    		  $("#sal_to").focus();

			    		  
			    		  return false;
			    	  } 
 	 	      
			}); // end change sal to
		
			
			 
		      $("#sal_from").change(function(){
			    	
		    	  	  var from = $("#sal_from").val();
		    		  var to = $("#sal_to").val();
		    		  
		    		  //유효한 날짜인지 확인 용
			    	  if(!checkValidDate(from)){
			    		  
			    		  alert("유효한 날짜를 입력해주세요");
			    		  $("#sal_from").val("");
			    		  $("#sal_from").focus();

			    		  return false;
			    	  }
						
			    	  
					  var ch_to = new Date(to);
					  var ch_from = new Date(from);
	 					
					  // 앞 뒤 날짜를 비교함
			    	  if(ch_to < ch_from){
			    		  
			    		  alert("날짜 값이 너무 많습니다. 다시 날짜를 찾아주세요.");
			    		  $("#sal_from").val(seven);
			    		  $("#sal_from").focus();
			    		  
			    		  return false;
			    		  
			    	  } 
		    	  
		    	  
			      
			}); // end change sal from 날짜 유효성 검사
			
			
		}); //document ready end
		
		
		
		//리프레쉬 버튼
		function refresh(){
			var se = $("#se_user_dt_cd").val(); 
			
			$("#sal_to").val(today);
			$("#sal_from").val(seven);
			$("tbody#main_body").html('');	
			
			if(se == 1){
				$("#prt_cd").val("");
				$("#prt_cd").prop("disabled",true);
				$("#prt_cd_nm").val("");
				$("#cust_no_dis").val("");
				$("#cust_no").val("");
				
				$("#prt_cd_nm").focus();
			}else{
				$("#cust_no_dis").val("");
				$("#cust_no").val("");
				$("#cust_no").focus();
			}
			
			
			$("#totSalQty").text('');
			$("#totSalAmt").text('');
			$("#cshStlmAmt").text('');
			$("#crdStlmAmt").text('');
			$("#pntStlmAmt").text('');
			
		}
		
		
		
		//큰 돋보기 클릭 시 조회
		function mainTable(){
			
		 
			var prt_cd = $("#prt_cd").val();
			var prt_cd_nm = $("#prt_cd_nm").val();
			var cust_no_dis = $("#cust_no_dis").val();
			var cust_no = $("#cust_no").val();
			var sal_from = $("#sal_from").val();
			var sal_to = $("#sal_to").val();
			
			
			
			 //가입 날짜 없으면 팝업
			if(sal_to == '' || sal_from == ''){
				alert('날짜가 맞는지 다시 확인 바랍니다.');
				return false;
			}
			 
			if(prt_cd == '' ){
				alert('매장 입력은 필수 입니다.');
				$("#prt_cd_nm").focus();
				return false;
			}
			 

	 		
		$.ajax({
			url:"<%= request.getContextPath()%>/search/panmeFirst",
			data: {"prt_cd": prt_cd,
					"cust_no_dis":cust_no_dis,
					"sal_from":sal_from,
					"sal_to":sal_to} ,
			type: 'post',
			dataType: "JSON",
			async: false,
			success: function(json){
				console.log('panmeFirst success');
				console.log(json);
				//alert("성공");
				let html = "";
				let hap = "";
				if(json.length > 0){
					var totSalQty = 0;
					var totSalAmt = 0;
					var cshStlmAmt = 0;
					var crdStlmAmt = 0;
					var pntStlmAmt = 0;
					
					var prtCd = $('#prt_cd').val();
					var prtNm = $('#prt_cd_nm').val();
					
					$.each(json,function(index, item){
						
						var rtnFontStyle = "";
						
						var a = item.TOT_VAT_AMT;
						var b = item.TOT_VOS_AMT;
						console.log("vat : "+ a);
						console.log("vos : "+ b);
						
						item.PRT_CD = prtCd;
						item.PRT_NM = prtNm;
						
						if(item.SAL_TP_CD == 'SAL'){
							totSalQty += parseInt(item.TOT_SAL_QTY);
							totSalAmt += parseInt(item.TOT_SAL_AMT);
							cshStlmAmt += parseInt(item.CSH_STLM_AMT);
							crdStlmAmt += parseInt(item.CRD_STLM_AMT);
							pntStlmAmt += parseInt(item.PNT_STLM_AMT);
						}
						
						
						if(item.SAL_TP_CD == 'RTN') {
							rtnFontStyle = "style='color: red;'";
							totSalQty -= parseInt(item.TOT_SAL_QTY);
							totSalAmt -= parseInt(item.TOT_SAL_AMT);
							cshStlmAmt -= parseInt(item.CSH_STLM_AMT);
							crdStlmAmt -= parseInt(item.CRD_STLM_AMT);
							pntStlmAmt -= parseInt(item.PNT_STLM_AMT);
						}
						
						html += "<tr style='width: 100%;'>";
						html += "<td class='center' id='SAL_DT'>"+item.SAL_DT+"</td>";
						html += "<td class='center' id='CUST_NO'>"+item.CUST_NO+"</td>";
						html += "<td class='center' id='CUST_NM'>"+item.CUST_NM+"</td>";
						html += "<td class='center' id='SAL_NO'>"+item.SAL_NO+"&nbsp;<button id='sangBtn' onclick='sangse("+JSON.stringify(item)+")'>상세</button></td>";
						html += "<td class='right' id='TOT_SAL_QTY' " + rtnFontStyle + ">"+item.TOT_SAL_QTY+"</td>";
						html += "<td class='right' id='TOT_SAL_AMT' " + rtnFontStyle + ">"+addComma(item.TOT_SAL_AMT)+"</td>";
						html += "<td class='right' id='CSH_STLM_AMT'>"+addComma(item.CSH_STLM_AMT)+"</td>";
						html += "<td class='right' id='CRD_STLM_AMT'>"+addComma(item.CRD_STLM_AMT)+"</td>";
						html += "<td class='right' id='PNT_STLM_AMT'>"+addComma(item.PNT_STLM_AMT)+"</td>";
						html += "<td class='center' id='FST_USER_NM'>"+item.FST_USER_NM+"</td>";
						html += "<td class='center' id='FST_REG_DT'>"+item.FST_REG_DT+"</td>";
						html += "</tr>";
						
					});
					
					$("#totSalQty").text(totSalQty);
					$("#totSalAmt").text(addComma(totSalAmt));
					$("#cshStlmAmt").text(addComma(cshStlmAmt));
					$("#crdStlmAmt").text(addComma(crdStlmAmt));
					$("#pntStlmAmt").text(addComma(pntStlmAmt));
				}
				else {
					html += "<tr>";
					html += "<td  colspan='12' class='center'>검색조건에 맞는 고객이 존재하지 않습니다.</td>";
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
	
	
	
	function sangse(item){
		//console.log('sangse 실행?');
		//console.log(JSON.stringify(item));
		//console.log(item.PRT_CD + " : " + item.PRT_NM);
		popUp_sangse3(item);
			
			
	}
	
		
	

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
	
	
	
	
	
		function popUp_sugum2(){
			  var url = "http://localhost:8080/gwaje/sale/sugumPopup";
			  var title = "popup";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=1110, height=800, top=80,left=170"; 
			  //alert(cust_his);
			  window.open(url,title,status);
			  
		} 
	
	
	
	 	function popUp_sangse3(item){
			  
			  var salDtPop= document.salDtPop;    
			  var url = 'http://localhost:8080/gwaje/sale/sangsePopup';
			  var title = "popup";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=990, height=800, top=80,left=300";
			  window.open('',title,status);            
			  salDtPop.action = url;     
			  salDtPop.target = title; //window,open()의 두번째 인수와 같아야 하며 필수다.  
			  salDtPop.method="post";    
			  salDtPop.PRT_CD.value = item.PRT_CD;    
			  salDtPop.PRT_NM.value = item.PRT_NM;
			  salDtPop.CUST_NO.value = item.CUST_NO;
			  salDtPop.CUST_NM.value = item.CUST_NM;
			  salDtPop.SAL_DT.value = item.SAL_DT;
			  salDtPop.SAL_NO.value = item.SAL_NO;
			  salDtPop.TOT_SAL_QTY.value = item.TOT_SAL_QTY;
			  salDtPop.TOT_SAL_AMT.value = addComma(item.TOT_SAL_AMT);
			  salDtPop.TOT_VOS_AMT.value = item.TOT_VOS_AMT;
			  salDtPop.TOT_VAT_AMT.value = item.TOT_VAT_AMT;
			  salDtPop.CSH_STLM_AMT.value = addComma(item.CSH_STLM_AMT);
			  salDtPop.CRD_STLM_AMT.value = addComma(item.CRD_STLM_AMT);
			  salDtPop.PNT_STLM_AMT.value = addComma(item.PNT_STLM_AMT);
			  salDtPop.CRD_NO.value = item.CRD_NO;
			  salDtPop.VLD_YM.value = item.VLD_YM;
			  salDtPop.CRD_CO_CD.value = item.CRD_CO_CD;
			  salDtPop.FST_USER_ID.value = item.FST_USER_ID;
			  salDtPop.FST_REG_DT.value = item.FST_REG_DT;
			  salDtPop.RTN_USE_YN.value = item.RTN_USE_YN;
			  salDtPop.submit();  
			  
		} 
	 	
	 	
	 	
	 	function popUp_jego4(){
			  var url = "http://localhost:8080/gwaje/sale/jegoPopup";
			  var title = "popup";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=900, height=800, top=80,left=300"; 
			  //alert(cust_his);
			  window.open(url,title,status);
			  
		} 
		

		//천단위 콤마 추가
		function addComma(obj){
			var result = obj.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	        return result;
		}
		
		//천단위 콤마 제거
		function removeComma(obj){
			var result = obj.toString().replace(/,/gi, "");
	        return result;
		}
		
		
		 //날짜 유효성 검사용
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



</script>
</head>
<body>
<div style="width: 70%; margin-top:20px; margin-left:170px;">
	<table style="padding-bottom: 10px;">
		<tr>
			<td><img src="../resources/image/star.jpg" height ="15" width="15"></td>
			<th>고객판매관리</th>
			<td><button id="refresh" onclick="refresh()"><img src="../resources/image/refresh.png" height ="15" width="15"></button></td>
		</tr>
	
	</table>
	
	<table id="check_cust">
	<tr>
		<td><i class="redstar" style="color:red;">*</i>판매일자<input type="date" name="sal_from" id="sal_from"  style="margin-right: 44px;
    width: 131px; margin-left: 8px;"><input type="date" name="sal_to" id="sal_to" class="" style="width: 138px;" >
		<td><i class="redstar" style="color:red;">*</i>매장<input type="text" name="prt_cd" id="prt_cd" style="margin-left: 8px; width: 140px;"disabled>
		<button type="button" id="prtBtn" ><img src="../resources/image/dott.png" id="search_cust"></button>
		<input type="text" name="prt_cd_nm" id="prt_cd_nm" style="width:135px;"></td>
		<td><button type="button" id="mainSearch" ><img src="../resources/image/dott.png" id="sub_btn"></button></td>
	</tr>
	<tr>
		<td>고객번호<input type="text" name="cust_no_dis" id="cust_no_dis" style="margin-left:14px;width:129px;">
			<button type="button" id="custBtn" ><img src="../resources/image/dott.png" id="search_cust"></button>
			<input type="text" name="cust_no" id="cust_no" style="width:135px;">
		</td>
		</tr>
		
	</table>
	
	<input type="button" name="panmeBtn" id="panmeBtn" value="판매등록"  style="float:right; "/>
		

		</div>
		
		<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" />
		<input type="hidden" name="se_user_dt_cd" id="se_user_dt_cd" value="${sessionScope.member.user_dt_cd}" />
		<input type="hidden" name="se_prt_nm" id="se_prt_nm" value="${sessionScope.member.prt_nm}" />
		<input type="hidden" name="toSangse" id="toSangse" value="" />
		


	<div id="mainTable" style="overflow:auto; width:70%; height:300px; margin-top:20px; margin-left:170px; clear:both;" >
	<table border="1" id="first_table" >
		<thead id="main_table">
		<tr id="first_tbl_tr">
			<th class='center' rowspan="2">판매일자</th>
			<th class='center' rowspan="2">고객번호</th>
			<th class='center' rowspan="2">고객명</th>
			<th class='center' rowspan="2">판매번호</th>
			<th class='center' colspan="2">판매</th>
			<th class='center' colspan="3">수금</th>
			<th class='center' rowspan="2">등록자</th>
			<th class='center' rowspan="2">등록시간</th>
		</tr>
		<tr style="position:sticky;top:0;top:25px;">
		<th >수량</th>
		<th >금액</th>
		<th >현금</th>
		<th >카드</th>
		<th >포인트</th>
		</tr>
		</thead>
		<tbody id="main_body"/>
	</table>
	</div>
	<div style="margin-left:170px;width:70%">
		<table style="border: 2px solid #00c8ff; width:1046px ;text-align:center;">
			<tr id="hapgye">
				<td class="center border_left" style="width:425px; border-right:1px solid #00c8ff;">합계</td>
				<td class="right" id="totSalQty" style="width:48px; border-right:1px solid #00c8ff;"></td>
				<td class="right" id="totSalAmt" style="width:97px; border-right:1px solid #00c8ff;"></td>
				<td class="right" id="cshStlmAmt" style="width:99px; border-right:1px solid #00c8ff;"></td>
				<td class="right" id="crdStlmAmt" style="width:82px; border-right:1px solid #00c8ff;"></td>
				<td class="right" id="pntStlmAmt" style="width:69px; border-right:1px solid #00c8ff;"></td>
				<td class="right" style="width:69px; border-right:1px solid #00c8ff;"></td>
				<td class="right"></td>
			</tr>
		</table>
	</div>
	
	<form name="salDtPop">
		<input type="hidden" name="PRT_CD">
		<input type="hidden" name="PRT_NM">
		<input type="hidden" name="CUST_NO">
		<input type="hidden" name="CUST_NM">
		<input type="hidden" name="SAL_DT">
		<input type="hidden" name="SAL_NO">
		<input type="hidden" name="TOT_SAL_QTY">
		<input type="hidden" name="TOT_SAL_AMT">
		<input type="hidden" name="TOT_VOS_AMT">
		<input type="hidden" name="TOT_VAT_AMT">
		<input type="hidden" name="CSH_STLM_AMT">
		<input type="hidden" name="CRD_STLM_AMT">
		<input type="hidden" name="PNT_STLM_AMT">
		<input type="hidden" name="CRD_NO">
		<input type="hidden" name="VLD_YM">
		<input type="hidden" name="CRD_CO_CD">
		<input type="hidden" name="FST_USER_ID">
		<input type="hidden" name="FST_REG_DT">
		<input type="hidden" name="RTN_USE_YN">
	</form>
</body>
</html>