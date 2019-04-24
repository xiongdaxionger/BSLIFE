package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 5.1 用户登录
 */
public abstract class LoginInterface extends BaseHttpInterfaceTask {
	String mUserCode, mPwd, mVCode;

	public LoginInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.post_login";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("uname", mUserCode);
		nContentValues.put("password", mPwd);
		if (!TextUtils.isEmpty(mVCode)) {
			nContentValues.put("verifycode", mVCode);
		}
		
		return nContentValues;
	}
	
	public void setLoginInfo(String userCode, String pwd, String vcode){
		mUserCode = userCode;
		mPwd = pwd;
		mVCode = vcode;
	}
}
