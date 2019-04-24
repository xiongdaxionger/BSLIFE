package com.qianseit.westore.activity.shopping;

import android.content.Intent;
import android.graphics.Paint;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.index.GetGroupInterface;
import com.qianseit.westore.httpinterface.index.ServiceTimeInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarCheckoutInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppRemindInterface;
import com.qianseit.westore.ui.HorizontalListView;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;
import com.qianseit.westore.ui.MyListView;
import com.qianseit.westore.ui.RushBuyCountDownTimerView;
import com.qianseit.westore.ui.RushBuyCountDownTimerView.CountDownTimerListener;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class ShoppSecKillFragment extends BaseDoFragment implements OnRefreshListener {
    final String CHECK_STATUS_FIELD = "checkstatusfield";
    long mSystemTime = 0;
    long mLocalSystemTime = 0;

    /**
     * 秒杀
     */
    int mGroupType = 2;

    LinearLayout mPinnedLayout;
    LinearLayout mListLayout, mBarLayout;
    int mBarTop = 0;

    String mTitleImageUrl;

    private PullToRefreshLayout mPullToRefreshLayout;
    private MyListView mListView;
    ImageCycleView<JSONObject> mCycleView;
    ArrayList<JSONObject> mAdArrayList = new ArrayList<JSONObject>();

    TextView mSeckillTitle, mSeckillCountDownTip;
    RushBuyCountDownTimerView mSeckillCountDown, mSuperSeckillCountDown;
    private long mDisplayBeginTime;
    private long mDisPlayEndTime;

    private View suspensionView;
    HorizontalListView mBarHorizontalListView, mSuperBarHorizontalListView;
    QianseitAdapter<JSONObject> mBarAdapter;
    List<JSONObject> mBarJsonObjects = new ArrayList<JSONObject>();
    List<JSONObject> mDataJsonObjects = new ArrayList<JSONObject>();
    JSONObject mCurJsonObject;
    int mSelectedBarIndex = 0;
    String mDefualtSelectedId = "";
    long nBarCurSystemTime;
    Handler timeHandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            mBarAdapter.notifyDataSetChanged();
        }
    };
    ShoppRemindInterface mRemindInterface = new ShoppRemindInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            if (isSave) {
                try {
                    mCurJsonObject.put("is_remind", true);
                } catch (JSONException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                JSONObject nItem = mBarAdapter.getItem(mSelectedBarIndex).optJSONObject("info");
                CommonLoginFragment.showAlertDialog(mActivity, String.format("设置成功\n开卖前%s提醒您", StringUtils.friendly2FormatTime(nItem.optLong("begin_time") - nItem.optLong("remind_time"))));
            } else {
                CommonLoginFragment.showAlertDialog(mActivity, "取消提醒成功");
                try {
                    mCurJsonObject.put("is_remind", false);
                } catch (JSONException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            mAdapter.notifyDataSetChanged();
        }
    };
    ShoppCarCheckoutInterface mCarCheckoutInterface = new ShoppCarCheckoutInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Bundle nBundle = new Bundle();
            nBundle.putString(Run.EXTRA_DATA, responseJson.toString());
            startActivity(AgentActivity.FRAGMENT_SHOPP_CONFIRM_ORDER, nBundle);
        }
    };
    ShoppCarAddInterface mAddCarInterface = new ShoppCarAddInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            if (isFastBuy()) {
                mCarCheckoutInterface.reset();
                mCarCheckoutInterface.setFastbuy();
                mCarCheckoutInterface.addGoodsIdent(getIdentId());
                mCarCheckoutInterface.RunRequest();
            } else {
                Run.alert(mActivity, "加入购物车成功");
                Run.goodsCounts += getQty();
            }
        }
    };
    GetGroupInterface mGetGroupInterface = new GetGroupInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            mPullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
            if (!rootView.isShown()) {
                rootView.setVisibility(View.VISIBLE);
            }
            mBarJsonObjects.clear();
            JSONArray nArray = responseJson.optJSONArray("data");
            if (nArray == null) {
                mBarAdapter.notifyDataSetChanged();
                return;
            }

            try {
                for (int i = 0; i < nArray.length(); i++) {
                    JSONObject nItem = nArray.optJSONObject(i);
                    nItem.put(CHECK_STATUS_FIELD, false);

                    if (i == 0) {
                        mSystemTime = ServiceTimeInterface.getServiceTime();// nItem.optJSONObject("info").optLong("sys_time");
                        mLocalSystemTime = System.currentTimeMillis() / 1000;
                    }

                    mBarJsonObjects.add(nArray.optJSONObject(i));
                    if (!TextUtils.isEmpty(mDefualtSelectedId) && nItem.optJSONObject("info").optString("special_id").equals(mDefualtSelectedId)) {
                        mSelectedBarIndex = i;
                        mDefualtSelectedId = "";
                    }
                }
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            if (mBarLayout.getParent() != mListLayout) {
                // mPinnedLayout.removeView(mBarLayout);
                // mListLayout.addView(mBarLayout, 1);
            }

            mBarAdapter.notifyDataSetChanged();

            // 顶部轮播图
            JSONObject nJsonObject = responseJson.optJSONObject("slideBox");
            if (nJsonObject != null && !nJsonObject.isNull("params")) {
                nJsonObject = nJsonObject.optJSONObject("params");
                double nScale = nJsonObject.optDouble("scale", 0d);
                if (nScale > 1) {
                    setViewSize(mCycleView, 1080, 1080 / nScale);
                }
                JSONArray nItemArray = nJsonObject.optJSONArray("pic");
                mAdArrayList.clear();
                for (int i = 0; i < nItemArray.length(); i++) {
                    mAdArrayList.add(nItemArray.optJSONObject(i));
                }
                mCycleView.setImageResources(mAdArrayList, mAdCycleViewListener);
            }
            if (mAdArrayList.size() <= 0) {
                setViewSize(mCycleView, 1080, 0);
            }

            switchBar(mSelectedBarIndex);

        }
    };

    private ImageCycleViewListener<JSONObject> mAdCycleViewListener = new ImageCycleViewListener<JSONObject>() {

        @Override
        public void onImageClick(int position, View imageView) {
            JSONObject AvJSON = (JSONObject) imageView.getTag();
            onClickData(AvJSON);
        }

        @Override
        public void displayImage(JSONObject imageURLJson, ImageView imageView) {
            String imageUrl = imageURLJson.optString("link");
            imageView.setScaleType(ScaleType.FIT_XY);
            displayRectangleImage(imageView, imageUrl);
        }
    };

    QianseitAdapter<JSONObject> mAdapter = new QianseitAdapter<JSONObject>(mDataJsonObjects) {

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // TODO Auto-generated method stub
            if (convertView == null) {
                convertView = View.inflate(mActivity, R.layout.item_seckill_goods, null);
                convertView.findViewById(R.id.just_buy).setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        mCurJsonObject = (JSONObject) v.getTag();
                        final long nCurSystemTime = System.currentTimeMillis() / 1000 - mLocalSystemTime + mSystemTime;
                        if (nCurSystemTime < mDisplayBeginTime) {
                            if (mCurJsonObject.optBoolean("is_remind")) {
                                mRemindInterface.cancel(mCurJsonObject.optString("product_id"));
                            } else {
                                JSONObject nItem = mBarAdapter.getItem(mSelectedBarIndex).optJSONObject("info");
                                mRemindInterface.save(mCurJsonObject.optString("product_id"), String.valueOf(mGroupType), nItem.optString("remind_time"), nItem.optString("begin_time"));
                            }
                            return;
                        }
                        mAddCarInterface.setData(mCurJsonObject.optString("goods_id"), mCurJsonObject.optString("product_id"), 1);
                        mAddCarInterface.setIsFastBuy();
                        mAddCarInterface.RunRequest();
                    }
                });

                convertView.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        // TODO Auto-generated method stub
                        JSONObject json = (JSONObject) v.getTag(R.id.tag_object);
                        String productIID = json.optString("product_id");
                        Intent intent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, productIID);
                        startActivity(intent);
                    }
                });

                ((TextView) convertView.findViewById(R.id.market_price_text)).getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
            }

            JSONObject goodsObject = getItem(position);
            convertView.setTag(R.id.tag_object, goodsObject);
            convertView.findViewById(R.id.just_buy).setTag(goodsObject);
            ((TextView) convertView.findViewById(R.id.title_item_shopping_good_list)).setText(goodsObject.optString("product_name"));

            ((TextView) convertView.findViewById(R.id.price_item_shopping_good_list)).setText(goodsObject.optString("promotion_price"));
            ((TextView) convertView.findViewById(R.id.market_price_text)).setText(goodsObject.optString("price"));
            ((TextView) convertView.findViewById(R.id.partake_count)).setText(goodsObject.optString("initial_num") + "人");
            displayRectangleImage((ImageView) convertView.findViewById(R.id.icon_item_shopping_good_list), goodsObject.optString("image_default_id"));

            final long nCurSystemTime = System.currentTimeMillis() / 1000 - mLocalSystemTime + mSystemTime;
            if (nCurSystemTime < mDisplayBeginTime || nCurSystemTime > mDisPlayEndTime) {
                convertView.findViewById(R.id.just_buy).setEnabled(false);
                ((Button) convertView.findViewById(R.id.just_buy)).setText("立即抢购");
                if (nCurSystemTime < mDisplayBeginTime) {
                    ((TextView) convertView.findViewById(R.id.partake_count)).setText(0 + "人");
                }

                if (nCurSystemTime < mDisplayBeginTime) {
                    convertView.findViewById(R.id.just_buy).setEnabled(true);
                    if (goodsObject.optBoolean("is_remind")) {
                        ((Button) convertView.findViewById(R.id.just_buy)).setText("取消提醒");
                    } else {
                        ((Button) convertView.findViewById(R.id.just_buy)).setText("提醒我");
                    }
                }
            }
            // else if (!goodsObject.optBoolean("status")) {
            // //
            // convertView.findViewById(R.id.soldout_icon_item_shopping_good_list).setVisibility(View.VISIBLE);
            // convertView.findViewById(R.id.just_buy).setEnabled(false);
            // ((Button)
            // convertView.findViewById(R.id.just_buy)).setText("已抢完");
            // }
            else {
                // convertView.findViewById(R.id.soldout_icon_item_shopping_good_list).setVisibility(View.GONE);
                convertView.findViewById(R.id.just_buy).setEnabled(true);
                ((Button) convertView.findViewById(R.id.just_buy)).setText("立即抢购");
            }

            return convertView;
        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        Bundle nBundle = mActivity.getIntent().getExtras();
        if (nBundle != null) {
            mDefualtSelectedId = nBundle.getString(Run.EXTRA_CLASS_ID, "");
            mTitleImageUrl = nBundle.getString(Run.EXTRA_TITLE, "");
        }
        mActionBar.setTitle("秒杀专区");
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        // TODO Auto-generated method stub
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            mBarTop = mBarLayout.getTop();
        }
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        rootView = View.inflate(mActivity, R.layout.fragment_shopp_seckill, null);
        rootView.setVisibility(View.INVISIBLE);
        suspensionView = View.inflate(mActivity, R.layout.item_seckill_layout, null);
        mPinnedLayout = (LinearLayout) findViewById(R.id.seckill_pinned);
        suspensionView.setVisibility(View.GONE);
        mPinnedLayout.addView(suspensionView);
        mListLayout = (LinearLayout) findViewById(R.id.seckill_list_ll);
        mBarLayout = (LinearLayout) findViewById(R.id.seckill_bar_ll);

        mPullToRefreshLayout = (PullToRefreshLayout) findViewById(R.id.refresh_view);
        mPullToRefreshLayout.setOnRefreshListener(this);
        mPullToRefreshLayout.setPullUp(false);

        mListView = (MyListView) findViewById(R.id.seckill_list);
        mListView.setFocusable(false);
        mListView.setAdapter(mAdapter);

        mCycleView = (ImageCycleView<JSONObject>) findViewById(R.id.seckill_ad_view);
        setViewSize(mCycleView, 1080, 540);

        mBarHorizontalListView = (HorizontalListView) findViewById(R.id.seckill_bar_list_view);
        mSuperBarHorizontalListView = (HorizontalListView) suspensionView.findViewById(R.id.seckill_bar_list_view);
        mBarAdapter = new QianseitAdapter<JSONObject>(mBarJsonObjects) {

            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                // TODO Auto-generated method stub
                if (convertView == null) {
                    convertView = View.inflate(mActivity, R.layout.item_seckill_radiobar, null);
                    setViewWidth(convertView.findViewById(R.id.viewwidth), 270);
                    convertView.setOnClickListener(new OnClickListener() {

                        @Override
                        public void onClick(View v) {
                            // TODO Auto-generated method stub
                            int mPostion = (Integer) v.getTag();
                            if (mPostion != mSelectedBarIndex) {
                                mSelectedBarIndex = mPostion;
                                switchBar(mSelectedBarIndex);
                                mScrollView.setScrollY(0);
                                notifyDataSetChanged();
                            }
                        }
                    });
                }

                JSONObject nItem = getItem(position).optJSONObject("info");
                final Long mBeginTime = nItem.optLong("begin_time");
                final Long mEndTime = nItem.optLong("end_time");

                TextView nTitleTextView = (TextView) convertView.findViewById(R.id.title);
                TextView nSubTitleTextView = (TextView) convertView.findViewById(R.id.sub_title);
                convertView.findViewById(R.id.title_ll).setSelected(position == mSelectedBarIndex);
                nTitleTextView.setSelected(position == mSelectedBarIndex);
                nSubTitleTextView.setSelected(position == mSelectedBarIndex);
                nTitleTextView.setText(StringUtils.LongTimeToString("M月d日", mBeginTime));
                nSubTitleTextView.setText(StringUtils.LongTimeToString("HH:mm", mBeginTime));

                nBarCurSystemTime = System.currentTimeMillis() / 1000 - mLocalSystemTime + mSystemTime;
                if (position == mSelectedBarIndex) {
                    mDisplayBeginTime = mBeginTime;
                    mDisPlayEndTime = mEndTime;
                }
                Timer timer = new Timer();
                timer.schedule(new TimerTask() {

                    @Override
                    public void run() {
                        nBarCurSystemTime = System.currentTimeMillis() / 1000 - mLocalSystemTime + mSystemTime;
                        if ((mBeginTime == nBarCurSystemTime) || (mEndTime == nBarCurSystemTime)) {
                            timeHandler.sendEmptyMessage(1);
                        }
                    }
                }, 0, 1000);

                if (position == mSelectedBarIndex && !nItem.optBoolean(CHECK_STATUS_FIELD)) {
                    try {
                        nItem.put(CHECK_STATUS_FIELD, true);

                        // if (mBarLayout.getParent() != mListLayout) {
                        // mPinnedLayout.removeView(mBarLayout);
                        // mListLayout.addView(mBarLayout, 1);
                        // }

                        mPinnedLayout.getChildAt(0).setVisibility(View.GONE);
                        mSeckillTitle.setText(nItem.optString("name"));
                        ((TextView) suspensionView.findViewById(R.id.seckill_item_title)).setText(nItem.optString("name"));
                        mSeckillCountDownTip.setText(mBeginTime > nBarCurSystemTime ? "距开始" : "距结束");
                        ((TextView) suspensionView.findViewById(R.id.seckill_item_countdown_tip)).setText(mBeginTime > nBarCurSystemTime ? "距开始" : "距结束");
                        mSeckillCountDown.setTime(mBeginTime > nBarCurSystemTime ? mBeginTime : mEndTime, nBarCurSystemTime);
                        // mSeckillCountDown.setTime(100050, 100000);
                        mSeckillCountDown.start();
                        mSuperSeckillCountDown.setTime(mBeginTime > nBarCurSystemTime ? mBeginTime : mEndTime, nBarCurSystemTime);
                        mSuperSeckillCountDown.start();
                        // mActionBar.setTitle(nItem.optString("name"));
                    } catch (JSONException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                } else if (position != mSelectedBarIndex && nItem.optBoolean(CHECK_STATUS_FIELD)) {
                    try {
                        nItem.put(CHECK_STATUS_FIELD, false);
                    } catch (JSONException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }

                convertView.setTag(position);

                return convertView;
            }
        };

        mBarHorizontalListView.setAdapter(mBarAdapter);
        mSuperBarHorizontalListView.setAdapter(mBarAdapter);

        mSeckillTitle = (TextView) findViewById(R.id.seckill_item_title);
        mSeckillCountDownTip = (TextView) findViewById(R.id.seckill_item_countdown_tip);
        mSeckillCountDown = (RushBuyCountDownTimerView) findViewById(R.id.seckill_item_countdown);
        mSuperSeckillCountDown = (RushBuyCountDownTimerView) suspensionView.findViewById(R.id.seckill_item_countdown);
        mSeckillCountDown.setOnCountDownTimerListener(new CountDownTimerListener() {

            @Override
            public void CountDownTimeEnd() {
                // TODO Auto-generated method stub
                mBarAdapter.notifyDataSetChanged();
                mAdapter.notifyDataSetChanged();
            }
        });

        if (!TextUtils.isEmpty(mTitleImageUrl)) {
            View nTitleView = View.inflate(mActivity, R.layout.title_shopp_skill, null);
            mActionBar.setCustomTitleView(nTitleView);
            displayRectangleImage((ImageView) nTitleView.findViewById(R.id.title_icon), mTitleImageUrl);
        }

        initPinnedScrollView();

        onRefresh(mPullToRefreshLayout);
    }

    void switchBar(int barIndex) {
        mDataJsonObjects.clear();
        if (mBarJsonObjects == null || mBarJsonObjects.size() <= barIndex) {
            mAdapter.notifyDataSetChanged();
            return;
        }

        JSONObject nJsonObject = mBarJsonObjects.get(barIndex);
        JSONArray nGoodsArray = nJsonObject.optJSONArray("goods");
        if (nGoodsArray == null || nGoodsArray.length() <= 0) {
            mAdapter.notifyDataSetChanged();
            return;
        }

        for (int i = 0; i < nGoodsArray.length(); i++) {
            mDataJsonObjects.add(nGoodsArray.optJSONObject(i));
        }
        mAdapter.notifyDataSetChanged();
    }

    ScrollView mScrollView;

    void initPinnedScrollView() {
        mScrollView = (ScrollView) findViewById(R.id.seckill_pull_scroll);
        mScrollView.setOnTouchListener(new OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                onScroll(lastScrollY = mScrollView.getScrollY());
                switch (event.getAction()) {
                    case MotionEvent.ACTION_UP:
                        handler.sendMessageDelayed(handler.obtainMessage(), 20);
                        break;
                }
                return false;
            }
        });
    }

    // 监听滚动Y值变化，通过addView和removeView来实现悬停效果
    public void onScroll(int scrollY) {
        if (scrollY >= mBarTop) {
            mPinnedLayout.getChildAt(0).setVisibility(View.VISIBLE);
            // if (mBarLayout.getParent() != mPinnedLayout) {
            // mListLayout.removeView(mBarLayout);
            // mPinnedLayout.addView(mBarLayout);
            // }
        } else {
            mPinnedLayout.getChildAt(0).setVisibility(View.GONE);
            // if (mBarLayout.getParent() != mListLayout) {
            // mPinnedLayout.removeView(mBarLayout);
            // mListLayout.addView(mBarLayout, 1);
            // }
        }
    }

    /**
     * 主要是用在用户手指离开MyScrollView，MyScrollView还在继续滑动，我们用来保存Y的距离，然后做比较
     */
    private int lastScrollY;

    /**
     * 用于用户手指离开MyScrollView的时候获取MyScrollView滚动的Y距离，然后回调给onScroll方法中
     */
    private Handler handler = new Handler() {

        public void handleMessage(android.os.Message msg) {
            int scrollY = mScrollView.getScrollY();

            // 此时的距离和记录下的距离不相等，在隔5毫秒给handler发送消息
            if (lastScrollY != scrollY) {
                lastScrollY = scrollY;
                handler.sendMessageDelayed(handler.obtainMessage(), 5);
            }
            onScroll(scrollY);
        }

    };

    @Override
    public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
        // TODO Auto-generated method stub
        mGetGroupInterface.getGroup(mGroupType);
    }

    @Override
    public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
        // TODO Auto-generated method stub
        pullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.FAIL);
    }
}
