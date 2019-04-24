package com.qianseit.westore.httpinterface.index;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

/**
 * @author qianseit
 * 11.7 在线客服
 */
public abstract class GetOnlineSeveiceInterface extends BaseHttpInterfaceTask {
	public static final String QQ = "qq";
	/**
	 * 微信
	 */
	public static final String WECHAT = "weixin";
	/**
	 * 第三方
	 */
	public static final String THRID = "custom";

	/**
	 * 在线客服类型
	 */
	public String mOnlineServiceType="";
	/**
	 * 在线客服值（qq号，微信号等）
	 */
	public String mOnlineServiceValue = "";
	/**
	 * 客服说明
	 */
	public String mRemark = "";
	/**
	 * 客服电话
	 */
	public String mServiceTel = "";

	/**
	 * 上线电话 如果存在上线
     */
	public String mUplinePhoneNumber;

	public GetOnlineSeveiceInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.activity.cs";
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		mOnlineServiceType = responseJson.optString("type");
		mOnlineServiceValue = responseJson.optString("val");
		mServiceTel = responseJson.optString("mobile");
		mRemark = responseJson.optString("explain");
		mUplinePhoneNumber = responseJson.optString("higher");
		responseService(mOnlineServiceType, mOnlineServiceValue);
	}
	
	/**
	 * @param type 客服类型
	 * @param serviceValue 如qq号微信号或第三方客服地址
	 */
	public abstract void responseService(String type, String serviceValue);
}
