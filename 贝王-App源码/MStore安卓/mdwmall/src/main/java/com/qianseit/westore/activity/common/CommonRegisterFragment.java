package com.qianseit.westore.activity.common;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.passport.ItemSettingGenderView;
import com.qianseit.westore.activity.passport.ItemSettingHandler;
import com.qianseit.westore.activity.passport.ItemSettingItemView;
import com.qianseit.westore.activity.passport.ItemSettingTextView;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.passport.DIYRegisterItemsInterface;
import com.qianseit.westore.httpinterface.passport.LoginInterface;
import com.qianseit.westore.httpinterface.passport.LogoutInterface;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface.Gender;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.qianseit.westore.ui.MyAlertDialog;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class CommonRegisterFragment extends BaseDoFragment implements TextWatcher {
	final int PICKER_AREA_REQUEST = 100;
	final int PICKER_SINGLE_REQUEST = 101;
	final int PICKER_MULTI_REQUEST = 102;
	private final int HINT_REG = 0x100;
	private EditText mEtPhoto;
	private EditText mEtCode;
	private EditText mEtPassword;
	EditText mImageVCodeEditText;
	ImageView mImageVCodeImageView;
	Button mCommitButton;

	CheckBox mCheckBox;

	private Button mCodeBut;
	LinearLayout mRegisterItemsLayout;

	private int recLen = 120;
	Timer timer = new Timer();
	TimerTask timeTask;
	private Dialog dialog;

	JSONObject mDIYItemsJsonObject;
	List<ItemSettingHandler> mHandlers = new ArrayList<ItemSettingHandler>();
	Map<Integer, JSONObject> mDIYItemMap = new HashMap<Integer, JSONObject>();
	ItemSettingHandler mCurHandler;

	boolean mUseImageVCode = false;

	List<String> mList;

	RegistrMemberInterface mRegistrMemberInterface = new RegistrMemberInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mLoginInterface.setLoginInfo(mEtCode.getText().toString(), mEtPassword.getText().toString(), "");
			mLoginInterface.RunRequest();
		}

		@Override
		public void FailRequest() {
		}

		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			nContentValues.put("pam_account[login_name]", mEtPhoto.getText().toString());
			nContentValues.put("pam_account[login_password]", mEtPassword.getText().toString());
			nContentValues.put("vcode", mEtCode.getText().toString());
			nContentValues.put("license", "on");
			nContentValues.put("pam_account[psw_confirm]", mEtPassword.getText().toString());
			nContentValues.put("source","Android");

			for (ItemSettingHandler itemSettingHandler : mHandlers) {
				JSONObject nJsonObject = mDIYItemMap.get(itemSettingHandler.hashCode());
				String nItemType = nJsonObject.optString("attr_type");
				if (nItemType.equalsIgnoreCase("checkbox")) {// 多选
					if (mList == null) {
						continue;
					}
					int i = 0;
					for (String string : mList) {
						nContentValues.put(String.format("box:%s[%d]", nJsonObject.optString("attr_column"), i), string);
						i++;
					}
				} else {
					nContentValues.put(nJsonObject.optString("attr_column"), itemSettingHandler.getSettingValue());
				}
			}
			return nContentValues;
		}
	};

	SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (timer != null) {
				timer.cancel();
				timer = null;
			}
			if (timeTask != null) {
				timeTask = null;
			}
			recLen = 120;
			timer = new Timer();
			timeTask = GetTimerTask();
			timer.schedule(timeTask, 0, 1000);
			mCodeBut.setText(String.valueOf(recLen));
			mCodeBut.setBackgroundResource(R.drawable.bg_verify_code);
			mCodeBut.setTextColor(Color.parseColor("#ed6655"));
		}

		@Override
		public void FailRequest() {
			mCodeBut.setEnabled(true);
			reloadVcodeImage();
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
			new MemberIndexInterface(CommonRegisterFragment.this) {

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

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	private TimerTask GetTimerTask() {
		TimerTask task = new TimerTask() {

			@Override
			public void run() {
				mActivity.runOnUiThread(new Runnable() {
					@SuppressLint("ResourceAsColor")
					@Override
					public void run() {
						mCodeBut.setText("" + recLen);
						recLen--;
						if (recLen < 0) {
							mCodeBut.setBackgroundResource(R.drawable.app_button_selector);
							mCodeBut.setTextColor(Color.parseColor("#ffffff"));
							mCodeBut.setText("获取验证码");
							mCodeBut.setEnabled(true);
						}

					}
				});

			}
		};
		return task;
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mActionBar.setShowTitleBar(true);
		mActionBar.setTitle("注册");
		rootView = inflater.inflate(R.layout.fragment_register_main, null);
		rootView.setVisibility(View.INVISIBLE);
		rootView.setPadding(69, 80, 69, 0);
		mRegisterItemsLayout = (LinearLayout) findViewById(R.id.register_items_ll);

		mCommitButton = (Button) findViewById(R.id.register_commit);
		mCommitButton.setOnClickListener(this);
		mCodeBut = (Button) findViewById(R.id.register_code_but);
		findViewById(R.id.common_regist_agreement).setOnClickListener(this);
		mCodeBut.setOnClickListener(this);
		mEtPhoto = (EditText) findViewById(R.id.register_photo);
		mEtCode = (EditText) findViewById(R.id.register_code);
		mEtPassword = (EditText) findViewById(R.id.register_password);
		mEtPhoto.requestFocus();

		mImageVCodeEditText = (EditText) findViewById(R.id.register_vcode);
		mImageVCodeImageView = (ImageView) findViewById(R.id.register_vcode_ib);
		mImageVCodeImageView.setOnClickListener(this);

		mCheckBox = (CheckBox) findViewById(R.id.common_regist_status);

		mEtPhoto.addTextChangedListener(this);
		mEtCode.addTextChangedListener(this);
		mEtPassword.addTextChangedListener(this);
		mImageVCodeEditText.addTextChangedListener(this);
		mCheckBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				// TODO Auto-generated method stub
				mCommitButton.setEnabled(checkCanCommit());
			}
		});
		
		findViewById(R.id.common_regist_agreement).setOnClickListener(this);
		findViewById(R.id.common_regist_privacy).setOnClickListener(this);

		new DIYRegisterItemsInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mDIYItemsJsonObject = responseJson;

				new LogoutInterface(CommonRegisterFragment.this) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						LoginedUser.getInstance().setIsLogined(false);
						Run.savePrefs(mActivity, Run.pk_logined_user_password, "");
						Run.goodsCounts = 0;
					}
				}.RunRequest();
				mCommitButton.setEnabled(checkCanCommit());
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

	void parseDIYItems() {
		mUseImageVCode = mDIYItemsJsonObject.optBoolean("valideCode");
		if (mUseImageVCode) {
			findViewById(R.id.register_vcode_divider).setVisibility(View.VISIBLE);
			findViewById(R.id.register_vcode_tr).setVisibility(View.VISIBLE);
			reloadVcodeImage();
		} else {
			findViewById(R.id.register_vcode_divider).setVisibility(View.GONE);
			findViewById(R.id.register_vcode_tr).setVisibility(View.GONE);
		}

		JSONArray nArray = mDIYItemsJsonObject.optJSONArray("attr");
		if (nArray == null || nArray.length() <= 0) {
			return;
		}

		for (int i = 0; i < nArray.length(); i++) {
			addDIYItem(nArray.optJSONObject(i));
		}
	}

	/**
	 * { "attr_id":9, "attr_show":"true", "attr_edit":"false", "attr_order":8,
	 * "attr_name":"字符（测试）",
	 * "attr_type":"text",//region|text|gender|date|select|checkbox
	 * "attr_required":"false", "attr_search":"false", "attr_option":"",
	 * "attr_valtype":"alpha",//alpha|alphaint|number "attr_tyname":"仅限输入字符",
	 * "attr_group":"input", "attr_column":"chars", "attr_sdfpath":null,
	 * "attr_value":null }
	 * 
	 * @param jsonObject
	 */
	void addDIYItem(JSONObject jsonObject) {
		if (jsonObject == null) {
			return;
		}

		String nItemType = jsonObject.optString("attr_type");
		if (nItemType.equalsIgnoreCase("region")) {// 地区
			parseRegion(jsonObject);
		} else if (nItemType.equalsIgnoreCase("text")) {// 文本
			parseText(jsonObject);
		} else if (nItemType.equalsIgnoreCase("gender")) {// 性别
			parseGender(jsonObject);
		} else if (nItemType.equalsIgnoreCase("date")) {// 日期
			parseDate(jsonObject);
		} else if (nItemType.equalsIgnoreCase("select")) {// 单选
			parseSingle(jsonObject);
		} else if (nItemType.equalsIgnoreCase("checkbox")) {// 多选
			parseMulti(jsonObject);
		}
	}

	/**
	 * @param jsonObject
	 *            多选
	 */
	void parseMulti(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optBoolean("attr_required") ? "" : "选填") {
			@Override
			public boolean verifySettingValue(String t) {
				// TODO Auto-generated method stub
				if (jsonObject.optBoolean("attr_required")) {
					if (TextUtils.isEmpty(t)) {
						mLastErrorMessage = String.format("请选择[%s]", jsonObject.optString("attr_name"));
						return false;
					} else {
						return true;
					}
				}
				return super.verifySettingValue(t);
			}
		};
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurHandler = (ItemSettingHandler) v;
				ArrayList<String> nArrayList = new ArrayList<String>();
				JSONArray nArray = jsonObject.optJSONArray("attr_option");
				if (nArray != null && nArray.length() > 0) {
					for (int i = 0; i < nArray.length(); i++) {
						nArrayList.add(nArray.optString(i));
					}
				}

				String nCHoosedString = mCurHandler.getSettingValue();
				String[] nChoosedStrings = nCHoosedString.split("，");
				ArrayList<String> nChoosedArrayList = new ArrayList<String>();
				for (String string : nChoosedStrings) {
					nChoosedArrayList.add(string);
				}

				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_TITLE, jsonObject.optString("attr_name"));
				nBundle.putStringArrayList(Run.EXTRA_DATA, nArrayList);
				nBundle.putStringArrayList(Run.EXTRA_VALUE, nChoosedArrayList);
				startActivityForResult(AgentActivity.FRAGMENT_PASSPORT_MULTI, nBundle, PICKER_MULTI_REQUEST);
			}
		});
		// if (mHandlers.size() <= 0) {
		// nItemSettingTextView.showTopDivide(true);
		// }
		nItemSettingTextView.padding(0, 0);
		mHandlers.add(nItemSettingTextView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), jsonObject);
		mRegisterItemsLayout.addView(nItemSettingTextView);
	}

	/**
	 * @param jsonObject
	 *            单选
	 */
	void parseSingle(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optBoolean("attr_required") ? "" : "选填") {
			@Override
			public boolean verifySettingValue(String t) {
				// TODO Auto-generated method stub
				if (jsonObject.optBoolean("attr_required")) {
					if (TextUtils.isEmpty(t)) {
						mLastErrorMessage = String.format("请选择[%s]", jsonObject.optString("attr_name"));
						return false;
					} else {
						return true;
					}
				}
				return super.verifySettingValue(t);
			}
		};
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurHandler = (ItemSettingHandler) v;
				ArrayList<String> nArrayList = new ArrayList<String>();
				JSONArray nArray = jsonObject.optJSONArray("attr_option");
				if (nArray != null && nArray.length() > 0) {
					for (int i = 0; i < nArray.length(); i++) {
						nArrayList.add(nArray.optString(i));
					}
				}

				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_TITLE, jsonObject.optString("attr_name"));
				nBundle.putStringArrayList(Run.EXTRA_DATA, nArrayList);
				startActivityForResult(AgentActivity.FRAGMENT_PASSPORT_SINGLE, nBundle, PICKER_SINGLE_REQUEST);
			}
		});
		// if (mHandlers.size() <= 0) {
		// nItemSettingTextView.showTopDivide(true);
		// }
		nItemSettingTextView.padding(0, 0);
		mHandlers.add(nItemSettingTextView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), jsonObject);
		mRegisterItemsLayout.addView(nItemSettingTextView);
	}

	/**
	 * @param jsonObject
	 *            日期
	 */
	void parseDate(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optBoolean("attr_required") ? "" : "选填") {
			@Override
			public boolean verifySettingValue(String t) {
				// TODO Auto-generated method stub
				if (jsonObject.optBoolean("attr_required")) {
					if (TextUtils.isEmpty(t)) {
						mLastErrorMessage = String.format("请选择[%s]", jsonObject.optString("attr_name"));
						return false;
					} else {
						return true;
					}
				}
				return super.verifySettingValue(t);
			}
		};
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurHandler = (ItemSettingHandler) v;
				setTimDialog();
			}
		});
		// if (mHandlers.size() <= 0) {
		// nItemSettingTextView.showTopDivide(true);
		// }
		nItemSettingTextView.padding(0, 0);
		mHandlers.add(nItemSettingTextView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), jsonObject);
		mRegisterItemsLayout.addView(nItemSettingTextView);
	}

	private void setTimDialog() {
		final MyAlertDialog dialog = new MyAlertDialog(mActivity).builder().setNegativeButton("取消", new OnClickListener() {
			@Override
			public void onClick(View v) {

			}
		});
		dialog.setPositiveButton("确定", new OnClickListener() {
			@Override
			public void onClick(View v) {
				final String birthday = dialog.getResult();
				mCurHandler.setSettingValue(birthday);
				mCommitButton.setEnabled(checkCanCommit());
			}
		});
		dialog.show();
	}

	/**
	 * @param regionJsonObject
	 *            地区
	 */
	void parseRegion(final JSONObject regionJsonObject) {
		ItemSettingTextView nRegionItemSettingTextView = new ItemSettingTextView(mActivity, regionJsonObject.optString("attr_name"), regionJsonObject.optBoolean("attr_required") ? "" : "选填") {
			@Override
			public boolean verifySettingValue(String t) {
				// TODO Auto-generated method stub
				if (regionJsonObject.optBoolean("attr_required")) {
					if (TextUtils.isEmpty(t)) {
						mLastErrorMessage = String.format("请选择[%s]", regionJsonObject.optString("attr_name"));
						return false;
					} else {
						return true;
					}
				}
				return super.verifySettingValue(t);
			}
		};
		nRegionItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurHandler = (ItemSettingHandler) v;
				startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_MY_ADDRESS_PICKER), PICKER_AREA_REQUEST);
			}
		});
		// if (mHandlers.size() <= 0) {
		// nRegionItemSettingTextView.showTopDivide(true);
		// }
		nRegionItemSettingTextView.padding(0, 0);
		mHandlers.add(nRegionItemSettingTextView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), regionJsonObject);
		mRegisterItemsLayout.addView(nRegionItemSettingTextView);
	}

	void parseGender(final JSONObject jsonObject) {
		ItemSettingGenderView nGenderView = new ItemSettingGenderView(mActivity, jsonObject.optString("attr_name"), Gender.BOY);
		// if (mHandlers.size() <= 0) {
		// nGenderView.showTopDivide(true);
		// }
		nGenderView.padding(0, 0);
		mHandlers.add(nGenderView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), jsonObject);
		mRegisterItemsLayout.addView(nGenderView);
	}

	/**
	 * @param jsonObject
	 *            "attr_valtype":"alpha",//alpha|alphaint|number
	 */
	void parseText(final JSONObject jsonObject) {
		int nInputType = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL;
		String nValtype = jsonObject.optString("attr_valtype");
		if (nValtype.equalsIgnoreCase("number")) {
			nInputType = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_VARIATION_NORMAL;
		}
		ItemSettingItemView nItemSettingItemView = new ItemSettingItemView(mActivity, nInputType, 50, "", "", jsonObject.optString("attr_name")) {
			@Override
			public boolean verifySettingValue(String t) {
				// TODO Auto-generated method stub
				if (jsonObject.optBoolean("attr_required")) {
					if (TextUtils.isEmpty(t)) {
						mLastErrorMessage = String.format("请输入[%s]", jsonObject.optString("attr_name"));
						return false;
					} else {
						return true;
					}
				}
				return super.verifySettingValue(t);
			}
			
			@Override
			public void TextChanged(Editable s) {
				// TODO Auto-generated method stub
				mCommitButton.setEnabled(checkCanCommit());
			}
		};
		nItemSettingItemView.showLeftTitle(true, jsonObject.optBoolean("attr_required") ? "" : "选填");
		if (nValtype.equalsIgnoreCase("alpha")) {
			nItemSettingItemView.setInputAlpha();
		} else if (nValtype.equalsIgnoreCase("alphaint")) {
			nItemSettingItemView.setInputAlphaNumber();
		}
		// if (mHandlers.size() <= 0) {
		// nItemSettingItemView.showTopDivider(true);
		// }
		nItemSettingItemView.padding(0, 0);
		mHandlers.add(nItemSettingItemView);
		mDIYItemMap.put(mHandlers.get(mHandlers.size() - 1).hashCode(), jsonObject);
		mRegisterItemsLayout.addView(nItemSettingItemView);
	}

	String mLastErrorMessage = "";

	boolean checkCanCommit() {
		mLastErrorMessage = "";
		String code = mEtCode.getText().toString().toString().trim();
		String password = mEtPassword.getText().toString().toString();
		String photo = mEtPhoto.getText().toString().toString().trim();
		if (TextUtils.isEmpty(photo) || !Run.isChinesePhoneNumber(photo)) {
			mLastErrorMessage = "请输入正确的手机号（11位）";
			return false;
		} else if (TextUtils.isEmpty(code)) {
			mLastErrorMessage = "验证码不能为空";
			return false;
		} else if (TextUtils.isEmpty(password) || password.length() < 6 || password.length() > 20) {
			if (TextUtils.isEmpty(password)) {
				mLastErrorMessage = "密码不能为空";
			} else {
				mLastErrorMessage = "密码长度超过限制";
			}
			return false;
		} else {
			for (ItemSettingHandler handler : mHandlers) {
				if (!handler.verifySettingValue(handler.getSettingValue())) {
					return false;
				}
			}

			if (!mCheckBox.isChecked()) {
				mLastErrorMessage = "请同意《会员注册协议》";
				return false;
			}
		}
		return true;
	}

	@SuppressLint("ResourceAsColor")
	@Override
	public void onClick(View v) {
		super.onClick(v);
		switch (v.getId()) {
		case R.id.register_commit:
			String code = mEtCode.getText().toString().toString().trim();
			String password = mEtPassword.getText().toString().toString();
			String photo = mEtPhoto.getText().toString().toString().trim();
			if (TextUtils.isEmpty(photo) || !Run.isChinesePhoneNumber(photo)) {
				Run.alert(mActivity, "请输入正确的手机号（11位）");
				mEtPhoto.requestFocus();
			} else if (TextUtils.isEmpty(code)) {
				Run.alert(mActivity, "验证码不能为空");
				mEtCode.requestFocus();
			} else if (TextUtils.isEmpty(password) || password.length() < 6 || password.length() > 20) {
				if (TextUtils.isEmpty(password)) {
					Run.alert(mActivity, "密码不能为空");
				} else {
					Run.alert(mActivity, "密码长度超过限制");
				}
				mEtPassword.requestFocus();
			} else if (TextUtils.isEmpty(password) || password.length() < 6 || password.length() > 20) {
				if (TextUtils.isEmpty(password)) {
					Run.alert(mActivity, "密码不能为空");
				} else {
					Run.alert(mActivity, "密码长度超过限制");
				}
				mEtPassword.requestFocus();
			} else {

				for (ItemSettingHandler handler : mHandlers) {
					if (!handler.verifySettingValue(handler.getSettingValue())) {
						handler.requestFoucs();
						Run.alert(mActivity, mLastErrorMessage);
						return;
					}
				}

				if (!mCheckBox.isChecked()) {
					Run.alert(mActivity, "请同意《会员注册协议》");
					return;
				}

				mRegistrMemberInterface.RunRequest();
			}
			break;
		case R.id.register_code_but:
			String infoPhoto = mEtPhoto.getText().toString().toString().trim();
			if (TextUtils.isEmpty(infoPhoto)) {
				Run.alert(mActivity, "请输入正确的手机号（11位）");
				mEtPhoto.requestFocus();
			} else {
				if (mUseImageVCode && mImageVCodeEditText.getText().length() <= 0) {
					Run.alert(mActivity, "请输入图文验证码");
					mImageVCodeEditText.requestFocus();
					return;
				}

				mCodeBut.setEnabled(false);
				mCodeSMSInterface.setData(infoPhoto, "signup", mUseImageVCode ? mImageVCodeEditText.getText().toString() : "");
				mCodeSMSInterface.RunRequest();
			}
			break;
		case R.id.common_regist_agreement:
			// 协议
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PASSPORT_REGISTRATION_PROTOCOL));
			break;
		case R.id.common_regist_privacy:
			// 隐私保护政策
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_PASSPORT_PRIVACE));
			break;
		case R.id.register_vcode_ib:
			reloadVcodeImage();
			break;
		default:
			break;
		}
	}

	private void reloadVcodeImage() {
		String vcodeUrl = Run.buildString(mDIYItemsJsonObject.optString("code_url"), "?", System.currentTimeMillis());
		displayRectangleImage(mImageVCodeImageView, vcodeUrl);
	}

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
		Run.savePrefs(mActivity, Run.pk_logined_username, mEtPhoto.getText().toString().trim());
		Run.savePrefs(mActivity, Run.pk_logined_user_password, mEtPassword.getText().toString().trim());

		mActivity.setResult(Activity.RESULT_OK);
		mActivity.unregisterReceiver(homeDynamicReceiver);
		mActivity.finish();
		// startActivityForResult(AgentActivity.FRAGMENT_COMM_REGIST_HINT,
		// HINT_REG);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		if (requestCode == HINT_REG) {
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		} else if (requestCode == PICKER_AREA_REQUEST) {
			final String areaDisplayString = data.getStringExtra(Run.EXTRA_VALUE);
			final String areaValueString = data.getStringExtra(Run.EXTRA_DATA);
			mCurHandler.setSettingValue(areaDisplayString);
			mCommitButton.setEnabled(checkCanCommit());
		} else if (requestCode == PICKER_SINGLE_REQUEST) {
			mCurHandler.setSettingValue(data.getStringExtra(Run.EXTRA_VALUE));
			mCommitButton.setEnabled(checkCanCommit());
		} else if (requestCode == PICKER_MULTI_REQUEST) {
			mList = data.getStringArrayListExtra(Run.EXTRA_VALUE);
			StringBuilder nBuilder = new StringBuilder();
			for (String string : mList) {
				nBuilder.append(string).append("，");
			}
			if (nBuilder.length() > 0) {
				nBuilder.deleteCharAt(nBuilder.length() - 1);
			}
			mCurHandler.setSettingValue(nBuilder.toString());
			mCommitButton.setEnabled(checkCanCommit());
		}
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
		mCommitButton.setEnabled(checkCanCommit());
	}
}
