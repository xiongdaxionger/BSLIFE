package com.qianseit.westore.httpinterface.member;

import org.json.JSONObject;

import com.google.gson.reflect.TypeToken;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.bean.member.MemberIndex;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit 4.1 会员中心首页
 * 
 */
public abstract class MemberIndexInterface extends BaseHttpInterfaceTask {

	public MemberIndexInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.index";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		LoginedUser.getInstance().mMemberIndex = MemberIndex.getGsonData(mBaseActivity.getContext(), new TypeToken<MemberIndex>() {
		}, responseJson.toString());
		LoginedUser.getInstance().setIsLogined(true);
		Run.goodsCounts = LoginedUser.getInstance().getMember().getCart_number();
		responseSucc();
		AgentApplication.getInstance().sendToken();
	}

	public abstract void responseSucc();
}
