package com.qianseit.westore.httpinterface.wealth;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class WealthBankAddInterface extends BaseHttpInterfaceTask {

	String mVCode, mBankNumber, mBankName, mRealName, mPhone;
	/**
	 * 1 => 银行卡，2 => 支付宝, 3 => 信用卡
	 */
	int mBankType = 1;

	public WealthBankAddInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.addbankcard";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("vcode", mVCode);
		nContentValues.put("bank_num", mBankNumber);
		nContentValues.put("bank_name", mBankName);
		nContentValues.put("real_name", mRealName);
		nContentValues.put("mobile", mPhone);
		nContentValues.put("bank_type", String.valueOf(mBankType));
		return nContentValues;
	}
	
	void reset(){
		mVCode = "";
		mBankNumber = "";
		mBankName = "";
		mRealName = "";
		mPhone = "";
		mBankType = 1;
	}
	
	/**
	 * 银行卡
	 */
	/**
	 * @param vcode
	 * @param number银行卡号
	 * @param bankName银行名称
	 * @param realName开户人姓名
	 * @param mobile手机号
	 */
	public void addBankCard(String vcode, String number, String bankName, String realName, String mobile) {
		reset();
		mVCode = vcode;
		mBankNumber = number;
		mBankName = bankName;
		mRealName = realName;
		mPhone = mobile;
		mBankType = 1;
		RunRequest();
	}

	/**
	 * 支付宝
	 */
	public void addAli(String vcode, String number, String realName, String mobile) {
		reset();
		mVCode = vcode;
		mBankNumber = number;
		mBankName = "支付宝";
		mRealName = realName;
		mPhone = mobile;
		mBankType = 2;
		RunRequest();
	}
}
