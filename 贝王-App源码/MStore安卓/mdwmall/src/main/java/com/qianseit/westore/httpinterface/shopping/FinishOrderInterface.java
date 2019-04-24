package com.qianseit.westore.httpinterface.shopping;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class FinishOrderInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;

	public FinishOrderInterface(QianseitActivityInterface activityInterface, String orderIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.afterorder.okgoods";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderIdString);
		return nContentValues;
	}

}
