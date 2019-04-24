package com.qianseit.westore.httpinterface.marketing;

import org.json.JSONObject;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 11.4 签到
 */
public abstract class MarketingGetSignInterface extends BaseHttpInterfaceTask {

	public MarketingGetSignInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.signin";
	}
	

	@Override
	public void task_response(String json_str) {
		mBaseActivity.hideLoadingDialog_mt();
		try {
			JSONObject all = new JSONObject(json_str);
			if (checkRequestJson(mBaseActivity.getContext(), all)) {
				SuccCallBack(all);
			} else {
				mErrorJsonObject = all;
				FailRequest();
			}
		} catch (Exception e) {
			FailRequest();
		}
	}
}
