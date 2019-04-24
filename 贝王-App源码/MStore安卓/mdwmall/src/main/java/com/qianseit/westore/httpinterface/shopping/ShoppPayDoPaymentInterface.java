package com.qianseit.westore.httpinterface.shopping;

import org.json.JSONObject;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppPayDoPaymentInterface extends BaseHttpInterfaceTask {

	JSONObject mPaymentIndex;
	JSONObject mOrderJsonObject;
	JSONObject mPaymentJsonObject;
	String mPassword;

	boolean mIsCombinationPay = false;
	String mCombinationPayId;
	double mDepositAmount = 0;
	JSONObject mCombinationAmountJsonObject;

	public ShoppPayDoPaymentInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.paycenter.dopayment";
	}

	public void reset() {
		mIsCombinationPay = false;
		mCombinationPayId = "";
		mCombinationAmountJsonObject = null;
	}

	/**
	 * @param combinationPayId
	 * @param combinationAmountJsonObject
	 * @param depositAmount
	 *            预存款支付金额
	 */
	public void setCombinationParams(String combinationPayId, JSONObject combinationAmountJsonObject, double depositAmount) {
		mIsCombinationPay = true;
		mCombinationAmountJsonObject = combinationAmountJsonObject;
		mCombinationPayId = combinationPayId;
		mDepositAmount = depositAmount;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (mOrderJsonObject != null) {
			nContentValues.put("order_id", mOrderJsonObject.optString("order_id"));
			nContentValues.put("cur_money", mIsCombinationPay ? String.valueOf(mDepositAmount) : mOrderJsonObject.optString("cur_money"));
			nContentValues.put("pay_app_id", mPaymentJsonObject.optString("app_id"));
		}

		if (mIsCombinationPay) {
			nContentValues.put("combination_pay", "true");
			nContentValues.put("other_online_cur_money", mCombinationAmountJsonObject.optString("cur_money_val"));
			nContentValues.put("other_online_pay_app_id", mCombinationPayId);
		}

		if (!TextUtils.isEmpty(mPassword)) {
			nContentValues.put("pay_password", mPassword);
		}
		return nContentValues;
	}

	public void pay(JSONObject paymentIndex, JSONObject paymentJsonObject) {
		pay(paymentIndex, paymentJsonObject, "");
	}

	public void pay(JSONObject paymentIndex, JSONObject paymentJsonObject, String payPassword) {
		if (paymentIndex == null || paymentJsonObject == null || !paymentIndex.has("order")) {
			return;
		}
		mPaymentIndex = paymentIndex;
		mOrderJsonObject = mPaymentIndex.optJSONObject("order");
		mPaymentJsonObject = paymentJsonObject;
		mPassword = payPassword;
		RunRequest();
	}
}
