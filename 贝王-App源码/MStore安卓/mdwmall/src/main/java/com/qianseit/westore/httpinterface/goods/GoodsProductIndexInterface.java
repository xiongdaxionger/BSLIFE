package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

public abstract class GoodsProductIndexInterface extends BaseHttpInterfaceTask implements ProductIndexHandler {

	String mProductIdString;
	String mType = "product";

	public void setProductIdString(String productIdString, boolean isGift) {
		this.mProductIdString = productIdString;
		mType = isGift ? "gift" : "product";
	}

	public GoodsProductIndexInterface(QianseitActivityInterface activityInterface, String productId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mProductIdString = productId;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("product_id", mProductIdString);
		nContentValues.put("type", mType);
		return nContentValues;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.index";
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		ResponseData(responseJson);
		ResponseBtns(responseJson.optJSONArray("btn_page_list"));
		ResponseSetting(responseJson.optJSONObject("setting"));
		ResponseBasic(responseJson.optJSONObject("page_product_basic"));
		ResponseParts(responseJson.optJSONArray("page_goods_adjunct"), responseJson.optJSONObject("adjunct_images"));
		ResponseDIYTab(responseJson.optJSONArray("async_request_list"));
	}
}
