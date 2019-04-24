package com.qianseit.westore.activity.acco;

import android.content.ContentValues;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.base.BaseListFragment;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AccoHelpCenterFragment extends BaseListFragment<JSONObject> {

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("帮助中心");
		setEmptyText("暂无文章信息");
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_acco_helpcenter, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					AccoHelpCenterFragment.this.onClick("article", nJsonObject.optString("article_id"), nJsonObject.optString("title"));
				}
			});
		}
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();

		JSONArray nArray = responseJson.optJSONArray("articles");
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
		return "content.article.l";
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("node_type", "help");
		return nContentValues;
	}
}
