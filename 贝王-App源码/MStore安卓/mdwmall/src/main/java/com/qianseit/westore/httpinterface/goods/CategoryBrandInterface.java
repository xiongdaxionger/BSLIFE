package com.qianseit.westore.httpinterface.goods;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public class CategoryBrandInterface extends BaseHttpInterfaceTask {

	public CategoryBrandInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.brand.showList";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub

	}

}
