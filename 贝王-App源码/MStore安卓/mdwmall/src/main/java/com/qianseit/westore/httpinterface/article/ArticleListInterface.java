package com.qianseit.westore.httpinterface.article;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ArticleListInterface extends BaseHttpInterfaceTask {

	String mNodeId, mNodeType;

	public ArticleListInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "content.article.l";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (!TextUtils.isEmpty(mNodeId)) {
			nContentValues.put("node_id", mNodeId);
		}
		
		if (!TextUtils.isEmpty(mNodeId)) {
			nContentValues.put("node_type", mNodeType);
		}
		return nContentValues;
	}

	/**
	 * 必须有一个值不能为空
	 * @param nodeId
	 * @param nodeType
	 */
	public void getList(String nodeId, String nodeType){
		mNodeId = nodeId;
		mNodeType = nodeType;
		RunRequest();
	}
}
