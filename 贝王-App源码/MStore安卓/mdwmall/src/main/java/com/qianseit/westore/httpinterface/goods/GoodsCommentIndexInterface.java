package com.qianseit.westore.httpinterface.goods;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.15 获取评价商品规则
 */
public abstract class GoodsCommentIndexInterface extends BaseHttpInterfaceTask {

	public GoodsCommentIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.nodiscuss";
	}
}
