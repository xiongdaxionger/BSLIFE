package com.qianseit.westore.activity.recommend;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.base.BaseLocalListFragment;
import com.qianseit.westore.httpinterface.member.MemberGetInviteContent;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RecommendTelBookInvitedAddFragment extends BaseLocalListFragment<JSONObject> {

	private ArrayList<JSONObject> listPosition = new ArrayList<JSONObject>();
	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();

	@Override
	protected List<JSONObject> buildLocalItems() {
		// TODO Auto-generated method stub
		return mJsonObjects;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_mobile_friend, null);
			convertView.findViewById(R.id.item_mobile_friend_invite_item).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.item_mobile_friend_invite_yaoqing).setOnClickListener(this);
		}
		((TextView) convertView.findViewById(R.id.item_mobile_friend_invite_name)).setText(responseJson.optString("name"));
		Button nInviteButton = (Button) convertView.findViewById(R.id.item_mobile_friend_invite_yaoqing);
		if (listPosition.contains(responseJson)) {
			nInviteButton.setTag(null);
			nInviteButton.setTextColor(getResources().getColor(R.color.westore_gray_textcolor));
			nInviteButton.setText("已邀请");
		} else {
			nInviteButton.setText("邀请");
			nInviteButton.setTextColor(getResources().getColor(R.color.theme_color));
			nInviteButton.setTag(responseJson);
		}
		return convertView;
	}

	public void setItems(List<JSONObject> jsonObjects) {
		mJsonObjects = jsonObjects;
		if (this.isResumed()) {
			onRefresh();
		}
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		super.onClick(v);
		switch (v.getId()) {
		case R.id.item_mobile_friend_invite_yaoqing:
			if (v.getTag() == null) {
				return;
			}
			
			final JSONObject obj = (JSONObject) v.getTag();
			listPosition.add(obj);
			
			new MemberGetInviteContent(this) {
				
				@Override
				public void ResponseContent(String inviteContent) {
					// TODO Auto-generated method stub
					Uri smsToUri = Uri.parse("smsto:" + obj.optString("mobile") + "");// 发送电话
					Intent intent = new Intent(Intent.ACTION_SENDTO, smsToUri);
					intent.putExtra("sms_body", inviteContent);
					startActivity(intent);
				}
			}.RunRequest();
			mAdapter.notifyDataSetChanged();
			break;

		default:
			break;
		}
	}
}
