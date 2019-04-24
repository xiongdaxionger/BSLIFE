package com.qianseit.westore.httpinterface.passport;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class RegistrationProtocolInterface extends BaseHttpInterfaceTask {

	public RegistrationProtocolInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.license";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		responseProtocol(responseJson.optString("reg_license"));
	}

	public abstract void responseProtocol(String protocol);
}
