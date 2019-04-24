package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ForgetLoginPasswordInterface extends BaseHttpInterfaceTask {
	String mUName;
	String mVCode;
	String mPwd;
	String mPwdAgain;

	public ForgetLoginPasswordInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.resetpassword";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("account", mUName);
		nContentValues.put("key", mVCode);
		nContentValues.put("login_password", mPwd);
		nContentValues.put("psw_confirm", mPwdAgain);
		return nContentValues;
	}
	
	public void reset(String uname, String vcode, String pwd, String pwdagain){
		mUName = uname;
		mVCode = vcode;
		mPwd = pwd;
		mPwdAgain = pwdagain;
		RunRequest();
	}
}
