package com.qianseit.westore.activity.common;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;

import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.other.CaptureActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BasePageFragment;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator.ScrollDistanceListener;
import com.qianseit.westore.http.CookieHelper;
import com.qianseit.westore.httpinterface.index.ServiceTimeInterface;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.MyGridView;
import com.qianseit.westore.ui.RushBuyCountDownTimerView;
import com.qianseit.westore.ui.VerticalViewLinearLayout;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;
import com.qianseit.westore.ui.RushBuyCountDownTimerView.CountDownTimerListener;
import com.qianseit.westore.ui.VerticalViewLinearLayout.TextCycleViewListener;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.ui.XPullDownListView.IXListViewListener;
import com.qianseit.westore.util.StringUtils;

public class CommonHomeFragment extends BasePageFragment<JSONObject> implements IXListViewListener {
    public final static String HOMEREFASH = "com.qianse.home.BroadcastReceiverHelper";
    protected final String ITEM_TYPE_FIELD = "itemtypefield";
    protected final String ITEM_TYPE_FIRST_FIELD = "itemtypefirstfield";
    protected final String ITEM_TYPE_END_FIELD = "itemtypeendfield";
    protected final String ITEM_PARENT_INDEX = "itemparentindex";
    protected final String ITEM_GOODS_LEFT = "goods#left";
    protected final String ITEM_GOODS_RIGHT = "goods#right";
    protected final String ITEM_SPACE_HEIGHT = "itemspaceheight";
    /**
     * 只针对标题项有效，如享受更多优惠
     */
    protected final String ITEM_TITLE_FIELD = "itemtitlefield";

    final int ITEM_BANNER = 0;
    final int ITEM_NAVIGATION = 1;
    final int ITEM_SECOND_KILL = 2;
    final int ITEM_AD_TITLE = 3;
    final int ITEM_PICTURE_AD = 4;
    final int ITEM_GOODS = 5;
    final int ITEM_ARTICLE = 6;
    final int ITEM_SPACE = 7;
    final int ITEM_AD_HEADER_LINE = 8;
    final int ITEM_AD_FOOTER_LINE = 9;

    /**
     * 滑动图
     */
    final String TYPE_BANNER = "main_slide";
    /**
     * 导航菜单
     */
    final String TYPE_NAVIGATION = "wap_index_nav";
    /**
     * 快报
     */
    final String TYPE_ARTICLE = "article";
    /**
     * 图片广告
     */
    final String TYPE_PICTURE_AD = "wap_index_banner";
    final String TYPE_PICTURE_AD2 = "wap_index_banner2";
    /**
     * 秒杀
     */
    final String TYPE_SECOND_KILL = "goods_shopmax_starbuy";
    /**
     * 商品列表
     */
    final String TYPE_GOODS = "index_tab_goods";

    List<IndexPictureAdBean> mAdBeans = new ArrayList<IndexPictureAdBean>();

    int mRealScreenWidth = 0;
    int mBannerHeight = 0;
    int mTitleBarHeight = 0;
    int mDefinishScreenWidth = 1080;
    int mGoodsIconWidth = 540;
    int mSecondKillGoodsIconWidth = 360;
    int mDefualtSpaceHeight;
    long mSystemTime = 0;

    Drawable mScanDrawable, mNewsDrawable, mScanDarkDrawable, mNewsDarkDrawable, mWhiteSearchDrawable, mDarkSearchDrawable;
    int mDarkColor, mWhiteSearchTextColor, mGraySearchTextColor;

    private static boolean isRefash = false;

    public static class BroadcastReceiverHelper extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(HOMEREFASH)) {
                isRefash = true;
            }
        }

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mActionBar.setShowTitleBar(false);
        WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
        Point nPoint = new Point();
        wm.getDefaultDisplay().getSize(nPoint);
        mRealScreenWidth = nPoint.x;

        mGoodsIconWidth = (mRealScreenWidth - Run.dip2px(mActivity, 15)) / 2;
        mSecondKillGoodsIconWidth = (int) ((mRealScreenWidth - Run.dip2px(mActivity, 20)) / 3.5);
        mTitleBarHeight = Run.dip2px(mActivity, 46);
        mDefualtSpaceHeight = Run.dip2px(mActivity, 8);

        Resources nResources = getResources();

//        mScanDrawable = nResources.getDrawable(R.drawable.phone_icon_white);
        mScanDrawable = nResources.getDrawable(R.drawable.scan);
        mNewsDrawable = nResources.getDrawable(R.drawable.news);
        mWhiteSearchDrawable = nResources.getDrawable(R.drawable.shopping_home_bar_search_white);
        mDarkColor = nResources.getColor(R.color.westore_dark_textcolor);
        mWhiteSearchTextColor = nResources.getColor(R.color.white);
        mGraySearchTextColor = nResources.getColor(R.color.westore_second_gray_textcolor);
//        mScanDarkDrawable = nResources.getDrawable(R.drawable.phone_icon_dark);
        mScanDarkDrawable = nResources.getDrawable(R.drawable.scan_dark);
        mNewsDarkDrawable = nResources.getDrawable(R.drawable.news_dark);
        mDarkSearchDrawable = nResources.getDrawable(R.drawable.shopping_home_bar_search);
    }

    @Override
    protected int getViewTypeCount() {
        // TODO Auto-generated method stub
        return 10;
    }

    @Override
    protected int getItemViewType(JSONObject t) {
        // TODO Auto-generated method stub
        return t.optInt(ITEM_TYPE_FIELD);
    }

    @Override
    protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        switch (getItemViewType(responseJson)) {
            case ITEM_BANNER:
                convertView = getBannerView(responseJson, convertView, parent);
                break;
            case ITEM_NAVIGATION:
                convertView = getNavigationView(responseJson, convertView, parent);
                break;
            case ITEM_SECOND_KILL:
                convertView = getSecondKillView(responseJson, convertView, parent);
                break;
            case ITEM_AD_TITLE:
                convertView = getPictureADTitleView(responseJson, convertView, parent);
                break;
            case ITEM_PICTURE_AD:
                convertView = getPictureView(responseJson, convertView, parent);
                break;
            case ITEM_GOODS:
                convertView = getGoodsView(responseJson, convertView, parent);
                break;
            case ITEM_ARTICLE:
                convertView = getArticleView(responseJson, convertView, parent);
                break;
            case ITEM_SPACE:
                convertView = getItemSpaceView(responseJson, convertView, parent, 0);
                break;
            case ITEM_AD_HEADER_LINE :
            case ITEM_AD_FOOTER_LINE :
                convertView = getItemSpaceView(responseJson, convertView, parent, Run.dip2px(mActivity, 10));
                break;
            default:
                break;
        }
        return convertView;
    }

    /**
     * 分割线项
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getItemSpaceView(JSONObject responseJson, View convertView, ViewGroup parent, int margin) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_home_space, null);
        }
        View nView = convertView.findViewById(R.id.divider_top);
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams)nView.getLayoutParams();
        layoutParams.leftMargin = margin;
        layoutParams.rightMargin = margin;
        nView.setLayoutParams(layoutParams);
        setViewAbsoluteHeight(nView, responseJson.optInt(ITEM_SPACE_HEIGHT));
        return convertView;
    }

    @Override
    protected List<JSONObject> fetchDatas(JSONObject responseJson) {
        // TODO Auto-generated method stub
        if (mPageNum == 1) {
            mAdBeans.clear();
        }
        List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        JSONArray nArray = responseJson.optJSONArray("data");
        if (nArray == null || nArray.length() <= 0) {
            return nJsonObjects;
        }
        try {
            for (int i = 0; i < nArray.length(); i++) {
                JSONObject nJsonObject = nArray.optJSONObject(i);
                JSONObject nParamJsonObject = nJsonObject.optJSONObject("params");
                if (nParamJsonObject == null) {
                    // 非法数据过滤
                    continue;
                }
                String nType = nJsonObject.optString("widgets_type");
                if (nType.equals(TYPE_BANNER)) {
                    JSONArray nDataArray = nParamJsonObject.optJSONArray("pic");
                    if (nDataArray != null && nDataArray.length() > 0) {
                        // 顶部广告
                        nJsonObject.put(ITEM_TYPE_FIELD, ITEM_BANNER);
                        nJsonObjects.add(nJsonObject);
                    }
                } else if (nType.equals(TYPE_NAVIGATION)) {
                    JSONArray nDataArray = nParamJsonObject.optJSONArray("nav");
                    if (nDataArray != null && nDataArray.length() > 0) {
                        nJsonObject.put(ITEM_TYPE_FIELD, ITEM_NAVIGATION);
                        nJsonObjects.add(nJsonObject);
                    }

                } else if (nType.equals(TYPE_ARTICLE)) {

                    if (nJsonObjects.size() > 0 && getItemViewType(nJsonObjects.get(nJsonObjects.size() - 1)) != ITEM_SPACE) {
                        int nTopItemType = getItemViewType(nJsonObjects.get(nJsonObjects.size() - 1));
                        if (nTopItemType != ITEM_SPACE && nTopItemType != ITEM_NAVIGATION) {
                            nJsonObjects.add(getSpace(mDefualtSpaceHeight));
                        }
                    }

                    JSONArray nDataArray = nParamJsonObject.optJSONArray("articles");
                    if (nDataArray != null && nDataArray.length() > 0) {
                        nJsonObject.put(ITEM_TYPE_FIELD, ITEM_ARTICLE);
                        nJsonObjects.add(nJsonObject);
                    }

                    nJsonObjects.add(getSpace(mDefualtSpaceHeight));
                } else if (nType.equals(TYPE_PICTURE_AD) || nType.equals(TYPE_PICTURE_AD2)) {
                    nJsonObjects.addAll(parsePictureAd(nJsonObject));
                } else if (nType.equals(TYPE_SECOND_KILL)) {

                    if (nJsonObjects.size() > 0 && getItemViewType(nJsonObjects.get(nJsonObjects.size() - 1)) != ITEM_SPACE) {
                        int nTopItemType = getItemViewType(nJsonObjects.get(nJsonObjects.size() - 1));
                        if (nTopItemType != ITEM_SPACE && nTopItemType != ITEM_NAVIGATION) {
                            nJsonObjects.add(getSpace(mDefualtSpaceHeight));
                        }
                    }

                    JSONArray nSecondKillGoodsArray = nParamJsonObject.optJSONArray("goodsRows");
                    if (nSecondKillGoodsArray == null || nSecondKillGoodsArray.length() <= 0) {
                        continue;
                    }
                    nJsonObject.put(ITEM_TYPE_FIELD, ITEM_SECOND_KILL);
                    nJsonObjects.add(nJsonObject);

                    nJsonObjects.add(getSpace(mDefualtSpaceHeight));
                } else if (nType.equals(TYPE_GOODS)) {
                    nJsonObjects.addAll(parseGoods(nJsonObject));
                }
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return nJsonObjects;
    }

    /**
     * 分割线
     *
     * @return
     * @throws JSONException
     */
    JSONObject getSpace(int spaceHeight) throws JSONException {
        JSONObject nSpaceJsonObject = new JSONObject();
        nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
        nSpaceJsonObject.put(ITEM_SPACE_HEIGHT, spaceHeight);
        return nSpaceJsonObject;
    }

    @SuppressLint("UseValueOf")
    private List<JSONObject> parsePictureAd(JSONObject jsonObject) throws JSONException {
        // TODO Auto-generated method stub
        List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        JSONObject nParams = jsonObject.optJSONObject("params");
        if (nParams == null) {
            return nJsonObjects;
        }
        JSONObject nBanType = nParams.optJSONObject("bantype");
        if (nBanType == null) {
            return nJsonObjects;
        }

        JSONObject nTitleJsonObject = nBanType.optJSONObject("title");
        if (nTitleJsonObject != null && nTitleJsonObject.optInt("show_title") != 0) {
            nTitleJsonObject.put(ITEM_TYPE_FIELD, ITEM_AD_TITLE);
            nJsonObjects.add(nTitleJsonObject);
        }

        ///标题分割线
        if (nBanType.optInt("title_unline") != 0){

            JSONObject object = new JSONObject();
            object.put(ITEM_TYPE_FIELD, ITEM_AD_HEADER_LINE);
            object.put(ITEM_SPACE_HEIGHT, Run.dip2px(mActivity, 1.0f));
            nJsonObjects.add(object);
        }

        JSONArray nArray = nBanType.optJSONArray("url");

        if (nArray != null && nArray.length() > 0) {

            mDefinishScreenWidth = nBanType.optInt("window_width");
            if(mDefinishScreenWidth <= 0)
                mDefinishScreenWidth = 1080;

            double nDividerSpace = nBanType.optDouble("spacing", 0);

            IndexPictureAdBean nAdBean = new IndexPictureAdBean();
            nAdBean.setDefinitionWidth(mDefinishScreenWidth);
            nAdBean.setDividerSpace(nDividerSpace);
            int nArrayLength = nArray.length();
            for (int i = 0; i < nArray.length(); i++) {
                JSONObject nJsonObject = nArray.optJSONObject(i);
                if (nJsonObject.optInt("size_x", 0) <= 0) {
                    continue;
                }

                int nOrder = nJsonObject.optInt("order");
                float nWidth = new Float(nJsonObject.optDouble("size_x"));
                float nHeight = new Float(nJsonObject.optDouble("size_y"));
                String nUrlType = nJsonObject.optString("url_type");
                String nUrlValue = nJsonObject.optString("url_id");
                String nImageUrl = nJsonObject.optString("img");
                if (nAdBean.addItem(nOrder, nWidth, nHeight, nUrlType, nUrlValue, nImageUrl)) {
                    mAdBeans.add(nAdBean);
                    JSONObject nJsonObject2 = new JSONObject();
                    nJsonObject2.put(ITEM_TYPE_FIELD, ITEM_PICTURE_AD);
                    nJsonObject2.put(ITEM_PARENT_INDEX, mAdBeans.size() - 1);
                    nJsonObjects.add(nJsonObject2);
                    nAdBean = new IndexPictureAdBean();
                    nAdBean.setDefinitionWidth(mDefinishScreenWidth);
                    nAdBean.setDividerSpace(nDividerSpace);

                    if (i < nArrayLength - 1 && nDividerSpace > 0) {
                        nJsonObjects.add(getSpace((int) Math.round(nDividerSpace * mRealScreenWidth / mDefinishScreenWidth)));
                    }
                }
            }

            if (nAdBean.beanHeight > 0) {
                mAdBeans.add(nAdBean);
                JSONObject nJsonObject2 = new JSONObject();
                nJsonObject2.put(ITEM_TYPE_FIELD, ITEM_PICTURE_AD);
                nJsonObject2.put(ITEM_PARENT_INDEX, mAdBeans.size() - 1);
                nJsonObjects.add(nJsonObject2);
            }
        }

        ///底部分割线
        if (nBanType.optInt("node_unline") != 0){

            JSONObject object = new JSONObject();
            object.put(ITEM_TYPE_FIELD, ITEM_AD_FOOTER_LINE);
            object.put(ITEM_SPACE_HEIGHT, Run.dip2px(mActivity, 1.0f));
            nJsonObjects.add(object);
        }

        return nJsonObjects;
    }

    private List<JSONObject> parseGoods(JSONObject jsonObject) throws JSONException {
        List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        JSONObject nParams = jsonObject.optJSONObject("params");
        if (nParams == null) {
            return nJsonObjects;
        }
        JSONArray nGoodsArray = nParams.optJSONArray("goodsRows");
        if (nGoodsArray == null || nGoodsArray.length() <= 0) {
            return nJsonObjects;
        }

        int nGoodsItemCount = 1;
        JSONObject nGoodsJsonObject = new JSONObject();
        nGoodsJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
        for (int i = 0; i < nGoodsArray.length(); i++) {
            nGoodsJsonObject.put(nGoodsItemCount == 1 ? ITEM_GOODS_LEFT : ITEM_GOODS_RIGHT, nGoodsArray.optJSONObject(i));
            nGoodsItemCount++;
            if (nGoodsItemCount > 2) {
                nGoodsItemCount = 1;
                nJsonObjects.add(nGoodsJsonObject);
                nGoodsJsonObject = new JSONObject();
                nGoodsJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
            }
        }

        return nJsonObjects;
    }

    View getGoodsView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_goods, null);
            View nLeftView = convertView.findViewById(R.id.goods_left);
            View nRightView = convertView.findViewById(R.id.goods_right);
            setViewAbsoluteSize(nLeftView.findViewById(R.id.recommed_goods_icon), mGoodsIconWidth, mGoodsIconWidth);
            ((TextView) nLeftView.findViewById(R.id.recommed_goods_mktprice)).getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);

            setViewAbsoluteSize(nRightView.findViewById(R.id.recommed_goods_icon), mGoodsIconWidth, mGoodsIconWidth);
            ((TextView) nRightView.findViewById(R.id.recommed_goods_mktprice)).getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
        }

        assignmentGoods(responseJson.optJSONObject(ITEM_GOODS_LEFT), convertView.findViewById(R.id.goods_left));
        assignmentGoods(responseJson.optJSONObject(ITEM_GOODS_RIGHT), convertView.findViewById(R.id.goods_right));

        return convertView;
    }

    void assignmentGoods(JSONObject jsonObject, View goodsItemView) {
        if (goodsItemView == null) {
            return;
        }

        if (jsonObject == null) {
            jsonObject = new JSONObject();
        }

        goodsItemView.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run
                        .EXTRA_PRODUCT_ID, ((JSONObject) v.getTag()).optString("productId")));
            }
        });

        goodsItemView.setTag(jsonObject);

        displaySquareImage((ImageView) goodsItemView.findViewById(R.id.recommed_goods_icon), jsonObject.optString("goodsPicM"));
        ((TextView) goodsItemView.findViewById(R.id.recommed_goods_title)).setText(jsonObject.optString("goodsName"));
        ((TextView) goodsItemView.findViewById(R.id.recommed_goods_price)).setText(jsonObject.optString("goodsSalePrice"));
        ((TextView) goodsItemView.findViewById(R.id.recommed_goods_mktprice)).setText("");// jsonObject.optString
		// ("goodsMarketPrice")
    }

    View getSecondKillView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_second_kill, null);
            ((RushBuyCountDownTimerView) convertView.findViewById(R.id.second_kill_countdown)).
                    setOnCountDownTimerListener(new CountDownTimerListener() {

                @Override
                public void CountDownTimeEnd() {
                    // TODO Auto-generated method stub

                }
            });
            convertView.findViewById(R.id.second_kill_description).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject clickJSON = (JSONObject) v.getTag();
                    // 进入秒杀画面
                    Bundle nBundle = new Bundle();
                    nBundle.putString(Run.EXTRA_CLASS_ID, clickJSON.optString("special_id"));
                    nBundle.putString(Run.EXTRA_TITLE, (String) v.getTag(R.id.tag_object));
                    startActivity(AgentActivity.FRAGMENT_SHOPP_SECKILL, nBundle);
                }
            });

        }

        JSONObject nParamsJsonObject = responseJson.optJSONObject("params");
        JSONObject nProJsonObject = nParamsJsonObject.optJSONObject("pro");
        ImageView nLeftImageView = (ImageView) convertView.findViewById(R.id.second_kill_left);
        setViewAbsoluteHeight(nLeftImageView, Run.dip2px(mActivity, 26));
        displayRectangleImage(nLeftImageView, nParamsJsonObject.optString("title_left"));
        convertView.findViewById(R.id.second_kill_description).setTag(nProJsonObject);
        convertView.findViewById(R.id.second_kill_description).setTag(R.id.tag_object, nParamsJsonObject.optString("title_left"));

        TextView nTitleRightTextView = (TextView) convertView.findViewById(R.id.second_kill_description);
        nTitleRightTextView.setTextColor(Color.parseColor(nParamsJsonObject.optString("title_right_color")));
        nTitleRightTextView.setText(nParamsJsonObject.optString("title_right"));
        final long nBeginTimeSec = nProJsonObject.optLong("begin_time");
        final long nEndTimeSec = nProJsonObject.optLong("end_time");
        final RushBuyCountDownTimerView mTimerView = (RushBuyCountDownTimerView) convertView.findViewById(R.id
				.second_kill_countdown);
        mTimerView.setCountdownStyle(RushBuyCountDownTimerView.STYLE_DARK_ROUND);
        mSystemTime = ServiceTimeInterface.getServiceTime();
        if (mSystemTime <= nBeginTimeSec) {
            // ((TextView)
            // convertView.findViewById(R.id.tem_time_tip)).setText("距开始倒计时");
            mTimerView.setTime(nBeginTimeSec, mSystemTime);
        } else {
            // ((TextView)
            // convertView.findViewById(R.id.tem_time_tip)).setText("距结束倒计时");
            mTimerView.setTime(nEndTimeSec, mSystemTime);
        }
        mTimerView.start();

        LinearLayout nSecondContent = (LinearLayout) convertView.findViewById(R.id.second_kill_goods_ll);
        nSecondContent.removeAllViews();
        JSONArray nSecondKillGoodsArray = responseJson.optJSONObject("params").optJSONArray("goodsRows");
        if (nSecondKillGoodsArray == null || nSecondKillGoodsArray.length() <= 0) {
            return convertView;
        }

        for (int i = 0; i < nSecondKillGoodsArray.length(); i++) {
            JSONObject nSecondKillGoodsJsonObject = nSecondKillGoodsArray.optJSONObject(i);
            View nView = View.inflate(mActivity, R.layout.item_comm_home_secondkill_goods, null);
            ImageView nImageView = (ImageView) nView.findViewById(R.id.goods_icon);
            setViewAbsoluteSize(nImageView, mSecondKillGoodsIconWidth, mSecondKillGoodsIconWidth);
            displaySquareImage(nImageView, nSecondKillGoodsJsonObject.optString("goodsPicM"));
            ((TextView) nView.findViewById(R.id.goods_mktprice)).getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
            ((TextView) nView.findViewById(R.id.goods_price)).setText(nSecondKillGoodsJsonObject.optString("promotion_price"));
            ((TextView) nView.findViewById(R.id.goods_mktprice)).setText(nSecondKillGoodsJsonObject.optString("price"));

            LinearLayout.LayoutParams nLayoutParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams
					.WRAP_CONTENT);
            nLayoutParams.rightMargin = i == nSecondKillGoodsArray.length() - 1 ? 0 : Run.dip2px(mActivity, 10);
            nSecondContent.addView(nView, nLayoutParams);
            nView.setTag(nSecondKillGoodsJsonObject);
            nView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nJsonObject = (JSONObject) v.getTag();
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run
							.EXTRA_PRODUCT_ID, nJsonObject.optString("product_id")));
                }
            });
        }

        return convertView;
    }

    View getPictureADTitleView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_picture_ad_title, null);
        }

        convertView.setBackgroundColor(Color.parseColor(responseJson.optString("bgcolor")));
        int nColor = Color.parseColor(responseJson.optString("color"));
        View nLeftLine = convertView.findViewById(R.id.title_left);
        View nRightLine = convertView.findViewById(R.id.title_right);

        String textAlign = responseJson.optString("text_align");

        LinearLayout layout = (LinearLayout)convertView.findViewById(R.id.title_linearLayout);
        TextView nAlignTextView = (TextView) convertView.findViewById(R.id.align_title);
        if(textAlign == null || textAlign.equals("center")){

            nAlignTextView.setVisibility(View.INVISIBLE);
            layout.setVisibility(View.VISIBLE);
            if (responseJson.optInt("show_line", 0) == 0) {
                nLeftLine.setVisibility(View.INVISIBLE);
                nRightLine.setVisibility(View.INVISIBLE);
            } else {
                nLeftLine.setBackgroundColor(nColor);
                nRightLine.setBackgroundColor(nColor);
                nLeftLine.setVisibility(View.VISIBLE);
                nRightLine.setVisibility(View.VISIBLE);
            }

            TextView nTextView = (TextView) convertView.findViewById(R.id.title);
            nTextView.setTextColor(nColor);
            nTextView.setText(responseJson.optString("title_name"));
        }else {
            layout.setVisibility(View.INVISIBLE);
            nAlignTextView.setVisibility(View.VISIBLE);
            nAlignTextView.setTextColor(nColor);
            nAlignTextView.setText(responseJson.optString("title_name"));
            int gravity = textAlign.equals("left") ? Gravity.LEFT : Gravity.RIGHT;
            nAlignTextView.setGravity(gravity | Gravity.CENTER_VERTICAL);
        }

        return convertView;
    }

    View getArticleView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_fast, null);
        }
        VerticalViewLinearLayout nViewPagerLinear = (VerticalViewLinearLayout) convertView.findViewById(R.id
				.home_fast_pagelinear);
        ArrayList<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        JSONArray dataArray = responseJson.optJSONObject("params").optJSONArray("articles");
        if (dataArray != null && dataArray.length() > 0) {
            for (int i = 0; i < dataArray.length(); i++) {
                JSONObject itemJSON = dataArray.optJSONObject(i);
                if (itemJSON != null && !itemJSON.isNull("title")) {
                    nJsonObjects.add(itemJSON);
                }
            }
        }
        nViewPagerLinear.setTextResources(nJsonObjects, mVerticalListener);
        return convertView;
    }

    private TextCycleViewListener mVerticalListener = new TextCycleViewListener() {

        @Override
        public void onTextClick(int position, View textView) {
            JSONObject AvJSON = (JSONObject) textView.getTag();
            onClick("article", AvJSON.optString("article_id"), AvJSON.optString("title"));
        }

        @Override
        public void displayTextView(JSONObject textJson, TextView textView) {
            String valStr = textJson.optString("title");
            textView.setText(valStr);

        }
    };

    View getNavigationView(JSONObject responseJson, View convertView, ViewGroup parent) {
        MyGridView nGridView = null;
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_navigation, null);
            nGridView = (MyGridView) convertView.findViewById(R.id.home_navigation);
            nGridView.setNumColumns(4);
            List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
            nGridView.setAdapter(new QianseitAdapter<JSONObject>(nJsonObjects) {

                @Override
                public View getView(int arg0, View arg1, ViewGroup arg2) {
                    // TODO Auto-generated method stub
                    if (arg1 == null) {
                        arg1 = View.inflate(mActivity, R.layout.item_comm_home_grid, null);
                        arg1.setOnClickListener(new OnClickListener() {

                            @Override
                            public void onClick(View arg0) {
                                // TODO Auto-generated method stub
                                onClickData((JSONObject) arg0.getTag());
                            }
                        });
                    }

                    JSONObject nItem = getItem(arg0);
                    arg1.setTag(nItem);
                    displaySquareImage((ImageView) arg1.findViewById(R.id.gridview_icon), nItem.optString("img"));
                    ((TextView) arg1.findViewById(R.id.gridview_title)).setText(nItem.optString("name"));
                    return arg1;
                }
            });
            nGridView.setTag(nJsonObjects);
        }
        nGridView = (MyGridView) convertView.findViewById(R.id.home_navigation);
        List<JSONObject> nJsonObjects = (List<JSONObject>) nGridView.getTag();
        nJsonObjects.clear();

        JSONArray nArray = responseJson.optJSONObject("params").optJSONArray("nav");
        if (nArray != null && nArray.length() > 0) {
            for (int i = 0; i < nArray.length(); i++) {
                nJsonObjects.add(nArray.optJSONObject(i));
            }
        }
        ((QianseitAdapter<JSONObject>) nGridView.getAdapter()).notifyDataSetChanged();
        return convertView;
    }

    View getBannerView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_banner, null);
            double nScale = responseJson.optJSONObject("params").optDouble("scale");
            if (nScale <= 1) {
                nScale = 1;
            }
            mBannerHeight = (int) (mRealScreenWidth / nScale);
            setViewAbsoluteHeight(convertView.findViewById(R.id.home_ad_view), mBannerHeight);
        }

        ArrayList<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        JSONArray child = responseJson.optJSONObject("params").optJSONArray("pic");
        if (child != null && child.length() > 0) {
            // 顶部广告
            for (int i = 0; i < child.length(); i++) {
                nJsonObjects.add(child.optJSONObject(i));
            }
            ((ImageCycleView<JSONObject>) convertView.findViewById(R.id.home_ad_view)).setImageResources(nJsonObjects,
					mAdCycleViewListener);
        }

        return convertView;
    }

    private ImageCycleViewListener<JSONObject> mAdCycleViewListener = new ImageCycleViewListener<JSONObject>() {

        @Override
        public void onImageClick(int position, View imageView) {
            JSONObject AvJSON = (JSONObject) imageView.getTag();
            onClickData(AvJSON);
        }

        @Override
        public void displayImage(JSONObject imageURLJson, ImageView imageView) {
            imageView.setScaleType(ScaleType.CENTER_CROP);
            String imageUrl = imageURLJson.optString("link");
            displayRectangleImage(imageView, imageUrl);

        }
    };

    View getPictureView(JSONObject responseJson, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_comm_home_picture_ad, null);
        }

        RelativeLayout nLayout = (RelativeLayout) convertView;
        nLayout.removeAllViews();

        IndexPictureAdBean nAdBean = mAdBeans.get(responseJson.optInt(ITEM_PARENT_INDEX));
        for (int i = 0; i < nAdBean.mAdBeanItems.size(); i++) {
            IndexPictureAdBeanItem nAdBeanItem = nAdBean.mAdBeanItems.get(i);
            nAdBeanItem.realScreenWidth = mRealScreenWidth;
            nAdBeanItem.definedWidth = mDefinishScreenWidth;
            ImageView nImageView = new ImageView(mActivity);
            nImageView.setScaleType(ScaleType.FIT_XY);
            RelativeLayout.LayoutParams nLayoutParams = new LayoutParams(nAdBeanItem.getRealWidth(), nAdBeanItem.getRealHeight());
            nLayoutParams.leftMargin = nAdBeanItem.getRealLeft();
            nLayoutParams.topMargin = nAdBeanItem.getRealTop();
            nLayout.addView(nImageView, nLayoutParams);
            displayRectangleImage(nImageView, nAdBeanItem.imageUrl);
            nImageView.setTag(nAdBeanItem);
            nImageView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    IndexPictureAdBeanItem nAdBeanItem = (IndexPictureAdBeanItem) v.getTag();
                    CommonHomeFragment.this.onClick(nAdBeanItem.type, nAdBeanItem.typeValue, "");
                }
            });
        }

        return convertView;
    }

    protected void endInit() {
        // TODO Auto-generated method stub
        PageEnable(false);
        mListView.setPullRefreshEnable(true);
        mListView.setDividerHeight(0);

        CookieHelper.getCarQty();
    }

    @Override
    public void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        mActionBar.setShowBackButton(true);
        if (isRefash) {
            isRefash = false;
            onRefresh();
            mLoginedUser.loadServicePhone(null);
        }

        if (mLoginedUser.isLogined()) {
            setNewsCount(mLoginedUser.getMember().getUn_readMsg());
            mActionBar.setHasNews(mLoginedUser.getMember().getUn_readMsg() > 0);
        } else {
            setNewsCount(0);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see com.qianseit.westore.base.BasePageFragment#requestInterfaceName()
     * 7.2 首页数据
     */
    @Override
    protected String requestInterfaceName() {
        // TODO Auto-generated method stub
        return "mobile.index.index";
    }

    private ImageView mEmptyImageView;
    private String mEmptyString = "";

    private int mEmptyStringRes = -1;
    private TextView mEmptyTextView;

    private RelativeLayout mEmptyViewRL;
    private int mImageRes = -1;

    ImageView mToTopImageView;
    protected XPullDownListView mListView;
    ListScrollDistanceCalculator mListScrollDistanceCalculator;
    int mScreenHeight = 0;

    FrameLayout mCustomAcationBarLayout;

    View mCustomAcationBarBg, mSearchBg;
    View mNewsView;

    ///弹窗
    Dialog mDialog;

    @Override
    protected void init() {
        // TODO Auto-generated method stub

        rootView = View.inflate(mActivity, R.layout.fragment_comm_home, null);
        rootView.setVisibility(View.INVISIBLE);

        mNewsView = findViewById(R.id.has_unread);
        mCustomAcationBarLayout = (FrameLayout) findViewById(R.id.action_bar_topbar);
        mSearchBg = findViewById(R.id.bar_search_bg);
        mCustomAcationBarBg = findViewById(R.id.action_bar_bg);
        mSearchBg.setAlpha(0.65f);
        mCustomAcationBarBg.setAlpha(0f);

        findViewById(R.id.bar_search_ll).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                startActivity(AgentActivity.FRAGMENT_GOODS_SEARCH);
            }
        });
        findViewById(R.id.action_bar_titlebar_right_ib).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                startNeedloginActivity(AgentActivity.FRAGMENT_NEWS_CENTER);
            }
        });
        findViewById(R.id.action_bar_titlebar_left).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                Intent nIntent = new Intent(mActivity, CaptureActivity.class);
                startActivity(nIntent);

                ///拨打客服电话
//                if(mLoginedUser.getPhone() != null){
//                    makePhoneCall(mLoginedUser.getPhone());
//                }else {
//
//                    showLoadingDialog();
//                    ///加载客服电话
//                    mLoginedUser.loadServicePhone(new LoginedUser.LoadServicePhoneHandler() {
//                        @Override
//                        public void onComplete() {
//                            hideLoadingDialog();
//                            makePhoneCall(mLoginedUser.getPhone());
//                        }
//                    });
//                }
            }
        });

        mListView = (XPullDownListView) findViewById(R.id.base_lv);
        mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
        mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
        mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
        mEmptyViewRL.setVisibility(View.GONE);
        findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                onRefresh();
            }
        });

        mListView.setEmptyView(mEmptyViewRL);
        mListView.setAdapter(mAdapter);
        mListView.setXPullDownListViewListener(this);
        mListView.setPullLoadEnable(true);

        if (mImageRes != -1) {
            setEmptyImage(mImageRes);
        }
        if (mEmptyStringRes != -1) {
            setEmptyText(mEmptyStringRes);
        }
        if (mEmptyString != null && !TextUtils.isEmpty(mEmptyString)) {
            setEmptyText(mEmptyString);
        }

        initToTop();

        mEmptyViewRL.setVisibility(View.GONE);
        endInit();
    }

    ///拨打电话
    void makePhoneCall(String phone){
        if(TextUtils.isEmpty(phone))
            return;
        final String nPhone = phone;
        ///拨打客服电话
        mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("%s", nPhone), "取消", "拨打", null, new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                String phone = nPhone;
                if (phone.contains("-")) {
                    phone = phone.replaceAll("-", "");
                }
                Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + phone));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                mDialog.hide();
            }
        }, false, null);
    }

    void setNewsCount(int newsCount) {
        mNewsView.setVisibility(newsCount > 0 ? View.VISIBLE : View.GONE);
    }

    void initToTop() {
        mScreenHeight = Run.getWindowsHeight(mActivity);

        mToTopImageView = (ImageView) findViewById(R.id.to_top);
        mToTopImageView.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                mListView.setSelectionAfterHeaderView();
                mListView.smoothScrollToPosition(0);
            }
        });
        mListScrollDistanceCalculator = new ListScrollDistanceCalculator();
        mListScrollDistanceCalculator.setScrollDistanceListener(new ScrollDistanceListener() {

            @Override
            public void onScrollDistanceChanged(int delta, int total) {
                // TODO Auto-generated method stub

                if (Math.abs(total) > mScreenHeight * 2) {
                    mToTopImageView.setVisibility(View.VISIBLE);
                } else {
                    mToTopImageView.setVisibility(View.GONE);
                }

                if (total == 0 && mListView.getHeadlerVisiableHeight() > 10) {
                    mCustomAcationBarLayout.setVisibility(View.GONE);
                } else {
                    if (!mCustomAcationBarLayout.isShown()) {
                        mCustomAcationBarLayout.setVisibility(View.VISIBLE);
                    }
                    int nTotal = Math.abs(total) - mBannerHeight + mTitleBarHeight;
                    if (nTotal >= mTitleBarHeight) {
                        ((ImageButton) findViewById(R.id.action_bar_titlebar_left)).setImageDrawable(mScanDarkDrawable);
                        ((ImageButton) findViewById(R.id.action_bar_titlebar_right_ib)).setImageDrawable(mNewsDarkDrawable);
                        ((ImageView) findViewById(R.id.bar_search_iv)).setImageDrawable(mDarkSearchDrawable);
                        ((TextView) findViewById(R.id.search_text)).setTextColor(mGraySearchTextColor);
                    } else {
                        ((ImageButton) findViewById(R.id.action_bar_titlebar_left)).setImageDrawable(mScanDrawable);
                        ((ImageButton) findViewById(R.id.action_bar_titlebar_right_ib)).setImageDrawable(mNewsDrawable);
                        ((ImageView) findViewById(R.id.bar_search_iv)).setImageDrawable(mWhiteSearchDrawable);
                        ((TextView) findViewById(R.id.search_text)).setTextColor(mWhiteSearchTextColor);
                    }

                    if (nTotal > 0) {
                        float nSearchTransparent = 0.65f + nTotal * 0.35f / mTitleBarHeight;
                        float nTitleTransparent = (float) nTotal / mTitleBarHeight;
                        if (nSearchTransparent > 0.9) {
                            nSearchTransparent = 0.9f;
                        }
                        if (nTitleTransparent > 0.9) {
                            nTitleTransparent = 0.9f;
                        }
                        mSearchBg.setAlpha(nSearchTransparent);
                        mCustomAcationBarBg.setAlpha(nTitleTransparent);
                    } else {
                        mSearchBg.setAlpha(0.65f);
                        mCustomAcationBarBg.setAlpha(0);
                    }
                }
            }
        });

        mListView.setOnScrollListener(mListScrollDistanceCalculator);

    }

    @Override
    protected void onLoadFinished() {
        // TODO Auto-generated method stub
        mListView.stopRefresh();
        mListView.stopLoadMore();
        mListView.setRefreshTime("刚刚");
        if (isLoadAll()) {
            mListView.setPullLoadEnable(false);
        }
    }

    @Override
    protected void onPageEnable(boolean enable) {
        // TODO Auto-generated method stub
        mListView.setPullLoadEnable(enable);
        mListView.setPullRefreshEnable(enable);
    }

    @Override
    public void onRefresh() {
        // TODO Auto-generated method stub
        if (mEnablePage) {
            mListView.setPullLoadEnable(true);
        }
        loadNextPage(0);
    }

    @Override
    public void onLoadMore() {
        // TODO Auto-generated method stub
        loadNextPage(mPageNum);
    }

    final protected void setEmptyImage(int imgRes) {
        if (mEmptyImageView == null) {
            mImageRes = imgRes;
            return;
        }
        mEmptyImageView.setImageResource(imgRes);
    }

    final protected void setEmptyText(int strRes) {
        if (mEmptyImageView == null) {
            mEmptyStringRes = strRes;
            return;
        }
        mEmptyTextView.setText(strRes);
    }

    final protected void setEmptyText(String emptyString) {
        if (mEmptyImageView == null) {
            mEmptyString = emptyString;
            return;
        }
        mEmptyTextView.setText(emptyString);
    }
}
