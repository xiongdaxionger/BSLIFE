package com.qianseit.westore.httpinterface.passport;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 5.11 会员注册页面
 */
public abstract class DIYRegisterItemsInterface extends BaseHttpInterfaceTask {

	public DIYRegisterItemsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.signup";
	}
}
