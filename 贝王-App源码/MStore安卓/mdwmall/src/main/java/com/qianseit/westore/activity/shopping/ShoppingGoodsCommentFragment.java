package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsAddCommentsInterface;

import org.json.JSONException;
import org.json.JSONObject;

public class ShoppingGoodsCommentFragment extends BaseDoFragment {

    private EditText mEditText;
    private String mOrderId;
    private String mMemberId;
    private String mGoodsId;
    private LoginedUser mLoginedUser;
    private JSONObject goodsJson;
    private TextView mTextViewNum;
    private int contentNum = 140;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mActionBar.setTitle(R.string.orders_goods_rating);
        mLoginedUser = AgentApplication.getLoginedUser(mActivity);
        Intent intent = mActivity.getIntent();
        String data = intent.getStringExtra(Run.EXTRA_DATA);
        try {
            goodsJson = new JSONObject(data);
            mGoodsId = goodsJson.optString("goods_id");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        mMemberId = mLoginedUser.getMember().getMember_id();
        mOrderId = intent.getStringExtra(Run.EXTRA_ADDR);
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_shopping_goods_comment, null);
        findViewById(R.id.account_rating_submit).setOnClickListener(this);
        mEditText = (EditText) findViewById(R.id.account_rating_content);
        ImageView imageViewIcon = (ImageView) findViewById(R.id.account_rating_goods_icon);
        displaySquareImage(imageViewIcon, goodsJson.optString("thumbnail_pic_src"));
        ((TextView) findViewById(R.id.account_rating_goods_title)).setText(goodsJson.optString("name"));
        ((TextView) findViewById(R.id.account_rating_goods_price)).setText("￥" + goodsJson.optString("price"));
        mTextViewNum = (TextView) findViewById(R.id.account_rating_num);
        mEditText.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String content = mEditText.getText().toString();
                int ab = 140;
                int num = ab - content.length();
                if (num < 0) {
                    num = 0;
                    mEditText.setText(content.subSequence(0, ab));
                }

                mTextViewNum.setText(String.valueOf(num));

            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                // TODO Auto-generated method stub

            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.account_rating_submit:
                String strContent = mEditText.getText().toString().trim();
                if (!TextUtils.isEmpty(strContent)) {
                    new GoodsAddCommentsInterface(this, mMemberId, mGoodsId, strContent, mOrderId) {

                        @Override
                        public void SuccCallBack(JSONObject responseJson) {
                            // TODO Auto-generated method stub
                            if (responseJson.optBoolean("data")) {
                                Run.alert(mActivity, "评论成功");
                                mActivity.setResult(Activity.RESULT_OK);
                                mActivity.finish();
                            } else {
                                Run.alert(mActivity, "评论失败");
                            }
                        }
                    }.RunRequest();
                }
                break;
            default:
                break;
        }
        super.onClick(v);
    }
}
