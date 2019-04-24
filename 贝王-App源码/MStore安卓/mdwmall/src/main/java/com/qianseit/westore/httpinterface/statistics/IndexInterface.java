package com.qianseit.westore.httpinterface.statistics;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 6.4 首页统计接口
 * @author qianseit
 *
 */
public abstract class IndexInterface extends BaseHttpInterfaceTask {

	public IndexInterface(BaseDoFragment baseDoFragment) {
		super(baseDoFragment);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "distribution.stats.index";
	}
}
