package com.qianseit.westore.base;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MenuInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewGroup.MarginLayoutParams;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.DoActionBar.ActionBarHandler;
import com.qianseit.westore.ui.LoadingDialog;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public abstract class DoFragment extends Fragment implements QianseitActivityInterface, OnClickListener {
	private final int REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY = 0x1001;
	private final int HANDLE_HIDE_LOADING_DIALOG = 100;
	private final int HANDLE_SHOW_LOADING_DIALOG = 101;
	private final int HANDLE_SHOW_CANCEL_LOADING_DIALOG = 102;

	// private CustomProgrssDialog progress;
	private LoadingDialog progress1;
	boolean mProgressIsShow = false;
	public DoActionBar mActionBar;
	public View rootView;

	public FragmentActivity mActivity;

	// 是否显示返回按钮
	private boolean showBackButton;

	int mWaitStarFragmentId = 0;
	Bundle mWaitStarFragmentBundler;

	/**
	 * Notice:Never use this constructor<br />
	 * 只是防止Fragment重载崩溃
	 */
	public DoFragment() {
		super();
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// fragment一定要有无参数构造方法，我们尽量去适应它
		// 这段代码不能直接放在构造方法中，构造时还没有activiy
		if (mActivity == null)
			mActivity = getActivity();

		// ActionBar为空时，构造ActionBar
		if (mActionBar == null) {
			mActionBar = new DoActionBar(mActivity);
			// 设置返回按钮是否可用
			if (getArguments() != null)
				showBackButton = getArguments().getBoolean(DoActivity.EXTRA_SHOW_BACK, false);
			showBackButton = mActivity.getIntent().getBooleanExtra(DoActivity.EXTRA_SHOW_BACK, showBackButton);
			mActionBar.setShowBackButton(showBackButton);
			mActionBar.setActionBarHandler(new ActionBarHandler() {

				@Override
				public void back() {
					// TODO Auto-generated method stub
					DoFragment.this.back();
				}
			});
		}
	}

	protected void back() {
		mActivity.finish();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// ActionBar已经有父View则从父View移除
		if (mActionBar != null && mActionBar.getParent() != null)
			((ViewGroup) mActionBar.getParent()).removeView(mActionBar);
		mActionBar.setShowBackButton(showBackButton);

		// rootView已存在，说明已经初始化好Fragment则不需要重复初始化
		// 在子方法中不要加入需要重复初始化的方法
		if (rootView != null)
			return mActionBar;
		init(inflater, container, savedInstanceState);
		mActionBar.getContainerView().addView(rootView);
		return mActionBar;
	}

	// 初始化Fragment视图
	public abstract void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState);

	/**
	 * 查找指定Id的View
	 * 
	 * @param resId
	 * @return
	 */
	public View findViewById(int resId) {
		return rootView.findViewById(resId);
	}

	public void startNeedloginActivity(int fragmentId, Bundle bundle) {
		if (!AgentApplication.getLoginedUser(mActivity).isLogined()) {
			Run.savePrefs(mActivity, "goodsdetastatus", false);
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY);
			mWaitStarFragmentBundler = bundle;
			mWaitStarFragmentId = fragmentId;
			return;
		}

		startActivity(fragmentId, bundle);
	}

	public void startNeedloginActivity(int fragmentId) {
		startNeedloginActivity(fragmentId, new Bundle());
	}

	public void startActivity(int fragmentId) {
		startActivity(fragmentId, new Bundle());
	}

	public void startActivity(int fragmentId, Bundle bundle) {
		startActivity(AgentActivity.intentForFragment(mActivity, fragmentId).putExtras(bundle));
	}

	public void startActivityForResult(int fragmentId, Bundle bundle, int requestCode) {
		startActivityForResult(AgentActivity.intentForFragment(mActivity, fragmentId).putExtras(bundle), requestCode);
	}

	public void startActivityForResult(int fragmentId, int requestCode) {
		startActivityForResult(fragmentId, new Bundle(), requestCode);
	}

	public String getExtraStringFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return "";
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return "";
		return nBundle.getString(key);
	}

	public double getExtraDoubleFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return 0.00;
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return 0.00;
		return nBundle.getDouble(key);
	}

	public int getExtraIntFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return 0;
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return 0;
		return nBundle.getInt(key);
	}

	public long getExtraLongFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return 0;
		}

		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return 0;
		return nBundle.getLong(key);
	}

	public boolean getExtraBooleanFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return false;
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return false;
		return nBundle.getBoolean(key, false);
	}

	public List<String> getExtraStringListFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return new ArrayList<String>();
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return new ArrayList<String>();
		return nBundle.getStringArrayList(key);
	}

	public Serializable getExtraSerializableFromBundle(String key){
		Intent nIntent = mActivity.getIntent();
		if (nIntent == null) {
			return new ArrayList<String>();
		}
		
		Bundle nBundle = nIntent.getExtras();
		if(nBundle == null) return new ArrayList<String>();
		return nBundle.getSerializable(key);
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode == Activity.RESULT_OK) {
			if (requestCode == REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY && mWaitStarFragmentId > 0) {
				startActivity(mWaitStarFragmentId, mWaitStarFragmentBundler);
				mWaitStarFragmentId = 0;
				mWaitStarFragmentBundler = null;
				return;
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	/**
	 * 获得ActionBar
	 * 
	 * @return
	 */
	public DoActionBar getActionBar() {
		return mActionBar;
	}

	/**
	 * 获得进度框
	 * 
	 * @return
	 */
	// public CustomProgrssDialog getProgressDialog() {
	// return progress;
	// }
	public LoadingDialog getProgressDialog() {
		return progress1;
	}

	public boolean isDialogShowing() {
		if (progress1 != null) {
			return progress1.isShowing();
		}
		return false;
	}

	/**
	 * 获得LayoutInflater
	 * 
	 * @return
	 */
	public LayoutInflater getLayoutInflater() {
		return getActivity().getLayoutInflater();
	}

	/**
	 * 获得LayoutInflater
	 * 
	 * @return
	 */
	@Override
	public LayoutInflater getLayoutInflater(Bundle savedInstanceState) {
		return getActivity().getLayoutInflater();
	}

	/**
	 * 获得MenuInflater
	 * 
	 * @return
	 */
	public MenuInflater getMenuInflater() {
		return getActivity().getMenuInflater();
	}

	@Override
	public void onClick(View v) {
	}

	/**
	 * 主线程执行命令
	 * 
	 * @param what
	 */
	public final void call(int what) {
		call(what, new Message());
	}

	public final void callDelayed(int what, long mills) {
		call(what, new Message(), mills);
	}

	public final void call(int what, Message msg) {
		call(what, msg, 0);
	}

	public final void call(int what, Message msg, long mills) {
		msg.what = what;
		mHandler.sendMessageDelayed(msg, mills);
	}

	/**
	 * 统一操作UI入口
	 * 
	 * @param what
	 */
	public abstract void ui(int what, Message msg);

	public final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			ui(msg.what, msg);
		}
	};

	private Handler tHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case HANDLE_SHOW_LOADING_DIALOG:
				// if (progress != null && progress.isShowing())
				// progress.dismiss();
				// progress = Util.showLoadingDialog(mActivity, null, null);
				// if (progress != null)
				// progress.setCancelable(false);

				if (progress1 != null && progress1.isShowing())
					progress1.dismiss();
				if (mProgressIsShow) {
					progress1 = new LoadingDialog(mActivity);
					progress1.show();
					if (progress1 != null) {
						progress1.setCancelable(false);
					}
				}
				break;
			case HANDLE_SHOW_CANCEL_LOADING_DIALOG:
				if (mProgressIsShow) {
					showCancelableLoadingDialog_mt();
				}

				break;
			case HANDLE_HIDE_LOADING_DIALOG:
				hideLoadingDialog_mt();
				break;
			}
		}
	};

	/**
	 * 显示加载提示框
	 */
	public void showLoadingDialog() {
		mProgressIsShow = true;
		tHandler.sendEmptyMessage(HANDLE_SHOW_LOADING_DIALOG);
	}

	/**
	 * 显示可以取消的提示框
	 */
	public void showCancelableLoadingDialog() {
		mProgressIsShow = true;
		tHandler.sendEmptyMessage(HANDLE_SHOW_CANCEL_LOADING_DIALOG);
	}

	/**
	 * 主线程直接调用显示可以取消的提示框<br/>
	 */
	public void showCancelableLoadingDialog_mt() {
		// if (progress != null && progress.isShowing())
		// progress.dismiss();
		// progress = Util.showLoadingDialog(getActivity(), null, null);
		// if (progress != null)
		// progress.setCancelable(true);
		mProgressIsShow = true;
		if (progress1 != null && progress1.isShowing())
			progress1.dismiss();
		progress1 = new LoadingDialog(mActivity);
		progress1.show();
		if (progress1 != null)
			progress1.setCancelable(true);

	}

	// 隐藏提示框
	public void hideLoadingDialog() {
		mProgressIsShow = false;
		tHandler.sendEmptyMessageDelayed(HANDLE_HIDE_LOADING_DIALOG, 1000);
	}

	/**
	 * 主线程直接调用取消提示框<br/>
	 */
	public void hideLoadingDialog_mt() {
		// Util.hideLoading(progress);
		mProgressIsShow = false;
		if (progress1 != null) {
			progress1.dismiss();
		}
	}

	@Override
	public Context getContext() {
		// TODO Auto-generated method stub
		return mActivity;
	}

	// 隐藏软键盘
	public void hideKeyboard(View v) {
		((InputMethodManager) mActivity.getSystemService(Context.INPUT_METHOD_SERVICE)).hideSoftInputFromWindow(v.getWindowToken(), 0);
	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			back();
			return true;
		}
		return false;
	}
	
	public boolean dispatchKeyEvent(KeyEvent event) {
		// TODO Auto-generated method stub
		return false;
	}
	
	public void onWindowFocusChanged(boolean hasFocus) {

	}

	public static void setViewHeight(View view, double ratioOfScreenWidth) {
		WindowManager wm = (WindowManager) view.getContext().getSystemService(Context.WINDOW_SERVICE);
		setViewAbsoluteHeight(view, (int) (wm.getDefaultDisplay().getWidth() * ratioOfScreenWidth / 1080));
	}

	public static void setViewAbsoluteHeight(View view, int height) {
		LayoutParams nLayoutParams = view.getLayoutParams();
		nLayoutParams.height = height;
		view.setLayoutParams(nLayoutParams);
	}

	public static void setViewWidth(View view, double ratioOfScreenWidth) {
		LayoutParams nLayoutParams = view.getLayoutParams();
		WindowManager wm = (WindowManager) view.getContext().getSystemService(Context.WINDOW_SERVICE);
		nLayoutParams.width = (int) (wm.getDefaultDisplay().getWidth() * ratioOfScreenWidth / 1080);
		view.setLayoutParams(nLayoutParams);
	}

	public static void setViewSize(View view, double ratioOfScreenWidthForWidth, double ratioOfScreenWidthForHeight) {
		LayoutParams nLayoutParams = view.getLayoutParams();
		WindowManager wm = (WindowManager) view.getContext().getSystemService(Context.WINDOW_SERVICE);
		nLayoutParams.width = (int) (wm.getDefaultDisplay().getWidth() * ratioOfScreenWidthForWidth / 1080);
		nLayoutParams.height = (int) (wm.getDefaultDisplay().getWidth() * ratioOfScreenWidthForHeight / 1080);
		view.setLayoutParams(nLayoutParams);
	}

	public static void setViewLayout(View view, double width, double height, double top) {
		MarginLayoutParams nLayoutParams = (ViewGroup.MarginLayoutParams) view.getLayoutParams();
		WindowManager wm = (WindowManager) view.getContext().getSystemService(Context.WINDOW_SERVICE);
		nLayoutParams.height = (int) (wm.getDefaultDisplay().getWidth() * height / 1080);
		nLayoutParams.width = (int) (wm.getDefaultDisplay().getWidth() * width / 1080);
		nLayoutParams.setMargins(nLayoutParams.leftMargin, (int) (wm.getDefaultDisplay().getWidth() * top / 1080), nLayoutParams.rightMargin, nLayoutParams.bottomMargin);
		view.requestLayout();
	}

	public static void setViewAbsoluteSize(View view, int ratioOfScreenWidthForWidth, int ratioOfScreenWidthForHeight) {
		LayoutParams nLayoutParams = view.getLayoutParams();
		nLayoutParams.width = ratioOfScreenWidthForWidth;
		nLayoutParams.height = ratioOfScreenWidthForHeight;
		view.setLayoutParams(nLayoutParams);
	}
}
