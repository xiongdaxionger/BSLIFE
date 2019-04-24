package com.qianseit.westore.httpinterface.wealth;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 10.7 删除已绑定的银行卡
 */
public abstract class WealthBankCardDeleteInterface extends BaseHttpInterfaceTask {
	
	String mBankId;
	public WealthBankCardDeleteInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.delete_bankcard";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_bank_id", mBankId);
		return nContentValues;
	}
	
	public void delete(String bankId){
		mBankId = bankId;
		RunRequest();
	}
}
