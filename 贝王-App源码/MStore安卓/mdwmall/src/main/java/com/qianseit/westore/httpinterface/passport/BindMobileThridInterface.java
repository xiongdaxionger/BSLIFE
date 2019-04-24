package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.bean.ThridLoginTrustBean;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit 5.19 设置并绑定的帐号（第三方登录）
 * 5.18 绑定已有帐号（第三方登录）
 */
public abstract class BindMobileThridInterface extends BaseHttpInterfaceTask {
	String mLoginPassword;
	String mVerifyCode;
	String mPhone;
	
	ThridLoginTrustBean mLoginTrustBean;
	
	boolean isNew = true;

	public BindMobileThridInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		if (isNew) {
			return "trustlogin.trustlogin.set_login";
		}else
			return "trustlogin.trustlogin.check_login";
		
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("vcode", mVerifyCode);
		if (isNew) {
			nContentValues.put("pam_account[login_name]", mPhone);
			nContentValues.put("pam_account[login_password]", mLoginPassword);
			nContentValues.put("pam_account[psw_confirm]", mLoginPassword);
		}else{
			nContentValues.put("uname", mPhone);
			nContentValues.put("password", mLoginPassword);
		}
		if(!TextUtils.isEmpty(mLoginTrustBean.getUnionid())){
			nContentValues.put("data[unionid]", mLoginTrustBean.getUnionid());
		}
		nContentValues.put("data[trust_source]", "trustlogin_plugin_" + mLoginTrustBean.getSource());
		nContentValues.put("data[openid]", mLoginTrustBean.getOpenId());
		nContentValues.put("data[nickname]", mLoginTrustBean.getNickName());
		nContentValues.put("data[avatar]", mLoginTrustBean.getAvatar());
		nContentValues.put("data[gender]", mLoginTrustBean.getGender());
		return nContentValues;
	}

	/**
	 * @param mobile 手机
	 * @param vcode 短信验证码
	 * @param password 登录密码
	 * @param loginTrustBean
	 */
	public void bindMobile(String mobile, String vcode, String password, ThridLoginTrustBean loginTrustBean, boolean isNew) {
		mLoginPassword = password;
		mPhone = mobile;
		mVerifyCode = vcode;
		mLoginTrustBean = loginTrustBean;
		this.isNew = isNew;
		RunRequest();
	}
}
