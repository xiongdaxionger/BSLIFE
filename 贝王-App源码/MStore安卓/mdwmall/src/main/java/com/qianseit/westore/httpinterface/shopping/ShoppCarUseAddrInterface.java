package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 *3.11 选择收货地址
 */
public abstract class ShoppCarUseAddrInterface extends BaseHttpInterfaceTask {
	String mAddress;

	public ShoppCarUseAddrInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.shipping_confirm";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("address", mAddress);
		return nContentValues;
	}
	
	/**
	 * @param address {"addr_id":11094,"area":"3"}
	 */
	public void useAddr(String address){
		mAddress= address;
		RunRequest();
	}
}
