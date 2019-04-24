package com.qianseit.westore.activity.goods;

import android.app.Dialog;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.ScrollView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.tools.ToolGroupPopupWindow;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter.RadioBarCallback;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;
import com.qianseit.westore.httpinterface.goods.GoodsLinkInterface;
import com.qianseit.westore.httpinterface.goods.GoodsProductIndexInterface;
import com.qianseit.westore.httpinterface.goods.ProductBasicHandler;
import com.qianseit.westore.httpinterface.index.GetOnlineSeveiceInterface;
import com.qianseit.westore.httpinterface.goods.GoodServiceInfoInterface;
import com.qianseit.westore.httpinterface.index.ServiceTimeInterface;
import com.qianseit.westore.httpinterface.member.MemberAddFavInterface;
import com.qianseit.westore.httpinterface.member.MemberDelFavInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface.AdjunctBean;
import com.qianseit.westore.ui.FlowLayout;
import com.qianseit.westore.ui.HorizontalListView;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;
import com.qianseit.westore.ui.RushBuyCountDownTimerView;
import com.qianseit.westore.ui.RushBuyCountDownTimerView.CountDownTimerListener;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.ui.viewpager.GoodsDetailPagerAdapter;
import com.qianseit.westore.ui.viewpager.GoodsDetailViewPager;
import com.qianseit.westore.ui.viewpager.GoodsDetailViewPager.OnPageChangeListener;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsDetailFragment extends BaseDoFragment implements ShareViewDataSource {
    final int MSG_SCROLL_TO_COMBO_BOTTOM = 0x1001;

    final long TITLE_RADIO_BAR_GOODS = 1;
    final long TITLE_RADIO_BAR_DETAIL = 2;
    final long TITLE_RADIO_BAR_RECOMMEND = 3;


    /**
     * 一般促销标签
     */
    final int PROMOTION_TYPE_COMMON = 0;
    /**
     * 赠品
     */
    final int PROMOTION_TYPE_GIFT = 1;
    /**
     * 促销标签类型key
     */
    final String PROMOTION_TYPE_KEY = "promotiontype";
    /**
     * 第一个赠品
     */
    final String PROMOTION_GIFT_START = "promotiongiftstart";
    /**
     * 最后一个赠品
     */
    final String PROMOTION_GIFT_END = "promotiongiftend";
    /**
     * 客户服务联系信息
     */
    public JSONObject mServiceJsonObject = null;
    /**
     * 客户服务联系信息弹窗
     */
    public Dialog mServiceInfoDialog;
    /**
     * 客户服务联系信息文本
     */
    public TextView mServiceInfoTextView;

    ToolGroupPopupWindow mToolGroupPopupWindow;

    private ScrollView mPagerUpView;
    GoodsBottomView mGoodsBottomView;
    View mPagerMoreView;
    private ShareViewPopupWindow mShareViewPopupWindow;

    private GoodsDetailViewPager mPagerView;
    ViewPager mViewPager;

    private String mProductIID;

    ImageButton mServiceButton, mCollectionButton, mShopcarButton;
    TextView mShopcarCountTextView, mCollectionTextView;
    Button mAddtoCarButton, mBuyButton;
    FlowLayout mPromotionFlowLayout, mTagFlowLayout;
    View mPromotionHeaderView;
    ImageView mPromotionAcationImageView;
    List<View> mPromotionTagList = new ArrayList<View>();

    GoodsSpecDialog mGoodsSpecDialog;
    GoodsProptyDialog mGoodsProptyDialog;

    JSONObject mComboImageJsonObject, mProductJsonObject = null, mSettingsonObject = null, mProductBasicJsonObject = null, mPriceJsonObject = null, mPromotionJsonObject = null, mProductDic = null;
    JSONArray mDIYTabArray = null, mComboArray = null, mSpecArray, mBtnArray, mPropArray, mGoodsLinkArray, mServiceTagArray;

    long mSystemTime = 0;

    Resources mResources;

    /**
     * 是积分兑换的赠品
     */
    boolean isGift = false;

    boolean needChangeSelected = true;
    GoodsDetailTitleRadioBarAdapter mTitleRadioBarAdapter;
    // HorizontalListView mTitleBarListView;
    LinearLayout mTitleBarListView;
    List<RadioBarBean> mTitleBarBeans = new ArrayList<RadioBarBean>();

    // 促销
    int mPromotionPadding = 0;
    ListView mPromotionListView;
    List<JSONObject> mPromotionList = new ArrayList<JSONObject>();
    QianseitAdapter<JSONObject> mPromotionAdapter = new QianseitAdapter<JSONObject>(mPromotionList) {

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // TODO Auto-generated method stub
            int nType = getItemViewType(position);
            if (convertView == null) {
                if (nType == PROMOTION_TYPE_COMMON) {
                    convertView = View.inflate(mActivity, R.layout.item_goods_detail_promotion, null);
                    convertView.setOnClickListener(new OnClickListener() {

                        @Override
                        public void onClick(View v) {
                            // TODO Auto-generated method stub
                            JSONObject nJsonObject = (JSONObject) v.getTag();
                            int nTagId = nJsonObject.optInt("tag_id", 0);
                            if (nTagId <= 0) {
                                return;
                            }

                            Bundle nBundle = new Bundle();
                            nBundle.putInt(Run.EXTRA_VALUE, nTagId);
                            nBundle.putString(Run.EXTRA_TITLE, nJsonObject.optString("tag"));
                            startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_LIST, nBundle);
                        }
                    });
                } else {
                    convertView = View.inflate(mActivity, R.layout.item_goods_detail_promotion_gift, null);
                    convertView.setOnClickListener(new OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            JSONObject nItem = (JSONObject) v.getTag();
                            Bundle nBundle = new Bundle();
                            nBundle.putString(Run.EXTRA_PRODUCT_ID, nItem.optString("product_id"));
                            nBundle.putBoolean(Run.EXTRA_VALUE, true);//赠品
                            startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
                        }
                    });
                }
            }

            JSONObject nItem = getItem(position);
            if (nType == PROMOTION_TYPE_COMMON) {
                ((TextView) convertView.findViewById(R.id.promotion_name)).setText(nItem.optString("tag"));
                ((TextView) convertView.findViewById(R.id.promotion_content)).setText(nItem.optString("name"));
                convertView.findViewById(R.id.promotion_action).setVisibility(nItem.optInt("tag_id", 0) > 0 ? View.VISIBLE : View.GONE);
                convertView.setTag(nItem);
            } else {
                ((TextView) convertView.findViewById(R.id.promotion_name)).setText("赠品");
                ((TextView) convertView.findViewById(R.id.promotion_content)).setText(nItem.optString("name"));
                convertView.findViewById(R.id.promotion_action).setVisibility(View.GONE);
                convertView.findViewById(R.id.divider).setVisibility(nItem.optBoolean(PROMOTION_GIFT_END) ? View.VISIBLE : View.GONE);
                if (nItem.optBoolean(PROMOTION_GIFT_START)) {
                    convertView.setPadding(0, mPromotionPadding, 0, 0);
                    convertView.findViewById(R.id.promotion_name).setVisibility(View.VISIBLE);
                } else {
                    convertView.setPadding(0, 0, 0, 0);
                    convertView.findViewById(R.id.promotion_name).setVisibility(View.INVISIBLE);
                }
                convertView.setTag(nItem);
            }
            return convertView;
        }

        @Override
        public int getViewTypeCount() {
            return 2;
        }

        @Override
        public int getItemViewType(int i) {
            JSONObject nItem = getItem(i);
            return nItem.optInt(PROMOTION_TYPE_KEY, PROMOTION_TYPE_COMMON);
        }
    };

    // 相关商品与配件
    List<RadioBarBean> mComboAndRecommend = new RadioBarBeanList();
    BaseRadioBarAdapter mComboAndRecommendAdapter;

    class ComboAndRecommendType {
        public static final int RECOMMEND = 1;
        public static final int COMBO = 2;
    }

    HorizontalListView mComboAndRecommendListView;
    LinearLayout mComboBarScrollView, mComboContentScrollView;
    GoodsCombo mGoodsCombo;
    GoodsCycleView mGoodsCycleView;
    GoodsCycleView.GoodsCycleViewListener mGoodsCycleViewListener = new GoodsCycleView.GoodsCycleViewListener() {

        @Override
        public void onClick(JSONObject jsonObject, View view) {
            // TODO Auto-generated method stub
            String nGoodsId = jsonObject.optString("goods_id");
            if (mProductDic == null || mProductDic.isNull(nGoodsId)) {
                return;
            }
            Bundle nBundle = new Bundle();
            nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductDic.optString(nGoodsId));
            startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
        }

        @Override
        public void displayImage(JSONObject imageURLJson, ImageView imageView) {
            // TODO Auto-generated method stub
            displaySquareImage(imageView, imageURLJson.optString("image_default_id"));
        }
    };

    ShoppCarAddInterface mAddCarInterface = new ShoppCarAddInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Run.goodsCounts += getQty();
            setShopcarCount(Run.goodsCounts);
        }

    };

    MemberAddFavInterface mAddFavInterface = new MemberAddFavInterface(this, "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Run.alert(mActivity, "收藏成功");
            try {
                mProductBasicJsonObject.put("is_fav", true);
                setCollection(true);
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    };
    MemberDelFavInterface mDelFavInterface = new MemberDelFavInterface(this, "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Run.alert(mActivity, "删除收藏成功");
            try {
                mProductBasicJsonObject.put("is_fav", false);
                setCollection(false);
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    };

    GoodsProductIndexInterface mGoodsProductIndexInterface = new GoodsProductIndexInterface(this, "") {

        @Override
        public void ResponseBtns(JSONArray btnArray) {
            mBtnArray = btnArray;
            praseBtns();
        }

        @Override
        public void ResponseData(JSONObject jsonObject) {
            // TODO Auto-generated method stub
            rootView.setVisibility(View.VISIBLE);
            mProductJsonObject = jsonObject;
            JSONObject mGoodsPointJsonObject = jsonObject.optJSONObject("goods_point");
            String nString = StringUtils.getString(mGoodsPointJsonObject, "best_avg");
            if (!TextUtils.isEmpty(nString)) {
                nString = String.format("好评率%s", nString);
            } else {
                nString = "暂无好评";
            }
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_comment_breif)).setText(nString);
            ((RatingBar) mPagerUpView.findViewById(R.id.goods_detail_comment_rat)).setRating(mGoodsPointJsonObject == null ? 0.00f : (float) mGoodsPointJsonObject.optDouble("avg"));
            mGoodsBottomView.setDatas(jsonObject.optJSONObject("page_product_basic"), jsonObject.optJSONObject("setting"), jsonObject.optJSONArray("async_request_list"));

            mServiceTagArray = mProductJsonObject.optJSONArray("service_tag_list");
            parseServiceTag();
        }

        @Override
        public void ResponseSetting(JSONObject jsonObject) {
            // TODO Auto-generated method stub
            mSettingsonObject = jsonObject;
            parseSetting();
        }

        @Override
        public void ResponseBasic(JSONObject jsonObject) {
            // TODO Auto-generated method stub
            try {
                jsonObject.put(GoodsUtil.CHOOSED_QTY, "1");
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            mProductBasicJsonObject = jsonObject;
            GoodsUtil.putSpoor(mActivity, mProductBasicJsonObject);
            new GoodsLinkInterface(GoodsDetailFragment.this, mProductBasicJsonObject.optString("goods_id")) {

                @Override
                public void responseGoodsLink(JSONArray linkArray, JSONObject productDic) {
                    // TODO Auto-generated method stub
                    mGoodsLinkArray = linkArray;
                    mProductDic = productDic;
                    parseGoodsLink();
                }

                @Override
                public void FailRequest() {
                    parseGoodsLink();
                }
            }.RunRequest();
            parseBaisc();
        }

        @Override
        public void ResponseParts(JSONArray array, JSONObject imageJsonObject) {
            // TODO Auto-generated method stub
            mComboArray = array;
            mComboImageJsonObject = imageJsonObject;
            parseCombo();
        }

        @Override
        public void ResponseDIYTab(JSONArray array) {
            // TODO Auto-generated method stub
            mDIYTabArray = array;
        }
    };
    GetOnlineSeveiceInterface mGetOnlineSeveiceInterface = new GetOnlineSeveiceInterface(this) {

        @Override
        public void responseService(String type, String serviceValue) {
            // TODO Auto-generated method stub
            if (type.equals(GetOnlineSeveiceInterface.QQ)) {
                String url = String.format("mqqwpa://im/chat?chat_type=wpa&uin=%s", serviceValue);
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
            } else if (type.equals(GetOnlineSeveiceInterface.WECHAT)) {
                Run.alert(mActivity, "微信客服接口已关闭");
            } else if (type.equals(GetOnlineSeveiceInterface.THRID)) {
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(serviceValue)));
            } else {
                Run.alert(mActivity, "客服数据有误");
            }
        }
    };

    GoodServiceInfoInterface mServiceInfoInterface = new GoodServiceInfoInterface(this) {
        @Override
        public void SuccCallBack(JSONObject responseJson) {

            mServiceJsonObject = responseJson;

            showDialog();

            mServiceInfoDialog.show();
        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mActionBar.setTitle(R.string.goods_detail);

        Intent data = mActivity.getIntent();
        Bundle nBundle = data.getExtras();
        mProductIID = nBundle.getString(Run.EXTRA_PRODUCT_ID);
        isGift = getExtraBooleanFromBundle(Run.EXTRA_VALUE);

        mToolGroupPopupWindow = new ToolGroupPopupWindow(this);

        mPromotionPadding = Run.dip2px(mActivity, 10);

        mActionBar.setRightImageButton(R.drawable.more, new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                mToolGroupPopupWindow.showAsDropDown(v, -Run.dip2px(mActivity, 90), 0);
            }
        });
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.init(inflater, container, savedInstanceState);

        mResources = mActivity.getResources();

        rootView = inflater.inflate(R.layout.fragment_goods_detail, null);
        mPagerUpView = (ScrollView) inflater.inflate(R.layout.fragment_goods_detail_up, null);
        rootView.setVisibility(View.INVISIBLE);

        mServiceButton = (ImageButton) findViewById(R.id.goods_detail_service);
        mCollectionButton = (ImageButton) findViewById(R.id.goods_detail_like);
        mCollectionTextView = (TextView) findViewById(R.id.goods_detail_like_tv);
        mShopcarButton = (ImageButton) findViewById(R.id.goods_detail_shoppingcar);
        mShopcarCountTextView = (TextView) findViewById(R.id.shopcar_count);
        findViewById(R.id.goods_detail_service_title).setOnClickListener(this);
        mShopcarButton.setOnClickListener(this);
        mCollectionButton.setOnClickListener(this);
        mServiceButton.setOnClickListener(this);

        mGoodsBottomView = new GoodsBottomView(mActivity) {

            @Override
            public BaseDoFragment ParentFragment() {
                // TODO Auto-generated method stub
                return GoodsDetailFragment.this;
            }
        };
        mPagerMoreView = inflater.inflate(R.layout.goods_shopp_detail_pager_more, null);

        initMain();
        initUp();

        initTitleBar();

        loadData();
    }

    void initTitleBar() {
        View nTitleBarView = View.inflate(mActivity, R.layout.title_goods_detail, null);
        mTitleBarListView = (LinearLayout) nTitleBarView.findViewById(R.id.bar_list_view);
        mTitleRadioBarAdapter = new GoodsDetailTitleRadioBarAdapter(mActivity, mTitleBarBeans, new RadioBarCallback() {

            @Override
            public boolean showRadioBarsDivider() {
                // TODO Auto-generated method stub
                return false;
            }

            @Override
            public int parentWindowsWidth() {
                // TODO Auto-generated method stub
                return 0;
            }

            @Override
            public boolean onSelectedRadioBar(RadioBarBean barBean) {
                // TODO Auto-generated method stub
                if (barBean.mId == TITLE_RADIO_BAR_GOODS) {
                    if (needChangeSelected) {

                    } else {
                        mPagerView.setCurrentItem(0, true);
                        mPagerUpView.smoothScrollTo(0, 0);
                    }
                } else if (barBean.mId == TITLE_RADIO_BAR_DETAIL) {
                    if (needChangeSelected) {

                    } else {
                        mPagerView.setCurrentItem(1, true);
                        mGoodsBottomView.scrollTo(0, 0);
                    }
                } else if (barBean.mId == TITLE_RADIO_BAR_RECOMMEND) {

                }
                return false;
            }
        }) {
            @Override
            public void onItemChangeChick(int position, int oldPosition, View itemView) {
                // TODO Auto-generated method stub
                if (getItem(position).mId == TITLE_RADIO_BAR_RECOMMEND) {
                    Bundle nCommentBundle = new Bundle();
                    nCommentBundle.putString(Run.EXTRA_GOODS_ID, mProductBasicJsonObject.optString("goods_id"));
                    startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_COMMENT, nCommentBundle);
                } else {
                    needChangeSelected = false;
                    super.onItemChangeChick(position, oldPosition, itemView);
                }
            }

            @Override
            public void notifyDataSetChanged() {
                // TODO Auto-generated method stub
                mTitleBarListView.removeAllViews();
                for (int i = 0; i < getCount(); i++) {
                    mTitleBarListView.addView(getView(i, null, null));
                }
            }
        };
        mTitleBarBeans.add(new RadioBarBean("商品", TITLE_RADIO_BAR_GOODS));
        mTitleBarBeans.add(new RadioBarBean("详情", TITLE_RADIO_BAR_DETAIL));
        mTitleBarBeans.add(new RadioBarBean("评价", TITLE_RADIO_BAR_RECOMMEND));
        // mTitleBarListView.setAdapter(mTitleRadioBarAdapter);
        mActionBar.setCustomTitleView(nTitleBarView);

        nTitleBarView.findViewById(R.id.share).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
            }
        });
    }

    @Override
    public void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        setShopcarCount(Run.goodsCounts);
        mToolGroupPopupWindow.setNews();
    }

    void setShopcarCount(int count) {
        mShopcarCountTextView.setVisibility(count <= 0 ? View.GONE : View.VISIBLE);
        if (count < 100) {
            mShopcarCountTextView.setText(String.valueOf(count));
        } else {
            mShopcarCountTextView.setText("99+");
        }
    }

    void setCollection(boolean collectioned) {
        mCollectionButton.setSelected(collectioned);
        mCollectionTextView.setText(collectioned ? "已收藏" : "收藏");
        mCollectionButton.setImageResource(collectioned ? R.drawable.goods_detail_collectioned : R.drawable.goods_detail_collection);
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        switch (v.getId()) {
            case R.id.goods_detail_spec_ll:
                mGoodsSpecDialog.setData(mProductBasicJsonObject, mBtnArray, false);
                mGoodsSpecDialog.show();
                break;
            case R.id.goods_detail_prop_ll:
                mGoodsProptyDialog.setData(mPropArray);
                mGoodsProptyDialog.show();
                break;
            case R.id.goods_detail_consult_rl:
                Bundle nBundle = new Bundle();
                nBundle.putString(Run.EXTRA_GOODS_ID, mProductBasicJsonObject.optString("goods_id"));
                startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_CONSULT, nBundle);
                break;
            case R.id.goods_detail_comment_rl:
                Bundle nCommentBundle = new Bundle();
                nCommentBundle.putString(Run.EXTRA_GOODS_ID, mProductBasicJsonObject.optString("goods_id"));
                startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_COMMENT, nCommentBundle);
                break;
            case R.id.goods_detail_addto_shopcar:
                if (mProductBasicJsonObject == null) {
                    Run.alert(mActivity, "正在加载商品数据，请稍后");
                    return;
                }
                mGoodsSpecDialog.setData(mProductBasicJsonObject, mBtnArray, false);
                mGoodsSpecDialog.show();
                break;
            case R.id.goods_detail_buy:
                if (mProductBasicJsonObject == null) {
                    Run.alert(mActivity, "正在加载商品数据，请稍后");
                    return;
                }
                mGoodsSpecDialog.setData(mProductBasicJsonObject, mBtnArray, true);
                mGoodsSpecDialog.show();
                break;
            case R.id.goods_detail_shoppingcar:// 购物车
                startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_CAR);
                break;
            case R.id.goods_detail_like:// 收藏
                if (mCollectionButton.isSelected()) {
                    mDelFavInterface.delFav(mProductBasicJsonObject.optString("goods_id"));
                } else {
                    mAddFavInterface.addFav(mProductBasicJsonObject.optString("goods_id"));
                }
                break;
            case R.id.goods_detail_service:// 客服
            case R.id.goods_detail_service_title:

                if(!LoginedUser.getInstance().isLogined()){
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
                    return;
                }
                mGetOnlineSeveiceInterface.RunRequest();
//                if (mServiceJsonObject == null) {
//                    mServiceInfoInterface.RunRequest();
//                } else {
//                    mServiceInfoDialog.show();
//                }
                break;
            case R.id.goods_detail_brand_ll:
                JSONObject nBrandJsonObject = mProductBasicJsonObject.optJSONObject("brand");
                Bundle nBrandBundle = new Bundle();
                nBrandBundle.putString(Run.EXTRA_BRAND_ID, nBrandJsonObject.optString("brand_id"));
                nBrandBundle.putString(Run.EXTRA_TITLE, nBrandJsonObject.optString("brand_name"));
                startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_LIST, nBrandBundle);
                break;

            default:
                super.onClick(v);
                break;
        }
    }

    void initMain() {
        mShareViewPopupWindow = new ShareViewPopupWindow(mActivity);
        mShareViewPopupWindow.setDataSource(this);

        mPagerView = (GoodsDetailViewPager) rootView.findViewById(R.id.fragment_goods_detail_viewpager);
        mPagerView.setAdapter(new MyPagerViewAdapter());
        mPagerView.setOnPageChangeListener(new OnPageChangeListener() {

            @Override
            public void onPageSelected(int position) {
                // TODO Auto-generated method stub
                if (position == 0) {
                    if (needChangeSelected) {
                        mTitleRadioBarAdapter.setSelected(0);
                    } else {
                        needChangeSelected = true;
                    }

                } else if (position == 1) {
                    if (needChangeSelected) {
                        mTitleRadioBarAdapter.setSelected(1);
                    } else {
                        needChangeSelected = true;
                    }
                }
            }

            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                // TODO Auto-generated method stub

            }

            @Override
            public void onPageScrollStateChanged(int state) {
                // TODO Auto-generated method stub

            }
        });

        mAddtoCarButton = (Button) findViewById(R.id.goods_detail_addto_shopcar);
        mAddtoCarButton.setOnClickListener(this);
        mBuyButton = (Button) findViewById(R.id.goods_detail_buy);
        mBuyButton.setOnClickListener(this);
    }

    void initUp() {
        mGoodsSpecDialog = new GoodsSpecDialog(mActivity, this) {
            @Override
            public void updateQty(JSONObject productBasicJsonObject) {
                // TODO Auto-generated method stub
                mProductBasicJsonObject = productBasicJsonObject;
                parseSpec();
            }

            @Override
            public void dismiss() {
                // TODO Auto-generated method stub
                super.dismiss();
                setShopcarCount(Run.goodsCounts);
            }

            @Override
            public List<AdjunctBean> getAdjuncts() {
                // TODO Auto-generated method stub
                return mGoodsCombo.getChoosedAdjunct();
            }
        };
        mGoodsSpecDialog.setIsGift(isGift);
        mGoodsSpecDialog.setProductBasicHandler(new ProductBasicHandler() {

            @Override
            public void ResponseBtns(JSONArray btnArray) {
                mBtnArray = btnArray;
                praseBtns();
            }

            @Override
            public void ResponseSetting(JSONObject jsonObject) {
                // TODO Auto-generated method stub
                mSettingsonObject = jsonObject;
                parseSetting();
            }

            @Override
            public void ResponseBasic(JSONObject jsonObject) {
                // TODO Auto-generated method stub
                mProductBasicJsonObject = jsonObject;
                parseBaisc();
            }
        });

        mComboBarScrollView = (LinearLayout) mPagerUpView.findViewById(R.id.goods_detail_combo_bar_list);
        mComboContentScrollView = (LinearLayout) mPagerUpView.findViewById(R.id.goods_detail_combo_goods_list);
        mGoodsCombo = new GoodsCombo(this, mComboBarScrollView, mComboContentScrollView) {

            @Override
            public void addAdjunctToCar(int groupId, int productId, int qty) {
                // TODO Auto-generated method stub
                mAddCarInterface.setData(mProductBasicJsonObject.optString("goods_id"), mProductBasicJsonObject.optString("product_id"), 1);
                mAddCarInterface.addAdjunct(groupId, productId, qty);
                mAddCarInterface.RunRequest();
            }

        };
        mComboAndRecommendAdapter = new BaseRadioBarAdapter(mActivity, mComboAndRecommend, new BaseRadioBarAdapter.RadioBarCallback() {

            @Override
            public boolean showRadioBarsDivider() {
                // TODO Auto-generated method stub
                return true;
            }

            @Override
            public int parentWindowsWidth() {
                // TODO Auto-generated method stub
                return Run.getWindowsWidth(mActivity);
            }

            @Override
            public boolean onSelectedRadioBar(RadioBarBean barBean) {
                // TODO Auto-generated method stub
                if (barBean.mId == ComboAndRecommendType.COMBO) {
                    mPagerUpView.findViewById(R.id.goods_detail_combo_bar_hs).setVisibility(View.VISIBLE);
                    mPagerUpView.findViewById(R.id.goods_detail_combo_goods_hs).setVisibility(View.VISIBLE);
                    mGoodsCombo.notifyData();
                    mPagerUpView.findViewById(R.id.goods_recommend).setVisibility(View.GONE);
                } else {
                    mPagerUpView.findViewById(R.id.goods_detail_combo_bar_hs).setVisibility(View.GONE);
                    mPagerUpView.findViewById(R.id.goods_detail_combo_goods_hs).setVisibility(View.GONE);
                    mPagerUpView.findViewById(R.id.goods_recommend).setVisibility(View.VISIBLE);
                }
                return false;
            }
        });
        mComboAndRecommend.add(0, new RadioBarBean("配件推荐", ComboAndRecommendType.COMBO));
        mComboAndRecommend.add(new RadioBarBean("猜您喜欢", ComboAndRecommendType.RECOMMEND));
        mComboAndRecommendListView = (HorizontalListView) mPagerUpView.findViewById(R.id.goods_detail_recommend_bar_list);
        mComboAndRecommendAdapter.setVisibleRadios(2);
        mComboAndRecommendListView.setAdapter(mComboAndRecommendAdapter);
        mComboAndRecommendAdapter.notifyDataSetChanged();

        mGoodsCycleView = (GoodsCycleView) mPagerUpView.findViewById(R.id.goods_recommend);

        mGoodsProptyDialog = new GoodsProptyDialog(mActivity);

        mPagerUpView.findViewById(R.id.goods_detail_consult_rl).setOnClickListener(this);
        mPagerUpView.findViewById(R.id.goods_detail_prop_ll).setOnClickListener(this);
        mPagerUpView.findViewById(R.id.goods_detail_spec_ll).setOnClickListener(this);
        mPagerUpView.findViewById(R.id.goods_detail_brand_ll).setOnClickListener(this);
        mPagerUpView.findViewById(R.id.goods_detail_comment_rl).setOnClickListener(this);

        mTagFlowLayout = (FlowLayout) mPagerUpView.findViewById(R.id.goods_detail_tag);
    }

    void loadData() {
        mGoodsProductIndexInterface.setProductIdString(mProductIID, isGift);
        excuteJsonTask(mGoodsProductIndexInterface);
    }

    void praseBtns() {
        if (mBtnArray == null) {
            return;
        }

        boolean canFastBuy = false, canAddcar = false;
        for (int i = 0; i < mBtnArray.length(); i++) {
            JSONObject nJsonObject = mBtnArray.optJSONObject(i);
            if (nJsonObject.optString("value").equals("fastbuy")) {
                mBuyButton.setText(nJsonObject.optString("name"));
                canFastBuy = true;
            } else if (nJsonObject.optString("value").equals("buy")) {
                mAddtoCarButton.setText(nJsonObject.optString("name"));
                canAddcar = true;
            }
        }

        mBuyButton.setVisibility(canFastBuy ? View.VISIBLE : View.GONE);
        mAddtoCarButton.setVisibility(canAddcar ? View.VISIBLE : View.GONE);
    }

    /**
     * "setting": {//配置信息 "acomment": { "switch": { "ask": "on",//on开启商品咨询否则关闭
     * "discuss": "on"//on开启商品评论否则关闭 }, "point_status": "on"//on商品开启否则关闭 },
     * "recommend": "true",//true商品开启推荐否则关闭推荐 "selllog":
     * "true",//true开启商品销售记录否则关闭销售记录 "buytarget": "3"//加入购物车按钮跳转方式：1.跳转到购物车页面
     * 2.不跳转，不提示 3.不跳转，弹出购物车提示 },
     */
    void parseSetting() {
        if (mSettingsonObject == null) {
            mTitleRadioBarAdapter.notifyDataSetChanged();
            return;
        }

        JSONObject mCommentJsonObject = mSettingsonObject.optJSONObject("acomment");
        if (mCommentJsonObject != null) {
            JSONObject mSwitch = mCommentJsonObject.optJSONObject("switch");
            if (mSwitch != null) {
                if ("on".equals(mSwitch.optString("discuss"))) {
                    mPagerUpView.findViewById(R.id.goods_detail_comment_rl).setVisibility(View.VISIBLE);
                } else {
                    mPagerUpView.findViewById(R.id.goods_detail_comment_rl).setVisibility(View.GONE);
                    if (mTitleBarBeans.size() > 2) {
                        mTitleBarBeans.remove(2);
                    }
                }

                mPagerUpView.findViewById(R.id.goods_detail_consult_rl).setVisibility("on".equals(mSwitch.optString("ask")) ? View.VISIBLE : View.GONE);
                if (mPagerUpView.findViewById(R.id.goods_detail_consult_rl).isShown()) {
                    ((TextView) mPagerUpView.findViewById(R.id.goods_detail_consult)).setText(String.format("点击查看购买咨询（%s）", mProductJsonObject.optString("askCount")));
                }
            }
        }
        mTitleRadioBarAdapter.notifyDataSetChanged();
    }

    void parseCombo() {
        if (mComboArray == null || mComboArray.length() <= 0) {
            if (mComboAndRecommend.size() > 0 && mComboAndRecommend.get(0).mId == ComboAndRecommendType.COMBO) {
                mComboAndRecommend.remove(0);
                mComboAndRecommendAdapter.notifyDataSetChanged();
                if (mComboAndRecommendAdapter.getCount() > 0) {
                    mComboAndRecommendAdapter.onSelectedChanged(0);
                }
            }
            return;
        }

        mPagerUpView.findViewById(R.id.goods_detail_recommend_ll).setVisibility(View.VISIBLE);
        mGoodsCombo.setData(mComboArray, mComboImageJsonObject);
    }

    void parseGoodsLink() {
        if (mGoodsLinkArray == null || mGoodsLinkArray.length() <= 0) {
            if (mComboAndRecommend.size() > 0 && mComboAndRecommend.get(mComboAndRecommend.size() - 1).mId == ComboAndRecommendType.RECOMMEND) {
                mComboAndRecommend.remove(mComboAndRecommend.size() - 1);
                mComboAndRecommendAdapter.notifyDataSetChanged();
                if (mComboAndRecommendAdapter.getCount() > 0) {
                    mComboAndRecommendAdapter.onSelectedChanged(0);
                }
            }
            return;
        }

        mPagerUpView.findViewById(R.id.goods_detail_recommend_ll).setVisibility(View.VISIBLE);
        ArrayList<JSONObject> nArrayList = new ArrayList<JSONObject>();
        for (int i = 0; i < mGoodsLinkArray.length(); i++) {
            nArrayList.add(mGoodsLinkArray.optJSONObject(i));
        }
        mGoodsCycleView.setImageResources(nArrayList, mGoodsCycleViewListener);
    }

    void parseServiceTag() {
        if (mServiceTagArray == null || mServiceTagArray.length() <= 0) {
            mPagerUpView.findViewById(R.id.goods_detail_tag_ll).setVisibility(View.GONE);
            return;
        }

        mTagFlowLayout.removeAllViews();
        mPagerUpView.findViewById(R.id.goods_detail_tag_ll).setVisibility(View.VISIBLE);
        for (int i = 0; i < mServiceTagArray.length(); i++) {
            JSONObject nJsonObject = mServiceTagArray.optJSONObject(i);
            View nView = View.inflate(mActivity, R.layout.item_goods_detail_service_tag, null);
            ((TextView) nView.findViewById(R.id.name)).setText(nJsonObject.optString("name"));
            mTagFlowLayout.addView(nView);
        }
    }

    /**
     * 显示弹窗
     */
    void showDialog() {

        mServiceInfoDialog = new Dialog(mActivity, R.style.Theme_dialog);

        View view = null;
        try {
            view = LayoutInflater.from(mActivity).inflate(R.layout.good_service_info_dialog, null);

            mServiceInfoTextView = (TextView) view.findViewById(R.id.service_info);

            StringBuilder infoString = new StringBuilder();

            String ownerString = mServiceJsonObject.optString("owner");

            if (!TextUtils.isEmpty(ownerString)) {

                infoString.append("上线:" + ownerString + "\n");
            }

            String contactString = mServiceJsonObject.optString("contact");

            if (!TextUtils.isEmpty(contactString)) {

                infoString.append("联系人:" + contactString + "\n");
            }

            String telephone = mServiceJsonObject.optString("telephone");

            if (!TextUtils.isEmpty(telephone)) {

                infoString.append("固定电话:" + telephone + "\n");
            }

            String mobile = mServiceJsonObject.optString("mobile");

            if (!TextUtils.isEmpty(mobile)) {

                infoString.append("手机:" + mobile + "\n");
            }

            String email = mServiceJsonObject.optString("email");

            if (!TextUtils.isEmpty(email)) {

                infoString.append("邮箱:" + email + "\n");
            }

            String qq = mServiceJsonObject.optString("qq");

            if (!TextUtils.isEmpty(qq)) {

                infoString.append("QQ:" + qq + "\n");
            }

            String area = mServiceJsonObject.optString("address");

            if (!TextUtils.isEmpty(area)) {

                if (area.contains("main")) {

                    infoString.append("联系地址:" + StringUtils.FormatArea(area));
                } else {

                    infoString.append("联系地址:" + area);
                }
            }

            mServiceInfoTextView.setText(infoString);

            view.findViewById(R.id.close_dialog_button).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    mServiceInfoDialog.dismiss();
                }
            });

            Button okBtn = (Button) view.findViewById(R.id.dialog_add_contact_btn);
            okBtn.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub

                    Intent it = new Intent(Intent.ACTION_INSERT, Uri.withAppendedPath(
                            Uri.parse("content://com.android.contacts"), "contacts"));
                    it.setType("vnd.android.cursor.dir/person");

                    String ownerString = mServiceJsonObject.optString("owner");

                    String contactString = mServiceJsonObject.optString("contact");

                    String telephone = mServiceJsonObject.optString("telephone");

                    String mobile = mServiceJsonObject.optString("mobile");

                    String email = mServiceJsonObject.optString("email");

                    String qq = mServiceJsonObject.optString("qq");

                    String area = mServiceJsonObject.optString("address");

                    String realArea = "";

                    if (!TextUtils.isEmpty(area)) {

                        if (area.contains("main")) {

                            realArea = StringUtils.FormatArea(area);
                        } else {

                            realArea = area;
                        }
                    }

// 联系人姓名
                    it.putExtra(android.provider.ContactsContract.Intents.Insert.NAME, TextUtils.isEmpty(contactString) ? "" : contactString);
// 公司
//                        it.putExtra(android.provider.ContactsContract.Intents.Insert.COMPANY,
//                                "北京XXXXXX公司");
// email
                    it.putExtra(android.provider.ContactsContract.Intents.Insert.EMAIL,
                            TextUtils.isEmpty(email) ? "" : email);
// 手机号码
                    it.putExtra(android.provider.ContactsContract.Intents.Insert.PHONE,
                            TextUtils.isEmpty(mobile) ? "" : mobile);

// 住宅电话
                    it.putExtra(
                            android.provider.ContactsContract.Intents.Insert.TERTIARY_PHONE,
                            TextUtils.isEmpty(telephone) ? "" : telephone);

                    startActivity(it);

                    mServiceInfoDialog.dismiss();
                }
            });
        } catch (Exception e) {
            // TODO: handle exception
            Log.w(Run.TAG, e.getMessage());
        }

        mServiceInfoDialog.setContentView(view);

        mServiceInfoDialog.setCanceledOnTouchOutside(true);
    }

    /**
     * 商品基本信息
     */
    void parseBaisc() {
        if (mProductBasicJsonObject == null) {
            return;
        }
        setCollection(mProductBasicJsonObject.optBoolean("is_fav", false));

        // 商品简介
        String nBrief = StringUtils.getString(mProductBasicJsonObject, "brief");
        mPagerUpView.findViewById(R.id.goods_detail_breif_ll).setVisibility(TextUtils.isEmpty(nBrief) ? View.GONE : View.VISIBLE);
        ((TextView) mPagerUpView.findViewById(R.id.goods_detail_brief)).setText(nBrief);

        // 商品属性
        mPropArray = mProductBasicJsonObject.optJSONArray("props");
        mPagerUpView.findViewById(R.id.goods_detail_prop_ll).setVisibility(mPropArray == null || mPropArray.length() <= 0 ? View.GONE : View.VISIBLE);

        parseBanner();

        ((TextView) mPagerUpView.findViewById(R.id.goods_detail_title)).setText(mProductBasicJsonObject.optString("title"));
        parsePrice();

        if (mProductBasicJsonObject.optBoolean("is_gift", false)) {
            mPagerUpView.findViewById(R.id.goods_detail_brief_tr).setVisibility(View.GONE);
            mPagerUpView.findViewById(R.id.goods_detail_gift_tr).setVisibility(View.VISIBLE);
        } else {
            String nBuyCount = StringUtils.getString(mProductBasicJsonObject, "buy_count");
            String nStore = StringUtils.getString(mProductBasicJsonObject, "store_title");
            if (!TextUtils.isEmpty(nBuyCount) && Integer.parseInt(nBuyCount) > 0) {
                nBuyCount = "月销：<font color='#333333'>" + nBuyCount + StringUtils.getString(mProductBasicJsonObject, "unit") + "</font>";
            } else {
                nBuyCount = "";
            }

            if (!TextUtils.isEmpty(nStore)) {
                nStore = "库存：<font color='#333333'>" + mProductBasicJsonObject.optString("store_title") + "</font>";
            }

            String nQuota = "";
            if ("starbuy".equals(mProductBasicJsonObject.optString("promotion_type"))) {// 秒杀
                if (!mProductBasicJsonObject.isNull("special_info")) {
                    JSONObject nSpecialJsonObject = mProductBasicJsonObject.optJSONObject("special_info");
                    nQuota = String.format("限购：<font color='#F3273F'>%s%s</font>", nSpecialJsonObject.optString("limit"), StringUtils.getString(mProductBasicJsonObject, "unit"));
                }
            }

            if (TextUtils.isEmpty(nStore) && TextUtils.isEmpty(nStore) && TextUtils.isEmpty(nQuota)) {// 销量和库存、限购为空时销量库存栏影藏
                mPagerUpView.findViewById(R.id.goods_detail_brief_tr).setVisibility(View.GONE);
            } else {
                if (!TextUtils.isEmpty(nQuota)) {
                    ((TextView) mPagerUpView.findViewById(R.id.goods_detail_quota)).setText(Html.fromHtml(nQuota));
                }
                mPagerUpView.findViewById(R.id.goods_detail_quota_ll).setVisibility(TextUtils.isEmpty(nQuota) ? View.GONE : View.VISIBLE);
                if (!TextUtils.isEmpty(nBuyCount)) {
                    ((TextView) mPagerUpView.findViewById(R.id.goods_detail_volume)).setText(Html.fromHtml(nBuyCount));
                }
                mPagerUpView.findViewById(R.id.goods_detail_volume_ll).setVisibility(TextUtils.isEmpty(nBuyCount) ? View.GONE : View.VISIBLE);
                if (!TextUtils.isEmpty(nStore)) {
                    ((TextView) mPagerUpView.findViewById(R.id.goods_detail_store)).setText(Html.fromHtml(nStore));
                }
                mPagerUpView.findViewById(R.id.goods_detail_store_ll).setVisibility(TextUtils.isEmpty(nStore) ? View.GONE : View.VISIBLE);
            }
        }

        parsePromotion();

        parseBrand();
        parseSpec();
    }

    /**
     * 选中规格
     */
    void parseSpec() {
        if (mProductBasicJsonObject == null) {
            return;
        }

        mSpecArray = mProductBasicJsonObject.optJSONArray("spec");
        if (mSpecArray == null) {
            mPagerUpView.findViewById(R.id.goods_detail_spec_ll).setVisibility(View.GONE);
            return;
        }

        String nQtyDisplay = mProductBasicJsonObject.optString(GoodsUtil.CHOOSED_QTY) + StringUtils.getString(mProductBasicJsonObject, "unit");
        StringBuilder nDisplay = new StringBuilder();
        nDisplay.append(nQtyDisplay).append("、").append(GoodsUtil.formatChoosedSpec(mSpecArray));
        if (nDisplay.charAt(nDisplay.length() - 1) == '、') {
            nDisplay.deleteCharAt(nDisplay.length() - 1);
        }
        ((TextView) mPagerUpView.findViewById(R.id.goods_detail_spec)).setText(nDisplay.toString());
        nDisplay.delete(0, nDisplay.length());
    }

    /**
     * 顶部轮播图
     */
    void parseBanner() {
        if (mProductBasicJsonObject == null || mProductBasicJsonObject.isNull("images")) {
            return;
        }

        JSONArray nArray = mProductBasicJsonObject.optJSONArray("images");
        ImageCycleView<String> nCycleView = (ImageCycleView<String>) mPagerUpView.findViewById(R.id.goods_detail_images);
        ArrayList<String> nJsonObjects = new ArrayList<String>();
        for (int i = 0; i < nArray.length(); i++) {
            nJsonObjects.add(nArray.optString(i));
        }
        nCycleView.setImageResources(nJsonObjects, new ImageCycleViewListener<String>() {

            @Override
            public void onImageClick(int position, View imageView) {
                // TODO Auto-generated method stub

            }

            @Override
            public void displayImage(String imageURL, ImageView imageView) {
                // TODO Auto-generated method stub
                displaySquareImage(imageView, imageURL);
            }
        });
    }

    /**
     * 商品价格（销售价、市场价、会员价等）
     */
    void parsePrice() {
        if (mProductBasicJsonObject == null) {
            return;
        }

        mPagerUpView.findViewById(R.id.goods_detail_prepare_ll).setVisibility(View.GONE);

        mPriceJsonObject = mProductBasicJsonObject.optJSONObject("price_list");

        View nPriceView = mPagerUpView.findViewById(R.id.goods_detail_price_rl);
        // 销售价
        TextView nPriceTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_price);
        TextView nPriceTipTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_price_tip);

        // 最低会员价
        TextView nMinPriceTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_minprice);
        TextView nMinPriceTipTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_minprice_tip);

        // 市场价
        TextView nMktPriceTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_mktprice);
        TextView nMktPriceTipTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_mktprice_tip);

        //分销佣金
        TextView nFxPriceTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_fxprice);
        TextView nFxPriceTipTextView = (TextView) nPriceView.findViewById(R.id.goods_detail_fxprice_tip);

        JSONObject nShowJsonObject = mPriceJsonObject.optJSONObject("show");

        if ("starbuy".equals(mProductBasicJsonObject.optString("promotion_type"))) {// 秒杀
            nMktPriceTextView.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
            mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.GONE);

            nPriceView.findViewById(R.id.goods_detail_time_ll).setVisibility(View.VISIBLE);

            parseCountDownView();
        } else if ("prepare".equals(mProductBasicJsonObject.optString("promotion_type"))) {// 预售
            mPagerUpView.findViewById(R.id.goods_detail_prepare_ll).setVisibility(View.VISIBLE);
            mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.GONE);

            JSONObject nPrepareJsonObject = mProductBasicJsonObject.optJSONObject("prepare");
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_prepare_status)).setText(nPrepareJsonObject.optString("message"));
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_prepare_remark)).setText(nPrepareJsonObject.optString("description"));
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_prepare_rule)).setText(nPrepareJsonObject.optString("preparename"));

            mPagerUpView.findViewById(R.id.goods_detail_brief_tr).setVisibility(View.GONE);
            mAddtoCarButton.setText("立即购买");
        } else if (mProductBasicJsonObject.optBoolean("is_gift", false)) {
            mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.GONE);

            nPriceView.findViewById(R.id.goods_detail_time_ll).setVisibility(View.VISIBLE);
            nPriceView.findViewById(R.id.goods_detail_time).setVisibility(View.GONE);

            JSONObject nGiftJsonObject = mProductBasicJsonObject.optJSONObject("gift");
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_time_tip))
                    .setText(String.format("起止时间%s至%s", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", nGiftJsonObject.optLong("from_time")),
                            StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", nGiftJsonObject.optLong("to_time"))));

            nPriceTipTextView.setText("兑换所需贝壳：");
            nPriceTextView.setText(nGiftJsonObject.optString("consume_score"));
            nMktPriceTextView.setText("");

            StringBuilder nBuilder = new StringBuilder();
            JSONArray nMemberArray = nGiftJsonObject.optJSONArray("member_lv_data");
            if (nMemberArray != null && nMemberArray.length() > 0) {
                nBuilder.append("可兑换会员：");
                for (int i = 0; i < nMemberArray.length(); i++) {
                    nBuilder.append(nMemberArray.optJSONObject(i).optString("name")).append("/");
                }
                nBuilder.delete(nBuilder.length() - 1, nBuilder.length());
            }
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_gift_remark)).setText(nBuilder.toString());
            nBuilder.delete(0, nBuilder.length());
            ((TextView) mPagerUpView.findViewById(R.id.goods_detail_gift_limit)).setText(String.format("限兑：%s%s", nGiftJsonObject.optString("max"),
                    StringUtils.getString(mProductBasicJsonObject, "unit")));
            mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.GONE);

            mAddtoCarButton.setText("兑换赠品");
            return;
        } else {
            nMktPriceTextView.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
            nPriceView.findViewById(R.id.goods_detail_time_ll).setVisibility(View.GONE);

            if (mPriceJsonObject.has("minprice") && !mPriceJsonObject.isNull("minprice")) {
                JSONObject nMinJsonObject = mPriceJsonObject.optJSONObject("minprice");
                mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.VISIBLE);
                nMinPriceTipTextView.setText(nMinJsonObject.optString("name"));
                nMinPriceTextView.setText(nMinJsonObject.optString("format"));
            } else {
                mPagerUpView.findViewById(R.id.goods_detail_minprice_ll).setVisibility(View.GONE);
            }
            mAddtoCarButton.setText("加入购物车");
        }

        if (nShowJsonObject != null) {
            nPriceTipTextView.setText(nShowJsonObject.optString("name"));
            nPriceTextView.setText(nShowJsonObject.optString("format"));
        }

        JSONObject nMktPriceJsonObject = mPriceJsonObject.optJSONObject("mktprice");
        if (nMktPriceJsonObject != null && !nMktPriceJsonObject.isNull("format")) {
            nMktPriceTipTextView.setText(mPriceJsonObject.optJSONObject("mktprice").optString("name"));
            nMktPriceTextView.setText(mPriceJsonObject.optJSONObject("mktprice").optString("format"));
            nMktPriceTextView.setVisibility(View.VISIBLE);
        } else {
            nMktPriceTipTextView.setText("");
            nMktPriceTextView.setText("");
            nMktPriceTextView.setVisibility(View.GONE);
        }


        JSONObject nFxPriceJsonObject = mPriceJsonObject.optJSONObject("fxprice");
        if (nFxPriceJsonObject != null && !nFxPriceJsonObject.isNull("format")) {
            nFxPriceTipTextView.setText(nFxPriceJsonObject.optString("name"));
            nFxPriceTextView.setText(nFxPriceJsonObject.optString("format"));
        } else {
            nFxPriceTipTextView.setText("");
            nFxPriceTextView.setText("");
        }
    }

    /**
     * 促销商品倒计时
     */
    void parseCountDownView() {

        if (mProductBasicJsonObject == null) {
            return;
        }

        JSONObject nSpecialInfo = mProductBasicJsonObject.optJSONObject("special_info");
        if (nSpecialInfo == null) {
            return;
        }

        final RushBuyCountDownTimerView nCountDownTimerView = (RushBuyCountDownTimerView) mPagerUpView.findViewById(R.id.goods_detail_time);
        final TextView nCountDownTipTextView = (TextView) mPagerUpView.findViewById(R.id.goods_detail_time_tip);
//		nCountDownTimerView.setCountdownStyle(RushBuyCountDownTimerView.STYLE_WHITE);
        mSystemTime = ServiceTimeInterface.getServiceTime();
        final long nBeginTimeSec = nSpecialInfo.optLong("begin_time");
        final long nEndTimeSec = nSpecialInfo.optLong("end_time");

        if (mSystemTime <= nBeginTimeSec) {
            nCountDownTipTextView.setText("距开始");
            nCountDownTimerView.setTime(nBeginTimeSec, mSystemTime);
        } else {
            nCountDownTipTextView.setText("距结束");
            nCountDownTimerView.setTime(nEndTimeSec, mSystemTime);
        }
        nCountDownTimerView.start();

        nCountDownTimerView.setOnCountDownTimerListener(new CountDownTimerListener() {

            @Override
            public void CountDownTimeEnd() {
                // TODO Auto-generated method stub
                if (mSystemTime <= nBeginTimeSec) {
                    mSystemTime = nBeginTimeSec;
                    nCountDownTipTextView.setText("距结束");
                    nCountDownTimerView.setTime(nEndTimeSec, mSystemTime);
                    nCountDownTimerView.start();
                }
            }
        });

    }

    /**
     * 促销(预售和贝壳兑换商品没有促销)
     */
    void parsePromotion() {
        if (mProductBasicJsonObject == null || "prepare".equals(mProductBasicJsonObject.optString("promotion_type")) || isGift) {
            return;
        }

        mPromotionJsonObject = mProductBasicJsonObject.optJSONObject("promotion");
        if (mPromotionJsonObject == null) {
            return;
        }

        if (mPromotionFlowLayout == null) {
            mPromotionHeaderView = mPagerUpView.findViewById(R.id.goods_detail_marketing_top_tr);
            mPromotionFlowLayout = (FlowLayout) mPagerUpView.findViewById(R.id.goods_detail_marketing_flowlayout);
            mPromotionAcationImageView = (ImageView) mPagerUpView.findViewById(R.id.goods_detail_marketing_action);
            mPromotionHeaderView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    v.setTag(!((Boolean) v.getTag()));
                    showPromotion((Boolean) v.getTag());
                }
            });
        }
        if (mPromotionListView == null) {
            mPromotionListView = (ListView) mPagerUpView.findViewById(R.id.goods_detail_marketing_list);
            mPromotionListView.setDividerHeight(0);
            mPromotionListView.setAdapter(mPromotionAdapter);
        }

        mPromotionTagList.clear();
        mPromotionList.clear();

        JSONArray nArray = mPromotionJsonObject.optJSONArray("goods");
        if (nArray != null && nArray.length() > 0) {// 商品促销
            for (int i = 0; i < nArray.length(); i++) {
                JSONObject nJsonObject = nArray.optJSONObject(i);
                View nView = View.inflate(mActivity, R.layout.item_goods_detail_promotion_tag, null);
                ((TextView) nView.findViewById(R.id.promotion_name)).setText(nJsonObject.optString("tag"));
                nView.setTag(nJsonObject);
                mPromotionTagList.add(nView);
                mPromotionList.add(nJsonObject);
            }
        }

        nArray = mPromotionJsonObject.optJSONArray("gift");
        if (nArray != null && nArray.length() > 0) {// 赠品
            View nView = View.inflate(mActivity, R.layout.item_goods_detail_promotion_tag, null);
            ((TextView) nView.findViewById(R.id.promotion_name)).setText("赠品");
            mPromotionTagList.add(nView);

            JSONObject nJsonObject = new JSONObject();
            nView.setTag(nJsonObject);
            try {
//                nJsonObject.put("tag", "赠品");
//                nJsonObject.put("tag_id", 0);

                StringBuilder nBuilder = new StringBuilder();
                for (int i = 0; i < nArray.length(); i++) {
                    JSONObject nItem = nArray.optJSONObject(i);
                    nItem.put(PROMOTION_TYPE_KEY, PROMOTION_TYPE_GIFT);
                    nItem.put(PROMOTION_GIFT_START, i == 0);
                    nItem.put(PROMOTION_GIFT_END, i == nArray.length() - 1);
                    mPromotionList.add(nItem);
//                    nBuilder.append(nItem.optString("name")).append("\n");
                }
//                if (nBuilder.length() > 0) {
//                    nBuilder.deleteCharAt(nBuilder.length() - 1);
//                }
//                nJsonObject.put("name", nBuilder.toString());
//                nBuilder.delete(0, nBuilder.length());
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
//            mPromotionList.add(nJsonObject);
        }

        // 屏蔽订单促销
        // nArray = mPromotionJsonObject.optJSONArray("order");
        // if (nArray != null && nArray.length() > 0) {// 订单促销
        // for (int i = 0; i < nArray.length(); i++) {
        // JSONObject nJsonObject = nArray.optJSONObject(i);
        // View nView = View.inflate(mActivity,
        // R.layout.item_goods_detail_promotion_tag, null);
        // ((TextView)
        // nView.findViewById(R.id.promotion_name)).setText(nJsonObject.optString("tag"));
        // nView.setTag(nJsonObject);
        // mPromotionTagList.add(nView);
        // mPromotionList.add(nJsonObject);
        // }
        // }

        mPagerUpView.findViewById(R.id.goods_detail_marketing_rl).setVisibility(mPromotionList.size() > 0 ? View.VISIBLE : View.GONE);

        mPromotionHeaderView.setTag(false);
        showPromotion(false);
    }

    void showPromotion(boolean unfold) {
        if (unfold) {
            while (mPromotionFlowLayout.getChildCount() > 2) {
                mPromotionFlowLayout.removeViewAt(2);
            }

            mPromotionFlowLayout.getChildAt(1).setVisibility(View.VISIBLE);
            mPromotionListView.setVisibility(View.VISIBLE);
            mPagerUpView.findViewById(R.id.goods_detail_marketing_header_space).setVisibility(View.VISIBLE);
            mPromotionAcationImageView.setImageResource(R.drawable.base_arrow_up_pink_n);
        } else {
            mPromotionFlowLayout.getChildAt(1).setVisibility(View.GONE);
            mPromotionListView.setVisibility(View.GONE);
            mPagerUpView.findViewById(R.id.goods_detail_marketing_header_space).setVisibility(View.GONE);

            if (mPromotionFlowLayout.getChildCount() > 2) {
                mPromotionFlowLayout.removeViews(2, mPromotionFlowLayout.getChildCount() - 2);
            }

            for (int i = mPromotionTagList.size() - 1; i >= 0; i--) {
                mPromotionFlowLayout.addView(mPromotionTagList.get(i), 2);
            }
            mPromotionAcationImageView.setImageResource(R.drawable.base_arrow_bottom_pink_n);
        }

        mPromotionAdapter.notifyDataSetChanged();
    }

    void parseBrand() {
        if (mProductBasicJsonObject == null || !mProductBasicJsonObject.has("brand")) {
            mPagerUpView.findViewById(R.id.goods_detail_brand_ll).setVisibility(View.GONE);
            return;
        }

        JSONObject nBrandJsonObject = mProductBasicJsonObject.optJSONObject("brand");

        // 品牌
        if (nBrandJsonObject == null || nBrandJsonObject.isNull("brand_id")) {
            mPagerUpView.findViewById(R.id.goods_detail_brand_ll).setVisibility(View.GONE);
        } else {
            mPagerUpView.findViewById(R.id.goods_detail_brand_ll).setVisibility(View.VISIBLE);
            ((TextView) mPagerUpView.findViewById(R.id.detail_brand_name)).setText(StringUtils.getString(nBrandJsonObject, "brand_name"));
            mPagerUpView.findViewById(R.id.rel_brand_view).setTag(nBrandJsonObject);

            displayCircleImage((ImageView) mPagerUpView.findViewById(R.id.img_brand_logo), nBrandJsonObject.optString
                    ("brand_logo"));
//            displayCircleImage((ImageView) mPagerUpView.findViewById(R.id.img_brand_logo), nBrandJsonObject.optString("brand_logo"));
        }
    }

    private class MyPagerViewAdapter extends GoodsDetailPagerAdapter {
        @Override
        public int getCount() {
            return 2;
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            View view = null;
            if (position == 0) {
                view = mPagerUpView;
            } else if (position == 1) {
                view = mGoodsBottomView;
            }
            container.addView(view);
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }
    }

    @Override
    public String getShareText() {
        // TODO Auto-generated method stub
        return mProductBasicJsonObject.optString("title");
    }

    @Override
    public String getShareImageFile() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String getShareImageUrl() {
        // TODO Auto-generated method stub
        return mProductBasicJsonObject == null ? null : mProductBasicJsonObject.optString("image_default_id");
    }

    @Override
    public String getShareUrl() {
        // TODO Auto-generated method stub
        return mProductBasicJsonObject.optString("share_url");
    }

    @Override
    public String getShareMessage() {
        // TODO Auto-generated method stub
        return mProductBasicJsonObject.optString("brief");
    }
}

