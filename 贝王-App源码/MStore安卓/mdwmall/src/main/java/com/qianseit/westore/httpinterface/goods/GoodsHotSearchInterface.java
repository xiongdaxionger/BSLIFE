package com.qianseit.westore.httpinterface.goods;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 1.5 热门搜索
 */
public abstract class GoodsHotSearchInterface extends BaseHttpInterfaceTask {

	public GoodsHotSearchInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.gallery.hot_search";
	}
}
