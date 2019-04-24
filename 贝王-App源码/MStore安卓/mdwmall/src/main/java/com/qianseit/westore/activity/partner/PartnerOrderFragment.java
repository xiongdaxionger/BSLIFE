package com.qianseit.westore.activity.partner;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.viewHolder.ViewHolder;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * 会员订单
 */

public class PartnerOrderFragment extends BaseListFragment<OrderInfo> {

    ///会员id
    String mUserId;

    @Override
    protected View getItemView(OrderInfo responseJson, View convertView, ViewGroup parent) {

        if(convertView == null){
            convertView = View.inflate(mActivity, R.layout.partner_order_list_item, null);
        }

        ImageView imageView = ViewHolder.get(convertView, R.id.good_imageView);
        displayCircleImage(imageView, responseJson.goodImageURL);

        TextView textView = ViewHolder.get(convertView, R.id.time_textView);
        textView.setText(responseJson.time);

        textView = ViewHolder.get(convertView, R.id.status_textView);
        textView.setText(responseJson.status);

        textView = ViewHolder.get(convertView, R.id.name_textView);
        textView.setText(responseJson.goodName);

        textView = ViewHolder.get(convertView, R.id.amount_textView);
        textView.setText("实付款：" + responseJson.realPrice);

        return convertView;
    }

    @Override
    protected List<OrderInfo> fetchDatas(JSONObject responseJson) {

        JSONArray orders = responseJson.optJSONArray("orders");
        ArrayList<OrderInfo> infos = new ArrayList<>(orders.length());

        for(int i = 0;i < orders.length();i ++){
            JSONObject object = orders.optJSONObject(i);
            infos.add(new OrderInfo(object));
        }

        return infos;
    }

    @Override
    protected String requestInterfaceName() {
        return "b2c.member.orders";
    }

    @Override
    protected ContentValues extentConditions() {

        ContentValues values = new ContentValues(3);
        values.put("member_id", mUserId);
        values.put("order_status", "all");
        values.put("false", "is_fx");

        return values;
    }

    @Override
    public void setArguments(Bundle args) {
        super.setArguments(args);

        mUserId = args.getString(PartnerDetailFragment.USERID_KEY);
    }

    @Override
    protected void init() {
        super.init();
        mActionBar.setShowTitleBar(false);
    }
}
