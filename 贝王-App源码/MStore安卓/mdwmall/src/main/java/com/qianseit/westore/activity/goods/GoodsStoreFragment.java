package com.qianseit.westore.activity.goods;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.viewHolder.ViewHolder;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * 商品存放记录
 */

public class GoodsStoreFragment extends BaseListFragment<JSONObject> {

    @Override
    protected void init() {
        super.init();
        mActionBar.setShowTitleBar(false);
        mListView.setBackgroundColor(ContextCompat.getColor(mActivity, R.color.fragment_background_color));
        mListView.setDividerHeight(0);
    }

    @Override
    protected void addFooter(XPullDownListView listView) {

        View view = new View(mActivity);
        AbsListView.LayoutParams params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, Run
                .dip2px(mActivity, 10));
        view.setLayoutParams(params);
        listView.addFooterView(view);
    }

    @Override
    protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {

        if(convertView == null){
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.goods_access_record_list_item, parent, false);
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    Bundle bundle = new Bundle();
                    JSONObject object = (JSONObject)v.getTag();
                    bundle.putString(Run.EXTRA_GOODS_ID, object.optString("goods_id"));
                    bundle.putString(Run.EXTRA_PRODUCT_ID, object.optString("product_id"));
                    startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, bundle);
                }
            });
        }

        convertView.setTag(responseJson);
        ImageView imageView = ViewHolder.get(convertView, R.id.icon);
        displaySquareImage(imageView, responseJson.optString("goods_img"));

        TextView textView = ViewHolder.get(convertView, R.id.name);
        textView.setText(responseJson.optString("name"));

        textView = ViewHolder.get(convertView, R.id.store);
        textView.setText(responseJson.optString("local_name"));

        textView = ViewHolder.get(convertView, R.id.time);
        textView.setText(StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", responseJson.optLong("create_time")));

        textView = ViewHolder.get(convertView, R.id.left_count);
        textView.setText(responseJson.optInt("nums") + "");

        return convertView;
    }

    @Override
    protected List<JSONObject> fetchDatas(JSONObject responseJson) {
        JSONArray array = responseJson.optJSONArray("list");

        ArrayList<JSONObject> objects = new ArrayList<>();
        if(array != null){
            for(int i = 0;i < array.length();i ++){
                objects.add(array.optJSONObject(i));
            }
        }

        return objects;
    }

    @Override
    protected String requestInterfaceName() {
        return "b2c.member.access";
    }
}
