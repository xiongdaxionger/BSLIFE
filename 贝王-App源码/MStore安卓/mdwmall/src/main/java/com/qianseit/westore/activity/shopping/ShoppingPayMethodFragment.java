package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.alipay.client.AliPayFragment;
import com.alipay.client.PayResult;
import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.acco.InputPayPasswordDialog;
import com.qianseit.westore.activity.acco.InputPayPasswordDialog.OnPayPasswordListener;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.order.OrderFragment;
import com.qianseit.westore.activity.order.OrderSegementFragment;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.base.UPPayInterface;
import com.qianseit.westore.httpinterface.setting.CheckPayPasswordInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayChangeCombinationPaymentInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayChangePaymentInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayCheckPayStatus;
import com.qianseit.westore.httpinterface.shopping.ShoppPayDoPaymentInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayIndexInterface;
import com.qianseit.westore.util.StringUtils;
import com.unionpay.UPPayAssistEx;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class ShoppingPayMethodFragment extends AliPayFragment {
	final String AMOUNT_WITH_BRIEF = "%s<font color='#F3273F'>%s</font>";
	/**
	 * 是否组合支付
	 */
	boolean mIsCombination = false;
	boolean mIsFromOrderConfirm = false;
	/**是否为佣金订单
	 */
	boolean mIsCommisionOrder = false;
	private String mOrderId;
	String mErrHint = "";
	JSONObject mPaymentIndex, mOrderJsonObject, mPaymentSettingJsonObject, mMemberInfoJsonObject, mCombinationAmountJsonObject;

	private JSONObject mCurPayment, mCurCombinationPayment;

	Button mSubmitButton;
	Dialog mDialog;

	ListView mListView;
	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();
	List<JSONObject> mPaymentJsonObjects = new ArrayList<JSONObject>();
	List<JSONObject> mCombinationJsonObjects = new ArrayList<JSONObject>();
	QianseitAdapter<JSONObject> mAdapter = new QianseitAdapter<JSONObject>(mJsonObjects) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_payment, null);
				setViewSize(convertView.findViewById(R.id.pay_icon), 126, 87);
				convertView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						int nPosition = (Integer) v.getTag();
						JSONObject nItem = getItem(nPosition);
						if (nItem.optBoolean("checked")) {
							return;
						}
						if (!mIsCombination) {
							mChangePaymentInterface.changePayment(nItem.optString("app_id"));
							return;
						}

						try {
							for (int i = 0; i < mCombinationJsonObjects.size(); i++) {
								mCombinationJsonObjects.get(i).put("checked", false);
							}
							nItem.put("checked", true);
							mChangeCombinationPaymentInterface.changeCombinationPayment(nItem.optString("app_id"), mMemberInfoJsonObject.optDouble("cur_money"),
									mMemberInfoJsonObject.optDouble("deposit_money"));
							notifyDataSetChanged();
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				});
			}
			JSONObject nItem = getItem(position);
			String nAppname = nItem.optString("app_name");

			((TextView) convertView.findViewById(R.id.pay_name)).setText(nAppname.contains("预存款") || nAppname.contains("现金") ? Html.fromHtml(String.format(AMOUNT_WITH_BRIEF, nAppname,
					String.format("(余额：%s)", mMemberInfoJsonObject.optString("deposit_money_format")))) : nAppname);
			((TextView) convertView.findViewById(R.id.pay_content)).setText(nItem.optString("app_pay_brief"));
			((CheckBox) convertView.findViewById(R.id.pay_checkbox)).setChecked(nItem.optBoolean("checked"));
			if (nItem.optBoolean("checked")) {
				if (mIsCombination) {
					mCurCombinationPayment = nItem;
				} else {
					mCurPayment = nItem;
				}
			}

			// 支付方式图标
			String appicon = nItem.optString("icon_src");
			ImageView iconView = (ImageView) convertView.findViewById(R.id.pay_icon);
			if (!TextUtils.isEmpty(appicon)) {
				displayImage(iconView, appicon, R.drawable.default_pay);
			} else {
				if (nAppname.contains("预存款") || nAppname.contains("现金")) {
					iconView.setImageResource(R.drawable.icon_pay_pre_deposit);
				} else if (nAppname.contains("分享")) {
					iconView.setImageResource(R.drawable.icon_pay_share);
				} else if (nAppname.contains("银行卡")) {
					iconView.setImageResource(R.drawable.icon_pay_pank_card);
				} else if (nAppname.contains("支付宝")) {
					iconView.setImageResource(R.drawable.icon_pay_zhifubao);
				} else {
					iconView.setImageResource(R.drawable.icon_pay_pre_deposit);
				}
			}

			convertView.setTag(position);

			return convertView;
		}
	};

	ShoppPayDoPaymentInterface mPaymentInterface = new ShoppPayDoPaymentInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			String payAppId = responseJson.optString("pay_app_id");
			if (TextUtils.isEmpty(payAppId)) {
				payAppId = mCurPayment.optString("app_id");
			}
			if ("malipay".equals(payAppId)) {
				// 支付宝
				callAliPay(responseJson);
				return;
			} else if ("wxpayjsapi".equals(payAppId)) {
				// 微信
				callWXPay(responseJson);
				if (Run.loadOptionBoolean(mActivity, "WXPayResult", false)) {
					mPaymentStatus = true;
				}
			} else if ("wapupacp".equals(payAppId)) {// 银联支付
				// “00” – 银联正式环境
				// “01” – 银联测试环境，该环境中不发生真实交易
				if (responseJson.optJSONObject("data").has("tn")){

					String serverMode = "00";
					UPPayAssistEx.startPay(mActivity, null, null, responseJson.optJSONObject("data").optString("tn"), serverMode);
				}
			} else {
				mPaymentStatus = true;
				checkPay(null);
			}
		}
	};
	ShoppPayIndexInterface mPayIndexInterface = new ShoppPayIndexInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			findViewById(R.id.pay_title_ll).setVisibility(View.VISIBLE);
			parsePaymentIndex(responseJson);
		}

		@Override
		public void isPaied() {
			mPaymentStatus = true;
			checkPay(null);
		}
	};
	ShoppPayChangePaymentInterface mChangePaymentInterface = new ShoppPayChangePaymentInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			parsePaymentIndex(responseJson);
		}
	};
	ShoppPayChangeCombinationPaymentInterface mChangeCombinationPaymentInterface = new ShoppPayChangeCombinationPaymentInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mCombinationAmountJsonObject = responseJson;
			assignmentCombinationAmount();
		}
	};
	ShoppPayCheckPayStatus mCheckPayStatus = new ShoppPayCheckPayStatus(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mPaymentStatus = true;
			checkPay("");
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("支 付");
		Intent nIntent = mActivity.getIntent();
		mOrderId = nIntent.getStringExtra(Run.EXTRA_ORDER_ID);
		mIsFromOrderConfirm = nIntent.getBooleanExtra(Run.EXTRA_VALUE, false);
		mIsCommisionOrder = nIntent.getBooleanExtra(OrderFragment.ORDER_COMMISION_TYPE,false);
		try {
			String nString = nIntent.getStringExtra(Run.EXTRA_DATA);
			if (!TextUtils.isEmpty(nString)) {
				mPaymentIndex = new JSONObject(nString);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mPaymentIndex = null;
		}
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		if (Run.loadOptionBoolean(mActivity, "WXPayResult", false)) {
			Run.savePrefs(mActivity, "WXPayResult", false);
			mCheckPayStatus.checkPayStatus(mOrderId);
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		if (mActivity instanceof DoActivity) {
			((DoActivity) mActivity).setUPPayCallBack(new UPPayInterface() {

				@Override
				public void UPPayCallback(Intent data) {
					// TODO Auto-generated method stub
					dealUPResult(data);
					checkPay(mErrHint);
				}
			});
		}
		rootView = inflater.inflate(R.layout.fragment_shopp_order_pay, null);

		((TextView) findViewById(R.id.orderid)).setText(mOrderId);

		findViewById(R.id.confirm_order_submit).setOnClickListener(this);
		findViewById(R.id.confirm_order_pay_state_ok).setOnClickListener(this);

		mSubmitButton = (Button) findViewById(R.id.confirm_order_submit);

		mListView = (ListView) findViewById(R.id.payments);
		mListView.setAdapter(mAdapter);

		findViewById(R.id.combination_pay_title_ll).setVisibility(View.GONE);
		findViewById(R.id.pay_title_ll).setVisibility(View.GONE);

		if (mPaymentIndex == null) {
			mPayIndexInterface.getPayIndex(mOrderId);
		} else {
			findViewById(R.id.pay_title_ll).setVisibility(View.VISIBLE);
			parsePaymentIndex(mPaymentIndex);
		}
	}

	void finishActivity() {
		if (!mIsFromOrderConfirm) {
			mActivity.finish();
			return;
		}

		long nStartOrdersType = OrderFragment.WAIT_SHIPPING;
		if (!mPaymentStatus) {
			nStartOrdersType = OrderFragment.WAIT_PAY;
		} else if (mOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare")) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDER_PREPARE));
			mActivity.finish();
			return;
		}

		startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS).putExtra(Run.EXTRA_DETAIL_TYPE, nStartOrdersType).putExtra(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,mIsCommisionOrder ? R.id.segement_right : R.id.segement_left));
		mActivity.finish();
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.confirm_order_pay_state_ok) {
			finishActivity();
		} else {
			v.setEnabled(false);
			if (!mIsCombination && TextUtils.isEmpty(mPaymentSettingJsonObject.optString("pay_btn"))) {
				v.setEnabled(true);
				return;
			}

			if (mCurPayment != null) {
				if ("deposit".equals(mCurPayment.optString("app_id"))) {
					if (mIsCombination && mCurCombinationPayment == null) {
						Run.alert(mActivity, "请选择组合支付方式");
					} else {
						openInputPayPasswordFrame(mPaymentIndex.optJSONObject("order").optString("cur_money_format"));
					}
				} else {
					mPaymentInterface.reset();
					mPaymentInterface.pay(mPaymentIndex, mCurPayment);
				}
			}
			v.setEnabled(true);
		}
	}

	@Override
	public void ui(int what, Message msg) {
		switch (msg.what) {
		case SDK_PAY_FLAG: // 支付宝支付结果
			PayResult payResult = new PayResult((String) msg.obj);
			// 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
			// String resultInfo = payResult.getResult();
			String resultStatus = payResult.getResultStatus();
			// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
			if (TextUtils.equals(resultStatus, "9000")) {
				Toast.makeText(mActivity, "支付成功", Toast.LENGTH_SHORT).show();
				mPaymentStatus = true;
			} else {
				// 判断resultStatus 为非“9000”则代表可能支付失败
				// “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
				if (TextUtils.equals(resultStatus, "8000")) {
					Toast.makeText(mActivity, "支付结果确认中", Toast.LENGTH_SHORT).show();
				} else {
					// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
					Toast.makeText(mActivity, "支付失败", Toast.LENGTH_SHORT).show();
					mPaymentStatus = false;
				}
			}
			checkPay(null);
			break;
		}
	}

	@Override
	protected void back() {
		// TODO Auto-generated method stub
		if (mIsCombination) {
			switchCombination(false);
		} else if (!mPaymentStatus) {
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定取消支付吗？", "取消", "确定", null, new OnClickListener() {// ok

						@Override
						public void onClick(View v) {
							// TODO Auto-generated method
							// stub
							mDialog.dismiss();
							finishActivity();
						}
					}, false, null);
		} else {
			super.back();
		}
	}

	private boolean mPaymentStatus;

	/**
	 * 银联支付结果处理
	 * 
	 * @param data
	 * @return
	 */
	boolean dealUPResult(Intent data) {
		if (data == null) {
			return false;
		}

		String str = data.getExtras().getString("pay_result");
		if (str == null) {
			return false;
		}
		if (str.equalsIgnoreCase("success")) {
			// 支付成功后，extra中如果存在result_data，取出校验
			// result_data结构见c）result_data参数说明
			if (data.hasExtra("result_data")) {
				String sign = data.getExtras().getString("result_data");
				// 验签证书同后台验签证书
				// 此处的verify，商户需送去商户后台做验签
				if (true) {// verify(sign)
					// 验证通过后，显示支付结果
					mErrHint = "支付成功";
					Toast.makeText(mActivity, mErrHint, Toast.LENGTH_SHORT).show();
					mPaymentStatus = true;
				} else {
					// 验证不通过后的处理
					// 建议通过商户后台查询支付结果
				}
			} else {
				// 未收到签名信息
				// 建议通过商户后台查询支付结果
			}
			return true;
		} else if (str.equalsIgnoreCase("fail")) {
			mErrHint = "支付失败";
			Toast.makeText(mActivity, mErrHint, Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 支付失败！ ", "",
			// "确定", null, null, false, null);
			return true;
		} else if (str.equalsIgnoreCase("cancel")) {
			mErrHint = "你已取消了本次订单的支付！";
			Toast.makeText(mActivity, mErrHint, Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 你已取消了本次订单的支付！ ",
			// "", "确定", null, null, false, null);
			return true;
		}

		return false;
	}

	private void checkPay(String hint) {
		Intent nResultIntent = new Intent();
		nResultIntent.putExtra(Run.EXTRA_VALUE, mPaymentStatus);

		if (mPaymentStatus) {
			mActivity.setResult(Activity.RESULT_OK, nResultIntent);
			finishActivity();
		}
	}

	void parsePaymentIndex(JSONObject paymentIndex) {
		mPaymentIndex = paymentIndex;
		mOrderJsonObject = mPaymentIndex.optJSONObject("order");
		mPaymentSettingJsonObject = mPaymentIndex.optJSONObject("setting");
		mMemberInfoJsonObject = mPaymentIndex.optJSONObject("memberInfo");

		mChangePaymentInterface.setData(mOrderJsonObject.optString("order_id"), mOrderJsonObject.optString("currency"));

		String mAmountText = mOrderJsonObject.optString("current_amount_text");
		((TextView) findViewById(R.id.amount)).setText(TextUtils.isEmpty(mAmountText) ? mOrderJsonObject.optString("cur_money_format") : mAmountText);

		((TextView) findViewById(R.id.paied_amount)).setText(mMemberInfoJsonObject.optString("deposit_money_format"));

		String nButtonString = mPaymentSettingJsonObject.optString("pay_btn");
		mSubmitButton.setEnabled(!TextUtils.isEmpty(nButtonString));
		if (TextUtils.isEmpty(nButtonString)) {
			nButtonString = mPaymentSettingJsonObject.optString("no_btn_message");
		}
		mSubmitButton.setText(TextUtils.isEmpty(nButtonString) ? "无法支付" : nButtonString);

		JSONObject nSelectedPayment = null;

		mPaymentJsonObjects.clear();
		mCombinationJsonObjects.clear();
		JSONArray nArray = mPaymentIndex.optJSONArray("payments");
		if (nArray != null && nArray.length() > 0) {
			for (int i = 0, c = nArray.length(); i < c; i++) {
				JSONObject nJsonObject = nArray.optJSONObject(i);
				mPaymentJsonObjects.add(nJsonObject);
				if (nJsonObject.optBoolean("checked")) {
					nSelectedPayment = nJsonObject;
				}
			}
		}

		nArray = mPaymentIndex.optJSONArray("combination_pay_payments");
		if (nArray != null && nArray.length() > 0) {
			try {
				for (int i = 0, c = nArray.length(); i < c; i++) {
					mCombinationJsonObjects.add(nArray.optJSONObject(i));
					mCombinationJsonObjects.get(i).put("checked", false);
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		mJsonObjects.clear();
		mJsonObjects.addAll(mIsCombination ? mCombinationJsonObjects : mPaymentJsonObjects);
		mAdapter.notifyDataSetChanged();

		if (StringUtils.getString(nSelectedPayment, "app_id").equals("deposit")) {
			boolean nCanCombination = mPaymentSettingJsonObject.optBoolean("combination_pay");
			if (nCanCombination && mMemberInfoJsonObject.optDouble("deposit_money") <= 0) {
				Run.alert(mActivity, "您还没有预存款，请选择其它支付方式或充值后再选择预存款支付");
			} else if (nCanCombination && mMemberInfoJsonObject.optDouble("cur_money") > 0) {
				mDialog = CommonLoginFragment.showAlertDialog(mActivity, "您好，您的余额已不足", "取消", "去组合支付", null, new OnClickListener() {// ok

							@Override
							public void onClick(View v) {
								// TODO Auto-generated method
								// stub
								switchCombination(true);
								mDialog.dismiss();
							}
						}, false, null);
			}
		}
	}

	void assignmentCombinationAmount() {
		if (mCombinationAmountJsonObject == null) {
			return;
		}

		Run.log(mCombinationAmountJsonObject);

		((TextView) findViewById(R.id.paied_amount)).setText(mCombinationAmountJsonObject.optString("deposit_money"));

		((TextView) findViewById(R.id.wait_pay_amount)).setText(Html.fromHtml(String.format(AMOUNT_WITH_BRIEF, "您可以选择其他支付方式支付剩余金额：", mCombinationAmountJsonObject.optString("cur_money"))));
	}

	void switchCombination(boolean isCombination) {
		mIsCombination = isCombination;
		if (mIsCombination) {
			findViewById(R.id.combination_pay_title_ll).setVisibility(View.VISIBLE);
			findViewById(R.id.pay_title_ll).setVisibility(View.GONE);
			mJsonObjects.clear();
			mJsonObjects.addAll(mCombinationJsonObjects);
			mCurCombinationPayment = null;

			if (mCombinationJsonObjects.size() > 0) {
				try {
					mCombinationJsonObjects.get(0).put("checked", true);
					mChangeCombinationPaymentInterface.changeCombinationPayment(mCombinationJsonObjects.get(0).optString("app_id"), mMemberInfoJsonObject.optDouble("cur_money"),
							mMemberInfoJsonObject.optDouble("deposit_money"));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			mAdapter.notifyDataSetChanged();
			mSubmitButton.setText("组合支付");
			mSubmitButton.setEnabled(true);
		} else {
			findViewById(R.id.combination_pay_title_ll).setVisibility(View.GONE);
			findViewById(R.id.pay_title_ll).setVisibility(View.VISIBLE);
			mJsonObjects.clear();
			mJsonObjects.addAll(mPaymentJsonObjects);
			mAdapter.notifyDataSetChanged();

			String nButtonString = mPaymentSettingJsonObject.optString("pay_btn");
			mSubmitButton.setEnabled(!TextUtils.isEmpty(nButtonString));
			if (TextUtils.isEmpty(nButtonString)) {
				nButtonString = mPaymentSettingJsonObject.optString("no_btn_message");
			}
			mSubmitButton.setText(TextUtils.isEmpty(nButtonString) ? "无法支付" : nButtonString);
		}
	}

	// 打开输入支付密码界面
	private void openInputPayPasswordFrame(final String totalAmount) {

		if (!AgentApplication.getLoginedUser(mActivity).getPayPassword()) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW));
		} else
			InputPayPasswordDialog.openDialog(mActivity, new OnPayPasswordListener() {

				@Override
				public void onResult(final String payPassword) {
					// 验证支付密码是否正确
					new CheckPayPasswordInterface(ShoppingPayMethodFragment.this, payPassword) {

						@Override
						public void Correct() {
							// TODO Auto-generated method stub
							mPaymentInterface.reset();
							if (mIsCombination) {
								mPaymentInterface.setCombinationParams(mCurCombinationPayment.optString("app_id"), mCombinationAmountJsonObject, mMemberInfoJsonObject.optDouble("deposit_money"));
							}
							mPaymentInterface.pay(mPaymentIndex, mCurPayment, payPassword);
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
					return totalAmount;
				}
			});
	}
}