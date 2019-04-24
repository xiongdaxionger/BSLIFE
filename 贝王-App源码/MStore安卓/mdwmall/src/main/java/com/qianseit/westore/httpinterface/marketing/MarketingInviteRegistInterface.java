package com.qianseit.westore.httpinterface.marketing;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 11.3 邀请注册二维码
 */
public abstract class MarketingInviteRegistInterface extends BaseHttpInterfaceTask {

	public MarketingInviteRegistInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.activity.register";
	}
}
