package com.qianseit.westore.httpinterface.passport;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 5.9 会员登录页面
 */
public abstract class LoginInfoInterface extends BaseHttpInterfaceTask {

	public LoginInfoInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.login";
	}
}
