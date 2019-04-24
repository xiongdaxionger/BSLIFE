package com.qianseit.westore.activity.aftermarket;

import android.text.TextUtils;

import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.article.ArticleGetDetailInterface;

public class AftermarketNoticeFragment extends BaseWebviewFragment {

	String mContent = "";
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("售后服务须知");
		
		new ArticleGetDetailInterface(this, 46) {
			
			@Override
			public void responseTitle(String titleString) {
				// TODO Auto-generated method stub
				if (TextUtils.isEmpty(titleString)) {
					mActionBar.setTitle(titleString);
				}
			}

			@Override
			public void responseContent(String contentString) {
				// TODO Auto-generated method stub
				mContent = contentString;
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
