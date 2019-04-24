package com.qianseit.westore.httpinterface.shopping;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsBrandInterface extends BaseHttpInterfaceTask {

	String mBrandIdString;
	/**
	 * @param activityInterface
	 * @param brandIdString "all" 查询全部
	 */
	public GoodsBrandInterface(QianseitActivityInterface activityInterface, String brandIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mBrandIdString = brandIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("brand_id", mBrandIdString);
		return nContentValues;
	}

}
