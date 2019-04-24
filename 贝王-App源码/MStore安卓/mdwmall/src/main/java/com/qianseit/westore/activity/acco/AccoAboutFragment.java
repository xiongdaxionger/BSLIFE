package com.qianseit.westore.activity.acco;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.member.MemberAboutInterface;

/**
 * 关于、帮助
 * 
 * 
 */
public class AccoAboutFragment extends BaseWebviewFragment {

	String mContent = "";
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("关于我们");

		new MemberAboutInterface(this) {
			
			@Override
			public void responseContent(String content) {
				mContent = content;
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
