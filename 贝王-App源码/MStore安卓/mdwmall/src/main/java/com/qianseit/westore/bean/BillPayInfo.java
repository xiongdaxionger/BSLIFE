package com.qianseit.westore.bean;

import java.io.Serializable;

/**
 * 账单
 * @author Administrator
 */
public class BillPayInfo implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String imgPath;
	private String title;
	private String status;//账单状态,0为进账单,1为出账单,2为佣金账单,3为待确认账单
	private String money;
	private String time;
	
	public BillPayInfo() {
		super();
	}
	public BillPayInfo(String imgPath, String title, String status,
			String money, String time) {
		super();
		this.imgPath = imgPath;
		this.title = title;
		this.status = status;
		this.money = money;
		this.time = time;
	}
	public String getImgPath() {
		return imgPath;
	}
	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getMoney() {
		return money;
	}
	public void setMoney(String money) {
		this.money = money;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	

}
