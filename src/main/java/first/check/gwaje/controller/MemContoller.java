package first.check.gwaje.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.json.JSONException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.JsonArray;

import first.check.gwaje.service.MemService;
import first.check.gwaje.vo.FirstTableVO;
import first.check.gwaje.vo.MemberVO;
import first.check.gwaje.vo.ProductVO;

@Controller
public class MemContoller {

	@Autowired
	MemService memService;
	
	//첫 화면
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView start(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("main");

		return mav;
	}
	
	//첫 화면
	@RequestMapping(value = "/member/toMain", method = RequestMethod.GET)
	public ModelAndView mainPage(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("/member/main");

		return mav;
	}
	
	
	//로그인시 
	@RequestMapping(value = "/member/login", method = RequestMethod.POST)
	public ModelAndView login(@ModelAttribute("member") MemberVO member, Model model, RedirectAttributes rAttr,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
			HttpSession session = request.getSession(true);
			
			ModelAndView mav = new ModelAndView();
		
			MemberVO memberVO = memService.login(member);

			
		if (memberVO != null) {
			
			session.setAttribute("member", memberVO);
			model.addAttribute("member", memberVO);
			mav.setViewName("/member/main");
		} else {
            model.addAttribute("msg","아이디나 패스워드가 틀렸습니다.");
            model.addAttribute("url","/");
            mav.setViewName("redirect");
		}
		return mav;
	}
	
	
	//로그아웃
	@RequestMapping(value = "/member/logout", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession();
		session.invalidate();

		mav.setViewName("redirect:/");
		return mav;
	}

	
	// main 에서 2번 고객관리 페이지 보내는 mav
	@RequestMapping(value = "/search/toCustmod", method = RequestMethod.GET)
	public ModelAndView toCust2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		Map custVO = new HashMap();
		ModelAndView mav = new ModelAndView();
		
		// DEFAULT DATA SETTING
		custVO.put("SEX_CD", "F");
		custVO.put("SCAL_YN", "0");
		custVO.put("PSMT_GRC_CD", "H");
		custVO.put("CUST_SS_CD", "10");
		custVO.put("EMAIL_RCV_YN", "N");
		custVO.put("SMS_RCV_YN", "N");
		custVO.put("DM_RCV_YN", "N");
		
		mav.addObject("custVO", custVO);
		mav.setViewName("/search/toCustModJsp");

		return mav;
	}
	
	
	
	
	
	//2번 고객관리 페이지 보내는 mav
	@RequestMapping(value = "/search/custmod", method = RequestMethod.GET)
	public ModelAndView cust2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String cust_mod = request.getParameter("cust_mod");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		System.out.println("cust_mod : " + cust_mod);
		map.put("cust_no", cust_mod);
		
		//고객번호로 해당정보 가져오는 service 구현
		//to-do
		Map custVO = memService.getCustInfo(map);
		
		//System.out.println("custVO.SEX_CD : " + custVO.get("SEX_CD"));

		ModelAndView mav = new ModelAndView();
		mav.addObject("custVO", custVO);
		mav.setViewName("/search/toCustModJsp");

		return mav;
	}
	
	
	
	//2번 고객관리 
	@ResponseBody
	@RequestMapping(value = "/search/custmod222", method = RequestMethod.POST)
	public String cust222(ModelAndView mav, @RequestParam Map<String, Object> map) throws Exception {
		
		
		System.out.println("map : " + map);
		Map custMap = memService.getCustInfo(map);
		System.out.println("custMap : " + custMap);
		


				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("CUST_NO", custMap.get("CUST_NO"));
					jsonObj.put("CUST_NM", custMap.get("CUST_NM"));
					jsonObj.put("SEX_CD", custMap.get("SEX_CD"));
					jsonObj.put("SCAL_YN", custMap.get("SCAL_YN"));
					jsonObj.put("BRDY_DT", custMap.get("BRDY_DT"));
					jsonObj.put("MRRG_DT", custMap.get("MRRG_DT"));
					jsonObj.put("POC_CD", custMap.get("POC_CD"));
					jsonObj.put("MBL_NO1", custMap.get("MBL_NO1"));
					jsonObj.put("MBL_NO2", custMap.get("MBL_NO2"));
					jsonObj.put("MBL_NO3", custMap.get("MBL_NO3"));
					jsonObj.put("PSMT_GRC_CD", custMap.get("PSMT_GRC_CD"));
					jsonObj.put("EMAIL", custMap.get("EMAIL"));
					jsonObj.put("EMAIL_DTL", custMap.get("EMAIL_DTL"));
					jsonObj.put("ZIP_CD", custMap.get("ZIP_CD"));
					jsonObj.put("ADDR", custMap.get("ADDR"));
					jsonObj.put("ADDR_DTL", custMap.get("ADDR_DTL"));
					jsonObj.put("CUST_SS_CD", custMap.get("CUST_SS_CD"));
					jsonObj.put("CNCL_CNTS", custMap.get("CNCL_CNTS"));
					jsonObj.put("JN_PRT_CD", custMap.get("JN_PRT_CD"));
					jsonObj.put("JN_PRT_NM", custMap.get("JN_PRT_NM"));
					jsonObj.put("EMAIL_RCV_YN", custMap.get("EMAIL_RCV_YN"));
					jsonObj.put("SMS_RCV_YN", custMap.get("SMS_RCV_YN"));
					jsonObj.put("DM_RCV_YN", custMap.get("DM_RCV_YN"));
					jsonObj.put("FST_JS_DT", custMap.get("FST_JS_DT"));
					jsonObj.put("JS_DT", custMap.get("JS_DT"));
					jsonObj.put("STP_DT", custMap.get("STP_DT"));
					jsonObj.put("CNCL_DT", custMap.get("CNCL_DT"));
					jsonObj.put("FST_REG_DT", custMap.get("FST_REG_DT"));
					jsonObj.put("FST_USER_ID", custMap.get("FST_USER_ID"));
					jsonObj.put("LST_UPD_DT", custMap.get("LST_UPD_DT"));
					jsonObj.put("LST_UPD_ID", custMap.get("LST_UPD_ID"));
					jsonObj.put("TOT_SAL_AMT", custMap.get("TOT_SAL_AMT"));
					jsonObj.put("NMM_SAL_AMT", custMap.get("NMM_SAL_AMT"));
					jsonObj.put("LST_SAL_DT", custMap.get("LST_SAL_DT"));
					jsonObj.put("TOT_PNT", custMap.get("TOT_PNT"));
					jsonObj.put("RSVG_PNT", custMap.get("RSVG_PNT"));
					jsonObj.put("US_PNT", custMap.get("US_PNT"));
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}


		System.out.println("jsonObj.toString() : " + jsonObj.toString());
		return jsonObj.toString();
	}
	
	

	
	
	//3번 신규등록 보내는 mav
	@RequestMapping(value = "/search/newcust", method = RequestMethod.GET)
	public ModelAndView cust3(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("customer/newCust3");

		return mav;
	}
	
	
	//4번 고객조회 팝업 mav
	@RequestMapping(value = "/search/customer", method = RequestMethod.GET)
	public ModelAndView cust4(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("customer/searchCust4");

		return mav;
	}
	
	
	//5번 고객이력 팝업 mav
	@RequestMapping(value = "/search/custdetail", method = RequestMethod.POST)
	public ModelAndView cust5(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		//System.out.println("상세이력"+ cust_his);
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("CUST_NO", request.getParameter("CUST_NO"));
		map.put("CUST_NM", request.getParameter("CUST_NM"));
		
		mav.addObject("item", map);
		mav.setViewName("customer/custDetail5");

		return mav;
	}
	
	
	//6번 팝업 보내는 mav 
	@RequestMapping(value = "/search/searchshop", method = RequestMethod.GET)
	public ModelAndView srcCust6(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("shop/searchShop6");

		return mav;
	}
	
	
	
	
	//판매 메인 1번 보내는 mav 
	@RequestMapping(value = "/sale/panMain", method = RequestMethod.GET)
	public ModelAndView panMain1(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();

		ModelAndView mav = new ModelAndView();
		
		
		MemberVO memberVO = (MemberVO) session.getAttribute("member");
		
		//System.out.println("memberVO.prt_cd : " + memberVO.getPrt_cd());
		//System.out.println("memberVO.user_id : " + memberVO.getUser_id());
		
		String se_user_dt_cd = memberVO.getUser_dt_cd();
		String prt_cd  = memberVO.getPrt_cd();
		String prt_cd_nm = memberVO.getPrt_nm();

		
		session.setAttribute("prt_cd_nm", prt_cd_nm);
		session.setAttribute("prt_cd", prt_cd);
		session.setAttribute("se_user_dt_cd", se_user_dt_cd);
		
		
		mav.setViewName("/sale/panMain1");

		return mav;
	}
	
	
	
	
	
	// 판매 1번  페이지 조회 
	@ResponseBody
	@RequestMapping(value = "/search/panmeFirst", produces = "text/plain;charset=UTF-8")
	public String panMeMain(ModelAndView mav, @RequestParam Map<String, Object> map) {
		 System.out.println("c체크"+map);
		List<Map<String, String>> mainList = memService.panMainTable(map);

		JSONArray jsonArr = new JSONArray();

		if (mainList != null && mainList.size() > 0) {

			for (Map<String, String> mainMap : mainList) {

				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("SAL_DT", mainMap.get("SAL_DT"));
					jsonObj.put("CUST_NO", mainMap.get("CUST_NO"));
					jsonObj.put("CUST_NM", mainMap.get("CUST_NM"));
					jsonObj.put("SAL_NO", mainMap.get("SAL_NO"));
					jsonObj.put("TOT_SAL_QTY", mainMap.get("TOT_SAL_QTY"));
					jsonObj.put("TOT_SAL_AMT", mainMap.get("TOT_SAL_AMT"));
					jsonObj.put("TOT_VOS_AMT", mainMap.get("TOT_VOS_AMT"));
					jsonObj.put("TOT_VAT_AMT", mainMap.get("TOT_VAT_AMT"));
					jsonObj.put("CSH_STLM_AMT", mainMap.get("CSH_STLM_AMT"));
					jsonObj.put("CRD_STLM_AMT", mainMap.get("CRD_STLM_AMT"));
					jsonObj.put("PNT_STLM_AMT", mainMap.get("PNT_STLM_AMT"));
					jsonObj.put("CRD_NO", mainMap.get("CRD_NO") == null ? "" : mainMap.get("CRD_NO"));
					jsonObj.put("VLD_YM", mainMap.get("VLD_YM") == null ? "" : mainMap.get("VLD_YM"));
					jsonObj.put("CRD_CO_CD", mainMap.get("CRD_CO_CD") == null ? "" : mainMap.get("CRD_CO_CD"));
					jsonObj.put("FST_USER_ID", mainMap.get("FST_USER_ID"));
					jsonObj.put("FST_USER_NM", mainMap.get("FST_USER_NM"));
					jsonObj.put("FST_REG_DT", mainMap.get("FST_REG_DT"));
					jsonObj.put("RTN_USE_YN", mainMap.get("RTN_USE_YN"));
					jsonObj.put("SAL_TP_CD", mainMap.get("SAL_TP_CD"));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				jsonArr.put(jsonObj);

			}
		}
		return jsonArr.toString();
	}
	
	
	
	
	
	//판매 수금 2번 팝업  mav 
	@RequestMapping(value = "/sale/sugumPopup", method = RequestMethod.GET)
	public ModelAndView sugumPop2(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("/sale/sugum2");

		return mav;
	}
	
	
	
	
	//판매 2pg 판매등록처리
	@ResponseBody
	@RequestMapping(value = "/search/newSal88", produces = "text/plain;charset=UTF-8")
	public String newSal88(ModelAndView mav, @RequestParam Map<String, Object> map, HttpServletRequest request) {
	
		HttpSession session = request.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("member");
		
		System.out.println("map : " + map);
		
		Map<String, Object> salMtMap = net.sf.json.JSONObject.fromObject(map.get("salMtMap"));
		salMtMap.put("user_id", memberVO.getUser_id());
		
		System.out.println("salMtMap : " + salMtMap);
		
		JSONObject jsonObj = new JSONObject();
		try {
			//판매등록 마스터처리
			String rst = memService.newSalMt(salMtMap);
			System.out.println("salMt rst : " + rst);
			if(rst.equals("1")) {
				List<Map<String, Object>> salDtList = net.sf.json.JSONArray.fromObject(map.get("salDtList"));
				System.out.println("salDtList.size() : " + salDtList.size());
				for (int i = 0; i < salDtList.size(); i++) {
					Map<String, Object> salDtMap = salDtList.get(i);
					
					salDtMap.put("sal_no", salMtMap.get("sal_no"));
					salDtMap.put("sal_tp_cd", salMtMap.get("sal_tp_cd"));
					salDtMap.put("user_id", memberVO.getUser_id());
					System.out.println("salDtMap : " + salDtMap);
					
					//판매등록 상세처리
					rst = memService.newSalDt(salDtMap);
					System.out.println("salDt rst : " + rst);
					if(rst.equals("1")) {
						//판매등록 재고처리
						rst = memService.updIvcoMt(salDtMap);
						System.out.println("ivcoMt rst : " + rst);
						if(!rst.equals("1")) {
							rst = (i+1) + "번째 판매등록 재고처리 중 실패";
							break;
						}
					} else {
						rst = (i+1) + "번째 판매등록 상세처리 중 실패";
						break;
					}
				}
				
				List<Map<String, Object>> pntList = net.sf.json.JSONArray.fromObject(map.get("pntList"));
				System.out.println("pntList.size() : " + pntList.size());
				for (int i = 0; i < pntList.size(); i++) {
					Map<String, Object> pntMap = pntList.get(i);
					
					pntMap.put("user_id", memberVO.getUser_id());
					System.out.println("pntMap : " + pntMap);
					
					//판매등록 포인트처리
					int pnt = Integer.parseInt(String.valueOf(pntMap.get("pnt")));
					if(rst.equals("1") && pnt > 0) {
						//포인트 디테일 테이블에 넣기
						rst = memService.newCustPntD(pntMap);
						System.out.println("pntDt rst : " + rst);
						if(rst.equals("1")) {
							System.out.println("pntMap : " + pntMap);
							//포인트 마스터 테이블에 더해주기
							rst = memService.newCustPntM(pntMap);
							System.out.println("pntMt rst : " + rst);
							if(!rst.equals("1")) {
								rst = "판매등록 포인트마스터처리 중 실패";
							}
						} else {
							rst = "판매등록 포인트상세처리 중 실패";
						}
					}
				}
				
			} else {
				rst = "판매등록 마스터처리 중 실패";
			}
			
			System.out.println("return rst : " + rst);
			jsonObj.put("rst", rst);

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		return jsonObj.toString();
		
	}
	

	
	
	
	
	//판매 상세 3번 팝업  mav 
	@RequestMapping(value = "/sale/sangsePopup", method = RequestMethod.POST)
	public ModelAndView sangsePop3(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("PRT_CD", request.getParameter("PRT_CD"));
		map.put("PRT_NM", request.getParameter("PRT_NM"));
		map.put("CUST_NO", request.getParameter("CUST_NO"));
		map.put("CUST_NM", request.getParameter("CUST_NM"));
		map.put("SAL_DT", request.getParameter("SAL_DT"));
		map.put("SAL_NO", request.getParameter("SAL_NO"));
		map.put("TOT_SAL_QTY", request.getParameter("TOT_SAL_QTY"));
		map.put("TOT_SAL_AMT", request.getParameter("TOT_SAL_AMT"));
		map.put("TOT_VOS_AMT", request.getParameter("TOT_VOS_AMT"));
		map.put("TOT_VAT_AMT", request.getParameter("TOT_VAT_AMT"));
		map.put("CSH_STLM_AMT", request.getParameter("CSH_STLM_AMT"));
		map.put("CRD_STLM_AMT", request.getParameter("CRD_STLM_AMT"));
		map.put("PNT_STLM_AMT", request.getParameter("PNT_STLM_AMT"));
		map.put("CRD_NO", request.getParameter("CRD_NO"));
		map.put("VLD_YM", request.getParameter("VLD_YM"));
		map.put("CRD_CO_CD", request.getParameter("CRD_CO_CD"));
		map.put("FST_USER_ID", request.getParameter("FST_USER_ID"));
		map.put("FST_REG_DT", request.getParameter("FST_REG_DT"));
		map.put("RTN_USE_YN", request.getParameter("RTN_USE_YN"));
		
		
		System.out.println(map);
		
		mav.addObject("item", map);
		mav.setViewName("/sale/sangse3");

		return mav;
	}
	
	
	
	
	//판매 3pg 상세 조회
	@ResponseBody
	@RequestMapping(value = "/search/panSangse", produces = "text/plain;charset=UTF-8")
	public String panSangJo(ModelAndView mav, @RequestParam Map<String, Object> map) {
		System.out.println("c체크"+map);
		List<Map<String, String>> sangList = memService.panSangTable(map);

		JSONArray jsonArr = new JSONArray();

		if (sangList != null && sangList.size() > 0) {

			for (Map<String, String> mainMap : sangList) {

				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("PRD_CD", mainMap.get("PRD_CD"));
					jsonObj.put("PRD_NM", mainMap.get("PRD_NM"));
					jsonObj.put("SAL_QTY", mainMap.get("SAL_QTY"));
					jsonObj.put("SAL_VOS_AMT", mainMap.get("SAL_VOS_AMT"));
					jsonObj.put("SAL_VAT_AMT", mainMap.get("SAL_VAT_AMT"));
					jsonObj.put("SAL_AMT", mainMap.get("SAL_AMT"));
					jsonObj.put("PRD_CSMR_UPR", mainMap.get("PRD_CSMR_UPR"));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				jsonArr.put(jsonObj);

			}
		}
		return jsonArr.toString();
	}
	
	
	
	
	//판매 3pg 팝업 반품
	@ResponseBody
	@RequestMapping(value = "/search/banPum", produces = "text/plain;charset=UTF-8")
	public String banPum(ModelAndView mav, @RequestParam Map<String, Object> map, HttpServletRequest request) {
	
		HttpSession session = request.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("member");
		
		System.out.println("map : " + map);
		
		Map<String, Object> rtnMt = net.sf.json.JSONObject.fromObject(map.get("rtnMt"));
		rtnMt.put("user_id", memberVO.getUser_id());
		
		System.out.println("rtnMt : " + rtnMt);
		
		JSONObject jsonObj = new JSONObject();
		try {
			//판매등록 마스터처리
			String rst = memService.newSalMt(rtnMt);
			System.out.println("rtnMt rst : " + rst);
			if(rst.equals("1")) {
				List<Map<String, Object>> rtnDtList = net.sf.json.JSONArray.fromObject(map.get("rtnDtList"));
				System.out.println("rtnDtList.size() : " + rtnDtList.size());
				for (int i = 0; i < rtnDtList.size(); i++) {
					Map<String, Object> rtnDt = rtnDtList.get(i);
					
					rtnDt.put("sal_no", rtnMt.get("sal_no"));
					rtnDt.put("sal_tp_cd", rtnMt.get("sal_tp_cd"));
					rtnDt.put("user_id", memberVO.getUser_id());
					System.out.println("rtnDt : " + rtnDt);
					
					//판매등록 상세처리
					rst = memService.newSalDt(rtnDt);
					System.out.println("rtnDt rst : " + rst);
					if(rst.equals("1")) {
						//판매등록 재고처리
						rst = memService.updIvcoMt(rtnDt);
						System.out.println("ivcoMt rst : " + rst);
						if(!rst.equals("1")) {
							rst = (i+1) + "번째 반품 재고처리 중 실패";
							break;
						}
					} else {
						rst = (i+1) + "번째 반품 상세처리 중 실패";
						break;
					}
				}
				
				List<Map<String, Object>> pntList = net.sf.json.JSONArray.fromObject(map.get("pntList"));
				System.out.println("pntList.size() : " + pntList.size());
				for (int i = 0; i < pntList.size(); i++) {
					Map<String, Object> pntMap = pntList.get(i);
					
					pntMap.put("user_id", memberVO.getUser_id());
					System.out.println("pntMap : " + pntMap);
					
					//판매등록 포인트처리
					int pnt = Integer.parseInt(String.valueOf(pntMap.get("pnt")));
					if(rst.equals("1") && pnt > 0) {
						//포인트 디테일 테이블에 넣기
						rst = memService.newCustPntD(pntMap);
						System.out.println("pntDt rst : " + rst);
						if(rst.equals("1")) {
							System.out.println("pntMap : " + pntMap);
							//포인트 마스터 테이블에 더해주기
							rst = memService.newCustPntM(pntMap);
							System.out.println("pntMt rst : " + rst);
							if(!rst.equals("1")) {
								rst = "반품 포인트마스터처리 중 실패";
							}
						} else {
							rst = "반품 포인트상세처리 중 실패";
						}
					}
				}
				
			} else {
				rst = "반품 마스터처리 중 실패";
			}
			
			System.out.println("return rst : " + rst);
			jsonObj.put("rst", rst);

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		return jsonObj.toString();
		
	}
	
	
	
	
	
	
	//판매 재고 4번 팝업  mav 
	@RequestMapping(value = "/sale/jegoPopup", method = RequestMethod.POST)
	public ModelAndView jegoPop4(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> map) throws Exception {

		System.out.println("map : " + map);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("map", map);
		mav.setViewName("/sale/jego4");

		return mav;
	}
	
	
	
	
	
	//판매 4pg 상품 재고 조회
	@ResponseBody
	@RequestMapping(value = "/search/jegoJo", produces = "text/plain;charset=UTF-8")
	public String jegoJo(ModelAndView mav, @RequestParam Map<String, Object> map) {
		System.out.println("c체크"+map);
		List<Map<String, String>> jegoList = memService.jegoTable(map);

		JSONArray jsonArr = new JSONArray();

		if (jegoList != null && jegoList.size() > 0) {

			for (Map<String, String> mainMap : jegoList) {

				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("PRT_CD", mainMap.get("PRT_CD"));
					jsonObj.put("PRD_CD", mainMap.get("PRD_CD"));
					jsonObj.put("PRD_NM", mainMap.get("PRD_NM"));
					jsonObj.put("IVCO_QTY", mainMap.get("IVCO_QTY"));
					jsonObj.put("PRD_TP_CD", mainMap.get("PRD_TP_CD"));
					jsonObj.put("PRD_SS_CD", mainMap.get("PRD_SS_CD"));
					jsonObj.put("PRD_CSMR_UPR", mainMap.get("PRD_CSMR_UPR"));
					jsonObj.put("SEQ", map.get("seq"));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				jsonArr.put(jsonObj);

			}
		}
		return jsonArr.toString();
	}


	
	
	
		//1번 페이지 조회 
		@ResponseBody
		@RequestMapping(value = "/search/shopcust", produces = "text/plain;charset=UTF-8")
		public String mainList(ModelAndView mav, @RequestParam Map<String, Object> map) {
			// System.out.println("map"+map);
			List<Map<String, String>> mainList = memService.firstList(map);
	
			JSONArray jsonArr = new JSONArray();
	
			if (mainList != null && mainList.size() > 0) {
	
				for (Map<String, String> mainMap : mainList) {
	
					JSONObject jsonObj = new JSONObject();
					try {
						jsonObj.put("CUST_NO", mainMap.get("CUST_NO"));
						jsonObj.put("CUST_NM", mainMap.get("CUST_NM"));
						jsonObj.put("MBL_NO", mainMap.get("MBL_NO"));
						jsonObj.put("CUST_SS_CD", mainMap.get("CUST_SS_CD"));
						jsonObj.put("JS_DT", mainMap.get("JS_DT"));
						jsonObj.put("JN_PRT_CD", mainMap.get("JN_PRT_CD"));
						jsonObj.put("PRT_NM", mainMap.get("PRT_NM"));
						jsonObj.put("FST_USER_ID", mainMap.get("FST_USER_ID"));
						jsonObj.put("USER_NM", mainMap.get("USER_NM"));
						jsonObj.put("LST_UPD_DT", mainMap.get("LST_UPD_DT"));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	
					jsonArr.put(jsonObj);
	
				}
			}
			return jsonArr.toString();
		}
		
	
		
		
		
		
		
		
		//2pg 고객정보수정
		@ResponseBody
		@RequestMapping(value = "/search/updCust22", produces = "text/plain;charset=UTF-8")
		public String updCust22(ModelAndView mav, @RequestParam Map<String, Object> map, HttpServletRequest request) {
		
			HttpSession session = request.getSession();
			MemberVO memberVO = (MemberVO) session.getAttribute("member");

			
			System.out.println("map : " + map);
			
			Map<String, Object> form = net.sf.json.JSONObject.fromObject(map.get("af_form"));
			List<Map<String,Object>> list = net.sf.json.JSONArray.fromObject(map.get("histList"));
			
			form.put("user_id", memberVO.getUser_id());
			
			System.out.println("form : " + form);
			
			//CS_CUST01_MT TABLE UPDATE
			
			String rst = memService.updCust(form);
			
			if(rst.equals("1")) {
				System.out.println("list.size() : " + list.size());
				for(int i = 0; i < list.size(); i++) {
					Map<String,Object> hist = list.get(i);
					hist.put("cust_no", form.get("cust_no_dis"));
					hist.put("user_id", form.get("user_id"));
					
					System.out.println("hist : " + hist);
					
					//SD_CUST01_HT TABLE INSERT
					
					rst = memService.updCustHist(hist);
				}
			}
			
			System.out.println("rst : " + rst);
			
			JSONObject jsonObj = new JSONObject();
			try {
				jsonObj.put("rst", rst);

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			return jsonObj.toString();
			
		}
	
	
		
		
		
		
		//3pg 모바일 중복 체크
		@ResponseBody
		@RequestMapping(value = "/search/checkMblNo", produces = "text/plain;charset=UTF-8")
		public String checkMbl(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
			System.out.println("map : " + map);
			
			String cnt = memService.checkMbl(map);
			
			System.out.println("cnt : " + cnt);
			
			JSONObject jsonObj = new JSONObject();
			try {
				jsonObj.put("CNT", cnt);

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			return jsonObj.toString();
			
		}
	
		
		
		
		
		
		
		//3pg 신규등록처리
		@ResponseBody
		@RequestMapping(value = "/search/newCust33", produces = "text/plain;charset=UTF-8")
		public String newCust33(ModelAndView mav, @RequestParam Map<String, Object> map, HttpServletRequest request) {
		
			HttpSession session = request.getSession();
			MemberVO memberVO = (MemberVO) session.getAttribute("member");
			
			map.put("user_id", memberVO.getUser_id());
			
			System.out.println("map : " + map);
			
			//신규등록처리
			String rst = memService.newCust33(map);
			
			//신규 등록이 성공되면 포인트를 넣어준다
			if(rst.equals("1")) {
				//포인트 구분 코드
				map.put("pnt_ds_cd", "100");
				//포인트 구분 상세 코드
				map.put("pnt_ds_dt_cd", "102");
				//포인트
				map.put("pnt", "1000");
				
				System.out.println("map : " + map);
				
				//포인트 디테일 테이블에 넣기
				rst = memService.newCustPntD(map);
				if(rst.equals("1")) {
					System.out.println("map : " + map);
					//포인트 마스터 테이블에 더해주기
					rst = memService.newCustPntM(map);
				}
			}
			
			System.out.println("rst : " + rst);
			System.out.println("map.cust_no : " + map.get("cust_no"));
			
			JSONObject jsonObj = new JSONObject();
			try {
				jsonObj.put("rst", rst);

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			return jsonObj.toString();
			
		}
		
		





	
		// 4pg 고객 조회
		@ResponseBody
		@RequestMapping(value = "/search/searchcust4", produces = "text/plain;charset=UTF-8")
		public String searchCust(ModelAndView mav, @RequestParam Map<String, Object> map) {
			System.out.println("map" + map);
	
			List<Map<String, String>> custList = memService.searchcust(map);
	
			JSONArray jsonArr = new JSONArray();
	
			if (custList != null && custList.size() > 0) {
	
				for (Map<String, String> custMap : custList) {
	
					JSONObject jsonObj = new JSONObject();
					try {
						jsonObj.put("CUST_NO", custMap.get("CUST_NO"));
						jsonObj.put("CUST_NM", custMap.get("CUST_NM"));
						jsonObj.put("MBL_NO", custMap.get("MBL_NO"));
						jsonObj.put("CUST_SS_CD", custMap.get("CUST_SS_CD"));
						jsonObj.put("AVB_PNT", custMap.get("AVB_PNT"));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	
					jsonArr.put(jsonObj);
	
				}
	
			}
	
			return jsonArr.toString();
		}
	
	
	
		
		
		
	
		// 5번 변경이력 조회
		@ResponseBody
		@RequestMapping(value = "/search/memHistory", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
		public String getHistory(ModelAndView mav, @RequestParam Map<String, Object> map) {
				
				List<Map<String, String>> historyList = memService.getHistoryList(map);
				// parameter로 map을 담아 getPopUpHistotyList를 실행한 뒤 결과값을 담는 popUpHistoryList 생성
				
				JSONArray jsonArr = new JSONArray();
				// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
				
				if(historyList != null && historyList.size() > 0) {
					
					for(Map<String, String> hisMap : historyList) {
						
						JSONObject jsonObj = new JSONObject();
						try {
							jsonObj.put("CUST_NO", hisMap.get("CUST_NO"));
							jsonObj.put("CUST_NM", hisMap.get("CUST_NM"));
							jsonObj.put("CHG_DT", hisMap.get("CHG_DT"));
							jsonObj.put("CHG_CD", hisMap.get("CHG_CD"));
							jsonObj.put("CHG_BF_CNT", hisMap.get("CHG_BF_CNT"));
							jsonObj.put("CHG_AFT_CNT", hisMap.get("CHG_AFT_CNT"));
							jsonObj.put("LST_UPD_ID", hisMap.get("LST_UPD_ID"));
							jsonObj.put("LST_UPD_DT", hisMap.get("LST_UPD_DT"));
							
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
	
						jsonArr.put(jsonObj); 
					}
					
				}
				
				return jsonArr.toString(); 
			}
		
			
	
	

		
	
		// 6pg 매장 조회
		@ResponseBody
		@RequestMapping(value = "/search/searchshop6", produces = "text/plain;charset=UTF-8")
		public String searchShop(ModelAndView mav, @RequestParam Map<String, Object> map) {
			// System.out.println("map"+map);
			List<Map<String, String>> shopList = memService.searchshop(map);
	
			JSONArray jsonArr = new JSONArray();
	
			if (shopList != null && shopList.size() > 0) {
	
				for (Map<String, String> shopMap : shopList) {
	
					JSONObject jsonObj = new JSONObject();
					try {
						jsonObj.put("PRT_CD", shopMap.get("PRT_CD"));
						jsonObj.put("PRT_NM", shopMap.get("PRT_NM"));
						jsonObj.put("PRT_SS_CD", shopMap.get("PRT_SS_CD"));
						jsonObj.put("PRT_DT_CD", shopMap.get("PRT_DT_CD"));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	
					jsonArr.put(jsonObj);
	
				}
			}
			return jsonArr.toString();
		}
	
		
	
		
	
	
	//7번 페이지 보내는 mav
	@RequestMapping(value = "/search/getTotal", method = RequestMethod.GET)
	public ModelAndView total7(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			HttpSession session = request.getSession();
			
			
			ModelAndView mav = new ModelAndView();
			
			MemberVO memberVO = (MemberVO) session.getAttribute("member");
			
			//System.out.println("memberVO.prt_cd : " + memberVO.getPrt_cd());
			//System.out.println("memberVO.user_id : " + memberVO.getUser_id());
			
			String se_user_dt_cd = memberVO.getUser_dt_cd();
			String prt_cd  = memberVO.getPrt_cd();
			String prt_cd_nm = memberVO.getPrt_nm();

			
			session.setAttribute("prt_cd_nm", prt_cd_nm);
			session.setAttribute("prt_cd", prt_cd);
			session.setAttribute("se_user_dt_cd", se_user_dt_cd);

			
			mav.setViewName("/search/totalCount");
	
			return mav;
	}
	
	

	
	
	
		
		//7 페이지 매장 월별 실적조회
		@ResponseBody
		@RequestMapping(value = "/search/getTotal77", produces = "text/plain;charset=UTF-8")
		public String getTotal(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		//System.out.println("maaaaP"+map);
		
		List<Map<String, String>> totalList = memService.getTotal(map);
		
		JSONArray jsonArr = new JSONArray();
		
		if (totalList != null && totalList.size() > 0) {

			for (Map<String, String> totalMap : totalList) {
				System.out.println("tatallll"+ totalMap.get("PRT_CD"));
				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("PRT_CD", totalMap.get("PRT_CD"));
					jsonObj.put("PRT_NM", totalMap.get("PRT_NM"));
					jsonObj.put("SAL_1_QTY", totalMap.get("SAL_1_QTY"));
					jsonObj.put("SAL_2_QTY", totalMap.get("SAL_2_QTY"));
					jsonObj.put("SAL_3_QTY", totalMap.get("SAL_3_QTY"));
					jsonObj.put("SAL_4_QTY", totalMap.get("SAL_4_QTY"));
					jsonObj.put("SAL_5_QTY", totalMap.get("SAL_5_QTY"));
					jsonObj.put("SAL_6_QTY", totalMap.get("SAL_6_QTY"));
					jsonObj.put("SAL_7_QTY", totalMap.get("SAL_7_QTY"));
					jsonObj.put("SAL_8_QTY", totalMap.get("SAL_8_QTY"));
					jsonObj.put("SAL_9_QTY", totalMap.get("SAL_9_QTY"));
					jsonObj.put("SAL_10_QTY", totalMap.get("SAL_10_QTY"));
					jsonObj.put("SAL_11_QTY", totalMap.get("SAL_11_QTY"));
					jsonObj.put("SAL_12_QTY", totalMap.get("SAL_12_QTY"));
					jsonObj.put("SAL_13_QTY", totalMap.get("SAL_13_QTY"));
					jsonObj.put("SAL_14_QTY", totalMap.get("SAL_14_QTY"));
					jsonObj.put("SAL_15_QTY", totalMap.get("SAL_15_QTY"));
					jsonObj.put("SAL_16_QTY", totalMap.get("SAL_16_QTY"));
					jsonObj.put("SAL_17_QTY", totalMap.get("SAL_17_QTY"));
					jsonObj.put("SAL_18_QTY", totalMap.get("SAL_18_QTY"));
					jsonObj.put("SAL_19_QTY", totalMap.get("SAL_19_QTY"));
					jsonObj.put("SAL_20_QTY", totalMap.get("SAL_20_QTY"));
					jsonObj.put("SAL_21_QTY", totalMap.get("SAL_21_QTY"));
					jsonObj.put("SAL_22_QTY", totalMap.get("SAL_22_QTY"));
					jsonObj.put("SAL_23_QTY", totalMap.get("SAL_23_QTY"));
					jsonObj.put("SAL_24_QTY", totalMap.get("SAL_24_QTY"));
					jsonObj.put("SAL_25_QTY", totalMap.get("SAL_25_QTY"));
					jsonObj.put("SAL_26_QTY", totalMap.get("SAL_26_QTY"));
					jsonObj.put("SAL_27_QTY", totalMap.get("SAL_27_QTY"));
					jsonObj.put("SAL_28_QTY", totalMap.get("SAL_28_QTY"));
					jsonObj.put("SAL_29_QTY", totalMap.get("SAL_29_QTY"));
					jsonObj.put("SAL_30_QTY", totalMap.get("SAL_30_QTY"));
					jsonObj.put("SAL_31_QTY", totalMap.get("SAL_31_QTY"));
					jsonObj.put("TOT_SAL_QTY", totalMap.get("TOT_SAL_QTY"));
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				jsonArr.put(jsonObj);

			}

		}

		return jsonArr.toString();
	}
		
	
			
			

}
