package com.qianseit.westore.activity.news;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListNopageFragment;

public class NewsCenterFragment extends BaseListNopageFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("消息中心");
		AutoLoad(false);
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news, null);
			convertView.findViewById(R.id.left).setOnClickListener(mOnClickListener);
			convertView.findViewById(R.id.middle).setOnClickListener(mOnClickListener);
			convertView.findViewById(R.id.right).setOnClickListener(mOnClickListener);
			setViewHeight(convertView.findViewById(R.id.left), 360);
			setViewHeight(convertView.findViewById(R.id.middle), 360);
			setViewHeight(convertView.findViewById(R.id.right), 360);
		}

		int nPosition = mResultLists.indexOf(responseJson) * 3;
		convertView.findViewById(R.id.divider_top).setVisibility(nPosition == 0 ? View.VISIBLE : View.GONE);

		assignment(mResultLists.get(nPosition), convertView.findViewById(R.id.left));
		assignment(nPosition + 1 < mResultLists.size() ? mResultLists.get(nPosition + 1) : null, convertView.findViewById(R.id.middle));
		assignment(nPosition + 2 < mResultLists.size() ? mResultLists.get(nPosition + 2) : null, convertView.findViewById(R.id.right));

		return convertView;
	}

	void assignment(JSONObject responseJson, View convertView) {
		if (responseJson == null) {
			((ImageView) convertView.findViewById(R.id.icon)).setImageBitmap(null);
			((TextView) convertView.findViewById(R.id.title)).setText("");
			convertView.findViewById(R.id.has_unread).setVisibility(View.GONE);
		} else {
			displaySquareImage((ImageView) convertView.findViewById(R.id.icon), responseJson.optString("img"));
			((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("name"));
			convertView.findViewById(R.id.has_unread).setVisibility(responseJson.optInt("nums") > 0 ? View.VISIBLE : View.GONE);
		}
		convertView.setTag(responseJson);
	}

	OnClickListener mOnClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			Object nObject = v.getTag();
			if (nObject == null) {
				return;
			}
			JSONObject nJsonObject = (JSONObject) nObject;
			onItemClick(nJsonObject);
		}
	};

	@Override
	public int getItemCount() {
		// TODO Auto-generated method stub
		return (int) Math.ceil(mResultLists.size() / 3.0);
	}

	void onItemClick(JSONObject nJsonObject) {
		if (nJsonObject == null) {
			return;
		}

		String nType = nJsonObject.optString("type");
		if (TextUtils.isEmpty(nType)) {
			return;
		}

		Bundle nBundle = new Bundle();
		nBundle.putString(Run.EXTRA_TITLE, nJsonObject.optString("name"));

		int nFragmentId = AgentActivity.FRAGMENT_NEWS_ORDER;
		if (nType.equalsIgnoreCase("order")) {
			nFragmentId = AgentActivity.FRAGMENT_NEWS_ORDER;
		} else if (nType.equalsIgnoreCase("article")) {
			nFragmentId = AgentActivity.FRAGMENT_NEWS_PUBLIC_NOTICE;
		} else if (nType.equalsIgnoreCase("active")) {
			nFragmentId = AgentActivity.FRAGMENT_NEWS_MARKETING;
		} else if (nType.equalsIgnoreCase("assets")) {
			nFragmentId = AgentActivity.FRAGMENT_NEWS_ASSETS;
		} else if (nType.equalsIgnoreCase("system")) {
			nFragmentId = AgentActivity.FRAGMENT_NEWS_SYSTEM;
			nBundle.putString(Run.EXTRA_DATA, nJsonObject.optJSONArray("re_type").toString());
		} else {
			return;
		}

		startActivity(nFragmentId, nBundle);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		onRefresh();
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray nArray = responseJson.optJSONArray("msg_center");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}

		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}

		return nJsonObjects;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.msg_center";
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setEmptyText("暂无消息");
		AutoLoad(false);
	}
}
