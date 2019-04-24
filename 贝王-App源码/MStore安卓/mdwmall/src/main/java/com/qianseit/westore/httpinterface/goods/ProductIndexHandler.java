package com.qianseit.westore.httpinterface.goods;

import org.json.JSONArray;
import org.json.JSONObject;

public interface ProductIndexHandler extends ProductBasicHandler {

	/**
	 * 返回商品数据
	 * @param jsonObject
	 */
	void ResponseData(JSONObject jsonObject);

	/**
	 * 返回商品商品配件信息
	 * @param array
	 * @param imageJsonObject配件图片，相当于一个字典，根据goods_id取
	 */
	void ResponseParts(JSONArray array, JSONObject imageJsonObject);
	/**
	 * 返回自定义tab
	 * @param array
	 */
	void ResponseDIYTab(JSONArray array);
}
