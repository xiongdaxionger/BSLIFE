package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsDelPraiseInterface extends BaseHttpInterfaceTask {
	String mMemberIdString;
	String mOptionsIdString;
	public GoodsDelPraiseInterface(QianseitActivityInterface activityInterface, String memberIdString, String optionsIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMemberIdString = memberIdString;
		mOptionsIdString = optionsIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.del_opinions_praise";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mMemberIdString);
		nContentValues.put("opinions_id", mOptionsIdString);
		return nContentValues;
	}
}
