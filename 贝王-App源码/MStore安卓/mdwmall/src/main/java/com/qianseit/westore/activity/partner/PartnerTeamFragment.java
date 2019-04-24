package com.qianseit.westore.activity.partner;

import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.viewHolder.ViewHolder;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * 会员团队
 */

public class PartnerTeamFragment extends BaseListFragment<PartnerInfo> {

    ///会员id
    String mUserId;

    ///层级 小于等于1时无法查看团队
    private int mHierarchy;

    @Override
    protected View getItemView(PartnerInfo responseJson, View convertView, ViewGroup parent) {

        if(convertView == null){
            convertView = View.inflate(mActivity, R.layout.partner_team_list_item, null);
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    PartnerInfo info = (PartnerInfo)v.getTag();
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PARTNR_DETAIL)
                    .putExtra(PartnerDetailFragment.PARTNER_INFO_KEY, info)
                    .putExtra(PartnerDetailFragment.HIERARCHY_KEY, mHierarchy - 1));
                }
            });
        }

        ImageView imageView = ViewHolder.get(convertView, R.id.header);
        displayCircleImage(imageView, responseJson.headImageURL);

        TextView textView = ViewHolder.get(convertView, R.id.name);
        textView.setText(responseJson.name);

        textView = ViewHolder.get(convertView, R.id.order_num);
        textView.setText(responseJson.getOrderCountHtml());

        textView = ViewHolder.get(convertView, R.id.amount);
        textView.setText(responseJson.getOrderCountHtml());

        convertView.setTag(responseJson);

        return convertView;
    }

    @Override
    protected List<PartnerInfo> fetchDatas(JSONObject responseJson) {

        ///从json中获取会员列表信息

        JSONArray list = responseJson.optJSONArray("List");
        ArrayList<PartnerInfo> infos = new ArrayList<>(list.length());

        for(int i = 0;i < list.length();i ++){

            JSONObject object = list.optJSONObject(i);
            infos.add(new PartnerInfo(object));
        }

        return infos;
    }

    @Override
    protected String requestInterfaceName() {

        return "distribution.fxmem.all_members";
    }

    @Override
    protected ContentValues extentConditions() {

        ContentValues values = new ContentValues();
        values.put("member_id", mUserId);
        return values;
    }

    @Override
    public void setArguments(Bundle args) {
        super.setArguments(args);

        mUserId = args.getString(PartnerDetailFragment.USERID_KEY);
        mHierarchy = args.getInt(PartnerDetailFragment.HIERARCHY_KEY);
    }

    @Override
    protected void init() {
        super.init();
        mActionBar.setShowTitleBar(false);
    }
}
