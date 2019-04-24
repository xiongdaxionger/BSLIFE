package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberSendMsgInterface extends BaseHttpInterfaceTask {
	
	String mMsgTo = "管理员", mTitle, mContent, mType, mContactWay;

	public MemberSendMsgInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.send_msg";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("msg_to", mMsgTo);
		nContentValues.put("subject", mTitle);
		nContentValues.put("comment", mContent);
		nContentValues.put("has_sent", "true");
		nContentValues.put("gask_type", mType);
		if (!TextUtils.isEmpty(mContactWay)) {
			nContentValues.put("contact", mContactWay);
		}
		return nContentValues;
	}
	
	/**
	 * @param title 标题
	 * @param content 内容
	 * @param type 意见反馈类型
	 * @param contactWay 联系方式（可为空）
	 */
	public void send(String title, String content, int type, String contactWay){
		mTitle = title;
		mContent = content;
		mType = String.valueOf(type);
		mContactWay = contactWay;
		RunRequest();
	}
}
