package com.qianseit.westore.activity.passport;

import org.json.JSONObject;

import com.beiwangfx.R;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.view.View;

/**
 * 验证码组件
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingVCodeView extends FrameLayout implements android.view.View.OnClickListener {
	final int MSG_COUNTDOWN = 10000;
	TextView mTitleTextView;
	EditText mVCodeEditText;
	View mDivideView;
	View mTopDivideView;
	String mVCodeTypeString = SendVCodeSMSInterface.TYPE_ACTIVATION;
	String mTelString;
	SendVCodeSMSInterface mCodeSmsInterface;
	BaseDoFragment mBaseDoFragment;
	private long countdown_time = 60;
	Button mButton;
	Dialog mDialog;

	private boolean isInited = false;
	private boolean mIsSend = false;

	public ItemSettingVCodeView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingVCodeView(Context context, boolean isSend) {
		super(context);
		// TODO Auto-generated constructor stub
		mIsSend = isSend;
		this.initView();
	}

	public ItemSettingVCodeView(Context context, BaseDoFragment baseDoFragment, String telString, String typeString, boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView( baseDoFragment, telString, typeString, showDivide);
	}

	public ItemSettingVCodeView(Context context, BaseDoFragment baseDoFragment, String telString, String typeString, boolean showDivide, boolean showTopDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView( baseDoFragment, telString, typeString, showDivide);
		this.initView( baseDoFragment, telString, typeString, showDivide, showTopDivide);
	}

	public ItemSettingVCodeView(Context context, BaseDoFragment baseDoFragment, String telString, String typeString, boolean showDivide, boolean showTopDivide, boolean isSend) {
		super(context);
		// TODO Auto-generated constructor stub
		mIsSend = isSend;
		this.initView();
		this.initView( baseDoFragment, telString, typeString, showDivide);
		this.initView( baseDoFragment, telString, typeString, showDivide, showTopDivide);
	}

	public ItemSettingVCodeView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingVCodeView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(BaseDoFragment baseDoFragment, String telString, String typeString, boolean showDivide) {
		showDivide(showDivide);
		mBaseDoFragment = baseDoFragment;
		mTelString = telString;
		mVCodeTypeString = typeString;
		initBaseDoFragment();
	}

	private void initView(BaseDoFragment baseDoFragment, String telString, String typeString, boolean showDivide, boolean showTopDivide) {
		showDivide(showDivide);
		showTopDivide(showTopDivide);
		mBaseDoFragment = baseDoFragment;
		mTelString = telString;
		mVCodeTypeString = typeString;
		initBaseDoFragment();
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_vcode, null));
			mTitleTextView = (TextView) findViewById(R.id.item_setting_vcode_title);
			mVCodeEditText = (EditText) findViewById(R.id.vcode_et);
			mDivideView = findViewById(R.id.item_setting_divide);
			mTopDivideView = findViewById(R.id.item_setting_divide_top);
			mButton = (Button) findViewById(R.id.btn_get_vcode);
			findViewById(R.id.btn_get_vcode).setOnClickListener(this);

			if (mIsSend) {
				beginCountDown();
			}

			mVCodeEditText.setText("");
		}
	}

	public void setTip(String textString) {
		mTitleTextView.setText(textString);
	}
	
	public String getVCode(){
		return mVCodeEditText.getText().toString();
	}

	public void showDivide(boolean showDivide) {
		mDivideView.setVisibility(showDivide ? View.VISIBLE : View.INVISIBLE);
	}

	public void showTopDivide(boolean showDivide) {
		mTopDivideView.setVisibility(showDivide ? View.VISIBLE : View.GONE);
	}
	
	public void removeRunningMsg(){
		mHandler.removeMessages(MSG_COUNTDOWN);

		mButton.setEnabled(true);
		mButton.setText(R.string.acco_regist_get_verify_code_again);
		mButton.setBackgroundResource(R.drawable.qianseit_bg_vcode_click);
		mButton.setTextColor(mBaseDoFragment.mActivity.getResources().getColor(R.color.westore_primary_textcolor));
	}

	public void initBaseDoFragment(){
		mCodeSmsInterface = new SendVCodeSMSInterface(mBaseDoFragment, mTelString, mVCodeTypeString) {
			
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				
			}
		};
//		mCodeSmsInterface = new SendVCodeSmsInterface(mBaseDoFragment.mActivity, mTelString, mVCodeTypeString) {
//			
//			@Override
//			public void SuccCallBack(JSONObject responseJson) {
//				// TODO Auto-generated method stub
//				mDialog = CommonLoginFragment.showAlertDialog(mBaseDoFragment.mActivity, "验证码已发送，请注意查收", "", "确定", null, new OnClickListener() {
//
//					@Override
//					public void onClick(View v) {
//						// TODO Auto-generated method stub
//						mDialog.dismiss();
//					}
//				}, false, null);
//				beginCountDown();
//				SuccRequestVCode();
//			}
//			
//			@Override
//			public void FailRequest() {
//				// TODO Auto-generated method stub
//				mButton.setEnabled(true);
//				mButton.setText(R.string.acco_regist_get_verify_code_again);
//				mButton.setBackgroundResource(R.drawable.qianseit_bg_vcode_click);
//				mButton.setTextColor(mBaseDoFragment.mActivity.getResources().getColor(R.color.westore_primary_textcolor));
//				FailRequestVCode();
//			}
//		};
	}

	void beginCountDown(){
		mButton.setEnabled(true);
		countdown_time = 60;
		Message nMessage = new Message();
		nMessage.what = MSG_COUNTDOWN;
		mHandler.sendMessage(nMessage);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.btn_get_vcode) {
			requestVCode();
		}
	}
	
	public void requestVCode(){
		if (mCodeSmsInterface != null) {
			mButton.setEnabled(false);
			StartRequestVCode();
			mCodeSmsInterface.RunRequest();
		}
	}

	@SuppressLint("HandlerLeak")
	private Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			// 倒计时结束
			if (--countdown_time <= 0) {
				mButton.setEnabled(true);
				mButton.setText(R.string.acco_regist_get_verify_code_again);
				mButton.setBackgroundResource(R.drawable.qianseit_bg_vcode_click);
				mButton.setTextColor(mBaseDoFragment.mActivity.getResources().getColor(R.color.westore_primary_textcolor));
				return;
			} else {
				mButton.setEnabled(false);
				mButton.setBackgroundResource(R.drawable.bg_verify_code);
				mButton.setTextColor(mBaseDoFragment.mActivity.getResources().getColor(R.color.default_page_bgcolor_3));
			}

			mButton.setText(mBaseDoFragment.mActivity.getString(R.string.acco_forget_password_step2_countdown, countdown_time));

			Message nMessage = new Message();
			nMessage.what = MSG_COUNTDOWN;
			mHandler.sendMessageDelayed(nMessage, 1000);
		}
	};
	
	public void SuccRequestVCode(){
		
	}
	public void FailRequestVCode(){
		
	}
	public void StartRequestVCode(){
		
	}
}