package com.qianseit.westore.httpinterface.member;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 4.46关于我们
 */
public abstract class MemberAboutInterface extends BaseHttpInterfaceTask {

	public MemberAboutInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.activity.about";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		responseContent(responseJson.optString("explain"));
	}
	
	public abstract void responseContent(String content);

}
