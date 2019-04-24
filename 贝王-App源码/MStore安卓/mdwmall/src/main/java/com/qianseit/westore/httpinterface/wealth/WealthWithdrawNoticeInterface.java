package com.qianseit.westore.httpinterface.wealth;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 10.6 提现说明
 */
public abstract class WealthWithdrawNoticeInterface extends BaseHttpInterfaceTask {

	public WealthWithdrawNoticeInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.withdrawalNotice";
	}
}
