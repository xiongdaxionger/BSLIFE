package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 6.3 更换支付方式
 * 第一次调用changePayment 前 需先调用setData设置订单信息，
 */
public abstract class ShoppPayChangePaymentInterface extends BaseHttpInterfaceTask {

	String mOrderId, mCurrency, mPaymentId;
	public ShoppPayChangePaymentInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.payment_change";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderId);
		nContentValues.put("payment[pay_app_id]", mPaymentId);
		nContentValues.put("payment[currency]", mCurrency);
		return nContentValues;
	}
	
	/**
	 * @param orderId
	 * @param currency
	 */
	public void setData(String orderId, String currency){
		mOrderId = orderId;
		mCurrency = currency;
	}
	
	public void changePayment(String paymentId){
		mPaymentId = paymentId;
		RunRequest();
	}
}
