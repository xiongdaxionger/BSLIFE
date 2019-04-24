package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *4.40 删除作废订单
 */
public abstract class MemberOrderDeleteInterface extends BaseHttpInterfaceTask {

	String mOrderId;
	String mReasonType;
	String mReasonRemark;

	public MemberOrderDeleteInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.dodelete";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}

	public void delete(String orderId) {
		mOrderId = orderId;
		RunRequest();
	}
}
