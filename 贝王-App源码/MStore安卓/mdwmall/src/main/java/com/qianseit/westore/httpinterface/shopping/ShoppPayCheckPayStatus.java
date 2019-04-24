package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 6.8 查询订单支付状态
 */
public abstract class ShoppPayCheckPayStatus extends BaseHttpInterfaceTask {

	public ShoppPayCheckPayStatus(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	String mOrderId;
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.paycenter.check_payments";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}
	
	public void checkPayStatus(String orderId){
		mOrderId = orderId;
		RunRequest();
	}
}
