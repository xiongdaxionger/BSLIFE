package com.qianseit.westore.bean;

import java.io.Serializable;

/**
 * 银行卡信息
 * @author Administrator
 *
 */
public class BankInfo implements Serializable{
	private static final long serialVersionUID = 1L;
		private String imgPath;
		private String bank_id;
		private String bank_num;//银行卡号
		private String bank_name;//银行名字
		private String real_name;//银行卡账户名称
		private String bank_type;// 银行卡类型 
		private boolean isSelected=false;//是否选择当前充值方式
		public BankInfo(String imgPath, String bank_num, String bank_name,
				String real_name, String bank_type) {
			super();
			this.imgPath = imgPath;
			this.bank_num = bank_num;
			this.bank_name = bank_name;
			this.real_name = real_name;
			this.bank_type = bank_type;
		}
		
		public BankInfo(String imgPath, String bank_id, String bank_num,
				String bank_name, String real_name, String bank_type,
				boolean isSelected) {
			super();
			this.imgPath = imgPath;
			this.bank_id = bank_id;
			this.bank_num = bank_num;
			this.bank_name = bank_name;
			this.real_name = real_name;
			this.bank_type = bank_type;
			this.isSelected = isSelected;
		}

		public BankInfo(String imgPath, String bank_num, String bank_name,
				String real_name, String bank_type, boolean isSelected) {
			super();
			this.imgPath = imgPath;
			this.bank_num = bank_num;
			this.bank_name = bank_name;
			this.real_name = real_name;
			this.bank_type = bank_type;
			this.isSelected = isSelected;
		}
		
		public BankInfo() {
			
		}

		public String getBank_id() {
			return bank_id;
		}

		public void setBank_id(String bank_id) {
			this.bank_id = bank_id;
		}

		public String getImgPath() {
			return imgPath;
		}
		public void setImgPath(String imgPath) {
			this.imgPath = imgPath;
		}
		public String getBank_num() {
			return bank_num;
		}
		public void setBank_num(String bank_num) {
			this.bank_num = bank_num;
		}
		public String getBank_name() {
			return bank_name;
		}
		public void setBank_name(String bank_name) {
			this.bank_name = bank_name;
		}
		public String getReal_name() {
			return real_name;
		}
		public void setReal_name(String real_name) {
			this.real_name = real_name;
		}
		public String getBank_type() {
			return bank_type;
		}
		public void setBank_type(String bank_type) {
			this.bank_type = bank_type;
		}
		public boolean isSelected() {
			return isSelected;
		}
		public void setSelected(boolean isSelected) {
			this.isSelected = isSelected;
		}
		
		
		
}
