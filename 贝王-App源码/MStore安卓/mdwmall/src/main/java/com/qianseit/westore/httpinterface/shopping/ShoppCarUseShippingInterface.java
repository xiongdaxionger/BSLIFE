package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 * 3.13 选择配送方式
 */
public abstract class ShoppCarUseShippingInterface extends BaseHttpInterfaceTask {
	String mShipping;

	public ShoppCarUseShippingInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.delivery_confirm";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("shipping", mShipping);
		return nContentValues;
	}
	
	/**
	 * @param shipping {"id":2,"has_cod":"true","dt_name":"货到付款","money":"15"}
	 */
	public void useShipping(String shipping){
		mShipping= shipping;
		RunRequest();
	}
}
