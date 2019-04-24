package com.qianseit.westore.activity.wealth;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.acco.InputPayPasswordDialog;
import com.qianseit.westore.activity.acco.InputPayPasswordDialog.OnPayPasswordListener;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.bean.BankInfo;
import com.qianseit.westore.httpinterface.setting.CheckPayPasswordInterface;
import com.qianseit.westore.httpinterface.wealth.WealthWithdrawInterface;
import com.qianseit.westore.httpinterface.wealth.WealthWithdrawNoticeInterface;
import com.qianseit.westore.util.StringUtils;
import com.beiwangfx.R;

public class WealthWithdrawFragment extends BaseDoFragment {
	public final int REQUEST_BANK = 0x100;
	private Button butWithdraw;
	private LoginedUser mLoginedUser;
	private TextView withdrawMoneytext;
	private TextView withdrawTaxestext, withdrawCosttext;
	private EditText etMoney;
	private double minMoney = 0;
	private double maxMoney = 0, withdrawMaxMoney = 0;
	private LinearLayout mHintLayout;
	private LayoutInflater mInflater;
	private TextView noSelectText, selectText, bankNameText;
	private BankInfo bankInfo;

	String mWithdrawTaxesTip;
	Double mWithdrawTaxes = 0d;
	
	String mWithdrawCostTip;
	Double mWithdrawCost = 0d;

	WealthWithdrawNoticeInterface mNoticeInterface = new WealthWithdrawNoticeInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			List<JSONObject> hintArray = new ArrayList<JSONObject>();
			JSONArray dataArray = responseJson.optJSONArray("data");
			if (dataArray == null || dataArray.length() <= 0) {
				return;
			}

			for (int i = 0; i < dataArray.length(); i++) {
				JSONObject json = dataArray.optJSONObject(i);
				if (json != null) {
					String nType = json.optString("type");
					if (nType.equalsIgnoreCase("money")) {
						fillMoneyData(json);
					} else if (nType.equalsIgnoreCase("notice")) {
						hintArray.add(json);
					}  else if (nType.equalsIgnoreCase("fee")) {
						mWithdrawCostTip = json.optString("notice");
						mWithdrawCost = json.optDouble("val");
						if (mWithdrawCost > 0) {
							withdrawCosttext.setText(mWithdrawCostTip);
							findViewById(R.id.withdraw_cost_ll).setVisibility(View.VISIBLE);
							findViewById(R.id.withdraw_cost_divider).setVisibility(View.VISIBLE);
							hintArray.add(json);
						}else{
							findViewById(R.id.withdraw_cost_ll).setVisibility(View.GONE);
							findViewById(R.id.withdraw_cost_divider).setVisibility(View.GONE);
						}
					} else if (nType.equalsIgnoreCase("tax")) {
						mWithdrawTaxesTip = json.optString("notice");
						mWithdrawTaxes = json.optDouble("val");
						if (mWithdrawTaxes > 0) {
							withdrawTaxestext.setText(mWithdrawTaxesTip);
							findViewById(R.id.withdraw_taxes_ll).setVisibility(View.VISIBLE);
							findViewById(R.id.withdraw_taxes_divider).setVisibility(View.VISIBLE);
							hintArray.add(json);
						}else{
							findViewById(R.id.withdraw_taxes_ll).setVisibility(View.GONE);
							findViewById(R.id.withdraw_taxes_divider).setVisibility(View.GONE);
						}
					}
				}
			}

			fillHintData(hintArray);
		}
	};
	WealthWithdrawInterface mWealthWithdrawInterface = new WealthWithdrawInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "提现成功");
			back();
//			mNoticeInterface.RunRequest();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowHomeView(true);
		mActionBar.setShowTitleBar(true);
		mActionBar.setShowBackButton(true);
		mActionBar.setTitle("提现");
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
	}

	@Override
	public void onResume() {
		super.onResume();
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_withdraw, null);

		mHintLayout = (LinearLayout) findViewById(R.id.withdraw_hint_linear);
		butWithdraw = (Button) findViewById(R.id.but_withdraw);
		withdrawMoneytext = (TextView) findViewById(R.id.withdraw_total_money_text);
		withdrawTaxestext = (TextView) findViewById(R.id.withdraw_taxes_et);
		etMoney = (EditText) findViewById(R.id.withdraw_money_et);
		noSelectText = (TextView) findViewById(R.id.withdraw_no_select_bank_text);
		selectText = (TextView) findViewById(R.id.withdraw_select_bank_text);
		bankNameText = (TextView) findViewById(R.id.withdraw_bank_content_text);
		withdrawCosttext = (TextView) findViewById(R.id.withdraw_cost_et);
		butWithdraw.setOnClickListener(this);
		findViewById(R.id.withdraw_bank_linear).setOnClickListener(this);
		etMoney.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (etMoney.getText().toString().indexOf(".") > 0) {
					if (etMoney.getText().toString().indexOf(".", etMoney.getText().toString().indexOf(".") + 1) > 0) {
						etMoney.setText(etMoney.getText().toString().substring(0, etMoney.getText().toString().length() - 1));
						etMoney.setSelection(etMoney.getText().toString().length());
					}
				} else {
					if (etMoney.getText().toString().indexOf(".") == 0) {
						etMoney.setText("");
					}
				}

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO Auto-generated method stub

			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
				if (s.length() > 0) {
					double nWithdrawMoney = Double.parseDouble(s.toString());
					if (nWithdrawMoney > Math.min(withdrawMaxMoney, maxMoney)) {
						nWithdrawMoney = Math.min(withdrawMaxMoney, maxMoney);
						etMoney.setText(String.valueOf(nWithdrawMoney));
						etMoney.setSelection(etMoney.getText().length());
					}
					withdrawTaxestext.setText(StringUtils.formatPrice(String.valueOf(nWithdrawMoney * mWithdrawTaxes)));
					withdrawCosttext.setText(StringUtils.formatPrice(String.valueOf(nWithdrawMoney * mWithdrawCost)));
				} else {
					withdrawTaxestext.setText(mWithdrawTaxesTip);
					withdrawCosttext.setText(mWithdrawCostTip);
				}
			}
		});

		mNoticeInterface.RunRequest();
	}

	private void fillMoneyData(JSONObject json) {
		minMoney = json.optDouble("min");
		maxMoney = json.optDouble("max");
		withdrawMaxMoney = json.optDouble("commision");
		etMoney.setHint(String.format("单笔最高可提现%s元", json.optString("max")));
		// if (maxMoney / 10000 >= 1) {
		// etMoney.setHint("单笔最高" + String.valueOf(maxMoney / 10000) + "万元");
		// } else {
		// etMoney.setHint("单笔最高" + String.valueOf(maxMoney)+"元");
		// }
		withdrawMoneytext.setText(json.optString("commision").isEmpty() ? "0.00" : json.optString("commision"));

	}

	private void fillHintData(List<JSONObject> hintArray) {
		mHintLayout.removeAllViews();
		for (int i = 0; i < hintArray.size(); i++) {
			JSONObject json = hintArray.get(i);
			TextView hintText = (TextView) mInflater.inflate(R.layout.item_withdraw_hint, null);
			hintText.setText(json.optString("notice"));
			mHintLayout.addView(hintText);
		}
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.but_withdraw) {
			if (bankInfo == null) {
				Run.alert(mActivity, "请选择提现账号");
				return;
			}
			String DrawValue = etMoney.getText().toString().trim();
			if (!TextUtils.isEmpty(DrawValue)) {
				double nWithdrawValue = Double.valueOf(DrawValue);

				if (nWithdrawValue < minMoney) {
					Run.alert(mActivity, "输入提现金额不要小于" + minMoney + "元");
					etMoney.requestFocus();
					return;
				} else if (maxMoney < nWithdrawValue) {
					Run.alert(mActivity, "单笔提现金额超过" + maxMoney + "元");
					etMoney.requestFocus();
					return;
				} else if (withdrawMaxMoney < nWithdrawValue) {
					Run.alert(mActivity, "提现金额不能超过当前贝壳：" + withdrawMaxMoney + "元");
					etMoney.requestFocus();
					return;
				}
			} else {
				Run.alert(mActivity, "提现金额不能为空");
				etMoney.requestFocus();
				return;
			}

			if (!mLoginedUser.getPayPassword()) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW));
			} else {
				openInputPayPasswordFrame();
			}
		} else if (v.getId() == R.id.withdraw_bank_linear) {
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BANK_CARD).putExtra(Run.EXTRA_TITLE, "提现账号"), REQUEST_BANK);
		}

	}

	// 打开输入支付密码界面
	private void openInputPayPasswordFrame() {
		InputPayPasswordDialog.openDialog(mActivity, new OnPayPasswordListener() {

			@Override
			public void onResult(final String payPassword) {
				// 验证支付密码是否正确
				
				new CheckPayPasswordInterface(WealthWithdrawFragment.this, payPassword) {

					@Override
					public void Correct() {
						// TODO Auto-generated method stub
						mWealthWithdrawInterface.withdraw(etMoney.getText().toString(), bankInfo.getBank_id(), payPassword);
					}

					@Override
					public void modPassword() {
						// TODO Auto-generated method stub
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_BUSINESS_PW));
					}
				}.RunRequest();
			}

			@Override
			public String onPaymentAmount() {
				return etMoney.getText().toString();
			}
		}, "提现金额");
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == Activity.RESULT_OK) {
			if (requestCode == REQUEST_BANK) {
				bankInfo = (BankInfo) data.getSerializableExtra(Run.EXTRA_DATA);
				if (bankInfo != null) {
					selectText.setVisibility(View.VISIBLE);
					noSelectText.setVisibility(View.GONE);
					int length = bankInfo.getBank_num().length();
					bankNameText.setText(bankInfo.getBank_name() + "  尾号" + bankInfo.getBank_num().substring(length > 4 ? length - 4 : 0, length) + "  " + bankInfo.getReal_name());
				}
			}
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
}
