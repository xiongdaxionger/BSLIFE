package com.qianseit.westore.httpinterface.article;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class InfoCouponInstructionsInterface extends BaseHttpInterfaceTask {

	public InfoCouponInstructionsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.coupons_explain";
	}
}
