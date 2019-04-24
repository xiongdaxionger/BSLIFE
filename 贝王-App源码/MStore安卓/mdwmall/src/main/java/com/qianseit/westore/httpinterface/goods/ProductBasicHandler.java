package com.qianseit.westore.httpinterface.goods;

import org.json.JSONArray;
import org.json.JSONObject;

public interface ProductBasicHandler {

	/**
	 * 返回配置信息
	 * @param jsonObject
	 */
    void ResponseSetting(JSONObject jsonObject);
	/**
	 * 按钮列表：到货通知、立即购买、加入购物车
	 * [
            {
                "name": "立即购买按钮",
                "value": "fastbuy"
            },
            {
                "name": "加入购物车按钮",
                "value": "buy"
            }
            {
                "name": "到货通知",
                "value": "notify"
            }
        ]
	 * @param btnArray
	 */
    void ResponseBtns(JSONArray btnArray);
	
	/**
	 * 商品基本信息
	 * @param basicJsonObject
	 */
    void ResponseBasic(JSONObject basicJsonObject);
}
