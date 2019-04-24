package com.qianseit.westore.httpinterface.wealth;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 10.5 提交提现申请
 */
public abstract class WealthWithdrawInterface extends BaseHttpInterfaceTask {

	String mMoney, mBankId, mPayPassword;
	public WealthWithdrawInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.withdrawal";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("money", mMoney);
		nContentValues.put("member_bank_id", mBankId);
		nContentValues.put("pay_password", mPayPassword);
		return nContentValues;
	}
	public void withdraw(String money, String bankId, String payPassword){
		mMoney = money;
		mBankId = bankId;
		mPayPassword = payPassword;
		RunRequest();
	}
}
