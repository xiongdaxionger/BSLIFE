package com.qianseit.westore.httpinterface.goods;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * 2.12 回复商品评论/商品咨询
 * @author qianseit
 *
 */
public abstract class GoodsReplyInterface extends BaseHttpInterfaceTask {

	public GoodsReplyInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.comment.toReply";
	}
}
