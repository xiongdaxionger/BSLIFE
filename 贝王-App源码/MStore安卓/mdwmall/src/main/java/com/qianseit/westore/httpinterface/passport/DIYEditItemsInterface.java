package com.qianseit.westore.httpinterface.passport;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.19 编辑个人资料
 */
public abstract class DIYEditItemsInterface extends BaseHttpInterfaceTask {

	public DIYEditItemsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.setting";
	}
}
