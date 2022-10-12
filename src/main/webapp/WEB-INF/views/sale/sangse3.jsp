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
<title>판매실적조회</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
		
	$(document).ready(function() {
	
		
		//창 열리자마자 리스트 나오게
		 findSangse();
		
		
		//창닫기 버튼
		$("#closeBtn").click(function(){
			cancel();
		});
		
		
		//반품 버튼
		$("#banpumBtn").click(function(){
			console.log("반품버튼 눌렀냐?!?!?!?!");
			banPum();
		});
		
		
	}); //document ready end

	
	
	
	//창 닫기
	function cancel(){
		
		window.close();
	}

  	
	
	
	//판매 상세 조회 해오는 ajax
	function findSangse(){
		
		var prt_cd = $("#PRT_CD").val();
		var cust_no = $("#CUST_NO").val();
		var sal_dt = $("#SAL_DT").val();
		var sal_no = $("#SAL_NO").val();
		
    	
    	$.ajax({
			url:"<%= request.getContextPath()%>/search/panSangse",
			data: {"prt_cd":prt_cd
				, "cust_no":cust_no
				, "sal_dt":sal_dt
				, "sal_no":sal_no
			}, 
			dataType:"JSON", 														
			type:"POST",															
			success:function(json){ 
				//alert("성공");
				let info = "";														
				let html = "";	
			 	
				//console.log(json);												
				if(json.length > 0) { 
					
					var salQty = 0;
					var salVosAmt = 0;
					var salVatAmt = 0;
					var salAmt = 0;
					
					$.each(json, function(index, item){		
						
						index += 1;
						
						salQty += parseInt(item.SAL_QTY);
						salVosAmt += parseInt(item.SAL_VOS_AMT);
						salVatAmt += parseInt(item.SAL_VAT_AMT);
						salAmt += parseInt(item.SAL_AMT);
						
						html += "<tr class='row'>"; 
						html += "<td class='right border_left'>"+index+"</td>";
						html += "<td class='center ' >"+item.PRD_CD+"</td>";
						html += "<input type='hidden' name='prd_cd"+index+"' class='prd_cd' value='"+item.PRD_CD+"' />";
						html += "<td class='center'>"+item.PRD_NM+"</td>";
						html += "<input type='hidden' name='prd_nm"+index+"' class='prd_nm' value='"+item.PRD_NM+"' />";
						html += "<td class='right' >"+item.SAL_QTY+"</td>";
						html += "<input type='hidden' name='sal_qty"+index+"' class='sal_qty' value='"+item.SAL_QTY+"' />";
						html += "<td class='right' >"+addComma(item.SAL_VOS_AMT)+"</td>";
						html += "<input type='hidden' name='vos_amt"+index+"' class='vos_amt' value='"+item.SAL_VOS_AMT+"' />";
						html += "<td class='right' >"+addComma(item.SAL_VAT_AMT)+"</td>";
						html += "<input type='hidden' name='vat_amt"+index+"' class='vat_amt' value='"+item.SAL_VAT_AMT+"' />";
						html += "<td class='right' >"+addComma(item.SAL_AMT)+"</td>";
						html += "<input type='hidden' name='sal_amt"+index+"' class='sal_amt' value='"+item.SAL_AMT+"' />";
						html += "<input type='hidden' name='csmr_upr"+index+"' class='csmr_upr' value='"+item.PRD_CSMR_UPR+"' />";
						html += "</tr>";
					
					});
					html += "<tr >";
					html += "<td colspan='3' class='right border_left'>합계</td>";
					html += "<td class='right' >"+salQty+"</td>";
					html += "<input type='hidden' id='tot_sal_qty' value='"+salQty+"' />";
					html += "<td class='right' >"+addComma(salVosAmt)+"</td>";
					html += "<input type='hidden' id='tot_vos_amt' value='"+salVosAmt+"' />";
					html += "<td class='right' >"+addComma(salVatAmt)+"</td>";
					html += "<input type='hidden' id='tot_vat_amt' value='"+salVatAmt+"' />";
					html += "<td class='right' >"+addComma(salAmt)+"</td>";
					html += "<input type='hidden' id='tot_sal_amt' value='"+salAmt+"' />";
					html += "</tr>";
				}
				else {
					html += "<tr>";
					html += "<td colspan='7' class='center' >조회될 데이터가 존재하지 않습니다.</td>";
					html += "</tr>";
				}
				
				$("tbody#sangseBody").html(html); 						
				
			},
			error: function(){
				alert("실패");
			}
		}); // end of $.ajax
    	
    } // end of  findSangse()
		
		
    
	function banPum(){
    	
    	// 1. 각 Query문에 사용할 Map/List 생성
    	// 2. 생성한 Map/List를 하나의 Map에 담기
    	// 3. ajax를 통하여 저장처리
    	// 4. 반품완료 alert 보여주고 window close
		
    	// 반품처리 대상 Table
    	// CS_SAL01_DT/CS_SAL01_MT/SD_IVCO01_MT/CS_CUST_PNT_M/CS_CUST_PNT_D
    	
    	// 1. 각 Query문에 사용할 Map/List 생성
    	// salMt 반품 Insert Data
    	var rtnMt = objToJson($('#rtnMt').serializeArray());
    	console.log('rtnMt : ' + JSON.stringify(rtnMt));
    	
    	// salDt 반품 Insert Data
    	var maeFrm3 = newSalDtList($('#mae_form3').serializeArray());
    	console.log('maeFrm3 : ' + JSON.stringify(maeFrm3));
    	
    	// pntD/pntM Insert Data
    	// crd_stlm_amt/csh_stlm_amt/pnt_stlm_amt DB NullAble No 때문에 Default 0 처리
    	//콤마를 제거한 값이 '' 라면 삼항연산자로 0 값이 있다면 숫자 변환하여 값을 넣는다
	    var crd_stlm_amt = removeComma($('#crd_stlm_amt').val()) == '' ? 0 : parseInt(removeComma($('#crd_stlm_amt').val()));
	    var csh_stlm_amt = removeComma($('#csh_stlm_amt').val()) == '' ? 0 : parseInt(removeComma($('#csh_stlm_amt').val()));
    	var pnt = (crd_stlm_amt + csh_stlm_amt) * 0.1; //포인트 쿼리에 넣을 현금사용액과 + 카드사용액의 10%
    	
    	var pntList = new Array();
    	//판매시 포인트 비 이용 , 구매 적립 취소용 포인트
    	var pntMap = {
    			"cust_no" : $('#CUST_NO').val()
    			,"pnt_ds_cd" : "100"
    			,"pnt_ds_dt_cd" : "104"
    			,"pnt" : pnt
    	};
    	pntList.push(pntMap);
    	
    	var pnt_stlm_amt = removeComma($('#pnt_stlm_amt').val()) == '' ? 0 : parseInt(removeComma($('#pnt_stlm_amt').val()));
    	//판매시 포인트 이용 , 구매 사용 취소 포인트
    	if(pnt_stlm_amt > 0) {
    		var pntMap = {
        			"cust_no" : $('#CUST_NO').val()
        			,"pnt_ds_cd" : "200"
        			,"pnt_ds_dt_cd" : "202"
        			,"pnt" : pnt_stlm_amt
        	};
    		pntList.push(pntMap);
    	}
    	console.log('pntList : ' + JSON.stringify(pntList));
    	
    	// RTN ajax
    	$.ajax({
			url:"<%= request.getContextPath()%>/search/banPum",
			data: {"rtnMt": JSON.stringify(rtnMt)
				,"rtnDtList" : JSON.stringify(maeFrm3)
				,"pntList" : JSON.stringify(pntList)
				} ,
			type: 'post',
			dataType: "JSON",
			async: false,
			success: function(json){
				console.log(json);
				//alert("성공");
				if(json.rst == '1'){
					alert('반품이 정상적으로 완료 되었습니다');
					window.close();
				} else {
					alert(json.rst);
				}
			},
			error: function( error){
				
				alert("전송 실패");
			}
		}); 
    	
    } // end of  banPum()
    
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
    
    //data는 Array(List)
	//CS_SAL01_DT Insert Data 생성 (return array)
	function newSalDtList(data) {
		//변경 된 data list 담을 변수 생성
		var list = new Array();
		var prt_cd = $('#prt_cd').val();
		
		var len = data.length;
		var i = $('#mae_tbl3 >tbody tr.row').length;
		console.log('i : ' + i);
		// tr 수 = 전체 row 수
		// 전체 name 수 / 전체 row 수 = 한 row name 수  
		var n = data.length / i;
		var cnt = Math.floor(len / n) + (Math.floor(len % n) > 0 ? 1 : 0)
		console.log(len + ' : ' + n + ' : ' + cnt);
		
		for(var i = 0; i < cnt; i++) {
			//CS_SAL01_DT Insert Data
			var row = objToJson(data.splice(0, n));
			row.prt_cd = prt_cd
			list.push(row);
		}
		
		return list;
	}
    
	// 문자+숫자에서 문자만 추출하여 return
	function strNumToStr(str) {
		const regex = /[(0-9)]/gi;
		const result = str.replace(regex, "");
		
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




</script>
</head>
<body>
	<h3 style="margin:1px;">판매상세조회</h3>
		
	<table id="maeca_tbl">
	<tr id="maecu"><td>매장 : ${item.PRT_CD }&nbsp;${item.PRT_NM }&nbsp;고객번호 : ${item.CUST_NO }&nbsp;${item.CUST_NM }</td></tr>
	<tr id="panca"><td>판매수량 : ${item.TOT_SAL_QTY } 판매금액 : ${item.TOT_SAL_AMT } 현금 : ${item.CSH_STLM_AMT } 카드 : ${item.CRD_STLM_AMT } 포인트:${item.PNT_STLM_AMT }</td></tr>
	</table>
	
	
	<div id="mae_div3" style="overflow:auto;width:980px;  height:450px;">
	<form id="mae_form3">
	<table id="mae_tbl3" cellspacing="0">
		<thead id="maeHead3" >
		<tr id="mae_tr3" >
			<th class="center">번호</th>
			<th class="center">상품코드</th>
			<th class="center">상품명</th>
			<th class="center">판매수량</th>
			<th class="center">공급가</th>
			<th class="center">부가세</th>
			<th class="center">판매금액</th>
		</tr>
		</thead>
		
		<tbody id="sangseBody">
		
		</tbody>
	
	</table>
	</form>
	</div>
	
	
	<div id="banBtn_div" style="margin-right:415px; margin-top:60px;">
		<button type="button" id="banpumBtn" <c:if test="${item.RTN_USE_YN eq 'N'}">disabled="disabled"</c:if>>반품</button>
		<button type="button" id="closeBtn" >닫기</button>
	</div>
	
	<form id="rtnMt">
		<input type="hidden" name="prt_cd" id="prt_cd" value="${item.PRT_CD}" />
		<input type="hidden" name="sal_tp_cd" value="RTN" />
		
		<input type="hidden" name="tot_sal_qty" value="${item.TOT_SAL_QTY}" />
		<input type="hidden" name="tot_sal_amt" value="${item.TOT_SAL_AMT}" />
		<input type="hidden" name="tot_vos_amt" value="${item.TOT_VOS_AMT}" />
		<input type="hidden" name="tot_vat_amt" value="${item.TOT_VAT_AMT}" />
		
		<input type="hidden" name="csh_stlm_amt" id="csh_stlm_amt" value="${item.CSH_STLM_AMT}" />
		<input type="hidden" name="crd_stlm_amt" id="crd_stlm_amt" value="${item.CRD_STLM_AMT}" />
		<input type="hidden" name="pnt_stlm_amt" id="pnt_stlm_amt" value="${item.PNT_STLM_AMT}" />
		
		<input type="hidden" name="cust_no" id="CUST_NO" value="${item.CUST_NO}" />
		<input type="hidden" name="crd_no" value="${item.CRD_NO}" />
		<input type="hidden" name="vld_ym" value="${item.VLD_YM}" />
		<input type="hidden" name="crd_co_cd" value="${item.CRD_CO_CD}" />
		
		<input type="hidden" name="org_shop_cd" id="PRT_CD" value="${item.PRT_CD}" />
		<input type="hidden" name="org_sal_dt" id="SAL_DT" value="${item.SAL_DT}" />
		<input type="hidden" name="org_sal_no" id="SAL_NO" value="${item.SAL_NO}" />
	</form>
		
</body>
</html>