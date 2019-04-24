package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppOrderDetailInterface extends BaseHttpInterfaceTask {

	String mOrderId;
	
	public ShoppOrderDetailInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.orderdetail";
	}
	
	public void getDetail(String orderId){
		mOrderId = orderId;
		RunRequest();
	}
}
