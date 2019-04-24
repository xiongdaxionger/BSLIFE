package com.qianseit.westore.activity.common;

import android.text.TextUtils;

import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.article.ArticleGetDetailInterface;
import com.beiwangfx.R;

public class CommRegArticleFragment extends BaseWebviewFragment {

	String mContent = "";
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mActionBar.setTitle(getString(R.string.app_name) + "网络服务协议");
		
		new ArticleGetDetailInterface(this, 60) {
			
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
