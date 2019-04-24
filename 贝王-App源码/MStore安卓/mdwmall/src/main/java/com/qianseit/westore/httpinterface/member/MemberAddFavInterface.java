package com.qianseit.westore.httpinterface.member;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberAddFavInterface extends BaseHttpInterfaceTask {
	String mGoodsIdString;
	String mType = "goods";
	
	public MemberAddFavInterface(QianseitActivityInterface activityInterface, String goodsString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mGoodsIdString = goodsString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.ajax_fav";
	}
	
	public void addFav(String goodsId){
		mGoodsIdString = goodsId;
		RunRequest();
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("gid", mGoodsIdString);
		nContentValues.put("type", mType);
		return nContentValues;
	}
}
