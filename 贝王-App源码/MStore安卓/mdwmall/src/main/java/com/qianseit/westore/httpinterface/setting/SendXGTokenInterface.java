package com.qianseit.westore.httpinterface.setting;

import android.content.ContentValues;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public class SendXGTokenInterface extends BaseHttpInterfaceTask {

	String mToken;
	public SendXGTokenInterface(QianseitActivityInterface activityInterface, String token) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mToken = token;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.save_token";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("token", mToken);
		nContentValues.put("tag_type", "android");
		return nContentValues;
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub

	}

}
