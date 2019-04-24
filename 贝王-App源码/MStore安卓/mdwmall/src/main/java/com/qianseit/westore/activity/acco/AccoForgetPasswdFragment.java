package com.qianseit.westore.activity.acco;

import org.json.JSONObject;
import org.w3c.dom.Text;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.passport.ForgetLoginPasswordInterface;
import com.qianseit.westore.httpinterface.passport.ResetLoginPasswordIndexInterface;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.beiwangfx.R;;

public class AccoForgetPasswdFragment extends BaseDoFragment {
	final int MSG_COUNTDOWNTIME = 0x01;

	///手机号码
	private EditText mPhoneText;
	private EditText mNewPasswdText;
	private EditText mRenewPasswdText;
	private EditText mVCodeImageText;
	private EditText mVCodeSmsText;
	private Button mSubmitButton, mGetVCodeSmsButton;


	///客服电话
	private TextView mServicePhoneTextView;

	///弹窗
	Dialog mDialog;

	int mCountDownTime = 120;

	ImageView mVCodeImageView;

	private JSONObject mPasswordIndexJsonObject;
	ResetLoginPasswordIndexInterface mPasswordIndexInterface = new ResetLoginPasswordIndexInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mPasswordIndexJsonObject = responseJson;
			passwordIndexLoaded();
		}
	};

	SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mCountDownTime = 120;
			mGetVCodeSmsButton.setText(String.valueOf(mCountDownTime));
			mGetVCodeSmsButton.setBackgroundResource(R.drawable.bg_verify_code);
			mGetVCodeSmsButton.setTextColor(Color.parseColor("#ed6655"));
			mHandler.sendEmptyMessageDelayed(MSG_COUNTDOWNTIME, 1000);
		}

		@Override
		public void FailRequest() {
			mGetVCodeSmsButton.setEnabled(true);
			reloadImageVCode();
		}
	};

	ForgetLoginPasswordInterface mForgetLoginPasswordInterface = new ForgetLoginPasswordInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub

			CommonLoginFragment.showAlertDialog(mActivity, "重置密码成功", "", "OK", null, new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					mActivity.setResult(Activity.RESULT_OK);
					mActivity.finish();
				}
			}, false, null);
		}
	};

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mActionBar.setTitle(R.string.acco_forget_password_title);
		rootView = inflater.inflate(R.layout.fragment_acco_forget_login_password, null);
		mNewPasswdText = (EditText) findViewById(R.id.password_business);
		mRenewPasswdText = (EditText) findViewById(R.id.password_business_again);
		mVCodeImageText = (EditText) findViewById(R.id.vcode_image);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_image_ib);
		mPhoneText = (EditText) findViewById(R.id.phone);

		mVCodeSmsText = (EditText) findViewById(R.id.vcode_sms);

		mSubmitButton = (Button) findViewById(R.id.submit_btn);
		mGetVCodeSmsButton = (Button) findViewById(R.id.vcode_sms_get);
		mServicePhoneTextView = (TextView) findViewById(R.id.service_phone_textView);

		mSubmitButton.setOnClickListener(this);
		mGetVCodeSmsButton.setOnClickListener(this);
		mVCodeImageView.setOnClickListener(this);
		mServicePhoneTextView.setOnClickListener(this);

		mPasswordIndexInterface.check(Run.loadOptionString(mActivity, Run.pk_logined_username, Run.EMPTY_STR));
	}

	/**
	 * @return 发送短信验证码需要图形验证码
	 */
	protected boolean needVCodeSMSVcode() {
		if (mPasswordIndexJsonObject == null) {
			return false;
		}

		return !TextUtils.isEmpty(mPasswordIndexJsonObject.optString("code_url"));
	}

	protected String getVCodeUrl() {
		if (mPasswordIndexJsonObject == null) {
			return "";
		}

		return mPasswordIndexJsonObject.optString("code_url") + "?" + System.currentTimeMillis();
	}

	protected String getPhone() {
//		if (mPasswordIndexJsonObject == null) {
//			return "";
//		}
//		JSONObject nJsonObject = mPasswordIndexJsonObject.optJSONObject("data");
//		if (nJsonObject == null) {
//			return "";
//		}

		//return nJsonObject.optString("mobile");

		return mPhoneText.getText().toString();
	}

	@Override
	public void ui(int what, Message msg) {
		// TODO Auto-generated method stub
		if (what == MSG_COUNTDOWNTIME) {
			mGetVCodeSmsButton.setText("" + mCountDownTime);
			mCountDownTime--;
			if (mCountDownTime < 0) {
				mGetVCodeSmsButton.setBackgroundResource(R.drawable.app_button_selector);
				mGetVCodeSmsButton.setTextColor(Color.parseColor("#ffffff"));
				mGetVCodeSmsButton.setText("获取验证码");
				mGetVCodeSmsButton.setEnabled(true);
			} else {
				mHandler.sendEmptyMessageDelayed(MSG_COUNTDOWNTIME, 1000);
			}
		} else {
			super.ui(what, msg);
		}
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		mHandler.removeMessages(MSG_COUNTDOWNTIME);
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.submit_btn:
			if (TextUtils.isEmpty(mVCodeSmsText.getText().toString().trim())) {
				Run.alert(mActivity, "请输入短信验证码");
				mVCodeSmsText.requestFocus();
				return;
			}

			if (TextUtils.isEmpty(mNewPasswdText.getText().toString().trim())) {
				Run.alert(mActivity, "请输入新密码");
				mNewPasswdText.requestFocus();
				return;
			}

			if (mNewPasswdText.getText().length() != 6) {
				Run.alert(mActivity, "密码长度必须等于6位");
				mNewPasswdText.requestFocus();
				return;
			}

			if (TextUtils.isEmpty(mRenewPasswdText.getText().toString().trim())) {
				Run.alert(mActivity, "请输入确认密码");
				mRenewPasswdText.requestFocus();
				return;
			}

			if (!TextUtils.equals(mNewPasswdText.getText(), mRenewPasswdText.getText())) {
				Run.alert(mActivity, R.string.acco_reset_password_confirm_failed);
				return;
			}

			mForgetLoginPasswordInterface.reset(getPhone(), mVCodeSmsText.getText().toString(), mNewPasswdText.getText().toString(), mRenewPasswdText.getText().toString());
			break;
		case R.id.vcode_sms_get:
			if (needVCodeSMSVcode() && mVCodeImageText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入图文验证码");
				mVCodeImageText.requestFocus();
				return;
			}

			mCodeSMSInterface.getVCode(getPhone(), mVCodeImageText.getText().toString(), "forgot");
			break;
		case R.id.vcode_image_ib:
			reloadImageVCode();
			break;
			case R.id.service_phone_textView :{

				final String nPhone = mPasswordIndexJsonObject.optString("tel");
				///拨打客服电话
				mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("%s", nPhone), "取消", "拨打", null, new View.OnClickListener() {

					@Override
					public void onClick(View v) {

						String phone = nPhone;
						if (phone.contains("-")) {
							phone = phone.replaceAll("-", "");
						}
						Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + phone));
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						startActivity(intent);
						mDialog.hide();
					}
				}, false, null);
			}
		default:
			break;
		}
		if (mSubmitButton == v) {
			AccountResetPasswd();
		} else {
			super.onClick(v);
		}
	}

	void reloadImageVCode() {
		displayRectangleImage(mVCodeImageView, getVCodeUrl());
	}

	private void AccountResetPasswd() {

		if (TextUtils.isEmpty(mNewPasswdText.getText().toString().trim())) {
			Run.alert(mActivity, "请输入新密码");
			mNewPasswdText.requestFocus();
			return;
		}
		
		if (TextUtils.isEmpty(mRenewPasswdText.getText().toString().trim())) {
			Run.alert(mActivity, "请输入确认密码");
			mRenewPasswdText.requestFocus();
			return;
		}

		if (!TextUtils.equals(mNewPasswdText.getText(), mRenewPasswdText.getText())) {
			Run.alert(mActivity, R.string.acco_reset_password_confirm_failed);
			return;
		}
	}

	protected void passwordIndexLoaded() {
		// TODO Auto-generated method stub
		if (needVCodeSMSVcode()) {
			findViewById(R.id.vcode_image_divider).setVisibility(View.VISIBLE);
			findViewById(R.id.vcode_image_tr).setVisibility(View.VISIBLE);
			reloadImageVCode();
		} else {
			findViewById(R.id.vcode_image_divider).setVisibility(View.GONE);
			findViewById(R.id.vcode_image_tr).setVisibility(View.GONE);
		}

		///客服电话
		String servicePhone = mPasswordIndexJsonObject.optString("tel");
		if(!TextUtils.isEmpty(servicePhone)){
			mServicePhoneTextView.setText("如无绑定手机号码，请联系商城客服处理。客服热线：" + servicePhone);
		}
//
//		((TextView) findViewById(R.id.phone)).setText(getPhone());
//
//		if (mPasswordIndexJsonObject == null || !mPasswordIndexJsonObject.optBoolean("send_status")) {
//			String nMessage = mPasswordIndexJsonObject == null ? "由于您并未验证手机或者邮箱，无法自助找回密码，请联系网站客服！" : mPasswordIndexJsonObject.optString("message");
//			if (TextUtils.isEmpty(nMessage)) {
//				nMessage = "由于您并未验证手机或者邮箱，无法自助找回密码，请联系网站客服！";
//			}
//			CommonLoginFragment.showAlertDialog(mActivity, nMessage, "", "OK", null, null, false, null);
//			mSubmitButton.setEnabled(false);
//		}else{
//			mSubmitButton.setEnabled(true);
//		}
	}
}
