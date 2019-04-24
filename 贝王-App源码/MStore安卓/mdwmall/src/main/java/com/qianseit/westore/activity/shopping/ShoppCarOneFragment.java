package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.SparseArray;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.baoyz.swipemenulistview.SwipeMenuItem;
import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.base.BaseSwticListFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.httpinterface.member.MemberAddFavInterface;
import com.qianseit.westore.httpinterface.member.MemberDelFavInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarCheckoutInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarDeleteInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarSelectedInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarUpdateInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShoppCarOneFragment extends BaseSwticListFragment {
    final String CHECK_STATUS_FIELD = "selected";
    final String CHECK_EDIT_STATUS_FIELD = "editselected";
    final String ITEM_TYPE_FIELD = "itemtypefield";
    final String ITEM_TYPE_FIRST_FIELD = "itemtypefirstfield";
    final String ITEM_TYPE_END_FIELD = "itemtypeendfield";
    final String ITEM_PARENT_INDEX = "itemparentindex";
    /**
     * 只针对标题项有效，如享受更多优惠
     */
    final String ITEM_TITLE_FIELD = "itemtitlefield";

    /**
     * 商品
     */
    final int ITEM_GOODS = 0;
    final int ITEM_GOODS_COLLECTION = 13;
    /**
     * 商品赠品
     */
    final int ITEM_GOODS_GIFT = 1;
    /**
     * 商品配件
     */
    final int ITEM_GOODS_ADJUNCT = 2;
    final int ITEM_GOODS_ADJUNCT_COLLECTION = 12;
    /**
     * 商品促销
     */
    final int ITEM_GOODS_PROMOTION = 3;
    /**
     * 享受更多优惠
     */
    final int ITEM_DISCOUNT_MORE = 4;
    /**
     * 享受更多优惠
     */
    final int ITEM_DISCOUNT_MORE_PROMOTION = 5;
    /**
     * 积分兑换的赠品
     */
    final int ITEM_GIFT_SCORE = 6;
    final int ITEM_GIFT_SCORE_COLLECTION = 14;
    /**
     * 已享受优惠 订单赠品
     */
    final int ITEM_GIFT_ORDER = 7;
    /**
     * 已享受优惠 订单促销
     */
    final int ITEM_ORDER_PROMOTION = 8;
    /**
     * 粗分割线（模块分割）
     */
    final int ITEM_SPACE = 9;
    /**
     * 已享受优惠
     */
    final int ITEM_DISCOUNT = 10;
    /**
     * 标题栏
     */
    final int ITEM_GIFT_SCORE_GROUP = 11;

    private final int FRAGMENT_RESULT_VALUES = 0;

    private JSONArray mCoupon;

    CheckBox mCheckAllBox;
    TextView mTotalAmountTextView, mTotalSaveTextView;
    Button mActionButton;
    View mBottomView;

    SparseArray<List<JSONObject>> mResultGroupMap = new SparseArray<List<JSONObject>>();

    private Dialog mDeleteDialog;
    boolean mIgnoreCheckedChange = false;

    JSONObject mCarJsonObject;
    JSONObject mModGoodsJsonObject, mModAdjunctJsonObject;

    /**
     * 当前修改数量的项
     */
    JSONObject mCurEditJsonObject;
    /**
     * 修改后的数量值
     */
    String mCurEditQty = "0";
    boolean isSaveNewQty = true;

    int mModQty = 0;
    int mImageRound;

    boolean mIsEdit = false;

    ShoppCarUpdateInterface mCarUpdateInterface = new ShoppCarUpdateInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            try {
                // 当前编辑商品
                if (mModAdjunctJsonObject != null) {
                    mModAdjunctJsonObject.put("quantity", mModQty);
                } else {
                    mModGoodsJsonObject.put("quantity", mModQty);
                    mModGoodsJsonObject.put(CHECK_STATUS_FIELD, true);
                }
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            parseUpdateCarResponse(responseJson);
        }

        @Override
        public void FailRequest() {
            mAdapter.notifyDataSetChanged();
        }
    };

    ShoppCarDeleteInterface mCarDeleteInterface = new ShoppCarDeleteInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            // 当前编辑商品
            Run.goodsCounts -= getQty();

            JSONObject nNumJsonObject = responseJson.optJSONObject("number");
            if (nNumJsonObject.isNull("cart_count") || nNumJsonObject.optInt("cart_count") <= 0) {
                Run.goodsCounts = 0;
                mResultLists.clear();
                mResultGroupMap.clear();
                mAdapter.notifyDataSetChanged();
                mCarJsonObject = new JSONObject();
                updateTotal(mResultLists);
                return;
            }

            if (mIsEdit) {
                List<JSONObject> nDeleteJsonObjects = new ArrayList<JSONObject>();
                for (JSONObject itemJsonObject2 : mResultLists) {
                    if (isEditChecked(itemJsonObject2)) {
                        nDeleteJsonObjects.add(itemJsonObject2);
                    }
                }
                for (JSONObject jsonObject : nDeleteJsonObjects) {
                    int nType = getItemViewType(jsonObject);
                    if (nType == ITEM_GOODS || nType == ITEM_GOODS_COLLECTION) {
                        List<JSONObject> nJsonObjects = mResultGroupMap.get(jsonObject.hashCode());
                        for (int i = 0; i < nJsonObjects.size(); i++) {
                            mResultLists.remove(nJsonObjects.get(i));
                        }
                        nJsonObjects.clear();
                        mResultGroupMap.remove(jsonObject.hashCode());
                    } else {
                        mResultLists.remove(mModGoodsJsonObject);
                        List<JSONObject> nJsonObjects = mResultGroupMap.get(ITEM_GIFT_SCORE_GROUP);
                        nJsonObjects.remove(mModGoodsJsonObject);
                        if (nJsonObjects.size() <= 1) {
                            mResultGroupMap.remove(ITEM_GIFT_SCORE_GROUP);
                        }
                        mResultLists.removeAll(nJsonObjects);
                    }
                }
                parseUpdateCarResponse(responseJson);
                return;
            }
            if (mModAdjunctJsonObject != null) {
                mResultLists.remove(mModAdjunctJsonObject);
                mResultGroupMap.get(mModGoodsJsonObject.hashCode()).remove(mModAdjunctJsonObject);
            } else if (getItemViewType(mModGoodsJsonObject) == ITEM_GIFT_SCORE || getItemViewType(mModGoodsJsonObject) == ITEM_GIFT_SCORE_COLLECTION) {
                mResultLists.remove(mModGoodsJsonObject);
                List<JSONObject> nJsonObjects = mResultGroupMap.get(ITEM_GIFT_SCORE_GROUP);
                nJsonObjects.remove(mModGoodsJsonObject);
                if (nJsonObjects.size() <= 1) {
                    mResultGroupMap.remove(ITEM_GIFT_SCORE_GROUP);
                    mResultLists.removeAll(nJsonObjects);
                }
            } else {
                List<JSONObject> nJsonObjects = mResultGroupMap.get(mModGoodsJsonObject.hashCode());
                for (int i = 0; i < nJsonObjects.size(); i++) {
                    mResultLists.remove(nJsonObjects.get(i));
                }
                nJsonObjects.clear();
                mResultGroupMap.remove(mModGoodsJsonObject.hashCode());
            }

            parseUpdateCarResponse(responseJson);
        }

        @Override
        public void carEmpty() {
            mResultGroupMap.clear();
            mResultLists.clear();
            mCarJsonObject = new JSONObject();
            Run.goodsCounts = 0;
            updateTotal(mResultLists);
            mAdapter.notifyDataSetChanged();
        }
    };

    ShoppCarSelectedInterface mCarSelectedInterface = new ShoppCarSelectedInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Map<String, Integer> nMap = new HashMap<String, Integer>();

            for (Map.Entry<String, Object> entry :
                    mSelectedContentValues.valueSet()) {
                nMap.put(String.valueOf(entry.getValue()), 0);
            }

            try {
                for (JSONObject itemJsonObject : mResultLists) {
                    int nType = getItemViewType(itemJsonObject);
                    if (nType == ITEM_GOODS || nType == ITEM_GOODS_COLLECTION) {
                        itemJsonObject.put(CHECK_STATUS_FIELD, nMap.containsKey(itemJsonObject.optString("obj_ident")));
                    }
                }
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            parseUpdateCarResponse(responseJson);
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

    MemberAddFavInterface memberAddFavInterface = new MemberAddFavInterface(this, "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            try {
                convertItemType(mModGoodsJsonObject);
                mModGoodsJsonObject.put("is_fav", true);
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            Run.alert(mActivity, "收藏成功");
            mAdapter.notifyDataSetChanged();
        }
    };
    MemberDelFavInterface mDelFavInterface = new MemberDelFavInterface(this, "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            try {
                convertItemType(mModGoodsJsonObject);
                mModGoodsJsonObject.put("is_fav", false);
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            Run.alert(mActivity, "已取消收藏");
            mAdapter.notifyDataSetChanged();
        }
    };

    /**
     * ITEM_GOODS和ITEM_GOODS_COLLECTION互转;
     * ITEM_GOODS_ADJUNCT和ITEM_GOODS_ADJUNCT_COLLECTION互转;
     * ITEM_GIFT_SCORE和ITEM_GIFT_SCORE_COLLECTION互转;
     *
     * @param jsonObject
     * @return
     * @throws JSONException
     */
    void convertItemType(JSONObject jsonObject) throws JSONException {
        int nType = getItemViewType(jsonObject);
        if (nType == ITEM_GOODS) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_COLLECTION);
        } else if (nType == ITEM_GOODS_COLLECTION) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
        } else if (nType == ITEM_GOODS_ADJUNCT) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_ADJUNCT_COLLECTION);
        } else if (nType == ITEM_GOODS_ADJUNCT_COLLECTION) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_ADJUNCT);
        } else if (nType == ITEM_GIFT_SCORE) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE_COLLECTION);
        } else if (nType == ITEM_GIFT_SCORE_COLLECTION) {
            jsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE);
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mActionBar.setTitle("购物车");
        mActionBar.setRightTitleButton("编辑", new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                switchMode(!mIsEdit);
            }
        });
    }

    void switchMode(boolean isEdit) {
        mIsEdit = isEdit;
        if (mIsEdit) {
            findViewById(R.id.delete).setVisibility(View.VISIBLE);
            findViewById(R.id.action).setVisibility(View.INVISIBLE);
            findViewById(R.id.action).setEnabled(false);
            findViewById(R.id.statistics_ll).setVisibility(View.INVISIBLE);
            mActionBar.getRightButton().setText("完成");
            mAdapter.notifyDataSetChanged();
            updateCheckStatusEdit();
        } else {
            findViewById(R.id.delete).setVisibility(View.GONE);
            findViewById(R.id.action).setVisibility(View.VISIBLE);
            findViewById(R.id.statistics_ll).setVisibility(View.VISIBLE);
            findViewById(R.id.action).setEnabled(true);
            mActionBar.getRightButton().setText("编辑");
            mAdapter.notifyDataSetChanged();
            updateTotal(mResultLists);
        }
    }

    @Override
    protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        switch (getItemViewType(responseJson)) {
            case ITEM_GOODS:
            case ITEM_GOODS_COLLECTION:
                convertView = getCarItemView(responseJson, convertView, parent);
                break;
            case ITEM_GOODS_GIFT:
                convertView = getCarGiftItemView(responseJson, convertView, parent);
                break;
            case ITEM_GOODS_ADJUNCT_COLLECTION:
            case ITEM_GOODS_ADJUNCT:
                convertView = getCarAdjunctItemView(responseJson, convertView, parent);
                break;
            case ITEM_GOODS_PROMOTION:
                convertView = getCarItemPromotionView(responseJson, convertView, parent);
                break;
            case ITEM_DISCOUNT_MORE_PROMOTION:
                convertView = getCarItemDiscountMoreView(responseJson, convertView, parent);
                break;
            case ITEM_GIFT_SCORE_COLLECTION:
            case ITEM_GIFT_SCORE:
                convertView = getCarItemView(responseJson, convertView, parent);
                break;
            case ITEM_GIFT_ORDER:
                convertView = getCarGiftItemView(responseJson, convertView, parent);
                break;
            case ITEM_ORDER_PROMOTION:
                convertView = getCarItemDiscountMoreView(responseJson, convertView, parent);
                break;
            case ITEM_SPACE:
                convertView = getCarItemSpaceView(responseJson, convertView, parent);
                break;
            case ITEM_DISCOUNT_MORE:
            case ITEM_DISCOUNT:
            case ITEM_GIFT_SCORE_GROUP:
                convertView = getCarItemTitleView(responseJson, convertView, parent);
                break;

            default:
                break;
        }

        return convertView;
    }

    /**
     * 商品促销
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarItemPromotionView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_shopp_car_promotion, null);
        }
        convertView.findViewById(R.id.divider_top).setVisibility(responseJson.optBoolean(ITEM_TYPE_FIRST_FIELD, false) ? View.VISIBLE : View.GONE);
        convertView.findViewById(R.id.divider_bottom).setVisibility(responseJson.optBoolean(ITEM_TYPE_END_FIELD, false) ? View.VISIBLE : View.GONE);
        String nContent = String.format("<font color=#F3273F>[%s]</font>  %s", responseJson.optString("desc_tag"), responseJson.optString("name"));
        ((TextView) convertView.findViewById(R.id.content)).setText(Html.fromHtml(nContent));
        return convertView;
    }

    /**
     * 标题项 如享受更多优惠
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarItemTitleView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_shopp_car_title, null);
        }
        ((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString(ITEM_TITLE_FIELD));
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
    private View getCarItemSpaceView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_shopp_car_space, null);
        }
        return convertView;
    }

    /**
     * 享受更多优惠
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarItemDiscountMoreView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_shopp_car_discount_promotion, null);
            convertView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nJsonObject = (JSONObject) v.getTag();
                    if (!nJsonObject.optBoolean("fororder_status", false)) {
                        return;
                    }

                    // 进入凑单界面
                    startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_TOGETHER);
                }
            });
        }
        ((TextView) convertView.findViewById(R.id.promotion_name)).setText(responseJson.optString("desc_tag"));
        ((TextView) convertView.findViewById(R.id.promotion_content)).setText(responseJson.optString("name"));
        convertView.findViewById(R.id.promotion_action).setVisibility(responseJson.optBoolean("fororder_status", false) ? View.VISIBLE : View.INVISIBLE);
        convertView.setTag(responseJson);
        return convertView;
    }

    /**
     * 商品
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            int layout = R.layout.item_shopp_car;
            convertView = LayoutInflater.from(mActivity).inflate(layout, null);
            convertView.findViewById(R.id.selected).setOnClickListener(this);
            convertView.findViewById(R.id.minus).setOnClickListener(this);
            convertView.findViewById(R.id.plus).setOnClickListener(this);
            convertView.findViewById(R.id.thumb).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nProductJsonObject = (JSONObject) v.getTag();
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
                }
            });
        }

        JSONObject all = responseJson;
        if (all == null)
            return convertView;

        convertView.findViewById(R.id.thumb).setTag(all);
        convertView.findViewById(R.id.itemview).setTag(all);
        fillupItemView(convertView, all);
        // 选中与否
        convertView.findViewById(R.id.selected).setTag(all);
        convertView.findViewById(R.id.plus).setTag(all);
        convertView.findViewById(R.id.minus).setTag(all);
        View nSelectedView = convertView.findViewById(R.id.selected);
        nSelectedView.setSelected(all.optBoolean(mIsEdit ? CHECK_EDIT_STATUS_FIELD : CHECK_STATUS_FIELD));
        nSelectedView.setEnabled(mIsEdit ? true : all.optInt("store") > 0);
        return convertView;
    }

    /**
     * 配件
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarAdjunctItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            int layout = R.layout.item_shopp_car_adjunct;
            convertView = LayoutInflater.from(mActivity).inflate(layout, null);
            convertView.findViewById(R.id.minus).setOnClickListener(this);
            convertView.findViewById(R.id.plus).setOnClickListener(this);
            convertView.findViewById(R.id.thumb).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nProductJsonObject = (JSONObject) v.getTag();
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
                }
            });
        }

        final JSONObject all = responseJson;
        if (all == null)
            return convertView;

        convertView.findViewById(R.id.thumb).setTag(all);

        EditText mCarQuantity = ((EditText) convertView.findViewById(R.id.quantity));
        mCarQuantity.setText(all.optString("quantity"));

        mCarQuantity.setOnEditorActionListener(new OnEditorActionListener() {

            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    /* 隐藏软键盘 */
                    InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                    if (imm.isActive()) {
                        imm.hideSoftInputFromWindow(v.getApplicationWindowToken(), 0);
                    }
                    isSaveNewQty = true;
                    String values = v.getText().toString();
                    if (!TextUtils.isEmpty(values)) {
                        Integer integer = Integer.valueOf(values);
                        updateQty(all, integer);
                    } else {
                        Run.alert(mActivity, "输入不正确");
                        v.setText(all.optString("quantity"));
                    }
                    return true;
                }
                return false;
            }
        });

        mCarQuantity.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // TODO Auto-generated method stub

            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                // TODO Auto-generated method stub

            }

            @Override
            public void afterTextChanged(Editable s) {
                // TODO Auto-generated method stub
                mCurEditJsonObject = all;
                mCurEditQty = s.toString();
                isSaveNewQty = false;
            }
        });
        mCarQuantity.setOnFocusChangeListener(new OnFocusChangeListener() {

            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                // TODO Auto-generated method stub
                if (hasFocus) {
                    mCurEditJsonObject = all;
                    mCurEditQty = mCurEditJsonObject.optString("quantity");
                }
            }
        });

        ((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
        // 原价
        TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
        oldPriceTV.setText(StringUtils.getString(all, "mktprice"));
        oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
        oldPriceTV.setVisibility(oldPriceTV.getText().length() <= 0 || oldPriceTV.getText().toString().equals("0") ? View.GONE : View.VISIBLE);

        String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_adjunct, responseJson.optString("name"));
        ((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
        displayRoundImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail"), mImageRound);
        ((TextView) convertView.findViewById(R.id.type)).setText(all.optString("spec_info"));

        convertView.findViewById(R.id.plus).setTag(all);
        convertView.findViewById(R.id.minus).setTag(all);
        return convertView;
    }

    /**
     * 商品赠品
     *
     * @param responseJson
     * @param convertView
     * @param parent
     * @return
     */
    private View getCarGiftItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        if (convertView == null) {
            int layout = R.layout.item_shopp_car_gift;
            convertView = LayoutInflater.from(mActivity).inflate(layout, null);
            convertView.findViewById(R.id.thumb).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    JSONObject nProductJsonObject = (JSONObject) v.getTag();
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
                }
            });
        }

        JSONObject all = responseJson;
        if (all == null)
            return convertView;

        convertView.findViewById(R.id.thumb).setTag(all);

        ((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
        ((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
        // 原价
        TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
        oldPriceTV.setText(all.optString("mktprice"));
        oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

        String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_gift, responseJson.optString("name"));
        ((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
        displayRoundImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail"), mImageRound);
        ((TextView) convertView.findViewById(R.id.type)).setText(all.optString("spec_info"));

        return convertView;
    }

    @Override
    public int getViewTypeCount() {
        // TODO Auto-generated method stub
        return 15;
    }

    @Override
    public int getItemViewType(JSONObject json) {
        // TODO Auto-generated method stub
        return json.optInt(ITEM_TYPE_FIELD);
    }

    @Override
    protected void initBottom(LinearLayout bottomLayout) {
        // TODO Auto-generated method stub
        mBottomView = View.inflate(mActivity, R.layout.bottom_shopp_car, null);

        mTotalAmountTextView = (TextView) mBottomView.findViewById(R.id.total_amount);
        mTotalSaveTextView = (TextView) mBottomView.findViewById(R.id.total_save);
        mActionButton = (Button) mBottomView.findViewById(R.id.action);
        mActionButton.setOnClickListener(this);
        mCheckAllBox = (CheckBox) mBottomView.findViewById(R.id.check_all);
        mCheckAllBox.setOnClickListener(this);
        mBottomView.findViewById(R.id.delete).setOnClickListener(this);
        AutoLoad(false);
        bottomLayout.addView(mBottomView);

        initEmptyCarView();
    }

    void initEmptyCarView() {
        View nView = View.inflate(mActivity, R.layout.empty_shop_car, null);
        setCustomEmptyView(nView);
        nView.findViewById(R.id.shopping_go).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                if (mActivity instanceof CommonMainActivity) {
                    CommonMainActivity.mActivity.chooseRadio(0);
                } else {
                    startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
                    mActivity.finish();
                }
            }
        });
    }

    @Override
    public void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        onRefresh();
        switchMode(false);
    }

    @Override
    protected void endInit() {
        // TODO Auto-generated method stub
        PageEnable(false);
        mListView.setDividerHeight(0);
        mListView.setPullRefreshEnable(true);
        mImageRound = Run.dip2px(mActivity, 5);

        listenerSoftInput(mListView);
    }

    private void fillupItemView(View view, final JSONObject all) {
        try {
            EditText mCarQuantity = ((EditText) view.findViewById(R.id.quantity));
            mCarQuantity.setText(all.optString("quantity"));

            mCarQuantity.setOnEditorActionListener(new OnEditorActionListener() {

                @Override
                public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                    if (actionId == EditorInfo.IME_ACTION_DONE) {
						/* 隐藏软键盘 */
                        InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                        if (imm.isActive()) {
                            imm.hideSoftInputFromWindow(v.getApplicationWindowToken(), 0);
                        }
                        isSaveNewQty = true;

                        String values = v.getText().toString();
                        if (!TextUtils.isEmpty(values)) {
                            Integer integer = Integer.valueOf(values);
                            updateQty(all, integer);
                        } else {
                            Run.alert(mActivity, "输入不正确");
                            v.setText(all.optString("quantity"));
                        }
                        return true;
                    }
                    return false;
                }
            });
            mCarQuantity.addTextChangedListener(new TextWatcher() {

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void afterTextChanged(Editable s) {
                    // TODO Auto-generated method stub
                    mCurEditJsonObject = all;
                    mCurEditQty = s.toString();
                    isSaveNewQty = false;
                }
            });
            mCarQuantity.setOnFocusChangeListener(new OnFocusChangeListener() {

                @Override
                public void onFocusChange(View v, boolean hasFocus) {
                    // TODO Auto-generated method stub
                    if (hasFocus && (mCurEditJsonObject == null || mCurEditJsonObject.hashCode() != all.hashCode())) {
                        mCurEditJsonObject = all;
                        mCurEditQty = mCurEditJsonObject.optString("quantity");
                    }
                }
            });

            ((TextView) view.findViewById(R.id.price)).setText(all.optString("price"));
            // 原价
            TextView oldPriceTV = (TextView) view.findViewById(R.id.market_price);
            oldPriceTV.setText(StringUtils.getString(all, "mktprice"));
            oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
            oldPriceTV.setVisibility(oldPriceTV.getText().length() <= 0 || oldPriceTV.getText().toString().equals("0") ? View.GONE : View.VISIBLE);

            String nName = String.format("<font color=\"#FFFFFF\" style=\"BACKGROUND-COLOR:#F3273F\"> 配件 </font>%s", all.optString("name"));
            ((TextView) view.findViewById(R.id.title)).setText(all.optString("name"));
            // ((TextView)
            // view.findViewById(R.id.title)).setText(all.optString("name"));
            displayRoundImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail"), mImageRound);
            ((TextView) view.findViewById(R.id.type)).setText(all.optString("spec_info"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void carEmpty() {
        // TODO Auto-generated method stub
        updateTotal(mResultLists);
    }

    @Override
    protected List<JSONObject> fetchDatas(JSONObject responseJson) {
        // TODO Auto-generated method stub
        mResultGroupMap.clear();
        List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
        mCarJsonObject = responseJson.optJSONObject("aCart");
        if (mCarJsonObject == null) {
            return nJsonObjects;
        }

        JSONObject nJsonObject = mCarJsonObject.optJSONObject("object");
        if (nJsonObject == null) {
            return nJsonObjects;
        }

        try {
            // 商品
            JSONArray nGoodsArray = nJsonObject.optJSONArray("goods");
            if (nGoodsArray != null && nGoodsArray.length() > 0) {
                for (int i = 0; i < nGoodsArray.length(); i++) {
                    JSONObject nGoodsJsonObject = nGoodsArray.optJSONObject(i);
                    nGoodsJsonObject.put(ITEM_TYPE_FIELD, nGoodsJsonObject.optBoolean("is_fav") ? ITEM_GOODS_COLLECTION : ITEM_GOODS);
                    nGoodsJsonObject.put(CHECK_EDIT_STATUS_FIELD, false);
                    List<JSONObject> nGroupItemList = new ArrayList<JSONObject>();
                    mResultGroupMap.put(nGoodsJsonObject.hashCode(), nGroupItemList);

                    if (nJsonObjects.size() > 0) {
                        JSONObject nSpaceJsonObject = new JSONObject();
                        nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
                        nJsonObjects.add(nSpaceJsonObject);
                        nGroupItemList.add(nSpaceJsonObject);
                    }
                    nJsonObjects.add(nGoodsJsonObject);
                    nGroupItemList.add(nGoodsJsonObject);

                    int nParentIndex = nGoodsJsonObject.hashCode();

                    // 商品赠品
                    JSONArray nGoodsGiftArray = nGoodsJsonObject.optJSONArray("gift");
                    if (nGoodsGiftArray != null && nGoodsGiftArray.length() > 0) {
                        for (int j = 0; j < nGoodsGiftArray.length(); j++) {
                            JSONObject nGoodsGiftJsonObject = nGoodsGiftArray.optJSONObject(j);
                            nGoodsGiftJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_GIFT);
                            nGoodsGiftJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
                            nJsonObjects.add(nGoodsGiftJsonObject);
                            nGroupItemList.add(nGoodsGiftJsonObject);
                        }
                    }

                    // 商品配件
                    JSONArray nGoodsAdjunctArray = nGoodsJsonObject.optJSONArray("adjunct");
                    if (nGoodsAdjunctArray != null && nGoodsAdjunctArray.length() > 0) {
                        for (int j = 0; j < nGoodsAdjunctArray.length(); j++) {
                            JSONObject nGoodsAdjunctJsonObject = nGoodsAdjunctArray.optJSONObject(j);
                            nGoodsAdjunctJsonObject.put(ITEM_TYPE_FIELD, nGoodsAdjunctJsonObject.optBoolean("is_fav") ? ITEM_GOODS_ADJUNCT_COLLECTION : ITEM_GOODS_ADJUNCT);
                            nGoodsAdjunctJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
                            nJsonObjects.add(nGoodsAdjunctJsonObject);
                            nGroupItemList.add(nGoodsAdjunctJsonObject);
                        }
                    }

                    // 商品促销
                    JSONArray nGoodsPromotionArray = nGoodsJsonObject.optJSONArray("promotion");
                    if (nGoodsPromotionArray != null && nGoodsPromotionArray.length() > 0) {
                        for (int j = 0; j < nGoodsPromotionArray.length(); j++) {
                            JSONObject nGoodsPromotionJsonObject = nGoodsPromotionArray.optJSONObject(j);
                            nGoodsPromotionJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_PROMOTION);
                            nGoodsPromotionJsonObject.put(ITEM_TYPE_FIRST_FIELD, j == 0);
                            nGoodsPromotionJsonObject.put(ITEM_TYPE_END_FIELD, j == nGoodsPromotionArray.length() - 1);
                            nGoodsPromotionJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
                            nJsonObjects.add(nGoodsPromotionJsonObject);
                            nGroupItemList.add(nGoodsPromotionJsonObject);
                        }
                    }
                }
            }

            // 赠品
            JSONObject nGiftJsonObject = nJsonObject.optJSONObject("gift");
            if (nGiftJsonObject != null) {
                // 积分兑换的赠品
                JSONArray nGiftScoreArray = nGiftJsonObject.optJSONArray("cart");
                if (nGiftScoreArray != null && nGiftScoreArray.length() > 0) {
                    List<JSONObject> nGroupItemList = null;
                    if (mResultGroupMap.get(ITEM_GIFT_SCORE_GROUP) == null) {
                        nGroupItemList = new ArrayList<JSONObject>();
                        mResultGroupMap.put(ITEM_GIFT_SCORE_GROUP, nGroupItemList);
                        JSONObject nGiftTitleJsonObject = new JSONObject();
                        nGiftTitleJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE_GROUP);
                        nGiftTitleJsonObject.put(ITEM_TITLE_FIELD, "积分兑换赠品");
                        nJsonObjects.add(nGiftTitleJsonObject);
                        nGroupItemList.add(nGiftTitleJsonObject);
                    } else {
                        nGroupItemList = mResultGroupMap.get(ITEM_GIFT_SCORE_GROUP);
                    }

                    for (int i = 0; i < nGiftScoreArray.length(); i++) {
                        JSONObject nGiftScoreJsonObject = nGiftScoreArray.optJSONObject(i);
                        nGiftScoreJsonObject.put(ITEM_TYPE_FIELD, nGiftScoreJsonObject.optBoolean("is_fav") ? ITEM_GOODS_ADJUNCT_COLLECTION : ITEM_GIFT_SCORE);
                        nGiftScoreJsonObject.put(CHECK_EDIT_STATUS_FIELD, false);
                        nGroupItemList.add(nGiftScoreJsonObject);
                        nJsonObjects.add(nGiftScoreJsonObject);
                    }
                }

                // 订单赠品
                JSONArray nGiftOrderArray = nGiftJsonObject.optJSONArray("order");
                if (nGiftOrderArray != null && nGiftOrderArray.length() > 0) {
                    List<JSONObject> nGroupItemList = null;
                    if (mResultGroupMap.get(ITEM_DISCOUNT) == null) {
                        nGroupItemList = new ArrayList<JSONObject>();
                        mResultGroupMap.put(ITEM_DISCOUNT, nGroupItemList);
                        JSONObject nDiscountJsonObject = new JSONObject();
                        nDiscountJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT);
                        nDiscountJsonObject.put(ITEM_TITLE_FIELD, "已享受优惠");
                        nJsonObjects.add(nDiscountJsonObject);
                        nGroupItemList.add(nDiscountJsonObject);
                    } else {
                        nGroupItemList = mResultGroupMap.get(ITEM_DISCOUNT);
                    }

                    for (int i = 0; i < nGiftOrderArray.length(); i++) {
                        JSONObject nGiftOrderJsonObject = nGiftOrderArray.optJSONObject(i);
                        nGiftOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_ORDER);
                        nJsonObjects.add(nGiftOrderJsonObject);
                        nGroupItemList.add(nGiftOrderJsonObject);
                    }
                }
            }

            // 已享受的订单优惠 促销
            JSONObject nOrderPromotionJsonObject = mCarJsonObject.optJSONObject("promotion");
            if (nOrderPromotionJsonObject != null) {
                JSONArray nOrderPromotionArray = nOrderPromotionJsonObject.optJSONArray("order");
                if (nOrderPromotionArray != null && nOrderPromotionArray.length() > 0) {
                    List<JSONObject> nGroupItemList = null;
                    if (mResultGroupMap.get(ITEM_DISCOUNT) == null) {
                        nGroupItemList = new ArrayList<JSONObject>();
                        mResultGroupMap.put(ITEM_DISCOUNT, nGroupItemList);
                        JSONObject nDiscountJsonObject = new JSONObject();
                        nDiscountJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT);
                        nDiscountJsonObject.put(ITEM_TITLE_FIELD, "已享受优惠");
                        nJsonObjects.add(nDiscountJsonObject);
                        nGroupItemList.add(nDiscountJsonObject);
                    } else {
                        nGroupItemList = mResultGroupMap.get(ITEM_DISCOUNT);
                    }

                    for (int i = 0; i < nOrderPromotionArray.length(); i++) {
                        JSONObject nOrderPromotion2JsonObject = nOrderPromotionArray.optJSONObject(i);
                        nOrderPromotion2JsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_PROMOTION);
                        nJsonObjects.add(nOrderPromotion2JsonObject);
                        nGroupItemList.add(nOrderPromotion2JsonObject);
                    }
                }
            }

            // 享受更多优惠
            if (responseJson.optBoolean("cart_promotion_display", false)) {
                JSONArray nDiscountMoreArray = responseJson.optJSONArray("unuse_rule");
                if (nDiscountMoreArray != null && nDiscountMoreArray.length() > 0) {

                    List<JSONObject> nGroupItemList = null;
                    if (mResultGroupMap.get(ITEM_DISCOUNT_MORE) == null) {
                        nGroupItemList = new ArrayList<JSONObject>();
                        mResultGroupMap.put(ITEM_DISCOUNT_MORE, nGroupItemList);
                        JSONObject nDiscountJsonObject = new JSONObject();
                        nDiscountJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT_MORE);
                        nDiscountJsonObject.put(ITEM_TITLE_FIELD, "享受更多优惠");
                        nJsonObjects.add(nDiscountJsonObject);
                        nGroupItemList.add(nDiscountJsonObject);
                    } else {
                        nGroupItemList = mResultGroupMap.get(ITEM_DISCOUNT_MORE);
                    }

                    for (int i = 0; i < nDiscountMoreArray.length(); i++) {
                        JSONObject nDiscountMoreJsonObject = nDiscountMoreArray.optJSONObject(i);
                        nDiscountMoreJsonObject.put(ITEM_TYPE_FIRST_FIELD, i == 0);
                        nDiscountMoreJsonObject.put(ITEM_TYPE_END_FIELD, i == nDiscountMoreArray.length() - 1);
                        nDiscountMoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT_MORE_PROMOTION);
                        nJsonObjects.add(nDiscountMoreJsonObject);
                        nGroupItemList.add(nDiscountMoreJsonObject);
                    }
                }
            }

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        updateTotal(nJsonObjects);
        return nJsonObjects;
    }

    @Override
    protected String requestInterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.cart.index";
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        JSONObject nGoodsJsonObject = null;
        int quantity = 0;
        switch (v.getId()) {
            case R.id.delete:
                askBatchRemoveGoods();
                break;
            case R.id.action:
                mCarCheckoutInterface.reset();
                for (JSONObject itemJsonObject2 : mResultLists) {
                    if (isChecked(itemJsonObject2)) {
                        mCarCheckoutInterface.addGoodsIdent(itemJsonObject2.optString("obj_ident"));
                    }
                }
                if (!mCarCheckoutInterface.canCheckout()) {
                    Run.alert(mActivity, "请选择要算的商品");
                    return;
                }
                mCarCheckoutInterface.RunRequest();
                break;
            case R.id.selected:
                nGoodsJsonObject = (JSONObject) v.getTag();
                if (mIsEdit) {
                    try {
                        nGoodsJsonObject.put(CHECK_EDIT_STATUS_FIELD, !nGoodsJsonObject.optBoolean(CHECK_EDIT_STATUS_FIELD, false));
                        mAdapter.notifyDataSetChanged();
                        updateCheckStatusEdit();
                    } catch (JSONException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                } else {
                    selected(nGoodsJsonObject, !nGoodsJsonObject.optBoolean(CHECK_STATUS_FIELD));
                }
                break;
            case R.id.minus:
                nGoodsJsonObject = (JSONObject) v.getTag();
                quantity = nGoodsJsonObject.optInt("quantity") - 1;
                if (quantity <= 0) {
                    // askRemoveGoods(data);
                    return;
                }
                updateQty(nGoodsJsonObject, quantity);
                break;
            case R.id.plus:
                nGoodsJsonObject = (JSONObject) v.getTag();
                quantity = nGoodsJsonObject.optInt("quantity") + 1;
                if (quantity > nGoodsJsonObject.optInt("store", 0)) {
                    Run.alert(mActivity, "商品库存不足，无法修改！");
                    return;
                }
                updateQty(nGoodsJsonObject, quantity);
                break;
            case R.id.check_all:
                selectedAll(mCheckAllBox.isChecked());
                break;

            default:
                break;
        }
        super.onClick(v);
    }

    void selected(JSONObject itemJsonObject, boolean selected) {
        mCarSelectedInterface.reset();
        for (JSONObject itemJsonObject2 : mResultLists) {
            if (itemJsonObject2.hashCode() == itemJsonObject.hashCode() && selected) {
                mCarSelectedInterface.addSelected(itemJsonObject2.optString("obj_ident"));
            } else if (itemJsonObject2.hashCode() != itemJsonObject.hashCode() && isChecked(itemJsonObject2)) {
                mCarSelectedInterface.addSelected(itemJsonObject2.optString("obj_ident"));
            }
        }

        mCarSelectedInterface.RunRequest();
    }

    void selectedAll(boolean selected) {
        if (mResultLists.size() <= 0) {
            return;
        }
        if (mIsEdit) {
            try {
                for (JSONObject itemJsonObject2 : mResultLists) {
                    int nType = itemJsonObject2.optInt(ITEM_TYPE_FIELD);
                    if (nType == ITEM_GOODS || nType == ITEM_GIFT_SCORE || nType == ITEM_GOODS_COLLECTION || nType == ITEM_GIFT_SCORE_COLLECTION) {
                        itemJsonObject2.put(CHECK_EDIT_STATUS_FIELD, selected);
                    }
                }
                mAdapter.notifyDataSetChanged();
                updateCheckStatusEdit();
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        } else {
            mCarSelectedInterface.reset();
            if (selected) {
                for (JSONObject itemJsonObject2 : mResultLists) {
                    mCarSelectedInterface.addSelected(itemJsonObject2.optString("obj_ident"));
                }
            }
            mCarSelectedInterface.RunRequest();
        }
    }

    void updateCheckStatusEdit() {
        boolean nIsSelectAll = true;
        for (JSONObject itemJsonObject2 : mResultLists) {
            if (!isEditChecked(itemJsonObject2)) {
                nIsSelectAll = false;
                break;
            }
        }
        mCheckAllBox.setChecked(nIsSelectAll);
    }

    void updateQty(JSONObject itemJsonObject, int qty) {
        if (itemJsonObject == null || itemJsonObject.optInt("quantity") == qty) {
            return;
        }

        int nType = getItemViewType(itemJsonObject);

        mModQty = qty;
        mModAdjunctJsonObject = null;
        if (nType == ITEM_GOODS || nType == ITEM_GIFT_SCORE || nType == ITEM_GOODS_COLLECTION || nType == ITEM_GIFT_SCORE_COLLECTION) {
            mModGoodsJsonObject = itemJsonObject;
            mCarUpdateInterface.setData(itemJsonObject.optString("obj_ident"), itemJsonObject.optString("goods_id"), qty);
        } else if (nType == ITEM_GOODS_ADJUNCT || nType == ITEM_GOODS_ADJUNCT_COLLECTION) {
            mModGoodsJsonObject = getParentGoods(itemJsonObject.optInt(ITEM_PARENT_INDEX));
            if (mModGoodsJsonObject == null) {
                return;
            }
            mCarUpdateInterface.setData(mModGoodsJsonObject.optString("obj_ident"), mModGoodsJsonObject.optString("goods_id"), mModGoodsJsonObject.optInt("quantity"));
            mCarUpdateInterface.addAdjunct(itemJsonObject.optInt("group_id"), itemJsonObject.optInt("product_id"), qty);
            mModAdjunctJsonObject = itemJsonObject;
        } else {
            return;
        }

        for (JSONObject itemJsonObject2 : mResultLists) {
            if (isChecked(itemJsonObject2)) {
                mCarUpdateInterface.addSelected(itemJsonObject2.optString("obj_ident"));
            }
        }

        mCarUpdateInterface.RunRequest();
    }

    boolean isChecked(JSONObject jsonObject) {
        if (jsonObject == null) {
            return false;
        }

        int nType = getItemViewType(jsonObject);
        if (nType == ITEM_GOODS || nType == ITEM_GIFT_SCORE || nType == ITEM_GOODS_COLLECTION || nType == ITEM_GIFT_SCORE_COLLECTION) {
            return jsonObject.optBoolean(CHECK_STATUS_FIELD);
        }
        return false;
    }

    boolean isEditChecked(JSONObject jsonObject) {
        if (jsonObject == null) {
            return false;
        }

        int nType = getItemViewType(jsonObject);
        if (nType == ITEM_GOODS || nType == ITEM_GIFT_SCORE || nType == ITEM_GOODS_COLLECTION || nType == ITEM_GIFT_SCORE_COLLECTION) {
            return jsonObject.optBoolean(CHECK_EDIT_STATUS_FIELD);
        }
        return false;
    }

    JSONObject getParentGoods(int key) {
        JSONObject nJsonObject = null;
        List<JSONObject> nJsonObjects = mResultGroupMap.get(key);
        if (nJsonObjects == null || nJsonObjects.size() <= 0) {
            return nJsonObject;
        }

        for (JSONObject jsonObject : nJsonObjects) {
            int nType = getItemViewType(jsonObject);
            if (nType == ITEM_GOODS || nType == ITEM_GOODS_COLLECTION) {
                nJsonObject = jsonObject;
                break;
            }
        }

        return nJsonObject;
    }

    /**
     * 购物车变化后的处理（删除更新勾选）
     *
     * @param responseJson
     */
    void parseUpdateCarResponse(JSONObject responseJson) {
        JSONObject nSubTotalJsonObject = responseJson.optJSONObject("sub_total");
        try {
            // 总价信息
            mCarJsonObject.put("subtotal_prefilter_after", nSubTotalJsonObject.opt("subtotal_prefilter_after"));
            mCarJsonObject.put("promotion_subtotal", nSubTotalJsonObject.opt("promotion_subtotal"));
            mCarJsonObject.put("subtotal_gain_score", nSubTotalJsonObject.opt("subtotal_gain_score"));
            mCarJsonObject.put("discount_amount_order", nSubTotalJsonObject.opt("discount_amount_order"));

            // 已享受优惠
            List<JSONObject> mDiscountJsonObjects = mResultGroupMap.get(ITEM_DISCOUNT);
            if (mDiscountJsonObjects != null && mDiscountJsonObjects.size() > 0) {
                for (int i = mDiscountJsonObjects.size() - 1; i > 0; i--) {
                    mResultLists.remove(mDiscountJsonObjects.get(i));
                    mDiscountJsonObjects.remove(i);
                }
            } else {
                mDiscountJsonObjects = new ArrayList<JSONObject>();
                mResultGroupMap.put(ITEM_DISCOUNT, mDiscountJsonObjects);
                JSONObject nDiscountJsonObject = new JSONObject();
                nDiscountJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT);
                nDiscountJsonObject.put(ITEM_TITLE_FIELD, "已享受优惠");
                mDiscountJsonObjects.add(nDiscountJsonObject);
            }

            // 订单赠品
            JSONArray nGiftOrderArray = responseJson.optJSONArray("order_gift");
            if (nGiftOrderArray != null && nGiftOrderArray.length() > 0) {
                for (int i = 0; i < nGiftOrderArray.length(); i++) {
                    JSONObject nGiftOrderJsonObject = nGiftOrderArray.optJSONObject(i);
                    nGiftOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_ORDER);
                    mDiscountJsonObjects.add(nGiftOrderJsonObject);
                }
            }

            // 已享受的订单优惠 促销
            JSONObject nOrderPromotionJsonObject = responseJson.optJSONObject("promotion");
            if (nOrderPromotionJsonObject != null) {
                JSONArray nOrderPromotionArray = nOrderPromotionJsonObject.optJSONArray("order");
                if (nOrderPromotionArray != null && nOrderPromotionArray.length() > 0) {
                    for (int i = 0; i < nOrderPromotionArray.length(); i++) {
                        JSONObject nOrderPromotion2JsonObject = nOrderPromotionArray.optJSONObject(i);
                        nOrderPromotion2JsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_PROMOTION);
                        mDiscountJsonObjects.add(nOrderPromotion2JsonObject);
                    }
                }
            }

            if (mDiscountJsonObjects.size() == 1 && mResultLists.contains(mDiscountJsonObjects.get(0))) {
                mResultLists.remove(mDiscountJsonObjects.get(0));
            } else if (mDiscountJsonObjects.size() > 1) {
                if (mResultLists.contains(mDiscountJsonObjects.get(0))) {
                    mResultLists.addAll(mResultLists.indexOf(mDiscountJsonObjects.get(0)) + 1, mDiscountJsonObjects.subList(1, mDiscountJsonObjects.size()));
                } else if (mResultGroupMap.get(ITEM_DISCOUNT_MORE) != null && mResultLists.contains(mResultGroupMap.get(ITEM_DISCOUNT_MORE).get(0))) {
                    mResultLists.addAll(mResultLists.indexOf(mResultGroupMap.get(ITEM_DISCOUNT_MORE).get(0)), mDiscountJsonObjects);
                } else {
                    mResultLists.addAll(mDiscountJsonObjects);
                }
            }

            // 享受更多优惠
            List<JSONObject> mDiscountMoreJsonObjects = mResultGroupMap.get(ITEM_DISCOUNT_MORE);
            if (mDiscountMoreJsonObjects != null && mDiscountMoreJsonObjects.size() > 0) {
                for (int i = mDiscountMoreJsonObjects.size() - 1; i > 0; i--) {
                    mResultLists.remove(mDiscountMoreJsonObjects.get(i));
                    mDiscountMoreJsonObjects.remove(i);
                }
            } else {
                mDiscountMoreJsonObjects = new ArrayList<JSONObject>();
                mResultGroupMap.put(ITEM_DISCOUNT_MORE, mDiscountMoreJsonObjects);
                JSONObject nDiscountMoreJsonObject = new JSONObject();
                nDiscountMoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT_MORE);
                nDiscountMoreJsonObject.put(ITEM_TITLE_FIELD, "享受更多优惠");
                mDiscountMoreJsonObjects.add(nDiscountMoreJsonObject);
            }

            // 享受更多优惠 促销
            JSONArray nOrderPromotionMoreArray = responseJson.optJSONArray("unuse_rule");
            if (nOrderPromotionMoreArray != null && nOrderPromotionMoreArray.length() > 0) {
                for (int i = 0; i < nOrderPromotionMoreArray.length(); i++) {
                    JSONObject nOrderPromotionMoreJsonObject = nOrderPromotionMoreArray.optJSONObject(i);
                    nOrderPromotionMoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_DISCOUNT_MORE_PROMOTION);
                    mDiscountMoreJsonObjects.add(nOrderPromotionMoreJsonObject);
                }
            }

            if (mDiscountMoreJsonObjects.size() == 1 && mResultLists.contains(mDiscountMoreJsonObjects.get(0))) {
                mResultLists.remove(mDiscountMoreJsonObjects.get(0));
            } else if (mDiscountMoreJsonObjects.size() > 1) {
                if (mResultLists.contains(mDiscountMoreJsonObjects.get(0))) {
                    mResultLists.addAll(mResultLists.indexOf(mDiscountMoreJsonObjects.get(0)) + 1, mDiscountMoreJsonObjects.subList(1, mDiscountMoreJsonObjects.size()));
                } else {
                    mResultLists.addAll(mDiscountMoreJsonObjects);
                }
            }

            updateTotal(mResultLists);
            mAdapter.notifyDataSetChanged();

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    // 询问删除商品
    private void askRemoveGoods(final JSONObject data) {
        mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除此商品？", "取消", "确定", null, new OnClickListener() {

            @Override
            public void onClick(View v) {
                mDeleteDialog.dismiss();
                mDeleteDialog = null;
                mModAdjunctJsonObject = null;
                mCarDeleteInterface.reset();
                int nType = getItemViewType(data);
                if (nType == ITEM_GOODS || nType == ITEM_GOODS_COLLECTION) {
                    mModGoodsJsonObject = data;
                    mCarDeleteInterface.setData(data.optString("obj_ident"), data.optString("goods_id"), data.optInt("quantity"));
                } else if (nType == ITEM_GOODS_ADJUNCT || nType == ITEM_GOODS_ADJUNCT_COLLECTION) {
                    mModGoodsJsonObject = getParentGoods(data.optInt(ITEM_PARENT_INDEX));
                    if (mModGoodsJsonObject == null) {
                        return;
                    }
                    mCarDeleteInterface.setData(mModGoodsJsonObject.optString("obj_ident"), mModGoodsJsonObject.optString("goods_id"), 0);
                    mCarDeleteInterface.addAdjunct(data.optInt("group_id"), data.optInt("product_id"), data.optInt("quantity"));
                    mModAdjunctJsonObject = data;
                } else {
                    mModGoodsJsonObject = data;
                    mCarDeleteInterface.addGiftScore(data.optString("obj_ident"), data.optInt("quantity"));
                }

                for (JSONObject itemJsonObject2 : mResultLists) {
                    if (isChecked(itemJsonObject2)) {
                        mCarDeleteInterface.addSelected(itemJsonObject2.optString("obj_ident"));
                    }
                }

                mCarDeleteInterface.RunRequest();
            }
        }, false, null);
    }

    // 询问批量删除商品
    private void askBatchRemoveGoods() {
        final List<JSONObject> nDeleteJsonObjects = new ArrayList<JSONObject>();
        for (JSONObject itemJsonObject2 : mResultLists) {
            if (isEditChecked(itemJsonObject2)) {
                nDeleteJsonObjects.add(itemJsonObject2);
            }
        }
        if (nDeleteJsonObjects.size() <= 0) {
            Run.alert(mActivity, "请选择要删除商品");
            return;
        }

        mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除选中商品？", "取消", "确定", null, new OnClickListener() {

            @Override
            public void onClick(View v) {
                mDeleteDialog.dismiss();
                mDeleteDialog = null;

                mCarDeleteInterface.reset();
                if (mCheckAllBox.isChecked()) {
                    mCarDeleteInterface.clear();
                    return;
                }

                for (JSONObject jsonObject : nDeleteJsonObjects) {
                    int nType = getItemViewType(jsonObject);
                    if (nType == ITEM_GOODS || nType == ITEM_GOODS_COLLECTION) {
                        mCarDeleteInterface.addProduct(jsonObject.optString("obj_ident"), jsonObject.optString("goods_id"), jsonObject.optInt("quantity"));
                    } else {
                        mCarDeleteInterface.addGiftScore(jsonObject.optString("obj_ident"), jsonObject.optInt("quantity"));
                    }
                }

                for (JSONObject itemJsonObject2 : mResultLists) {
                    if (isChecked(itemJsonObject2)) {
                        mCarDeleteInterface.addSelected(itemJsonObject2.optString("obj_ident"));
                    }
                }

                mCarDeleteInterface.RunRequest();
            }
        }, false, null);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != Activity.RESULT_OK)
            return;
        if (requestCode == FRAGMENT_RESULT_VALUES) {
            if (Run.goodsCounts <= 0) {
                mActivity.finish();
            }
        }
    }

    private class RemoveCoupon implements JsonTaskHandler {

        private String obj_ident;
        private int index;

        public RemoveCoupon(int index, String obj_ident) {
            this.obj_ident = obj_ident;
            this.index = index;
        }

        @Override
        public void task_response(String json_str) {
            removeCoupon(index + 1);
        }

        @Override
        public JsonRequestBean task_request() {
            JsonRequestBean req = new JsonRequestBean(Run.API_URL,

                    "mobileapi.cart.remove");
            req.addParams("obj_type", "coupon");
            req.addParams("obj_ident", obj_ident);
            return req;
        }

    }

    private void removeCoupon(int index) {
        if (index < mCoupon.length()) {
            new JsonTask().execute(new RemoveCoupon(index, mCoupon.optJSONObject(index).optString("obj_ident")));
        }
    }

    /**
     * 结算价，节省价，商品件数（加配件和赠品）
     *
     * @param nJsonObjects
     */
    void updateTotal(List<JSONObject> nJsonObjects) {
        int totalCount = 0;
        int selectedCount = 0;
        boolean nSelectedAll = true;
        for (JSONObject item : nJsonObjects) {
            int nItemType = getItemViewType(item);
            if (nItemType == ITEM_GOODS || nItemType == ITEM_GIFT_SCORE || nItemType == ITEM_GOODS_COLLECTION || nItemType == ITEM_GIFT_SCORE_COLLECTION) {
                totalCount = totalCount + item.optInt("quantity");
                if (!item.optBoolean(mIsEdit ? CHECK_EDIT_STATUS_FIELD : CHECK_STATUS_FIELD)) {
                    nSelectedAll = false;
                    continue;
                }
                selectedCount = selectedCount + item.optInt("quantity");
            } else if (nItemType == ITEM_GOODS_ADJUNCT || nItemType == ITEM_GOODS_ADJUNCT_COLLECTION) {
                totalCount = totalCount + item.optInt("quantity");
                if (getParentGoods(item.optInt(ITEM_PARENT_INDEX)).optBoolean(CHECK_STATUS_FIELD)) {
                    selectedCount = selectedCount + item.optInt("quantity");
                }
            }
        }

        if (mCarJsonObject != null) {
            mTotalAmountTextView.setText("合计：" + mCarJsonObject.optString("promotion_subtotal"));
            mTotalSaveTextView.setText("节省：" + mCarJsonObject.optString("discount_amount_order"));
        } else {
            mTotalAmountTextView.setText("合计：0.00");
            mTotalSaveTextView.setText("节省：0.00");
        }

        mActionButton.setText(String.format("去结算(%d)", selectedCount));

        mCheckAllBox.setChecked(nSelectedAll);

        Run.goodsCounts = totalCount;
        if (CommonMainActivity.mActivity != null) {
            CommonMainActivity.mActivity.setShoppingCarCount();
        }

        if (Run.goodsCounts <= 0) {
            mBottomView.setVisibility(View.GONE);
            mActionBar.setShowRightButton(false);
        } else {
            mActionBar.setShowRightButton(true);
            mBottomView.setVisibility(View.VISIBLE);
        }
    }

    boolean isSelectedAll() {
        boolean nSelectAll = true;
        for (JSONObject item : mResultLists) {
            if (!item.optBoolean(CHECK_STATUS_FIELD)) {
                nSelectAll = false;
                break;
            }
        }
        return nSelectAll;
    }

    @Override
    protected List<SwipeMenuItem> createSwipeMenuItems(int viewType) {
        // TODO Auto-generated method stub
        List<SwipeMenuItem> nItems = new ArrayList<SwipeMenuItem>();
        if (viewType == ITEM_GOODS || viewType == ITEM_GOODS_ADJUNCT || viewType == ITEM_GIFT_SCORE) {
            SwipeMenuItem nItem = new SwipeMenuItem(mActivity);
            nItem.setWidth(Run.dip2px(mActivity, 80));
            nItem.setBackground(R.color.westore_red);
            nItem.setTitle("删除");
            nItem.setTitleColor(Color.WHITE);
            nItem.setTitleSize(18);
            nItems.add(nItem);

            nItem = new SwipeMenuItem(mActivity);
            nItem.setWidth(Run.dip2px(mActivity, 80));
            nItem.setBackground(R.color.westore_orange);
            nItem.setTitle("收藏");
            nItem.setTitleColor(Color.WHITE);
            nItem.setTitleSize(18);
            nItems.add(nItem);
        } else if (viewType == ITEM_GOODS_COLLECTION || viewType == ITEM_GOODS_ADJUNCT_COLLECTION || viewType == ITEM_GIFT_SCORE_COLLECTION) {
            SwipeMenuItem nItem = new SwipeMenuItem(mActivity);
            nItem.setWidth(Run.dip2px(mActivity, 80));
            nItem.setBackground(R.color.westore_red);
            nItem.setTitle("删除");
            nItem.setTitleColor(Color.WHITE);
            nItem.setTitleSize(18);
            nItems.add(nItem);

            nItem = new SwipeMenuItem(mActivity);
            nItem.setWidth(Run.dip2px(mActivity, 80));
            nItem.setBackground(R.color.westore_orange);
            nItem.setTitle("取消收藏");
            nItem.setTitleColor(Color.WHITE);
            nItem.setTitleSize(18);
            nItems.add(nItem);
        }
        return nItems;
    }

    @Override
    protected void onSwipeMenuItemClick(JSONObject positionJsonObject, int index) {
        // TODO Auto-generated method stub
        // super.onSwipeMenuItemClick(positionJsonObject, index);
        if (index == 0) {// 删除
            askRemoveGoods(positionJsonObject);
        } else if (index == 1) {// 收藏
            mModGoodsJsonObject = positionJsonObject;
            if (positionJsonObject.optBoolean("is_fav")) {
                mDelFavInterface.delFav(positionJsonObject.optString("goods_id"));
            } else {
                memberAddFavInterface.addFav(positionJsonObject.optString("goods_id"));
            }
        }
    }

    @Override
    public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
        // TODO Auto-generated method stub

    }

    @Override
    protected void initActionBar() {
        // TODO Auto-generated method stub

    }

    private void listenerSoftInput(final View view) {
        view.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {

            @Override
            public void onGlobalLayout() {
                // TODO Auto-generated method stub

                // int heightDiff = view.getRootView().getHeight() -
                // view.getHeight();
                // if (heightDiff > 100) { // 如果高度差超过100像素，就很有可能是有软键盘...
                // } else {
                if (isSaveNewQty) {
                    return;
                }
                isSaveNewQty = true;
                if (TextUtils.isEmpty(mCurEditQty)) {
                    mAdapter.notifyDataSetChanged();
                }
                updateQty(mCurEditJsonObject, Integer.parseInt(mCurEditQty));
                // }
            }
        });
    }
}
