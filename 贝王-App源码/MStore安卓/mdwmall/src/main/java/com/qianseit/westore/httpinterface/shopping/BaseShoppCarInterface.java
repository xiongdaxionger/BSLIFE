package com.qianseit.westore.httpinterface.shopping;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class BaseShoppCarInterface extends BaseHttpInterfaceTask {

	public BaseShoppCarInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void FailRequest() {
		// TODO Auto-generated method stub
		if (mErrorJsonObject == null) {
			return;
		}
		
		String nCode = mErrorJsonObject.optString("code");
		if (nCode.equals("cart_empty")) {
			carEmpty();
		}
	}
	
	public void carEmpty() {

	}
}
