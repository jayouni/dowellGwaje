package first.check.gwaje.dao;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import first.check.gwaje.vo.FirstTableVO;
import first.check.gwaje.vo.MemberVO;
import first.check.gwaje.vo.ProductVO;

@Repository
public class MemDAOImpl implements MemDAO {
	
	@Autowired
	private SqlSession sqlSession;


	@Override
	public MemberVO login(MemberVO member) {
		return sqlSession.selectOne("first.check.login", member);

	}



	@Override
	public List<FirstTableVO> test(String cust_no) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.test", cust_no);
	}


	@Override
	public List<Map<String, String>> searchshop(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.sixTable", map);
	}


	@Override
	public List<Map<String, String>> searchcust(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.fourtable", map);
	}


	@Override
	public List<Map<String, String>> getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.totalTable", map);
	}


	@Override
	public List<Map<String, String>> firstList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.firstTable", map);
	}



	@Override
	public List<Map<String, String>> getHistoryList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.history", map);
	}



	@Override
	public String checkMbl(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("first.check.mobile", map);
	}



	@Override
	public String newCust33(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.newCust33", map));
	}



	@Override
	public Map getCustInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("first.check.getCustInfo", map);
	}



	@Override
	public String updCust(Map<String, Object> form) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.update("first.check.updCust", form));
	}



	@Override
	public String updCustHist(Map<String, Object> form) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.updCustHist", form));
	}



	@Override
	public List<Map<String, String>> custMod2(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("first.check.getCustInfo", map);
	}



	@Override
	public String newCustPntD(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.newCustPntD", map));
	}



	@Override
	public String newCustPntM(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.newCustPntM", map));
	}



	@Override
	public List<Map<String, String>> panmeMainTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.panMainTable", map);
	}



	@Override
	public List<Map<String, String>> panmeSangTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.panSangTable", map);
	}



	@Override
	public List<Map<String, String>> jegoTable(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("first.check.jegoTable", map);
	}



	@Override
	public String newSalMt(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.insSalMt", map));
	}
	
	@Override
	public String newSalDt(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.insert("first.check.insSalDt", map));
	}
	
	@Override
	public String updIvcoMt(Map<String, Object> form) {
		// TODO Auto-generated method stub
		return String.valueOf(sqlSession.update("first.check.updIvcoMt", form));
	}













	

}
