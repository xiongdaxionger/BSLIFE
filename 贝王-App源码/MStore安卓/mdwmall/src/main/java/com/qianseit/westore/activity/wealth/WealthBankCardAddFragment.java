package com.qianseit.westore.activity.wealth;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TableRow;
import android.widget.TextView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.passport.SendVCodeSMSInterface;
import com.qianseit.westore.httpinterface.wealth.WealthBankAddInterface;
import com.beiwangfx.R;

/**
 * 添加银行卡,绑定提现可以绑定支付宝或者银行卡 而充值时选择添加银行卡则不用选择绑定支付宝
 */
public class WealthBankCardAddFragment extends BaseDoFragment implements OnCheckedChangeListener {

	private View viewContainer;
	private String title;
	private FrameLayout fraContainer;
	private LoginedUser loginedUser;
	private ViewBankHolder bankHolder;
	private ViewAliPayHolder aliHolder;
	private Button btnSure;// 绑定
	private String bankType = "1";
	private String mVcode;
	private String userPhone;

	private RadioGroup mGroup;
	private RadioButton mBancRadioButton;
	private boolean isOther = false;
	String mVCode = "";
	private boolean isInit = false;

	SendVCodeSMSInterface mCodeSMSInterface = new SendVCodeSMSInterface(this, "", SendVCodeSMSInterface.TYPE_ACTIVATION) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.countdown_time = System.currentTimeMillis();
			if (bankType.equals("1")) {
				enableVreifyCodeButton(bankHolder.mGetVerifyCodeButton);
			} else {
				enableVreifyCodeButton(aliHolder.mGetVerifyCodeButton);
			}
		}

		@Override
		public void FailRequest() {
			if (bankType.equals("1")) {
				bankHolder.mGetVerifyCodeButton.setEnabled(true);
				bankHolder.reloadVcodeImage();
			} else {
				aliHolder.mGetVerifyCodeButton.setEnabled(true);
				aliHolder.reloadVcodeImage();
			}
		}
	};
	WealthBankAddInterface mAddInterface = new WealthBankAddInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "添加账号成功");
			mActivity.finish();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowHomeView(true);
		mActionBar.setShowBackButton(true);
		mActionBar.setShowTitleBar(true);
		Intent intent = getActivity().getIntent();
		if (intent != null) {
			title = intent.getStringExtra(Run.EXTRA_TITLE);
			mVCode = intent.getStringExtra(Run.EXTRA_DATA);
			if (title != null) {
				mActionBar.setTitle(title);
			} else {
				mActionBar.setTitle("添加账户");
			}
		}
		loginedUser = AgentApplication.getLoginedUser(mActivity);
		userPhone = loginedUser.mobile;
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_wealth_bank_card_add, null);
		fraContainer = (FrameLayout) findViewById(R.id.ll_container);
		btnSure = (Button) findViewById(R.id.btn_sure);
		btnSure.setOnClickListener(this);

		mGroup = (RadioGroup) findViewById(R.id.radiogroup_bank_all);
		mGroup.setOnCheckedChangeListener(this);

		mBancRadioButton = (RadioButton) findViewById(R.id.bank_card_bank);
		mBancRadioButton.setChecked(true);

		if (TextUtils.isEmpty(loginedUser.mobile)) {
			startActivity(AgentActivity.FRAGMENT_ACCO_BIND_MOBILE);
			Run.alert(mActivity, "先绑定手机号才能添加银行卡");
		}

	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		if(!isInit){
			isInit = true;
			initCurrentView();
		}
	}
	
	@Override
	public void onClick(View v) {
		if (v == btnSure) {
			if (TextUtils.equals("1", bankType)) {
				if (TextUtils.isEmpty(bankHolder.etBankNum.getText().toString().trim())) {
					bankHolder.etBankNum.requestFocus();
					Run.alert(mActivity, "银行卡号不能为空");
				} else if (TextUtils.isEmpty(bankHolder.etRealName.getText().toString().trim())) {
					bankHolder.etRealName.requestFocus();
					Run.alert(mActivity, "持卡人不能为空");
				} else if (TextUtils.isEmpty(bankHolder.tvBankName.getText().toString().trim())) {
					bankHolder.tvBankName.requestFocus();
					Run.alert(mActivity, "请选择发卡银行");
				} else if (TextUtils.isEmpty(bankHolder.etVCode.getText().toString().trim())) {
					bankHolder.etVCode.requestFocus();
					Run.alert(mActivity, "验证码不能为空");
				} else if (TextUtils.isEmpty(bankHolder.etBankName.getText().toString().trim()) && isOther) {
					bankHolder.etBankName.requestFocus();
					Run.alert(mActivity, "银行名称不能为空");
				} else {
					mAddInterface.addBankCard(bankHolder.etVCode.getText().toString().trim(), bankHolder.etBankNum.getText().toString().trim(), bankHolder.tvBankName.getText().toString().trim(),
							bankHolder.etRealName.getText().toString().trim(), bankHolder.etPhone.getText().toString().trim());
				}
			} else {
				if (TextUtils.isEmpty(aliHolder.etAccount.getText().toString().trim())) {
					aliHolder.etAccount.requestFocus();
					Run.alert(mActivity, "帐号不能为空");
				} else if (TextUtils.isEmpty(aliHolder.etRealName.getText().toString().trim())) {
					aliHolder.etRealName.requestFocus();
					Run.alert(mActivity, "帐号名字不能为空");
				} else if (TextUtils.isEmpty(aliHolder.etVCode.getText().toString().trim())) {
					aliHolder.etVCode.requestFocus();
					Run.alert(mActivity, "验证码不能为空");
				} else {
					mAddInterface.addAli(aliHolder.etVCode.getText().toString().trim(), aliHolder.etAccount.getText().toString().trim(), aliHolder.etRealName.getText().toString().trim(),
							aliHolder.etPhone.getText().toString().trim());
				}
			}
		}
	}

	// 加载绑定支付宝UI或者银联UI
	private void initCurrentView() {
		fraContainer.removeAllViews();
		bankHolder = null;
		aliHolder = null;
		isOther = false;
		if (TextUtils.equals("添加银行卡", title)) {
			viewContainer = getActivity().getLayoutInflater().inflate(R.layout.item_layout_bank_bind, null);
			fraContainer.removeAllViews();
			fraContainer.addView(viewContainer);
			bankHolder = new ViewBankHolder();
		} else if (bankType.equals("1")) {
			viewContainer = getActivity().getLayoutInflater().inflate(R.layout.item_layout_bank_bind, null);
			fraContainer.removeAllViews();
			fraContainer.addView(viewContainer);
			bankHolder = new ViewBankHolder();
		} else if (bankType.equals("2")) {
			viewContainer = getActivity().getLayoutInflater().inflate(R.layout.item_layout_alipay_bind, null);
			fraContainer.removeAllViews();
			fraContainer.addView(viewContainer);
			aliHolder = new ViewAliPayHolder();
		}
	}

	class ViewBankHolder {
		TextView tvBankName;
		EditText etBankNum;
		EditText etRealName;
		EditText etVCode;
		EditText etVCodeImage;
		EditText etBankName;
		View mViewLin;
		Button mGetVerifyCodeButton;
		View viewSelectBank;
		EditText etPhone;
		ImageView mImageVCodeImageView;

		public ViewBankHolder() {

			mViewLin = viewContainer.findViewById(R.id.et_bank_name_lin);
			tvBankName = (TextView) viewContainer.findViewById(R.id.tv_bank_name);
			etBankNum = (EditText) viewContainer.findViewById(R.id.et_bank_num);
			etRealName = (EditText) viewContainer.findViewById(R.id.et_real_name);
			etBankName = (EditText) viewContainer.findViewById(R.id.et_bank_name);
			etPhone = (EditText) viewContainer.findViewById(R.id.et_phone);
			etVCode = (EditText) viewContainer.findViewById(R.id.et_vcode);
			etVCodeImage = (EditText) viewContainer.findViewById(R.id.vcode);
			mImageVCodeImageView = (ImageView) viewContainer.findViewById(R.id.vcode_ib);
			mGetVerifyCodeButton = (Button) viewContainer.findViewById(R.id.btn_get_Code);
			viewSelectBank = viewContainer.findViewById(R.id.rel_select_bank);
			etPhone.setText(userPhone);

			if(TextUtils.isEmpty(mVCode)){
				viewContainer.findViewById(R.id.register_vcode_tr).setVisibility(View.GONE);
				viewContainer.findViewById(R.id.register_vcode_divider).setVisibility(View.GONE);
			}else{
				viewContainer.findViewById(R.id.register_vcode_tr).setVisibility(View.VISIBLE);
				viewContainer.findViewById(R.id.register_vcode_divider).setVisibility(View.VISIBLE);
				reloadVcodeImage();
			}
			
			mImageVCodeImageView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					reloadVcodeImage();
				}
			});
			
			mGetVerifyCodeButton.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					if (!TextUtils.isEmpty(mVCode) && TextUtils.isEmpty(etVCodeImage.getText().toString().trim())) {
						etVCodeImage.requestFocus();
						Run.alert(mActivity, "请输入图文验证码");
						return;
					}
					mCodeSMSInterface.getVCode(userPhone, TextUtils.isEmpty(mVCode) ? "" : etVCodeImage.getText().toString());
				}
			});
			viewSelectBank.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BANK_CHOOSE), 1);
				}
			});

		}

		public void reloadVcodeImage() {
			String vcodeUrl = Run.buildString(mVCode, "?", System.currentTimeMillis());
			displayRectangleImage(mImageVCodeImageView, vcodeUrl);
		}
	}

	class ViewAliPayHolder {
		EditText etAccount;
		EditText etRealName;
		EditText etVCode;
		EditText etVCodeImage;
		EditText etPhone;
		Button mGetVerifyCodeButton;
		ImageView mImageVCodeImageView;

		public ViewAliPayHolder() {
			etAccount = (EditText) viewContainer.findViewById(R.id.et_account);
			etRealName = (EditText) viewContainer.findViewById(R.id.et_real_name);
			etVCode = (EditText) viewContainer.findViewById(R.id.et_vcode);
			etPhone = (EditText) viewContainer.findViewById(R.id.et_alipay_phone);
			etVCodeImage = (EditText) viewContainer.findViewById(R.id.vcode);
			mImageVCodeImageView = (ImageView) viewContainer.findViewById(R.id.vcode_ib);
			mGetVerifyCodeButton = (Button) viewContainer.findViewById(R.id.btn_get_Code);

			etPhone.setText(userPhone);
			mGetVerifyCodeButton.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					if (!TextUtils.isEmpty(mVCode) && TextUtils.isEmpty(etVCodeImage.getText().toString().trim())) {
						etVCodeImage.requestFocus();
						Run.alert(mActivity, "请输入图文验证码");
						return;
					}
					mCodeSMSInterface.getVCode(userPhone, TextUtils.isEmpty(mVCode) ? "" : etVCodeImage.getText().toString());
				}
			});
			
			if(TextUtils.isEmpty(mVCode)){
				viewContainer.findViewById(R.id.register_vcode_tr).setVisibility(View.GONE);
				viewContainer.findViewById(R.id.register_vcode_divider).setVisibility(View.GONE);
			}else{
				viewContainer.findViewById(R.id.register_vcode_tr).setVisibility(View.VISIBLE);
				viewContainer.findViewById(R.id.register_vcode_divider).setVisibility(View.VISIBLE);
				reloadVcodeImage();
			}
			
			mImageVCodeImageView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					reloadVcodeImage();
				}
			});
		}

		public void reloadVcodeImage() {
			String vcodeUrl = Run.buildString(mVCode, "?", System.currentTimeMillis());
			displayRectangleImage(mImageVCodeImageView, vcodeUrl);
		}
	}

	// 设置验证码按钮状态，倒计时60秒
	private void enableVreifyCodeButton(final Button mGetVerifyCodeButton) {
		long remainTime = System.currentTimeMillis() - Run.countdown_time;
		remainTime = 120 - remainTime / 1000;
		if (remainTime <= 0) {
			mGetVerifyCodeButton.setEnabled(true);
			mGetVerifyCodeButton.setText("获取验证码");
			mGetVerifyCodeButton.setBackgroundResource(R.drawable.app_button_selector);
			mGetVerifyCodeButton.setTextColor(mActivity.getResources().getColor(R.color.white));
			return;
		} else {
			mGetVerifyCodeButton.setBackgroundResource(R.drawable.bg_verify_code);
			mGetVerifyCodeButton.setTextColor(mActivity.getResources().getColor(R.color.default_page_bgcolor_3));
		}

		mGetVerifyCodeButton.setEnabled(false);
		mGetVerifyCodeButton.setText(mActivity.getString(R.string.acco_regist_verify_code_countdown, remainTime));
		verifyRunnable = new Runnable() {
			@Override
			public void run() {
				enableVreifyCodeButton(mGetVerifyCodeButton);
			}
		};
		mHandler.postDelayed(verifyRunnable, 1000);
	}

	private Runnable verifyRunnable;

	@Override
	public void onDestroy() {
		super.onDestroy();
		if (verifyRunnable != null) {
			mHandler.removeCallbacks(verifyRunnable);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == Activity.RESULT_OK) {
			if (data != null && requestCode == 1) {
				String bankName = data.getStringExtra(Run.EXTRA_DATA);
				if (bankHolder != null) {
					TableRow tableRow = (TableRow) bankHolder.etBankName.getParent();

					if ("其他".equals(bankName)) {
						tableRow.setVisibility(View.VISIBLE);
						bankHolder.mViewLin.setVisibility(View.VISIBLE);
						bankHolder.etBankName.requestFocus();
						isOther = true;
					} else {
						bankHolder.mViewLin.setVisibility(View.GONE);
						tableRow.setVisibility(View.GONE);
						isOther = false;
					}
					bankHolder.tvBankName.setText(bankName);
				}
			}
		}

	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		// TODO Auto-generated method stub
		switch (checkedId) {
		case R.id.bank_card_bank:
			bankType = "1";
			initCurrentView();
			break;

		default:
			bankType = "2";
			initCurrentView();
			break;
		}
	}
}
