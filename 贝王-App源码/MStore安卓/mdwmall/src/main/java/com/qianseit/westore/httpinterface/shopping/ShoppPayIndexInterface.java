package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppPayIndexInterface extends BaseHttpInterfaceTask {

	String mOrderId;
	public ShoppPayIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.paycenter.index";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}
	
	@Override
	public void FailRequest() {
		// TODO Auto-generated method stub
		if (mErrorJsonObject != null && mErrorJsonObject.optString("code").equalsIgnoreCase("is_payed")) {//已支付
			isPaied();
		}
	}
	
	/**
	 * 已支付
	 * code = 'is_payed'
	 */
	public abstract void isPaied();
	
	public void getPayIndex(String orderId){
		mOrderId = orderId;
		RunRequest();
	}
}
