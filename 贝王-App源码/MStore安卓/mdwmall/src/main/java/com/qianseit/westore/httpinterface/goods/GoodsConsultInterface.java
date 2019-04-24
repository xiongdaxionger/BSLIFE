package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import org.json.JSONArray;
import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 2.10 商品咨询列表第一页
 * @author qianseit
 *
 */
public abstract class GoodsConsultInterface extends BaseHttpInterfaceTask {
	String mGoodsId;

	public GoodsConsultInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.goodsConsult";
	}
	
	public void loadFirstPage(String goodsId){
		mGoodsId = goodsId;
		RunRequest();
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject nComments = responseJson.optJSONObject("comments");
		responsePageInfo(responseJson.optJSONObject("pager"));
		
		if (nComments != null) {
			responseSetting(nComments.optJSONObject("setting"));
			responseAskType(nComments.optJSONArray("gask_type"));
			responseAsk(nComments.optJSONObject("list").optJSONArray("ask"));
		}
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsId);
		return nContentValues;
	}
	
	public abstract void responseAsk(JSONArray askArray);
	/**
	 * {
                "switch_reply": "on",
                "verifyCode": "http://zj.qianseit.com/index.php/index-gen_vcode-REPLYVCODE.html",
                "submit_comment_notice": "如果有更多问题，您可以拨打客服电话",
                "submit_comment_notice_tel": "22-333-33",
                "submit_notice": "您的问题已经提交成功!",
                "login": "nologin",
                "power_status": true,
                "display": "true",
                "power_message": null
            }
	 */
	public abstract void responseSetting(JSONObject settingJsonObject);
	/**
	 * [
                {
                    "type_id": 0,
                    "name": "全部咨询",
                    "total": 65
                },
                {
                    "type_id": 1,
                    "name": "商品咨询",
                    "total": 55
                },
                {
                    "type_id": 1464146190192,
                    "name": "困难咨询",
                    "total": 10
                }
            ]
	 */
	public abstract void responseAskType(JSONArray askTypeArray);
	/**
	 * {
            "current": 1,
            "total": 7,
            "dataCount": 65,
            "pageLimit": 10
        }
	 */
	public abstract void responsePageInfo(JSONObject pageInfoJsonObject);
}
