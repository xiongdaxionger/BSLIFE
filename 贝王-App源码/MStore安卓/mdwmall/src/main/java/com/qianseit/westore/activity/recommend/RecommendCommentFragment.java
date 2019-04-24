package com.qianseit.westore.activity.recommend;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RecommendCommentFragment extends BaseListFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("收到的评论");
	}
	
	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray list = responseJson.optJSONArray("data");
		int count = list == null ? 0 : list.length();
		for (int i = 0; i < count; i++) {
			nJsonObjects.add(list.optJSONObject(i));
		}
		return nJsonObjects;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_receive_praise_comment, null);
		}

		displayCircleImage((ImageView) convertView.findViewById(R.id.item_receive_pc_user_img), responseJson.optString("avatar"));
		displaySquareImage((ImageView) convertView.findViewById(R.id.item_receive_pc_title_img), responseJson.optString("image"));

		((TextView) convertView.findViewById(R.id.item_receive_pc_username)).setText(Run.defaultName(responseJson.optString("name")));
		((TextView) convertView.findViewById(R.id.item_receive_pc_date)).setText(StringUtils.friendlyFormatLongStringTime(responseJson.optString("created")));
		((TextView) convertView.findViewById(R.id.member_personal_lv)).setText(responseJson.optString("member_lv_name"));
		TextView nCommentTextView = (TextView) convertView.findViewById(R.id.item_receive_pc_comment);
		nCommentTextView.setVisibility(View.VISIBLE);
		nCommentTextView.setText(responseJson.optString("content"));
		return convertView;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mLoginedUser.getMember().getMember_id());
		nContentValues.put("limit", "20");
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_comment_for_member";
	}

}
