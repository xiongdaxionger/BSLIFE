package com.qianseit.westore.base;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.base.BaseDoFragment;

abstract public class BaseSettingFragment extends BaseDoFragment {
	protected LinearLayout mContentLinearLayout;
	protected LoginedUser mLoginedUser;
	private Button mButton;

	public BaseSettingFragment() {
		super();
	}

	@Override
	final public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.base_fragment_setting, null);
		mContentLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_content_ll);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mButton = (Button) findViewById(R.id.base_fragment_btn);
		initActionBar();
		initSettingItems(mContentLinearLayout);
	}

	protected void reloadSettingItems() {
		mContentLinearLayout.removeAllViews();
		initSettingItems(mContentLinearLayout);
	}

	protected abstract void initActionBar();

	protected abstract void initSettingItems(LinearLayout parentView);

	protected void setOnBaseBtnClick(OnClickListener l) {
		mButton.setOnClickListener(l);
	}

	protected void setBaseBtnText(String textString) {
		mButton.setText(textString);
		mButton.setVisibility(TextUtils.isEmpty(textString) ? View.GONE : View.VISIBLE);
	}

	protected void setBaseBtnText(int textRes) {
		mButton.setText(textRes);
		mButton.setVisibility(TextUtils.isEmpty(mButton.getText().toString()) ? View.GONE : View.VISIBLE);
	}
}
