package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsAssociateInterface extends BaseHttpInterfaceTask {

	String mSearchKey;
	
	public GoodsAssociateInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.search.associate";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("value", mSearchKey);
		return nContentValues;
	}
	
	public void getAssociate(String searchKey){
		mSearchKey = searchKey;
		RunRequest();
	}
}
