package com.qianseit.westore.httpinterface.shopping;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 6.9 物流查询接口
 */
public abstract class ShoppOrderLogisticsInterface extends BaseHttpInterfaceTask {
	String mDeliveryId;

	public ShoppOrderLogisticsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.get_delivery";
	}
	
	public void getLogistics(String deliveryId){
		mDeliveryId = deliveryId;
		RunRequest();
	}
}
