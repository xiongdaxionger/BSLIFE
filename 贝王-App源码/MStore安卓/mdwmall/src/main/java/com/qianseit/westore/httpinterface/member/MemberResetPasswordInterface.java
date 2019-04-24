package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberResetPasswordInterface extends BaseHttpInterfaceTask {

	String mOldPwd;
	String mNewPwd;
	String mNewPwdAgain;
	public MemberResetPasswordInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.save_security";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("old_passwd", mOldPwd);
		nContentValues.put("passwd", mNewPwd);
		nContentValues.put("passwd_re", mNewPwdAgain);
		return nContentValues;
	}
	
	public void reset(String oldPwd, String newPwd, String newPwdAgain){
		mOldPwd = oldPwd;
		mNewPwd = newPwd;
		mNewPwdAgain = newPwdAgain;
		RunRequest();
	}
}
