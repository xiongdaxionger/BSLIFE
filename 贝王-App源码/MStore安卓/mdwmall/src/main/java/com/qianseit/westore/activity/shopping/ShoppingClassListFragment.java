package com.qianseit.westore.activity.shopping;

import android.annotation.TargetApi;
import android.content.Intent;
import android.graphics.Paint;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.GoodsListscreenPopupWindow;
import com.qianseit.westore.ui.GoodsListscreenPopupWindow.onScreenListPopupCheckListener;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.qianseit.westore.ui.pull.PullableGridView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ShoppingClassListFragment extends BaseDoFragment implements OnRefreshListener, onScreenListPopupCheckListener, OnDismissListener {
    private String mKeywords;
    private String mCategoryId;
    private String mVitualCategoryId;
    private String mGoodsListTitle;
    private String mSortKey;

    private int mPageNum;
    private View mSelectView;

    private RelativeLayout mSortDefaultView;
    private RelativeLayout mSortHotView;
    private RelativeLayout mSortBuyCountView;
    private RelativeLayout mSortPriceView;

    private LayoutInflater mLayoutInflater;

    private PullableGridView mGridView;
    private BaseAdapter mGoodsListAdapter;
    private String newTime;
    private PullToRefreshLayout mPullToRefreshLayout;
    private RelativeLayout mNullListRel;

    private ArrayList<JSONObject> mGoodsArray = new ArrayList<JSONObject>();
    private int iconDisplayWidth;
    private PopupWindow mScreenWindow;
    //筛选
    private int mTotalGoodsNum;
    private JSONObject screenJson;

    List<JSONObject> mThirdCategoryJsonObjects;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        iconDisplayWidth = Run.getWindowsWidth(mActivity) / 2 - Run.dip2px(mActivity, 5);
        mActionBar.setShowTitleBar(true);
        mActionBar.setShowHomeView(true);
        mActionBar.setShowBackButton(true);
        Intent data = mActivity.getIntent();
        String nThirdCategoryJsonString = data.getStringExtra(Run.EXTRA_DATA);
        mThirdCategoryJsonObjects = new ArrayList<JSONObject>();
        if (!TextUtils.isEmpty(nThirdCategoryJsonString)) {
            try {
                JSONArray nArray = new JSONArray(nThirdCategoryJsonString);
                for (int i = 0; i < nArray.length(); i++) {
                    mThirdCategoryJsonObjects.add(nArray.optJSONObject(i));
                }
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        mKeywords = data.getStringExtra(Run.EXTRA_KEYWORDS);
        mCategoryId = data.getStringExtra(Run.EXTRA_CLASS_ID);
        mVitualCategoryId = data.getStringExtra(Run.EXTRA_VITUAL_CATE);
        mGoodsListTitle = data.getStringExtra(Run.EXTRA_TITLE);


        mLayoutInflater = mActivity.getLayoutInflater();
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.init(inflater, container, savedInstanceState);
        rootView = inflater.inflate(R.layout.fragment_main_goods_list, null);
        mGridView = (PullableGridView) findViewById(R.id.goods_list_grid);
        mPullToRefreshLayout = ((PullToRefreshLayout) findViewById(R.id.refresh_view));
        mPullToRefreshLayout.setOnRefreshListener(this);
        mNullListRel = (RelativeLayout) findViewById(R.id.order_null_rl);
        ((TextView) mNullListRel.getChildAt(0)).setText("暂无商品");
        mSortDefaultView = (RelativeLayout) findViewById(R.id.main_goods_list_topbar_sort_default);
        mSortDefaultView.setOnClickListener(mSortClickListener);
        mSortPriceView = (RelativeLayout) findViewById(R.id.main_goods_list_topbar_sort_price);
        mSortPriceView.setOnClickListener(mSortClickListener);
        mSortBuyCountView = (RelativeLayout) findViewById(R.id.main_goods_list_topbar_sort_sales);
        mSortBuyCountView.setOnClickListener(mSortClickListener);
        mSortHotView = (RelativeLayout) findViewById(R.id.main_goods_list_topbar_sort_hot);
        mSortHotView.setOnClickListener(mSortClickListener);

        mGoodsListAdapter = new GoodsListAdapter();
        mGridView.setAdapter(mGoodsListAdapter);
        mGridView.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                JSONObject json = (JSONObject) view.getTag(R.id.tag_object);
                String goodsIID = json.optString("iid");
                Intent intent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL)
                        .putExtra(Run.EXTRA_CLASS_ID, goodsIID);
                startActivity(intent);
            }

        });

//		mActionBar.setRightTitleButton(R.string.screen,new OnClickListener() {
//			
//			@Override
//			public void onClick(View v) {
//				
//				openScreenPopupWindow(v);
//			}
//		});

        mSortHotView.performClick();

    }

    private void openScreenPopupWindow(View view) {
        if (this.mScreenWindow == null) {
            mScreenWindow = new GoodsListscreenPopupWindow(mActivity, view.getId(), this, null, mImageLoader, mTotalGoodsNum);
            mScreenWindow.setOnDismissListener(this);
        }
        if (mScreenWindow.isShowing()) {
            mScreenWindow.dismiss();
        } else {
            ((GoodsListscreenPopupWindow) mScreenWindow).setGoodsNum(mTotalGoodsNum);
            mScreenWindow.setAnimationStyle(android.R.style.Animation_Dialog);
            mScreenWindow.showAsDropDown(((LinearLayout) mSortHotView.getParent()), 0, 1);
        }
    }


    private OnClickListener mSortClickListener = new OnClickListener() {
        @Override
        public void onClick(View v) {

            if (mSelectView != null) {
                mSelectView.setSelected(false);
                ((RelativeLayout) mSelectView).getChildAt(1).setVisibility(View.GONE);
            }
            mSelectView = v;
            if (v == mSortDefaultView) {
                mSortKey = "";
            } else if (v == mSortHotView) {
                mSortKey = "uptime desc";
            } else if (v == mSortBuyCountView) {
                if (TextUtils.equals("buy_count desc", mSortKey)) {
                    mSortKey = "buy_count asc";
                } else {
                    mSortKey = "buy_count desc";
                }
            } else if (v == mSortPriceView) {
                if (TextUtils.equals(mSortKey, "price asc")) {
                    mSortKey = "price desc";
                } else {
                    mSortKey = "price asc";
                }
            }
            v.setSelected(true);
            ((RelativeLayout) v).getChildAt(1).setVisibility(View.VISIBLE);
            loadNextPage(1, null);
        }
    };

    private void loadNextPage(int oldPageNum, PullToRefreshLayout pullToRefreshLayout) {
        this.mPageNum = oldPageNum;
        if (this.mPageNum == 1) {
            mGoodsArray.clear();
            mGoodsListAdapter.notifyDataSetChanged();
        }
        Run.excuteJsonTask(new JsonTask(), new GetGoodsTask(pullToRefreshLayout));
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (TextUtils.isEmpty(mGoodsListTitle)) {
            mActionBar.setTitle("全部商品");
        } else {
            mActionBar.setTitle(mGoodsListTitle);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    private class GoodsListAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return mGoodsArray.size();
        }

        @Override
        public JSONObject getItem(int position) {
            return mGoodsArray.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder viewHolder;
            if (convertView == null) {
                viewHolder = new ViewHolder();
                convertView = mLayoutInflater.inflate(R.layout.item_shopping_good_list, null);
                View contentView = convertView.findViewById(R.id.icon_item_shopping_good_list_fl);
                LayoutParams nLayoutParams = contentView.getLayoutParams();
                nLayoutParams.height = iconDisplayWidth;
                contentView.setLayoutParams(nLayoutParams);
                viewHolder.iconImage = (ImageView) convertView.findViewById(R.id.icon_item_shopping_good_list);
                viewHolder.titleTextView = (TextView) convertView.findViewById(R.id.title_item_shopping_good_list);
                viewHolder.priceTextView = (TextView) convertView.findViewById(R.id.price_item_shopping_good_list);
                viewHolder.soldoutImage = (ImageView) convertView.findViewById(R.id.soldout_icon_item_shopping_good_list);
                viewHolder.marketPriceTextView = (TextView) convertView.findViewById(R.id.market_price_text);
                viewHolder.marketPriceTextView.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
                viewHolder.statusIcon = (ImageView) contentView.findViewById(R.id.item_goods_tag_icon);
                convertView.setTag(viewHolder);
            } else {
                viewHolder = (ViewHolder) convertView.getTag();
            }

            JSONObject goodsObject = getItem(position);
            convertView.setTag(R.id.tag_object, goodsObject);
            viewHolder.titleTextView.setText(goodsObject.optString("title"));
            viewHolder.priceTextView.setText("￥" + goodsObject.optString("price"));
            viewHolder.marketPriceTextView.setText("￥" + goodsObject.optString("mktprice"));
            displayRectangleImage(viewHolder.iconImage, goodsObject.optString("default_img_url"));
            if ("1".equals(goodsObject.optString("is_rebate"))) {
                viewHolder.statusIcon.setVisibility(View.VISIBLE);
            } else {
                viewHolder.statusIcon.setVisibility(View.VISIBLE);
            }
            int store = goodsObject.optInt("store");
            if (store <= 0) {
                viewHolder.soldoutImage.setVisibility(View.VISIBLE);
            } else {
                viewHolder.soldoutImage.setVisibility(View.GONE);
            }

            return convertView;
        }
    }

    private class ViewHolder {
        private ImageView iconImage;
        private ImageView soldoutImage;
        private TextView titleTextView;
        private TextView priceTextView;
        private TextView marketPriceTextView;
        private ImageView statusIcon;

    }

    class GetGoodsTask implements JsonTaskHandler {
        private PullToRefreshLayout pullToRefreshLayout;

        public GetGoodsTask(PullToRefreshLayout pullToRefreshLayout) {
            this.pullToRefreshLayout = pullToRefreshLayout;
        }

        @Override
        public void task_response(String json_str) {
            try {
                hideLoadingDialog_mt();
                JSONObject all = new JSONObject(json_str);
                if (Run.checkRequestJson(mActivity, all)) {
                    JSONObject childs = all.optJSONObject("data");
                    if (childs != null) {
                        newTime = childs.optString("system_time");
                        JSONObject items = childs.optJSONObject("items");
                        if (items != null) {
                            loadLocalGoods(items);
                        }
                    }

                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (pullToRefreshLayout != null) {
                    pullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.SUCCEED);
                    pullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
                }
                if (mGoodsArray.size() > 0) {
                    mNullListRel.setVisibility(View.GONE);
                } else {
                    mNullListRel.setVisibility(View.VISIBLE);
                }
            }

        }

        @Override
        public JsonRequestBean task_request() {
            if (pullToRefreshLayout == null) {
                showCancelableLoadingDialog();
            }
            JsonRequestBean req = new JsonRequestBean(Run.API_URL, "mobileapi.goods.get_all_list");
            req.addParams("page_no", String.valueOf(mPageNum));
            if (!TextUtils.isEmpty(mCategoryId))
                req.addParams("cat_id", mCategoryId);
            if (!TextUtils.isEmpty(mKeywords))
                req.addParams("search_keyword", mKeywords);
            if (!TextUtils.isEmpty(mSortKey))
                req.addParams("orderby", mSortKey);
            if (!TextUtils.isEmpty(mVitualCategoryId))
                req.addParams("virtual_cat_id", mVitualCategoryId);
            req.addParams("son_object", "json");
            return req;
        }

    }

    private void loadLocalGoods(JSONObject json) {
        JSONArray item = json.optJSONArray("item");
        if (item != null && item.length() > 0) {
            // mGoodsArray.clear();
            for (int i = 0; i < item.length(); i++) {
                mGoodsArray.add(item.optJSONObject(i));
            }
            mGoodsListAdapter.notifyDataSetChanged();
        }

    }

    @Override
    public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
        loadNextPage(1, pullToRefreshLayout);
    }

    @Override
    public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
        mPageNum++;
        loadNextPage(mPageNum, pullToRefreshLayout);
    }

    @Override
    public void onScreenResult(List<JSONObject> ListJson, int dockViewID) {
        // TODO Auto-generated method stub

    }

    @Override
    public void onDismiss() {
        // TODO Auto-generated method stub

    }

}
