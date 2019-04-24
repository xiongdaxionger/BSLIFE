package com.qianseit.westore.httpinterface.shopping;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 *6.1 创建订单
 */
public abstract class ShoppOrderCreateInterface extends BaseHttpInterfaceTask {

	public ShoppOrderCreateInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.create";
	}
}
