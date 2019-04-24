package com.qianseit.westore.activity.common;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.KeyEvent;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.FrameLayout.LayoutParams;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.acco.AccoCenterFragment;
import com.qianseit.westore.activity.community.CommunityFragment;
import com.qianseit.westore.activity.goods.CategoryFragment;
import com.qianseit.westore.activity.shopping.ShoppCarOneFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.DoActivity;

import java.util.ArrayList;
import java.util.List;

public class CommonMainActivity extends DoActivity implements OnCheckedChangeListener {
	private final int FRAGMENT_LOGING_REQUE = 0x100;
	public final static String DYNAMICACTION = "com.qianse.BroadcastReceiverHelper";
	public static CommonMainActivity mActivity;
	private List<BaseDoFragment> fragments;
	private LoginedUser mLoginedUser;
	private long mLastBackDownTime = 0;

	private RadioGroup mRadioGroup;
	public int mOldSelectIndex = 0;
	public int mSelectIndex = 0;
	private static TextView mCarText;

	BaseDoFragment mCurBaseDoFragment;

	public int mDefualtSelectedCategoryType = R.id.category_rb;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActivity = this;
		setContentView(R.layout.fragment_comm_main);
		mLoginedUser = AgentApplication.getLoginedUser(this);
		initData();
		mRadioGroup = (RadioGroup) findViewById(R.id.maintab_tab_radiogroup);
		mCarText = (TextView) findViewById(R.id.main_car_text);
		LayoutParams layoutParams = (LayoutParams) mCarText.getLayoutParams();
		int itemWidth = Run.getWindowsWidth(this) / 5;
		layoutParams.setMargins(0, Run.dip2px(this, 5), itemWidth + Run.dip2px(this, 10), 0);
		for (int i = 0, c = mRadioGroup.getChildCount(); i < c; i++) {
			((RadioButton) mRadioGroup.getChildAt(i)).setOnCheckedChangeListener(this);
		}

		// 自动创建桌面快捷方式
		if (!Run.loadOptionBoolean(mActivity, Run.pk_shortcut_installed, false)) {
			Run.savePrefs(mActivity, Run.pk_shortcut_installed, true);
			Run.createShortcut(mActivity);
		}
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	public static class BroadcastReceiverHelper extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			if (intent.getAction().equals(DYNAMICACTION)) {
				CommonMainActivity.mActivity.setShoppingCarCount();
			}
		}

	}

	@Override
	protected void onResume() {
		super.onResume();
		CommonMainActivity.mActivity.setShoppingCarCount();
		if (mSelectIndex == 3) {
			if (AgentApplication.getLoginedUser(this).isLogined()) {
			} else {
				if (mOldSelectIndex == 3) {
					mSelectIndex = 0;
				} else {
					mSelectIndex = mOldSelectIndex;
				}
			}
		}

		switchFragment(fragments.get(mSelectIndex));
		((RadioButton) mRadioGroup.getChildAt(mSelectIndex)).setChecked(true);
		
	}

	// 设置购物车商品数量数量
	public void setShoppingCarCount() {
		if (mCarText != null) {
			if (Run.goodsCounts > 0) {
				mCarText.setVisibility(View.VISIBLE);
				mCarText.setText(Run.goodsCounts > 99 ? "99+" : String.valueOf(Run.goodsCounts));
			} else {
				mCarText.setVisibility(View.GONE);
			}
		}
	}

	public void chooseRadio(int indexRadio) {
		if (indexRadio < 0 || indexRadio >= mRadioGroup.getChildCount()) {
			return;
		}

		mOldSelectIndex = mSelectIndex;
		mSelectIndex = indexRadio;
//		if (mSelectIndex == 2 || mSelectIndex == 3) {
//			if (!mLoginedUser.isLogined()) {
//				startActivity(AgentActivity.intentForFragment(this, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
//				return;
//			}
//		}

		((RadioButton) mRadioGroup.getChildAt(indexRadio)).setChecked(true);
		switchFragment(fragments.get(indexRadio));
	}

	public boolean onKeyDown(int key, KeyEvent e) {
		Run.log("repeat count:", e.getRepeatCount());
		if (key == KeyEvent.KEYCODE_BACK && e.getRepeatCount() == 0) {
			long now = System.currentTimeMillis();
			// 点击Back键提示退出程序
			if (now - mLastBackDownTime > 3000) {
				mLastBackDownTime = now;
				Run.alert(this, R.string.exit_message);
			} else {
				this.finish();
			}
			return true;
		}

		return super.onKeyDown(key, e);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == RESULT_OK) {
			if (requestCode == FRAGMENT_LOGING_REQUE) {
				this.finish();
				return;
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	private void initData() {
		fragments = new ArrayList<BaseDoFragment>();
		fragments.add(new CommonHomeFragment());
		fragments.add(new CategoryFragment());
		fragments.add(new CommunityFragment());
		fragments.add(new ShoppCarOneFragment());
		fragments.add(new AccoCenterFragment());
	}

	private void switchFragment(BaseDoFragment baseFragment) {
		if (mCurBaseDoFragment != null && baseFragment != null && mCurBaseDoFragment.equals(baseFragment)) {
			return;
		}

		FragmentTransaction fragmentTransaction = CommonMainActivity.this.getSupportFragmentManager().beginTransaction();
		fragmentTransaction.replace(R.id.main_content, baseFragment);
		mCurBaseDoFragment = baseFragment;
		fragmentTransaction.commit();
	}

	public static Intent GetMainTabActivity(Context context) {
		if (mActivity != null) {
			mActivity.finish();
		}
		Intent nIntent = new Intent(context, CommonMainActivity.class);
//		nIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);// 它可以关掉所要到的界面中间的activity
		return nIntent;
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
		if (isChecked) {
			int resid = buttonView.getId();
			mOldSelectIndex = mSelectIndex;
			if (resid == R.id.tabbar1) {
				mSelectIndex = 0;
			} else if (resid == R.id.tabbar2) {
				mSelectIndex = 1;
			} else if (resid == R.id.tabbar3) {
				mSelectIndex = 2;
				// if (!mLoginedUser.isLogined()) {
				// startActivity(AgentActivity.intentForFragment(this,
				// AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
				// return;
				// }
			} else if (resid == R.id.tabbar4) {
				mSelectIndex = 3;
//				if (!mLoginedUser.isLogined()) {
//					Run.savePrefs(mActivity, "goodsdetastatus", false);
//					startActivity(AgentActivity.intentForFragment(this, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
//					return;
//				}
			} else if (resid == R.id.tabbar5) {
				mSelectIndex = 4;
//				if (!mLoginedUser.isLogined()) {
//					Run.savePrefs(mActivity, "goodsdetastatus", false);
//					startActivity(AgentActivity.intentForFragment(this, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
//					return;
//				}
			}
			switchFragment(fragments.get(mSelectIndex));
		}
	}
}