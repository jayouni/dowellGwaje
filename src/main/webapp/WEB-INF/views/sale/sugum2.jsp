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
<title>고객판매수금등록</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
			
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
	
		//현재 날짜 
		$("#sal_dt").val(today);
		
		$("#btn_cust").click(function(){
			
			popUp_cust();
			
		});
		
		
		
		//플러스 버튼 눌렀을때 행 추가
		$("#plus").click(function(){
			
			// 마지막 Row(<tr>)
			var tr = $("#su_tbl2 >tbody tr:last");
			var td = tr.children('td').get();
			var id = td[1].id.replace("num", "");
			var seq = id == '' ? 1 : parseInt(id)+1;
			// 추가하는 Row의 번호
			var num = ($("#su_tbl2 >tbody tr").length)+1;
			
			console.log("seq"+seq);
			console.log("num"+num);
		
			
			$("#su_body2").append(
					
					"<tr><td><input type='checkbox' name='chkbox' style='border-left: 1px solid #00c8ff;'></td>"+
					"<td id='num"+seq+"'>"+num+"</td>"+
					"<td><input type='text' style='width:120px;text-align:center;' id='prd_cd"+seq+"' name='prd_cd"+seq+"' onkeydown='findJego("+seq+")'><button type='button' num='"+seq+"'id='jegoBtn' onclick='toJego("+seq+")' style='margin-left:2px;width:18px; height:20px;'>"+
					"<img src='../resources/image/dott.png' id='dot_img"+seq+"' style='height:13px;width:10px;' ></button></td>"+
					"<td><input type='text' id='prd_nm"+seq+"' name='prd_nm"+seq+"' style='width:130px; cursor: default;' class='center' readonly='readonly' onfocus='this.blur();'></td>"+
					"<input type='hidden' id='ivcOri"+seq+"' />"+
					"<td><input type='text' id='ivco_qty"+seq+"' name='ivco_qty"+seq+"' style='width:130px; cursor: default;' class='right' readonly='readonly' onfocus='this.blur();'></td>"+
					"<td><input type='text' id='sal_qty"+seq+"' name='sal_qty"+seq+"' style='width:50px; text-align: right;' class='sal_qty' oninput='inputNum(this)' readonly='readonly'></td>"+
					"<td><input type='text' id='csmr_upr"+seq+"' name='csmr_upr"+seq+"' style='width:130px; cursor: default;' class='right' readonly='readonly' onfocus='this.blur();'></td>"+
					"<td><input type='text' id='sal_amt"+seq+"' name='sal_amt"+seq+"' style='width:130px; cursor: default; text-align: right;' class='sal_amt' readonly='readonly' onfocus='this.blur();'></td>"+
					"<input type='hidden' id='vos_amt"+seq+"' name='vos_amt"+seq+"' class='vos_amt' />"+
					"<input type='hidden' id='vat_amt"+seq+"' name='vat_amt"+seq+"' class='vat_amt' />"+
					"</tr>");
		});
		
		//마이너스 버튼 눌렀을때 마지막 행 삭제 및 체크된 행 삭제
		$("#minus").click(function(){
			
			var chkBoxArr = $("input:checkbox[name='chkbox']:checked");
			
			console.log(JSON.stringify(chkBoxArr));
 			console.log("length : " + chkBoxArr.length);
 			
 			
			if(chkBoxArr.length > 0){
				
				delChkRow(chkBoxArr);
				
			} else{

				delRow();
				
			}
			
		
			
		});
		
		
 		//엔터시 바로 고객 찾는 함수 실행
		$("#cust_no").keydown(function(event){					
			if(event.keyCode == 13) { 									
				check_cust_data();					
				
			}
		}); 
		
		
 	 	 
 	 	 
  	 	//고객 명 지우면 고객 번호와 포인트 지워지게 하게
   	 	$("#cust_no").keyup(function(event){

   	 		var prdNm= $("#prd_nm").val();
  			var custDisNo = $("#cust_no_dis").val(); 	 	
   	 		var custNmHide = $("#custNmHide").val();
   	 		
  	 		if(event.keyCode == 8 || event.keyCode == 46) {  // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
  	           	
  	           if($("#cust_no").val() == "") {               
		             $("#cust_no_dis").val("");
		            $("#pnt_stlm_amt").val("");
		             $("#avb_pnt").val("");
		          }
	 	      
  	 		//고객 번호가 있고 , 행에 물건이 들어있을때 고객을 지우는 동작을 하면	
  	 	 	if(custDisNo != ''){
  	 			if(checkPrdNm() == true ) {
  	        	   
  	        	   if(confirm("불러온 상품이 존재합니다. 그래도 고객을 바꾸시겠습니까 ?")){
  	        		  
	  				reFresh();
  	        		   
  	        	   }else{
  	        		   
  	        		 $("#cust_no").val(custNmHide);

  	        	   }
  		          }
  	 		}
  	 	 }      
   	 	
  	 	 });// end key up
 	 	 
 	 	
 	 	 
 	 	 
		 // 모든 sal_qty의 변경에 반응
	    $(document).on('propertychange change keyup paste', ".sal_qty", function() {
	    	
	    	// 현재 Row(<tr>)
 	        var tr = $(this).parent().parent();
 	        var td = tr.children('td').get();
 	        
 	         
			var id = td[1].id.replace("num", "");
			var seq = '';
			//첫 번째 행 제외 , 행 생성시 생성된 td의 id로 seq 생성
 	        if(td[1].innerText != '1') {
 	        	seq = id ;
 	        	
 	        } 
 	        
	    	
 	        //수량 입력시 바뀌는 값들 넣기
	        var ivcOri = $("#ivcOri"+seq).val();
 			var ivco = $("#ivco_qty"+seq).val();
 			var qty = $("#sal_qty"+seq).val();
 			var upr = removeComma($("#csmr_upr"+seq).val());
 			var price = removeComma($("#sal_amt"+seq).val());
 			
 			
 			
 			//판매재고가 비어 있지 않을 때 
 			if(ivcOri != '') {
 				
 				
 				//판매수량이 비어 있다면 , 다시 판매 재고 원 상태 복귀  , 그리고 판매수량 0
	 				if(qty == ''){
	 	 				ivco = ivcOri;
	 	 				qty = '0';
	 	 			}

	 	 			
 					//숫자 계산용 값 변환
	 	 			var fQty = parseInt(qty);
	 	 			var fIvcOri = parseInt(ivcOri);
	 	 			var fIvco = parseInt(ivcOri) - parseInt(qty);
	 	 			var fPrice = parseInt(qty) * parseInt(upr);
	 	 			var fVat = fPrice * 0.1;
	 	 			var fVos = fPrice - fVat;
	 	 			
	 	 			//인풋창에 값 넣어주기
	 	 			$("#ivco_qty"+seq).val(fIvco);
	 	 			$("#sal_amt"+seq).val(addComma(fPrice+''));
	 	 			$("#vos_amt"+seq).val(fVos);
	 	 			$("#vat_amt"+seq).val(fVat);
	 	 			
	 				console.log('fQty : ' + fQty);
	 				console.log('fIvcOri : ' + fIvcOri);
	 				
	 				//판매수량이 매장재고보다 많이 쓰였을때
	 				if(fQty > fIvcOri){
	 					alert("매장 재고를 넘어섰습니다.");
	 					$("#ivco_qty"+seq).val(fIvcOri);
	 		 			$("#sal_amt"+seq).val('0');
	 		 			$("#sal_qty"+seq).val('0');
	 		 			$("#vos_amt"+seq).val('0');
	 		 			$("#vat_amt"+seq).val('0');
	 				}
	 				
	 				// 총 판매 수량
	 				var totQty = 0;
	 				//모든 행들에 쓰여 있는 판매 수량 값을 구하기 위해 
	 				$("input.sal_qty").each(function() {
	 		 			console.log("$(this).val() : " + $(this).val());
	 		 			var salQty = $(this).val();
	 		 			//판매 수량이 비어있다면 0 으로 만들어준다
	 		 			if(salQty == ''){
	 		 				salQty = '0';
	 		 			}
	 		 			//총 판매수량은 모든 판매수량을 변환하여 더한 값들
	 		 			totQty += parseInt(salQty);
	 		 		});
	 				console.log("totQty : " + totQty);
	 				
	 				//총 판매 금액
	 				var totAmt = 0;
	 				//모든 행들에 쓰여 있는 판매 금액을 구하기 위해 
	 				$("input.sal_amt").each(function() {
	 		 			console.log("$(this).val() : " + $(this).val());
	 		 			//콤마를 제거한 판매 금액 
	 		 			var salAmt = removeComma($(this).val());
	 		 			//판매 금액이 비어있다면 0으로 만들어준다
	 		 			if(salAmt == ''){
	 		 				salAmt = '0';
	 		 			}
	 		 			//총 판매 금액은 모든 판매 금액들은 변환하여 더한 값들
	 		 			totAmt += parseInt(salAmt);
	 		 		});
	 				console.log("totAmt : " + totAmt);
	 				
	 				//총 판매 공급 가액 = 소비자 판매가 - (소비자 판매가 * 10%)
	 				var totVos = 0;
	 				$("input.vos_amt").each(function() {
	 		 			console.log("$(this).val() : " + $(this).val());
	 		 			var vosAmt = $(this).val();
	 		 		    //공급가 금액이 비어있다면 0으로 만들어준다
	 		 			if(vosAmt == ''){
	 		 				vosAmt = '0';
	 		 			}
	 		 		    //총 공급가액은 모든 판매 금액들의 소비자 판매가 - (소비자 판매가 * 10%) 변환하여 더한 값들
	 		 			totVos += parseInt(vosAmt);
	 		 		});
	 				console.log("totVos : " + totVos);
	 				
	 				//총 판매 부가세액 = 소비자 판매가 * 10%
	 				var totVat = 0;
	 				$("input.vat_amt").each(function() {
	 		 			console.log("$(this).val() : " + $(this).val());
	 		 			var vatAmt = $(this).val();
	 		 		   //부가세 금액이 비어있다면 0으로 만들어준다
	 		 			if(vatAmt == ''){
	 		 				vatAmt = '0';
	 		 			}
	 		 		//총 판매 부가세액은 모든 판매 금액들의 소비자 판매가 * 10% 변환하여 더한 값들
	 		 			totVat += parseInt(vatAmt);
	 		 		});
	 				console.log("totVat : " + totVat);
	 				
	 				//값들을 저장한다
	 				$("#tot_sal_qty").val(totQty);
	 	 			$("#tot_sal_amt").val(addComma(totAmt+''));
	 	 			$("#tot_vos_amt").val(totVos);
	 	 			$("#tot_vat_amt").val(totVat);
 			}
			
	     });
 	 	 
 	 	 
		
		//창닫기
		$("#cancel").click(function(){
			
			cancel();
		});
		
		
		//현금 입력시 콤마 생성용
		$("#csh_stlm_amt").on('propertychange change keyup paste', function() {
			//console.log('현금 입력');
			var cshStlmAmt = removeComma($(this).val());
			this.value = addComma(cshStlmAmt);
		});
		
		
		//포인트 입력시 콤마 생성 및 포인트 가능액 지정
		$("#pnt_stlm_amt").on('propertychange change keyup paste', function() {
			//console.log('포인트사용액 입력');
			var pntStlmAmt = removeComma($(this).val());
			this.value = addComma(pntStlmAmt);
			var avbPnt = removeComma($('#avb_pnt').val());
			console.log('pntStlmAmt : ' + pntStlmAmt);
			console.log('avbPnt : ' + avbPnt);
			if(pntStlmAmt != '' && avbPnt != '') {
				if(parseInt(pntStlmAmt) > parseInt(avbPnt)) {
					alert('포인트가능액 보다 크게 사용할 수 없습니다');
					$("#pnt_stlm_amt").val('');
					$("#pnt_stlm_amt").focus();
				}
			}
		});
		
		//포인트 100미만 입력시 사용하지 못하게
		$("#pnt_stlm_amt").on('blur', function() {
			//console.log('포인트사용액 입력');
			var pntStlmAmt = removeComma($(this).val());
			var avbPnt = removeComma($('#avb_pnt').val());
			console.log('pntStlmAmt : ' + pntStlmAmt);
			console.log('avbPnt : ' + avbPnt);
			if(pntStlmAmt != '' && avbPnt != '') {
				if(parseInt(pntStlmAmt) < 100) {
					alert('최소 포인트사용액은 100이상 입니다');
					$("#pnt_stlm_amt").val('');
					$("#pnt_stlm_amt").focus();
				}
			}
		});
		
		
		//카드 입력칸 
		$("#crd_stlm_amt").on('propertychange change keyup paste', function() {
			//console.log('카드금액 입력');
			//콤마 생성용
			var crdStlmAmt = removeComma($(this).val());
			this.value = addComma(crdStlmAmt);
			console.log('crdStlmAmt : ' + crdStlmAmt);
			
			//카드 값 입력시 disabled 여닫기 처리
			if(crdStlmAmt != '') {
				$("#vld_ym").attr("disabled", false);
				$("#crd_co_cd").attr("disabled", false);
				$("#crd_no1").attr("disabled", false);
				$("#crd_no2").attr("disabled", false);
				$("#crd_no3").attr("disabled", false);
				$("#crd_no4").attr("disabled", false);
			} else {
				$("#vld_ym").val("");
				$("#crd_co_cd").val("").prop("selected", true);
				$("#crd_no1").val("");
				$("#crd_no2").val("");
				$("#crd_no3").val("");
				$("#crd_no4").val("");
				
				$("#vld_ym").attr("disabled", true);
				$("#crd_co_cd").attr("disabled", true);
				$("#crd_no1").attr("disabled", true);
				$("#crd_no2").attr("disabled", true);
				$("#crd_no3").attr("disabled", true);
				$("#crd_no4").attr("disabled", true);
			}
		});
		

		
		
	}); //document ready end
	
	
	function reFresh(){
		window.location.reload();
	}



	
	// 바로 물건 재고를 가져오기 위한 ajax
	function findJego(seq){
		if(event.keyCode == 13) {
			var prt_cd = $("#se_prt_cd").val();
			var prd_nm = $("#prd_cd"+seq).val();
			
			
	    	
	    	$.ajax({
				url:"<%= request.getContextPath()%>/search/jegoJo",
				data: {"prt_cd":prt_cd
					 , "prd_nm":prd_nm
					 , "seq":seq
				}, 
				dataType:"JSON", 														
				type:"POST",															
				success:function(json){ 
					console.log(json);												
					if(json.length == 1) {
						
						
						
						var prdCd = json[0].PRD_CD;
						var prdNm = json[0].PRD_NM;
						var ivco = json[0].IVCO_QTY;
						var csmr = json[0].PRD_CSMR_UPR;
						var ssCd = json[0].PRD_SS_CD;
						var tpCd = json[0].PRD_TP_CD;
						var salQty = 0;
						var salAmt = 0;
						var vosAmt = 0;
						var vatAmt = 0;
						var seq = json[0].SEQ;
						var toPrdCd = prdCd.toString();
						console.log("toPrdCd" + toPrdCd);

						var obj = {
						           "seq" : seq
						          ,"prdCd" : prdCd
						};
						
						//console.log('Enter sugum2 checkDupPrd Start');
						if(checkDupPrd(obj)) {
							alert('입력하신 상품들 중에 동일한 상품이 있습니다');
							$("#prd_cd"+seq).val("");
							return;
						}
						
						
						$("#prd_cd"+seq).val(prdCd);
						$("#toPrdCd").val(toPrdCd);
						$("#chkPrdCd").val(prdCd);
						
						$("#prd_nm"+seq).val();
						$("#ivco_qty"+seq).val(ivco);
						$("#ivcOri"+seq).val(ivco);
						$("#sal_qty"+seq).val(salQty);
						$("#csmr_upr"+seq).val(csmr);
						$("#sal_amt"+seq).val(salAmt);
						$("#vos_amt"+seq).val(vosAmt);
						$("#vat_amt"+seq).val(vatAmt);
						
						
						//상품 코드가 아무 글자이거나 있지 않는 상품일때 판매 수량을 막기 위한 코드
						var chkNm = $("#prd_nm"+seq).val(prdNm);
						if(chkNm != ''){
							
							$("#sal_qty"+seq).attr("readonly", false);
						}
						
						
						//견본품일 때 알럿창
						if(tpCd == '20'){
							
							alert("견본품 입니다. 다시 골라 주세요.");
							$("#prd_cd"+seq).val("");
							$("#prd_nm"+seq).val("");
							$("#ivco_qty"+seq).val("");
							$("#sal_qty"+seq).val("");
							$("#csmr_upr"+seq).val("");
							$("#sal_amt"+seq).val("");
							$("#vos_amt"+seq).val("");
							$("#vat_amt"+seq).val("");
							
						}
						
						//소비자가가 0일 때
						if(csmr == '0'){
							alert("소비자가가 0 입니다. 다시 골라 주세요.");
							$("#prd_cd"+seq).val("");
							$("#prd_nm"+seq).val("");
							$("#ivco_qty"+seq).val("");
							$("#sal_qty"+seq).val("");
							$("#csmr_upr"+seq).val("");
							$("#sal_amt"+seq).val("");
							$("#vos_amt"+seq).val("");
							$("#vat_amt"+seq).val("");
							
						}
						
						//해지 상품 일때
						if(ssCd == 'C'){
							alert("해지 상품입니다. 다시 골라 주세요.");
							$("#prd_cd"+seq).val("");
							$("#prd_nm"+seq).val("");
							$("#ivco_qty"+seq).val("");
							$("#sal_qty"+seq).val("");
							$("#csmr_upr"+seq).val("");
							$("#sal_amt"+seq).val("");
							$("#vos_amt"+seq).val("");
							$("#vat_amt"+seq).val("");
							
						}
						
						//상품 재고가 0 일때
						if(ivco == '0'){
							alert("상품 재고가 없습니다. 다시 골라 주세요.");
							$("#prd_cd"+seq).val("");
							$("#prd_nm"+seq).val("");
							$("#ivco_qty"+seq).val("");
							$("#sal_qty"+seq).val("");
							$("#csmr_upr"+seq).val("");
							$("#sal_amt"+seq).val("");
							$("#vos_amt"+seq).val("");
							$("#vat_amt"+seq).val("");
							
						}
						
						
					}
					else {
						alert('일치하는 값이 없거나 두개 이상입니다');
						popUp_jego4({"SEQ":json[0].SEQ});
					}
					
				},
				error: function(){
					alert("실패");
				}
			}); // end of $.ajax
		}
		
		//console.log('findJego enterkey event before');
		//상품 코드 다 지웠을때 다시 계산 용
		if(event.keyCode == 8 || event.keyCode == 46) {  // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
			//console.log('findJego enterkey event after');

		
			var prd_cd = $("#prd_cd"+seq).val();
			var prd_nm = $("#prd_nm"+seq).val();
			var chkPrdCd = $("#chkPrdCd").val();

			
			if(prd_nm != '') {
				
				if(confirm("상품을 변경 하시겠습니까 ?")){
					$("#prd_cd"+seq).val('');
					$("#prd_nm"+seq).val('');
					$("#ivco_qty"+seq).val('');
					$("#ivcOri"+seq).val('');
					$("#sal_qty"+seq).val('');
					$("#csmr_upr"+seq).val('');
					$("#sal_amt"+seq).val('');
					$("#vos_amt"+seq).val('');
					$("#vat_amt"+seq).val('');
		 			
		 			var totQty = 0;
		 			$("input.sal_qty").each(function() {
		 	 			console.log("$(this).val() : " + $(this).val());
		 	 			var salQty = $(this).val();
		 	 			if(salQty == ''){
		 	 				salQty = '0';
		 	 			}
		 	 			totQty += parseInt(salQty);
		 	 		});
		 			console.log("totQty : " + totQty);
		 			
		 			var totAmt = 0;
		 			$("input.sal_amt").each(function() {
		 	 			console.log("$(this).val() : " + $(this).val());
		 	 			var salAmt = removeComma($(this).val());
		 	 			if(salAmt == ''){
		 	 				salAmt = '0';
		 	 			}
		 	 			totAmt += parseInt(salAmt);
		 	 		});
		 			console.log("totAmt : " + totAmt);
		 			
		 			var totVos = 0;
		 			$("input.vos_amt").each(function() {
		 	 			console.log("$(this).val() : " + $(this).val());
		 	 			var vosAmt = $(this).val();
		 	 			if(vosAmt == ''){
		 	 				vosAmt = '0';
		 	 			}
		 	 			totVos += parseInt(vosAmt);
		 	 		});
		 			console.log("totVos : " + totVos);
		 			
		 			var totVat = 0;
		 			$("input.vat_amt").each(function() {
		 	 			console.log("$(this).val() : " + $(this).val());
		 	 			var vatAmt = $(this).val();
		 	 			if(vatAmt == ''){
		 	 				vatAmt = '0';
		 	 			}
		 	 			totVat += parseInt(vatAmt);
		 	 		});
		 			console.log("totVat : " + totVat);
		 			
		 			$("#tot_sal_qty").val(totQty);
		 			$("#tot_sal_amt").val(addComma(totAmt+''));
		 			$("#tot_vos_amt").val(totVos);
		 			$("#tot_vat_amt").val(totVat);
					
				}else {
					
					//값을 세팅해주는 속도보다 백스페이스가 나중에 눌려서 값이 지워지는걸 방지하기 위해
					setTimeout(function() {
						
						$("#prd_cd"+seq).val(chkPrdCd);
					}, 125); //  0.125초 후 함수가 실행됨
					
				}
				
			}
			
			
 			}
		//}
    	
    } // end of  findjego()
    
    
    // List 중에 동일 상품 있는지 확인
    function checkDupPrd(obj) {
    	//debugger;
    	var result = false;
    	var prd_cd = obj.prdCd;
    	var bfSeq = obj.seq;
		$("input:checkbox[name='chkbox']").each(function(k, kVal) {
 			console.log("kVal :: ", kVal.parentElement.parentElement);
            
 	        // 현재 Row(<tr>)
 	        var tr = kVal.parentElement.parentElement;
 	        var td = tr.children;
 	        var input = td[2].children;
 	        var val = input[0].value;
 	         
			var id = td[1].id.replace("num", "");
			var afSeq = id ;
 	        
 	        console.log('val : ' + val + ' : ' + typeof(val));
 	        console.log('prd_cd : ' + prd_cd + ' : ' + typeof(prd_cd));
 	        console.log(val == prd_cd);
 	        
 	        
 	       	if(bfSeq != afSeq) {
 	        	if(val == prd_cd) {
 	        		result = true;
 	        		// break;
 	        		return false;
 	        	}
 	       	}
 		});
		
		console.log('return : ' + result);
		return result;
    }
    
    
    
    //행에 가져온 상품이 존재하는지 여부 체크 
    function checkPrdNm() {
    	//debugger;
    	var result = false;
		$("input:checkbox[name='chkbox']").each(function(k, kVal) {
 			console.log("kVal :: ", kVal.parentElement.parentElement);
            
 	        // 현재 Row(<tr>)
 	        var tr = kVal.parentElement.parentElement;
 	        var td = tr.children;
 	        var input = td[2].children;
 	        var val = input[0].value;
 	        
 	        console.log('checkPrdNm val : ' + val + ' : ' + typeof(val));
 	        
 	        if(val != '') {
 	        	result = true;
 	        	// break;
 	        	return false;
 	        }
 		});
		
		console.log('return : ' + result);
		return result;
    }
	
	
	
	
	// 엔터 클릭시 회원 이름 가져오기
	function check_cust_data() {
		
		var check_cust = $("#cust_no").val();
		var mbl_no = '';
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
					var avbPnt = json[0].AVB_PNT;
					
					$('#cust_no_dis').val(custNo);
					$('#cust_no').val(custNm);
					$('#avb_pnt').val(avbPnt);
					$("#custNmHide").val(custNm);
					
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

	
	
	//행에 매겨진 seq를 들고 팝업 띄우기
	function toJego(seq){
		
		var item = {
			"SEQ":seq
		};
		
		popUp_jego4(item);
		
	}
	
	
	
	//체크 박스 된 행 삭제
	function delChkRow(chkBoxArr){
		
 		chkBoxArr.each(function(k, kVal) {
 			console.log("kVal :: ", kVal.parentElement.parentElement);
 	        var tdArr = new Array();    // 배열 선언
            
 	        // 현재 Row(<tr>)
 	        var tr = kVal.parentElement.parentElement;
 	        var td = tr.children;
 	        
 	        console.log(td[1].innerText);
 	        
 	        //첫번째 행은 제외한 것들이 체크되었을때 삭제 
 	        if(td[1].innerText != "1") {
 	        	$(tr).remove();
 	        
 	        //첫 번째 행이 체크 되었을 때 삭제
 	        } else {
 	        	
 	        	//첫번째 행은 값을 날린다
 	        	$("input:checkbox[name='chkbox']:checked").removeAttr('checked');
 	        	$("#prd_cd").val("");
				$("#prd_nm").val("");
				$("#ivco_qty").val("");
				$("#ivcOri").val("");
				$("#sal_qty").val("");
				$("#sal_qty").attr("readonly", true);
				$("#csmr_upr").val("");
				$("#sal_amt").val("");
				$("#vos_amt").val("");
				$("#vat_amt").val("");
 	        }
 	        
 	       //지워진 행 때문에 섞이는 번호를 다시 매김 
 	       resetNum();
 	            
 		});
 		
 		//계산용
 		var totQty = 0;
		$("input.sal_qty").each(function() {
 			console.log("$(this).val() : " + $(this).val());
 			var salQty = $(this).val();
 			if(salQty == ''){
 				salQty = '0';
 			}
 			totQty += parseInt(salQty);
 		});
		console.log("totQty : " + totQty);
		
		var totAmt = 0;
		$("input.sal_amt").each(function() {
 			console.log("$(this).val() : " + $(this).val());
 			var salAmt = removeComma($(this).val());
 			if(salAmt == ''){
 				salAmt = '0';
 			}
 			totAmt += parseInt(salAmt);
 		});
		console.log("totAmt : " + totAmt);
		
		var totVos = 0;
		$("input.vos_amt").each(function() {
 			console.log("$(this).val() : " + $(this).val());
 			var vosAmt = $(this).val();
 			if(vosAmt == ''){
 				vosAmt = '0';
 			}
 			totVos += parseInt(vosAmt);
 		});
		console.log("totVos : " + totVos);
		
		var totVat = 0;
		$("input.vat_amt").each(function() {
 			console.log("$(this).val() : " + $(this).val());
 			var vatAmt = $(this).val();
 			if(vatAmt == ''){
 				vatAmt = '0';
 			}
 			totVat += parseInt(vatAmt);
 		});
		console.log("totVat : " + totVat);
		
		$("#tot_sal_qty").val(totQty);
		$("#tot_sal_amt").val(addComma(totAmt+''));
		$("#tot_vos_amt").val(totVos);
		$("#tot_vat_amt").val(totVat);

	}
	

	
	
	
	//체크 박스를 체크 하지 않고 마이너스 버튼을 누르면 밑에서 부터 삭제 됌
	function delRow(){
		
		var length = $("input:checkbox[name='chkbox']").length;
		console.log(length);
		
		if(length > 0){
			// 마지막 Row(<tr>)
			var tr = $("#su_tbl2 >tbody tr:last");
			var td = tr.children('td').get();
			
			if(td[1].innerText != '1') {
				$("#su_tbl2 >tbody tr:last").remove();
				
				//다시 계산
				var totQty = 0;
				$("input.sal_qty").each(function() {
		 			console.log("$(this).val() : " + $(this).val());
		 			var salQty = $(this).val();
		 			if(salQty == ''){
		 				salQty = '0';
		 			}
		 			totQty += parseInt(salQty);
		 		});
				console.log("totQty : " + totQty);
				
				var totAmt = 0;
				$("input.sal_amt").each(function() {
		 			console.log("$(this).val() : " + $(this).val());
		 			var salAmt = removeComma($(this).val());
		 			if(salAmt == ''){
		 				salAmt = '0';
		 			}
		 			totAmt += parseInt(salAmt);
		 		});
				console.log("totAmt : " + totAmt);
				
				var totVos = 0;
				$("input.vos_amt").each(function() {
		 			console.log("$(this).val() : " + $(this).val());
		 			var vosAmt = $(this).val();
		 			if(vosAmt == ''){
		 				vosAmt = '0';
		 			}
		 			totVos += parseInt(vosAmt);
		 		});
				console.log("totVos : " + totVos);
				
				var totVat = 0;
				$("input.vat_amt").each(function() {
		 			console.log("$(this).val() : " + $(this).val());
		 			var vatAmt = $(this).val();
		 			if(vatAmt == ''){
		 				vatAmt = '0';
		 			}
		 			totVat += parseInt(vatAmt);
		 		});
				console.log("totVat : " + totVat);
				
				$("#tot_sal_qty").val(totQty);
	 			$("#tot_sal_amt").val(addComma(totAmt+''));
	 			$("#tot_vos_amt").val(totVos);
	 			$("#tot_vat_amt").val(totVat);
			}
		}
		
	}
	
	
	//행 삭제 후 다시 생성시 번호가 섞여, 번호를 다시 매김
	function resetNum() {
		$("input:checkbox[name='chkbox']").each(function(k, kVal) {
 			console.log("kVal :: ", kVal.parentElement.parentElement);
 	        var tdArr = new Array();    // 배열 선언
            
 	        // 현재 Row(<tr>)
 	        var tr = kVal.parentElement.parentElement;
 	        var td = tr.children;
 	        
 	        console.log(td[1].innerText);
 	        console.log("k+1 : " + k+1);
 	        
 	        td[1].innerText = k + 1;
 	            
 		});
	}
	
	//창 닫기
	function cancel(){
		
		window.close();
	}
	
	

		
		
		//카드 유효년월 용 유효성 날짜
		function inputValidThru(period) {

	        // replace 함수를 사용하여 슬래시( / )을 공백으로 치환한다.
	        var replaceCard = period.value.replace(/\//g, "");

	        // 텍스트박스의 입력값이 6글자가 되는 경우에만 실행한다.
	        if(replaceCard.length >= 6 && replaceCard.length < 7) {

	            var inputMonth = replaceCard.substring(0, 2);    // 선언한 변수 month에 월의 정보값을 담는다.
	            var inputYear = replaceCard.substring(2, 6);     // 선언한 변수 year에 년의 정보값을 담는다.
	            
	            console.log('inputMonth : ' + inputMonth);
	            console.log('inputYear : ' + inputYear);

	            // 현재 날짜 값을 구한다.

	            var nowDate = new Date();
	            var nowMonth = autoLeftPad(nowDate.getMonth() + 1, 2);
	            var nowYear = nowDate.getFullYear().toString();
	            
	            console.log('nowMonth : ' + nowMonth);
	            console.log('nowYear : ' + nowYear);


	            // isFinite함수를 사용하여 문자가 선언되었는지 확인한다.
	            if(isFinite(inputMonth + inputYear) == false) {
	                alert("문자는 입력하실 수 없습니다.");
	                period.value = autoLeftPad((Number(nowMonth) + 1), 2) + "/" + nowYear;
	                return false;
	            }

	            // 입력한 월이 12월 보다 큰 경우
	            if(inputMonth > 12) {
	                alert("12월보다 큰 월수는 입력하실 수 없습니다. ");
	                period.value = "12/" + inputYear;
	                return false;
	            }

	            // 입력한 유효기간을 현재날짜와 비교하여 사용 가능 여부를 판단한다.
	            if((inputYear + inputMonth) <= (nowYear + nowMonth)) {
	                alert("유효기간이 만료된 카드는 사용하실 수 없습니다.");
	                period.value = inputMonth + "/" + (Number(nowYear) + 1);
	                return false;
	            }
	            period.value = inputMonth + "/" + inputYear;
	        }
	    }



	    // 1자리 문자열의 경우 앞자리에 숫자 0을 자동으로 채워 00형태로 출력하기위한 함수
	    function autoLeftPad(num, digit) {
	        if(String(num).length < digit) {
	            num = new Array(digit - String(num).length + 1).join('0') + num;
	        }
	        return num;
	    }
	    
	    
	    // 저장 버튼 클릭 처리 function
	    function saveSal() {
	    	//console.log('저장 버튼');
	    	// 1. validation check
	    	// 2. 각 Query문에 사용할 Map/List 생성
	    	// 3. 생성한 Map/List를 하나의 Map에 담기
	    	// 4. ajax를 통하여 저장처리
	    	// 5. 저장완료 alert 보여주고 window close
	    	
	    	// 유효성 검사
	    	if(saveValChk()) {
	    		return;
	    	}
	    	
	    	// 2. 각 Query문에 사용할 Map/List 생성
	    	var suFrm1 = $('#su_form1').serializeArray();
	    	var suFrm2 = $('#su_form2').serializeArray();
	    	var totFrm = $('#tot_form').serializeArray();
	    	console.log(JSON.stringify(suFrm1));
	    	console.log(JSON.stringify(suFrm2));
	    	console.log(JSON.stringify(totFrm));
	    	
	    	// CS_SAL01_DT Insert Data 생성
	    	var salDtList = newSalDtList(suFrm2);
	    	console.log('salDtList : ' + JSON.stringify(salDtList));
	    	
	    	var suFrm1Obj = objToJson(suFrm1);
	    	var totFrmObj = objToJson(totFrm);
	    	// CS_SAL01_MT Insert Data 생성
	    	var crd_no = $('#crd_no1').val() + $('#crd_no2').val() + $('#crd_no3').val() + $('#crd_no4').val();
	    	var vld_ym = $('#vld_ym').val().replace(/\//g, "");
	    	var crd_co_cd = $("select[name='crd_co_cd']").val();
	    	
	    	// crd_stlm_amt/csh_stlm_amt/pnt_stlm_amt DB NullAble No 때문에 Default 0 처리
	    	var crd_stlm_amt = suFrm1Obj.crd_stlm_amt == '' ? 0 : parseInt(suFrm1Obj.crd_stlm_amt);
	    	var csh_stlm_amt = suFrm1Obj.csh_stlm_amt == '' ? 0 : parseInt(suFrm1Obj.csh_stlm_amt);
	    	var pnt_stlm_amt = suFrm1Obj.pnt_stlm_amt == '' ? 0 : parseInt(suFrm1Obj.pnt_stlm_amt);
	    	var salMtMap = {
	    			"prt_cd" : $('#se_prt_cd').val()
	    			,"sal_tp_cd" : suFrm1Obj.sal_tp_cd
	    			,"tot_sal_qty" : totFrmObj.tot_sal_qty
	    			,"tot_sal_amt" : totFrmObj.tot_sal_amt
	    			,"tot_vos_amt" : totFrmObj.tot_vos_amt
	    			,"tot_vat_amt" : totFrmObj.tot_vat_amt
	    			,"csh_stlm_amt" : csh_stlm_amt
	    			,"crd_stlm_amt" : crd_stlm_amt
	    			,"pnt_stlm_amt" : pnt_stlm_amt
	    			,"cust_no" : suFrm1Obj.cust_no_dis
	    			,"crd_no" : crd_no
	    			,"vld_ym" : vld_ym
	    			,"crd_co_cd" : crd_co_cd
	    			,"org_shop_cd" : ""
	    			,"org_sal_dt" : ""
	    			,"org_sal_no" : ""
	    	};
	    	console.log('salMtMap : ' + JSON.stringify(salMtMap));
	    	
	    	// CS_CUST_PNT_D/CS_CUST_PNT_M Table Insert/Update Data 생성
	    	// 포인트 미사용일 경우 지불한 값의 10%를 포인트 적립
	    	var pntList = new Array();
	    	var pnt = (crd_stlm_amt + csh_stlm_amt) * 0.1;
	    	var pntMap = {
	    			"cust_no" : suFrm1Obj.cust_no_dis
	    			,"pnt_ds_cd" : "100"
	    			,"pnt_ds_dt_cd" : "101"
	    			,"pnt" : pnt
	    	};
	    	pntList.push(pntMap);
	    	// 구매시 포인트를 사용 할 경우 , 포인트 테이블에서 쓴 포인트를 차감
	    	if(pnt_stlm_amt > 0) {
	    		var pntMap = {
	        			"cust_no" : suFrm1Obj.cust_no_dis
	        			,"pnt_ds_cd" : "200"
	        			,"pnt_ds_dt_cd" : "201"
	        			,"pnt" : pnt_stlm_amt
	        	};
	    		pntList.push(pntMap);
	    	}
	    	console.log('salDtList : ' + JSON.stringify(salDtList));
	    	console.log('salMtMap : ' + JSON.stringify(salMtMap));
	    	console.log('pntList : ' + JSON.stringify(pntList));
	    	
	    	// save ajax
	    	$.ajax({
				url:"<%= request.getContextPath()%>/search/newSal88",
				data: {"salDtList": JSON.stringify(salDtList)
					,"salMtMap" : JSON.stringify(salMtMap)
					,"pntList" : JSON.stringify(pntList)
					} ,
				type: 'post',
				dataType: "JSON",
				async: false,
				success: function(json){
					console.log(json);
					//alert("성공");
					if(json.rst == '1'){
						alert('판매등록이 정상적으로 완료 되었습니다');
						window.close();
					} else {
						alert(json.rst);
					}

				},
				error: function( error){
					
					alert("전송 실패");
				}
					
			});
	    	
	    }
	    
	    
	    
	    // return boolean
	    function saveValChk() {
	    	
	    	// 고객번호 체크
	    	var cust_no = $('#cust_no_dis').val();
	    	if(cust_no == '') {
	    		alert('고객번호는 필수 값입니다.');
	    		$('#cust_no').focus();
	    		return true;
	    	}
	    	
	    	//tot_sal_qty 비어있으면 저장 안되게 
	    	var totSalQty = $('#tot_sal_qty').val();
	    	if(totSalQty == '') {
	    		alert('판매 등록 할 상품이 없습니다. 등록 확인 해주세요.');
	    		$('#prd_cd').focus();
	    		return true;
	    	}
	    	
	    	
	    	// 카드금액이 있는 경우 유효일자/카드회사/카드번호 체크
	    	var crd_stlm_amt = removeComma($('#crd_stlm_amt').val());
	    	if(crd_stlm_amt != '') {
	    		var vld_ym = $('#vld_ym').val();
	    		var crd_co_cd = $("select[name='crd_co_cd']").val();
	    		var crd1 = $('#crd_no1').val();
	    		var crd2 = $('#crd_no2').val();
	    		var crd3 = $('#crd_no3').val();
	    		var crd4 = $('#crd_no4').val();
	    		var crd_no = $('#crd_no1').val() + $('#crd_no2').val() + $('#crd_no3').val() + $('#crd_no4').val();
	    		//console.log(vld_ym + ' : ' + crd_co_cd + ' : ' + crd_no);
	    		
	    		if(vld_ym == '') {
	    			alert('유효일자는 필수 값입니다.');
	    			return true;
	    		}
	    		if(crd_co_cd == '') {
	    			alert('카드회사는 필수 값입니다.');
	    			return true;
	    		}
	    		
	    		if(crd_no == '') {
	    			alert('카드번호는 필수 값입니다.');
	    			return true;
	    		}
	    		
	    		if(crd1 == ''){
	    			alert('첫 번째 카드번호칸이 비어있습니다.');
	    			$('#crd_no1').focus();
	    			return true;
	    		}
	    		if(crd2 == ''){
	    			alert('두 번째 카드번호칸이 비어있습니다.');
	    			$('#crd_no2').focus();
	    			return true;
	    		}
	    		if(crd3 == ''){
	    			alert('세 번째 카드번호칸이 비어있습니다.');
	    			$('#crd_no3').focus();
	    			return true;
	    		}
	    		if(crd4 == ''){
	    			alert('네 번째 카드번호칸이 비어있습니다.');
	    			$('#crd_no4').focus();
	    			return true;
	    		}
	    		
	    		if(crd1.length < 4){
	    			alert('첫 번째 카드번호칸 필수 4자리 입니다.');
	    			$('#crd_no1').focus();
	    			return true;
	    		}
	    		if(crd2.length < 4){
	    			alert('두 번째 카드번호칸 필수 4자리 입니다.');
	    			$('#crd_no2').focus();
	    			return true;
	    		}
	    		if(crd3.length < 4){
	    			alert('세 번째 카드번호칸 필수 4자리 입니다.');
	    			$('#crd_no3').focus();
	    			return true;
	    		}
	    		if(crd4.length < 4){
	    			alert('네 번째 카드번호칸 필수 4자리 입니다.');
	    			$('#crd_no4').focus();
	    			return true;
	    		}

	    	}
	    	
	    	// 3. 결제금액 존재 여부 체크
	    	// 4. 판매금액 존재 여부 체크
	    	// 5. 현금 + 카드금액 + 포인트사용액 == 합계 행의 판매금액 체크
	    	crd_stlm_amt = crd_stlm_amt == '' ? 0 : parseInt(crd_stlm_amt);
	    	var csh_stlm_amt = removeComma($('#csh_stlm_amt').val()) == '' ? 0 : parseInt(removeComma($('#csh_stlm_amt').val()));
	    	var pnt_stlm_amt = removeComma($('#pnt_stlm_amt').val()) == '' ? 0 : parseInt(removeComma($('#pnt_stlm_amt').val()));
	    	var tot_sal_amt = removeComma($('#tot_sal_amt').val()) == '' ? 0 : parseInt(removeComma($('#tot_sal_amt').val()));
	    	
	    	console.log('결제금액 : ' + (csh_stlm_amt+crd_stlm_amt+pnt_stlm_amt));
	    	console.log('판매금액 : ' + tot_sal_amt);
	    	
	    	if((csh_stlm_amt+crd_stlm_amt+pnt_stlm_amt) == 0) {
	    		alert('결제금액이 없습니다. 결제금액을 입력하여 주시기 바랍니다.');
	    		$('#csh_stlm_amt').focus();
    			return true;
	    	}
	    	if(tot_sal_amt == 0) {
	    		alert('판매금액이 없습니다. 판매금액을 확인 해주시기 바랍니다.');
    			return true;
	    	}
	    	if((csh_stlm_amt+crd_stlm_amt+pnt_stlm_amt) != tot_sal_amt) {
	    		alert('결제금액과 판매금액이 일치하지 않습니다. 다시 확인 해주시기 바랍니다.');
    			return true;
	    	}
	    	
	    	return false;
	    }
	    
	    
	    //data는 Array(List)
		//CS_SAL01_DT Insert Data 생성 (return array)
		function newSalDtList(data) {
			//변경 된 data list 담을 변수 생성
			var list = new Array();
			var prt_cd = $('#se_prt_cd').val();
			
			var len = data.length;
			var i = $("input:checkbox[name='chkbox']").length;
			// input:checkbox 수 = 전체 row 수
			// 전체 name 수 / 전체 row 수 = 한 row name 수  
			var n = data.length / i;
			var cnt = Math.floor(len / n) + (Math.floor(len % n) > 0 ? 1 : 0)
			console.log(len + ' : ' + n + ' : ' + cnt);
			
			for(var i = 0; i < cnt; i++) {
				//CS_SAL01_DT Insert Data
				var row = objToJson(data.splice(0, n));
				row.prt_cd = prt_cd
				console.log(row.prd_cd + ' : ' + row.sal_qty + ' : ' + row.sal_amt);
				//상품코드 입력창에 아무 값이나 들어갔을 경우 저장이 되는 걸 막기 위해 상품명이 비어있지 않을 때도 포함하여 저장
				if(row.prd_cd != '' && row.prd_nm != '' && row.sal_qty != '' && row.sal_amt != '0') {
					list.push(row);
				}
			}
			
			return list;
		}

		
					
					
		//serializeArray()를 매개변수로 받아처리
		//return object(key:value)
		function objToJson(formData) {
			var data = formData;
			var obj = {};
			var name = '';
			$.each(data, function(idx, ele) {
				name = strNumToStr(ele.name);
				//천단위 콤마 제거
				obj[name] = removeComma(ele.value)
			});
			
			return obj;
		}
		
		// 문자+숫자에서 숫자만 추출하여 return(String)
		function strNumToNum(obj) {
			const regex = /[^0-9]/g;
			const result = obj.toString().replace(regex, "");
			
			return result;
		}
		
		// 문자+숫자에서 문자만 추출하여 return(String)
		function strNumToStr(obj) {
			const regex = /[(0-9)]/gi;
			const result = obj.toString().replace(regex, "");
			
			return result;
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
		
		//숫자만 입력 되도록 처리
		function inputNum(obj) {
			obj.value = obj.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
			obj.value = obj.value.replace(/(^0+)/, "");
		}
		
		
		//팝팝
		
		function popUp_jego4(item){
			  
			  var jegoPop = document.jegoPop;    
			  var url = 'http://localhost:8080/gwaje/sale/jegoPopup';
			  var title = "popup4";
			  var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=990, height=800, top=80,left=300";
			  window.open('',title,status);            
			  jegoPop.action = url;     
			  jegoPop.target = title; //window,open()의 두번째 인수와 같아야 하며 필수다.  
			  jegoPop.method="post";
			  jegoPop.SEQ.value = item.SEQ;
			  jegoPop.submit();
			  
		} 
	
		function popUp_cust(){
			
			var url = "http://localhost:8080/gwaje/search/customer";
			var title = "popup_cust";
			var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
			window.open(url, title, status);
			
		}

</script>
</head>
<body>
	<h4 style="margin:5px 5px;">고객판매수금등록</h4>
	<form id="su_form1">
	<table id="pansu_tbl">
		<tr>
			<td><i class="redstar" style="color:red;">*</i>판매일자<input style="margin-left:20px;margin-right:20px; width:133px;" type="date" name="sal_dt" id="sal_dt" disabled>
			<i class="redstar" style="color:red;">*</i>전체
					<select name="sal_tp_cd" style="width:137px; margin-left:1px;">
					<option value="SAL">판매</option>
			</select>
			</td>
		</tr>
		<tr>
			<td><i class="redstar" style="color:red;">*</i>고객번호<input style="margin-left:20px;margin-right:15px; width:130px;" type="text" name="cust_no_dis" id="cust_no_dis" style="width:135px;" readonly="readonly" class="disabled" onfocus="this.blur();">
			<button type="button" id="btn_cust" style="margin-right:10px; "><img src="../resources/image/dott.png" id="search_cust"></button>
			<input type="text" name="cust_no" id="cust_no" style="width:130px;margin-left:1px;">
		</td>
		</tr>
	</table>
	
	<h4 style="margin:5px 5px;">결제금액</h4>
	<div>
	<table id="gel_tbl">
		<tr>
			<td style="width:260px;">현금<input type="text" name="csh_stlm_amt" id="csh_stlm_amt" style="margin-left:37px; margin-right:20px;" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');"></td>
			<td>카드금액<input type="text" name="crd_stlm_amt" id="crd_stlm_amt" style="margin-left:13px; margin-right:20px;" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');"></td>
			<td>포인트사용액<input type="text" name="pnt_stlm_amt" id="pnt_stlm_amt" style="margin-left:13px; margin-right:20px;" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');"></td>
		</tr>
		<tr>
			<td style="width:260px;">유효일자<input type="text" name="vld_ym" id="vld_ym" style="margin-left: 5px;" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" onKeyup="inputValidThru(this);" placeholder="MM/YYYY" maxlength="7" disabled="disabled"></td>
			<td>카드회사<select style="margin-left:13px; height:25px; width:171px;" name="crd_co_cd" id="crd_co_cd" disabled="disabled">
					<option value=""></option>
					<option value="10">BC</option>
					<option value="20">현대</option>
					<option value="30">삼성</option>
					<option value="40">신한</option>
			</select></td>
			<td>포인트가능액<input type="text" name="avb_pnt" id="avb_pnt" style="margin-left:13px; margin-right:20px;" disabled="disabled"></td>
		</tr>
		<tr>
			<td colspan="3">카드번호<input type="text" name="crd_no1" id="crd_no1" style="width:50px;margin-left: 5px;" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" disabled="disabled">
			<input type="text" name="crd_no2" id="crd_no2" style="width:50px;margin-left:7px;" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" disabled="disabled">
			<input type="text" name="crd_no3" id="crd_no3" style="width:50px;margin-left:7px;" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" disabled="disabled">
			<input type="text" name="crd_no4" id="crd_no4" style="width:50px;margin-left:7px;" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" disabled="disabled"></td>
		</tr>
	</table>
	</div>
	</form>
	<div>
		<table id="pmBtn">
			<tr><td><button type="button" id="plus">+</button><td><button type="button" id="minus">-</button></td></tr>
		</table>
	</div>
	
	
	<div id="su_div2" style="overflow:auto; /* width:820px; */ height:300px;" >
	<form id="su_form2">
	<table  id="su_tbl2" cellspacing="0">
	<thead id="su_head2" style="width:90%">
		<tr id="su_tr2">
			<th>선택</th>
			<th>번호</th>
			<th>상품코드</th>
			<th>상품명</th>
			<th>매장재고</th>
			<th>판매수량</th>
			<th>소비자가</th>
			<th>판매금액</th>
		</tr>
		</thead>
		<tbody id="su_body2">
		<tr>
			<td><input type="checkbox" name="chkbox" class="center border_left" style='border-left: 1px solid #00c8ff;'></td>
			<td id="num">1</td>
			<td><input type="text" style="width:120px;text-align:center;" id="prd_cd" name="prd_cd" onkeydown="findJego('')" ><button type="button" id="jegoBtn" onclick="toJego('')" style="margin-left:2px;width:18px; height:20px;">
			<img src="../resources/image/dott.png" id="dot_img" style="	height:13px;width:10px;" ></button></td>
			<td><input type="text" id="prd_nm" name="prd_nm" style="width:130px; cursor: default;" class="center" readonly="readonly" onfocus="this.blur();"></td>
			<input type="hidden" id="ivcOri" />
			<td><input type="text" id="ivco_qty" name="ivco_qty" style="width:130px; cursor: default;" class="right" readonly="readonly" onfocus="this.blur();"></td>
			<td><input type="text" id="sal_qty" name="sal_qty" style="width:50px; text-align: right;" class="sal_qty" oninput="inputNum(this)" readonly="readonly"></td>
			<td><input type="text" id="csmr_upr" name="csmr_upr" style="width:130px; cursor: default;" class="right" readonly="readonly" onfocus="this.blur();"></td>
			<td><input type="text" id="sal_amt" name="sal_amt" style="width:130px; cursor: default; text-align: right;" class="sal_amt" readonly="readonly" onfocus="this.blur();"></td>
			<input type="hidden" id="vos_amt" name="vos_amt" class="vos_amt" />
			<input type="hidden" id="vat_amt" name="vat_amt" class="vat_amt" />
		</tr>
		</tbody>
	</table>
	</form>
	</div>
	
	<form id="tot_form">
	<table  id="su_tbl3" cellspacing="0">
		<tr id="su_body3">
			<td style="width: 435px;border-top:2px solid #00c8ff;border-right:2px solid #00c8ff;border-bottom:2px solid #00c8ff;border-left:2px solid #00c8ff;">합계</td>
			<td style="width: 173px;border-top:2px solid #00c8ff;border-right:2px solid #00c8ff;border-bottom:2px solid #00c8ff;" class="center" >판매수량</td>
			<td style="border-top:2px solid #00c8ff;border-right:2px solid #00c8ff;border-bottom:2px solid #00c8ff;"><input type="text" name="tot_sal_qty" id="tot_sal_qty" style="width:50px; cursor: default;" class="right" readonly="readonly" onfocus="this.blur();"></td>
			<td style="width: 173px;border-top:2px solid #00c8ff;border-right:2px solid #00c8ff;border-bottom:2px solid #00c8ff;" class="center">판매금액</td>
			<td style="border-top:2px solid #00c8ff;border-right:2px solid #00c8ff;border-bottom:2px solid #00c8ff;"><input type="text" name="tot_sal_amt" id="tot_sal_amt" style="width:130px; cursor: default;" class="right" readonly="readonly" onfocus="this.blur();"></td>
			<input type="hidden" id="tot_vos_amt" name="tot_vos_amt" />
			<input type="hidden" id="tot_vat_amt" name="tot_vat_amt" />
		</tr>
	</table>
	</form>
	
	<div id="btn_div" style="margin-left:455px; margin-top:50px;">
		<input style="width:80px; height:40px;" type="button" id="cancel" value="닫기" >
		<input style="width:80px; height:40px;" type="button" id="submit" value="저장" onclick="saveSal()">	
	</div>
	
	<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" />
	<input type="hidden" name="toPrdCd" id="toPrdCd"  />
	<input type="hidden" name="chkPrdCd" id="chkPrdCd"  />
	<input type="hidden" name="custNmHide" id="custNmHide"  />
	
	
	<form name="jegoPop">
		<input type="hidden" name="SEQ">
	</form>
</body>
</html>