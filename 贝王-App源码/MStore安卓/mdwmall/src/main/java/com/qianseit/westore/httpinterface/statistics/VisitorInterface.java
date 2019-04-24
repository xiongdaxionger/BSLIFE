package com.qianseit.westore.httpinterface.statistics;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.3 访问统计
 * @author qianseit
 *
 */
public abstract class VisitorInterface extends BaseHttpInterfaceTask {

	public VisitorInterface(BaseDoFragment baseDoFragment) {
		super(baseDoFragment);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "distribution.stats.visit";
	}
}
