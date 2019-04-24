package com.qianseit.westore.httpinterface.statistics;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.2 收入统计
 * 收入统计
 * @author qianseit
 *
 */
public abstract class IncomeInterface extends BaseHttpInterfaceTask {

	public IncomeInterface(BaseDoFragment baseDoFragment) {
		super(baseDoFragment);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "distribution.stats.income";
	}
}
