package com.qianseit.westore.activity.common;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.method.PasswordTransformationMethod;
import android.text.method.SingleLineTransformationMethod;
import android.text.method.TransformationMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.passport.LoginInterface;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface;

import org.json.JSONObject;

/**
 * Created by Hank on 16/11/29.
 */

public class CommonRegisterStepThreeFragment extends BaseDoFragment implements TextWatcher {

    //注册手机号
    public String mPhoneCode = "";

    //收到的验证码
    public String mCode = "";

    //密码输入文本框
    EditText mPassWordInput;

    //密码显示切换
    CheckBox mPassWordCheckBox;

    //完成按钮
    Button mFinishButton;

    //联系客服
    TextView mContactTextView;

    //登录用户
    LoginedUser mLoginedUser;

    //弹窗
    Dialog mDialog;

    //重写创建
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        mLoginedUser = AgentApplication.getLoginedUser(mActivity);

        Intent nIntent = mActivity.getIntent();

        mPhoneCode = nIntent.getStringExtra(CommonRegisterStepTwoFragment.REGISTERPHONECODE);

        mCode = nIntent.getStringExtra(CommonRegisterStepTwoFragment.REGISTERPHONEVCODE);
    }

    //初始化
    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        super.init(inflater, container, savedInstanceState);

        mActionBar.setShowTitleBar(true);

        mActionBar.setTitle("手机快速注册");

        rootView = inflater.inflate(R.layout.fragment_register_step_three, null);

        mPassWordInput = (EditText) rootView.findViewById(R.id.register_step_three_password);

        mPassWordCheckBox = (CheckBox) rootView.findViewById(R.id.register_step_three_checkbox);

        mFinishButton = (Button) rootView.findViewById(R.id.register_step_three_commit);

        mContactTextView = (TextView) rootView.findViewById(R.id.register_step_three_customer);

        mFinishButton.setEnabled(false);

        mPassWordCheckBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

                TransformationMethod method = isChecked ? SingleLineTransformationMethod.getInstance() : PasswordTransformationMethod.getInstance();

                mPassWordInput.setTransformationMethod(method);

                mPassWordInput.setSelection(mPassWordInput.getText().length());

                mPassWordInput.postInvalidate();
            }
        });

        mPassWordInput.addTextChangedListener(this);

        mFinishButton.setOnClickListener(this);

        mContactTextView.setOnClickListener(this);
    }

    //点击事件
    @Override
    public void onClick(View v) {

        super.onClick(v);

        switch (v.getId()) {

            case R.id.register_step_three_commit:

                String password = mPassWordInput.getText().toString().toString().trim();

                if (!TextUtils.isEmpty(password)){

                    mRegistrMemberInterface.RunRequest();
                }
                else {

                    Run.alert(mActivity, "请输入6-20位密码");
                }

                break;
            case R.id.register_step_three_customer:

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

    //注册请求
    RegistrMemberInterface mRegistrMemberInterface = new RegistrMemberInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            mLoginInterface.setLoginInfo(mCode, mPassWordInput.getText().toString(), "");
            mLoginInterface.RunRequest();
        }

        @Override
        public void FailRequest() {
        }

        @Override
        public ContentValues BuildParams() {
            ContentValues nContentValues = new ContentValues();
            nContentValues.put("pam_account[login_name]", mPhoneCode);
            nContentValues.put("pam_account[login_password]", mPassWordInput.getText().toString());
            nContentValues.put("vcode", mCode);
            nContentValues.put("license", "on");
            nContentValues.put("pam_account[psw_confirm]", mPassWordInput.getText().toString());
            nContentValues.put("source","Android");
            return nContentValues;
        }
    };

    //登录请求

    LoginInterface mLoginInterface = new LoginInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            new MemberIndexInterface(CommonRegisterStepThreeFragment.this) {

                @Override
                public void responseSucc() {
                    // TODO Auto-generated method stub
                    try {
                        userLoginSuccess();
                    } catch (Exception e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }
            }.RunRequest();
        }
    };

    //登录成功
    /**
     * 用户登录成功
     *
     */
    private void userLoginSuccess() throws Exception {
        IntentFilter home_dynamic_filter = new IntentFilter();
        home_dynamic_filter.addAction(CommonHomeFragment.HOMEREFASH); // 添加动态广播的Action
        CommonHomeFragment.BroadcastReceiverHelper homeDynamicReceiver = new CommonHomeFragment.BroadcastReceiverHelper();
        mActivity.registerReceiver(homeDynamicReceiver, home_dynamic_filter);
        Intent homeIntent = new Intent();
        homeIntent.setAction(CommonHomeFragment.HOMEREFASH); // 发送广播
        mActivity.sendBroadcast(homeIntent);

        // 保存用户名，密码
        Run.savePrefs(mActivity, Run.pk_logined_username, mPhoneCode);
        Run.savePrefs(mActivity, Run.pk_logined_user_password, mPassWordInput.getText().toString().trim());

        mActivity.setResult(Activity.RESULT_OK);
        mActivity.finish();
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

        String password = mPassWordInput.getText().toString().toString().trim();

        mFinishButton.setEnabled(!password.isEmpty());
    }

}
