package com.qianseit.westore.activity.acco;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberPasswordIndexInterface;

import org.json.JSONObject;

public abstract class BasePayPasswordFragment extends BaseDoFragment {
	
	protected JSONObject mPasswordIndexJsonObject;
	MemberPasswordIndexInterface mPasswordIndexInterface = new MemberPasswordIndexInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mPasswordIndexJsonObject = responseJson;
			passwordIndexLoaded();
		}
		
		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			nContentValues.put("verifyType", passwordType());
			return nContentValues;
		}
	};

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		mPasswordIndexInterface.RunRequest();
	}
	
	protected boolean showVCode(){
		if (mPasswordIndexJsonObject == null) {
			return false;
		}
		
		return mPasswordIndexJsonObject.optBoolean("show_varycode");
	}

	/**
	 * @return
	 * 发送短信验证码需要图形验证码
	 */
	protected boolean needVCodeSMSVcode(){
		if (mPasswordIndexJsonObject == null) {
			return false;
		}
		
		return mPasswordIndexJsonObject.optBoolean("show_varycode");
	}
	
	protected String getVCodeUrl(){
		if (mPasswordIndexJsonObject == null) {
			return "";
		}
		
		return mPasswordIndexJsonObject.optString("code_url") + "?" + System.currentTimeMillis();
	}
	
	protected String getPhoneShow(){
		if (mPasswordIndexJsonObject == null) {
			return "";
		}
		JSONObject nJsonObject = mPasswordIndexJsonObject.optJSONObject("show");
		if (nJsonObject == null) {
			return "";
		}
		
		return nJsonObject.optString("mobile");
	}
	
	protected String getPhone(){
		if (mPasswordIndexJsonObject == null) {
			return "";
		}
		JSONObject nJsonObject = mPasswordIndexJsonObject.optJSONObject("data");
		if (nJsonObject == null) {
			return "";
		}
		
		return nJsonObject.optString("mobile");
	}
	
	protected abstract void passwordIndexLoaded();
	/**
	 * @return
	 * setpaypassword:设置支付密码，verifypaypassword:修改支付密码/忘记支付密码，verifymobile:绑定手机
	 */
	protected abstract String passwordType();
}
