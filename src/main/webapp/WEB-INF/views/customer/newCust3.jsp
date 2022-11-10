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
<title>신규고객등록3</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	
	//한글 있는지 체크
	const kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	//이메일 체크
	var regExp = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
	
	//날짜용
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);

	var dateString = year + '-' + month  + '-' + day;

	//console.log(dateString);

	$(document).ready(function() {
		
		//생년월일 캘린더에서 선택 할때 미래일자 선택 불가처리
		$("#brdy_dt").prop("max", dateString);
		
		//부모창에 매장코드 및 매장명 값 가져오기
		var prt_cd =  opener.$("#prt_cd").val();
		var prt_cd_nm = opener.$("#prt_cd_nm").val();
		
		//부모창에 매장코드 및 매장명 값 넣어주기
		$("#prt_cd").val(prt_cd); 
		$("#prt_cd_nm").val(prt_cd_nm); 
		
		//들어올때 이름에 포커스
		$("#cust_nm").focus();
		
		
		//매장 입력 엔터 눌렀을때 이벤트 처리
 		$("#prt_cd_nm").keydown(function(event){					
			if(event.keyCode == 13) { 									
				checkPrt();			
			}
		});
 		
		
		//닫기 버튼 눌렀을때
		$("#datgi").click(function() {
			
			window.close();
		});
		
		//부모 창 닫을시 팝업창 닫기
 	    $(opener).one('beforeunload', function() {                    
			window.close();                                      
		});

		
		//생일 키인 시 유효성 
		$("#brdy_dt").keyup(function() {
			var dt = $("#brdy_dt").val();
			
			var cv_dt = new Date(dt);
			var nw_dt = new Date();
			
			if(nw_dt < cv_dt) {
				alert("생년월일은 당일 포함 이전으로만 선택 가능합니다.");
				$("#brdy_dt").val('');
				$("#brdy_dt").focus();
			}
			
		}); // end key up brdy_dt
		
		
		
	 	  //생일 날짜 유효성  
 	      $("#brdy_dt").change(function(){
	    	  
	    	  var bd = $("#brdy_dt").val();
	    	  
	    	  if(!checkValidDate(bd)){
	    		  
	    		  alert("유효한 날짜를 입력해주세요");
	    		  $("#brdy_dt").val("");
	    		  $("#brdy_dt").focus();
	    		  
	    		  return false;
	    		  
	    	  }
	      
		}); // end change brdy_dt
		
		
		
	 	    //결혼 기념일 날짜 유효성  
 	      $("#mrrg_dt").change(function(){
	    	  
	    	  var mr = $("#mrrg_dt").val();
	    	  
	    	  if(!checkValidDate(mr)){
	    		  
	    		  alert("유효한 날짜를 입력해주세요");
	    		  $("#mrrg_dt").val("");
	    		  $("#mrrg_dt").focus();
	    		  
	    		  return false;
	    		  
	    	  }
	      
		}); // end change mrrg_dt
		
		
		
		
		
		//휴대폰인증 중복 버튼 눌렀을때 처리
		$("#dupBtn").click(function() {
			//휴대폰번호 값 가져오기
			var mbl_no1 = $("#mbl_no1").val();
			var mbl_no2 = $("#mbl_no2").val();
			var mbl_no3 = $("#mbl_no3").val();
			
			var mbl_no = mbl_no1 + mbl_no2 + mbl_no3;
			
			//핸드폰이 비어있을때
			if(mbl_no1 == ''){
				alert("핸드폰 앞자리가 비어있습니다.")
				$("#mbl_no1").focus();
				return false;
			}
			
			//핸드폰 앞자리 세자리 맞추기
			if(mbl_no1.length < 3){
				alert("핸드폰 앞자리는 꼭 세자리가 필요합니다.")
				$("#mbl_no1").focus();
				return false;
			}
			
			//핸드폰 가운데 비어있을때
			if(mbl_no2 == ''){
				alert("핸드폰 가운데 자리가 비어있습니다.")
				$("#mbl_no2").focus();
				return false;
			}
			
			//핸드폰 가운데자리 세자리 미만 
			if(mbl_no2.length < 3){
				alert("핸드폰 가운데 자리는 3-4자리 입력해주세요.")
				$("#mbl_no2").focus();
				return false;
			}
			
			//핸드폰 뒷자리 비어있을떄
			if(mbl_no3 == ''){
				alert("핸드폰 뒷 자리가 비어있습니다.")
				$("#mbl_no3").focus();
				return false;
			}
			
			//핸드폰 뒷자리 4자리 미만일때
			if(mbl_no3.length < 4){
				alert("핸드폰 뒷 자리는 꼭 4자리가 필요합니다.")
				$("#mbl_no3").focus();
				return false;
			}
			
			console.log(mbl_no);
			
			 $.ajax({
				url:"<%= request.getContextPath()%>/search/checkMblNo",
				data: {"mbl_no": mbl_no} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					if(json.CNT == 0){
					   alert("사용 가능한 번호 입니다.");
					   $("#chkMblBtn").val("확인");
					}
					
					if(json.CNT == 1){
						
						alert("중복된 번호가 있습니다.");
						$("#mbl_no1").val("");
						$("#mbl_no2").val("");
						$("#mbl_no3").val("");
						
					} 
		
				},
				error: function( error){
					
					alert("실패"+ error);
				}
					
			});
			
		}); //핸드폰 중복 enda
		

		
		
 		//매장 값 지웠을때 코드 
 		$("#prt_cd_nm").keyup(function(event){    
 			
 			var prt = $("#prt_cd_nm").val();
 			
 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
 	            if( $("#prt_cd_nm").val() == "" ) {            
 	               $("#prt_cd").val("");
 	               $("#checkPrt").html("매장을 선택해주세요");
 	              $("#checkPrt").css("color","red");
 	            }
 	         }
 	         
 	         if(prt != ''){
 	        	$("#checkPrt").html("");
 	         }

 	         
 	      }); // end key up
		
		
		
		
		//등록 버튼 눌렀을때
		$("#dengrok").click(function() {
			
			//validation 용 값 가져오기
			var name = $("#cust_nm").val();
			var cd = $("#poc_cd option:selected").val();
			var bd = $("#brdy_dt").val();
			var no1 = $("#mbl_no1").val();
			var no2 = $("#mbl_no2").val();
			var no3 = $("#mbl_no3").val();
			var em = $("#email").val();
			var emdt = $("#email_dtl").val();
			var add = $("#addr").val();
			var addt = $("#addr_dtl").val();
			var ptcd = $("#prt_cd").val();
			var ptnm = $("#prt_cd_nm").val();
			var mblBtn = $("#chkMblBtn").val();
			var emcheck = $("#email").val() + "@" + $("#email_dtl").val();
			
			//console.log("email" + emcheck);
			
			//validaion starts
			//이름이 없을때
			if(name == ''){
				alert("이름을 꼭 써주세요.");
				$("#cust_nm").focus();
				return false;
			}
			
			//직업을 체크 하지 않았을때
			if(cd == ''){
				alert("직업을 꼭 선택해 주세요.");
				$("#poc_cd").focus();
				return false;
			}
			
			//생일이 비어있을때
			if(bd == ''){
				alert("생일을 체크해주세요.");
				$("#brdy_dt").focus();
				return false;
				
			}
			
			
			//핸드폰이 앞자리 비어있을때
			if(no1 == ''){
				alert("핸드폰 앞자리가 비어있습니다.")
				$("#mbl_no1").focus();
				return false;
			}
			
			//핸드폰이 가운데 비어있을때
			if(no2 == ''){
				alert("핸드폰 가운데 자리가 비어있습니다.")
				$("#mbl_no2").focus();
				return false;
			}

			//핸드폰이 뒷자리 비어있을때
			if(no3 == ''){
				alert("핸드폰 뒷 자리가 비어있습니다.")
				$("#mbl_no3").focus();
				return false;
			}
			
			
			//이메일 앞칸 비어있을때
			if(em == ''){
				alert("이메일은 필수입니다.")
				$("#email").focus();
				return false;
			}
			
			
			//이메일 뒷자리 칸 비어있을때
			if(emdt == ''){
				alert("이메일 뒷자리가 비어있습니다.")
				$("#email_dtl").focus();
				return false;
			}
			
			
			//주소 앞칸이 빠졌을때
			if(add == '' && addt != ''){
				alert("앞 주소가 빠져있습니다.");
				$("#addr").focus();
				return false;
			}
			
			//상세 주소가 빠졌을때 
			if(add != '' && addt == ''){
				alert("주소에 상세 주소가 빠져있습니다.");
				$("#addr_dtl").focus();
				return false;
			}

			
			//매장이 없을때
			if(ptcd == ''){
				alert("가입 될 매장이 비어있습니다.")
				$("#prt_cd_nm").focus();
				return false;
			}
			
			
			//중복 버튼 안눌렸을때 
			if(mblBtn == ''){
				alert("핸드폰 중복 버튼을 누르지 않았습니다.");
				$("#mbl_no3").focus();
				return false;
			}
			
			
			//이메일에 한글 있을때
			if(kor.test(em) || kor.test(emdt)){
				
				alert("이메일에 한글이 들어가 있습니다.");
				$("#email").focus();
				return false;
			}
			
			
			//이메일 형식에 맞지 않게 들어갈때   예 ): abc@nav.com 알파벳과 번호 골뱅이와 . 형식
 			if (!regExp.test(emcheck)){
				alert("이메일 형식이 이상합니다. 다시 확인해 주세요.")
				$("#email").focus();
				return false;
			} 
			
			
			if(confirm("신규 고객으로 등록하시겠습니까?")) {
				//고객정보 가져와서 담기
				var cust_nm = $("#cust_nm").val();
				var poc_cd = $("#poc_cd option:selected").val();
				var brdy_dt = $("#brdy_dt").val().replace(/-/g, "");
				var sex_cd = $("input:radio[name=sex_cd]:checked").val();
				var mbl_no = $("#mbl_no1").val() + $("#mbl_no2").val() + $("#mbl_no3").val();
				var scal_yn = $("input:radio[name=scal_yn]:checked").val();
				var psmt_grc_cd = $("input:radio[name=psmt_grc_cd]:checked").val();
				var email = $("#email").val() + "@" + $("#email_dtl").val();
				var addr = $("#addr").val();
				var addr_dtl = $("#addr_dtl").val();
				var mrrg_dt = $("#mrrg_dt").val().replace(/-/g, "");
				var jn_prt_cd =  $("#prt_cd").val();
				var email_rcv_yn = $("input:radio[name=email_rcv_yn]:checked").val();
				var sms_rcv_yn = $("input:radio[name=sms_rcv_yn]:checked").val();
				var dm_rcv_yn = $("input:radio[name=dm_rcv_yn]:checked").val();
				
				//key-value 형태로 담기
				var data = {
					"cust_nm" : cust_nm
					,"poc_cd" : poc_cd
					,"brdy_dt" : brdy_dt
					,"sex_cd" : sex_cd
					,"mbl_no" : mbl_no
					,"scal_yn" : scal_yn
					,"psmt_grc_cd": psmt_grc_cd
					,"email" : email
					,"addr" : addr
					,"addr_dtl" : addr_dtl
					,"mrrg_dt" : mrrg_dt
					,"jn_prt_cd" : jn_prt_cd
					,"email_rcv_yn" : email_rcv_yn
					,"sms_rcv_yn" : sms_rcv_yn
					,"dm_rcv_yn" : dm_rcv_yn
				};
				
				//Data 확인
				console.log(data);
				
				//고객정보 저장처리
				$.ajax({
					url:"<%= request.getContextPath()%>/search/newCust33",
					data: data ,
					type: 'post',
					dataType: "JSON",
					async: false,
					success: function(json){
						console.log(json);
						alert("신규 가입이 완료 되었습니다.");
						window.close();

					},
					error: function( error){
						alert("실패"+ error);
					}
						
				});
			}
			
			
		}); //등록 ajax end
		
			
		
			// 이름 두자 이상 입력시 글씨 창
		   $("#cust_nm").blur(function() {
		       	
			   var cs = $("#cust_nm").val();
			   
			   //이름이 두글자 미만일 경우
			   if(cs.length > 0 && cs.length <= 1 ){
				   
				   alert("이름은 두자리 이상 필수입니다.");
				   
			   }
			   
		    });// 두자 이상 end
		
			
		    
		    
		    
		    
		    
		    $("#mbl_no3").keyup(function() {
		    	
		    	var no1 = $("#mbl_no1").val();
		    	var no2 = $("#mbl_no2").val();
		    	var no3 = $("#mbl_no3").val();
		    	

		    	//중복 버튼 누르게 하는 팝업
		    	if(no1.length == 3 && no2.length == 4 &&no3.length == 4){
		    		
		    		alert("번호 중복 확인을 꼭 해주세요");
		    	}
		    	
		    	//중복 버튼 누르게 하는 팝업
		    	if(no1.length == 3 && no2.length == 3 &&no3.length == 4){
		    		
		    		alert("번호 중복 확인을 꼭 해주세요");
		    	}
		    	
		    	//000 막기
		    	if(no1 == '000' && no2 == '0000' && no3 == '0000' ){
		    		
		    		alert("지원되지 않는 번호 형식 입니다.");
		    		 $("#mbl_no1").val("");
		    		 $("#mbl_no2").val("");
		    		 $("#mbl_no3").val("");
		    		 $("#mbl_no1").focus();
		    		
		    	}
		    	
		    	//000 막기
		    	if(no1 == '000' && no2 == '000' && no3 == '0000' ){
		    		
		    		alert("지원되지 않는 번호 형식 입니다.");
		    		 $("#mbl_no1").val("");
		    		 $("#mbl_no2").val("");
		    		 $("#mbl_no3").val("");
		    		 $("#mbl_no1").focus();
		    		
		    	}
		    	
		    
		    	
		    });// mbl_no3 end
		    
		    
		    
	 		 
		    //이메일 한글 입력 시 빨갛게
		    $('#email').keyup(function() {
		    	
		    	var email = $('#email').val();
		    	var emdt = $('#email_dtl').val();
		    	
		    	//console.log('email'+ email);
		    	//console.log('kor'+ kor.test(email));
		    	
		    	//이메일 앞 칸에 한글이 들어갈 경우
		    	if(kor.test(email)){
		    		//console.log('if start');
					 alert("이메일에 한글이 들어갈 수 없습니다.");
					 $('#email').val("");
					 $('#email').focus();
		    	}


		    });// 이메일 앞자리 end
		    
		    
		    
 		    //이메일 디테일 칸
		    $("#email_dtl").keyup(function() {
		    	
		    	var email = $("#email").val();
		    	var emdt = $("#email_dtl").val();
				
		    	//이메일 디테일 칸에 한글이 들어갈 경우
		    	if(kor.test(emdt)){
					 alert("이메일에 한글이 들어갈 수 없습니다.");
					 $('#email_dtl').val("");
					 $('#email_dtl').focus();
		    	}
		    	
	 	        
		    });// 이메일 뒷 자리 end 
		    
		    
		    
		
	
	}); //document ready end
	
	
	
	
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

	

	
	//팝팝
 	function popUp_prt(){
		
		var url = "http://localhost:8080/gwaje/search/searchshop";
		var title = "popUp_prt2";
		var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
		window.open(url, title, status);
		
		
	}






</script>
</head>
<body id="new_bd_3">
	<div id="sing_div">
	<h3>신규고객등록</h3>
	</div>
	 고객기본정보
	
	<div id="sindiv">	 
	 <table id="sintb" >
	 <tr>
	 	<td style="width:330px;"><i class="redstar" style="color:red;">*</i>
	 	고객명<input type="text" style="width:188px; margin-left:15px;" name="cust_nm" id="cust_nm" oninput="this.value = this.value.replace(/^[0-9]+$/, '');"></td>
			<td><i class="redstar" style="color:red;">*</i>직업코드<select style="margin-left:5px; height:25px; width:200px;" name="poc_cd" id="poc_cd" form="">
					<option value="">직업선택</option>
					<option value="10">학생</option>
					<option value="20">회사원</option>
					<option value="30">공무원</option>
					<option value="40">전문직</option>
					<option value="50">군인</option>
					<option value="60">주부</option>
					<option value="90">연예인</option>
					<option value="99">기타</option>
			</select>
			</td>
		</tr>
	 <tr>
	 	<td><i class="redstar" style="color:red;">*</i>생년월일<input type="date" name="brdy_dt" id="brdy_dt" style="width: 190px; margin-left:5px; margin-bottom:13px;" required></td>
	 	<td>성별<input style="margin-left:45px; margin-bottom:14px;" type="radio" value="F" name="sex_cd" checked>여성
	 		<input type="radio" value="M" name="sex_cd" >남성</td>
	 </tr>
	 <tr>
	 	<td><i class="redstar" style="color:red; margin-bottom:-30px;">*</i>휴대폰번호
	 	<input type="text" style="width:40px;" name="mbl_no1" id="mbl_no1" maxlength="3" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">&nbsp;-
	 	<input type="text" style="width:40px;" name="mbl_no2" id="mbl_no2" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">&nbsp;-
	 	<input type="text" style="width:40px;" name="mbl_no3" id="mbl_no3" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">
	 	<button id="dupBtn">중복</button></td>
	 	<td>생일<input style="margin-left:45px;" type="radio" value="0" name="scal_yn" checked>양력
	 		<input type="radio" value="1" name="scal_yn">음력</td>
	 </tr>
	 <tr>
	 	<td><i class="redstar" style="color:red;">*</i>우편물수령<input type="radio" value="H" name="psmt_grc_cd" checked>자택
	 	<input type="radio" value="O" name="psmt_grc_cd">직장</td>
	 	<td><i class="redstar" style="color:red;">*</i>이메일<input style="width:130px; margin-left: 5px;" type="text" name="email" id="email">@<input style="width:140px;" type="text" name="email_dtl" id="email_dtl">
	 	</td>
	 </tr>
	 <tr>
	 	<td >주소<input type="text" style="width:70px;" disabled><button style="padding-left:10px;"><img src="../resources/image/dott.png" id="search_cust"></button>
	 	<input type="text" name="addr" id="addr"></td>
		<td><input type="text" placeholder="직접입력" name="addr_dtl" id="addr_dtl" style="width:349px;">
		</td>
	 </tr>
	 <tr>
	 	<td>결혼기념일<input type="date" name="mrrg_dt" id="mrrg_dt" style="margin-left:5px; width:180px;"></td>
	 	<td><i class="redstar" style="color:red;">*</i>매장<input type="text" name="prt_cd" id="prt_cd" style="margin-left:5px; width:120px;" disabled>
	 	<button disabled><img src="../resources/image/dott.png" id="prt_btn" style="height:19px;width:19px;" ></button><input style="margin-left:5px; width:130px;" type="text" name="prt_cd_nm" id="prt_cd_nm" disabled></td>
	 </tr>
	 </table>
	 </div>
	 
	 <h4>수신동의(통합)</h4>
	 <div id="su_to_div">
	 <table id="su_to_tbl">
		<tr>
			<td><i class="redstar" style="color:red;">*</i>이메일수신동의<input type="radio" value="Y" name="email_rcv_yn">예
				<input type="radio" value="N" name="email_rcv_yn" checked/>아니오&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td><i class="redstar" style="color:red;">*</i>SMS수신동의<input type="radio" value="Y" name="sms_rcv_yn">예
				<input type="radio" value="N" name="sms_rcv_yn" checked/>아니오&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
				<td><i class="redstar" style="color:red;">*</i>DM수신동의<input type="radio" value="Y" name="dm_rcv_yn">예
				<input type="radio" value="N" name="dm_rcv_yn" checked/>아니오</td>
		</tr>

	 </table>
	 </div>
	 
	<div id="n_dat_3">
	<table>
	<tr><td><button type="button" id="datgi" style="width:65px; height:40px;">닫기</button>
	<button type="button" id="dengrok" style="width:65px; height:40px;">등록</button></td>
	</tr>
	</table>
	</div>
	
	<input type="hidden" name="chkMblBtn" id="chkMblBtn" value="" />
	
</body>
</html>