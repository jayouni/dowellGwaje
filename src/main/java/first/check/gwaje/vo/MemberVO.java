package first.check.gwaje.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component
public class MemberVO {
	
	//MA_USER_MT
	
	private String user_id;
	private String user_nm;
	private String user_dt_cd;
	private String use_yn;
	private String use_pwd;
	private String st_dt;
	private String ed_dt;
	private String prt_cd;
	private String pwd_upd_dt;
	private Date fst_reg_dt;
	private String fst_user_id;
	private Date lst_upd_dt;
	private String lst_upd_id;
	
	private String cust_nm;
	private String cust_no;
	private String mbl_no;
	private String cust_ss_cd;
	private String js_dt;
	private String jn_prt_cd;

	private String prt_cd_nm;
	private String in_cust_no;
	private String jn_to;
	private String jn_from;
	
	private String prt_nm;
	private String prt_dt_cd;

	//MA_PRT_MT
	
	public String getPrt_cd_nm() {
		return prt_cd_nm;
	}
	public void setPrt_cd_nm(String prt_cd_nm) {
		this.prt_cd_nm = prt_cd_nm;
	}
	public String getIn_cust_no() {
		return in_cust_no;
	}
	public void setIn_cust_no(String in_cust_no) {
		this.in_cust_no = in_cust_no;
	}
	public String getJn_to() {
		return jn_to;
	}
	public void setJn_to(String jn_to) {
		this.jn_to = jn_to;
	}
	public String getJn_from() {
		return jn_from;
	}
	public void setJn_from(String jn_from) {
		this.jn_from = jn_from;
	}

	
	public String getCust_no() {
		return cust_no;
	}
	public void setCust_no(String cust_no) {
		this.cust_no = cust_no;
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
	public String getCust_nm() {
		return cust_nm;
	}
	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}

	
	
	public String getPrt_dt_cd() {
		return prt_dt_cd;
	}
	public void setPrt_dt_cd(String prt_dt_cd) {
		this.prt_dt_cd = prt_dt_cd;
	}
	public String getPrt_nm() {
		return prt_nm;
	}
	public void setPrt_nm(String prt_nm) {
		this.prt_nm = prt_nm;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_nm() {
		return user_nm;
	}
	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
	}
	public String getUser_dt_cd() {
		return user_dt_cd;
	}
	public void setUser_dt_cd(String user_dt_cd) {
		this.user_dt_cd = user_dt_cd;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getUse_pwd() {
		return use_pwd;
	}
	public void setUse_pwd(String use_pwd) {
		this.use_pwd = use_pwd;
	}
	public String getSt_dt() {
		return st_dt;
	}
	public void setSt_dt(String st_dt) {
		this.st_dt = st_dt;
	}
	public String getEd_dt() {
		return ed_dt;
	}
	public void setEd_dt(String ed_dt) {
		this.ed_dt = ed_dt;
	}
	public String getPrt_cd() {
		return prt_cd;
	}
	public void setPrt_cd(String prt_cd) {
		this.prt_cd = prt_cd;
	}
	public String getPwd_upd_dt() {
		return pwd_upd_dt;
	}
	public void setPwd_upd_dt(String pwd_upd_dt) {
		this.pwd_upd_dt = pwd_upd_dt;
	}
	public Date getFst_reg_dt() {
		return fst_reg_dt;
	}
	public void setFst_reg_dt(Date fst_reg_dt) {
		this.fst_reg_dt = fst_reg_dt;
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
	public String getLst_upd_id() {
		return lst_upd_id;
	}
	public void setLst_upd_id(String lst_upd_id) {
		this.lst_upd_id = lst_upd_id;
	}
	
	
	
	

	
	
}
