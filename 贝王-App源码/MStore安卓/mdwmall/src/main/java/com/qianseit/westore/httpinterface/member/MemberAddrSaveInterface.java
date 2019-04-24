package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 * 4.13 保存收货地址
 *
 */
public abstract class MemberAddrSaveInterface extends BaseHttpInterfaceTask {

	String mSelectMemberID;

	public MemberAddrSaveInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.save_rec";
	}

	public void getCreateAddress(String memberID){
		mSelectMemberID = memberID;
		RunRequest();
	}
}
