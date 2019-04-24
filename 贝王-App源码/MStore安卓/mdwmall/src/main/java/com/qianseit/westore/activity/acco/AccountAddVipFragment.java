package com.qianseit.westore.activity.acco;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.partner.PartnerListFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.httpinterface.partner.PartnerAddPageInfoInterface;


import org.json.JSONObject;

public class AccountAddVipFragment extends BaseDoFragment {

	private EditText phone, mVerifyCodeText, password, nickName, imageCode;
	private Button confirmButton, sendCode;
	private LoginedUser mLoginedUser;
	private String mUserId;
	private static SmsReceiver mSmsReceiver;

	///图形验证码
	private String mImageCodeURL;
	private ImageView mImageCodeView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		mActionBar.setTitle(R.string.add_vip);
		mActionBar.setShowHomeView(true);
		mActionBar.setRightTitleButtonText(R.string.add_member);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mUserId = mLoginedUser.getMemberId();
		mSmsReceiver = new SmsReceiver();
		IntentFilter filter = new IntentFilter(Run.ACTION_SMS_RECEIVED);
		filter.addAction(Run.ACTION_SMS_DELIVER);
		mActivity.registerReceiver(mSmsReceiver, filter);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.fragment_add_vip, null);
		phone = (EditText) findViewById(R.id.phone);
		// 验证码
		mVerifyCodeText = (EditText) findViewById(R.id.code_number);
		password = (EditText) findViewById(R.id.password);
		// 添加确认
		confirmButton = (Button) findViewById(R.id.confirm);
		// 发送验证码
		sendCode = (Button) findViewById(R.id.send_code);
		nickName = (EditText) findViewById(R.id.nick_name);
		confirmButton.setOnClickListener(this);
		sendCode.setOnClickListener(this);

		mImageCodeView = (ImageView)findViewById(R.id.vcode_image_ib);
		imageCode = (EditText)findViewById(R.id.image_code_edit_text);
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		mActivity.unregisterReceiver(mSmsReceiver);
	}

	@Override
	public void onResume() {
		super.onResume();

		loadPageInfo();
	}

	///加载页面信息，获取是否需要图形验证码
	private void loadPageInfo(){

		showLoadingDialog();
		new PartnerAddPageInfoInterface(){
			@Override
			public void getImageCodeURL(String url) {
				hideLoadingDialog();

				mImageCodeURL = url;
				View view = findViewById(R.id.image_code_layout);
				view.setVisibility(TextUtils.isEmpty(url) ? View.GONE : View.VISIBLE);

				view = findViewById(R.id.image_code_line);
				view.setVisibility(TextUtils.isEmpty(url) ? View.GONE : View.VISIBLE);
				reloadVcodeImage();
			}
		}.RunRequest();
	}

	///刷新图形验证码
	private void reloadVcodeImage() {
		if(!TextUtils.isEmpty(mImageCodeURL)) {
			String vcodeUrl = Run.buildString(mImageCodeURL, "?", System.currentTimeMillis());
			displayRectangleImage(mImageCodeView, vcodeUrl);
		}
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		if (v == confirmButton) {
			AccountLogin();
		} else if (v == sendCode) {
			String mobile = phone.getText().toString();
			if (TextUtils.isEmpty(mobile) || !Run.isChinesePhoneNumber(mobile)) {
				Run.alert(mActivity, R.string.account_regist_phone_number_invalid);
				phone.requestFocus();
			} else if(!TextUtils.isEmpty(mImageCodeURL) && TextUtils.isEmpty(imageCode.getText().toString())){

				///
				Run.alert(mActivity, "请输入图形验证码");
				imageCode.requestFocus();
			} else{
				Run.excuteJsonTask(new JsonTask(), new GetVerifyCodeTask());
			}

		} else {
			super.onClick(v);
		}
	}

	private class GetVerifyCodeTask implements JsonTaskHandler {
		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "b2c.passport.send_vcode_sms");
			bean.addParams("uname", phone.getText().toString());
			bean.addParams("type", "invite");
			String code = imageCode.getText().toString();
			if(code != null){
				bean.addParams("sms_vcode", code);
			}

			return bean;
		}

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog();
			;
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					phone.setEnabled(false);
					sendCode.setBackgroundColor(Color.parseColor("#eeeeee"));
					// 倒计时60秒
					Run.countdown_time = System.currentTimeMillis();
					enableVreifyCodeButton();
				}else {
					reloadVcodeImage();
				}
			} catch (Exception e) {
				Run.alert(mActivity, "验证码下发失败！");
			}
		}
	}

	// 设置验证码按钮状态，倒计时60秒
	private void enableVreifyCodeButton() {
		long remainTime = System.currentTimeMillis() - Run.countdown_time;
		remainTime = 60 - remainTime / 1000;

		if (remainTime <= 0) {
			sendCode.setEnabled(true);
			sendCode.setBackgroundResource(R.drawable.but_click);
			sendCode.setText(R.string.account_regist_get_verify_code);
			return;
		}

		sendCode.setEnabled(false);
		sendCode.setText(mActivity.getString(R.string.account_regist_verify_code_countdown, remainTime));
		mHandler.postDelayed(new Runnable() {
			@Override
			public void run() {
				enableVreifyCodeButton();
			}
		}, 1000);
	}

	// 注册会员
	private void AccountLogin() {

		String phoneNumber = phone.getText().toString();
		String name = nickName.getText().toString();
		String psd = password.getText().toString();
		String verifyCode = mVerifyCodeText.getText().toString();
		if (TextUtils.isEmpty(phoneNumber) || !Run.isChinesePhoneNumber(phoneNumber)) {
			Run.alert(mActivity, R.string.account_regist_phone_number_invalid);
			phone.requestFocus();
		} else if (TextUtils.isEmpty(psd) || psd.length() < 6 || psd.length() > 20) {
			Run.alert(mActivity, R.string.account_regist_password_error);
			password.requestFocus();
		} else if (mVerifyCodeText.isShown() && TextUtils.isEmpty(verifyCode)) {
			mVerifyCodeText.requestFocus();
		} else if (TextUtils.isEmpty(name) || name.length() < 1 || name.length() > 10) {
			Run.alert(mActivity, R.string.account_regist_name_error);
			nickName.requestFocus();
		} else {
			Run.hideSoftInputMethod(mActivity, phone);
			Run.hideSoftInputMethod(mActivity, password);
			Run.hideSoftInputMethod(mActivity, nickName);
			Run.hideSoftInputMethod(mActivity, mVerifyCodeText);
			Run.excuteJsonTask(new JsonTask(), new RegisterMemberTask());
		}
	}

	private class RegisterMemberTask implements JsonTaskHandler {
		@Override
		public JsonRequestBean task_request() {
			boolean isConnect = Run.checkNetwork(mActivity);
			if (!isConnect) {
				mActivity.runOnUiThread(new Runnable() {

					@Override
					public void run() {
						Run.alert(mActivity, "网络不可用，请稍后再试");
					}
				});
				return new JsonRequestBean(Run.API_URL, "");
			}
			JsonRequestBean rb = new JsonRequestBean(Run.API_URL, "distribution.fxmem.create");

			rb.addParams("pam_account[login_name]", phone.getText().toString());
			rb.addParams("pam_account[login_password]", password.getText().toString());
			rb.addParams("contact[name]", nickName.getText().toString());
			rb.addParams("pam_account[psw_confirm]", password.getText().toString());
			rb.addParams("license", "1");
			rb.addParams("source", "android");
			rb.addParams("member_id", mUserId);
			if (mVerifyCodeText.isShown())
				rb.addParams("vcode", mVerifyCodeText.getText().toString());
			return rb;
		}

		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {

					Run.alert(mActivity, "添加会员成功");

					///发送添加会员成功的广播
					IntentFilter filter = new IntentFilter(PartnerListFragment.PARTNER_ADD_ACTION);
					PartnerListFragment.PartnerAddReceiver receiver = new PartnerListFragment.PartnerAddReceiver();
					LocalBroadcastManager manager = LocalBroadcastManager.getInstance(mActivity);
					manager.registerReceiver(receiver, filter);
					Intent intent = new Intent();
					intent.setAction(PartnerListFragment.PARTNER_ADD_ACTION);
					manager.sendBroadcast(intent);
					mActivity.finish();
					manager.unregisterReceiver(receiver);
				}else {
					reloadVcodeImage();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public class SmsReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals(Run.ACTION_SMS_RECEIVED) || intent.getAction().equals(Run.ACTION_SMS_DELIVER)) {
				String msgText = Run.handleSmsReceived(intent);
				if (msgText.contains("验证码") && msgText.length() > 13) {
					mVerifyCodeText.setText(msgText.subSequence(7, 13));
				}
			}
		}
	}

}
