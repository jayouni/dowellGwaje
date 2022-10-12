package first.check.gwaje.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component
public class CustomerVO {
	
	private String cust_no;
	private String cust_nm;
	private String mbl_no;
	private String cust_ss_cd;
	private String js_dt;
	private String jn_prt_cd;
	private String fst_user_id;
	private Date lst_upd_dt;
	
	
	public String getCust_no() {
		return cust_no;
	}
	public void setCust_no(String cust_no) {
		this.cust_no = cust_no;
	}
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}
	public String getMbl_no() {
		return mbl_no;
	}
	public void setMbl_no(String mbl_no) {
		this.mbl_no = mbl_no;
	}
	public String getCust_ss_cd() {
		return cust_ss_cd;
	}
	public void setCust_ss_cd(String cust_ss_cd) {
		this.cust_ss_cd = cust_ss_cd;
	}
	public String getJs_dt() {
		return js_dt;
	}
	public void setJs_dt(String js_dt) {
		this.js_dt = js_dt;
	}
	public String getJn_prt_cd() {
		return jn_prt_cd;
	}
	public void setJn_prt_cd(String jn_prt_cd) {
		this.jn_prt_cd = jn_prt_cd;
	}
	public String getFst_user_id() {
		return fst_user_id;
	}
	public void setFst_user_id(String fst_user_id) {
		this.fst_user_id = fst_user_id;
	}
	public Date getLst_upd_dt() {
		return lst_upd_dt;
	}
	public void setLst_upd_dt(Date lst_upd_dt) {
		this.lst_upd_dt = lst_upd_dt;
	}
	
	

}
