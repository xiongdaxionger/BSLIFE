package com.qianseit.westore.httpinterface.passport;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class PrivacyInterface extends BaseHttpInterfaceTask {

	public PrivacyInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.privacy";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		responsePrivacy(responseJson.optString("reg_privacy"));
	}

	public abstract void responsePrivacy(String protocol);
}
