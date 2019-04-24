package com.qianseit.westore.activity.recommend;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseLocalListFragment;
import com.qianseit.westore.httpinterface.member.MemberAttentionInterface;
import com.qianseit.westore.httpinterface.member.MemberUnAttentionInterface;
import com.beiwangfx.R;

public class RecommendTelBookAddedFragment extends BaseLocalListFragment<JSONObject> {

	Resources mResources;
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
		mResources = getResources();
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_mobile_friend, null);
			convertView.findViewById(R.id.item_mobile_friend_invited_item).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.item_mobile_friend_invited_guanzhu).setOnClickListener(this);
			convertView.findViewById(R.id.item_mobile_friend_invited_avator).setOnClickListener(this);
		}
		((TextView) convertView.findViewById(R.id.item_mobile_friend_invited_nickname)).setText(responseJson.optString("nickname"));
		((TextView) convertView.findViewById(R.id.item_mobile_friend_invited_name)).setText("手机联系人：" + responseJson.optString("name"));
		ImageView nAvatorImageView = (ImageView) convertView.findViewById(R.id.item_mobile_friend_invited_avator);
		nAvatorImageView.setTag(responseJson);
		displayCircleImage(nAvatorImageView, responseJson.optString("avatar"));
		Button nAttentionButton = (Button) convertView.findViewById(R.id.item_mobile_friend_invited_guanzhu);
		nAttentionButton.setText(getGuanzhu());
		nAttentionButton.setTag(responseJson);
		if (responseJson.optInt("is_attention") == 1) {// 已关注
			nAttentionButton.setText("已关注");
			nAttentionButton.setTextColor(Color.parseColor("#ffffff"));
			nAttentionButton.setBackgroundResource(R.drawable.bg_address_add);
		} else {
			nAttentionButton.setText(getGuanzhu());
			nAttentionButton.setTextColor(mResources.getColor(R.color.westore_red));
			nAttentionButton.setBackgroundResource(R.drawable.button_white_selector);
		}
		return convertView;
	}

	private SpannableString getGuanzhu() {
		SpannableString sp = new SpannableString("+ 关注");
		ForegroundColorSpan span = new ForegroundColorSpan(0xff999999);
		sp.setSpan(span, 0, 1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		return sp;
	}

	@Override
	public void onClick(final View v) {
		// TODO Auto-generated method stub
		final JSONObject obj;
		switch (v.getId()) {
		case R.id.item_mobile_friend_invited_avator:
			obj = (JSONObject) v.getTag();
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra("userId", obj.optString("member_id")));
			break;
		case R.id.item_mobile_friend_invited_guanzhu:
			obj = (JSONObject) v.getTag();
			String fansID = mLoginedUser.getMember().getMember_id();
			if (!TextUtils.isEmpty(fansID)) {
				showCancelableLoadingDialog();
				if ("0".equals(obj.optString("is_attention").trim())) {
					new MemberAttentionInterface(this, obj.optString("member_id"), fansID) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub

							if (!obj.isNull("is_attention"))
								obj.remove("is_attention");
							try {
								obj.put("is_attention", String.valueOf(1));
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							Button but=((Button)v);
							if (obj.optInt("is_attention") == 1) {// 已关注
								but.setText("已关注");
								but.setTextColor(Color.parseColor("#ffffff"));
								but.setBackgroundResource(R.drawable.bg_address_add);
							} else {
								but.setText(getGuanzhu());
								but.setTextColor(mResources.getColor(R.color.westore_red));
								but.setBackgroundResource(R.drawable.button_white_selector);
							}
						}
					}.RunRequest();
				} else {
					new MemberUnAttentionInterface(this, obj.optString("member_id"), fansID) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub

							if (!obj.isNull("is_attention"))
								obj.remove("is_attention");
							try {
								obj.put("is_attention", String.valueOf(0));
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							Button but=((Button)v);
							if (obj.optInt("is_attention") == 1) {// 已关注
								but.setText("已关注");
								but.setTextColor(Color.parseColor("#ffffff"));
								but.setBackgroundResource(R.drawable.bg_address_add);
							} else {
								but.setText(getGuanzhu());
								but.setTextColor(mResources.getColor(R.color.westore_red));
								but.setBackgroundResource(R.drawable.button_white_selector);
							}
						}
					}.RunRequest();
				}
			}
			break;

		default:
			break;
		}
		super.onClick(v);
	}

	public void setItems(List<JSONObject> jsonObjects) {
		mJsonObjects = jsonObjects;
		if (this.isResumed()) {
			onRefresh();
		}
	}
}
