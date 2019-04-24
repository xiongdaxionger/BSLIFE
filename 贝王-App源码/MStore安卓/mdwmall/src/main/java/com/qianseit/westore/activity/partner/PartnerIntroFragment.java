package com.qianseit.westore.activity.partner;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;
import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.BaseLocalListFragment;
import com.qianseit.westore.base.viewHolder.ViewHolder;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 会员简介
 */

public class PartnerIntroFragment extends BaseLocalListFragment<HashMap<String, String>> {

    ///会员信息
    PartnerInfo mPartnerInfo;

    @Override
    protected List<HashMap<String, String>> buildLocalItems() {

        ArrayList<HashMap<String, String>> list = new ArrayList<>(5);

        HashMap<String, String> map = new HashMap<>(2);
        map.put("title", "累计下单：");
        map.put("content", String.valueOf(mPartnerInfo.orderCount));
        list.add(map);

        map = new HashMap<>(2);
        map.put("title", "带来收益：");
        map.put("content", mPartnerInfo.earnAmount);
        list.add(map);

        map = new HashMap<>(2);
        map.put("title", "联系电话：");
        map.put("content", mPartnerInfo.mobile);
        list.add(map);

        map = new HashMap<>(2);
        map.put("title", "收货地区：");
        map.put("content", mPartnerInfo.area);
        list.add(map);

        map = new HashMap<>(2);
        map.put("title", "注册时间：");
        map.put("content", mPartnerInfo.registerTime);
        list.add(map);

        return list;
    }

    @Override
    protected View getItemView(HashMap<String, String> responseJson, View convertView, ViewGroup parent) {

        if(convertView == null){
            convertView = View.inflate(mActivity, R.layout.partner_intro_list_item, null);
        }

        TextView textView = ViewHolder.get(convertView, R.id.title_textView);
        textView.setText(responseJson.get("title"));

        textView = ViewHolder.get(convertView, R.id.content_textView);
        textView.setText(responseJson.get("content"));

        return convertView;
    }

    @Override
    protected void addHeader(ListView listView) {

        View header = new View(mActivity);
        header.setBackgroundColor(Color.TRANSPARENT);
        header.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
                Run.dip2px(mActivity, 10)));
        listView.addHeaderView(header);
    }

    @Override
    protected void addFooter(ListView listView) {
        super.addFooter(listView);
    }

    @Override
    public void setArguments(Bundle args) {
        super.setArguments(args);

        mPartnerInfo = args.getParcelable(PartnerDetailFragment.PARTNER_INFO_KEY);
    }

    @Override
    protected void init() {
        super.init();
        mListView.setBackgroundColor(ContextCompat.getColor(mActivity, R.color.fragment_background_color));
        mListView.setDividerHeight(0);
        mActionBar.setShowTitleBar(false);
    }
}
