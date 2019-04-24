package com.qianseit.westore.activity.wealth;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.alipay.client.AliPayFragment;
import com.alipay.client.PayResult;
import com.qianseit.westore.Run;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.base.UPPayInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayChangePaymentInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayCheckPayStatus;
import com.qianseit.westore.httpinterface.wealth.WealthRechargeInterface;
import com.beiwangfx.R;
import com.unionpay.UPPayAssistEx;

public class WealthRechargePayFragment extends AliPayFragment {

	String mErrHint = "";
	JSONObject mRechargeJsonObject;
	double mRechargeValue = 0.00;
	String mCurrency = "￥";

	TextView mAmountTextView, mPayAmountTextView;

	private JSONObject mCurPayment;
	String mOrderId;

	Dialog mDialog;

	ListView mListView;
	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();
	List<JSONObject> mPaymentJsonObjects = new ArrayList<JSONObject>();
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
						try {
							for (JSONObject item : mJsonObjects) {
								item.put("checked", false);
							}
							nItem.put("checked", true);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						notifyDataSetChanged();
						// mChangePaymentInterface.changePayment(nItem.optString("app_id"));
					}
				});
			}
			JSONObject nItem = getItem(position);
			String nAppname = nItem.optString("app_display_name");

			((TextView) convertView.findViewById(R.id.pay_name)).setText(nAppname);
			((TextView) convertView.findViewById(R.id.pay_content)).setText(nItem.optString("app_pay_brief"));
			((CheckBox) convertView.findViewById(R.id.pay_checkbox)).setChecked(nItem.optBoolean("checked"));
			if (nItem.optBoolean("checked")) {
				mCurPayment = nItem;
			}

			// 支付方式图标
			String appicon = nItem.optString("icon_src");
			ImageView iconView = (ImageView) convertView.findViewById(R.id.pay_icon);
			if (!TextUtils.isEmpty(appicon)) {
				displayImage(iconView, appicon, R.drawable.default_pay);
			} else {
				if (nAppname.contains("分享")) {
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
	ListView mGiftListView;
	List<JSONObject> mGiftJsonObjects = new ArrayList<JSONObject>();
	QianseitAdapter<JSONObject> mGiftAdapter = new QianseitAdapter<JSONObject>(mGiftJsonObjects) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_recharge_gift, null);
				convertView.findViewById(R.id.recharge).setVisibility(View.GONE);
			}

			JSONObject nJsonObject = getItem(position);
			((TextView) convertView.findViewById(R.id.sub_title)).setText(String.format("充值%s%s 赠", nJsonObject.optString("price_min"), mCurrency));
			((TextView) convertView.findViewById(R.id.title)).setText(nJsonObject.optString("song"));
			((TextView) convertView.findViewById(R.id.brief)).setText(nJsonObject.optString("brief"));
			convertView.findViewById(R.id.recharge).setTag(nJsonObject);

			return convertView;
		}
	};

	WealthRechargeInterface mRechargeInterface = new WealthRechargeInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mOrderId = responseJson.optJSONArray("orders").optJSONObject(0).optString("bill_id");
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
				if (responseJson.optJSONObject("data").has("tn")) {

					String serverMode = "00";
					UPPayAssistEx.startPay(mActivity, null, null, responseJson.optJSONObject("data").optString("tn"), serverMode);
				}
			}
			else {
				mPaymentStatus = true;
				checkPay(null);
			}
		}
	};
	ShoppPayChangePaymentInterface mChangePaymentInterface = new ShoppPayChangePaymentInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			parseIndex(responseJson);
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
		mActionBar.setTitle("充值确认");

		try {
			mRechargeJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
			mRechargeValue = getExtraDoubleFromBundle(Run.EXTRA_VALUE);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
		rootView = inflater.inflate(R.layout.fragment_wealth_recharge_pay, null);

		mAmountTextView = (TextView) findViewById(R.id.amount);
		mPayAmountTextView = (TextView) findViewById(R.id.amount_pay);

		findViewById(R.id.submit).setOnClickListener(this);

		mListView = (ListView) findViewById(R.id.payments);
		mListView.setAdapter(mAdapter);

		mGiftListView = (ListView) findViewById(R.id.recharge_gift_lv);
		mGiftListView.setAdapter(mGiftAdapter);

		parseIndex(mRechargeJsonObject);
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.submit) {
			v.setEnabled(false);

			if (mCurPayment != null) {
				mRechargeInterface.recharge(mCurPayment.optString("app_id"), mRechargeValue);
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
					checkPay(mErrHint);
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
			checkPay(mErrHint);
			// CommonLoginFragment.showAlertDialog(mActivity, " 支付失败！ ", "",
			// "确定", null, null, false, null);
			return true;
		} else if (str.equalsIgnoreCase("cancel")) {
			mErrHint = "你已取消了本次订单的支付！";
			Toast.makeText(mActivity, mErrHint, Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			checkPay(mErrHint);
			// CommonLoginFragment.showAlertDialog(mActivity, " 你已取消了本次订单的支付！ ",
			// "", "确定", null, null, false, null);
			return true;
		}

		return false;
	}

	private void checkPay(String hint) {
		if (!mPaymentStatus) {
			return;
		}
		
		findViewById(R.id.pay_mothod_ll).setVisibility(View.GONE);
		Intent nResultIntent = new Intent();
		nResultIntent.putExtra(Run.EXTRA_VALUE, mPaymentStatus);

		if (mPaymentStatus) {
			mActivity.setResult(Activity.RESULT_OK, nResultIntent);
			mActivity.finish();
		}
	}

	void parseIndex(JSONObject rechargeInfo) {
		if (rechargeInfo == null) {
			return;
		}

		mCurrency = rechargeInfo.optString("def_cur_sign");
		mAmountTextView.setText(String.format("%s%.2f", mCurrency, mRechargeValue));
		mPayAmountTextView.setText(String.format("%s%.2f", mCurrency, mRechargeValue));

		JSONObject nJsonObject = rechargeInfo.optJSONObject("active");
		if (nJsonObject == null) {
			return;
		}
		nJsonObject = nJsonObject.optJSONObject("recharge");
		if (nJsonObject == null) {
			return;
		}

		JSONArray nArray = nJsonObject.optJSONArray("filter");
		if (nArray == null || nArray.length() <= 0) {
			return;
		}

		mGiftJsonObjects.clear();
		JSONObject nGiftJsonObject = null;
		double nMaxValue = 0;
		for (int i = 0; i < nArray.length(); i++) {
			nJsonObject = nArray.optJSONObject(i);
			double nValue = nJsonObject.optDouble("price_min");
			if (mRechargeValue >= nValue && nValue >= nMaxValue) {
				nGiftJsonObject = nJsonObject;
				nMaxValue = nValue;
			}
		}
		if (nGiftJsonObject != null) {
			mGiftJsonObjects.add(nGiftJsonObject);
		}
		mGiftAdapter.notifyDataSetChanged();
		findViewById(R.id.recharge_gift).setVisibility(mGiftJsonObjects.size() > 0 ? View.VISIBLE : View.GONE);

		JSONObject nSelectedPayment = null;
		mPaymentJsonObjects.clear();
		nArray = rechargeInfo.optJSONArray("payments");
		if (nArray != null && nArray.length() > 0) {
			try {
				for (int i = 0, c = nArray.length(); i < c; i++) {
					nJsonObject = nArray.optJSONObject(i);
					nJsonObject.put("checked", i == 0);
					mPaymentJsonObjects.add(nJsonObject);
					if (nJsonObject.optBoolean("checked")) {
						nSelectedPayment = nJsonObject;
					}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		mJsonObjects.clear();
		mJsonObjects.addAll(mPaymentJsonObjects);
		mAdapter.notifyDataSetChanged();
	}
}