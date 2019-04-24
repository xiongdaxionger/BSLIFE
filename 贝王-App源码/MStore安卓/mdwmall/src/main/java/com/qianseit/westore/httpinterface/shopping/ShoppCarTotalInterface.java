package com.qianseit.westore.httpinterface.shopping;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *3.16 重新计算订单总额
 */
public abstract class ShoppCarTotalInterface extends BaseHttpInterfaceTask {

	public ShoppCarTotalInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.total";
	}
}
