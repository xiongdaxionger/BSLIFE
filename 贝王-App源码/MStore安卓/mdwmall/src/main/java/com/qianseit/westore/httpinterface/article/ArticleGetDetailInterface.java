package com.qianseit.westore.httpinterface.article;


import android.content.ContentValues;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ArticleGetDetailInterface extends BaseHttpInterfaceTask {
	int mArticleId;
	
	public ArticleGetDetailInterface(QianseitActivityInterface activityInterface, int articleId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mArticleId = articleId;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "content.article.index";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("article_id", String.valueOf(mArticleId));
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		
		JSONObject nIndexsJsonObject = responseJson.optJSONObject("indexs");
		if (nIndexsJsonObject == null || !nIndexsJsonObject.has("title")) {
			responseTitle("");
		}else{
			responseTitle(nIndexsJsonObject.optString("title"));
		}
		
		JSONObject nContentJsonObject = responseJson.optJSONObject("bodys");
		if (nContentJsonObject == null || !nContentJsonObject.has("content")) {
			responseContent("");
		}else{
			responseContent(nContentJsonObject.optString("content"));
		}
	}

	public abstract void responseTitle(String titleString);
	public abstract void responseContent(String contentString);
}
