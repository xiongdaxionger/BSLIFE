package com.qianseit.westore.httpinterface.wealth;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class WealthRechargeInterface extends BaseHttpInterfaceTask {

	String mPaymentAppid = "";
	double mAmount = 0.00;

	public WealthRechargeInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.dopayment_recharge";
	}

	public void recharge(String paymentAppid, double amount) {
		mPaymentAppid = paymentAppid;
		mAmount = amount;
		RunRequest();
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("payment[pay_app_id]", mPaymentAppid);
		nContentValues.put("payment[money]", String.valueOf(mAmount));
		return nContentValues;
	}
}
