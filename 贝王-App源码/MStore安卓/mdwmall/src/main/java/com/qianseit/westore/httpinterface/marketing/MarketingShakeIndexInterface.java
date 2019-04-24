package com.qianseit.westore.httpinterface.marketing;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MarketingShakeIndexInterface extends BaseHttpInterfaceTask {

	public MarketingShakeIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", "1");
		return nContentValues;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "game.yiy.index";
	}
}
