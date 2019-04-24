package com.qianseit.westore.httpinterface.index;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GetGroupInterface extends BaseHttpInterfaceTask {
	String mType = "2";

	public GetGroupInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "starbuy.special.index";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type_id", mType);
		return nContentValues;
	}
	
	/**
	 * @param type 促销类型(1 => 团购, 2 => 秒杀)
	 */
	public void getGroup(int type){
		mType = String.valueOf(type);
		RunRequest();
	}
}
