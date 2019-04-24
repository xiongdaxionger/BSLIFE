package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin 4.11 设置和取消默认地址
 */
public abstract class MemberAddrDefualtInterface extends BaseHttpInterfaceTask {

	String mAddrId;
	/**
	 * 2为设置默认1为取消默认
	 */
	int mDisabled = 1;

	public MemberAddrDefualtInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.set_default";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("addr_id", mAddrId);
		nContentValues.put("disabled", String.valueOf(mDisabled));
		return nContentValues;
	}

	/**
	 * @param addrId
	 * @param isDefualt
	 */
	public void setDefualt(String addrId, boolean isDefualt) {
		mAddrId = addrId;
		mDisabled = isDefualt ? 2 : 1;
		RunRequest();
	}
}
