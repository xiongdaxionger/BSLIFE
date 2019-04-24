package com.qianseit.westore.httpinterface.wealth;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 10.1 钱包首页接口
 */
public abstract class WealthIndexInterface extends BaseHttpInterfaceTask {

	public WealthIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.index";
	}

}
