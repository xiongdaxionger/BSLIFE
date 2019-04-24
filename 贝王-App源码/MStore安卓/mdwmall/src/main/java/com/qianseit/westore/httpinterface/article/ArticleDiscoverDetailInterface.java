package com.qianseit.westore.httpinterface.article;


import android.content.ContentValues;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ArticleDiscoverDetailInterface extends BaseHttpInterfaceTask {
	int mDiscoverId;
	
	public ArticleDiscoverDetailInterface(QianseitActivityInterface activityInterface, int discoverId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mDiscoverId = discoverId;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.discover.getdiscover";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("discover_id", String.valueOf(mDiscoverId));
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject nDataJsonObject = responseJson.optJSONObject("data");
		if (nDataJsonObject == null) {
			responseTitle("");
			responseContent("");
			return;
		}
		
		if (!nDataJsonObject.has("title")) {
			responseTitle("");
		}else{
			responseTitle(nDataJsonObject.optString("title"));
		}
		
		if (!nDataJsonObject.has("content")) {
			responseContent("");
		}else{
			responseContent(nDataJsonObject.optString("content"));
		}
	}

	public abstract void responseTitle(String titleString);
	public abstract void responseContent(String contentString);
}
