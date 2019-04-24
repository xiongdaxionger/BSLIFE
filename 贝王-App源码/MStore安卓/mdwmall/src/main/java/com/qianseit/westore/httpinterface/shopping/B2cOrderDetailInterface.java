package com.qianseit.westore.httpinterface.shopping;


import org.json.JSONObject;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class B2cOrderDetailInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;
	public B2cOrderDetailInterface(QianseitActivityInterface activityInterface, String orderIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.detail";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("tid", mOrderIdString);
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject data = responseJson.optJSONObject("data");
		PaymentStatus(!TextUtils.equals(data.optString("pay_status"), "PAY_NO"));
	}

	public abstract void PaymentStatus(boolean paymentStatus);
}
