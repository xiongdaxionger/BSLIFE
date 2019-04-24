package com.qianseit.westore.activity.recommend;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseGridFragment;
import com.qianseit.westore.httpinterface.member.MemberAttentionInterface;
import com.qianseit.westore.httpinterface.member.MemberUnAttentionInterface;
import com.beiwangfx.R;

public class RecommendAttentionAddFragment extends BaseGridFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.recommend_attention_add_title);
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
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.header_recommend_attention_add, null);
		topLayout.addView(nView);

		findViewById(R.id.attention_add_search).setOnClickListener(this);
		// if (Run.loadOptionBoolean(mActivity, AccountLoginFragment.LOGIN_SINA,
		// false)) {
		// findViewById(R.id.account_add_attention_web).setVisibility(View.VISIBLE);
		// findViewById(R.id.account_add_attention_web).setOnClickListener(this);
		// }
		findViewById(R.id.account_add_attention_book).setOnClickListener(this);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.member.get_members_for_doyen";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		final JSONObject dataJSON;
		switch (v.getId()) {
		case R.id.account_click_but:
			dataJSON = (JSONObject) v.getTag();
			new MemberUnAttentionInterface(RecommendAttentionAddFragment.this, dataJSON.optString("member_id"), mLoginedUser.getMember().getMember_id()) {

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
			new MemberAttentionInterface(RecommendAttentionAddFragment.this, dataJSON.optString("member_id"), mLoginedUser.getMember().getMember_id()) {

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
			break;
		case R.id.attention_add_search:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_ATTENTION_SEARCH));
			break;
		case R.id.account_add_attention_book:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_TEL_BOOK));
			break;
		default:
			super.onClick(v);
			break;
		}
	}
}
