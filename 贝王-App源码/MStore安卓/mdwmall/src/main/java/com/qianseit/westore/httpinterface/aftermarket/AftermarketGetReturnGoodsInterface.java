package com.qianseit.westore.httpinterface.aftermarket;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.56申请订单退款
 * @author qianseit
 *
 */
public abstract class AftermarketGetReturnGoodsInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;
	
	public AftermarketGetReturnGoodsInterface(QianseitActivityInterface activityInterface, String orderIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.aftersales.add";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderIdString);
		return nContentValues;
	}
}
