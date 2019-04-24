package com.qianseit.westore.httpinterface.member;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberGetInviteContent extends BaseHttpInterfaceTask {
	public MemberGetInviteContent(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_invite_content";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		ResponseContent(responseJson.optString("data"));
	}

	public abstract void ResponseContent(String inviteContent);
}
