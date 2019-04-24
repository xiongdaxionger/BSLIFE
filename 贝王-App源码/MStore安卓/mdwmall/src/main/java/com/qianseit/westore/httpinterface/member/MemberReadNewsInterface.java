package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import org.json.JSONObject;

import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public class MemberReadNewsInterface extends BaseHttpInterfaceTask {

	String mCommentId = "";
	LoginedUser mLoginedUser = LoginedUser.getInstance();
	public MemberReadNewsInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		AutoStartLoadingDialog(false);
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.view_msg";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("comment_id", mCommentId);
		return nContentValues;
	}
	
	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (mLoginedUser.isLogined()) {
			mLoginedUser.getMember().setUn_readMsg(mLoginedUser.getMember().getUn_readMsg() - 1);
		}
	}
	
	public void read(String commentId){
		mCommentId = commentId;
		RunRequest();
	}
}
