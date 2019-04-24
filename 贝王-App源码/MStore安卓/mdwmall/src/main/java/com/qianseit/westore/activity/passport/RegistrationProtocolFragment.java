package com.qianseit.westore.activity.passport;

import android.os.Bundle;

import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.passport.RegistrationProtocolInterface;

public class RegistrationProtocolFragment extends BaseWebviewFragment {

	String mContentString;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("会员注册协议");
	}
	
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		new RegistrationProtocolInterface(this) {
			
			@Override
			public void responseProtocol(String protocol) {
				// TODO Auto-generated method stub
				mContentString = protocol;
				loadWebContent();
			}
		}.RunRequest();
	}

	@Override
	public String getContent() {
		// TODO Auto-generated method stub
		return mContentString;
	}
}
