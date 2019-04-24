package com.qianseit.westore.activity.partner;

import android.text.TextUtils;

import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * 订单信息
 */

public class OrderInfo {

    ///订单id
    String orderId;

    ///时间
    String time;

    ///订单状态
    String status;

    ///商品名称
    String goodName;

    ///商品图片
    String goodImageURL;

    ///实付款
    String realPrice;

    public OrderInfo(JSONObject object){

        orderId = object.optString("order_id");
        time = StringUtils.LongTimeToLongString(object.optLong("createtime"));

        ///订单状态
        StringBuilder stringBuilder = new StringBuilder();
        JSONArray statusArray = object.optJSONArray("status_txt");
        for(int i = 0;i < statusArray.length();i ++){
            JSONObject statusObject = statusArray.optJSONObject(i);
            String value = statusObject.optString("name");
            if(value != null){
                stringBuilder.append(value);
            }
        }

        ///商品信息
        status = stringBuilder.toString();
        JSONArray goodItems = object.optJSONArray("goods_items");
        if(goodItems.length() > 0){
            JSONObject goodObject = goodItems.optJSONObject(0);
            goodName = goodObject.optString("name");
            goodImageURL = goodObject.optString("thumbnail_pic");
        }

        realPrice = object.optString("cur_amount");
        if(TextUtils.isEmpty(realPrice)){
            realPrice = object.optString("total_amount");
        }
    }
}
