package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsAddOptionsCommentsInterface extends BaseHttpInterfaceTask {
	String mMemberIdString;
	String mOptionsIdString;
	String mContentString;
	public GoodsAddOptionsCommentsInterface(QianseitActivityInterface activityInterface, String memberIdString, String optionsIdString, String contentString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMemberIdString = memberIdString;
		mOptionsIdString = optionsIdString;
		mContentString = contentString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.add_opinions_comment";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mMemberIdString);
		nContentValues.put("opinions_id", mOptionsIdString);
		nContentValues.put("content", mContentString);
		return nContentValues;
	}
}
