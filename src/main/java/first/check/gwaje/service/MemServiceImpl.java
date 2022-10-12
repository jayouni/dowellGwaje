package first.check.gwaje.service;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import first.check.gwaje.dao.MemDAO;
import first.check.gwaje.vo.FirstTableVO;
import first.check.gwaje.vo.MemberVO;
import first.check.gwaje.vo.ProductVO;

@Service
public class MemServiceImpl implements MemService {
	
	@Autowired
	MemDAO memDao;


	@Override
	public MemberVO login(MemberVO member) {
		return memDao.login(member);
	}




	@Override
	public List<FirstTableVO> test(String cust_no) {
		// TODO Auto-generated method stub
		return memDao.test(cust_no);
	}


	@Override
	public List<Map<String, String>> searchshop(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.searchshop(map);
	}


	@Override
	public List<Map<String, String>> searchcust(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.searchcust(map);
	}


	@Override
	public List<Map<String, String>> getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.getTotal(map);
	}


	@Override
	public List<Map<String, String>> firstList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.firstList(map);
	}




	@Override
	public List<Map<String, String>> getHistoryList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.getHistoryList(map);
	}




	@Override
	public String checkMbl(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.checkMbl(map);
	}




	@Override
	public String newCust33(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.newCust33(map);
	}




	@Override
	public Map getCustInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.getCustInfo(map);
	}




	@Override
	public String updCust(Map<String, Object> form) {
		// TODO Auto-generated method stub
		return memDao.updCust(form);
	}




	@Override
	public String updCustHist(Map<String, Object> form) {
		// TODO Auto-generated method stub
		return memDao.updCustHist(form);
	}




	@Override
	public List<Map<String, String>> custMod2(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.custMod2(map);
	}




	@Override
	public String newCustPntD(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.newCustPntD(map);
	}




	@Override
	public String newCustPntM(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.newCustPntM(map);
	}




	@Override
	public List<Map<String, String>> panMainTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.panmeMainTable(map);
	}




	@Override
	public List<Map<String, String>> panSangTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.panmeSangTable(map);
	}




	@Override
	public List<Map<String, String>> jegoTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.jegoTable(map);
	}




	@Override
	public String newSalMt(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.newSalMt(map);
	}
	
	@Override
	public String newSalDt(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.newSalDt(map);
	}
	
	@Override
	public String updIvcoMt(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return memDao.updIvcoMt(map);
	}
























}
