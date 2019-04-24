package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin 3.12 获取配送方式
 */
public abstract class ShoppCarGetShippingsInterface extends BaseHttpInterfaceTask {

	String mAreaId;
	boolean mIsFastBuy = false;

	public ShoppCarGetShippingsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.delivery_change";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("area", mAreaId);
		nContentValues.put("isfastbuy", mIsFastBuy ? "1" : "0");
		return nContentValues;
	}

	/**
	 * @param areaId
	 *            最后级区域id
	 */
	public void getShippings(String areaId, boolean isfastbuy) {
		mAreaId = areaId;
		mIsFastBuy = isfastbuy;
		RunRequest();
	}
}
