package com.qianseit.westore.activity.wealth;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.alipay.client.AliPayFragment;
import com.alipay.client.PayResult;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.base.UPPayInterface;
import com.qianseit.westore.bean.BankInfo;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.beiwangfx.R;
import com.unionpay.UPPayAssistEx;

/**
 * 账户充值 填写充值金额
 * 
 * @author Administrator
 * 
 */
public class WealthPayFragment extends AliPayFragment {

	private Button btnNext;// 确认充值或下一步
	private TextView tvChooseBank;
	private BankInfo bankInfo;// 选择银联支付信息
	private TextView tvBankTitle, tvBankContent;
	private CheckBox cbAliPay;
	private CheckBox cbWeChat;
	private CheckBox cbUnionPay;
	private EditText etInput;
	private boolean mPaymentStatus = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowHomeView(true);
		mActionBar.setShowTitleBar(true);
		mActionBar.setShowBackButton(true);
		mActionBar.setTitle("账户充值 ");
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		boolean pay = Run.loadOptionBoolean(mActivity, "WXPayResult", false);
		if (pay) {
			Run.savePrefs(mActivity, "WXPayResult", false);
			// startActivity(AgentActivity.intentForFragment(mActivity,
// AgentActivity.FRAGMENT_ACCOUNT_ORDERS)
// .putExtra(Run.EXTRA_VALUE, R.id.acco_orders_shipping));
// getActivity().finish();
// startActivity(AgentActivity.intentForFragment(mActivity,
// AgentActivity.FRAGMENT_ACCOUNT_ORDERS).putExtra(
// Run.EXTRA_VALUE, R.id.acco_orders_paying));
			mPaymentStatus = Run.loadOptionBoolean(mActivity, "PayResult", false);
			resetPaymentStatusView();
		}
	}

	private void resetPaymentStatusView() {
		if (mPaymentStatus) {
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		} else {
			Run.alert(mActivity, "账户充值失败");
		}

	}

	@Override
	public void ui(int what, Message msg) {
		switch (msg.what) {
		case SDK_PAY_FLAG: {// 支付宝支付结果
			PayResult payResult = new PayResult((String) msg.obj);

			// 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
			String resultInfo = payResult.getResult();

			String resultStatus = payResult.getResultStatus();

			// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
			if (TextUtils.equals(resultStatus, "9000")) {
				Toast.makeText(mActivity, "支付成功", Toast.LENGTH_SHORT).show();
				// 跳转订单列表
				// startActivity(AgentActivity.intentForFragment(mActivity,
				// AgentActivity.FRAGMENT_ACCOUNT_ORDERS)
				// .putExtra(Run.EXTRA_VALUE, R.id.acco_orders_shipping));
				// getActivity().finish();
				mPaymentStatus = true;
			} else {
				// 判断resultStatus 为非“9000”则代表可能支付失败
				// “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
				if (TextUtils.equals(resultStatus, "8000")) {
					Toast.makeText(mActivity, "支付结果确认中", Toast.LENGTH_SHORT).show();

				} else {
					// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
					// Toast.makeText(mActivity, "支付失败", Toast.LENGTH_SHORT)
					// .show();
					// startActivity(AgentActivity.intentForFragment(mActivity,
					// AgentActivity.FRAGMENT_ACCOUNT_ORDERS).putExtra(
					// Run.EXTRA_VALUE, 0));
					mPaymentStatus = false;
				}
			}
			resetPaymentStatusView();
			break;

		}
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
				}
			});
		}
		rootView = inflater.inflate(R.layout.fragment_wealth_pay, null);
		btnNext = (Button) findViewById(R.id.btn_next);
		tvChooseBank = (TextView) findViewById(R.id.tv_choose_bank);
		tvBankTitle = (TextView) findViewById(R.id.tv_bank_title);
		tvBankContent = (TextView) findViewById(R.id.tv_bank_content);
		cbAliPay = (CheckBox) findViewById(R.id.cb_account_choose_alipay);
		cbWeChat = (CheckBox) findViewById(R.id.cb_account_choose_wechat);
		cbUnionPay = (CheckBox) findViewById(R.id.cb_account_choose_UnionPay);
		etInput = (EditText) findViewById(R.id.et_input);
		btnNext.setOnClickListener(this);
		tvChooseBank.setOnClickListener(this);
		cbAliPay.setOnClickListener(this);
		cbWeChat.setOnClickListener(this);
		cbUnionPay.setOnClickListener(this);
		Run.excuteJsonTask(new JsonTask(), new GetPaymentList());
	}

	@Override
	public void onClick(View v) {
		if (v == btnNext) {
			String iputText = etInput.getText().toString().trim();
			if (TextUtils.isEmpty(iputText)) {
				Run.alert(mActivity, "请输入金额");
				return;
			}

			if (cbUnionPay.isChecked() && (rootView.findViewById(R.id.rl_item3).getVisibility() == View.VISIBLE)) {
				JsonRequestBean bean = buildCreateOrderRequestBean((JSONObject) cbUnionPay.getTag());
				if (bean != null) {
					Run.excuteJsonTask(new JsonTask(), new DoPaymentTask(bean));
				}
			} else if (cbAliPay.isChecked() && (rootView.findViewById(R.id.rl_item1).getVisibility() == View.VISIBLE)) {
				JsonRequestBean bean = buildCreateOrderRequestBean((JSONObject) cbAliPay.getTag());
				if (bean != null) {
					Run.excuteJsonTask(new JsonTask(), new DoPaymentTask(bean));
				}
			} else if (cbWeChat.isChecked() && (rootView.findViewById(R.id.rl_item2).getVisibility() == View.VISIBLE)) {
				JsonRequestBean bean = buildCreateOrderRequestBean((JSONObject) cbWeChat.getTag());
				if (bean != null) {
					Run.excuteJsonTask(new JsonTask(), new DoPaymentTask(bean));
				}
			} else {
				Run.alert(mActivity, "请选择充值方式");
			}
		} else if (v == tvChooseBank) {
			cbAliPay.setChecked(false);
			cbWeChat.setChecked(false);
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BANK_CARD).putExtra(Run.EXTRA_TITLE, "选择银行卡"), 1);
		} else if (v == cbUnionPay) {
			cbAliPay.setChecked(false);
			cbWeChat.setChecked(false);
		} else if (v == cbAliPay) {
			cbUnionPay.setChecked(false);
			cbWeChat.setChecked(false);
		} else if (v == cbWeChat) {
			cbAliPay.setChecked(false);
			cbUnionPay.setChecked(false);
		}
	}

	private void clearBankCard() {
		tvBankTitle.setText("银联支付");
		tvBankContent.setText("添加银行卡支付");
		tvChooseBank.setText("选择银行卡");
		btnNext.setText("确认充值");
		bankInfo = null;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == Activity.RESULT_OK) {
			if (data != null) {
				bankInfo = (BankInfo) data.getSerializableExtra("bank");
				tvBankTitle.setText(bankInfo.getBank_name());
				tvBankContent.setText(bankInfo.getBank_num());
				tvChooseBank.setText("更换银行卡");
				btnNext.setText("下一步");
			} else {
				tvBankTitle.setText("银联支付");
				tvBankContent.setText("添加银行卡支付");
				tvChooseBank.setText("选择银行卡");
				btnNext.setText("下一步");
				bankInfo = null;
			}
		}
	}

	private JsonRequestBean buildCreateOrderRequestBean(JSONObject payInfo) {
		try {
			String iputText = etInput.getText().toString().trim();
			if (TextUtils.isEmpty(iputText)) {
				Run.alert(mActivity, "请输入金额");
				return null;
			}
			double input = Double.parseDouble(iputText);
			if (input <= 0) {
				Run.alert(mActivity, "输入金额必须大于0");
				return null;
			}

			// if (input < 1 || input > 10000) {
			// Run.alert(mActivity, "输入充值金额必须在1元到1万元之间");
			// return null;
			// }

			JSONObject payment = new JSONObject();
			payment.put("pay_app_id", payInfo.optString("app_id"));
			payment.put("app_pay_type", payInfo.optString("app_pay_type"));
			payment.put("payment_name", payInfo.optString("app_display_name"));
			JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.paycenter.dopayment").addParams("pay_object", "recharge").addParams("payment_pay_app_id", payInfo.optString("app_id"))
					.addParams("payment_cur_money", String.valueOf(input)).addParams("body", getString(R.string.app_name) + "预存款充值").addParams("source", "66card");
			AgentApplication.getApp(mActivity).payMoney = String.valueOf(input);
			return bean;
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		AgentApplication.getApp(mActivity).payMoney = null;
	}

	class DoPaymentTask implements JsonTaskHandler {
		private JsonRequestBean bean;

		public DoPaymentTask(JsonRequestBean bean) {
			this.bean = bean;
		}

		@Override
		public void task_response(String json_str) {
			try {
				hideLoadingDialog_mt();
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					String payName = all.optJSONObject("data").optString("pay_app_id");
					if (payName.equals("malipay")) {
						callAliPay(all.optJSONObject("data"));
						return;
					} else if (payName.equals("wxpayjsapi")) {
						callWXPay(all.optJSONObject("data"));
					} else if ("wapupacp".equals(payName)) {// 银联支付
						// “00” – 银联正式环境
						// “01” – 银联测试环境，该环境中不发生真实交易
						if (all.optJSONObject("data").has("tn")){

							String serverMode = "00";
							UPPayAssistEx.startPay(mActivity, null, null, all.optJSONObject("data").optString("tn"), serverMode);
						}
					} else {
						mPaymentStatus = all.optJSONObject("data").optString("msg").contains("成功");
						resetPaymentStatusView();
					}
				}
			} catch (Exception e) {
			}
		}

		@Override
		public JsonRequestBean task_request() {
			showLoadingDialog();
			return bean;
		}

	}

	class GetPaymentList implements JsonTaskHandler {

		@Override
		public void task_response(String json_str) {
			try {
				hideLoadingDialog_mt();
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					JSONArray array = all.getJSONArray("data");
					for (int i = 0; i < array.length(); i++) {
						JSONObject obj = array.getJSONObject(i);
						String payId = obj.getString("app_rpc_id");
						if ("wxpayjsapi".equalsIgnoreCase(payId)) { // 微信
							cbWeChat.setTag(obj);
							rootView.findViewById(R.id.rl_item2).setVisibility(View.VISIBLE);
							((TextView) rootView.findViewById(R.id.tv_title2)).setText(obj.optString("app_display_name"));
							displaySquareImage((ImageView) rootView.findViewById(R.id.iv_head2), obj.optString("icon_src"));
							((TextView) rootView.findViewById(R.id.tv_content2)).setText(obj.optString("app_info"));
						} else if ("malipay".equalsIgnoreCase(payId)) {// 支付宝
							cbAliPay.setTag(obj);
							rootView.findViewById(R.id.rl_item1).setVisibility(View.VISIBLE);
							String disName = obj.optString("app_display_name");
							disName ="支付宝支付";
							((TextView) rootView.findViewById(R.id.tv_title1)).setText(disName);
							displaySquareImage((ImageView) rootView.findViewById(R.id.iv_head1), obj.optString("icon_src"));
							((TextView) rootView.findViewById(R.id.tv_content1)).setText(obj.optString("app_info"));
						} else if ("wapupacp".equalsIgnoreCase(payId)) { // 银联
							cbUnionPay.setTag(obj);
							rootView.findViewById(R.id.rl_item3).setVisibility(View.VISIBLE);
							((TextView) rootView.findViewById(R.id.tv_title3)).setText(obj.optString("app_display_name"));
							displaySquareImage((ImageView) rootView.findViewById(R.id.iv_head3), obj.optString("icon_src"));
							((TextView) rootView.findViewById(R.id.tv_content3)).setText(obj.optString("app_info"));
						}
					}
				}
			} catch (Exception e) {
			} finally {
				if (rootView.findViewById(R.id.rl_item2).getVisibility() == View.VISIBLE) {
					cbWeChat.setChecked(true);
				} else if (rootView.findViewById(R.id.rl_item3).getVisibility() == View.VISIBLE) {
					cbUnionPay.setChecked(true);
				} else if (rootView.findViewById(R.id.rl_item1).getVisibility() == View.VISIBLE) {
					cbAliPay.setChecked(true);
				}
			}
		}

		@Override
		public JsonRequestBean task_request() {
			showLoadingDialog();
			return new JsonRequestBean(Run.API_URL, "mobileapi.order.select_payment");
		}

	}

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
					Toast.makeText(mActivity, "支付成功", Toast.LENGTH_SHORT).show();
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
			Toast.makeText(mActivity, "支付失败", Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 支付失败！ ", "",
			// "确定", null, null, false, null);
			return true;
		} else if (str.equalsIgnoreCase("cancel")) {
			Toast.makeText(mActivity, "你已取消了本次订单的支付！", Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 你已取消了本次订单的支付！ ",
			// "", "确定", null, null, false, null);
			return true;
		}

		return false;
	}

}
