package com.qianseit.westore.activity.acco;

import android.view.View;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.passport.ItemDivideView;
import com.qianseit.westore.activity.passport.ItemSettingTextView;
import com.qianseit.westore.base.BaseSettingFragment;
import com.qianseit.westore.util.Util;
//import android.support.v4.app.TaskStackBuilder;

public class AccoPwdManagerFragment extends BaseSettingFragment implements OnCheckedChangeListener {

	ItemSettingTextView mSetBusinessPwdItemSettingTextView;
	ItemSettingTextView mModBusinessPwdItemSettingTextView;
	ItemSettingTextView mForgotBusinessPwdItemSettingTextView;
	ItemSettingTextView mModLoginPwdItemSettingTextView;
//	ItemSettingCheckBox mGesturePwdItemSettingCheckBox;
//	ItemSettingTextView mModGesturePwdItemSettingTextView;

	boolean mStartGesture = false;

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle(R.string.acco_password_management_tip);
	}

	@Override
	protected void initSettingItems(LinearLayout parentView) {
		// TODO Auto-generated method stub
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);

		LayoutParams nLayoutParams = new LayoutParams(LayoutParams.MATCH_PARENT, Util.dip2px(mActivity, 0.5f));
		nLayoutParams.setMargins(0, Util.dip2px(mActivity, 10), 0, 0);
		parentView.addView(new ItemDivideView(mActivity), nLayoutParams);

		parentView.addView(mModLoginPwdItemSettingTextView = new ItemSettingTextView(mActivity,
				getString(R.string.acco_pwd_mod_login_pwd), ""));
		parentView.addView(mSetBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity,
				getString(R.string.acco_pwd_set_business_pwd), "", true, false));
		parentView.addView(mModBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity,
				getString(R.string.acco_pwd_mod_business_pwd), ""));
		parentView.addView(mForgotBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity,
				getString(R.string.acco_pwd_forgot_business_pwd), "", true, false));
//		parentView.addView(mGesturePwdItemSettingCheckBox = new ItemSettingCheckBox(mActivity,
//				getString(R.string.acco_pwd_gesture_pwd), ""));
//		parentView.addView(mModGesturePwdItemSettingTextView = new ItemSettingTextView(mActivity,
//				getString(R.string.acco_pwd_mod_gesture_pwd), "", Run
//						.loadOptionBoolean(mActivity, Run.gesture_pw_isshow, false), false));

		nLayoutParams = new LayoutParams(LayoutParams.MATCH_PARENT, Util.dip2px(mActivity, 0.5f));
		nLayoutParams.setMargins(0, 0, 0, 0);
		parentView.addView(new ItemDivideView(mActivity), nLayoutParams);

		mSetBusinessPwdItemSettingTextView.setOnClickListener(this);
		mModBusinessPwdItemSettingTextView.setOnClickListener(this);
		mForgotBusinessPwdItemSettingTextView.setOnClickListener(this);
		mModLoginPwdItemSettingTextView.setOnClickListener(this);
//		mGesturePwdItemSettingCheckBox.setOnCheckedChangeListener(this);
//		mModGesturePwdItemSettingTextView.setOnClickListener(this);
	}

	@Override
	public void onResume() {
		super.onResume();

		if (mLoginedUser.getPayPassword()) {
			mForgotBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
			mModBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
			mSetBusinessPwdItemSettingTextView.setVisibility(View.GONE);
		} else {
			mForgotBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mModBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mSetBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
		}

		if (!mStartGesture) {
			mStartGesture = true;
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v == mSetBusinessPwdItemSettingTextView) {
			startActivity(AgentActivity.intentForFragment(mActivity,
					AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW));
		} else if (v == mModBusinessPwdItemSettingTextView) {
			startActivity(AgentActivity.intentForFragment(mActivity,
					AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_MODIFY_BUSINISS_PW));
		} else if (v == mForgotBusinessPwdItemSettingTextView) {
			startActivity(AgentActivity.intentForFragment(mActivity,
					AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_BUSINESS_PW));
		} else if (v == mModLoginPwdItemSettingTextView) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_RESET_PASSWORD));
		} 
//		else if (v == mModGesturePwdItemSettingTextView) {
//			Intent nIntent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_GESTURE_PASSWORD);
//			nIntent.putExtra(GesturePasswordFragment.MODIFY_GESTURE_PASSWORD, true);
//			nIntent.putExtra(Run.EXTRA_VALUE, false);
//			nIntent.putExtra(Run.EXTRA_DATA, true);
//			nIntent.putExtra(Run.EXTRA_CLASS_ID, false);
//			startActivity(nIntent);
//		}
		else {
			super.onClick(v);
		}
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
		if (!mStartGesture) {
			return;
		}

//		boolean nShowGesture = Run.loadOptionBoolean(mActivity, Run.gesture_pw_isshow, false);
//		if (isChecked && !nShowGesture) {
//			CommonLoginFragment.showVerfiyPasswordDialog(mActivity, new PasswordVerfiyHandler() {
//				@Override
//				public void result_success(String json_str) {
//					// TODO 自动生成的方法存根
//					Intent nIntent = AgentActivity.intentForFragment(mActivity,
//							AgentActivity.FRAGMENT_COMM_GESTURE_PASSWORD);
//					nIntent.putExtra(Run.EXTRA_VALUE, false);
//					nIntent.putExtra(Run.EXTRA_DATA, true);
//					nIntent.putExtra(Run.EXTRA_CLASS_ID, false);
//					startActivity(nIntent);
//				}
//
//				@Override
//				public void result_fail(String json_str) {
//					// TODO 自动生成的方法存根
////					mGesturePwdItemSettingCheckBox.setCheckState(false);
////					mGesturePwdItemSettingCheckBox.showDivide(false);
////					mModGesturePwdItemSettingTextView.setVisibility(View.GONE);
//				}
//			});
//		} else if (!isChecked && nShowGesture) {
//			Intent nIntent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_GESTURE_PASSWORD);
//			nIntent.putExtra(Run.EXTRA_VALUE, true);
//			nIntent.putExtra(Run.EXTRA_DATA, true);
//			nIntent.putExtra(Run.EXTRA_CLASS_ID, false);
//			startActivity(nIntent);
//		}

//		mModGesturePwdItemSettingTextView.setVisibility(isChecked ? View.VISIBLE : View.GONE);
	}
}
