package com.qianseit.westore.httpinterface.passport;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *5.2 注册
 */
public abstract class RegistrMemberInterface extends BaseHttpInterfaceTask {

	public RegistrMemberInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.create";
	}

	public static class Gender {
		/**
		 * 男
		 */
		public static String BOY = "male";
		/**
		 * 女
		 */
		public static String GIRL = "female";
	}
}
