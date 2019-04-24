package com.qianseit.westore.activity.common;

import android.app.Activity;
import android.app.Notification.Action;
import android.os.Bundle;
import android.text.Html;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.beiwangfx.R;

public class CommonRegisterHintFragment extends BaseDoFragment {
	private int width;
	private TextView mPostionText, mDiscountText, mHint1Text, mHint2Text;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(getString(R.string.app_name));
		mActionBar.getBackButton().setVisibility(View.INVISIBLE);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.fragment_registered_hint_main, null);
		LayoutParams layoutParams = (RelativeLayout.LayoutParams) findViewById(R.id.reg_hint_icon).getLayoutParams();
		width = Run.getWindowsWidth(mActivity);
		layoutParams.height = (width * 1322) / 1242;

		mPostionText = (TextView) findViewById(R.id.regis_postion_tv);
		mDiscountText = (TextView) findViewById(R.id.regis_discount_tv);
		mHint1Text = (TextView) findViewById(R.id.regis_hint1_tv);
		mHint2Text = (TextView) findViewById(R.id.regis_hint2_tv);
		mDiscountText.setText(Html.fromHtml("<font color='#999999'>尊享购物</font><font color='#fe030a'>9.8</font><font color='#999999'>折</font>"));
		findViewById(R.id.regis_buy_but).setOnClickListener(this);
	}

	public boolean onKeyDown(int key, KeyEvent e) {
		Run.log("repeat count:", e.getRepeatCount());
		if (key == KeyEvent.KEYCODE_BACK && e.getRepeatCount() == 0) {
			goHome();
			return true;
		}
		return super.onKeyDown(key, e);
	}

	private void goHome() {
		boolean isStatus = Run.loadOptionBoolean(mActivity, "goodsdetastatus", false);
		if (isStatus) {
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		} else {
				startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
				mActivity.finish();
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		super.onClick(v);
		switch (v.getId()) {
		case R.id.regis_buy_but:
			goHome();
			break;
		default:
			break;
		}
	}
}
