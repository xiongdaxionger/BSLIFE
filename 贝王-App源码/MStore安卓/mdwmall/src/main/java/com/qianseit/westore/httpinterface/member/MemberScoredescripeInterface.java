package com.qianseit.westore.httpinterface.member;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberScoredescripeInterface extends BaseHttpInterfaceTask {

	
	public MemberScoredescripeInterface(
			QianseitActivityInterface activityInterface) {
		super(activityInterface);
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.point_rule";
	}
}
