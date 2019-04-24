package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;
import android.text.TextUtils;

import com.amap.api.maps.model.Text;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *4.35 设置支付密码
 */
public abstract class MemberBusinessPasswordInterface extends BaseHttpInterfaceTask {
	String mType = BusinessPasswordActionType.SET;
	
	String mLoginPassword;
	String mBusinessPassword;
	String mBusinessPasswordAgain;
	
	String mVerifyCode;
	String mPhone;

	public MemberBusinessPasswordInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.verify_vcode2";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (mType.equals(BusinessPasswordActionType.BIND_MOBILE)) {
			nContentValues.put("vcode", mVerifyCode);
			nContentValues.put("uname", mPhone);
			nContentValues.put("send_type", mType);
			if (!TextUtils.isEmpty(mLoginPassword)) {
				nContentValues.put("login_password", mLoginPassword);
			}
			return nContentValues;
		}
		
		if (!TextUtils.isEmpty(mLoginPassword)) {
			nContentValues.put("password", mLoginPassword);
		}
		
		nContentValues.put("pay_password", mBusinessPassword);
		
		if (!TextUtils.isEmpty(mBusinessPasswordAgain)) {
			nContentValues.put("re_pay_password", mBusinessPasswordAgain);
		}
		
		if (mType.equals(BusinessPasswordActionType.VERIFY)) {
			nContentValues.put("send_type", "mobile");

			if(!TextUtils.isEmpty(mPhone) && !TextUtils.isEmpty(mVerifyCode))
			{
				nContentValues.put("mobile", mPhone);
				nContentValues.put("vcode[mobile]", mVerifyCode);
			}

		}else{
			if (!TextUtils.isEmpty(mVerifyCode)) {
				nContentValues.put("verifycode", mVerifyCode);
			}
		}

		nContentValues.put("verifyType", mType);
		return nContentValues;
	}
	
	/**
	 * @param loginPassword
	 * @param businessPassword
	 * @param businessPasswordAgain
	 */
	public void set(String loginPassword, String businessPassword, String businessPasswordAgain, String vcode){
		mLoginPassword = loginPassword;
		mBusinessPassword = businessPassword;
		mBusinessPasswordAgain = businessPasswordAgain;
		
		mType = BusinessPasswordActionType.SET;
		mVerifyCode = vcode;
		RunRequest();
	}
	
	public void reset(String phone, String businessPassword, String businessPasswordAgain, String vcode){

		mBusinessPassword = businessPassword;
		mBusinessPasswordAgain = businessPasswordAgain;
		mPhone = phone;
		mType = BusinessPasswordActionType.VERIFY;
		mVerifyCode = vcode;

		///没有验证码,使用登录密码
		if(TextUtils.isEmpty(vcode))
		{
			mLoginPassword = phone;
		}else {

			mLoginPassword = "";
		}

		RunRequest();
	}
	
	public void bindMobile(String mobile, String vcode, String password){
		mLoginPassword = password;
		
		mPhone = mobile;
		mType = BusinessPasswordActionType.BIND_MOBILE;
		mVerifyCode = vcode;
		RunRequest();
	}
	
	public class BusinessPasswordActionType{
		/**
		 * 设置支付密码
		 */
		public static final String SET = "setpaypassword";
		/**
		 * 修改支付密码
		 */
		public static final String VERIFY = "verifypaypassword";
		/**
		 * 绑定手机号
		 */
		public static final String BIND_MOBILE = "reset";
	}
}
