package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 *6.5 验证支付密码
 */
public abstract class PayVerifyPayPasswordInterface extends BaseHttpInterfaceTask {
	String mPassword;
	public PayVerifyPayPasswordInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
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
		nContentValues.put("pay_password", mPassword);
		return nContentValues;
	}
	
	public void verifyPassword(String password){
		mPassword = password == null ? "" :password;
		RunRequest();
	}
}
