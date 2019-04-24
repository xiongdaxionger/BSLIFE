package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.bean.ThridLoginTrustBean;
import com.qianseit.westore.httpinterface.passport.BindMoblieIndexInterface;
import com.qianseit.westore.httpinterface.passport.BindMobileThridInterface;
import com.qianseit.westore.httpinterface.passport.DetectAccountExistInterface;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.beiwangfx.R;;

public class AccoBindMobileThridFragment extends BaseDoFragment implements TextWatcher {
    final int MSG_COUNTDOWNTIME = 0x01;
    private EditText mPasswdText;
    private EditText mMobileText;
    private EditText mVCodeImageText;
    private EditText mVCodeSmsText;

    private Button mSubmitButton, mGetVCodeSmsButton;

    int mCountDownTime = 120;

    ImageView mVCodeImageView;

    ThridLoginTrustBean mBean;

    Dialog mDialog;

    ///已检测的账号,空则表示还没有检测
    String mAccount;

    ///账号是否已注册
    boolean isExist = false;

    ///是否需要在检测账号完成后直接绑定手机
    boolean mShouldBindPhoneAfterDetectAccount = false;

    ///账号提示信息
    TextView mMsgTextView;

    JSONObject mBindMobileIndexJsonObject;
    BindMoblieIndexInterface mBindMoblieIndexInterface = new BindMoblieIndexInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            mBindMobileIndexJsonObject = responseJson;
            IndexLoaded();
        }
    };
    SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            mCountDownTime = 120;
            mGetVCodeSmsButton.setText(String.valueOf(mCountDownTime));
            mGetVCodeSmsButton.setBackgroundResource(R.drawable.bg_verify_code);
            mGetVCodeSmsButton.setTextColor(Color.parseColor("#ed6655"));
            mHandler.sendEmptyMessageDelayed(MSG_COUNTDOWNTIME, 1000);
        }

        @Override
        public void FailRequest() {
            mGetVCodeSmsButton.setEnabled(true);
            reloadImageVCode();
        }
    };

    BindMobileThridInterface mBindMobileInterface = new BindMobileThridInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub

            CommonLoginFragment.showAlertDialog(mActivity, "绑定手机号成功", "", "OK", null, new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent nIntent = new Intent();
                    nIntent.putExtra(Run.EXTRA_DATA, mMobileText.getText().toString().trim());
                    nIntent.putExtra(Run.EXTRA_VALUE, mPasswdText.getText().toString());
                    mActivity.setResult(Activity.RESULT_OK, nIntent);
                    mActivity.finish();
                }
            }, false, null);
        }
    };

    ///检测账号是否已注册
    DetectAccountExistInterface mDetectAccountExistInterface = new DetectAccountExistInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {

            ///账号不存在
            isExist = false;
            alertAccountExistMsg(null);
        }

        @Override
        public void FailRequest() {

            ///账号已存在
            isExist = true;
            String msg = mErrorJsonObject.optString("msg");
            alertAccountExistMsg(msg);
        }
    };

    ///调用检测接口
    private void detectAccountExist() {

        String account = mMobileText.getText().toString();
        ///如果已输入完整的手机号,并且手机号和以前检测的手机号不一致
        if (Run.isChinesePhoneNumber(account) && !account.equals(mAccount)) {

            mAccount = "";
            mDetectAccountExistInterface.detectAccount(account);
        }
    }

    ///提示账号是否存在
    private void alertAccountExistMsg(String msg) {

        ///检测后直接绑定手机
        if(mShouldBindPhoneAfterDetectAccount){

            mBindMobileInterface.bindMobile(mMobileText.getText().toString(), mVCodeSmsText.getText().toString(),
                    mPasswdText.getText().toString().trim(), mBean, !isExist);
        }

        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams)mSubmitButton.getLayoutParams();
        if (!TextUtils.isEmpty(msg)) {

            mMsgTextView.setText(msg);
            mMsgTextView.setVisibility(View.VISIBLE);

            layoutParams.topMargin = Run.dip2px(getContext(), 0f);

        } else {

            mMsgTextView.setVisibility(View.GONE);
            layoutParams.topMargin = Run.dip2px(getContext(), 15.0f);
        }

        mSubmitButton.setLayoutParams(layoutParams);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mBean = (ThridLoginTrustBean) getExtraSerializableFromBundle(Run.EXTRA_DATA);
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.init(inflater, container, savedInstanceState);
        mActionBar.setTitle("绑定手机号");
        rootView = inflater.inflate(R.layout.fragment_acco_bind_mobile, null);
        mMobileText = (EditText) findViewById(R.id.phone);
        mPasswdText = (EditText) findViewById(R.id.password);
        mVCodeImageText = (EditText) findViewById(R.id.vcode_image);
        mVCodeImageView = (ImageView) findViewById(R.id.vcode_image_ib);
        mMsgTextView = (TextView) findViewById(R.id.account_msg);

        mVCodeSmsText = (EditText) findViewById(R.id.vcode_sms);

        mSubmitButton = (Button) findViewById(R.id.submit_btn);
        mGetVCodeSmsButton = (Button) findViewById(R.id.vcode_sms_get);

        mSubmitButton.setOnClickListener(this);
        mGetVCodeSmsButton.setOnClickListener(this);
        mVCodeImageView.setOnClickListener(this);
        mMobileText.addTextChangedListener(this);

        mBindMoblieIndexInterface.RunRequest();
    }

    ///文字输入改变
    @Override
    public void afterTextChanged(Editable s) {

        mShouldBindPhoneAfterDetectAccount = false;
        detectAccountExist();
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }


    @Override
    public void ui(int what, Message msg) {
        // TODO Auto-generated method stub
        if (what == MSG_COUNTDOWNTIME) {
            mGetVCodeSmsButton.setText("" + mCountDownTime);
            mCountDownTime--;
            if (mCountDownTime < 0) {
                mGetVCodeSmsButton.setBackgroundResource(R.drawable.app_button_selector);
                mGetVCodeSmsButton.setTextColor(Color.parseColor("#ffffff"));
                mGetVCodeSmsButton.setText("获取验证码");
                mGetVCodeSmsButton.setEnabled(true);
            } else {
                mHandler.sendEmptyMessageDelayed(MSG_COUNTDOWNTIME, 1000);
            }
        } else {
            super.ui(what, msg);
        }
    }

    @Override
    protected void back() {
        // TODO Auto-generated method stub
        mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定放弃绑定手机号？", "第三方账号如果没有绑定手机号将无法登入M+Store", "取消", "确定", null,
                new OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                mDialog.dismiss();
                mActivity.setResult(Activity.RESULT_CANCELED);
                mActivity.finish();
            }
        });
    }

    @Override
    public void onDestroy() {
        // TODO Auto-generated method stub
        mHandler.removeMessages(MSG_COUNTDOWNTIME);
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.submit_btn:
                if (TextUtils.isEmpty(mMobileText.getText().toString().trim())) {
                    Run.alert(mActivity, "请输入手机号");
                    mMobileText.requestFocus();
                    return;
                }

                if (TextUtils.isEmpty(mVCodeSmsText.getText().toString().trim())) {
                    Run.alert(mActivity, "请输入短信验证码");
                    mVCodeSmsText.requestFocus();
                    return;
                }

                if (TextUtils.isEmpty(mPasswdText.getText().toString().trim())) {
                    Run.alert(mActivity, "请输入密码");
                    mPasswdText.requestFocus();
                    return;
                }

                ///判断账号是否已检测过
                if(mMobileText.getText().toString().equals(mAccount)){

                    mBindMobileInterface.bindMobile(mMobileText.getText().toString(), mVCodeSmsText.getText().toString(),
                            mPasswdText.getText().toString().trim(), mBean, !isExist);
                }else {

                    ///没有检测,需要检测后才能绑定手机号
                    mShouldBindPhoneAfterDetectAccount = true;
                    detectAccountExist();
                }
                break;
            case R.id.vcode_sms_get:
                String nPhone = mMobileText.getText().toString().trim();
                if (TextUtils.isEmpty(nPhone)) {
                    Run.alert(mActivity, "请输入手机号");
                    mMobileText.requestFocus();
                    return;
                }

                if (!Run.isChinesePhoneNumber(nPhone)) {
                    Run.alert(mActivity, "请输入正确的手机号");
                    mMobileText.requestFocus();
                    mMobileText.setSelection(mMobileText.getText().length());
                    return;
                }

                if (showVCode() && mVCodeImageText.getText().length() <= 0) {
                    Run.alert(mActivity, "请输入图文验证码");
                    mVCodeImageText.requestFocus();
                    return;
                }

                if (mVCodeImageText.getText().length() > 0)
                    mCodeSMSInterface.getVCode(nPhone, mVCodeImageText.getText().toString(), SendVCodeSMSInterface.TYPE_THIRDLOGIN);
                else
                    mCodeSMSInterface.getVCode(nPhone, "", SendVCodeSMSInterface.TYPE_THIRDLOGIN);
                break;
            case R.id.vcode_image_ib:
                reloadImageVCode();
                break;

            default:
                super.onClick(v);
                break;
        }
    }

    void reloadImageVCode() {
        displayRectangleImage(mVCodeImageView, getVCodeUrl());
    }

    protected void IndexLoaded() {
        // TODO Auto-generated method stub
        if (showVCode()) {
            findViewById(R.id.vcode_image_divider).setVisibility(View.VISIBLE);
            findViewById(R.id.vcode_image_tr).setVisibility(View.VISIBLE);
            reloadImageVCode();
        } else {
            findViewById(R.id.vcode_image_divider).setVisibility(View.GONE);
            findViewById(R.id.vcode_image_tr).setVisibility(View.GONE);
        }
    }

    boolean showVCode() {
        return mBindMobileIndexJsonObject == null ? false : mBindMobileIndexJsonObject.optBoolean("show_varycode");
    }

    String getVCodeUrl() {
        return mBindMobileIndexJsonObject == null ? "" : mBindMobileIndexJsonObject.optString("code_url") + "?" + System.currentTimeMillis();
    }
}
