package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnGroupClickListener;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsConsultRecordFragment extends BaseExpandListFragment<JSONObject, JSONObject> {
    final int REQUEST_REPLY = 0x02;
    long mTypeId = 0;
    String mGoodsId;
    JSONObject mSettingJsonObject;

    boolean mCanReply = true, mCanPublish = true, mNeedCheck = false;

    SparseArray<List<JSONObject>> mMoreChildArray = new SparseArray<List<JSONObject>>();
    String mReplyContentFormat = "<font color=\"#333333\">%s：</font><font color=\"#808080\">%s</font>";

    int mPaddingLeft = 0;
    int mPaddingRight = 0;
    int mPaddingTop = 0;
    int mPaddingBottom = 0;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle nBundle = getArguments();
        mTypeId = nBundle.getLong(Run.EXTRA_DETAIL_TYPE);
        mGoodsId = nBundle.getString(Run.EXTRA_GOODS_ID);
        try {
            mSettingJsonObject = new JSONObject(nBundle.getString(Run.EXTRA_DATA));
            mCanReply = mSettingJsonObject.optString("switch_reply").equalsIgnoreCase("on");
            mCanPublish = mSettingJsonObject.optBoolean("power_status");
            mNeedCheck = mSettingJsonObject.optBoolean("display");
        } catch (JSONException e) {
            e.printStackTrace();
            mSettingJsonObject = new JSONObject();
        }
    }

    @Override
    protected ContentValues extentConditions() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        nContentValues.put("goods_id", mGoodsId);
        nContentValues.put("type_id", String.valueOf(mTypeId));
        return nContentValues;
    }

    @Override
    protected List<ExpandListItemBean<JSONObject, JSONObject>> fetchDatas(JSONObject responseJson) {
        // TODO Auto-generated method stub
        if (mPageNum == 1) {
            mMoreChildArray.clear();
        }

        List<ExpandListItemBean<JSONObject, JSONObject>> nBeans = new ArrayList<ExpandListItemBean<JSONObject, JSONObject>>();
        JSONObject nCommentsJsonObject = responseJson.optJSONObject("comments");
        if (nCommentsJsonObject == null || nCommentsJsonObject.isNull("list")) {
            return nBeans;
        }

        JSONArray nArray = nCommentsJsonObject.optJSONObject("list").optJSONArray("ask");
        if (nArray == null || nArray.length() <= 0) {
            return nBeans;
        }
        for (int i = 0; i < nArray.length(); i++) {
            ExpandListItemBean<JSONObject, JSONObject> nBean = new ExpandListItemBean<JSONObject, JSONObject>();
            nBean.mGrupItem = nArray.optJSONObject(i);
            JSONArray nArray2 = nBean.mGrupItem.optJSONArray("items");
            if (nArray2 != null && nArray2.length() > 0) {
                for (int j = 0; j < nArray2.length(); j++) {
                    if (j >= 2) {
                        int nKey = nBean.mGrupItem.hashCode();
                        if (mMoreChildArray.get(nKey) == null) {
                            mMoreChildArray.put(nKey, new ArrayList<JSONObject>());
                        }
                        mMoreChildArray.get(nKey).add(nArray2.optJSONObject(j));
                    } else {
                        nBean.mDetailLists.add(nArray2.optJSONObject(j));
                    }
                }
            }
            nBeans.add(nBean);
        }

        return nBeans;
    }

    @Override
    protected View getGroupItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, boolean isExpanded, View convertView,
                                    ViewGroup parent) {
        // TODO Auto-generated method stub
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_goods_consult_parent, null);
            convertView.findViewById(R.id.reply).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nConsultJsonObject = (JSONObject) v.getTag();
                    Bundle nBundle = new Bundle();
                    nBundle.putString(Run.EXTRA_DATA, mSettingJsonObject.toString());
                    nBundle.putString(Run.EXTRA_VALUE, nConsultJsonObject != null ? nConsultJsonObject.toString() : new
							JSONArray().toString());
                    startActivityForResult(AgentActivity.FRAGMENT_SHOPP_GOODS_CONSULT_REPLY, nBundle, REQUEST_REPLY);
                }
            });
            convertView.findViewById(R.id.reply).setVisibility(mCanReply ? View.VISIBLE : View.GONE);
        }

        convertView.findViewById(R.id.reply).setTag(groupBean.mGrupItem);

        String nLv = groupBean.mGrupItem.optString("member_lv_name");
        TextView nLvTextView = (TextView) convertView.findViewById(R.id.lv);
        nLvTextView.setText(groupBean.mGrupItem.optString("member_lv_name"));
        nLvTextView.setVisibility(TextUtils.isEmpty(nLv) || nLv.equalsIgnoreCase("null") ? View.GONE : View.VISIBLE);

        ((TextView) convertView.findViewById(R.id.nickname)).setText(groupBean.mGrupItem.optString("author"));
        ((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.friendlyFormatTime(groupBean.mGrupItem.optLong
				("time")));
        ((TextView) convertView.findViewById(R.id.comment)).setText(groupBean.mGrupItem.optString("comment"));

        int nPosition = mResultLists.indexOf(groupBean);
        convertView.findViewById(R.id.divider).setVisibility(nPosition == 0 ? View.INVISIBLE : View.VISIBLE);

        if (groupBean.mDetailLists.size() > 0) {
            convertView.setPadding(mPaddingLeft, 0, mPaddingRight, 0);
        } else {
            convertView.setPadding(mPaddingLeft, 0, mPaddingRight, mPaddingBottom);
        }

        return convertView;
    }

    @Override
    protected View getDetailItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, JSONObject detailBean, boolean
			isLastChild, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_goods_consult_child, null);

            final TextView moreView = (TextView) convertView.findViewById(R.id.more);
            moreView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    int nPosition = (Integer) v.getTag();

                    int nKey = mResultLists.get(nPosition).mGrupItem.hashCode();
                    if (mResultLists.get(nPosition).mDetailLists.size() <= 2) {
                        mResultLists.get(nPosition).mDetailLists.addAll(mMoreChildArray.get(nKey));
                    } else {
                        mResultLists.get(nPosition).mDetailLists.removeAll(mMoreChildArray.get(nKey));
                    }
                    mAdatpter.notifyDataSetChanged();

                }
            });
        }

        TextView nameTextView = (TextView) convertView.findViewById(R.id.admin);
        nameTextView.setText(detailBean.optString("author"));

        TextView contentTextView = (TextView) convertView.findViewById(R.id.replay_content);
        contentTextView.setText(detailBean.optString("comment"));


        TextView nMoreView = (TextView) convertView.findViewById(R.id.more);
        int nPosition = mResultLists.indexOf(groupBean);
        nMoreView.setTag(nPosition);

        int nKey = mResultLists.get(nPosition).mGrupItem.hashCode();
        nMoreView.setVisibility(isLastChild && mMoreChildArray.get(nKey) != null ? View.VISIBLE :
                View.GONE);
        nMoreView.setText(mResultLists.get(nPosition).mDetailLists.size() > 2 ? "点击收起" : "点击查看更多");

        if (!isLastChild) {
            convertView.setPadding(mPaddingLeft, 0, mPaddingRight, 0);
        } else {
            convertView.setPadding(mPaddingLeft, 0, mPaddingRight, mPaddingBottom);
        }

        return convertView;
    }

    @Override
    protected void initActionBar() {
        // TODO Auto-generated method stub
        mActionBar.setShowTitleBar(false);
    }

    @Override
    public void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        if (resultCode == Activity.RESULT_OK) {
            onRefresh();
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void init() {
        // TODO Auto-generated method stub
        mListView.setDividerHeight(0);
        setEmptyImage(R.drawable.empty_consult);
        setEmptyText("如果您对本商品有什么问题,请提问咨询!");
        mPaddingBottom = Run.dip2px(mActivity, 15);
        mPaddingTop = Run.dip2px(mActivity, 15);
        mPaddingLeft = Run.dip2px(mActivity, 15);
        mPaddingRight = Run.dip2px(mActivity, 15);
        mListView.setOnGroupClickListener(new OnGroupClickListener() {

            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                // TODO Auto-generated method stub
                return true;
            }
        });
    }

    @Override
    protected String requestInterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.comment.getAsk";
    }

}