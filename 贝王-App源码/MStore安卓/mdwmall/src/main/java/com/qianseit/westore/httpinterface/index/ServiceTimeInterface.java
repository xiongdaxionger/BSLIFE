package com.qianseit.westore.httpinterface.index;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public class ServiceTimeInterface extends BaseHttpInterfaceTask {
	long mLocalTimeMatchService = 0;
	long mServiceTime = 0;
	
	static ServiceTimeInterface mInterface;

	public ServiceTimeInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mInterface = this;
		RunRequest();
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobile.index.getTimes";
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		mServiceTime = responseJson.optLong("time");
		mLocalTimeMatchService = System.currentTimeMillis() / 1000;
	}
	
	public static long getServiceTime(){
		if(mInterface == null){
			return System.currentTimeMillis() / 1000;
		}
		
		return mInterface.mServiceTime + System.currentTimeMillis() / 1000 - mInterface.mLocalTimeMatchService;
	}
}
