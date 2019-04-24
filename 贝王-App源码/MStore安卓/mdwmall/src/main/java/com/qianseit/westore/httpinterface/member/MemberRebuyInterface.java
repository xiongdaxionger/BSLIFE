package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.33 订单商品重新购买
 */
public abstract class MemberRebuyInterface extends BaseHttpInterfaceTask {
	String mOrderId;

	public MemberRebuyInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.reAddCart";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}
	
	public void rebuy(String orderId){
		mOrderId = orderId;
		RunRequest();
	}
}
