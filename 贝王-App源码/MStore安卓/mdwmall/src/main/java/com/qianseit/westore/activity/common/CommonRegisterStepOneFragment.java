package com.qianseit.westore.activity.common;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.JsonObject;
import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.passport.DIYRegisterItemsInterface;
import com.qianseit.westore.httpinterface.passport.GetSmsCodeInterface;
import com.qianseit.westore.httpinterface.passport.LogoutInterface;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;

import org.json.JSONObject;


/**
 * Created by Hank on 16/11/29.
 */

public class CommonRegisterStepOneFragment extends BaseDoFragment implements TextWatcher {

    //注册项信息--是否开启图形验证码、相关注册项等
    JSONObject mDIYItemsJsonObject;

    //手机号码输入文本框
    EditText mPhoneInput;

    //图形验证码的布局视图
    LinearLayout mImageCodeLinearLayout;

    //图形验证码输入文本框
    EditText mImageCodeInput;

    //图形验证码
    ImageView mImageCodeView;

    //同意注册协议
    CheckBox mAgreeCheckBox;

    //注册协议文本
    TextView mProtocolTextView;

    //下一步按钮
    Button mNextStepButton;

    //联系客服
    TextView mContactCustomer;

    //能否启用图形验证码
    boolean mCanUseImageCode = false;

    //上条错误信息
    String mLastErrorMessage = "";

    //登录用户
    public LoginedUser mLoginedUser;

    ///弹窗
    Dialog mDialog;

    //重写创建
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        mLoginedUser = AgentApplication.getLoginedUser(mActivity);
    }

    //重写恢复
    @Override
    public void onResume() {

        super.onResume();
    }

    //初始化
    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        super.init(inflater, container, savedInstanceState);

        mActionBar.setShowTitleBar(true);

        mActionBar.setTitle("手机快速注册");

        rootView = inflater.inflate(R.layout.fragment_register_step_one, null);

        mPhoneInput = (EditText) rootView.findViewById(R.id.register_step_one_phone);

        mImageCodeLinearLayout = (LinearLayout) rootView.findViewById(R.id.register_step_one_imagecode_layout);

        mImageCodeInput = (EditText) rootView.findViewById(R.id.register_step_one_imagecode_text);

        mImageCodeView = (ImageView) rootView.findViewById(R.id.register_step_one_imagecode);

        mAgreeCheckBox = (CheckBox) rootView.findViewById(R.id.register_step_one_checkbox);

        mProtocolTextView = (TextView) rootView.findViewById(R.id.register_step_one_protocol);

        mNextStepButton = (Button) rootView.findViewById(R.id.register_step_one_commit);

        mNextStepButton.setEnabled(false);

        mContactCustomer = (TextView) rootView.findViewById(R.id.register_step_one_customer);

        mAgreeCheckBox.setChecked(true);

        mPhoneInput.addTextChangedListener(this);

        mImageCodeInput.addTextChangedListener(this);

        mAgreeCheckBox.setOnClickListener(this);

        mImageCodeView.setOnClickListener(this);

        mProtocolTextView.setOnClickListener(this);

        mNextStepButton.setOnClickListener(this);

        mContactCustomer.setOnClickListener(this);

        new DIYRegisterItemsInterface(this) {

            @Override
            public void SuccCallBack(JSONObject responseJson) {

                mDIYItemsJsonObject = responseJson;

                new LogoutInterface(CommonRegisterStepOneFragment.this) {

                    @Override
                    public void SuccCallBack(JSONObject responseJson) {

                        LoginedUser.getInstance().setIsLogined(false);

                        Run.savePrefs(mActivity, Run.pk_logined_user_password, "");

                        Run.goodsCounts = 0;
                    }
                }.RunRequest();

                mNextStepButton.setEnabled(checkCanCommit());

                parseDIYItems();
            }

            @Override
            public void task_response(String json_str) {
                if (!rootView.isShown()) {
                    rootView.setVisibility(View.VISIBLE);
                }

                super.task_response(json_str);
            }
        }.RunRequest();
    }

    //解析注册项数据
    void parseDIYItems() {

        mCanUseImageCode = mDIYItemsJsonObject.optBoolean("valideCode");

        if (mCanUseImageCode) {

            mImageCodeLinearLayout.setVisibility(View.VISIBLE);

            reloadVcodeImage();
        } else {

            mImageCodeLinearLayout.setVisibility(View.GONE);
        }
    }

    //下一步按钮能否点击
    boolean checkCanCommit() {

        mLastErrorMessage = "";

        String code = mImageCodeInput.getText().toString().toString().trim();

        String phone = mPhoneInput.getText().toString().toString().trim();

        if (TextUtils.isEmpty(phone) || !Run.isChinesePhoneNumber(phone)) {

            mLastErrorMessage = "请输入正确的手机号（11位）";

            return false;

        } else if (TextUtils.isEmpty(code) && mCanUseImageCode) {

            mLastErrorMessage = "验证码不能为空";

            return false;

        } else if (!TextUtils.isEmpty(code) && mCanUseImageCode){

            if (code.length() < 4){

                mLastErrorMessage = "输入有效验证码";

                return false;
            }
        }
        else {
            if (!mAgreeCheckBox.isChecked()) {

                mLastErrorMessage = "请同意《会员注册协议》";

                return false;
            }
        }
        return true;
    }

    //重新获取图形验证码
    private void reloadVcodeImage() {

        String vcodeUrl = Run.buildString(mDIYItemsJsonObject.optString("code_url"), "?", System.currentTimeMillis());

        displayRectangleImage(mImageCodeView, vcodeUrl);
    }

    //点击事件
    @Override
    public void onClick(View v) {

        super.onClick(v);

        switch (v.getId()) {

            case R.id.register_step_one_commit:

                if (checkCanCommit()){

                    mCodeSMSInterface.setData(mPhoneInput.getText().toString().toString().trim(), "signup", mCanUseImageCode ? mImageCodeInput.getText().toString() : "");

                    mCodeSMSInterface.RunRequest();
                }
                else {

                    Run.alert(mActivity, mLastErrorMessage);
                }

                break;
            case R.id.register_step_one_protocol:

                startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PASSPORT_REGISTRATION_PROTOCOL));

                break;
            case R.id.register_step_one_imagecode:

                reloadVcodeImage();

                break;
            case R.id.register_step_one_checkbox:

                mNextStepButton.setEnabled(checkCanCommit());

                break;
            case R.id.register_step_one_customer:

                if(mLoginedUser.getPhone() != null){
                    makePhoneCall(mLoginedUser.getPhone());
                }else {

                    showLoadingDialog();
                    ///加载客服电话
                    mLoginedUser.loadServicePhone(new LoginedUser.LoadServicePhoneHandler() {
                        @Override
                        public void onComplete() {
                            hideLoadingDialog();
                            makePhoneCall(mLoginedUser.getPhone());
                        }
                    });
                }
                break;
            default:
                break;
        }
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

    //获取短信验证码的请求
    SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {

            mGetSmsCodeInterface.getSmsCode(mPhoneInput.getText().toString().toString().trim(),"signup");
        }

        @Override
        public void FailRequest() {
            reloadVcodeImage();
        }
    };

    //获取后台的短信验证码
    GetSmsCodeInterface mGetSmsCodeInterface = new GetSmsCodeInterface(this) {
        @Override
        public void SuccCallBack(JSONObject responseJson) {
            String vcode = responseJson.optString("vcode");
            startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGEMTN_PASSPORT_STEP_TWO).putExtra(CommonRegisterStepTwoFragment.REGISTERNEEDIMAGECODE, mCanUseImageCode)
                    .putExtra(CommonRegisterStepTwoFragment.REGISTERCODEIMAGEURL, mDIYItemsJsonObject.optString("code_url")).putExtra(CommonRegisterStepTwoFragment.REGISTERPHONECODE, mPhoneInput.getText().toString().toString().trim()).putExtra(CommonRegisterStepTwoFragment.REGISTERPHONEVCODE,vcode),1001);
        }
        @Override
        public void FailRequest() {
        }
    };

    //回调
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        mActivity.setResult(Activity.RESULT_OK);

        mActivity.finish();
    }

    //输入监控
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
        mNextStepButton.setEnabled(checkCanCommit());
    }























}
