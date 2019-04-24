package com.qianseit.westore.httpinterface.marketing;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MarketingShakeInterface extends BaseHttpInterfaceTask {

	public MarketingShakeInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "game.yiy.action";
	}
}
