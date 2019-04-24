package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.os.Bundle;

import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.article.InfoCouponInstructionsInterface;

public class AccoCouponInstructionsFragment extends BaseWebviewFragment {

	String mContent;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("优惠劵使用说明");
	}
	
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		new InfoCouponInstructionsInterface(this) {
			
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mContent = responseJson.optString("explain");
				loadWebContent();
			}
		}.RunRequest();
	}
	
	@Override
	public String getContent() {
		// TODO Auto-generated method stub
		return mContent;
	}

}
