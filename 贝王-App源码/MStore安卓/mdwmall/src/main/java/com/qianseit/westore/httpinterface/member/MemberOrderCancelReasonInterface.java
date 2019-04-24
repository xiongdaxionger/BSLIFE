package com.qianseit.westore.httpinterface.member;

import org.json.JSONArray;
import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.38 取消订单原因列表
 */
public abstract class MemberOrderCancelReasonInterface extends BaseHttpInterfaceTask {

	public MemberOrderCancelReasonInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.order_cancel_reason";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (responseJson == null || responseJson.isNull("data")) {
			return;
		}
		
		JSONArray nArray = responseJson.optJSONArray("data");
		if (nArray == null || nArray.length() <= 0) {
			return;
		}
		
		responseReason(nArray);
	}
	
	public abstract void responseReason(JSONArray reasonArray);

}
