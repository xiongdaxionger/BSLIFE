package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin 4.14 删除收货地址
 */
public abstract class MemberAddrDeleteInterface extends BaseHttpInterfaceTask {

	String mAddrId;
	String mSelectMemberID;

	public MemberAddrDeleteInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.del_rec";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("addr_id", mAddrId);
		nContentValues.put("member_id",mSelectMemberID);
		return nContentValues;
	}

	/**
	 * @param addrId
	 */
	public void delete(String addrId,String memberID) {
		mAddrId = addrId;
		mSelectMemberID = memberID;
		RunRequest();
	}
}
