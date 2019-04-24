package com.qianseit.westore.httpinterface.member;



import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberUnAttentionInterface extends BaseHttpInterfaceTask {

	String mMemberIdString;
	String mFansIdString;
	public MemberUnAttentionInterface(QianseitActivityInterface activityInterface, String memberIdString, String fansIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMemberIdString = memberIdString;
		mFansIdString = fansIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.member.un_attention";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mMemberIdString);
		nContentValues.put("fans_id", mFansIdString);
		return nContentValues;
	}
}
