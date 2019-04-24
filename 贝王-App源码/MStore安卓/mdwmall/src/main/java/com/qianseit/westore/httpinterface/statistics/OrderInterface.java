package com.qianseit.westore.httpinterface.statistics;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.1 订单统计
 * @author qianseit
 *
 */
public abstract class OrderInterface extends BaseHttpInterfaceTask {

	public OrderInterface(BaseDoFragment baseDoFragment) {
		super(baseDoFragment);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "distribution.stats.order";
	}
}
