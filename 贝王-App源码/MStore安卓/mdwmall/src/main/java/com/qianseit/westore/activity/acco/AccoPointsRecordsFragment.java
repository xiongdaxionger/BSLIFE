package com.qianseit.westore.activity.acco;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AccoPointsRecordsFragment extends BaseListFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (responseJson != null) {
			JSONArray list = responseJson.optJSONArray("historys");
			int count = list == null ? 0 : list.length();
			for (int i = 0; i < count; i++) {
				nJsonObjects.add(list.optJSONObject(i));
			}
		}
		return nJsonObjects;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.point_history";
	}

	@Override
	protected void endInit() {
		setEmptyText("暂无积分记录");
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_integral_history, null);
		}
		if (responseJson != null) {
			int change_point = responseJson.optInt("change_point");
			if (change_point >= 0) {
				((TextView) convertView.findViewById(R.id.item_integral_history_coin)).setText(Run.buildString("+", change_point, "积分"));
			} else {
				((TextView) convertView.findViewById(R.id.item_integral_history_coin)).setText(Run.buildString("", change_point, "积分"));
			}
			((TextView) convertView.findViewById(R.id.item_integral_history_desc)).setText(responseJson.optString("reason"));
			((TextView) convertView.findViewById(R.id.item_integral_history_date)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("addtime")));
		}
		return convertView;
	}
}
