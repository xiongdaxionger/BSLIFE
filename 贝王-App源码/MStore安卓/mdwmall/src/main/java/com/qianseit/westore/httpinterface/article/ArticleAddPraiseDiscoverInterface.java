package com.qianseit.westore.httpinterface.article;



import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ArticleAddPraiseDiscoverInterface extends BaseHttpInterfaceTask {
	boolean mIfPraise = true;
	String mArticleIdString;
	String mContentString;
	
	public ArticleAddPraiseDiscoverInterface(QianseitActivityInterface activityInterface, boolean ifPraise, String articleIdString, String contentString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		initFields(ifPraise, articleIdString, contentString);
	}

	public ArticleAddPraiseDiscoverInterface(QianseitActivityInterface activityInterface, String articleIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		initFields(true, articleIdString, "");
	}

	void initFields(boolean ifPraise, String articleIdString, String contentString){
		mIfPraise = ifPraise;
		mArticleIdString = articleIdString;
		mContentString = contentString;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "content.article.addPraise";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("ifpraise", String.valueOf(mIfPraise));
		nContentValues.put("article_id", mArticleIdString);
		if (!TextUtils.isEmpty(mContentString)) {
			nContentValues.put("content", mContentString);
		}
		
		return nContentValues;
	}
}
