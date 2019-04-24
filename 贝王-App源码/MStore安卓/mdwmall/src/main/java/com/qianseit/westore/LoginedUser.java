package com.qianseit.westore;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.bean.member.Member;
import com.qianseit.westore.bean.member.MemberIndex;
import com.qianseit.westore.httpinterface.index.GetOnlineSeveiceInterface;

import org.json.JSONObject;


/**
 * @author chanson
 * @CreatTime 2015-9-22 上午11:36:41
 * 
 */
public class LoginedUser {
	private final String EMPTY_URI = "http://localhost/";

	private static LoginedUser mLoginedUser;

	public MemberIndex mMemberIndex;
	
	/**
	 * 用户绑定的手机号
	 */
	public String mobile = "";

	/**
	 * 客服电话
	 */
	private String servicePhoneNumber;

	/**
	 * 上线电话
	 */
	private String uplinePhoneNumber;

	/**
	 * 加载完成回调
	 */
	private LoadServicePhoneHandler mHandler;

	private boolean loginStatus = false;
	
	private LoginedUser() {
	}

	public interface LoadServicePhoneHandler{

		void onComplete();
	}

	public Member getMember(){
		if (mMemberIndex != null && mMemberIndex.getMember() != null) {
			return mMemberIndex.getMember();
		}else{
			return new Member();
		}
	}

	///获取显示的昵称
	public String getDisplayName(){

		if(mMemberIndex == null)
			return "";

		if(mMemberIndex.isDistribution_status() && !TextUtils.isEmpty(mMemberIndex.getShopname()) &&
				!TextUtils.isEmpty(mMemberIndex.getMember().getName())) {
			return mMemberIndex.getShopname() + mMemberIndex.getMember().getName();
		}

		return mMemberIndex.getMember().getUname();
	}
	
	public static LoginedUser getInstance() {
		if (mLoginedUser == null)
			mLoginedUser = new LoginedUser();
		return mLoginedUser;
	}

	///获取电话 如果用户已登录并且有上线，则拨打上线电话，否则拨打后台客服电话
	public String getPhone(){
		if(isLogined() && !TextUtils.isEmpty(uplinePhoneNumber)){
			return uplinePhoneNumber;
		}else {
			return servicePhoneNumber;
		}
	}

	///获取客服电话信息
	public void loadServicePhone(LoadServicePhoneHandler handler){

		mHandler = handler;

		QianseitActivityInterface activityInterface = new QianseitActivityInterface() {
			@Override
			public void showLoadingDialog() {

			}

			@Override
			public void showCancelableLoadingDialog() {

			}

			@Override
			public void hideLoadingDialog() {

			}

			@Override
			public void hideLoadingDialog_mt() {

			}

			@Override
			public Context getContext() {
				return AgentApplication.getContext();
			}
		};

		GetOnlineSeveiceInterface seveiceInterface = new GetOnlineSeveiceInterface(activityInterface) {
			@Override
			public void responseService(String type, String serviceValue) {

				uplinePhoneNumber = mUplinePhoneNumber;
				servicePhoneNumber = mServiceTel;

				if(mHandler != null){
					mHandler.onComplete();
				}
			}
		};
		seveiceInterface.RunRequest();
	}

	public void clearLoginedStatus() {
		mMemberIndex.clear();
		mobile = "";
		uplinePhoneNumber = null;
	}

	public boolean isLogined() {
		return loginStatus && mMemberIndex != null;
	}

	public void setIsLogined(boolean loginStatus) {
		this.loginStatus = loginStatus;
		if (!loginStatus) {
			clearLoginedStatus();
		}else {
			loadServicePhone(null);
		}
	}

	public String getAvatarUri() {
		if (getMember() == null)
			return EMPTY_URI;
		return getMember().getAvatar();
	}

	public String getMemberId() {
		if (getMember() == null)
			return "";
		return getMember().getMember_id();
	}

	public void setAvatarUri(String avatarUriString) {
		if (getMember() == null)
			return;
		getMember().setAvatar(avatarUriString);
	}

	public void setMemberLvName(String memberLvName) {
		if (getMember() == null)
			return;
		getMember().setLevelname(memberLvName);
	}

	public String getMemberLvName() {
		if (getMember() == null)
			return "";
		return getMember().getLevelname();
	}

	public String getUName() {
		if (getMember() == null)
			return "";
		return getMember().getUname();
	}

	public String getName() {
		if (getMember() == null)
			return "";
		if(TextUtils.isEmpty(getMember().getName()))
			return getMember().getUname();
		return getMember().getName();
	}

	public Boolean getPayPassword() {
		if (mMemberIndex != null && mMemberIndex.getMember() != null) {
			return mMemberIndex.getMember().isHas_pay_password();
		}
		return false;
	}

	public void setPayPassword(boolean payPassword) {
		if (mMemberIndex != null && mMemberIndex.getMember() != null) {
			mMemberIndex.getMember().setHas_pay_password(payPassword);
		}
	}

	/**
	 * 总佣金
	 * 
	 * @return
	 */
	public String getAdvance() {
		if (getMember() == null)
			return "";
		return getMember().getAdvance();
	}

	public void setAdvance(String value) {
		if (getMember() == null)
			return;
		getMember().setAdvance(value);
	}

	/**
	 * 如果key值是null，则转为"" author yangtq creatTime 2015-9-22 上午11:36:43
	 * 
	 * @param jsonObject
	 * @param keyString
	 * @return return String
	 */
	@SuppressLint("DefaultLocale")
	private String getString(JSONObject jsonObject, String keyString) {
		if (jsonObject == null || keyString == null)
			return "";

		String nReturnString = jsonObject.optString(keyString);
		if (nReturnString.toLowerCase().equals("null"))
			nReturnString = "";
		return nReturnString;
	}
}
