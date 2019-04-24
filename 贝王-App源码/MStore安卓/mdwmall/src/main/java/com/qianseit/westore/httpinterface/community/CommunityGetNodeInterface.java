package com.qianseit.westore.httpinterface.community;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 10.4 获取发现主页目录
 * @author qianseit
 *
 */
public abstract class CommunityGetNodeInterface extends BaseHttpInterfaceTask {

	public CommunityGetNodeInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.discover.getnode";
	}
}
