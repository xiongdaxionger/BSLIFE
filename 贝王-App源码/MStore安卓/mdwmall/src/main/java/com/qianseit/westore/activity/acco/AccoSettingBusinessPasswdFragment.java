package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberBusinessPasswordInterface;
import com.beiwangfx.R;;

public class AccoSettingBusinessPasswdFragment extends BaseDoFragment {

	private EditText mLoginPasswdText;
	private EditText mNewPasswdText;
	private EditText mRenewPasswdText;
	private Button mSubmitButton;

	EditText mImageVCodeEditText;
	ImageView mImageVCodeImageView;

	String mImageVCodeUrl = "";
	boolean mNeedVerify = false;

	MemberBusinessPasswordInterface mBusinessPasswordInterface = new MemberBusinessPasswordInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub

			CommonLoginFragment.showAlertDialog(mActivity, "设置密码成功", "", "OK", null, new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					mActivity.setResult(Activity.RESULT_OK);
					mActivity.finish();
					AgentApplication.getLoginedUser(mActivity).setPayPassword(true);
				}
			}, false, null);
		}

		@Override
		public void FailRequest() {
			if (mErrorJsonObject == null) {
				return;
			}

			JSONObject nDataJsonObject = mErrorJsonObject.optJSONObject("data");
			if (nDataJsonObject == null) {
				return;
			}

			mNeedVerify = nDataJsonObject.optBoolean("needVerify");
			mImageVCodeUrl = nDataJsonObject.optString("code_url");
			if (mNeedVerify) {
				findViewById(R.id.vcode_image_divider).setVisibility(View.VISIBLE);
				findViewById(R.id.vcode_image_tr).setVisibility(View.VISIBLE);
				reloadImageVCode();
			}
		}
	};

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mActionBar.setTitle(R.string.acco_setting_business_password_title);

		rootView = inflater.inflate(R.layout.fragment_acco_setting_business_password, null);
		mLoginPasswdText = (EditText) findViewById(R.id.login_password);
		mRenewPasswdText = (EditText) findViewById(R.id.business_password);
		mNewPasswdText = (EditText) findViewById(R.id.business_password_again);

		mImageVCodeEditText = (EditText) findViewById(R.id.vcode_image);
		mImageVCodeImageView = (ImageView) findViewById(R.id.vcode_image_ib);

		mImageVCodeImageView.setOnClickListener(this);
		mSubmitButton = (Button) findViewById(R.id.submit);
		mSubmitButton.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.submit:
			accountSettingBusinessPasswd();
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
		displayRectangleImage(mImageVCodeImageView, mImageVCodeUrl + "?" + System.currentTimeMillis());
		mImageVCodeEditText.requestFocus();
	}

	// 注册用户
	private void accountSettingBusinessPasswd() {
		if (TextUtils.isEmpty(mLoginPasswdText.getText())) {
			mLoginPasswdText.requestFocus();
			CommonLoginFragment.showAlertDialog(mActivity, "请输入登陆密码", "", "OK", null, null, false, null);
			return;
		}

		if (mNeedVerify && TextUtils.isEmpty(mImageVCodeEditText.getText())) {
			CommonLoginFragment.showAlertDialog(mActivity, "请输入图文验证码", "", "OK", null, null, false, null);
			mImageVCodeEditText.requestFocus();
			return;
		}

		if (TextUtils.isEmpty(mNewPasswdText.getText())) {
			CommonLoginFragment.showAlertDialog(mActivity, "请输入支付密码", "", "OK", null, null, false, null);
			mNewPasswdText.requestFocus();
			return;
		}

		if (TextUtils.isEmpty(mRenewPasswdText.getText())) {
			CommonLoginFragment.showAlertDialog(mActivity, "请再次确认支付密码", "", "OK", null, null, false, null);
			mRenewPasswdText.requestFocus();
			return;
		}

		if (!TextUtils.equals(mNewPasswdText.getText(), mRenewPasswdText.getText())) {
			Run.alert(mActivity, R.string.acco_reset_password_confirm_failed);
			return;
		}

		mBusinessPasswordInterface.set(mLoginPasswdText.getText().toString(), mNewPasswdText.getText().toString(), mRenewPasswdText.getText().toString(), mNeedVerify ? mImageVCodeEditText.getText()
				.toString() : "");
	}
}
