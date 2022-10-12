package first.check.gwaje.vo;

import org.springframework.stereotype.Component;

@Component
public class ProductVO {
	
	//MA_PRT_MT
	private String prt_cd;
	private String prt_nm;
	private String prt_ss_cd;
	private String prt_dt_cd;
	
	public String getPrt_dt_cd() {
		return prt_dt_cd;
	}
	public void setPrt_dt_cd(String prt_dt_cd) {
		this.prt_dt_cd = prt_dt_cd;
	}
	private String in_prt;
	
	public String getIn_prt() {
		return in_prt;
	}
	public void setIn_prt(String in_prt) {
		this.in_prt = in_prt;
	}
	public String getPrt_cd() {
		return prt_cd;
	}
	public void setPrt_cd(String prt_cd) {
		this.prt_cd = prt_cd;
	}
	public String getPrt_nm() {
		return prt_nm;
	}
	public void setPrt_nm(String prt_nm) {
		this.prt_nm = prt_nm;
	}
	public String getPrt_ss_cd() {
		return prt_ss_cd;
	}
	public void setPrt_ss_cd(String prt_ss_cd) {
		this.prt_ss_cd = prt_ss_cd;
	}
	
	

}
