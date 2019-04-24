package com.qianseit.westore.httpinterface.community;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 10.5 获取发现文章列表
 * @author qianseit
 *
 */
public abstract class CommunityGetNewListInterface extends BaseHttpInterfaceTask {
	int mNodeId = -1;

	public CommunityGetNewListInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	public CommunityGetNewListInterface(QianseitActivityInterface activityInterface, int nodeId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mNodeId = nodeId;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.discover.getnewlist";
	}
}
