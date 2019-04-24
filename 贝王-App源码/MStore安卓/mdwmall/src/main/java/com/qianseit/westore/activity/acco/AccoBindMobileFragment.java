package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.httpinterface.member.MemberBusinessPasswordInterface;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.beiwangfx.R;;

public class AccoBindMobileFragment extends BasePayPasswordFragment {
	final int MSG_COUNTDOWNTIME = 0x01;
	private EditText mPasswdText;
	private EditText mMobileText;
	private EditText mVCodeImageText;
	private EditText mVCodeSmsText;
	private Button mSubmitButton, mGetVCodeSmsButton;

	int mCountDownTime = 120;

	ImageView mVCodeImageView;
	
	Dialog mDialog;

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

	MemberBusinessPasswordInterface mBindMobileInterface = new MemberBusinessPasswordInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub

			CommonLoginFragment.showAlertDialog(mActivity, "绑定手机号成功", "", "OK", null, new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					Intent nIntent = new Intent();
					nIntent.putExtra(Run.EXTRA_DATA, mMobileText.getText().toString().trim());
					nIntent.putExtra(Run.EXTRA_VALUE, mPasswdText.getText().toString());
					LoginedUser.getInstance().mobile = mMobileText.getText().toString().trim();
					mActivity.setResult(Activity.RESULT_OK, nIntent);
					mActivity.finish();
				}
			}, false, null);
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}
	
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mActionBar.setTitle("绑定手机号");
		rootView = inflater.inflate(R.layout.fragment_acco_bind_mobile, null);
		mMobileText = (EditText) findViewById(R.id.phone);
		mPasswdText = (EditText) findViewById(R.id.password);
		mVCodeImageText = (EditText) findViewById(R.id.vcode_image);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_image_ib);

		mVCodeSmsText = (EditText) findViewById(R.id.vcode_sms);

		mSubmitButton = (Button) findViewById(R.id.submit_btn);
		mGetVCodeSmsButton = (Button) findViewById(R.id.vcode_sms_get);

		mSubmitButton.setOnClickListener(this);
		mGetVCodeSmsButton.setOnClickListener(this);
		mVCodeImageView.setOnClickListener(this);

		findViewById(R.id.password_divider).setVisibility(View.GONE);
		findViewById(R.id.password_rl).setVisibility(View.GONE);
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
	protected void back() {
		// TODO Auto-generated method stub
		mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定放弃绑定手机号？", "", "取消", "确定", null, new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mDialog.dismiss();
				mActivity.setResult(Activity.RESULT_CANCELED);
				mActivity.finish();
			}
		});
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
			if (TextUtils.isEmpty(mMobileText.getText().toString().trim())) {
				Run.alert(mActivity, "请输入手机号");
				mMobileText.requestFocus();
				return;
			}

			if (TextUtils.isEmpty(mVCodeSmsText.getText().toString().trim())) {
				Run.alert(mActivity, "请输入短信验证码");
				mVCodeSmsText.requestFocus();
				return;
			}

			mBindMobileInterface.bindMobile(mMobileText.getText().toString(), mVCodeSmsText.getText().toString(), "");
			break;
		case R.id.vcode_sms_get:
			String nPhone = mMobileText.getText().toString().trim();
			if (TextUtils.isEmpty(nPhone)) {
				Run.alert(mActivity, "请输入手机号");
				mMobileText.requestFocus();
				return;
			}
			
			if (!Run.isChinesePhoneNumber(nPhone)) {
				Run.alert(mActivity, "请输入正确的手机号");
				mMobileText.requestFocus();
				mMobileText.setSelection(mMobileText.getText().length());
				return;
			}

			if (needVCodeSMSVcode() && mVCodeImageText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入图文验证码");
				mVCodeImageText.requestFocus();
				return;
			}

			if (mVCodeImageText.getText().length() > 0)
				mCodeSMSInterface.getVCode(nPhone, mVCodeImageText.getText().toString(), SendVCodeSMSInterface.TYPE_RESET);
			else
				mCodeSMSInterface.getVCode(nPhone, "", SendVCodeSMSInterface.TYPE_RESET);
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
		if (showVCode()) {
			findViewById(R.id.vcode_image_divider).setVisibility(View.VISIBLE);
			findViewById(R.id.vcode_image_tr).setVisibility(View.VISIBLE);
			reloadImageVCode();
		} else {
			findViewById(R.id.vcode_image_divider).setVisibility(View.GONE);
			findViewById(R.id.vcode_image_tr).setVisibility(View.GONE);
		}
	}

	@Override
	protected String passwordType() {
		// TODO Auto-generated method stub
		return "verifymobile";
	}
}
