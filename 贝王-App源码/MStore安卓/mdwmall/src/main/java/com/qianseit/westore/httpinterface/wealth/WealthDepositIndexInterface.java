package com.qianseit.westore.httpinterface.wealth;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.21 会员充值页面
 */
public abstract class WealthDepositIndexInterface extends BaseHttpInterfaceTask {

	public WealthDepositIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.deposit";
	}
}
