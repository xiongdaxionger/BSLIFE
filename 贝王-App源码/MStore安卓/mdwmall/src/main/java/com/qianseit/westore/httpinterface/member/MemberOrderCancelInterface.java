package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.39 取消订单
 */
public abstract class MemberOrderCancelInterface extends BaseHttpInterfaceTask {

	String mOrderId;
	String mReasonType;
	String mReasonRemark;

	public MemberOrderCancelInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.docancel";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_cancel_reason[order_id]", mOrderId);
		if (!TextUtils.isEmpty(mReasonType)) {
			nContentValues.put("order_cancel_reason[reason_type]", mReasonType);
		}
		if (!TextUtils.isEmpty(mReasonRemark)) {
			nContentValues.put("order_cancel_reason[reason_desc]", mReasonRemark);
		}
		return nContentValues;
	}

	public void cancel(String orderId) {
		cancel(orderId, -1, "");
	}

	public void cancel(String orderId, int reasonType, String reasonRemark) {
		mOrderId = orderId;
		mReasonType = reasonType < 0 ? "" : reasonType + "";
		mReasonRemark = reasonRemark;
		RunRequest();
	}
}
