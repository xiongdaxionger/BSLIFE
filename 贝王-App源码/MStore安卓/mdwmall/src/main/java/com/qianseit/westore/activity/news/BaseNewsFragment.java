package com.qianseit.westore.activity.news;

import android.content.ContentValues;
import android.os.Bundle;
import android.os.Message;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.member.MemberReadNewsInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseNewsFragment extends BaseListFragment<JSONObject> {
	final int READ_MSG = 0x01;
	
	List<Message> mMessages = new ArrayList<Message>();
	protected String mTitle;
	MemberReadNewsInterface mReadNewsInterface = new MemberReadNewsInterface(this) {
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			if (mMessages.size() > 0) {
				mHandler.sendMessageDelayed(mMessages.get(0), 10);
			}
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mTitle = getExtraStringFromBundle(Run.EXTRA_TITLE);
		mActionBar.setTitle(mTitle);
	}

	@Override
	public void onResume() {
		super.onResume();
		setEmptyText("暂无" + mTitle);
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray nArray = responseJson.optJSONArray("message");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}
		
		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}
		
		return nJsonObjects;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("msg_type", msgType());
		return nContentValues;
	}
	
	/* (non-Javadoc)
	 * 4.22 我的站内信
	 * @see com.qianseit.westore.base.BasePageFragment#requestInterfaceName()
	 */
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.inbox";
	}
	
	protected abstract String msgType();

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		mMessages.clear();
		mHandler.removeMessages(READ_MSG);
	}

	@Override
	public void ui(int what, Message msg) {
		// TODO Auto-generated method stub
		if (what == READ_MSG) {
			mReadNewsInterface.read(((JSONObject) msg.obj).optString("comment_id"));
			mMessages.remove(0);
		} else {
			super.ui(what, msg);
		}
	}

	protected void readNews(JSONObject newsJsonObject){
		if (newsJsonObject == null || newsJsonObject.optBoolean("mem_read_status")) {
			return;
		}

		Message nMessage = new Message();
		nMessage.what = READ_MSG;
		nMessage.obj = newsJsonObject;

		if (mMessages.size() <= 0) {
			mHandler.sendMessageDelayed(nMessage, 10);
		}
		mMessages.add(nMessage);
	}
}
