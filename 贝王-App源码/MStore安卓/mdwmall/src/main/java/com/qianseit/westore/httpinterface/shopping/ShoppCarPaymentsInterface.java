package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppCarPaymentsInterface extends BaseHttpInterfaceTask {
	String mShipping;
	String mCurrency;
	/**
	 * prepare:预售
	 */
	String mPrepare = "";

	public ShoppCarPaymentsInterface(QianseitActivityInterface activityInterface, String shipping, String currency) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mShipping = shipping;
		mCurrency = currency;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.payment_change";
	}
	
	/**
	 * prepare:预售
	 */
	public void setPrepare(){
		mPrepare = "prepare";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (!TextUtils.isEmpty(mShipping)) {
			nContentValues.put("shipping", mShipping);
		}
		if (!TextUtils.isEmpty(mCurrency)) {
			nContentValues.put("payment[currency]", mCurrency);
		}
		if (!TextUtils.isEmpty(mPrepare)) {
			nContentValues.put("no_offline", mPrepare);
		}
		return nContentValues;
	}
}
