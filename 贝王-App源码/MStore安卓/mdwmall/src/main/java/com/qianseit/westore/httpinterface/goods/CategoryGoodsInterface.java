package com.qianseit.westore.httpinterface.goods;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *1.1 商品分类
 */
public abstract class CategoryGoodsInterface extends BaseHttpInterfaceTask {

	public CategoryGoodsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.gallery.cat";
	}
}
