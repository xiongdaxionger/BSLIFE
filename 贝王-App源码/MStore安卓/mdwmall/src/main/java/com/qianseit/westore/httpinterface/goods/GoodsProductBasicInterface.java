package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

/**
 * 2.5 货品基本信息 HTTP请求方式：POST 该接口在选择规格时候触发
 * 
 * @author qianseit
 * 
 */
public abstract class GoodsProductBasicInterface extends BaseHttpInterfaceTask implements ProductBasicHandler {
	String mProductIdString;
	boolean mIsGift = false;

	public GoodsProductBasicInterface(QianseitActivityInterface activityInterface, String productIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mProductIdString = productIdString;
	}

	public void setProductId(String productIdString) {
		setProductId(productIdString, false);
	}

	public void setProductId(String productIdString, boolean isGift) {
		mProductIdString = productIdString;
		mIsGift = isGift;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.basic";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValuess = new ContentValues();
		nContentValuess.put("product_id", mProductIdString);
		nContentValuess.put("type", mIsGift ? "gift" : "product");
		return nContentValuess;
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		ResponseBasic(responseJson.optJSONObject("page_product_basic"));
		ResponseBtns(responseJson.optJSONArray("btn_page_list"));
		ResponseSetting(responseJson.optJSONObject("setting"));
	}
}
