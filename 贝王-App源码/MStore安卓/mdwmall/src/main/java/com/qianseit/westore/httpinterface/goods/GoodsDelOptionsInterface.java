package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsDelOptionsInterface extends BaseHttpInterfaceTask {
	String mOptionsIdString;
	public GoodsDelOptionsInterface(QianseitActivityInterface activityInterface, String optionsIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOptionsIdString = optionsIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.del_opinions";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("opinions_id", mOptionsIdString);
		return nContentValues;
	}
}
