package com.qianseit.westore.httpinterface.setting;


import android.content.ContentValues;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class CheckPayPasswordInterface extends BaseHttpInterfaceTask {

	String mPayPasswordString;
	public CheckPayPasswordInterface(QianseitActivityInterface activityInterface, String payPasswordString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mPayPasswordString = payPasswordString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.paycenter.pay_password";
		
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("pay_password", mPayPasswordString);
		return nContentValues;
	}
	
	@Override
	public void FailRequest() {
		// TODO Auto-generated method stub
		if (mErrorJsonObject == null) {
			return;
		}
		
		String nCode = mErrorJsonObject.optString("code");
		if (nCode.equals("pay_password_error")) {
			if (mErrorJsonObject.optJSONObject("data").optInt("limit") <= 0) {
				modPassword();
			}
		}
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		Correct();
	}

	/**
	 * 正确
	 */
	public abstract void Correct();
	
	/**
	 * 支付密码错误次数过多，导致支付密码失效，请重新设置支付密码
	 */
	public abstract void modPassword();
}
