package com.qianseit.westore.activity.other;

import android.os.Bundle;
import android.text.TextUtils;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.article.ArticleGetDetailInterface;

public class ArticleReaderFragment extends BaseWebviewFragment {

	private String articleid;
	private String articleHtml;
	private String articleUrl;

	public ArticleReaderFragment() {
		super();
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		articleid = mActivity.getIntent().getStringExtra(Run.EXTRA_ARTICLE_ID);
		articleHtml = mActivity.getIntent().getStringExtra(Run.EXTRA_HTML);
		articleUrl = mActivity.getIntent().getStringExtra("com.qianseit.westore.EXTRA_URL");
		String title = mActivity.getIntent().getStringExtra(Run.EXTRA_TITLE);
		if (!TextUtils.isEmpty(title)) {
			mActionBar.setTitle(title);
		}
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		if (!TextUtils.isEmpty(articleid)) {
			int nId = 0;
			if (TextUtils.isDigitsOnly(articleid)) {
				nId = Integer.parseInt(articleid);
			}
			new ArticleGetDetailInterface(this, nId) {

				@Override
				public void responseTitle(String titleString) {
					// TODO Auto-generated method stub
					mActionBar.setTitle(titleString);
				}

				@Override
				public void responseContent(String contentString) {
					// TODO Auto-generated method stub
					articleHtml = contentString;
					loadWebContent();
				}

			}.RunRequest();
		}
	}

	@Override
	public String getContent() {
		// TODO Auto-generated method stub
		return articleHtml;
	}

	@Override
	public String getUrl() {
		// TODO Auto-generated method stub
		return articleUrl;
	}
}
