package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberReceiverAddrInterface extends BaseHttpInterfaceTask {

	public String mSelectMemberID;

	public MemberReceiverAddrInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.receiver";
	}

	@Override
	public ContentValues BuildParams() {
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mSelectMemberID);
		return nContentValues;
	}

	public void getAddressList(String memberID){
		mSelectMemberID = memberID;
		RunRequest();
	}
}
