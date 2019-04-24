package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *6.7 组合支付计算订单支付金额
 */
public abstract class ShoppPayChangeCombinationPaymentInterface extends BaseHttpInterfaceTask {
	String mCombinationPaymentId;
	double mWaitAmount;
	double mDepositAmount;

	public ShoppPayChangeCombinationPaymentInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.paycenter.get_payment_money";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("payment[pay_app_id]", mCombinationPaymentId);
		nContentValues.put("payment[cur_money]", String.valueOf(mWaitAmount));
		nContentValues.put("payment[deposit_pay_money]", String.valueOf(mDepositAmount));
		return nContentValues;
	}
	
	/**
	 * @param combinationPaymentId 组合支付方式id
	 * @param waitAmount 剩余支付金额
	 * @param depositAmount 预存款已支付金额
	 */
	public void changeCombinationPayment(String combinationPaymentId, double waitAmount, double depositAmount){
		mWaitAmount = waitAmount;
		mDepositAmount = depositAmount;
		mCombinationPaymentId = combinationPaymentId;
		RunRequest();
	}
}
