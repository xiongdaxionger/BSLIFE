package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.member.MemberScoredescripeInterface;

public class AccoPointsRuleFragment extends BaseWebviewFragment {

	String mContent = "";
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mActionBar.setShowTitleBar(false);
		
		new MemberScoredescripeInterface(this) {
			
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
