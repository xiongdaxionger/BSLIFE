package com.qianseit.westore.activity.wealth;

import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.Button;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.beiwangfx.R;

/**
 * 选择储蓄卡充值最终页面
 */
public class WealthPayFinallyFragmtn extends BaseDoFragment {

	private Button mGetVerifyCodeButton;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowHomeView(true);
		mActionBar.setShowTitleBar(true);
		mActionBar.setShowBackButton(true);
		mActionBar.setTitle("账户充值 ");
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_wealth_pay_finally, null);
	}

	// 设置验证码按钮状态，倒计时60秒
	private void enableVreifyCodeButton() {
		long remainTime = System.currentTimeMillis() - Run.countdown_time;
		remainTime = 60 - remainTime / 1000;
		if (remainTime <= 0) {
			mGetVerifyCodeButton.setEnabled(true);
			mGetVerifyCodeButton.setText(R.string.acco_regist_get_verify_code);
			mGetVerifyCodeButton.setBackgroundResource(R.drawable.qianseit_bg_vcode_click);
			mGetVerifyCodeButton.setTextColor(Color.WHITE);
			return;
		} else {
			mGetVerifyCodeButton.setBackgroundResource(R.drawable.bg_verify_code);
			mGetVerifyCodeButton.setTextColor(mActivity.getResources().getColor(R.color.default_page_bgcolor_3));
		}

		mGetVerifyCodeButton.setEnabled(false);
		mGetVerifyCodeButton.setText(mActivity.getString(R.string.acco_regist_verify_code_countdown, remainTime));
		mHandler.postDelayed(new Runnable() {
			@Override
			public void run() {
				enableVreifyCodeButton();
			}
		}, 1000);
	}

}
