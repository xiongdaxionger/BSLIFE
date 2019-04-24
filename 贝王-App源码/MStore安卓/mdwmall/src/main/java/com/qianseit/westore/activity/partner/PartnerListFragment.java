package com.qianseit.westore.activity.partner;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.shopping.ItemSearchView;
import com.qianseit.westore.activity.shopping.SearchCallback;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.viewHolder.ViewHolder;

import org.json.JSONArray;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;

/**
 * 会员列表
 */
public class PartnerListFragment extends BaseListFragment<PartnerInfo> {

    ///是否可以搜索key
    public static final String SEARCH_ENABLE_KEY = "searchEnable";

    ///是否是选择会员key
    public static final String SELECT_PARTNER_KEY = "selectPartner";

    ///添加会员广播action
    public static final String PARTNER_ADD_ACTION = "partnerAdd";

    ///搜索关键字
    private String mKeyword;

    ///层级
    private int hierarchy;

    ///是否可以搜索
    private boolean mSearchEnable = false;

    ///是否是选择会员
    private boolean mSelectPartner = false;

//    标题
    private TextView title_textView;

    @Override
    protected List<PartnerInfo> fetchDatas(JSONObject responseJson) {

        if(title_textView != null){
            JSONObject nPageJsonObject = responseJson.optJSONObject("pager");
            int count = nPageJsonObject.optInt("dataCount");
            title_textView.setText("我的会员(" + count + ")");
        }

        hierarchy = responseJson.optInt("show_lv");
        ///从json中获取会员列表信息

        JSONArray list = responseJson.optJSONArray("List");
        ArrayList<PartnerInfo> infos = new ArrayList<PartnerInfo>(list.length());

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
        values.put("member_id", mLoginedUser.getMember().getMember_id());
        if(mKeyword != null){
            values.put("keyword", mKeyword);
        }
        return values;
    }

    @Override
    protected View getItemView(PartnerInfo responseJson, View convertView, ViewGroup parent) {
        if(convertView == null){
            convertView = View.inflate(mActivity, R.layout.partner_list_item, null);

            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    PartnerInfo info = (PartnerInfo)v.getTag();
                    if(mSelectPartner){
                        ///选择会员
                        Intent intent = new Intent();
                        intent.putExtra(PartnerDetailFragment.PARTNER_INFO_KEY, info);
                        mActivity.setResult(Activity.RESULT_OK, intent);
                        mActivity.finish();

                    }else {
                        ///查看会员详情
                        startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PARTNR_DETAIL)
                                .putExtra(PartnerDetailFragment.PARTNER_INFO_KEY, info));
                    }
                }
            });
        }

        ImageView imageView = ViewHolder.get(convertView, R.id.header);
        displayCircleImage(imageView, responseJson.headImageURL);

        TextView textView = ViewHolder.get(convertView, R.id.name);
        textView.setText(responseJson.name);

        textView = ViewHolder.get(convertView, R.id.referral_num);
        textView.setText("团队" + responseJson.referral + "人");

        textView = ViewHolder.get(convertView, R.id.amount);
        textView.setText(responseJson.earnAmount);

        convertView.setTag(responseJson);

        return convertView;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        shouldRefresh = false;
        Intent intent = mActivity.getIntent();
        mSearchEnable = intent.getBooleanExtra(SEARCH_ENABLE_KEY, false);
        mSelectPartner = intent.getBooleanExtra(SELECT_PARTNER_KEY, false);

        mActionBar.setShowBackButton(true);
        if(!mSearchEnable){
            View titleView = View.inflate(mActivity, R.layout.partner_list_title_view, null);
            title_textView = (TextView)titleView.findViewById(R.id.bar_title);
            ImageView searchImageView = (ImageView)titleView.findViewById(R.id.search_btn);
            searchImageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    ///搜索会员
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PARTNR_LIST)
                            .putExtra(SEARCH_ENABLE_KEY, true)
                            .putExtra(SELECT_PARTNER_KEY, mSelectPartner));

                }
            });

            mActionBar.setCustomTitleView(titleView);
            mActionBar.setRightImageButton(R.drawable.add_gray, new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    ///添加会员
                    startActivity(AgentActivity.FRAGMENT_ACCO_NEW_CUSTOMER);
                }
            });

        }else {

            AutoLoad(false);
            ///添加搜索栏
            ItemSearchView searchView = new ItemSearchView(mActivity);
            searchView.setSearchCallback(new SearchCallback() {
                @Override
                public void search(String searchKey) {

                    if(TextUtils.isEmpty(searchKey)){
                        Run.alert(mActivity, "请输入搜索内容");
                        return;
                    }
                    mKeyword = searchKey;
                    onRefresh();
                }
            });
            searchView.setHint("手机号、账号、姓名");
            mActionBar.setCustomTitleView(searchView);
            mActionBar.getRightButton().setVisibility(View.GONE);
            mActionBar.getRightLinear().setVisibility(View.GONE);
            mActionBar.getRightImageButton().setVisibility(View.GONE);
            mActionBar.getRightSearchView().setVisibility(View.GONE);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        ///搜索选择会员完成
        if(data.getParcelableExtra(PartnerDetailFragment.PARTNER_INFO_KEY) != null) {

            mActivity.setResult(Activity.RESULT_OK, data);
            mActivity.finish();
        }
    }

    ///是否需要刷新
    private static boolean shouldRefresh = false;

    ///添加会员监听
    public static class PartnerAddReceiver extends BroadcastReceiver{

        @Override
        public void onReceive(Context context, Intent intent) {

            if(intent.getAction().equals(PARTNER_ADD_ACTION)){
                ///收到添加会员通知
                shouldRefresh = true;
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if(shouldRefresh){
            onRefresh();
        }
    }
}
