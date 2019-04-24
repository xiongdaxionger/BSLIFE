package com.qianseit.westore.activity.common;

import android.content.Intent;
import android.os.Bundle;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseWebviewFragment;

public class CommExpressoFragment extends BaseWebviewFragment {

	String mContentString;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		Intent mIntent=mActivity.getIntent();
		mActionBar.setTitle(mIntent.getStringExtra(Run.EXTRA_TITLE));
		mContentString =  mIntent.getStringExtra(Run.EXTRA_HTML);
	}
	
	@Override
	public String getContent() {
		// TODO Auto-generated method stub
		return mContentString;
	}
	@Override
	protected void init() {
		// TODO Auto-generated method stub

	}

}
