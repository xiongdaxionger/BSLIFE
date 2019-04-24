package com.qianseit.westore.activity.goods;

import android.content.Context;
import android.content.res.ColorStateList;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDialog;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.goods.GoodsProductBasicInterface;
import com.qianseit.westore.httpinterface.goods.ProductBasicHandler;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface.AdjunctBean;
import com.qianseit.westore.httpinterface.shopping.ShoppCarCheckoutInterface;
import com.qianseit.westore.ui.FlowLayout;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public abstract class GoodsSpecDialog extends BaseDialog implements QianseitActivityInterface, TextWatcher, android.view.View.OnClickListener, OnTouchListener {

    JSONObject mProductJsonObject;
    JSONArray mBtnArray;
    ListView mListView;
    List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();

    TextView mPriceTextView, mStoreTextView, mChoosedTextView, mGoodNameTextView;
    Button mBuyButton, mNoticeButton, mSubButton, mAddButton;
    ImageView mIconImageView;

    EditText mQtyEditText;
    TextView mQtyRemarkTextView;

    float mSpecValueTextSize = 13;
    String mChoosedSpecInfo = "";

    BaseDoFragment mParentBaseDoFragment;
    ShoppCarAddInterface mAddCarInterface;
    ShoppCarCheckoutInterface mCarCheckoutInterface;

    ProductBasicHandler mBasicHandler;

    JSONObject mGiftJsonObject;
    boolean isGift = false;
    int mStore = 0;

    boolean isFastBuyParent = false;
    boolean isFastBuy = false;

    QianseitAdapter<JSONObject> mAdapter = new QianseitAdapter<JSONObject>(mJsonObjects) {

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // TODO Auto-generated method stub
            SpecItemView nItemView;
            if (convertView == null) {
                nItemView = new SpecItemView();
                convertView = View.inflate(mContext, R.layout.item_goods_spec, null);
                nItemView.mSpecName = (TextView) convertView.findViewById(R.id.spec_name);
                nItemView.mTags = (FlowLayout) convertView.findViewById(R.id.spec_values);
                nItemView.mSpecValue = (TextView) convertView.findViewById(R.id.spec_value);
                convertView.setTag(nItemView);
            } else {
                nItemView = (SpecItemView) convertView.getTag();
            }

            JSONObject nItemJsonObject = getItem(position);

            nItemView.mItemJsonObject = nItemJsonObject;
            nItemView.mSpecName.setText(nItemJsonObject.optString("group_name"));
            nItemView.clearRadioButton();
            nItemView.mTags.setVisibility(View.VISIBLE);

            JSONArray nArray = nItemJsonObject.optJSONArray("group_spec");
            if (nArray != null && nArray.length() >= 0) {
                for (int i = 0; i < nArray.length(); i++) {
                    nItemView.addSpecValue(getSpecValueView(nArray.optJSONObject(i)));
                }
            }
            return convertView;
        }

        @Override
        public int getCount() {
            return mJsonObjects.size();
        }
    };

    GoodsProductBasicInterface mBasicInterface;

    RadioButton getSpecValueText(JSONObject jsonObject) {
        RadioButton nButton = new RadioButton(mContext);
        nButton.setBackgroundResource(R.drawable.spec_value_selector);
        ColorStateList nColorStateList = mContext.getResources().getColorStateList(R.color.spec_value_selector);
        nButton.setTextColor(nColorStateList);
        nButton.setButtonDrawable(android.R.color.transparent);
        nButton.setPadding(Run.dip2px(mContext, 10), Run.dip2px(mContext, 5), Run.dip2px(mContext, 10), Run.dip2px(mContext, 5));
        nButton.setGravity(Gravity.CENTER);
        nButton.setText(jsonObject.optString("spec_value"));
        nButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, mSpecValueTextSize);
        nButton.setTag(jsonObject);
        nButton.setChecked(jsonObject.optBoolean("select", false));
        return nButton;
    }

    View getSpecValueView(JSONObject jsonObject) {
        if (jsonObject == null) {
            return null;
        }

        if (jsonObject.isNull("spec_image")) {
            return getSpecValueText(jsonObject);
        }

        return getSpecValueImageView(jsonObject);
    }

    View getSpecValueImageView(JSONObject jsonObject) {
        View nView = View.inflate(mContext, R.layout.item_spec_value_image, null);
        ((TextView) nView.findViewById(R.id.goods_spec_name)).setText(jsonObject.optString("spec_value"));
        RadioButton nButton = new RadioButton(mContext);
        nButton.setBackgroundResource(R.drawable.spec_value_selector);
        BaseDoFragment.displayCircleImage((ImageView) nView.findViewById(R.id.goods_spec_image), jsonObject.optString("spec_image"), R.drawable.default_img_cricle);
        nView.setSelected(jsonObject.optBoolean("select", false));
        nView.setTag(jsonObject);

        return nView;
    }

    class SpecItemView implements View.OnClickListener {
        public TextView mSpecName;
        public FlowLayout mTags;
        public TextView mSpecValue;
        public List<View> mSpecValues = new ArrayList<View>();
        public JSONObject mSelectedTag = null;
        public JSONObject mItemJsonObject;

        public void addSpecValue(View view) {
            mSpecValues.add(view);
            if (mTags != null) {
                mTags.addView(view, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            }
            view.setOnClickListener(this);
        }

        public void clearRadioButton() {
            mSpecValues.clear();
            if (mTags != null) {
                mTags.removeAllViews();
            }
        }

        @Override
        public void onClick(View v) {
            // TODO Auto-generated method stub
            JSONObject nJsonObject = (JSONObject) v.getTag();
            if (nJsonObject.optBoolean("select", false)) {
                return;
            }

            mBasicInterface.setProductId(nJsonObject.optString("product_id"), isGift);
            mBasicInterface.RunRequest();
        }
    }

    public GoodsSpecDialog(Context context, BaseDoFragment doFragment) {
        super(context);
        // TODO Auto-generated constructor stub
        mContext = context;
        mWindow = getWindow();
        mWindow.setBackgroundDrawableResource(backgroundRes());
        this.setContentView(init());
        this.setCanceledOnTouchOutside(true);
        mParentBaseDoFragment = doFragment;
        mAddCarInterface = new ShoppCarAddInterface(mParentBaseDoFragment == null ? this : mParentBaseDoFragment) {

            @Override
            public void SuccCallBack(JSONObject responseJson) {
                // TODO Auto-generated method stub
                if (isFastBuy()) {
                    mCarCheckoutInterface.reset();
                    mCarCheckoutInterface.setFastbuy();
                    mCarCheckoutInterface.addGoodsIdent(getIdentId());
                    mCarCheckoutInterface.RunRequest();
                    dismiss();
                } else {
                    Run.alert(mContext, "加入购物车成功");
                    Run.goodsCounts += getQty();
                    dismiss();
                }
            }

        };
        mCarCheckoutInterface = new ShoppCarCheckoutInterface(mParentBaseDoFragment == null ? this : mParentBaseDoFragment) {

            @Override
            public void SuccCallBack(JSONObject responseJson) {
                // TODO Auto-generated method stub
                Bundle nBundle = new Bundle();
                nBundle.putString(Run.EXTRA_DATA, responseJson.toString());
                mParentBaseDoFragment.startActivity(AgentActivity.FRAGMENT_SHOPP_CONFIRM_ORDER, nBundle);
            }
        };
        mBasicInterface = new GoodsProductBasicInterface(mParentBaseDoFragment == null ? this : mParentBaseDoFragment, "") {

            @Override
            public void ResponseBasic(JSONObject basicJsonObject) {
                // TODO Auto-generated method stub
                try {
                    basicJsonObject.put(GoodsUtil.CHOOSED_QTY, mQtyEditText.getText().toString());
                } catch (JSONException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }

                setData(basicJsonObject, null, isFastBuyParent);
                if (mBasicHandler != null) {
                    mBasicHandler.ResponseBasic(basicJsonObject);
                }
            }

            @Override
            public void ResponseSetting(JSONObject jsonObject) {
                // TODO Auto-generated method stub
                if (mBasicHandler != null) {
                    mBasicHandler.ResponseSetting(jsonObject);
                }
            }

            @Override
            public void ResponseBtns(JSONArray btnArray) {
                if (mBasicHandler != null) {
                    mBasicHandler.ResponseBtns(btnArray);
                }

                mBtnArray = btnArray;
                praseBtns();
            }
        };
    }

    @Override
    protected View init() {
        RelativeLayout view = null;
        try {
            view = (RelativeLayout) LayoutInflater.from(mContext).inflate(R.layout.goods_spec_dialog, null);

            mPriceTextView = (TextView) view.findViewById(R.id.goods_spec_price);
            mStoreTextView = (TextView) view.findViewById(R.id.goods_spec_store);
            mChoosedTextView = (TextView) view.findViewById(R.id.goods_spec_choosed);
            mGoodNameTextView = (TextView) view.findViewById(R.id.good_title_textView);

            mIconImageView = (ImageView) view.findViewById(R.id.goods_spec_icon);
            view.findViewById(R.id.goods_spec_top).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    dismiss();
                }
            });
            view.findViewById(R.id.goods_spec_cancel).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    dismiss();
                }
            });

            mListView = (ListView) view.findViewById(R.id.goods_spec_list);

            View nView = view.findViewById(R.id.goods_spec_qty_lv);
            mQtyRemarkTextView = (TextView) nView.findViewById(R.id.qty_remark);
            mQtyEditText = (EditText) nView.findViewById(R.id.goods_spec_qty);
            mQtyEditText.addTextChangedListener(GoodsSpecDialog.this);
            (mSubButton = (Button) nView.findViewById(R.id.goods_spec_minus)).setOnClickListener(GoodsSpecDialog.this);
            (mAddButton = (Button) nView.findViewById(R.id.goods_spec_plus)).setOnClickListener(GoodsSpecDialog.this);
            mSubButton.setOnTouchListener(GoodsSpecDialog.this);
            mAddButton.setOnTouchListener(GoodsSpecDialog.this);
            listenerSoftInput(view);

            view.removeView(nView);
            nView.setLayoutParams(new AbsListView.LayoutParams(nView.getLayoutParams()));
            mListView.addFooterView(nView);

            mListView.setAdapter(mAdapter);
            (mNoticeButton = (Button) view.findViewById(R.id.goods_spec_notice)).setOnClickListener(this);
            (mBuyButton = (Button) view.findViewById(R.id.goods_spec_buy)).setOnClickListener(this);

            mSpecValueTextSize = mContext.getResources().getDimensionPixelSize(R.dimen.TextSizeBigSmall);
        } catch (Exception e) {
            // TODO: handle exception
            Log.w(Run.TAG, e.getMessage());
        }
        return view;
    }

    @Override
    protected int backgroundRes() {
        return R.color.transparent;
    }

    public void setProductBasicHandler(ProductBasicHandler basicHandler) {
        mBasicHandler = basicHandler;
    }

    @Override
    protected float widthScale() {
        return 1;
    }

    @Override
    protected int gravity() {
        // TODO Auto-generated method stub
        return Gravity.BOTTOM;
    }

    private void listenerSoftInput(final View view) {
        view.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {

            @Override
            public void onGlobalLayout() {
                // TODO Auto-generated method stub
                int heightDiff = view.getRootView().getHeight() - view.getHeight();
                if (heightDiff > 100) { // 如果高度差超过100像素，就很有可能是有软键盘...
                } else {
                    if (mQtyEditText.getText().length() <= 0) {
                        mQtyEditText.setText(mProductJsonObject.optString(GoodsUtil.CHOOSED_QTY));
                        mQtyEditText.setSelection(mQtyEditText.getText().length());
                    }
                }
            }
        });
    }

    public void setIsGift(boolean isGift) {
        this.isGift = isGift;
    }

    void praseBtns() {
        if (mBtnArray == null) {
            return;
        }
        if (!mProductJsonObject.optBoolean("product_marketable", false)) {
            mNoticeButton.setEnabled(false);
            mNoticeButton.setText("该规格已下架");
            mNoticeButton.setVisibility(View.VISIBLE);
            mBuyButton.setVisibility(View.GONE);
            return;
        }

        boolean canFastBuy = false, canAddcar = false, noticeBuy = false, noticeAddCar = false;
        for (int i = 0; i < mBtnArray.length(); i++) {
            JSONObject nJsonObject = mBtnArray.optJSONObject(i);
            if (nJsonObject.optString("value").equals("fastbuy")) {
                canFastBuy = nJsonObject.optBoolean("buy");
//                isFastBuy = canFastBuy;
                noticeBuy = nJsonObject.optBoolean("show_notify");
            } else if (nJsonObject.optString("value").equals("buy")) {
                canAddcar = nJsonObject.optBoolean("buy");
//                isFastBuy = isFastBuyParent;
                noticeAddCar = nJsonObject.optBoolean("show_notify");
            }
        }

        if (isFastBuyParent && !canFastBuy && canAddcar){

            isFastBuy = false;
        }
        else if(!isFastBuyParent && !canAddcar && canFastBuy){

            isFastBuy = true;
        }

        if (canFastBuy || canAddcar) {
            mBuyButton.setText("确定");
            mBuyButton.setEnabled(true);
            mBuyButton.setVisibility(View.VISIBLE);
            mNoticeButton.setVisibility(View.GONE);
        } else if ((noticeBuy && isFastBuyParent) || (noticeAddCar && !isFastBuyParent)) {
            mNoticeButton.setEnabled(true);
            mNoticeButton.setText("到货通知");
            mNoticeButton.setVisibility(View.VISIBLE);
            mBuyButton.setVisibility(View.GONE);
        } else {
            mBuyButton.setText("确定");
            mBuyButton.setEnabled(false);
            mBuyButton.setVisibility(View.VISIBLE);
            mNoticeButton.setVisibility(View.GONE);
        }
    }

    void setData(JSONObject productJsonObject, JSONArray btnArray, boolean isFastBuy) {
        this.isFastBuyParent = isFastBuy;
        this.isFastBuy = isFastBuy;
        mProductJsonObject = productJsonObject;
        mJsonObjects.clear();
        if (mProductJsonObject == null) {
            return;
        }
        JSONArray nArray = mProductJsonObject.optJSONArray("spec");
        if (nArray != null && nArray.length() > 0) {
            for (int i = 0; i < nArray.length(); i++) {
                mJsonObjects.add(nArray.optJSONObject(i));
            }
        }
        mStore = mProductJsonObject != null ? mProductJsonObject.optInt("store") : 1;
        if (mStore < 1) {
            mStore = 1;
        }

        mChoosedSpecInfo = GoodsUtil.formatChoosedSpec(nArray);
        updateChoosedInfo();

        mAdapter.notifyDataSetChanged();

        BaseDoFragment.displaySquareImage(mIconImageView, mProductJsonObject.optString("image_default_id"));

        if (mProductJsonObject.optBoolean("is_gift", false)) {
            mGiftJsonObject = productJsonObject.optJSONObject("gift");
            mStore = mGiftJsonObject.optInt("max");
            mPriceTextView.setText(mGiftJsonObject.optString("consume_score") + "积分");
            mStoreTextView.setText(String.format("限兑%s%s", mGiftJsonObject.optString("max"), StringUtils.getString(mProductJsonObject, "unit")));
        } else {
            JSONObject nPriceJsonObject = productJsonObject.optJSONObject("price_list");
            JSONObject nShowJsonObject = nPriceJsonObject.optJSONObject("show");
            if (nShowJsonObject != null) {
                mPriceTextView.setText(nShowJsonObject.optString("format"));
            }

            mStoreTextView.setText(String.format("库存%s", mProductJsonObject.optString("store_title")));
        }

        mQtyEditText.setText(mProductJsonObject.optString(GoodsUtil.CHOOSED_QTY));
        String nQtyRemark = "";
        if ("starbuy".equals(mProductJsonObject.optString("promotion_type"))) {// 秒杀
            if (!mProductJsonObject.isNull("special_info")) {
                JSONObject nSpecialJsonObject = mProductJsonObject.optJSONObject("special_info");
                nQtyRemark = String.format("限购：%s%s", nSpecialJsonObject.optString("limit"), StringUtils.getString(mProductJsonObject, "unit"));
                mStore = nSpecialJsonObject.optInt("limit");
            }
        }
        mQtyRemarkTextView.setText(nQtyRemark);
        mGoodNameTextView.setText(mProductJsonObject.optString("title"));

        if (btnArray == null) {
            return;
        }
        mBtnArray = btnArray;
        praseBtns();
    }

    void updateChoosedInfo() {
        String nQtyDisplay = mProductJsonObject.optString(GoodsUtil.CHOOSED_QTY) + StringUtils.getString(mProductJsonObject, "unit");
        StringBuilder nDisplay = new StringBuilder();
        nDisplay.append(nQtyDisplay).append("、").append(mChoosedSpecInfo);
        if (nDisplay.charAt(nDisplay.length() - 1) == '、') {
            nDisplay.deleteCharAt(nDisplay.length() - 1);
        }
        mChoosedTextView.setText(nDisplay.toString());
        nDisplay.delete(0, nDisplay.length());
    }

    @Override
    public void showLoadingDialog() {
        // TODO Auto-generated method stub

    }

    @Override
    public void showCancelableLoadingDialog() {
        // TODO Auto-generated method stub

    }

    @Override
    public void hideLoadingDialog() {
        // TODO Auto-generated method stub

    }

    @Override
    public void hideLoadingDialog_mt() {
        // TODO Auto-generated method stub

    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        // TODO Auto-generated method stub

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        // TODO Auto-generated method stub

    }

    @Override
    public void afterTextChanged(Editable s) {
        // TODO Auto-generated method stub
        if (s.length() <= 0) {
            return;
        }

        int nQty = Integer.parseInt(s.toString());

        if (nQty > mStore) {
            mQtyEditText.setText(String.valueOf(mStore));
            mQtyEditText.setSelection(mQtyEditText.getText().length());
        }

        try {
            mProductJsonObject.put(GoodsUtil.CHOOSED_QTY, mQtyEditText.getText().toString());
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        updateQty(mProductJsonObject);
        updateChoosedInfo();
    }

    public abstract void updateQty(JSONObject productBasicJsonObject);

    public abstract List<AdjunctBean> getAdjuncts();

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        int nQty = 1;
        switch (v.getId()) {
            case R.id.goods_spec_plus:
                addQty(1);
                break;
            case R.id.goods_spec_minus:
                addQty(-1);
                break;
            case R.id.goods_spec_buy:
                if (mQtyEditText.getText().length() > 0) {
                    nQty = Integer.parseInt(mQtyEditText.getText().toString());
                }
                mAddCarInterface.setData(mProductJsonObject.optString("goods_id"), mProductJsonObject.optString("product_id"), nQty);
                mAddCarInterface.setAdjunct(getAdjuncts());
                if (isFastBuy) mAddCarInterface.setIsFastBuy();
                if (mProductJsonObject.optBoolean("is_gift", false)) {
                    mAddCarInterface.setIsGift();
                }
                mAddCarInterface.RunRequest();
                break;
            case R.id.goods_spec_notice:
                Bundle nBundle = new Bundle();
                nBundle.putString(Run.EXTRA_GOODS_ID, mProductJsonObject.optString("goods_id"));
                nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductJsonObject.optString("product_id"));
                mParentBaseDoFragment.startActivity(AgentActivity.FRAGMENT_GOODS_ARRIVAL_NOTICE, nBundle);
                dismiss();
                break;

            default:
                break;
        }
    }

    void addQty(int qty) {
        if (mQtyEditText.getText().length() <= 0) {
            mQtyEditText.setText("1");
            return;
        }

        int nQty = Integer.parseInt(mQtyEditText.getText().toString());

        nQty = nQty + qty;
        if (nQty <= 1) {
            nQty = 1;
        }

        mQtyEditText.setText(nQty + "");
    }

    final int MSG_ADD = 1;
    final int MSG_SUB = 2;
    long mDownTime = 0;
    boolean isLongClick = false;
    // 更新文本框的值
    Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {

            switch (msg.what) {

                case MSG_ADD:
                case MSG_SUB:
                    if (mDownTime > 0) {
                        addQty(msg.what == MSG_ADD ? 1 : -1);
                        mHandler.sendEmptyMessageDelayed(msg.what, 200);
                        isLongClick = true;
                    }
                    break;
            }
        }
    };

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        // TODO Auto-generated method stub

        boolean nRet = false;
        int nMsg = -1;
        if (v.getId() == R.id.goods_spec_minus) {
            nMsg = MSG_SUB;
        } else if (v.getId() == R.id.goods_spec_plus) {
            nMsg = MSG_ADD;
        }

        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            isLongClick = false;
            mDownTime = System.currentTimeMillis();
            if (nMsg == MSG_SUB || nMsg == MSG_ADD) {
                mHandler.sendEmptyMessageDelayed(nMsg, 2000);
            }
        } else if (event.getAction() == MotionEvent.ACTION_UP) {
            mDownTime = 0;
            if (isLongClick) {
                nRet = true;
            }
        } else if (event.getAction() == MotionEvent.ACTION_MOVE) {
        }

        return nRet;
    }

    @Override
    public void onDetachedFromWindow() {
        // TODO Auto-generated method stub
        mHandler.removeMessages(MSG_ADD);
        mHandler.removeMessages(MSG_SUB);
        super.onDetachedFromWindow();
    }
}
