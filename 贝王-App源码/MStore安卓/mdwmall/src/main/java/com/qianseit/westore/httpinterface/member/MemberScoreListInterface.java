package com.qianseit.westore.httpinterface.member;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.2 积分历史
 */
public abstract class MemberScoreListInterface extends BaseHttpInterfaceTask {

	public MemberScoreListInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.point_history";
	}
}
