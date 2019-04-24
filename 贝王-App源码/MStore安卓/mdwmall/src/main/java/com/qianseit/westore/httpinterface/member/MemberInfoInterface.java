package com.qianseit.westore.httpinterface.member;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberInfoInterface extends BaseHttpInterfaceTask {

	String mMemberIdString;
	public MemberInfoInterface(QianseitActivityInterface activityInterface, String memberIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMemberIdString = memberIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_member_info";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("son_object", "json");
		nContentValues.put("member_id", mMemberIdString);
		return nContentValues;
	}
}
