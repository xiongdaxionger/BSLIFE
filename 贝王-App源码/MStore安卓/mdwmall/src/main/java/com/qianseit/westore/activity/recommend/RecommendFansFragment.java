package com.qianseit.westore.activity.recommend;

import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseGridFragment;
import com.qianseit.westore.httpinterface.member.MemberAttentionInterface;
import com.qianseit.westore.httpinterface.member.MemberUnAttentionInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RecommendFansFragment extends BaseGridFragment<JSONObject> {
	String mUserIDString;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		Intent mIntent = mActivity.getIntent();
		mUserIDString = mIntent.getStringExtra(Run.EXTRA_VALUE);

		if (mUserIDString != null && mUserIDString.equals(mLoginedUser.getMember().getMember_id())) {
			mActionBar.setTitle("我的粉丝");
		} else {
			mActionBar.setTitle("TA的粉丝");
		}
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray dataArray = responseJson.optJSONArray("data");
		if (dataArray != null && dataArray.length() > 0) {
			for (int i = 0; i < dataArray.length(); i++)
				nJsonObjects.add(dataArray.optJSONObject(i));
		}
		return nJsonObjects;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_recommend_fans, null);
		}
		ImageView avdImage = (ImageView) convertView.findViewById(R.id.attention_item_avd);
		setViewSize(avdImage, mImageWidth, mImageWidth);
		Button clickBut = (Button) convertView.findViewById(R.id.account_click_but);
		View attentionAddBut = convertView.findViewById(R.id.account_attention_linear);
		TextView nameText = (TextView) convertView.findViewById(R.id.account_user_name);
		TextView recommendText = (TextView) convertView.findViewById(R.id.account_user_recommend);
		TextView fansText = (TextView) convertView.findViewById(R.id.account_user_fans);
		nameText.setText(("null".equals(responseJson.optString("name"))) ? "" : responseJson.optString("name"));
		String opinions = responseJson.optString("opinions_num");
		recommendText.setText(("null".equals(opinions) ? "0" : opinions) + "个评价");
		String fans = responseJson.optString("fans_num");
		fansText.setText(("null".equals(fans) ? "0" : fans) + "个粉丝");
		avdImage.setTag(responseJson);
		avdImage.setOnClickListener(this);
		clickBut.setOnClickListener(this);
		attentionAddBut.setOnClickListener(this);
		clickBut.setTag(responseJson);
		attentionAddBut.setTag(responseJson);
		displayCircleImage(avdImage, responseJson.optString("avatar"));
		String otherId = responseJson.optString("fans_id");
		if (otherId.equals(mLoginedUser.getMember().getMember_id())) {
			attentionAddBut.setVisibility(View.GONE);
			clickBut.setVisibility(View.VISIBLE);
			clickBut.setEnabled(false);
		} else {
			clickBut.setEnabled(true);
			if ("0".equals(responseJson.optString("is_attention"))) {
				attentionAddBut.setVisibility(View.VISIBLE);
				clickBut.setVisibility(View.GONE);
			} else {
				attentionAddBut.setVisibility(View.GONE);
				clickBut.setVisibility(View.VISIBLE);
			}
		}
		return convertView;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mUserIDString);
		nContentValues.put("limit", "20");
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_fans";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		final JSONObject dataJSON;
		switch (v.getId()) {
		case R.id.account_click_but:
			dataJSON = (JSONObject) v.getTag();
			new MemberUnAttentionInterface(RecommendFansFragment.this,  dataJSON.optString("member_id"), mLoginedUser.getMember().getMember_id()) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					Run.alert(mActivity, "已取消关注");
					if (!dataJSON.isNull("is_attention"))
						dataJSON.remove("is_attention");
					try {
						dataJSON.put("is_attention", String.valueOf(0));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					mAdapter.notifyDataSetChanged();
				}
			}.RunRequest();
			break;
		case R.id.account_attention_linear:
			dataJSON = (JSONObject) v.getTag();
			new MemberAttentionInterface(RecommendFansFragment.this, dataJSON.optString("member_id"), mLoginedUser.getMember().getMember_id()) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					Run.alert(mActivity, "关注成功");
					if (!dataJSON.isNull("is_attention"))
						dataJSON.remove("is_attention");
					try {
						dataJSON.put("is_attention", String.valueOf(1));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					mAdapter.notifyDataSetChanged();
				}
			}.RunRequest();
			break;
		case R.id.attention_item_avd:
			dataJSON = (JSONObject) v.getTag();
			if (dataJSON != null) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, dataJSON.optString("member_id")));
			}
		default:
			super.onClick(v);
			break;
		}
	}
}
