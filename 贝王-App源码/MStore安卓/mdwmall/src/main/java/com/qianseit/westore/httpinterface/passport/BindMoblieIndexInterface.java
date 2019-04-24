package com.qianseit.westore.httpinterface.passport;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 5.20 绑定帐号的页面（第三方登录）
 */
public abstract class BindMoblieIndexInterface extends BaseHttpInterfaceTask {

	public BindMoblieIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "trustlogin.trustlogin.bind_login";
	}
}
