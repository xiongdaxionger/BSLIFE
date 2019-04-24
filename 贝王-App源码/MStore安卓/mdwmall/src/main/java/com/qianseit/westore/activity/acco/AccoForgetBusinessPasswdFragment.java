package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.text.InputType;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.httpinterface.member.MemberBusinessPasswordInterface;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.beiwangfx.R;;

public class AccoForgetBusinessPasswdFragment extends BasePayPasswordFragment {
	final int MSG_COUNTDOWNTIME = 0x01;

	private EditText mPhoneText;
	private EditText mNewPasswdText;
	private EditText mRenewPasswdText;
	private EditText mVCodeImageText;
	private EditText mVCodeSmsText;
	private Button mSubmitButton, mGetVCodeSmsButton;

	///导航栏标题
	public static final String ACTIONBAR_TITLE = "ACTIONBAR_TITLE";

	int mCountDownTime = 120;

	ImageView mVCodeImageView;

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

	MemberBusinessPasswordInterface mBusinessPasswordInterface = new MemberBusinessPasswordInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub

			CommonLoginFragment.showAlertDialog(mActivity, mActionBar.getTitleTV().getText().toString(), "", "OK", null, new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					mActivity.setResult(Activity.RESULT_OK);
					mActivity.finish();
					AgentApplication.getLoginedUser(mActivity).setPayPassword(true);
				}
			}, false, null);
		}
	};

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);

		Intent intent = mActivity.getIntent();
		String title = intent.getStringExtra(ACTIONBAR_TITLE);

		if(TextUtils.isEmpty(title)){
            mActionBar.setTitle(R.string.acco_forget_business_password_title);
        }
        else {
            mActionBar.setTitle(title);
        }
		rootView = inflater.inflate(R.layout.fragment_acco_forget_business_password, null);
		mNewPasswdText = (EditText) findViewById(R.id.password_business);
		mRenewPasswdText = (EditText) findViewById(R.id.password_business_again);
		mVCodeImageText = (EditText) findViewById(R.id.vcode_image);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_image_ib);
		mPhoneText = (EditText) findViewById(R.id.phone);

		mVCodeSmsText = (EditText) findViewById(R.id.vcode_sms);

		mSubmitButton = (Button) findViewById(R.id.submit_btn);
		mGetVCodeSmsButton = (Button) findViewById(R.id.vcode_sms_get);

		mSubmitButton.setOnClickListener(this);
		mGetVCodeSmsButton.setOnClickListener(this);
		mVCodeImageView.setOnClickListener(this);
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

			if(TextUtils.isEmpty(mPhoneText.getText().toString().trim())){
				Run.alert(mActivity, "请输入登录密码");
				mPhoneText.requestFocus();
				return;
			}

			if (mVCodeSmsText.isShown() && TextUtils.isEmpty(mVCodeSmsText.getText().toString().trim())) {
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

			mBusinessPasswordInterface.reset(mPhoneText.getText().toString(), mNewPasswdText.getText().toString(), mRenewPasswdText.getText().toString(), mVCodeSmsText.getText().toString());
			break;
		case R.id.vcode_sms_get:
			if (needVCodeSMSVcode() && mVCodeImageText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入图文验证码");
				mVCodeImageText.requestFocus();
				return;
			}

			if (mVCodeImageText.getText().length() > 0)
				mCodeSMSInterface.getVCode(getPhone(), mVCodeImageText.getText().toString());
			else
				mCodeSMSInterface.getVCode(getPhone());
			break;
		case R.id.vcode_image_ib:
			reloadImageVCode();
			break;

		default:
			super.onClick(v);
			break;
		}
	}

	void reloadImageVCode() {
		displayRectangleImage(mVCodeImageView, getVCodeUrl());
	}

	@Override
	protected void passwordIndexLoaded() {
		// TODO Auto-generated method stub

		if (TextUtils.isEmpty(getPhone())) {
			///没有绑定手机号,使用登录密码验证 隐藏图形验证码和短信验证码
			mPhoneText.setEnabled(true);
			mPhoneText.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD);
			findViewById(R.id.vcode_image_divider).setVisibility(View.GONE);
			findViewById(R.id.vcode_image_tr).setVisibility(View.GONE);
			findViewById(R.id.code_linearLayout).setVisibility(View.GONE);
		}else{
			//
			mPhoneText.setText(getPhone());
			mPhoneText.setEnabled(false);

			if (showVCode()) {
				findViewById(R.id.vcode_image_divider).setVisibility(View.VISIBLE);
				findViewById(R.id.vcode_image_tr).setVisibility(View.VISIBLE);
				reloadImageVCode();
			} else {
				findViewById(R.id.vcode_image_divider).setVisibility(View.GONE);
				findViewById(R.id.vcode_image_tr).setVisibility(View.GONE);
			}
		}
	}

	@Override
	protected String passwordType() {
		// TODO Auto-generated method stub
		return "verifypaypassword";
	}
}
