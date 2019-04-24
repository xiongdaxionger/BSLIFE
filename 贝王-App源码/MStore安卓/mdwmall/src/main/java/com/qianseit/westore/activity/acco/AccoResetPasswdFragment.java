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

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberResetPasswordInterface;
import com.beiwangfx.R;;

public class AccoResetPasswdFragment extends BaseDoFragment {
	private EditText mOldPasswdText;
	private EditText mNewPasswdText;
	private EditText mRenewPasswdText;
	private Button mSubmitButton;

	MemberResetPasswordInterface mResetPasswordInterface = new MemberResetPasswordInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.savePrefs(mActivity, Run.pk_logined_user_password, mNewPasswdText.getText().toString());
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		}
	};
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mActionBar.setTitle(R.string.acco_reset_password);

		rootView = inflater.inflate(R.layout.fragment_acco_reset_password, null);
		mOldPasswdText = (EditText) findViewById(R.id.acco_reset_password_input_old_tv);
		mNewPasswdText = (EditText) findViewById(R.id.acco_reset_password_input_new_tv);
		mRenewPasswdText = (EditText) findViewById(R.id.acco_reset_password_input_new_again_tv);
		mSubmitButton = (Button) findViewById(R.id.acco_reset_password_submit_btn);
		mSubmitButton.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		if (mSubmitButton == v) {
			AccountResetPasswd();
		} else {
			super.onClick(v);
		}
	}

	// 注册用户
	private void AccountResetPasswd() {
		if (TextUtils.isEmpty(mOldPasswdText.getText())) {
			mOldPasswdText.requestFocus();
			return;
		}

		if (TextUtils.isEmpty(mNewPasswdText.getText())) {
			mNewPasswdText.requestFocus();
			return;
		}

		if (TextUtils.isEmpty(mRenewPasswdText.getText())) {
			mRenewPasswdText.requestFocus();
			return;
		}

		if (!TextUtils.equals(mNewPasswdText.getText(), mRenewPasswdText.getText())) {
			Run.alert(mActivity, R.string.acco_reset_password_confirm_failed);
			return;
		}

		mResetPasswordInterface.reset(mOldPasswdText.getText().toString(), mNewPasswdText.getText().toString(), mRenewPasswdText.getText().toString());
	}
}
