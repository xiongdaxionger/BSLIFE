package com.qianseit.westore.activity.goods;

import android.content.Context;
import android.text.TextUtils;

import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsUtil {
	public static final String SPOOR_ID_KEY = "goods#spooridkey";
	public static final String SPOOR_GOODS_KEY = "goods#[%s]";
	public static final String GOODS_SEARCH_KEY = "goods#searchkey";

	/**
	 * 选中数量
	 */
	public final static String CHOOSED_QTY = "choosed_qty";

	/**
	 * 格式化已选中规格
	 * 
	 * @param specArray
	 * @return颜色：红色，尺码：41
	 */
	public static String formatChoosedSpec(JSONArray specArray) {
		if (specArray == null || specArray.length() <= 0) {
			return "";
		}

		StringBuilder nChoosedSpecBuilder = new StringBuilder();
		for (int i = 0; i < specArray.length(); i++) {
			JSONObject nJsonObject = specArray.optJSONObject(i);
			nChoosedSpecBuilder.append(nJsonObject.optString("group_name")).append("：");

			JSONArray nSpecGroupArray = nJsonObject.optJSONArray("group_spec");
			for (int j = 0; j < nSpecGroupArray.length(); j++) {
				JSONObject nJsonObject2 = nSpecGroupArray.optJSONObject(j);
				if (nJsonObject2.optBoolean("select")) {
					nChoosedSpecBuilder.append(nJsonObject2.optString("spec_value")).append("，");
					break;
				}
			}
		}
		if (nChoosedSpecBuilder.length() > 0) {
			nChoosedSpecBuilder.delete(nChoosedSpecBuilder.length() - 1, nChoosedSpecBuilder.length());
		}

		String nChoosedString = nChoosedSpecBuilder.toString();
		nChoosedSpecBuilder.delete(0, nChoosedSpecBuilder.length());
		return nChoosedString;
	}
	
	/**
	 * @param productJsonObject
	 * @return
	 * -1.非预售
	 * 1.预订中，请在xx前支付订金参与活动
	 * 2.预售商品已售罄，已支付订金的会员请等待支付尾款.
	 * 3.活动已结束，已预订的会员请在xx至xx内我的预售订单中支付尾款
	 * 4.活动已结束，已预订的会员请在xxxx前我的预售订单中支付尾款
	 * 5.预售活动结束
	 * 6.预售活动还没有开始,敬请等待开始！
	 * 7.活动已结束，已预订的会员请在xx至xx内我的预售订单中支付尾款
	 */
	public static int getPrepareStatus(JSONObject productJsonObject){
		int nStatus = -1;
		if(productJsonObject == null || productJsonObject.isNull("prepare")){
			return nStatus;
		}
		
		JSONObject nPrepareJsonObject = productJsonObject.optJSONObject("prepare");
		if (nPrepareJsonObject == null || nPrepareJsonObject.isNull("status")) {
			return nStatus;
		}
		
		return nPrepareJsonObject.optInt("status");
	}
	
	public static void putSearchValue(Context context, String searchValue) {
		String nSpoorIdList = Util.loadOptionString(context, GOODS_SEARCH_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			Util.savePrefs(context, GOODS_SEARCH_KEY, searchValue);
		} else {
			StringBuilder nBuilder = new StringBuilder();
			String[] nStrings = nSpoorIdList.split(",");
			for (int i = nStrings.length - 1; i >= 0; i--) {
				if (i < 29 && !nStrings[i].equals(searchValue)) {
					nBuilder.insert(0, nStrings[i]).insert(0, ",");
				}
			}
			nBuilder.insert(0, searchValue);

			Util.savePrefs(context, GOODS_SEARCH_KEY, nBuilder.toString());
		}
	}

	public static List<String> getSearchVaue(Context context) {
		List<String> nStrings = new ArrayList<String>();
		String nSpoorIdList = Util.loadOptionString(context, GOODS_SEARCH_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			return nStrings;
		}

		String[] nStrings1 = nSpoorIdList.split(",");
		for (String string : nStrings1) {
			nStrings.add(string);
		}
		return nStrings;
	}

	public static void clearSearchValue(Context context) {
		Util.removeOption(context, GOODS_SEARCH_KEY);
	}

	public static void putSpoor(Context context, JSONObject productJsonObject) {
		String nGoodsId = productJsonObject.optString("goods_id");
		String nSpoorIdList = Util.loadOptionString(context, SPOOR_ID_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			Util.savePrefs(context, SPOOR_ID_KEY, nGoodsId);
			Util.savePrefs(context, String.format(SPOOR_GOODS_KEY, nGoodsId), productJsonObject.toString());
		} else {
			StringBuilder nBuilder = new StringBuilder();
			String[] nStrings = nSpoorIdList.split(",");
			for (int i = nStrings.length - 1; i >= 0; i--) {
				if (i >= 19 || nStrings[i].equals(nGoodsId)) {
					Util.removeOption(context, String.format(SPOOR_GOODS_KEY, nStrings[i]));
				} else {
					nBuilder.insert(0, nStrings[i]).insert(0, ",");
				}
			}
			nBuilder.insert(0, nGoodsId);

			Util.savePrefs(context, String.format(SPOOR_GOODS_KEY, nGoodsId), productJsonObject.toString());
			Util.savePrefs(context, SPOOR_ID_KEY, nBuilder.toString());

		}
	}

	public static List<JSONObject> getSpoor(Context context) {
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		String nSpoorIdList = Util.loadOptionString(context, SPOOR_ID_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			return nJsonObjects;
		}

		String[] nStrings = nSpoorIdList.split(",");
		try {
			for (String string : nStrings) {
				nJsonObjects.add(new JSONObject(Util.loadOptionString(context, String.format(SPOOR_GOODS_KEY, string), "")));
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return nJsonObjects;
	}

	public static void clearSpoor(Context context) {
		String nSpoorIdList = Util.loadOptionString(context, SPOOR_ID_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			return;
		}

		String[] nStrings = nSpoorIdList.split(",");
		for (String string : nStrings) {
			Util.removeOption(context, String.format(SPOOR_GOODS_KEY, string));
		}
		Util.removeOption(context, SPOOR_ID_KEY);
	}

	public static void deleteSpoor(Context context, JSONObject productJsonObject) {
		String nGoodsId = productJsonObject.optString("goods_id");
		String nSpoorIdList = Util.loadOptionString(context, SPOOR_ID_KEY, "");
		if (TextUtils.isEmpty(nSpoorIdList)) {
			return;
		} else {
			StringBuilder nBuilder = new StringBuilder();
			String[] nStrings = nSpoorIdList.split(",");
			for (int i = nStrings.length - 1; i >= 0; i--) {
				if (i >= 19 || nStrings[i].equals(nGoodsId)) {
					Util.removeOption(context, String.format(SPOOR_GOODS_KEY, nStrings[i]));
				} else {
					nBuilder.insert(0, nStrings[i]).insert(0, ",");
				}
			}
			if (nBuilder.length() > 0) {
				nBuilder.delete(0, 1);
			}

			Util.savePrefs(context, SPOOR_ID_KEY, nBuilder.toString());
		}
	}
}
