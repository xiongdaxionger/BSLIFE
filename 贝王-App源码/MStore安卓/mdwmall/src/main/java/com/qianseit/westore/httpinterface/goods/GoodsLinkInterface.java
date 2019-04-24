package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;

import org.json.JSONArray;
import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 2.2 相关商品展示
 * @author qianseit
 *
 */
public abstract class GoodsLinkInterface extends BaseHttpInterfaceTask {
	String mGoodsIdString;
	
	public GoodsLinkInterface(QianseitActivityInterface activityInterface, String goodsIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mGoodsIdString = goodsIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.goodsLink";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsIdString);
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (responseJson.isNull("page_goodslink")) {
			responseGoodsLink(null, null);
			return;
		}
		
		JSONObject nJsonObject = responseJson.optJSONObject("page_goodslink");
		if (nJsonObject.isNull("link")) {
			responseGoodsLink(null, null);
			return;
		}
		
		JSONArray nArray = nJsonObject.optJSONArray("link");
		if (nArray.length() <= 0) {
			responseGoodsLink(null, null);
			return;
		}
		
		responseGoodsLink(nArray, nJsonObject.optJSONObject("products"));
	}

	/**
	 *  返回相关商品
	 * @param linkArray
	 * @param productDic 货品字典，根据goods_id查
	 */
	public abstract void responseGoodsLink(JSONArray linkArray, JSONObject productDic);
}
