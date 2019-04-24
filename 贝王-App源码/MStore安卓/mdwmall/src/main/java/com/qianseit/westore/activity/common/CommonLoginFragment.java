package com.qianseit.westore.activity.common;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.support.v4.app.FragmentActivity;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.method.PasswordTransformationMethod;
import android.text.method.SingleLineTransformationMethod;
import android.text.method.TransformationMethod;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.acco.PasswordVerfiyHandler;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.bean.ThridLoginTrustBean;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.passport.LoginInfoInterface;
import com.qianseit.westore.httpinterface.passport.LoginInterface;
import com.qianseit.westore.httpinterface.passport.LogoutInterface;
import com.qianseit.westore.httpinterface.passport.ThirdUserLoginInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

public class CommonLoginFragment extends BaseDoFragment implements TextWatcher {

	public final static int REQUEST_BIND_MOBILE = 0x01;
	public final static int HIDE_LOADING_FORTHRID_DIALOG = 0x02;

	public final static String LOGIN_SINA = "LOGIN_SINA";
	public final static String LOGIN_SINA_DATA = "LOGIN_SINA_DATA";
	public final static String LOGIN_FROM_HOME = "LOGIN_FROM_HOME";

	private final String PLATFORM_WEIBO = "sina";
	private final String PLATFORM_WECHAT = "weixin";
	private final String PLATFORM_QQ = "qq";
	private final int LOG_REG = 0x1001;

	//未登录界面的视图
	private LinearLayout mUnLoginLinearLayout;
	private EditText mVerifyCodeText;
	private ImageView mVerifyCodeImageView;
	private EditText mUserNameText, mPasswdText;
	private Button mLoginSubmitButton;
	private View mLoginByQQ, mLoginByWechat;
	private View mLoginByAlipay, mLoginByWeibo;
	private CheckBox mVisiblePasswordBox;

	///社交账号登录标题视图
	private View mSocialLoginLayout;
	///社交账号登录视图
	private LinearLayout mSocailLinearLayout;

	private String sinaOpenId;
	private String sinaToken;
	private ThridLoginTrustBean mThridLoginTrustBean;
	private static FragmentActivity mFactivity;
	boolean mLoginFromHome = true;
	private Dialog dialog;

	boolean isWeibo = false;

	private ImageView mDelUserNameImageView;

	/**
	 * "data": { "show_varycode": 1, 0:不需要验证码|1：需要验证码 "loginName": null,
	 * "code_url": "http://zj.qianseit.com/index.php/index-gen_vcode-b2c.html",
	 * "remember": "true" }
	 */
	JSONObject mLoginInfoJsonObject;
	LoginInfoInterface mLoginInfoInterface = new LoginInfoInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mLoginInfoJsonObject = responseJson;
			parseLoginInfo();
		}

		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			
			super.task_response(json_str);
		}
	};
	LoginInterface mLoginInterface = new LoginInterface(this) {

		/*
		 * (non-Javadoc) { "member_id": "32657" }
		 * 
		 * @see
		 * com.qianseit.westore.httpinterface.InterfaceHandler#SuccCallBack(
		 * org.json.JSONObject)
		 */
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			new MemberIndexInterface(CommonLoginFragment.this) {

				@Override
				public void responseSucc() {
					// TODO Auto-generated method stub
					try {

						// 保存用户名，密码
						Run.savePrefs(mActivity, Run.pk_logined_username, mUserNameText.getText().toString());
						Run.savePrefs(mActivity, Run.pk_logined_user_password, mPasswdText.getText().toString());

						userLoginSuccess(false);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}.RunRequest();
		}

		@Override
		public void FailRequest() {
			if (mErrorJsonObject == null) {
				return;
			}
			String nCode = mErrorJsonObject.optString("code");
			if (nCode != null && nCode.equals("login_needVcode_error")) {
				JSONObject nDataJsonObject = mErrorJsonObject.optJSONObject("data");
				if (nDataJsonObject != null) {
					if (mLoginInfoJsonObject == null) {
						mLoginInfoJsonObject = new JSONObject();
					}
					try {
						mLoginInfoJsonObject.put("show_varycode", nDataJsonObject.optInt("needVcode"));
						mLoginInfoJsonObject.put("code_url", nDataJsonObject.optString("code_url"));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					parseLoginInfo();
				}
			}
		}
	};
	ThirdUserLoginInterface mThirdUserLoginInterface = new ThirdUserLoginInterface(this) {

		@Override
		public void loginSuccessWeibo(String weiboId, String weboToken) {
			// TODO Auto-generated method stub
			mThridLoginTrustBean = getThridLoginTrustBean();
			sinaOpenId = weiboId;
			sinaToken = weboToken;
			afterThirdLogin(true, isBindMobile());
		}

		@Override
		public void loginSuccessOther() {
			// TODO Auto-generated method stub
			mThridLoginTrustBean = getThridLoginTrustBean();
			afterThirdLogin(false, isBindMobile());
		}
	};


	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// mImageLoader = ImageLoader.getInstance(mActivity);
		Bundle b = getArguments();
		mFactivity = mActivity;
		if (b != null) {
			mLoginFromHome = b.getBoolean(LOGIN_FROM_HOME, true);
		}
	}

	void afterThirdLogin(boolean isWeibo, boolean isBindMobile) {
		this.isWeibo = isWeibo;
		// TODO Auto-generated method stub
		if (!isBindMobile) {
			// 先绑定手机号
			Bundle nBundle = new Bundle();
			nBundle.putSerializable(Run.EXTRA_DATA, mThridLoginTrustBean);
			startActivityForResult(AgentActivity.FRAGMENT_ACCO_BIND_MOBILE_THRID, nBundle, REQUEST_BIND_MOBILE);
			return;
		}

		new MemberIndexInterface(CommonLoginFragment.this) {

			@Override
			public void responseSucc() {
				// TODO Auto-generated method stub
				try {
					// 保存用户名，密码
					Run.savePrefs(mActivity, Run.pk_logined_username, "");
					Run.savePrefs(mActivity, Run.pk_logined_user_password, "");

					Run.savePrefs(mActivity, Run.pk_third_platform, mThridLoginTrustBean.getSource());
					userLoginSuccess(CommonLoginFragment.this.isWeibo);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}.RunRequest();
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// mActionBar.setTitle(R.string.acco_login_title);
		// mActionBar.getBackButton().setVisibility(View.INVISIBLE);
		mActionBar.setShowTitleBar(true);
		mActionBar.setTitle("登录");

		rootView = inflater.inflate(R.layout.fragment_account_login, null);
		rootView.setPadding(69, 80, 69, 0);
		rootView.setVisibility(View.INVISIBLE);
		mUserNameText = (EditText) findViewById(R.id.acco_login_username);
		mPasswdText = (EditText) findViewById(R.id.acco_login_password);
		mVerifyCodeText = (EditText) findViewById(R.id.acco_login_vcode_text);
		
		mPasswdText.addTextChangedListener(this);
		mVerifyCodeText.addTextChangedListener(this);
		
		mVerifyCodeImageView = (ImageView) findViewById(R.id.acco_login_vcode_image);
		mLoginSubmitButton = (Button) findViewById(R.id.acco_login_submit_button);
		findViewById(R.id.acco_login_forget_passwd).setOnClickListener(this);
		findViewById(R.id.acco_login_forget_regist).setOnClickListener(this);
		mLoginSubmitButton.setOnClickListener(this);
		mVerifyCodeImageView.setOnClickListener(this);
		mVisiblePasswordBox = (CheckBox) findViewById(R.id.acco_login_password_visible);
		mVisiblePasswordBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				TransformationMethod method = isChecked ? SingleLineTransformationMethod.getInstance() : PasswordTransformationMethod.getInstance();
				mPasswdText.setTransformationMethod(method);
				mPasswdText.setSelection(mPasswdText.getText().length());
				mPasswdText.postInvalidate();
			}
		});

		mDelUserNameImageView = (ImageView) findViewById(R.id.acco_login_username_delete_iv);
		mDelUserNameImageView.setOnClickListener(this);
		mUserNameText.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				// TODO 自动生成的方法存根

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO 自动生成的方法存根

			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO 自动生成的方法存根
				if (s.length() > 0) {
					mDelUserNameImageView.setVisibility(View.VISIBLE);
				} else {
					mDelUserNameImageView.setVisibility(View.INVISIBLE);
				}
				mLoginSubmitButton.setEnabled(checkCanLogin());
			}
		});

		mLoginInfoInterface.RunRequest();

		autoFillAccountInfo();

		// 第三方登录按钮
		mLoginByQQ = findViewById(R.id.acco_login_user_qq);
		mLoginByWechat = findViewById(R.id.acco_login_user_wechat);
		mLoginByWeibo = findViewById(R.id.acco_login_user_weibo);
		mLoginByAlipay = findViewById(R.id.acco_login_user_weibo);
		mSocialLoginLayout = findViewById(R.id.social_title_layout);
		mSocailLinearLayout = (LinearLayout) findViewById(R.id.social_linear_layout);
		mUnLoginLinearLayout = (LinearLayout) findViewById(R.id.unlogin_layout);

		mLoginByQQ.setOnClickListener(this);
		mLoginByWechat.setOnClickListener(this);
		mLoginByWeibo.setOnClickListener(this);
		mLoginByAlipay.setOnClickListener(this);
	}

	void parseLoginInfo() {
		if (mLoginInfoJsonObject == null) {
			return;
		}

		boolean nNeedVCode = needVCode();
		findViewById(R.id.acco_login_vcode).setVisibility(nNeedVCode ? View.VISIBLE : View.GONE);
		if (nNeedVCode) {
			reloadVcodeImage();
		}

		///判断是否有第三方登录
		JSONArray jsonArray = mLoginInfoJsonObject.optJSONArray("login_image_url");
		if(jsonArray != null && jsonArray.length() > 0){
			for(int i = 0;i < jsonArray.length();i ++){
				JSONObject object = jsonArray.optJSONObject(i);
				String name = object.optString("name");
				if(name == null)
					continue;

				if(name.equals("qq")){
					mLoginByQQ.setVisibility(View.VISIBLE);
				}else if(name.equals("weixin")){
					mLoginByWechat.setVisibility(View.VISIBLE);
				}
			}
		}

		if(mLoginByQQ.getVisibility() == View.VISIBLE || mLoginByWechat.getVisibility() == View.VISIBLE){
			mSocialLoginLayout.setVisibility(View.VISIBLE);
		}
//		mSocialLoginLayout.setVisibility(View.);
	}

	boolean needVCode() {
		return mLoginInfoJsonObject != null && mLoginInfoJsonObject.optInt("show_varycode", 0) == 1;
	}

	@Override
	public void onClick(View v) {
		if (R.id.acco_login_forget_regist == v.getId()) {
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PASSPORT_REGISTR), LOG_REG);
		} else if (R.id.acco_login_forget_passwd == v.getId()) {
			mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_PW));
		} else if (mLoginSubmitButton == v) {
			AccountLogin();
		} else if (mLoginByQQ == v) {
			Platform platQQ = ShareSDK.getPlatform(mActivity, QQ.NAME);
			platQQ.setPlatformActionListener(new ThirdLoginListener(PLATFORM_QQ));
			platQQ.SSOSetting(false);// 设置为false或者不设置这个值，如果设置为 true 则调用客户端
			platQQ.removeAccount(true);
			platQQ.showUser(null);
			showLoadingDialog();
			mHandler.sendEmptyMessageDelayed(HIDE_LOADING_FORTHRID_DIALOG, 10000);
		} else if (mLoginByWeibo == v) {
			Platform platWB = ShareSDK.getPlatform(mActivity, SinaWeibo.NAME);
			platWB.setPlatformActionListener(new ThirdLoginListener(PLATFORM_WEIBO));
			platWB.SSOSetting(false);// 设置为false或者不设置这个值，如果设置为 true 则调用客户端
			platWB.removeAccount(true);
			platWB.showUser(null);
			showLoadingDialog();
			mHandler.sendEmptyMessageDelayed(HIDE_LOADING_FORTHRID_DIALOG, 10000);
		} else if (mVerifyCodeImageView == v) {
			reloadVcodeImage();
		} else if (mLoginByWechat == v) {
			Platform platWX = ShareSDK.getPlatform(mActivity, Wechat.NAME);
			platWX.setPlatformActionListener(new ThirdLoginListener(PLATFORM_WECHAT));
			platWX.SSOSetting(false);
			platWX.removeAccount(true);
			platWX.showUser(null);
			showLoadingDialog();
			mHandler.sendEmptyMessageDelayed(HIDE_LOADING_FORTHRID_DIALOG, 10000);
		} else if (mDelUserNameImageView == v) {
			mUserNameText.setText("");
			mUserNameText.requestFocus();
		} else {
			super.onClick(v);
		}
	}

	@Override
	public void ui(int what, Message msg) {
		// TODO Auto-generated method stub
		if (what == HIDE_LOADING_FORTHRID_DIALOG) {
			hideLoadingDialog_mt();
			Run.alert(mActivity, "请求超时");
			return;
		}
		super.ui(what, msg);
	}
	
	public static Dialog showVerfiyPasswordDialog(final Context c, final PasswordVerfiyHandler handler) {
		final Dialog dialog = new Dialog(c, R.style.Theme_dialog);
		View view = null;
		try {

			view = LayoutInflater.from(c).inflate(R.layout.custom_password_verfiy_view, null);
			final EditText nPasswordEditText = (EditText) view.findViewById(R.id.password_text2);
			nPasswordEditText.requestFocus();
			nPasswordEditText.addTextChangedListener(new TextWatcher() {

				@Override
				public void onTextChanged(CharSequence s, int start, int before, int count) {
					// TODO 自动生成的方法存根

				}

				@Override
				public void beforeTextChanged(CharSequence s, int start, int count, int after) {
					// TODO 自动生成的方法存根

				}

				@Override
				public void afterTextChanged(Editable s) {
					// TODO 自动生成的方法存根
					if (nPasswordEditText.getText().length() == 6) {

					}
				}
			});

			TextView cancel = (TextView) view.findViewById(R.id.dialog_cancel_top_tv);
			cancel.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					if (handler != null) {
						handler.result_fail("");
					}
					dialog.dismiss();
				}
			});

			Button cancelBtn = (Button) view.findViewById(R.id.dialog_cancel_btn);
			cancelBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					if (handler != null) {
						handler.result_fail("");
					}
					dialog.dismiss();
				}
			});

			Button okBtn = (Button) view.findViewById(R.id.dialog_conform_btn);
			okBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {

					// Run.excuteJsonTask(new JsonTask(), new
					// UserLoginTask(null, Run.loadOptionString(c,
					// Run.pk_logined_username, Run.EMPTY_STR),
					// nPasswordEditText.getText().toString(), "",
					// new JsonRequestCallback() {
					// @Override
					// public void task_response(String jsonStr) {
					// try {
					// JSONObject all = new JSONObject(jsonStr);
					// if (Run.checkRequestJson(c, all, false)) {
					// if (handler != null) {
					// handler.result_success(jsonStr);
					// }
					// dialog.dismiss();
					// } else {
					// JSONObject data = all.optJSONObject("data");
					// showAlertDialog(c, data.optString("msg"), "取消", "前往商城",
					// null, new OnClickListener() {
					//
					// @Override
					// public void onClick(View v) {
					// Uri uri = Uri.parse(Run.DOMAIN + "/index.php/wap");
					// Intent it = new Intent(Intent.ACTION_VIEW, uri);
					// mFactivity.startActivity(it);
					// }
					// }, false, null);
					// }
					// } catch (Exception e) {
					// e.printStackTrace();
					// }
					// }
					// }));
				}
			});
		} catch (Exception e) {
			// TODO: handle exception
			Log.w(Run.TAG, e.getMessage());
		}

		dialog.setContentView(view);
		dialog.setCanceledOnTouchOutside(false);
		dialog.show();
		return dialog;
	}

	public static Dialog showInputDialog(final Context c, String titleString, final InputHandler handler) {
		return showInputDialog(c, titleString, "", "", "", "", "", handler);
	}

	public static Dialog showInputDialog(final Context c, String titleString, String hint, String okTitle, String okTextColor, String cancelTitle, String cancelTextColor, final InputHandler handler) {
		final Dialog dialog = new Dialog(c, R.style.Theme_dialog);
		View view = null;
		try {
			view = LayoutInflater.from(c).inflate(R.layout.custom_input_dialog_view, null);

			dialog.setCanceledOnTouchOutside(true);
			if (titleString != null && !TextUtils.isEmpty(titleString)) {
				((TextView) view.findViewById(R.id.dialog_title)).setText(titleString);
			}

			final EditText nEditText = (EditText) view.findViewById(R.id.input_et);
			nEditText.setHint(hint);
			nEditText.requestFocus();
			com.qianseit.westore.util.Util.openSoftInputMethod(c, nEditText);

			TextView cancel = (TextView) view.findViewById(R.id.dialog_cancel_top_tv);
			cancel.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});

			Button cancelBtn = (Button) view.findViewById(R.id.dialog_cancel_btn);
			if (!TextUtils.isEmpty(cancelTitle)) {
				cancelBtn.setText(cancelTitle);
			}
			if (!TextUtils.isEmpty(cancelTextColor)) {
				cancelBtn.setTextColor(Color.parseColor(cancelTextColor));
			}
			cancelBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});

			Button okBtn = (Button) view.findViewById(R.id.dialog_conform_btn);
			if (!TextUtils.isEmpty(okTitle)) {
				okBtn.setText(okTitle);
			}
			if (!TextUtils.isEmpty(okTextColor)) {
				okBtn.setTextColor(Color.parseColor(okTextColor));
			}
			okBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					if (TextUtils.isEmpty(nEditText.getText().toString())) {
						return;
					}
					if (handler != null) {
						handler.onOk(nEditText.getText().toString());
					}
					dialog.dismiss();
				}
			});
		} catch (Exception e) {
			// TODO: handle exception
			Log.w(Run.TAG, e.getMessage());
		}

		dialog.setContentView(view);
		dialog.setCanceledOnTouchOutside(false);
		dialog.show();
		return dialog;
	}

	public static Dialog showInputBankNumDialog(final Context c, String hintString, final InputHandler handler) {
		final Dialog dialog = new Dialog(c, R.style.main_dialog);
		Window dialogWindow = dialog.getWindow();
		WindowManager.LayoutParams lp = dialogWindow.getAttributes();
		DisplayMetrics d = c.getResources().getDisplayMetrics(); // 获取屏幕宽、高用
		lp.width = d.widthPixels;
		dialogWindow.setAttributes(lp);
		LinearLayout view = null;
		try {
			view = (LinearLayout) LayoutInflater.from(c).inflate(R.layout.custom_input_banknum_dialog_view, null);
			view.setGravity(Gravity.CENTER);
			final EditText nEditText = (EditText) view.findViewById(R.id.input_et);
			final EditText nPwdEditText = (EditText) view.findViewById(R.id.input_pwd_et);
			if (!TextUtils.isEmpty(hintString)) {
				nEditText.setHint(hintString);
			}

			nEditText.requestFocus();
			com.qianseit.westore.util.Util.openSoftInputMethod(c, nEditText);

			Button okBtn = (Button) view.findViewById(R.id.dialog_conform_btn);
			Button calcelBtn = (Button) view.findViewById(R.id.dialog_conform_calcel);
			calcelBtn.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});
			okBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					String nInputString = nEditText.getText().toString();
					if (TextUtils.isEmpty(nInputString)) {
						Run.alert(c, "请输入储蓄卡号");
						nEditText.requestFocus();
						return;
					}
					if (nInputString.length() < 19) {
						Run.alert(c, "储蓄卡号长度为19位");
						nEditText.requestFocus();
						return;
					}

					if (nPwdEditText.getText().length() < 6) {
						Run.alert(c, "请输入6位卡密码");
						nPwdEditText.requestFocus();
						return;
					}

					if (handler != null) {
						if (!handler.verify(nInputString)) {
							return;
						}

						handler.onOk(nInputString + "," + nPwdEditText.getText().toString());
					}
					dialog.dismiss();
				}
			});
		} catch (Exception e) {
			// TODO: handle exception
			Log.w(Run.TAG, e.getMessage());
		}

		dialog.setContentView(view);
		dialog.setCanceledOnTouchOutside(true);
		dialog.show();
		return dialog;
	}

	@Override
	public void onResume() {
		super.onResume();

//		LinearLayout.LayoutParams nUnLogInLayoutParams = (LinearLayout.LayoutParams) mUnLoginLinearLayout.getLayoutParams();
//		LinearLayout.LayoutParams nLayoutParams = (LinearLayout.LayoutParams) mSocailLinearLayout.getLayoutParams();
//		nLayoutParams.topMargin = Run.getScreenSize(mActivity.getWindowManager()).y - nUnLogInLayoutParams.height;
//		mSocailLinearLayout.setLayoutParams(nLayoutParams);

//		int screenHeight = Run.getScreenSize(mActivity.getWindowManager()).y;
//
//		TranslateAnimation wechatAnimation = new TranslateAnimation(0.0f,0.0f,0,screenHeight - 100);
//
//		wechatAnimation.setDuration(3000);
//
//		wechatAnimation.setRepeatCount(1);
//
//		mSocailLinearLayout.setAnimation(wechatAnimation);
//
//		mSocailLinearLayout.startAnimation(wechatAnimation);
	}

	@Override
	public void onPause() {
		super.onPause();
	}
	
	@Override
	public void onStop() {
		// TODO Auto-generated method stub
		hideLoadingDialog_mt();
		mHandler.removeMessages(HIDE_LOADING_FORTHRID_DIALOG);
		super.onStop();
	}

	/*
	 * (非 Javadoc) <p>Title: onDestroyView</p> <p>Description: </p>
	 * 
	 * @see android.support.v4.app.Fragment#onDestroyView()
	 */
	@Override
	public void onDestroyView() {
		// TODO 自动生成的方法存根
		super.onDestroyView();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			// 点击Back键提示退出程序
			this.mActivity.finish();
		}
		return super.onKeyDown(keyCode, event);
	}

	/*
	 * (非 Javadoc) <p>Title: onDetach</p> <p>Description: </p>
	 * 
	 * @see android.support.v4.app.Fragment#onDetach()
	 */
	@Override
	public void onDetach() {
		// TODO 自动生成的方法存根
		super.onDetach();
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_USER_REGIST && resultCode == Activity.RESULT_OK) {
			autoFillAccountInfo();
			onClick(mLoginSubmitButton);
		} else if (requestCode == LOG_REG && resultCode == Activity.RESULT_OK) {
			mActivity.finish();
		} else if (requestCode == REQUEST_BIND_MOBILE) {
			if (resultCode == Activity.RESULT_OK) {
				new MemberIndexInterface(this) {

					@Override
					public void responseSucc() {
						// TODO Auto-generated method stub
						try {
							userLoginSuccess(CommonLoginFragment.this.isWeibo);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}.RunRequest();

				// 保存用户名，密码
				Run.savePrefs(mActivity, Run.pk_logined_username, data.getStringExtra(Run.EXTRA_DATA));
				Run.savePrefs(mActivity, Run.pk_logined_user_password, data.getStringExtra(Run.EXTRA_VALUE));

			} else {
				new LogoutInterface(CommonLoginFragment.this) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub

					}
				}.RunRequest();
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	// 恢复登录用户名和密码
	private void autoFillAccountInfo() {
		if (!TextUtils.isEmpty(Run.loadOptionString(mActivity, Run.pk_logined_username, Run.EMPTY_STR))) {
			mUserNameText.setText(Run.loadOptionString(mActivity, Run.pk_logined_username, Run.EMPTY_STR));
		} else {
			mPasswdText.setText("");
			return;
		}

		if (!TextUtils.isEmpty(Run.loadOptionString(mActivity, Run.pk_logined_user_password, Run.EMPTY_STR)))
			mPasswdText.setText(Run.loadOptionString(mActivity, Run.pk_logined_user_password, Run.EMPTY_STR));
	}

	private void AccountLogin() {
		String username = mUserNameText.getText().toString();
		if (TextUtils.isEmpty(username)) {
			Run.alert(mActivity, "请输入用户号");
			mUserNameText.setFocusable(true);
			mUserNameText.requestFocus();
		} else if (TextUtils.isEmpty(mPasswdText.getText().toString())) {
			Run.alert(mActivity, "请输入密码");
			mPasswdText.setFocusable(true);
			mPasswdText.requestFocus();
		} else if (needVCode() && TextUtils.isEmpty(mVerifyCodeText.getText().toString())) {
			Run.alert(mFactivity, "请输入验证码");
			mVerifyCodeText.requestFocus();
		} else {
			Run.hideSoftInputMethod(mActivity, mUserNameText);
			Run.hideSoftInputMethod(mActivity, mPasswdText);
			Run.hideSoftInputMethod(mActivity, mVerifyCodeText);
			mLoginInterface.setLoginInfo(mUserNameText.getText().toString(), mPasswdText.getText().toString(), needVCode() ? mVerifyCodeText.getText().toString() : null);
			mLoginInterface.RunRequest();
		}
	}

	public static Dialog showAlertDialog(Context c, String message, String subMessage, String confirmText, View.OnClickListener okListener) {
		return showAlertDialog(c, message, subMessage, "", confirmText, null, okListener, false, null);
	}

	public static Dialog showAlertDialog(Context c, String message) {
		return showAlertDialog(c, message, "", "", "确定", null, null, false, null);
	}

	public static Dialog showAlertDialog(Context c, String message, String confirmText, View.OnClickListener okListener) {
		return showAlertDialog(c, message, "", "", confirmText, null, okListener, false, null);
	}

	public static Dialog showAlertDialog(Context c, String message, String cancelText, String confirmText, View.OnClickListener cancelListener, View.OnClickListener okListener) {
		return showAlertDialog(c, message, "", cancelText, confirmText, cancelListener, okListener, false, null);
	}

	public static Dialog showAlertDialog(Context c, String message, String subMessage, String cancelText, String confirmText, View.OnClickListener cancelListener, View.OnClickListener okListener) {
		return showAlertDialog(c, message, subMessage, cancelText, confirmText, cancelListener, okListener, false, null);
	}

	public static Dialog showAlertDialog(Context c, String message, String cancelText, String confirmText, View.OnClickListener cancelListener, View.OnClickListener okListener, boolean isShowGender,
			View.OnClickListener genderListener) {
		return showAlertDialog(c, message, "", cancelText, confirmText, cancelListener, okListener, isShowGender, genderListener);
	}

	public static Dialog showAlertDialog(Context c, String message, String subMessage, String cancelText, String confirmText, View.OnClickListener cancelListener, View.OnClickListener okListener,
			boolean isShowGender, View.OnClickListener genderListener) {
		final Dialog dialog = new Dialog(c, R.style.Theme_dialog);
		View view = LayoutInflater.from(c).inflate(R.layout.cunstom_dialog_view, null);

		((TextView) view.findViewById(R.id.dialog_message)).setText(message);
		((TextView) view.findViewById(R.id.dialog_message_sub)).setText(subMessage);
		view.findViewById(R.id.dialog_message_sub).setVisibility(TextUtils.isEmpty(subMessage) ? View.GONE : View.VISIBLE);

		TextView cancel = (TextView) view.findViewById(R.id.dialog_cancel_btn);
		if (!TextUtils.isEmpty(cancelText)) {
			cancel.setVisibility(View.VISIBLE);
			cancel.setText(cancelText);
		}
		if (cancelListener != null) {// 自定义点击事件
			cancel.setOnClickListener(cancelListener);
		} else {
			cancel.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});
		}
		TextView okBtn = (TextView) view.findViewById(R.id.dialog_conform_btn);
		if (isShowGender) {
			okBtn.setVisibility(View.GONE);
			if (genderListener != null) {
				view.findViewById(R.id.dialog_cancel_gender).setVisibility(View.VISIBLE);
				view.findViewById(R.id.dialog_gender1).setOnClickListener(genderListener);
				view.findViewById(R.id.dialog_gender2).setOnClickListener(genderListener);
				view.findViewById(R.id.dialog_gender3).setOnClickListener(genderListener);
			}
		} else {
			if (!TextUtils.isEmpty(confirmText)) {
				okBtn.setVisibility(View.VISIBLE);
				okBtn.setText(confirmText);
			}
			if (okListener != null) {// 自定义点击事件
				okBtn.setOnClickListener(okListener);
			} else {
				okBtn.setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						dialog.dismiss();
					}
				});
			}
		}
		if (okBtn.getVisibility() == View.VISIBLE && cancel.getVisibility() == View.VISIBLE) {
			view.findViewById(R.id.dialog_line).setVisibility(View.VISIBLE);
		}
		dialog.setContentView(view);
		dialog.setCanceledOnTouchOutside(true);
		dialog.show();
		return dialog;
	}

	public static Dialog showAlertDialog(Context c, String message, int cancelText, int confirmText, View.OnClickListener cancelListener, View.OnClickListener okListener, boolean isShowGender,
			View.OnClickListener genderListener) {
		final Dialog dialog = new Dialog(c, R.style.Theme_dialog);
		View view = LayoutInflater.from(c).inflate(R.layout.cunstom_dialog_view, null);
		((TextView) view.findViewById(R.id.dialog_message)).setText(message);
		TextView cancel = (TextView) view.findViewById(R.id.dialog_cancel_btn);
		if (-1 != cancelText) {
			cancel.setVisibility(View.VISIBLE);
			cancel.setText(cancelText);
		}
		if (cancelListener != null) {// 自定义点击事件
			cancel.setOnClickListener(cancelListener);
		} else {
			cancel.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});
		}
		TextView okBtn = (TextView) view.findViewById(R.id.dialog_conform_btn);
		if (isShowGender) {
			okBtn.setVisibility(View.GONE);
			if (genderListener != null) {
				view.findViewById(R.id.dialog_cancel_gender).setVisibility(View.VISIBLE);
				view.findViewById(R.id.dialog_gender1).setOnClickListener(genderListener);
				view.findViewById(R.id.dialog_gender2).setOnClickListener(genderListener);
				view.findViewById(R.id.dialog_gender3).setOnClickListener(genderListener);
			}
		} else {
			if (-1 != confirmText) {
				okBtn.setVisibility(View.VISIBLE);
				okBtn.setText(confirmText);
			}
			if (okListener != null) {// 自定义点击事件
				okBtn.setOnClickListener(okListener);
			} else {
				okBtn.setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						dialog.dismiss();
					}
				});
			}
		}
		if (okBtn.getVisibility() == View.VISIBLE && cancel.getVisibility() == View.VISIBLE) {
			view.findViewById(R.id.dialog_line).setVisibility(View.VISIBLE);
		}
		dialog.setContentView(view);
		dialog.setCanceledOnTouchOutside(true);
		dialog.show();
		return dialog;
	}

	/**
	 * 用户登录成功
	 * 
	 * @param isWeboLogin
	 */
	private void userLoginSuccess(boolean isWeboLogin) throws Exception {
		IntentFilter home_dynamic_filter = new IntentFilter();
		home_dynamic_filter.addAction(CommonHomeFragment.HOMEREFASH); // 添加动态广播的Action
		CommonHomeFragment.BroadcastReceiverHelper homeDynamicReceiver = new CommonHomeFragment.BroadcastReceiverHelper();
		mActivity.registerReceiver(homeDynamicReceiver, home_dynamic_filter);
		Intent homeIntent = new Intent();
		homeIntent.setAction(CommonHomeFragment.HOMEREFASH); // 发送广播
		mActivity.sendBroadcast(homeIntent);
		Run.savePrefs(mActivity, LOGIN_SINA, isWeboLogin);
		if (isWeboLogin) {
			Run.savePrefs(mActivity, LOGIN_SINA_DATA, sinaOpenId + "&" + sinaToken);
		}

		if (!mLoginFromHome) {
			gotoHomePage();
		}

		// 登录成功
		mActivity.setResult(Activity.RESULT_OK);
		mActivity.unregisterReceiver(homeDynamicReceiver);
		mActivity.finish();
	}

	private void reloadVcodeImage() {
		String vcodeUrl = Run.buildString(mLoginInfoJsonObject.optString("code_url"), "?", System.currentTimeMillis());
		displayRectangleImage(mVerifyCodeImageView, vcodeUrl);
	}

	private class ThirdLoginListener implements PlatformActionListener {
		private String platformName;

		public ThirdLoginListener(String platName) {
			this.platformName = platName;
		}

		@Override
		public void onError(Platform arg0, int arg1, Throwable arg2) {
			System.out.println("-------" + arg2.getMessage() + "--------");
			arg2.printStackTrace();
			hideLoadingDialog_mt();
			mHandler.removeMessages(HIDE_LOADING_FORTHRID_DIALOG);
		}

		@Override
		public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
			hideLoadingDialog_mt();
			mHandler.removeMessages(HIDE_LOADING_FORTHRID_DIALOG);
			mThirdUserLoginInterface.Login(platformName, arg0, arg2);
		}

		@Override
		public void onCancel(Platform arg0, int arg1) {
			System.out.println("-------MSG_AUTH_CANCEL--------");
			Run.log("onCancel:", arg1);
			hideLoadingDialog_mt();
			mHandler.removeMessages(HIDE_LOADING_FORTHRID_DIALOG);
		}

	}

	private void gotoHomePage() {
		startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
		mActivity.finish();
	}

	public interface InputHandler {
		/**
		 * 
		 * @param inputString
		 *            输入字符串
		 */
		void onOk(String inputString);

		boolean verify(String inputString);
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
		mLoginSubmitButton.setEnabled(checkCanLogin());
	}

	private boolean checkCanLogin() {
		// TODO Auto-generated method stub
		if (mUserNameText.length() <= 0) {
			return false;
		} else if (mPasswdText.length() < 6 || mPasswdText.length() > 20) {
			return false;
		} else if (needVCode() && mVerifyCodeText.length() != 4) {
			return false;
		}
		return true;
	}
}
