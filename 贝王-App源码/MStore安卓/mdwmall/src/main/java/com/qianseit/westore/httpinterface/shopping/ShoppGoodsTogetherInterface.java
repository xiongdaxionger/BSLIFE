package com.qianseit.westore.httpinterface.shopping;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppGoodsTogetherInterface extends BaseHttpInterfaceTask {

	public ShoppGoodsTogetherInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.fororder";
	}
}
