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
<title>매장재고조회</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

		var prt_nm = "";
		var se_prt_cd = "";
		var se_prt_nm = "";
		var se_prt_dt_cd = "";

	$(document).ready(function() {
		
	  	var prt_cd = $("#prt_cd").val();
		var prt_cd_nm = $("#prt_cd_nm").val();
		var se_user_nm = $("#se_user_nm").val();
		var se_prt_cd = $("#se_prt_cd").val();								// session 저장된 로그인유저의 매장코드
		var se_prt_cd_nm = $("#se_prt_nm").val();							// session 저장된 로그인유저의 매장명
		var se_user_dt_cd = $("#se_user_dt_cd").val(); 
		var seq = $("#seq").val();											//행 별로 값을 넣고 가져오기 위해
		
		var prdNm = opener.$("#prd_cd"+seq).val();							//부모창에 상품 코드
		$("#prd_nm").val(prdNm);
		
		
		//화면에 세션 값 넣기
		$("#prt_cd").val(se_prt_cd);
		$("#prt_cd_nm").val(se_prt_cd_nm);
		
		$("#prd_nm").focus();
		
		//창 실행 되자마자 ajax 실행 해서 상품 가져온다
		findJego();
		
		//닫기 버튼
		$("#cancel").click(function(){
			
			ChangClose();
		}); 
	
		// 재고 찾는 버튼
		$("#search").click(function(){
			
			findJego();
		});
		
		//적용 버튼
		$("#submit").click(function(){
			var qty = 0;
			var price = 0; 
			
			// 체크 하지 않고 적용버튼 누르면 알럿
			let is_check = $("input:checkbox[name='checkbox']").is(":checked");
			if(!is_check){
				alert("항목을 선택 하시지 않았습니다.");
				return false;
			}
			
			//id에 담긴 값 넣기
			var prdCd = $("input[name='checkbox']:checked").attr('id');
			//노드 찾아서 값 넣기
			var prdNm = $("input[name='checkbox']:checked").parent().parent().children().eq(2).text();
			var ivcoQty = $("input[name='checkbox']:checked").parent().parent().children().eq(3).text();
			var csmrUpr = $("input[name='checkbox']:checked").parent().parent().children().eq(4).text();
			
			var obj = {
			           "seq" : seq
			          ,"prdCd" : prdCd
			};
			
			//console.log('submit click jego4 checkDupPrd Start');
			//적용 버튼 눌렀을때 부모창에 동일한 상품이 있는지 체크
			if(opener.checkDupPrd(obj)) {
				alert('입력하신 상품들 중에 동일한 상품이 있습니다');
				return;
			}
			
			//창이 닫히면서 부모창에 들어갈 아이디에 값 넣기
	    	$("#prd_cd"+seq, opener.document).val(prdCd); 								
		    $("#prd_nm"+seq, opener.document).val(prdNm);
			$("#ivco_qty"+seq, opener.document).val(ivcoQty);
			$("#ivcOri"+seq, opener.document).val(ivcoQty);
			$("#sal_qty"+seq, opener.document).val(qty); 
		    $("#csmr_upr"+seq, opener.document).val(csmrUpr);
		    $("#sal_amt"+seq, opener.document).val(price); 
		    $("#chkPrdCd", opener.document).val(prdCd);
		    $("#prd_cd"+seq, opener.document).attr("maxlength","9");
		    $("#prd_cd"+seq, opener.document).attr("oninput","inputCheck(this)");
		    
		    //값이 있을때만 sal_qty input 창이 열리게 하기 위해
			var chkNm = $("#prd_nm"+seq).val(prdNm);
			if(chkNm != ''){
				
				$("#sal_qty"+seq, opener.document).attr("readonly", false);
			}
	    	
			opener.gyeSan();
	    	ChangClose();
			
			
		});
		
		//엔터시 바로 매장 찾는 함수 실행
 		$("#prt_cd_nm").keydown(function(event){					
			if(event.keyCode == 13) { 									
				check_prt_data();			
			}
		});
		
		
		//엔터시 바로 물건 찾기
 		$("#prd_nm").keydown(function(event){					
			if(event.keyCode == 13) { 									
				findJego();			
			}
		});
		
		
 		//매장 명 지웠을때 매장 코드도 같이 없앤다
 		$("#prt_cd_nm").keyup(function(event){                  
 	         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
 	            if( $("#prt_cd_nm").val() == "" ) {            
 	               $("#prt_cd").val("");                  
 	            } 

 	         }
 	      }); // end key up
		
 	      
 	    //매장 찾는 작은 돋보기  
		$("#btn_prt").click(function(){
			
			popUp_prt();
		});
		
 	      
		//부모 창 닫을시 팝업창 닫기
 	    $(opener).one('beforeunload', function() {                    
			window.close();                                      
		});
		
	}); //document ready end

	
	
	//닫기 
	function ChangClose(){
		
		window.close();
	}
	
	
	
	//재고 찾는 ajax
	function findJego(){
		
		//매장 코드와 상품 이름 입력된 값 가져오기
		var prt_cd = $("#prt_cd").val();
		var prd_nm = $("#prd_nm").val();
		
    	
    	$.ajax({
			url:"<%= request.getContextPath()%>/search/jegoJo",
			data: {"prt_cd":prt_cd
				 , "prd_nm":prd_nm
				 , "prd_tp_20_dif":"Y"
			}, 
			dataType:"JSON", 														
			type:"POST",															
			success:function(json){ 
				//alert("성공");
				let info = "";														
				let html = "";	
			 	
				console.log(json);												
				if(json.length > 0) { 
					
					$.each(json, function(index, item){	
						
						//상품 상태에 따라 다르게 보여줘야 하기 때문에 disabled 이나 노란색 조정 
						var haeji = "";
						var haedis = "";
						
						if(item.PRD_SS_CD == 'C'){
							
							haedis = "disabled";
							haeji = "style='color: #ffda24;'";
							
						}else if(item.IVCO_QTY == 0){
							
							haedis = "disabled";
						
						}else if(item.PRD_CSMR_UPR == 0){
							
							haedis = "disabled";
						}
						
						
						html += "<tr >";
						html += "<td class='center border_left' ondblclick='dbl_prd()'><input type='checkbox' name='checkbox' id='"+item.PRD_CD+"' onclick='checkOne(this)' "+haedis+"/></td>";
						html += "<td class='center ' ondblclick='dbl_prd()' id='PRD_CD' "+haeji+">"+item.PRD_CD+"</td>";
						html += "<td class='center' ondblclick='dbl_prd()' id='PRD_NM' "+haeji+">"+item.PRD_NM+"</td>";
						html += "<td class='right' ondblclick='dbl_prd()' id='IVCO_QTY' "+haeji+">"+addComma(item.IVCO_QTY)+"</td>";
						html += "<td class='right' ondblclick='dbl_prd()' id='PRD_CSMR_UPR' "+haeji+">"+addComma(item.PRD_CSMR_UPR)+"</td>";
						html += "<input type='hidden' id='PRD_SS_CD' value='" + item.PRD_SS_CD + "' />";
						html += "</tr>";
					
					});

				}
				else {
					html += "<tr>";
					html += "<td colspan='5' class='center' >조회할 데이터가 존재하지 않습니다.</td>";
					html += "</tr>";
				}
				
				$("tbody#jegoBody").html(html); 						
				
			},
			error: function(){
				alert("실패");
			}
		}); // end of $.ajax
    	
    } // end of  findjego()
	
	

	
	
	// 엔터 or 클릭시 매장 데이타 검색
	 function check_prt_data(){
		
		var check_prt = $("#prt_cd").val();
		
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
	
	
	//다중 선택 불가
	function checkOne(a){
		
		var check = document.getElementsByName("checkbox");
	  
		for(var i=0; i<check.length; i++){
			
			if(check[i] != a){
				
				check[i].checked= false;
			}
		}
		
	} //end checkOne
	
	
	
	//더블 클릭 액션
	function dbl_prd() {
		const $target = $(event.target);											
		var tr = $target.parent();													
		var td = tr.children();	
		var qty = 0;
		var price = 0; 
		var seq = $("#seq").val();
			
		var prdCd = td.eq(1).text();												
	    var prdNm = td.eq(2).text();	
		var ivcoQty = td.eq(3).text();
		var csmrUpr = td.eq(4).text();
		var prdSsCd = td.eq(5).val();
		
		console.log('prdSsCd : ' + prdSsCd);
		
		var obj = {
		           "seq" : seq
		          ,"prdCd" : prdCd
		};
		
		if(ivcoQty != '0' && prdSsCd != 'C' && csmrUpr != '0') {
			console.log('dbl_prd click jego4 checkDupPrd Start');
			if(opener.checkDupPrd(obj)) {
				alert('입력하신 상품들 중에 동일한 상품이 있습니다');
				return;
			}
			
	
			
			$("#prd_cd"+seq, opener.document).val(prdCd); 								
		    $("#prd_nm"+seq, opener.document).val(prdNm);
			$("#ivco_qty"+seq, opener.document).val(ivcoQty);
			$("#ivcOri"+seq, opener.document).val(ivcoQty);
			$("#sal_qty"+seq, opener.document).val(qty); 
		    $("#csmr_upr"+seq, opener.document).val(csmrUpr);
		    $("#sal_amt"+seq, opener.document).val(price); 
		    $("#chkPrdCd", opener.document).val(prdCd);
		    $("#prd_cd"+seq, opener.document).attr("maxlength","9");
		    $("#prd_cd"+seq, opener.document).attr("oninput","inputCheck(this)");
		    
		    //값이 있을때만 sal_qty input 창이 열리게 하기 위해		    
			var chkNm = $("#prd_nm"+seq).val(prdNm);
			if(chkNm != ''){
				
				$("#sal_qty"+seq, opener.document).attr("readonly", false);
			}
		    

		    opener.gyeSan();
			window.close();
		}

	}
	
	
	//팝팝
	function popUp_prt(){
		
		var url = "http://localhost:8080/gwaje/search/searchshop";
		var title = "popUp_prt";
		var status = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=810, height=600, top=100,left=250";
		window.open(url, title, status);
		
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

	<h3 style="margin:2px;">매장재고조회</h3>

		<table id="jego_tbl">
		<tr>
			<td style="padding-bottom:10px;">매장
			<input type="text" name="prt_cd" id="prt_cd"  style="margin-left:25px;"disabled>
			<button type="button" id="btn_prt" disabled><img src="../resources/image/dott.png" id="search_shop" ></button>
			<input type="text" name="prt_cd_nm" id="prt_cd_nm" style="margin-left:3px;" disabled></td>
			<td rowspan="2" style="float: right;padding-right: 8px;"><button type="button" id="search"><img src="../resources/image/dott.png" id="sub_btn4"></button></td>
		</tr>
		<tr>
			<td style="padding-bottom:10px;">상품명<input type="text" name="prd_nm" id="prd_nm" style="margin-left:15px;"></td>
			
		</tr>
	</table>
	
	
	<div id="jego_div" style="overflow:auto; /* width:900px; */ height:350px;" >
	<form>
	<table  id="je_tbl" cellspacing="0">
	<thead id="je_head" style="width:90%">
		<tr id="je_tr">
			<th>선택</th>
			<th>상품코드</th>
			<th>상품명</th>
			<th>재고수량</th>
			<th>소비자가</th>
		</tr>
		</thead>
		<tbody id="jegoBody"/>
	</table>
	</form>
	</div>
	
	<div id="btn_div" style="margin-left:353px; margin-top:120px;">
		<input style="width:65px; height:35px;" type="button" id="cancel" value="닫기" >
		<input style="width:65px; height:35px;" type="button" id="submit" value="적용" >	
	</div>



		<input type="hidden" name="se_prt_cd" id="se_prt_cd" value="${sessionScope.member.prt_cd}" />
		<input type="hidden" name="se_user_dt_cd" id="se_user_dt_cd" value="${sessionScope.member.user_dt_cd}" />
		<input type="hidden" name="se_prt_nm" id="se_prt_nm" value="${sessionScope.member.prt_nm}" />
		<input type="hidden" name="seq" id="seq" value="${map.SEQ}" />

</body>
<script>
	//opener 로 부모창에 접근하여 popup이라는 자식창 속성을 주입
	// (부모창에 popup 변수 선언 안해도 사용 가능)
	// 선언해준 위치에 따라 주입되는 영역이 달라진다.
	// 부모창에서 자식창의 <body>영역에 접근하고자 한다면
	// <head> 스크립트를 영역에 선언하지 말고  <body> 영역이 끝나고 난 뒤 <script>를 선언하여 주입
	opener.jego4 = this;
</script>
</html>