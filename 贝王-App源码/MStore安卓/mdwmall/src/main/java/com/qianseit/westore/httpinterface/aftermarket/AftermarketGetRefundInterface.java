package com.qianseit.westore.httpinterface.aftermarket;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.56申请订单退款
 * @author qianseit
 *
 */
public abstract class AftermarketGetRefundInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;
	String mType;
	
	/**
	 * @param activityInterface
	 * @param orderIdString
	 * @param type:reship:(退换货)/refund:退款
	 */
	public AftermarketGetRefundInterface(QianseitActivityInterface activityInterface, String orderIdString, String type) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
		mType = type;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "aftersales.aftersales.add";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderIdString);
		nContentValues.put("type", mType);
		return nContentValues;
	}
}
