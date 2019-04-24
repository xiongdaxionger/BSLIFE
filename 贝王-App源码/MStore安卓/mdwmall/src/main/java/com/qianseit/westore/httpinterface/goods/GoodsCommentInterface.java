package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import org.json.JSONArray;
import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *2.8 商品评论列表第一页
 */
public abstract class GoodsCommentInterface extends BaseHttpInterfaceTask {

	String mGoodsId;
	public GoodsCommentInterface(QianseitActivityInterface activityInterface, String goodsId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mGoodsId = goodsId;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.goodsDiscuss";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsId);
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		
		responseCommentsType(responseJson.optJSONArray("goodsDiscuss_type"));
		JSONObject nComments = responseJson.optJSONObject("comments");
		responseComments(nComments);
	}
	
	public void loadComment(String goodsId){
		mGoodsId = goodsId;
		RunRequest();
	}

	public abstract void responseComments(JSONObject commentsJsonObject);
	/**
	 * {
            "current": 1,
            "total": 7,
            "dataCount": 65,
            "pageLimit": 10
        }
	 */
	public abstract void responseCommentsType(JSONArray commentsTypeArray);
}
