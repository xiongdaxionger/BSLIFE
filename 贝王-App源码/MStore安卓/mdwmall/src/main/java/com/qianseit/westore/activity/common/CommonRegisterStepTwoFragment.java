package com.qianseit.westore.activity.common;

import android.annotation.SuppressLint;
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
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;

import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Hank on 16/11/29.
 */

public class CommonRegisterStepTwoFragment extends BaseDoFragment implements TextWatcher{

    //是否需要验证码
    public final static String REGISTERNEEDIMAGECODE = "REGISTERNEEDIMAGECODE";

    //外部暴露的手机号码key
    public final static String REGISTERPHONECODE = "REGISTERPHONECODE";

    //外部暴露的图形验证码链接
    public final static String REGISTERCODEIMAGEURL = "REGISTERCODEIMAGEURL";

    //外部暴露的短信验证码
    public final static String REGISTERPHONEVCODE = "REGISTERPHONEVCODE";

    //登录用户
    public LoginedUser mLoginedUser;

    //是否需要验证码
    boolean mNeedImageCode = false;

    //获取短信验证码的手机号码
    String mPhoneCode = "";

    //短信验证码
    String mCode = "";

    //图形验证码链接
    String mImageCodeURL = "";

    //手机标题
    TextView mPhoneTitleText;

    //验证码输入文本框
    EditText mCodeTextInput;

    //再次获取验证码按钮
    Button mGetCodeButton;

    //图形验证码的布局视图
    LinearLayout mImageCodeLinearLayout;

    //图形验证码输入文本框
    EditText mImageCodeInput;

    //图形验证码
    ImageView mImageCodeView;

    //下一步按钮
    Button mNextButton;

    //联系客服
    TextView mContactCustomer;

    //上条错误信息
    String mLastErrorMessage = "";

    //图形验证码计时间隔
    private int recLen = 120;

    //图形验证码计时器
    Timer timer = new Timer();

    //图形验证码计时任务
    TimerTask timeTask;

    //弹窗
    Dialog mDialog;

    //重写创建
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        mLoginedUser = AgentApplication.getLoginedUser(mActivity);

        Intent nIntent = mActivity.getIntent();

        mNeedImageCode = nIntent.getBooleanExtra(REGISTERNEEDIMAGECODE,false);

        mPhoneCode = nIntent.getStringExtra(REGISTERPHONECODE);

        mImageCodeURL = nIntent.getStringExtra(REGISTERCODEIMAGEURL);

        mCode = nIntent.getStringExtra(REGISTERPHONEVCODE);
    }

    //初始化
    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        super.init(inflater, container, savedInstanceState);

        mActionBar.setShowTitleBar(true);

        mActionBar.setTitle("手机快速注册");

        rootView = inflater.inflate(R.layout.fragment_register_step_two, null);

        mPhoneTitleText = (TextView) rootView.findViewById(R.id.register_step_two_phone);

        mCodeTextInput = (EditText) rootView.findViewById(R.id.register_step_two_code);

        mGetCodeButton = (Button) rootView.findViewById(R.id.register_step_two_getcode);

        mImageCodeLinearLayout = (LinearLayout) rootView.findViewById(R.id.register_step_two_imagecode_layout);

        mImageCodeLinearLayout.setVisibility(View.GONE);

        mImageCodeView = (ImageView) rootView.findViewById(R.id.register_step_two_imagecode);

        mImageCodeInput = (EditText) rootView.findViewById(R.id.register_step_two_imagecode_text);

        mNextButton = (Button) rootView.findViewById(R.id.register_step_two_commit);

        mContactCustomer = (TextView) rootView.findViewById(R.id.register_step_two_customer);

        mGetCodeButton.setEnabled(false);

        mContactCustomer.setOnClickListener(this);

        mImageCodeInput.addTextChangedListener(this);

        mCodeTextInput.addTextChangedListener(this);

        mNextButton.setOnClickListener(this);

        mGetCodeButton.setOnClickListener(this);

        mImageCodeView.setOnClickListener(this);

        mPhoneTitleText.setText("请输入" + mPhoneCode + "收到的短信验证码");

        setButtonTimer();
    }

    //时间任务
    private TimerTask GetTimerTask() {

        TimerTask task = new TimerTask() {

            @Override
            public void run() {

                mActivity.runOnUiThread(new Runnable() {

                    @SuppressLint("ResourceAsColor")

                    @Override
                    public void run() {

                        mGetCodeButton.setText("重新发送" + "(" + recLen + ")");

                        recLen--;

                        if (recLen < 0) {

                            mGetCodeButton.setBackgroundResource(R.drawable.app_button_selector);

                            mGetCodeButton.setTextColor(Color.parseColor("#ffffff"));

                            mGetCodeButton.setText("重新获取");

                            mGetCodeButton.setEnabled(true);

                            mImageCodeLinearLayout.setVisibility(mNeedImageCode ? View.VISIBLE : View.GONE);
                        }

                    }
                });

            }
        };
        return task;
    }

    //点击事件
    @Override
    public void onClick(View v) {

        super.onClick(v);

        switch (v.getId()) {

            case R.id.register_step_two_commit:

                String inputVCode = mCodeTextInput.getText().toString().toString().trim();

                if (checkCanCommit()){

                    if (!mCode.equals(inputVCode)){

                        Run.alert(mActivity,"请输入正确的验证码");

                        return;
                    }

                    startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGEMTN_PASSPORT_STEP_THREE)
                            .putExtra(CommonRegisterStepTwoFragment.REGISTERPHONECODE, mPhoneCode).putExtra(CommonRegisterStepTwoFragment.REGISTERPHONEVCODE,mCode),1002);
                }
                else {

                    Run.alert(mActivity, mLastErrorMessage);
                }

                break;
            case R.id.register_step_two_getcode:

                String code = mImageCodeInput.getText().toString().toString().trim();

                boolean isCodeEmpty = TextUtils.isEmpty(code);

                if (mNeedImageCode && isCodeEmpty){

                    Run.alert(mActivity, "请输入图形验证码");

                    return;
                }

                mGetCodeButton.setEnabled(false);

                mCodeSMSInterface.setData(mPhoneCode, "signup", mNeedImageCode ? mImageCodeInput.getText().toString() : "");

                mCodeSMSInterface.RunRequest();

                break;
            case R.id.register_step_two_customer:

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
            case R.id.register_step_two_imagecode:
                reloadVcodeImage();
                break;
            default:
                break;
        }
    }

    //下一步按钮能否点击
    boolean checkCanCommit() {

        mLastErrorMessage = "";

        String code = mCodeTextInput.getText().toString().toString().trim();

         if (TextUtils.isEmpty(code)) {

            mLastErrorMessage = "验证码不能为空";

            return false;
        }

        return true;
    }

    //重新获取图形验证码
    private void reloadVcodeImage() {

        String vcodeUrl = Run.buildString(mImageCodeURL, "?", System.currentTimeMillis());

        displayRectangleImage(mImageCodeView, vcodeUrl);
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

    //获取短信验证码
    SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", "") {

        @Override
        public void SuccCallBack(JSONObject responseJson) {

            setButtonTimer();
        }

        @Override
        public void FailRequest() {
            reloadVcodeImage();
        }
    };

    public void setButtonTimer(){

        if (timer != null) {

            timer.cancel();

            timer = null;

        }
        if (timeTask != null) {

            timeTask = null;

        }

        timer = new Timer();

        timeTask = GetTimerTask();

        timer.schedule(timeTask, 0, 1000);

        mGetCodeButton.setText(String.valueOf(recLen));

        mGetCodeButton.setBackgroundResource(R.drawable.bg_verify_code);

        mGetCodeButton.setTextColor(Color.parseColor("#ed6655"));
    }

    //回调
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

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
        mNextButton.setEnabled(checkCanCommit());
    }

}
