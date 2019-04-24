package com.qianseit.westore.base;

import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import com.beiwangfx.R;
import com.umeng.analytics.MobclickAgent;

import java.util.Date;
import java.util.List;

public abstract class TopActivity extends FragmentActivity {

	protected static boolean mIsActive = false;
	protected static Date mIsNotActiveBeginDate;

	@Override
	public void finish() {
		super.finish();
		overridePendingTransition(R.anim.activity_fadein, R.anim.activity_scroll_to_right);
	}

	@Override
	public void startActivity(Intent intent) {
		super.startActivity(intent);
		overridePendingTransition(R.anim.activity_scroll_from_right, R.anim.activity_fadeout);
	}

	@Override
	public void startActivityForResult(Intent intent, int requestCode) {
		super.startActivityForResult(intent, requestCode);
		overridePendingTransition(R.anim.activity_scroll_from_right, R.anim.activity_fadeout);
	}

	@SuppressLint("NewApi")
	@Override
	public void startActivityForResult(Intent intent, int requestCode, Bundle options) {
		super.startActivityForResult(intent, requestCode, options);
		overridePendingTransition(R.anim.activity_scroll_from_right, R.anim.activity_fadeout);
	}

	@Override
	protected void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
		if (!mIsActive) {
			// app 从后台唤醒，进入前台
			mIsActive = true;
		}
	}

	@Override
	protected void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

	/*
	 * (非 Javadoc) <p>Title: onStop</p> <p>Description: </p>
	 * 
	 * @see android.support.v4.app.FragmentActivity#onStop()
	 */
	@Override
	protected void onStop() {
		// TODO 自动生成的方法存根
		super.onStop();
		if (!isAppOnForeground()) {
			// app 进入后台
			mIsActive = false;
			mIsNotActiveBeginDate = new Date();

			// 全局变量isActive = false 记录当前已经进入后台
		}
	}

	/**
	 * 程序是否在前台运行
	 * 
	 * @return
	 */
	public boolean isAppOnForeground() {
		// Returns a list of application processes that are running on the
		// device

		ActivityManager activityManager = (ActivityManager) getApplicationContext().getSystemService(Context.ACTIVITY_SERVICE);
		String packageName = getApplicationContext().getPackageName();

		List<RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
		if (appProcesses == null)
			return false;

		for (RunningAppProcessInfo appProcess : appProcesses) {
			// The name of the process that this object is associated with.
			if (appProcess.processName.equals(packageName) && appProcess.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
				return true;
			}
		}

		return false;
	}
}
