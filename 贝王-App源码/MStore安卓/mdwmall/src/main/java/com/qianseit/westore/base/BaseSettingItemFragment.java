package com.qianseit.westore.base;


import android.app.Activity;
import android.content.ContentValues;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

abstract public class BaseSettingItemFragment extends BaseDoFragment {
	private boolean mAutoFinished = true;
	private LinearLayout mContentLinearLayout;
	protected LoginedUser mLoginedUser;
	private TextView mTipTextView;

	public BaseSettingItemFragment() {
		super();
	}

	public void setAutoFinished(boolean mAutoFinished) {
		this.mAutoFinished = mAutoFinished;
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.base_fragment_setting_item, null);
		mContentLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_content_ll);
		findViewById(R.id.base_fragment_submit_btn).setOnClickListener(this);
		((Button)findViewById(R.id.base_fragment_submit_btn)).addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
				if (s.length() > 0) {
					findViewById(R.id.base_fragment_submit_btn).setVisibility(View.VISIBLE);
				}else{
					findViewById(R.id.base_fragment_submit_btn).setVisibility(View.GONE);
				}
			}
		});
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mTipTextView = (TextView) findViewById(R.id.base_fragment_tip);
		mTipTextView.setText(setSubmitTip());
		
		initInputView(mContentLinearLayout);
		initActionBar();
	}

	protected abstract String requestInterfaceName();
	protected abstract ContentValues getSaveDatas();
	protected abstract void afterRequstScuu(JSONObject responeData);
	protected abstract void initActionBar();
	protected abstract boolean verifyInputValue();
	protected abstract void initInputView(LinearLayout parentView);

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.base_fragment_submit_btn) {
			submit();
		}
	}
	
	protected void setSubmitBtnText(String textString) {
		((Button)findViewById(R.id.base_fragment_submit_btn)).setText(textString);
	}

	protected void setSubmitBtnText(int res) {
		((Button)findViewById(R.id.base_fragment_submit_btn)).setText(res);
	}
	
	protected String setSubmitTip(){
		return "";
	}

	protected void submit() {
		if (!verifyInputValue()) {
			return;
		}
		
		new BaseHttpInterfaceTask(this) {
			
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				afterRequstScuu(responseJson);
				if (mAutoFinished) {
					mActivity.setResult(Activity.RESULT_OK);
					mActivity.finish();
				}
			}
			
			@Override
			public String InterfaceName() {
				// TODO Auto-generated method stub
				return requestInterfaceName();
			}
			
			@Override
			public ContentValues BuildParams() {
				// TODO Auto-generated method stub
				return getSaveDatas();
			}
		}.RunRequest();
	}
}
