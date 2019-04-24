package com.qianseit.westore.bean.member;

import com.qianseit.westore.bean.BaseBean;

public class MemberLv extends BaseBean {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7274352875090755677L;
	
	String show;
	String lv_name;
	int lv_data;
	/**
	 * 0:积分|1：经验值
	 */
	int switch_type;
	
	public String getShow() {
		return show;
	}
	public void setShow(String show) {
		this.show = show;
	}
	public String getLv_name() {
		return lv_name;
	}
	public void setLv_name(String lv_name) {
		this.lv_name = lv_name;
	}
	public int getLv_data() {
		return lv_data;
	}
	public void setLv_data(int lv_data) {
		this.lv_data = lv_data;
	}
	/**
	 * 0:积分|1：经验值
	 */
	public int getSwitch_type() {
		return switch_type;
	}
	public void setSwitch_type(int switch_type) {
		this.switch_type = switch_type;
	}
	
	public void clear(){
		setLv_data(0);
		setLv_name("");
		setShow("");
		setSwitch_type(0);
	}
}
