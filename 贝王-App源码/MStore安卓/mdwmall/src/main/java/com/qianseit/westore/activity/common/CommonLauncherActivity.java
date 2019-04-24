package com.qianseit.westore.activity.common;

import java.util.Calendar;
import java.util.Date;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;
import android.view.WindowManager;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.httpinterface.info.UpdateAppInterface;
import com.tencent.android.tpush.XGPushManager;
import com.umeng.analytics.MobclickAgent;

public class CommonLauncherActivity extends DoActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		Context context = getApplicationContext();
		XGPushManager.registerPush(context);  
		
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

		super.onCreate(savedInstanceState);
		if (Run.loadFlag(this) < Run.getVersionCode(this)) {
			setMainFragment(new SplashFragment());
		} else {
			getWindow().getDecorView().setBackgroundResource(R.drawable.launcher);
			new UpdateAppInterface(this) {
				
				@Override
				public void noNewVersion() {
					// TODO Auto-generated method stub
					mHandler.sendEmptyMessageDelayed(0, 1500);
				}
				
				@Override
				public void cancelUpdate() {
					// TODO Auto-generated method stub
					mHandler.sendEmptyMessageDelayed(0, 500);
				}
			}.RunRequest();
		}
	}

	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			 startActivity(CommonMainActivity.GetMainTabActivity(CommonLauncherActivity.this));
			 finish();
		}
	};

	@Override
	protected void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}

	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
	public void finish() {
		super.finish();
		overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
	}

	/** 
	* 获取app进入后台的时间（分钟）
	* @return
	*/
	int isNotActiveDate(){
		Date nDate = new Date();
		return getGapMinteCount(mIsNotActiveBeginDate, nDate);
	}
	
	/**
	 * 获取两个日期之间的间隔天数
	 * @return
	 */
	public static int getGapDayCount(Date startDate, Date endDate) {
        return getGapSecondCount(startDate, endDate) /(60 * 60 * 24);
	}

	/**
	 * 获取两个日期之间的间隔分钟数
	 * @return
	 */
	public static int getGapMinteCount(Date startDate, Date endDate) {
        return getGapSecondCount(startDate, endDate) /(60);
	}

	/**
	 * 获取两个日期之间的间隔小时数
	 * @return
	 */
	public static int getGapHourCount(Date startDate, Date endDate) {
        return getGapSecondCount(startDate, endDate) /(60 * 60);
	}

	/**
	 * 获取两个日期之间的间隔天数
	 * @return
	 */
	public static int getGapSecondCount(Date startDate, Date endDate) {
        Calendar fromCalendar = Calendar.getInstance();  
        fromCalendar.setTime(startDate);  
  
        Calendar toCalendar = Calendar.getInstance();  
        toCalendar.setTime(endDate);  
  
        return (int) ((toCalendar.getTime().getTime() - fromCalendar.getTime().getTime()) / (1000));
	}
}
