package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 5.4 发送短信验证码
 */
public abstract class SendVCodeSMSInterface extends BaseHttpInterfaceTask {
	public static final String TYPE_SIGNUP = "signup";
	public static final String TYPE_FORGOT = "forgot";
	public static final String TYPE_ACTIVATION = "activation";
	public static final String TYPE_RESET = "reset";
	public static final String TYPE_THIRDLOGIN = "trustlogin";
	
	String mUName;
	String mType;
	String mImageVCode;

	public SendVCodeSMSInterface(QianseitActivityInterface activityInterface, String uname, String type) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		setData(uname, type);
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.send_vcode_sms";
	}
	
	public void getVCode(String uname){
		setData(uname, TYPE_ACTIVATION);
		RunRequest();
	}

	public void getVCode(String uname, String imageVCode){
		setData(uname, TYPE_ACTIVATION, imageVCode);
		RunRequest();
	}

	/**
	 * @param uname
	 * @param imageVCode
	 * @param type:signup|forgot|activation
	 */
	public void getVCode(String uname, String imageVCode, String type){
		setData(uname, type, imageVCode);
		RunRequest();
	}
	
	/**
	 * @param uname
	 * @param type:signup|forgot|activation
	 */
	public void setData(String uname, String type){
		setData(uname, type, "");
	}

	/**
	 * @param uname
	 * @param type:signup|forgot|activation
	 */
	public void setData(String uname, String type, String imageVCode){
		mUName = uname;
		mType = type;
		mImageVCode = imageVCode;
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("uname", mUName);
		nContentValues.put("type", mType);
		if (!TextUtils.isEmpty(mImageVCode)) {
			nContentValues.put("sms_vcode", mImageVCode);
		}
		return nContentValues;
	}
}
