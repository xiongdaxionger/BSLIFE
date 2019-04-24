package com.qianseit.westore.httpinterface.shopping;


import org.json.JSONObject;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppingDopaymentInterface extends BaseHttpInterfaceTask {

	String mOrderIdString;
	String mCurAmountString;
	String mPaymentIdString;
	public ShoppingDopaymentInterface(QianseitActivityInterface activityInterface, String orderIdString, String curAmountString, String paymentIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
		mCurAmountString = curAmountString;
		mPaymentIdString = paymentIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.paycenter.dopayment";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		JSONObject data = responseJson.optJSONObject("data");
		String payAppId = data.optString("pay_app_id");
		if ("malipay".equals(payAppId)) {
			// 支付宝
			PayAlipay(data);
			return;
		} else if ("wxpayjsapi".equals(payAppId)) {
			// 微信
			PayWechat(data);
		} else if ("wapupacp".equals(payAppId)) {// 银联支付
			// “00” – 银联正式环境
			// “01” – 银联测试环境，该环境中不发生真实交易
			if (data.has("tn")){
				PayUP(data);
			}
		} else {
			PayPreDeposit(data);
		}
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("payment_order_id", mOrderIdString);
		nContentValues.put("payment_cur_money", mCurAmountString);
		nContentValues.put("payment_pay_app_id", PaymentId());

		return nContentValues;
	}
	
	public abstract void PayWechat(JSONObject payData);
	public abstract void PayAlipay(JSONObject payData);
	public abstract void PayUP(JSONObject payData);
	public abstract void PayPreDeposit(JSONObject payData);
	public String PaymentId(){
		return mPaymentIdString;
	}
}
