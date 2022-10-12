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
<title>고객정보조회2</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	
	const kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	//이메일 체크
	var regExp = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
	
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var today = year + month + day;
	var dateString = year + '-' + month  + '-' + day;
	

	$(document).ready(function() {
		
		//세션에 저장 된 사용자 구분 코드
		var se_user_dt_cd = $("#se_user_dt_cd").val();
		console.log(se_user_dt_cd);
		
		
		//고객 상태 코드 별로 disabled 처리
		ssCd();
		
		
		//본사로 들어왔을떄
		if(se_user_dt_cd == 1) {									
			
			//저장 버튼 disabled
			$("#updCust").attr('disabled', true);				
			bonsa();
			
		}
		
		//닫기 눌렀을떄
		$("#cs_dat_2").click(function(){
			
			location.href="${contextPath }/member/toMain";
			
		}); 
		
		
		//매장 팝업 창
		$("#prt_btn").click(function(){
			
			popUp_prt();
			
		}); 
		
		
		//고객 작은 돋보기
		$("#search_cust").click(function(){

			popUp_cust();
			
		});
		
		
		//고객조회 작은 돋보기 버튼 눌렀을떄 팝업
 		$("#newMem_btn").click(function(){
 			
 			popUp_newCust();
 			
 		}); 
		
		
		//매장 찾는 작은 돋보기 
		$("#search_prt").click(function(){

			popUp_prt();
						
		}); 
		
		//매장 칸 엔터시
 		$("#prt_cd_nm").keydown(function(event){
 			
			if(event.keyCode == 13) { 									
				checkPrt();			
			}
		});
		
		
		//생년월일 캘린더에서 선택 할때 미래일자 선택 불가처리
		$("#brdy_dt").prop("max", dateString);
		

		
 		//매장 값 지웠을때 코드 
 		$("#prt_cd_nm").keyup(function(event){  
 				
 			var prt = $("#prt_cd_nm").val();
 			
 			 //매장이 지워졌을 경우 빨간 글씨 띄움
 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
 	            if( $("#prt_cd_nm").val() == "" ) {            
 	               $("#prt_cd").val("");
 	            } 
 	         }
 	         
 	      }); // end key up

 	      
 	 		//고객 이름 지울 경우
 	 		$("#cust_no").keyup(function(event){                  
 	 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
 	 	            if( $("#cust_no").val() == "" ) {            
 	 	               if(confirm("다른 회원으로 바꾸시겠습니까 ?")){
 	 	            	 popUp_cust();
 	 	               }                  
 	 	            } 
 	 	         }
 	 	     }); // end key up
 	      
			
 	 	     
 	 	     //고객 이름 구해올떄 엔터로
 			$("#cust_no").keydown(function(event){					
 				if(event.keyCode == 13) { 									
 					check_cust_data();					
 					
 				}
 			}); //고객 엔터 end
		
		
		
		
		//리프레쉬 버튼 눌렀을떄 
		$("#refresh2").click(function(){
			//alert("리프레쉬");
			var bf_formArr = $("#bf_form").serializeArray();
			var af_formArr = $("#af_form").serializeArray();
			
			//전 후 값을 비교해서 값이 다를 경우 
			if(checkDataBoolean(bf_formArr, af_formArr)) {
				if(confirm('수정 된 내역이 있습니다. 변경내역이 사라지는데 그래도 진행 하시겠습니까?')) {
					
					 chkRefresh();
				}
			}
			
			//전 후 값을 비교해서 값이 같을 경우
			if(!checkDataBoolean(bf_formArr, af_formArr)) {
				if(confirm('화면을 새로고침 하시겠습니까?')) {
					
					 chkRefresh();
				}
			}
						
		}); //refresh end
		

		
		//고객 큰 돋보기
		$("#sub_btn").click(function(){
			
			var bf_formArr = $("#bf_form").serializeArray();
			var af_formArr = $("#af_form").serializeArray();
			var cus_dis = $("#cust_no_dis").val();
			var cus_nm = $("#cust_nm").val();
			
			//console.log('sub_btn.bf_formArr : ' + JSON.stringify(bf_formArr));
			//console.log('sub_btn.af_formArr : ' + JSON.stringify(af_formArr));

			//전 후 값을 비교해서 값이 다를 경우
			if(checkDataBoolean(bf_formArr, af_formArr)) {
				if(confirm('수정 된 내역이 있습니다. 변경내역이 사라지는데 그래도 진행 하시겠습니까?')) {
					gogekk();
				}
			}
			
			//전 후 값을 비교해서 값이 같을 경우 고객 데이터 불러오는 gogekk() 함수 실행
			if(!checkDataBoolean(bf_formArr, af_formArr)) {
				
					gogekk();
				
			}
			
			
		});
		


			
 	 	     
 		    
 		    
		    //핸드폰 앞자리
		    $("#mbl_no1").keyup(function() {
		    
		    	var no1 = $("#mbl_no1").val();
		    	var b1 = $("#bf_mbl_no1").val();
		    	
		    	//핸드폰 앞칸에 000 입력시 못하게
		    	if(no1 == '000'){
		    		
		    		alert("지원되지 않는 번호 형식 입니다.");
		    		 $("#mbl_no1").val(b1);
		    		 $("#mbl_no1").focus();
		    		
		    	}
		    	
		    	
		    });// mbl_no1 end
		    
		    
		    
		    //핸드폰 가운데 자리
		    $("#mbl_no2").keyup(function() {
			    
		    	var no2 = $("#mbl_no2").val();
		    	var b2 = $("#bf_mbl_no2").val();
		    	
		    	//가운데 자리를 000으로 입력시 못하게 막기
		    	if(no2 == '000' || no2 == '0000'){
		    		
		    		alert("지원되지 않는 번호 형식 입니다.");
		    		 $("#mbl_no2").val(b2);
		    		 $("#mbl_no2").focus();
		    		
		    	}
		    	
		    	
		    });// mbl_no2 end
		    
		    
		    //핸드폰 마지막 자리
		    $("#mbl_no3").keyup(function() {
		    	
		    	var no1 = $("#mbl_no1").val();
		    	var no2 = $("#mbl_no2").val();
		    	var no3 = $("#mbl_no3").val();
		    	var b3 = $("#bf_mbl_no3").val();
		    	
		    	//마지막 자리에 0000을 입력할 경우 막기
		    	if(no3 == '0000'){
		    		
		    		alert("지원되지 않는 번호 형식 입니다.");
		    		 $("#mbl_no3").val(b3);
		    		 $("#mbl_no3").focus();
		    		
		    	}
		    	
		    });// mbl_no3 end
		    

		    

		    
 		 

		    
 		    
		
		//저장 버튼 눌렀을때
		$("#updCust").click(function() {
			
			if(confirm("고객정보를 수정하시겠습니까")) {
				
			    //serialize() : queryString => key=value&key=value&.........
			    //serializeArray() : Array(List) => [ {key:value}, {key:value}, ......... ]
			    
			    //전 후 데이터들을 serializeArray() 화 하여 변수에 담기
				var bf_formArr = $("#bf_form").serializeArray();
				var af_formArr = $("#af_form").serializeArray();
				
				console.log('updCust.bf_formArr : ' + JSON.stringify(bf_formArr));
				console.log('updCust.af_formArr : ' + JSON.stringify(af_formArr));
				
				
				af_formArr = custSsList(bf_formArr, af_formArr);
				console.log('update af_formArr : ' + JSON.stringify(af_formArr));
				
				
				//변경전 및 변경후 비교처리
				//checkDataList 함수로 같은 값 비교 후 변경이력에 넣어 보낼 histList 에 저장
				var histList = checkDataList(bf_formArr, af_formArr);
				//최종입력된 고객정보
				var af_form = objToJson(af_formArr);
				//고객상태 값의 변경에 따라 가입/중지/해지 일자처리
				//var form = custSsChk(bf_formArr, af_form);
				
				console.log("histList : " + JSON.stringify(histList));
				//console.log("af_form : " + JSON.stringify(af_form));
				
				//validation 용 값 가져오기
				var name = $("#cust_nm").val();
				var poc = $("select[name=poc_cd] option:selected").val();
				var bd = $("#brdy_dt").val();
				var no1 = $("#mbl_no1").val();
				var no2 = $("#mbl_no2").val();
				var no3 = $("#mbl_no3").val();
				var b_no1 = $("#bf_mbl_no1").val();
				var b_no2 = $("#bf_mbl_no2").val();
				var b_no3 = $("#bf_mbl_no3").val();
				var em = $("#email").val();
				var emdt = $("#email_dtl").val();
				var add = $("#addr").val();
				var addt = $("#addr_dtl").val();
				var ptcd =  $("#prt_cd").val();
				var ptnm = $("#prt_cd_nm").val();
				var mblBtn = $("#chkMblBtn").val();
				var chkMbl =$("#checkMbl").html();
		    	var mr = $("#mrrg_dt").val();
		    	var bf_mr = $("#bf_mrrg_dt").val();
		    	var bf_bd = $("#bf_brdy_dt").val();
		    	var cscd = $('input[name=cust_ss_cd]:checked').val();
		    	var cncl = $("#cncl_cnts").val();
				var cv_dt = new Date(bd);
				var nw_dt = new Date();
	    	  		
				
				
					if(name.length < 2){
						
						alert("이름은 2자 이상 입력 해주세요.");
						$("#cust_nm").focus();
						return false;
					}
			    	//키인으로 생일에 이상한 값 넣었을때
			    	if(!checkValidDate(bd)){
			    		  
			    		alert("유효한 날짜를 입력해주세요");
			    		$("#brdy_dt").val(bf_bd);
			    		$("#brdy_dt").focus();
			    		  
			    		return false;
			    	}
					
					if(nw_dt < cv_dt) {
						alert("생년월일은 당일 포함 이전으로만 선택 가능합니다.");
						$("#brdy_dt").val(bf_bd);
						$("#brdy_dt").focus();
						
						return false;
					} 	
	    	  
				
					//이름이 없을때
					if(name == ''){
						alert("이름을 쓰지 않았습니다. 이름을 써주세요.");
						$("#cust_nm").focus();
						return false;
					}
					
					//이름이 해지고객인 상태로 저장 못하게
					if(name == '해지고객' || name == '해지'){
						alert("해지고객인 상태로 저장될 수 없습니다.");
						$("#cust_nm").focus();
						return false;
					}
					
					//직업을 체크 하지 않았을때
					if(poc == ''){
						alert("직업 선택이 빠져있습니다. 직업을 선택해 주세요.");
						$("#poc_cd").focus();
						return false;
					}
					
					//생일이 비어있을때
					if(bd == ''){
						alert("생일을 체크해주세요.");
						$("#brdy_dt").focus();
						return false;
					}
					
					//핸드폰 앞자리 비어있을때
					if(no1 == ''){
						alert("핸드폰 앞자리가 비어있습니다.")
						$("#mbl_no1").focus();
						return false;
					}
					
					//핸드폰 가운데 자리 비어있을때
					if(no2 == ''){
						alert("핸드폰 가운데 자리가 비어있습니다.")
						$("#mbl_no2").focus();
						return false;
					}
					
					//핸드폰 뒷자리 비어있을때
					if(no3 == ''){
						alert("핸드폰 뒷 자리가 비어있습니다.")
						$("#mbl_no3").focus();
						return false;
					}//핸드폰 끝

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
					
					//주소 뒤에 없을떄
					if(add != '' && addt == ''){
						alert("주소에 상세 주소가 빠져있습니다.");
						$("#addr_dtl").focus();
						return false;
					}
					
					//주소 앞에 없을떄
					if(add == '' && addt != ''){
						alert("앞 주소가 빠져있습니다.");
						$("#addr").focus();
						return false;
					}
					
					//매장 없을때
					if(ptcd == ''){
						alert("가입 매장이 비어있습니다.")
						$("#prt_cd_nm").focus();
						return false;
					}
					
					//핸드폰 변경 버튼 안누르고 저장 누를때
   					if(b_no1 != no1 && mblBtn == ''){
						alert("핸드폰 중복 버튼을 누르지 않았습니다.");
						$("#mbl_no3").focus();
						return false;
					} 
					
   					if(b_no2 != no2 && mblBtn == ''){
						alert("핸드폰 중복 버튼을 누르지 않았습니다.");
						$("#mbl_no3").focus();
						return false;
					} 
   					
   					if(b_no3 != no3 && mblBtn == ''){
						alert("핸드폰 중복 버튼을 누르지 않았습니다.");
						$("#mbl_no3").focus();
						return false;
					} 
					
					//이메일에 한글이 있을때
					if(kor.test(em) || kor.test(emdt)){
						alert("이메일에 한글이 들어가 있습니다.");
						$("#email").focus();
						return false;
					}
					
					//해지 사유 안 넣었을때
					if(cscd == 90 && cncl == ''){
						alert("해지 사유를 꼭 입력해 주세요.");
						$("#cncl_cnts").focus();
						return false;
					}
					
					
					//변경 된 값이 없이 저장 눌렀을때
					if(!checkDataBoolean(bf_formArr, af_formArr)) {
						alert("수정된 내용이 없습니다.");
						return false;
						
					}
				
				//고객정보 저장처리
				$.ajax({
					url:"<%= request.getContextPath()%>/search/updCust22",
					data: {
						"af_form" : JSON.stringify(af_form)
						,"histList" : JSON.stringify(histList)
					},
					type: 'post',
					dataType: "JSON",
					async: false,
					success: function(json){
						console.log(json);
						alert("고객정보 수정이 완료 되었습니다.");
						//window.location.reload();
						gogekk();

					},
					error: function( error){
						alert("실패"+ error);
					}
						
				});
			}
		});	


		    
		    
 	    // 라디오버튼 클릭시 이벤트 발생
 	    $("input:radio[name=cust_ss_cd]").click(function(){
 	 			
 	    	var name = $("#cust_nm").val();
 	    	//해지 눌렀을떄
 	        if($("input[name=cust_ss_cd]:checked").val() == 90){
 	            
 	        	alert("해지 버튼이 적용되었습니다.해지 사유를 등록해주세요.");
 	        	$("#cncl_cnts").attr("readonly", false);
 	        	$("#cncl_cnts").css({"width": "340px", "pointer-events": "auto", "background-color": "white"});
 	        	$("#cncl_cnts").focus();

 	        }
 	    	
 	        
 	    	//정상 눌렀을때
 	        if($("input[name=cust_ss_cd]:checked").val() == 10){
 	            
 	        	$("#cncl_cnts").attr("readonly", true);
 	        	$("#cncl_cnts").css({"width": "340px", "pointer-events": "none", "border-color": "rgba(118, 118, 118, 0.3)", "background-color": "#f2f3f5"});
 	        	$("#cncl_cnts").val('');

 	        }
 	    	
 	    	
 	        //해지에서 정상 눌렀을떄 그리고 이름이 '해지고객' 일 경우
 	        if($("input[name=cust_ss_cd]:checked").val() == 10 && name == '해지고객'){
 	            
 	        	alert("정상으로 활성화 하려면, 이름과 번호를 다시 지정해주셔야 합니다.");
 	        	$("#cust_nm").val("");
 	        	$("#mbl_no1").val("");
 	        	$("#mbl_no2").val("");
 	        	$("#mbl_no3").val("");
 				$("#cust_nm").focus();

 	        }
 	    	

 	        // 중지 눌렀을떄
 	        if($("input[name=cust_ss_cd]:checked").val() == 80){
 	            
 	        	$("#cncl_cnts").attr("readonly", true);
 	        	$("#cncl_cnts").css({"width": "340px", "pointer-events": "none", "border-color": "rgba(118, 118, 118, 0.3)", "background-color": "#f2f3f5"});

 	        }

 	        
 	        
 	    });
 		
 		
 	    
 	    
 		
 		//휴대폰 변경 중복 버튼 눌렀을때 처리
		$("#cng_mbl").click(function() {
			//휴대폰번호 값 가져오기
			var mbl_no1 = $("#mbl_no1").val();
			var mbl_no2 = $("#mbl_no2").val();
			var mbl_no3 = $("#mbl_no3").val();
			//원래 있던 값 
			var n1 = $("#bf_mbl_no1").val();
			var n2 = $("#bf_mbl_no2").val();
			var n3 = $("#bf_mbl_no3").val();
			
			//세등분 되어 있는 것 들을 한번에 모아줌
			var mbl_no = mbl_no1 + mbl_no2 + mbl_no3;
			
			console.log(mbl_no);
			
			
			//핸드폰 앞자리 비어있을떄
			if(mbl_no1 == '' ){
				
				alert("앞자리 번호가 비어있습니다.");
				$("#mbl_no1").focus();
				return false;
			}
			
			//핸드폰 앞자리 3자리 이하 일때
			if(mbl_no1.length < 3){
				alert("핸드폰 앞자리는 꼭 세자리가 필요합니다.")
				$("#mbl_no1").focus();
				return false;
			}
			
			//핸드폰 가운데 자리 비어있을떄
			if(mbl_no2 == '' ){
				alert("가운데 자리 번호가 비어있습니다.");
				$("#mbl_no2").focus();
				return false;
			}
			
			//핸드폰 가운데 자리 3자리 이하 일때
			if(mbl_no2.length < 3){
				alert("핸드폰 가운데 자리는 3-4자리 입력해주세요.")
				$("#mbl_no2").focus();
				return false;
			}
			
			//핸드폰 뒷자리 비어있을떄
			if(mbl_no3 == ''){
				alert("뒷 자리 번호가 비어있습니다.");
				$("#mbl_no3").focus();
				return false;
			}
			
			//핸드폰 뒷자리 4자리 이하 일때
			if(mbl_no3.length < 4){
				alert("핸드폰 뒷 자리는 꼭 4자리가 필요합니다.")
				$("#mbl_no3").focus();
				return false;
			}
			
			
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
					   alert("변경 가능한 번호 입니다.");
					    $("#chkMblBtn").val("확인");				//수정 버튼 시 변경 눌렀는지 확인 용도
					    $("#mbl_no").val(mbl_no);				//이전 이후 값 비교 위한 값 넣기
					}
					
					if(json.CNT == 1){
						
						alert("중복된 번호가 있습니다.");
						$("#mbl_no1").val(n1);					//중복된 값일 경우 원래 있던 번호
						$("#mbl_no2").val(n2);					//다시 불러오기
						$("#mbl_no3").val(n3);
						
					} 
				},
				error: function( error){
					
					alert("실패"+ error);
				}
			});
		}); //핸드폰 중복 end

		
		
		
		
	}); //document ready end
	
	
	
	
	
	//리프레쉬 버튼 눌렀을 떄 값 날리기
	function chkRefresh(){
		//조회조건 초기화
		$("#cust_no_dis").val("");
		$("#cust_no").val("");
		
		//af_form 초기화
		$("#cust_no_dis2").val("");								
		$("#cust_nm").val("");
		$("#brdy_dt").val("");
		$('input[name="sex_cd"]').val(['F']);
		$('input[name="scal_yn"]').val(['0']);
		$("#mrrg_dt").val("");
		$('select[name="poc_cd"]').val(['']);
		$("#mbl_no").val("");
		$("#mbl_no1").val("");
		$("#mbl_no2").val("");
		$("#mbl_no3").val("");
		$("#prt_cd").val("");
		$("#prt_cd_nm").val("");
		$('input[name="psmt_grc_cd"]').val(['H']);
		$("#email").val("");
		$("#email_dtl").val("");
		$("#addr").val("");
		$("#addr_dtl").val("");
		$('input[name="cust_ss_cd"]').val(['10']);
		$("#fst_js_dt").val("");
		$("#js_dt").val("");
		$("#cncl_cnts").val("");
		$("#stp_dt").val("");
		$("#cncl_dt").val("");
		$("#tot_sal_amt").val("");
		$("#nmm_sal_amt").val("");
		$("#lst_sal_dt").val("");
		$("#tot_pnt").val("");
		$("#rsvg_pnt").val("");
		$("#us_pnt").val("");
		$('input[name="email_rcv_yn"]').val(['N']);
		$('input[name="sms_rcv_yn"]').val(['N']);
		$('input[name="dm_rcv_yn"]').val(['N']);
		
		//bf_form
		$('#bf_cust_no').val('');
		$('#bf_cust_nm').val('');
		$('#bf_sex_cd').val('F');
		$('#bf_scal_yn').val('0');
		$('#bf_brdy_dt').val('');
		$('#bf_mrrg_dt').val('');
		$('#bf_poc_cd').val('');
		$('#bf_mbl_no').val('');
		$('#bf_mbl_no1').val('');
		$('#bf_mbl_no2').val('');
		$('#bf_mbl_no3').val('');
		$('#bf_psmt_grc_cd').val('H');
		$('#bf_email').val('');
		$('#bf_email_dtl').val('');
		$('#bf_addr').val('');
		$('#bf_addr_dtl').val('');
		$('#bf_cust_ss_cd').val('10');
		$('#bf_cncl_cnts').val('');
		$('#bf_jn_prt_cd').val('');
		$('#bf_email_rcv_yn').val('N');
		$('#bf_sms_rcv_yn').val('N');
		$('#bf_dm_rcv_yn').val('N');
		$('#bf_js_dt').val('');
		$('#bf_stp_dt').val('');
		$('#bf_cncl_dt').val('');
		
		
		var bf_formArr = $("#bf_form").serializeArray();
		var af_formArr = $("#af_form").serializeArray();
		
		console.log('chkRefresh 후 bf_formArr : ' + JSON.stringify(bf_formArr));
		console.log('chkRefresh 후 af_formArr : ' + JSON.stringify(af_formArr));
		
		
	}
	
	
	
	
	
	//본사로 로그인 했을떄 값을 바꾸지 못하도록 설정
 	function bonsa(){
		
 		$("#cust_nm").attr("readonly",true); 
 		$("#brdy_dt").attr("readonly",true); 
		$('input[name="sex_cd"]').prop("disabled",true);
		$('input[name="scal_yn"]').prop("disabled",true);
 		$("#mrrg_dt").attr("readonly",true); 
 		$('select[name="poc_cd"]').prop("disabled",true);
 		$("#mbl_no1").attr("readonly",true); 
 		$("#mbl_no2").attr("readonly",true); 
 		$("#mbl_no3").attr("readonly",true); 
 		$("#prt_cd").attr("readonly",true); 
 		$("#prt_cd_nm").attr("readonly",true); 
 		$('input[name="psmt_grc_cd"]').prop("disabled",true);
 		$("#email").attr("readonly",true); 
 		$("#email_dtl").attr("readonly",true); 
 		$("#addr").attr("readonly",true); 
 		$("#addr_dtl").attr("readonly",true); 
 		$('input[name="cust_ss_cd"]').prop("disabled",true);
 		$("#cncl_cnts").attr("readonly",true); 
 		$("#cncl_cnts").css({"width": "340px", "pointer-events": "none", "border-color": "rgba(118, 118, 118, 0.3)", "background-color": "#f2f3f5"});
 		$('input[name="email_rcv_yn"]').prop("disabled",true);
 		$('input[name="sms_rcv_yn"]').prop("disabled",true);
 		$('input[name="dm_rcv_yn"]').prop("disabled",true);
 		
 		
		
	} 
	
	
	
	
	
	
		// bfData 및 afData는 Array(List)
		//변경전 및 변경후 비교 (return boolean)
		function checkDataBoolean(bfData, afData) {
			
			var result = false;
			// 이전 값을 반복 문을 돌려 
			$(bfData).each(function(bfIdx, bfItem){
				//이후 값도 반복문을 돌려 값을 비교
				$(afData).each(function(afIdx, afItem){
					//만약 이전 값과 이후 값의 이름이 같을 경우
					if(bfItem.name == afItem.name) {
						//만약 이전 값에 value가 비어있지않고 이후 값도 value가 비어있지않을 경우 
						//if(!isEmpty(bfItem.value) || !isEmpty(afItem.value)) {
							//만약 이전값과 이후 값이 다를 경우 result 에 true를 넣는다
							if(bfItem.value != afItem.value) {
								console.log(bfItem.name + ' : ' + afItem.name);
								console.log(bfItem.value + ' : ' + afItem.value);
								result = true;
							}
						//}
					}
				});
			});
			//result를 다시 반환
			return result;
		}
		
	
	
		
		
		
			// bfData 및 afData는 Array(List)
			//변경전 및 변경후 비교 (return array)
			function checkDataList(bfData, afData) {
				//변경 된 data list 담을 변수 생성
				var list = new Array();
				// 변경 된 data 담기 이전 값과 이후 값을 이중 포문을 돌려 값을 비교 
				$(bfData).each(function(bfIdx, bfItem){
					$(afData).each(function(afIdx, afItem){
						//만약 이전 값과 이후 값의 이름이 같을 경우
						if(bfItem.name == afItem.name) {
							//만약 이전 값에 value가 비어있지않고 이후 값도 value가 비어있지않을 경우 
							//if(!isEmpty(bfItem.value) || !isEmpty(afItem.value)) {
								//만약 이전값과 이후 값이 다를 경우
								if(bfItem.value != afItem.value) {
									console.log("afItem.name : " + afItem.name);
									//변경 이력에 넣어 줄 name and value 설정
									var row = {
											"chg_cd":afItem.name
											,"chg_bf_cnt":bfItem.value
											,"chg_aft_cnt":afItem.value
									};
									//그리고 list 에 추가 해준다
									list.push(row);
								}
							//}
						}
					});
				});
				//list를 반환
				return list;
			}
	
			
						
						
			//serializeArray()를 매개변수로 받아처리
			//return object(key:value)
			function objToJson(formData) {
				//data에 불러온 af_form을 넣고
				var data = formData;
				//빈 객체 선언
				var obj = {};
				$.each(data, function(idx, ele) {
					//가입 날짜 이거나 중지 날짜 이거나 해지 날짜 일때
					if(ele.name == 'js_dt' || ele.name == 'stp_dt' || ele.name == 'cncl_dt') {
						//각각의 날짜들의 '-' 를 잘라 없애준다
						obj[ele.name] = ele.value.replace(/-/gi, '');
					} else {
						obj[ele.name] = ele.value;
					}
				});
				
				return obj;
			}
	
			
			
			
			
			
			//정상 중지 해지용 disabled 처리
			function ssCd(){
				//상태 코드 체크 박스				
				var cd = $('input[name=cust_ss_cd]:checked').val();
				//고객 번호
				var cust = $("#cust_no_dis").val();
				
				// 코드가 정상일때
				if(cd == 10){
					//해지 버튼 disabled
					 $("#ha").prop("disabled", true);
					//중지 버튼 disabled 해제
					 $("#jung").prop("disabled", false);
					//해지사유 readonly 
					 $("#cncl_cnts").attr("readonly", true);
					//disabled 효과를 주기 위한 css
					 $("#cncl_cnts").css({"width": "340px", "pointer-events": "none", "border-color": "rgba(118, 118, 118, 0.3)", "background-color": "#f2f3f5"});
					
				}
				
				//해지 상태 일때
				if(cd == 90){
					//해지 사유
					var cn = $("#cncl_cnts").val();
					//중지 버튼 disabled
					$("#jung").prop("disabled", true);
					//해지 버튼 disabled 해제
					$("#ha").prop("disabled", false);
					//해지사유 readonly 해제
					$("#cncl_cnts").attr("readonly", false);
					//해지사유 css 효과
					$("#cncl_cnts").css({"width": "340px", "pointer-events": "auto", "background-color": "white"});
					
				}
				
				// 값이 없이 들어왔을때
				if(cust == ''){
					//해지 버튼 disabled 해제
					$("#ha").prop("disabled", false);
				}
				
				//중지 상태 일때
				if(cd == 80){
					//해지사유 readonly
					$("#cncl_cnts").attr("readonly", true);
					//해지사유 css
					$("#cncl_cnts").css({"width": "340px", "pointer-events": "none", "border-color": "rgba(118, 118, 118, 0.3)", "background-color": "#f2f3f5"});
					
				}
				
				
			} //ssCd end
			
			
			
				
			
				
		//고객상태 값의 변경에 따라 가입/중지/해지 처리
		//bfData(배열), afData(맵)
		//return 배열
		function custSsChk(bfData, afData) {
			console.log('======================== custSsChk Start ========================');
			var list = new Array();;
			$(bfData).each(function(bfIdx, bfItem){
			//변경 전 데이터의 이름이 고객상태 코드 일 경우
			if(bfItem.name == 'cust_ss_cd') {
				var bfCustSsCd = bfItem.value;
				var afCustSsCd = afData.value;
				console.log(bfCustSsCd + ' : ' + afCustSsCd + '(' + today + ')');
				
				//정상 > 중지 처리
				if(bfCustSsCd == '10' && afCustSsCd == '80') {
					//새로 입력될 중지 날짜에 지금 날짜를 넣어준다
					var map = {
							"name" : "stp_dt"
							,"value" : dateString
					};
					list.push(map);
				}
				//중지 > 해지 처리
				if(bfCustSsCd == '80' && afCustSsCd == '90') {
					//새로 입력될 해지 날짜에 지금 날짜를 넣어준다 그리고 자동으로 이름과 번호를 바꿔준다.
					var map = {
							"name" : "cncl_dt"
							,"value" : dateString
					};
					list.push(map);
					
					map = {
							"name" : "cust_nm"
							,"value" : '해지고객'
					};
					list.push(map);
					
					map = {
							"name" : "mbl_no"
							,"value" : '00000000000'
					};
					list.push(map);
				}
				//해지 > 정상 처리
				if(bfCustSsCd == '90' && afCustSsCd == '10') {
					//새로 입력될 가입 날짜에 지금 날짜를 넣어준다 그리고 입력되어 있던 중지날짜와 해지날짜 해지사유를 없앤다.
					var map = {
							"name" : "js_dt"
							,"value" : dateString
					};
					list.push(map);
					
					map = {
							"name" : "cncl_dt"
							,"value" : ''
					};
					list.push(map);
					
					map = {
							"name" : "cncl_cnts"
							,"value" : ''
					};
					list.push(map);
				}
			}
		});
		
		console.log('custSsChk return : ' + JSON.stringify(list));
		return list;
	}
			
		//고객상태 값의 변경에 따라 가입/중지/해지 처리
		//bfData(배열), afData(배열)
		//return afData
		function custSsList(bfData, afData) {
			console.log('======================== custSsList Start ========================');
			var list;
			//고객상태 값의 변경에 따른 list 변수의 담을 배열 생성 목적의 반복문
			$(afData).each(function(afIdx, afItem){
			//변경 전 데이터의 이름이 고객상태 코드 일 경우
			//afData : [{name:"cust_ss_cd", value: "10"}, .......] 배열 형태
			//afItem : {name:"cust_ss_cd", value: "10"} key:value 형태
			if(afItem.name == 'cust_ss_cd') {
				list = custSsChk(bfData, afItem);
				console.log('list - ' + JSON.stringify(list));
				//afData[afIdx] = map;
			}
		});
			
			//return 해줄 afData와 custSsChk에서 반환 받은 list간의 비교 갱신처리 목적의 반복문
			$(afData).each(function(afIdx, afItem){
				$(list).each(function(idx, item){
					if(afItem.name == item.name) {
						afItem.value = item.value;
					}
				});
			});
		
		console.log('custSsList return : ' + JSON.stringify(afData));
		return afData;
	}
	

		
		
	
	// 엔터 or 클릭시 매장 데이타 검색
	 function checkPrt(){
		
		var check_prt = $("#prt_cd_nm").val();
		//console.log(check_prt);
		
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
	
	
	
	//큰 돋보기 눌렀을때 고객 조회 해오는 버튼
	function gogekk(){
		
		var cust_no = $("#cust_no_dis").val();
		
		$.ajax({
			url:"<%= request.getContextPath()%>/search/custmod222",
			data: {"cust_no": cust_no} ,
			type: 'post',
			dataType: "JSON",
			async: false,
			success: function(json){
				console.log(json);
				//alert("성공");
				//if(json.length == 1){
					var custNo = json.CUST_NO; 
					var custNm = json.CUST_NM; 
					var sexCd = json.SEX_CD;
					var scal = json.SCAL_YN;
					var brdy = json.BRDY_DT;
					var mrrg = json.MRRG_DT;
					var pocCd = json.POC_CD;
					var mbl1 = json.MBL_NO1;
					var mbl2 = json.MBL_NO2;
					var mbl3 = json.MBL_NO3;
					var psmt = json.PSMT_GRC_CD;
					var email = json.EMAIL;
					var emaildt = json.EMAIL_DTL;
					var zip = json.ZIP_CD;
					var add = json.ADDR;
					var addt = json.ADDR_DTL;
					var custSS = json.CUST_SS_CD;
					var cncl = json.CNCL_CNTS;
					var prtCd = json.JN_PRT_CD;
					var prtNm = json.JN_PRT_NM;
					var emailYN = json.EMAIL_RCV_YN;
					var smsYN = json.SMS_RCV_YN;
					var dmYN = json.DM_RCV_YN;
					var f_jdt = json.FST_JS_DT;
					var jsdt = json.JS_DT;
					var stp = json.STP_DT;
					var cncl_dt = json.CNCL_DT;
					var f_reg = json.FST_REG_DT;
					var f_user = json.FST_USER_ID;
					var l_updt = json.LST_UPD_DT;
					var l_upid = json.LST_UPD_ID;
					var tosal = json.TOT_SAL_AMT;
					var nmsal = json.NMM_SAL_AMT;
					var l_sal = json.LST_SAL_DT;
					var t_pnt = json.TOT_PNT;
					var n_pnt = json.RSVG_PNT;
					var u_pnt = json.US_PNT;
					
					//bf-form용 전 후 비교를 위해 넣어줘야 한다
					$('#bf_cust_no').val(custNo);
					$('#bf_cust_nm').val(custNm);
					$('#bf_sex_cd').val(sexCd);
					$('#bf_scal_yn').val(scal);
					$('#bf_brdy_dt').val(brdy);
					$('#bf_mrrg_dt').val(mrrg);
					$('#bf_poc_cd').val(pocCd);
					$('#bf_mbl_no').val(mbl1+mbl2+mbl3);
					$('#bf_mbl_no1').val(mbl1);
					$('#bf_mbl_no2').val(mbl2);
					$('#bf_mbl_no3').val(mbl3);
					$('#bf_psmt_grc_cd').val(psmt);
					$('#bf_email').val(email);
					$('#bf_email_dtl').val(emaildt);
					$('#bf_addr').val(add);
					$('#bf_addr_dtl').val(addt);
					$('#bf_cust_ss_cd').val(custSS);
					$('#bf_cncl_cnts').val(cncl);
					$('#bf_jn_prt_cd').val(prtCd);
					$('#bf_email_rcv_yn').val(emailYN);
					$('#bf_sms_rcv_yn').val(smsYN);
					$('#bf_dm_rcv_yn').val(dmYN);
					$('#bf_fst_js_dt').val(f_jdt);
					$('#bf_js_dt').val(jsdt);
					$('#bf_stp_dt').val(stp);
					$('#bf_cncl_dt').val(cncl_dt);
					$('#bf_tot_sal_amt').val(tosal);
					$('#bf_nmm_sal_amt').val(nmsal);
					$('#bf_lst_sal_dt').val(l_sal);
					$('#bf_tot_pnt').val(t_pnt);
					$('#bf_rsvg_pnt').val(n_pnt);
					$('#bf_us_pnt').val(u_pnt);
					
					//조회조건에 세팅
					$('#cust_no_dis').val(custNo);
					$('#cust_no').val(custNm);
					
					//af-form용 새로 입력 될 곳에 값을 넣어준다.
					$('#cust_no_dis2').val(custNo);
					$('#cust_nm').val(custNm);
					$('input[name="sex_cd"]').val([sexCd]);
					$('input[name="scal_yn"]').val([scal]);
					$('#brdy_dt').val(brdy);
					$('#mrrg_dt').val(mrrg);
					$('select[name="poc_cd"]').val([pocCd]);
					$('#mbl_no').val(mbl1+mbl2+mbl3);
					$('#mbl_no1').val(mbl1);
					$('#mbl_no2').val(mbl2);
					$('#mbl_no3').val(mbl3);
					$('input[name="psmt_grc_cd"]').val([psmt]);
					$('#email').val(email);
					$('#email_dtl').val(emaildt);
					$('#addr').val(add);
					$('#addr_dtl').val(addt);
					$('input[name="cust_ss_cd"]').val([custSS]);
					$('#cncl_cnts').val(cncl);
					$('#prt_cd').val(prtCd);
					$('#prt_cd_nm').val(prtNm);
					$('input[name="email_rcv_yn"]').val([emailYN]);
					$('input[name="sms_rcv_yn"]').val([smsYN]);
					$('input[name="dm_rcv_yn"]').val([dmYN]);
					$('#fst_js_dt').val(f_jdt);
					$('#js_dt').val(jsdt);
					$('#stp_dt').val(stp);
					$('#cncl_dt').val(cncl_dt);
					$('#tot_sal_amt').val(tosal);
					$('#nmm_sal_amt').val(nmsal);
					$('#lst_sal_dt').val(l_sal);
					$('#tot_pnt').val(t_pnt);
					$('#rsvg_pnt').val(n_pnt);
					$('#us_pnt').val(u_pnt);
					
					ssCd();

			},
			error: function( error){
				
				alert("전송 실패");
			}
				
		}); 
		
	}// gogekk() end
	
	
	

	
	
	
	
	 // 날짜 유효성 검사용
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
	
	
	
		
		
	 	//빈값 체크용
	 	function isEmpty(value){
	 		if(value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length)){
	 			return true
	 		} else {
	 			return false
	 		}
	 	}
		
	
	
	
	//팝팝
 	function popUp_prt(){
		
		var url = "http://localhost:8080/gwaje/search/searchshop";
		var title = "popUp_prt2";
		var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
		window.open(url, title, status);
		
		
	}
	
	
	function popUp_cust(){
		
		var url = "http://localhost:8080/gwaje/search/customer";
		var title = "popup_cust3";
		var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
		window.open(url, title, status);
	}
	


</script>
</head>
<body>

	<div>
	<table>
		<tr>
			<td><img src="../resources/image/star.jpg" height ="15" width="15"></td>
			<th style="margin:0px;">고객정보조회</th>
			<td><button id="refresh2" ><img src="../resources/image/refresh.png" height ="15" width="15"></button></td>
		</tr>
	</table>
	</div>
	
	<div id="go_div_1">
	<table>
		<tr>
		<td style="padding-right: 45px; padding-left: 99px;">고객번호<input type="text" name="cust_no_dis" id="cust_no_dis" value="${custVO.CUST_NO }" disabled>
		<button type="button" ><img src="../resources/image/dott.png" id="search_cust"></button>
		<input type="text" style="margin-left:7px;" name="cust_no" id="cust_no" value="${custVO.CUST_NM}"></td>
		<td><button type="button" type="button"><img src="../resources/image/dott.png" id="sub_btn"></button></td>
		
		</tr>
	</table>
	</div>
	
	
	
	<form id="af_form">
	<div style="margin-left:120px;">
	<h4 style="margin:1px;">고객기본정보</h4>
	
	<table id="go_gi_2">
	
	<tr>
		<td><input type="hidden"  name="cust_no_dis" id="cust_no_dis2" value="${custVO.CUST_NO }">
		<i class="redstar" style="color:red;">*</i>
		고객명<input type="text"  name="cust_nm" id="cust_nm" style="width: 180px; margin-left:30px;" value="${custVO.CUST_NM }">
		</td>
		
		<td><i class="redstar" style="color:red;">*</i>
		생년월일<input type="date" name="brdy_dt" id="brdy_dt" style="margin-left:5px; width:140px;" value="${custVO.BRDY_DT }"></td>
		
		<td>성별<input style="margin-left:48px;" type="radio" value="F" name="sex_cd" id="sex_cd" <c:if test="${custVO.SEX_CD eq 'F' || custVO.SEX_CD eq '' || custVO.SEX_CD eq null}">checked</c:if>>여성
			<input type="radio" value="M" name="sex_cd" id="sex_cd" <c:if test="${custVO.SEX_CD eq 'M'}">checked</c:if>>남성
		</td>
	</tr>
		<tr>
			<td><i class="redstar" style="color:red;">*</i>
			생일<input type="radio" value="0" name="scal_yn" style="margin-left:53px;" <c:if test="${custVO.SCAL_YN eq '0' || custVO.SCAL_YN eq '' || custVO.SCAL_YN eq null}">checked</c:if>>양력
			<input type="radio" value="1" name="scal_yn" <c:if test="${custVO.SCAL_YN eq '1'}">checked</c:if>>음력
			</td>
			<td>결혼기념일<input type="date" name="mrrg_dt" style="width: 141px; "id="mrrg_dt" value="${custVO.MRRG_DT}"></td>
			
			<td><i class="redstar" style="color:red;">*</i>
					직업코드<select name="poc_cd" style="width:140px; margin-left:5px;">
					<option value="" <c:if test="${custVO.POC_CD eq ''}">selected</c:if>>직업선택</option>
					<option value="10" <c:if test="${custVO.POC_CD eq '10'}">selected</c:if>>학생</option>
					<option value="20" <c:if test="${custVO.POC_CD eq '20'}">selected</c:if>>회사원</option>
					<option value="30" <c:if test="${custVO.POC_CD eq '30'}">selected</c:if>>공무원</option>
					<option value="40" <c:if test="${custVO.POC_CD eq '40'}">selected</c:if>>전문직</option>
					<option value="50" <c:if test="${custVO.POC_CD eq '50'}">selected</c:if>>군인</option>
					<option value="60" <c:if test="${custVO.POC_CD eq '60'}">selected</c:if>>주부</option>
					<option value="90" <c:if test="${custVO.POC_CD eq '90'}">selected</c:if>>연예인</option>
					<option value="99" <c:if test="${custVO.POC_CD eq '99'}">selected</c:if>>기타</option>
			</select>
		</tr>
		<tr>
		<td><i class="redstar" style="color:red;">*</i>
		<input type="hidden" name="mbl_no" id="mbl_no" value="${custVO.MBL_NO1 }${custVO.MBL_NO2 }${custVO.MBL_NO3 }">
		휴대폰번호<input type="text" style="width:45px;" id="mbl_no1"  maxlength="3" value="${custVO.MBL_NO1 }" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">-
		<input type="text" style="width:45px;" id="mbl_no2"  maxlength="4" value="${custVO.MBL_NO2 }" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">-
		<input style="width:45px;" type="text" id="mbl_no3"  maxlength="4" value="${custVO.MBL_NO3 }" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">
		<button type="button" id="cng_mbl">변경</button></td>
		<td></td>
		<td><i class="redstar" style="color:red;">*</i>
			가입매장<input type="text" id="prt_cd" name="jn_prt_cd" class="input:disabled" style="width: 90px; margin-left: 5px; pointer-events: none; border-color: rgba(118, 118, 118, 0.3); background-color: #f2f3f5;" value="${custVO.JN_PRT_CD}" readonly="readonly">
			<button type="button" ><img src="../resources/image/dott.png" id="search_prt"></button>
			<input type="text" id="prt_cd_nm" name="prt_cd_nm" style="width: 100px;" value="${custVO.JN_PRT_NM}">
			</td>
	</tr>
	<tr>
		<td><i class="redstar" style="color:red;">*</i>
		우편물수령<input type="radio" value="H" name="psmt_grc_cd" <c:if test="${custVO.PSMT_GRC_CD eq 'H' || custVO.PSMT_GRC_CD eq ''  || custVO.PSMT_GRC_CD eq null}">checked</c:if>>자택
		<input type="radio" value="O" name="psmt_grc_cd" <c:if test="${custVO.PSMT_GRC_CD eq 'O'}">checked</c:if>>직장</td>
		<td><i class="redstar" style="color:red;">*</i>
		이메일<input style="width:140px; margin-left:18px;" type="email" name="email" id="email" value="${custVO.EMAIL }">@<input style="width:140px;" type="email" name="email_dtl" id="email_dtl" value="${custVO.EMAIL_DTL }"></td>
	</tr>
	<tr>
		<td>주소
		<input type="text" style="width:40px;" disabled>
		<input type="text" placeholder="직접입력" style="width:150px;" name="addr" id="addr" value="${custVO.ADDR }">
		<input type="text" placeholder="직접입력" style="width:150px;" name="addr_dtl" id="addr_dtl" value="${custVO.ADDR_DTL }"></td>
	</tr>
	<tr>
		<td><i class="redstar" style="color:red;">*</i>
			고객상태
			<input style="margin-left:15px;" type="radio" value="10" name="cust_ss_cd" id="sang"<c:if test="${custVO.CUST_SS_CD eq '10' || custVO.CUST_SS_CD eq '' || custVO.CUST_SS_CD eq null}">checked</c:if>>정상
			<input type="radio" value="80" name="cust_ss_cd" id="jung" <c:if test="${custVO.CUST_SS_CD eq '80'}">checked</c:if>>중지
			<input type="radio" value="90" name="cust_ss_cd" id="ha" <c:if test="${custVO.CUST_SS_CD eq '90'}">checked</c:if>>해지
		</td>
		<td>최초가입일자<input style="margin-left:20px; pointer-events: none; border-color: rgba(118, 118, 118, 0.3); background-color: #f2f3f5;" type="text" id="fst_js_dt"  value="${custVO.FST_JS_DT }" readonly="readonly"></td>
		<td>가입일자<input type="text" id="js_dt" name="js_dt" style="margin-left:30px;width: 145px; pointer-events: none; border-color: rgba(118, 118, 118, 0.3); background-color: #f2f3f5;" value="${custVO.JS_DT }" readonly="readonly"></td>
	</tr>
	<tr>
		<td>해지사유<input type="text" id="cncl_cnts" name="cncl_cnts" style="width: 340px;" value="${custVO.CNCL_CNTS }"></td>
		<td>중지일자<input type="text" id="stp_dt" name="stp_dt" style="margin-left:52px; width: 163px; pointer-events: none; border-color: rgba(118, 118, 118, 0.3); background-color: #f2f3f5;"  value="${custVO.STP_DT }" readonly="readonly"></td>
		<td>해지일자<input type="text" id="cncl_dt" name="cncl_dt" style="margin-left:30px; width: 145px; pointer-events: none; border-color: rgba(118, 118, 118, 0.3); background-color: #f2f3f5;"  value="${custVO.CNCL_DT }" readonly="readonly"></td>
	</tr>
	</table>
	
	</div>
	
	<div style="margin-left:120px;">
	<h4  style="margin:1px;">구매</h4>
	
	<table id="chong_tbl">
		<!-- name 체크 -->
		<tr>
			<td>총구매금액<input style="margin-left:20px; margin-right:134px;" type="text" class="right" id="tot_sal_amt"  value="${custVO.TOT_SAL_AMT }" disabled></td>
			<td>당월구매금액<input type="text" style="margin-left:24px; margin-right:100px;"class="right" id="nmm_sal_amt" value="${custVO.NMM_SAL_AMT }" disabled></td>
			<td>최종구매일<input type="text"  style="margin-left:18px; " class="right" id="lst_sal_dt" value="${custVO.LST_SAL_DT }" disabled></td>
		</tr>
	
	</table>
	</div>
	
	<div style="margin-left:120px;">
	<h4 style="margin:1px;">포인트</h4>
	<table id="pnt_tbl3">
		<tr>
			<td>총포인트<input type="text" id="tot_pnt" class="right" style="margin-left:36px; margin-right:126px;"  value="${custVO.TOT_PNT }" disabled></td>
			<td>당월적립포인트<input type="text" id="rsvg_pnt" class="right" style="margin-left:17px;  margin-right:83px;" value="${custVO.RSVG_PNT }" disabled></td>
			<td>당월사용포인트<input type="text" id="us_pnt" class="right" style="margin-left:5px; margin-right:43px;" value="${custVO.US_PNT }" disabled></td>
		</tr>
	</table>
	</div>
	
	
	
	<div style="margin-left:120px;">
	<h4  style="margin:1px;">수신동의(통합)</h4>
	
	<table id="su_tbl">
		<tr>
			<td style="padding-right:91px;"><i class="redstar" style="color:red;">*</i>
			이메일수신동의<input style="margin-left:10px; margin-right:10px;" type="radio" value="Y" name="email_rcv_yn" <c:if test="${custVO.EMAIL_RCV_YN eq 'Y'}">checked</c:if>>예
				<input type="radio"  value="N" id="e_no" name="email_rcv_yn" <c:if test="${custVO.EMAIL_RCV_YN eq 'N' || custVO.EMAIL_RCV_YN eq '' || custVO.EMAIL_RCV_YN eq null}">checked</c:if>/>아니오&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td style="padding-right:27px;"><i class="redstar" style="color:red;">*</i>
			SMS수신동의<input style="margin-left:30px; margin-right:10px;" type="radio" value="Y" name="sms_rcv_yn" <c:if test="${custVO.SMS_RCV_YN eq 'Y'}">checked</c:if>>예
				<input type="radio"  value="N" id="s_no" name="sms_rcv_yn" <c:if test="${custVO.SMS_RCV_YN eq 'N' || custVO.SMS_RCV_YN eq '' || custVO.SMS_RCV_YN eq null}">checked</c:if>/>아니오&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><i class="redstar" style="color:red;">*</i>
			DM수신동의<input style="margin-left:20px; margin-right:10px;" type="radio" value="Y" name="dm_rcv_yn" <c:if test="${custVO.DM_RCV_YN eq 'Y'}">checked</c:if>>예
				<input type="radio"  value="N" id="d_no" name="dm_rcv_yn" <c:if test="${custVO.DM_RCV_YN eq 'N' || custVO.DM_RCV_YN eq '' || custVO.DM_RCV_YN eq null}">checked</c:if>/>아니오</td>
	</tr>
	</table>
	</div>
	</form>
	
	
	<div>
	<table id="dat_tbl">
	<tr>
	<td><button type="button" id="cs_dat_2">닫기</button>	</td>
	<td><button type="button" id="updCust">저장</button></td>
	</tr>
	</table>
	</div>
	
		<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" />
		<input type="hidden" name="se_user_dt_cd" id="se_user_dt_cd" value="${sessionScope.member.user_dt_cd}" />
		<input type="hidden" name="se_prt_nm" id="se_prt_nm" value="${sessionScope.member.prt_nm}" />	
		
		
		
		<!-- 변경전 DATA START -->
		<form id="bf_form">
		<input type="hidden" name= "cust_no" id="bf_cust_no" value="${custVO.CUST_NO }">
		<input type="hidden" name= "cust_nm" id="bf_cust_nm" value="${custVO.CUST_NM }">
		<input type="hidden" name= "sex_cd" id="bf_sex_cd" value="${custVO.SEX_CD }">
		<input type="hidden" name= "scal_yn" id="bf_scal_yn" value="${custVO.SCAL_YN }">
		<input type="hidden" name= "brdy_dt" id="bf_brdy_dt" value="${custVO.BRDY_DT }">
		<input type="hidden" name= "mrrg_dt" id="bf_mrrg_dt" value="${custVO.MRRG_DT }">
		<input type="hidden" name= "poc_cd" id="bf_poc_cd" value="${custVO.POC_CD }">
		<input type="hidden" name= "mbl_no" id="bf_mbl_no" value="${custVO.MBL_NO1 }${custVO.MBL_NO2 }${custVO.MBL_NO3 }">
		<input type="hidden" id="bf_mbl_no1" value="${custVO.MBL_NO1 }">
		<input type="hidden" id="bf_mbl_no2" value="${custVO.MBL_NO2 }">
		<input type="hidden" id="bf_mbl_no3" value="${custVO.MBL_NO3 }">
		<input type="hidden" name= "psmt_grc_cd" id="bf_psmt_grc_cd" value="${custVO.PSMT_GRC_CD }">
		<input type="hidden" name= "email" id="bf_email" value="${custVO.EMAIL }">
		<input type="hidden" name= "email_dtl" id="bf_email_dtl" value="${custVO.EMAIL_DTL }">
		<input type="hidden" name= "addr" id="bf_addr" value="${custVO.ADDR }">
		<input type="hidden" name= "addr_dtl" id="bf_addr_dtl" value="${custVO.ADDR_DTL }">
		<input type="hidden" name= "cust_ss_cd" id="bf_cust_ss_cd" value="${custVO.CUST_SS_CD }">
		<input type="hidden" name= "cncl_cnts" id="bf_cncl_cnts" value="${custVO.CNCL_CNTS }">
		<input type="hidden" name= "jn_prt_cd" id="bf_jn_prt_cd" value="${custVO.JN_PRT_CD }">
		<input type="hidden" name= "email_rcv_yn" id="bf_email_rcv_yn" value="${custVO.EMAIL_RCV_YN }">
		<input type="hidden" name= "sms_rcv_yn" id="bf_sms_rcv_yn" value="${custVO.SMS_RCV_YN }">
		<input type="hidden" name= "dm_rcv_yn" id="bf_dm_rcv_yn" value="${custVO.DM_RCV_YN }">
		<input type="hidden" name= "js_dt" id="bf_js_dt" value="${custVO.JS_DT }">
		<input type="hidden" name= "stp_dt" id="bf_stp_dt" value="${custVO.STP_DT }">
		<input type="hidden" name= "cncl_dt" id="bf_cncl_dt" value="${custVO.CNCL_DT }">
		</form>
		<!-- 변경전 DATA END -->

		
		
		<input type="hidden" name="chkMblBtn" id="chkMblBtn" value="" />

		

</body>
</html>