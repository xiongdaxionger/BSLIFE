package com.qianseit.westore.httpinterface.member;

import org.json.JSONObject;

import android.text.TextUtils;

import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberSecurityInterface extends BaseHttpInterfaceTask {

	public MemberSecurityInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.security";
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject nJsonObject = responseJson.optJSONObject("data");
		boolean isBinded = false;
		if (nJsonObject != null) {
			//先绑定手机号
			String nMobile = nJsonObject.optString("mobile");
			LoginedUser.getInstance().mobile = nMobile;
			if (!TextUtils.isEmpty(nMobile) && !nMobile.equalsIgnoreCase("null")) {
				isBinded = true;
			}
		}
		
		isBindMobile(isBinded);
	}
	
	public abstract void isBindMobile(boolean isBinded);
}
