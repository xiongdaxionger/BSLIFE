package com.qianseit.westore.activity.community;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.article.ArticleAddPraiseDiscoverInterface;
import com.qianseit.westore.httpinterface.community.CommunityIndexInterface;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class CommunityFragment extends BaseDoFragment implements OnRefreshListener {
    final int REQUEST_DETAIL = 0x01;
    public final static String BSELOG = "com.qianse.log.BroadcastReceiverHelper";
    private PullToRefreshLayout mPullToRefreshLayout;
    ImageCycleView mCycleView;
    private static boolean isLogStatus = false;
    ArrayList<JSONObject> mAdArrayList = new ArrayList<JSONObject>();
    private LoginedUser mLoginedUser;
    JSONObject mCurJsonObject = null;
    JSONArray mNodeJsonArray;

    public static class BroadcastReceiverHelper extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(BSELOG)) {
                isLogStatus = false;
            }
        }

    }

    CommunityIndexInterface mIndexGetAllListInterface = new CommunityIndexInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            parseBanner(responseJson);
            parseHots(responseJson);
            parseNotes(responseJson);
        }

        @Override
        public void task_response(String json_str) {
            super.task_response(json_str);
            onLoadFinished();
        }
    };

    void parseHots(JSONObject responseJson) {
        mRecommendList.clear();
        JSONArray nArray = responseJson.optJSONArray("hots");
        if (nArray == null) {
            mRecommendAdapter.notifyDataSetChanged();
            return;
        }

        for (int i = 0; i < nArray.length(); i++) {
            mRecommendList.add(nArray.optJSONObject(i));
        }
        mRecommendAdapter.notifyDataSetChanged();
    }

    void parseNotes(JSONObject responseJson) {
        mModuleList.clear();
        mNodeJsonArray = responseJson.optJSONArray("nodes");
        if (mNodeJsonArray == null) {
            mModuleAdapter.notifyDataSetChanged();
            return;
        }

        for (int i = 0; i < mNodeJsonArray.length(); i++) {
            mModuleList.add(mNodeJsonArray.optJSONObject(i));
        }
        mModuleAdapter.notifyDataSetChanged();
    }

    void parseBanner(JSONObject responseJson) {
        mAdArrayList.clear();

        JSONArray nDatas = responseJson.optJSONArray("slideBox");
        if (nDatas == null || nDatas.length() <= 0) {
            mCycleView.setVisibility(View.GONE);
            return;
        }

        JSONObject nDataJsonObject = nDatas.optJSONObject(0).optJSONObject("params");
        if (nDataJsonObject == null) {
            mCycleView.setVisibility(View.GONE);
            return;
        }

        JSONArray nItemArray = nDataJsonObject.optJSONArray("pic");
        if (nItemArray == null) {
            mCycleView.setVisibility(View.GONE);
            return;
        }
        double nScale = nDataJsonObject.optDouble("scale");
        if (nScale <= 1) {
            nScale = 1;
        }
        setViewAbsoluteHeight(mCycleView, (int) (Run.getWindowsWidth(mActivity) / nScale));

        for (int i = 0; i < nItemArray.length(); i++) {
            mAdArrayList.add(nItemArray.optJSONObject(i));
        }

        mCycleView.setVisibility(View.VISIBLE);
        mCycleView.setImageResources(mAdArrayList, mAdCycleViewListener);
    }

    private ImageCycleViewListener mAdCycleViewListener = new ImageCycleViewListener<JSONObject>() {

        @Override
        public void onImageClick(int position, View imageView) {
            JSONObject AvJSON = (JSONObject) imageView.getTag();
            onClickData(AvJSON);
        }

        @Override
        public void displayImage(JSONObject imageURLJson, ImageView imageView) {
            String imageUrl = imageURLJson.optString("link");
            displayRectangleImage(imageView, imageUrl);
        }
    };

    ListView mRecommendListView;
    List<JSONObject> mRecommendList = new ArrayList<JSONObject>();
    QianseitAdapter<JSONObject> mRecommendAdapter = new QianseitAdapter<JSONObject>(mRecommendList) {

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // TODO Auto-generated method stub
            if (convertView == null) {
                convertView = View.inflate(mActivity, R.layout.item_community_recommend, null);
                convertView.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        mCurJsonObject = (JSONObject) v.getTag();
                        Bundle nBundle = new Bundle();
                        nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
                        nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
                        startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
                    }
                });

                convertView.findViewById(R.id.comment).setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        mCurJsonObject = (JSONObject) v.getTag();
                        Bundle nBundle = new Bundle();
                        nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
                        nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
                        startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
                    }
                });

                convertView.findViewById(R.id.praise).setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        final JSONObject nJsonObject = (JSONObject) v.getTag();
                        new ArticleAddPraiseDiscoverInterface(CommunityFragment.this, nJsonObject.optString("article_id")) {

                            @Override
                            public void SuccCallBack(JSONObject responseJson) {
                                // TODO Auto-generated method stub
                                try {
                                    int nPraise = nJsonObject.optInt("praise_nums", 0);
                                    if (nJsonObject.optBoolean("ifpraise")) {
                                        nJsonObject.put("ifpraise", false);
                                        nJsonObject.put("praise_nums", nPraise - 1);
                                    } else {
                                        nJsonObject.put("ifpraise", true);
                                        nJsonObject.put("praise_nums", nPraise + 1);
                                    }
                                } catch (JSONException e) {
                                    // TODO Auto-generated catch block
                                    e.printStackTrace();
                                }
                                notifyDataSetChanged();
                            }
                        }.RunRequest();
                    }
                });
            }

            JSONObject nItem = getItem(position);
            ImageView img = (ImageView) convertView.findViewById(R.id.image);
            displayRectangleImage(img, nItem.optString("s_url"));
            ((TextView) convertView.findViewById(R.id.title)).setText(nItem.optString("title"));
            ((TextView) convertView.findViewById(R.id.category)).setText(nItem.optString("node_name"));

            convertView.findViewById(R.id.praise).setSelected(nItem.optBoolean("ifpraise"));
            ((TextView) convertView.findViewById(R.id.comment)).setText(nItem.optString("discuss_nums"));
            ((TextView) convertView.findViewById(R.id.praise)).setText(nItem.optString("praise_nums"));

            convertView.setTag(nItem);
            convertView.findViewById(R.id.praise).setTag(nItem);
            convertView.findViewById(R.id.comment).setTag(nItem);
            return convertView;
        }

        @Override
        public int getCount() {
            return mRecommendList.size();
        }
    };

    ListView mModuleListView;
    List<JSONObject> mModuleList = new ArrayList<JSONObject>();
    QianseitAdapter<JSONObject> mModuleAdapter = new QianseitAdapter<JSONObject>(mModuleList) {

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // TODO Auto-generated method stub
            if (convertView == null) {
                convertView = View.inflate(mActivity, R.layout.item_community_module, null);
                convertView.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        JSONObject nItem = (JSONObject) v.getTag();
                        Bundle nBundle = new Bundle();
                        nBundle.putInt(Run.EXTRA_CLASS_ID, nItem.optInt("node_id"));
                        nBundle.putString(Run.EXTRA_DATA, mNodeJsonArray.toString());
                        startActivity(AgentActivity.FRAGMENT_COMMUNITY_MODULE, nBundle);
                    }
                });
            }

            JSONObject nItem = getItem(position);
            ImageView img = (ImageView) convertView.findViewById(R.id.image);
            displayRectangleImage(img, nItem.optString("image"));
            ((TextView) convertView.findViewById(R.id.title)).setText(nItem.optString("node_name"));
            ((TextView) convertView.findViewById(R.id.content)).setText(nItem.optString("node_desc"));
            convertView.setTag(nItem);
            return convertView;
        }
    };

    GridView mGuruListView;
    private int mImageWidth;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mActionBar.setTitle("社区");
        mLoginedUser = LoginedUser.getInstance();
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_community, null);
        mPullToRefreshLayout = (PullToRefreshLayout) findViewById(R.id.refresh_view);
        mPullToRefreshLayout.setOnRefreshListener(this);

        mCycleView = (ImageCycleView) findViewById(R.id.community_ad_view);
        ((LinearLayout.LayoutParams) mCycleView.getLayoutParams()).height = Run.getWindowsWidth(mActivity) / 2;

        mRecommendListView = (ListView) findViewById(R.id.community_recommend_list);
        mRecommendListView.setAdapter(mRecommendAdapter);
        findViewById(R.id.more).setOnClickListener(this);

        mModuleListView = (ListView) findViewById(R.id.community_module_list);
        mModuleListView.setAdapter(mModuleAdapter);

        mGuruListView = (GridView) findViewById(R.id.community_guru_list);
        mImageWidth = (Run.getWindowsWidth(mActivity) - Run.dip2px(mActivity, 5 * 4)) / 3;
        mGuruListView.setNumColumns(3);
        mGuruListView.setHorizontalSpacing(Util.dip2px(mActivity, 5));
        mGuruListView.setVerticalSpacing(Util.dip2px(mActivity, 5));
        mGuruListView.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);

        onRefresh(mPullToRefreshLayout);
        mPullToRefreshLayout.setPullUp(false);
        mPullToRefreshLayout.setPullDown(true);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (!mLoginedUser.isLogined()) {
            mPullToRefreshLayout.setPullUp(false);
            findViewById(R.id.community_guru_rl).setVisibility(View.GONE);
            isLogStatus = false;
        } else {
            mPullToRefreshLayout.setPullUp(true);
            findViewById(R.id.community_guru_rl).setVisibility(View.VISIBLE);
            if (!isLogStatus) {
                mIndexGetAllListInterface.RunRequest();
            }
            isLogStatus = true;
        }
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        final JSONObject dataJSON;
        switch (v.getId()) {
            case R.id.more:
                Bundle nBundle = new Bundle();
                nBundle.putString(Run.EXTRA_DETAIL_TYPE, "stroy");
                nBundle.putString(Run.EXTRA_TITLE, "靓贴推荐");
                startActivity(AgentActivity.FRAGMENT_COMMUNITY_NOTE_LIST, nBundle);
                break;
            case R.id.attention_item_avd:
                dataJSON = (JSONObject) v.getTag();
                if (dataJSON != null) {
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, dataJSON.optString("member_id")));
                }

            default:
                break;
        }
        super.onClick(v);
    }

    protected void onLoadFinished() {
        // TODO Auto-generated method stub
        mPullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
        mPullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.SUCCEED);
    }

    @Override
    public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
        // TODO Auto-generated method stub
        if (mLoginedUser.isLogined()) {
            isLogStatus = true;
        } else {
            isLogStatus = false;
            mPullToRefreshLayout.setPullUp(false);
        }
        mIndexGetAllListInterface.RunRequest();
    }

    @Override
    public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
        // TODO Auto-generated method stub
        if (mLoginedUser.isLogined()) {
//            loadNextPage(mPageNum);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        if (resultCode != Activity.RESULT_OK) {
            return;
        }

        if (requestCode == REQUEST_DETAIL) {
            try {
                JSONObject nJsonObject = new JSONObject(data.getStringExtra(Run.EXTRA_DATA));
                mCurJsonObject.put("praise_nums", nJsonObject.opt("praise_nums"));
                mCurJsonObject.put("discuss_nums", nJsonObject.opt("discuss_nums"));
                mCurJsonObject.put("ifpraise", nJsonObject.opt("ifpraise"));
                mRecommendAdapter.notifyDataSetChanged();
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}
