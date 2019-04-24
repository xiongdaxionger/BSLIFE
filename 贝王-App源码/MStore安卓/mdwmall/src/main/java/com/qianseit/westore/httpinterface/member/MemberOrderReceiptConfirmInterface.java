package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *4.18 确认收货
 */
public abstract class MemberOrderReceiptConfirmInterface extends BaseHttpInterfaceTask {

	String mOrderId;
	String mReasonType;
	String mReasonRemark;

	public MemberOrderReceiptConfirmInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.receive";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}

	public void receiptConfirm(String orderId) {
		mOrderId = orderId;
		RunRequest();
	}
}
