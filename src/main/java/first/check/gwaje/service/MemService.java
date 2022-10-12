package first.check.gwaje.service;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import first.check.gwaje.vo.FirstTableVO;
import first.check.gwaje.vo.MemberVO;
import first.check.gwaje.vo.ProductVO;

public interface MemService {


	MemberVO login(MemberVO member);

	
	List<FirstTableVO> test(String cust_no);
	

	List<Map<String, String>> searchshop(Map<String, Object> map);
	

	List<Map<String, String>> searchcust(Map<String, Object> map);
	

	List<Map<String, String>> getTotal(Map<String, Object> map);
	

	List<Map<String, String>> firstList(Map<String, Object> map);
	

	List<Map<String, String>> getHistoryList(Map<String, Object> map);


	String checkMbl(Map<String, Object> map);
	
	String newCust33(Map<String, Object> map);


	Map getCustInfo(Map<String, Object> map);


	String updCust(Map<String, Object> form);


	String updCustHist(Map<String, Object> form);


	List<Map<String, String>> custMod2(Map<String, Object> map);


	String newCustPntD(Map<String, Object> map);


	String newCustPntM(Map<String, Object> map);


	List<Map<String, String>> panMainTable(Map<String, Object> map);


	List<Map<String, String>> panSangTable(Map<String, Object> map);


	List<Map<String, String>> jegoTable(Map<String, Object> map);


	String newSalMt(Map<String, Object> map);


	String newSalDt(Map<String, Object> map);


	String updIvcoMt(Map<String, Object> salDtMap);





	

	

	

}
