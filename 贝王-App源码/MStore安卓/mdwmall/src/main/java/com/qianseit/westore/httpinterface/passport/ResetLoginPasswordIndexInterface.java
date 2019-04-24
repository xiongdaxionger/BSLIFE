package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ResetLoginPasswordIndexInterface extends BaseHttpInterfaceTask {
	String mUName;
	public ResetLoginPasswordIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.sendPSW";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("username", mUName);
		return nContentValues;
	}
	
	public void check(String uname){
		mUName = uname;
		RunRequest();
	}
}
