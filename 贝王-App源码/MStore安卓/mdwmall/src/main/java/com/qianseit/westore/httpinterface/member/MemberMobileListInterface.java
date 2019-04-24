package com.qianseit.westore.httpinterface.member;


import android.content.ContentValues;

import org.json.JSONArray;
import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberMobileListInterface extends BaseHttpInterfaceTask {
	String mMobileListString;
	public MemberMobileListInterface(QianseitActivityInterface activityInterface, String mobileListString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMobileListString = mobileListString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.member.mobile_list";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("mobiles", mMobileListString);
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject data = responseJson.optJSONObject("data");
		HadInvitedList(data.optJSONArray("reg"));
		NeedInvitedList(data.optJSONArray("no_reg"));
	}

	public abstract void HadInvitedList(JSONArray hadInvitedArray);
	public abstract void NeedInvitedList(JSONArray needInvitedArray);
}
