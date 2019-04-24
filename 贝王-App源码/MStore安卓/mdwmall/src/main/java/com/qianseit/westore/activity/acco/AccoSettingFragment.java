package com.qianseit.westore.activity.acco;

import android.app.Dialog;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Color;
import android.text.format.Formatter;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.LinearLayout;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonHomeFragment;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.passport.ItemSettingTextView;
import com.qianseit.westore.base.BaseSettingFragment;
import com.qianseit.westore.httpinterface.info.UpdateAppInterface;
import com.qianseit.westore.httpinterface.passport.LogoutInterface;
import com.qianseit.westore.activity.acco.AccoForgetBusinessPasswdFragment;

import org.json.JSONObject;

import java.io.File;

public class AccoSettingFragment extends BaseSettingFragment implements OnCheckedChangeListener {
	public static final String WURAOMODE = "WURAU_MODE";

	ItemSettingTextView mHelpCenterView;
	ItemSettingTextView mAboutView;
	ItemSettingTextView mClearMemroyView;
	ItemSettingTextView mVersionView;
	ItemSettingTextView mModLoginPwdItemSettingTextView;

	ItemSettingTextView mSetBusinessPwdItemSettingTextView;
	ItemSettingTextView mModBusinessPwdItemSettingTextView;
	ItemSettingTextView mForgotBusinessPwdItemSettingTextView;

	private Dialog mLogoutDialog;
	private Dialog mClearMemoryDialog;

	private String mCacheFileSize = Run.EMPTY_STR;
	long mCacheSize = 0;

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle(R.string.acco_setting_title);
	}

	@Override
	protected void initSettingItems(LinearLayout parentView) {
		// TODO Auto-generated method stub
		parentView.addView(mModLoginPwdItemSettingTextView = new ItemSettingTextView(mActivity, getString(R.string.acco_pwd_mod_login_pwd), ""));

		parentView.addView(mSetBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity, getString(R.string.acco_pwd_set_business_pwd), "", true, true));
		parentView.addView(mModBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity, getString(R.string.acco_pwd_mod_business_pwd), ""));
		parentView.addView(mForgotBusinessPwdItemSettingTextView = new ItemSettingTextView(mActivity, getString(R.string.acco_pwd_forgot_business_pwd), "", true, true));

		parentView.addView(mHelpCenterView = new ItemSettingTextView(mActivity, "帮助中心", ""));
		parentView.addView(mAboutView = new ItemSettingTextView(mActivity, "关于我们", ""));
		parentView.addView(mVersionView = new ItemSettingTextView(mActivity, "版本更新", "", Color.RED));
		parentView.addView(mClearMemroyView = new ItemSettingTextView(mActivity, "清除缓存", "", Color.RED));

		setOnBaseBtnClick(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				logout();
			}
		});

		mAboutView.setOnClickListener(this);
		mHelpCenterView.setOnClickListener(this);
		mClearMemroyView.setOnClickListener(this);
		mVersionView.setOnClickListener(this);
		mModLoginPwdItemSettingTextView.setOnClickListener(this);

		mSetBusinessPwdItemSettingTextView.setOnClickListener(this);
		mModBusinessPwdItemSettingTextView.setOnClickListener(this);
		mForgotBusinessPwdItemSettingTextView.setOnClickListener(this);

		calculateCacheSize();

		PackageManager mPm = mActivity.getPackageManager();
		try {
			PackageInfo pi = mPm.getPackageInfo(mActivity.getPackageName(), 0);
			mVersionView.setSettingValue(getString(R.string.about_version, pi.versionName, ""));
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onResume() {
		super.onResume();

		if (!mLoginedUser.isLogined()) {
			mForgotBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mModBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mSetBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mModLoginPwdItemSettingTextView.setVisibility(View.GONE);
			setBaseBtnText("");
			return;
		}

		setBaseBtnText("退出登录");
		mModLoginPwdItemSettingTextView.setVisibility(View.VISIBLE);
		if (mLoginedUser.getPayPassword()) {
			mForgotBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
			mModBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
			mSetBusinessPwdItemSettingTextView.setVisibility(View.GONE);
		} else {
			mForgotBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mModBusinessPwdItemSettingTextView.setVisibility(View.GONE);
			mSetBusinessPwdItemSettingTextView.setVisibility(View.VISIBLE);
		}
	}

	void logout() {
		mLogoutDialog = CommonLoginFragment.showAlertDialog(mActivity, getString(R.string.acco_logout_confirm), R.string.cancel, R.string.ok, null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mLogoutDialog.dismiss();
				new LogoutInterface(AccoSettingFragment.this) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						AgentApplication.getLoginedUser(mActivity).setIsLogined(false);
						Run.savePrefs(mActivity, Run.pk_logined_user_password, "");
						IntentFilter home_dynamic_filter = new IntentFilter();
						home_dynamic_filter.addAction(CommonHomeFragment.HOMEREFASH); // 添加动态广播的Action
						CommonHomeFragment.BroadcastReceiverHelper homeDynamicReceiver = new CommonHomeFragment.BroadcastReceiverHelper();
						mActivity.registerReceiver(homeDynamicReceiver, home_dynamic_filter);
						Intent homeIntent = new Intent();
						homeIntent.setAction(CommonHomeFragment.HOMEREFASH); // 发送广播
						mActivity.sendBroadcast(homeIntent);
						mActivity.unregisterReceiver(homeDynamicReceiver);
						mActivity.finish();
						Run.goodsCounts = 0;
					}
				}.RunRequest();
			}
		}, false, null);
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
		Run.savePrefs(mActivity, WURAOMODE, isChecked);
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v == mAboutView) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_ABUOT));
		} else if (v == mClearMemroyView) {
			showClearCacheDialog();
		} else if (v == mModLoginPwdItemSettingTextView) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_RESET_PASSWORD));
		} else if (v == mVersionView) {
			new UpdateAppInterface(this) {

				@Override
				public void noNewVersion() {
					// TODO Auto-generated method stub
					PackageManager mPm = mActivity.getPackageManager();
					try {
						PackageInfo pi = mPm.getPackageInfo(mActivity.getPackageName(), 0);
						mVersionView.setSettingValue(getString(R.string.about_version, pi.versionName, "最新版"));
					} catch (NameNotFoundException e) {
						e.printStackTrace();
					}
				}

				@Override
				public void cancelUpdate() {
					// TODO Auto-generated method stub
				}
			}.RunRequest();
		} else if (v == mSetBusinessPwdItemSettingTextView) {

			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW));
		} else if (v == mModBusinessPwdItemSettingTextView || v == mForgotBusinessPwdItemSettingTextView) {

			ItemSettingTextView itemSettingTextView = (ItemSettingTextView) v;
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_BUSINESS_PW).putExtra(AccoForgetBusinessPasswdFragment.ACTIONBAR_TITLE, itemSettingTextView.getTitle()));
		} else if(v == mHelpCenterView){

			startActivity(AgentActivity.FRAGMENT_ACCO_HELP_CENTER);
		} else {
			super.onClick(v);
		}
	}

	// 清理缓存
	private void showClearCacheDialog() {
		if (mCacheFileSize == null || mCacheFileSize.length() < 2 || Double.parseDouble(mCacheFileSize.substring(0, mCacheFileSize.length() - 2)) <= 0) {

			return;
		}

		mClearMemoryDialog = CommonLoginFragment.showAlertDialog(mActivity, getString(R.string.acco_setting_clear_cache_summary), R.string.cancel, R.string.acco_setting_clear_cache, null,
				new OnClickListener() {

					@Override
					public void onClick(View v) {
						mClearMemoryDialog.dismiss();
						deleteCacheFolder();
					}
				}, false, null);
	}

	// 删除缓存目录
	private void deleteCacheFolder() {
		new Thread() {
			@Override
			public void run() {
				Run.deleteAllFiles(new File(Run.doImageCacheFolder));
				mActivity.runOnUiThread(new Runnable() {

					@Override
					public void run() {
						CommonLoginFragment.showAlertDialog(mActivity, "清除缓存完成！", "", "OK", null, null, false, null);
						mClearMemroyView.setSettingValue("0M");
					}
				});
			}
		}.start();
	}

	// 计算缓存大小
	private void calculateCacheSize() {
		mCacheSize = Run.countFileSize(new File(Run.doImageCacheFolder));
		mCacheFileSize = Formatter.formatFileSize(mActivity, mCacheSize);
		mActivity.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				mClearMemroyView.setSettingValue(mCacheFileSize);
			}
		});
	}

}
