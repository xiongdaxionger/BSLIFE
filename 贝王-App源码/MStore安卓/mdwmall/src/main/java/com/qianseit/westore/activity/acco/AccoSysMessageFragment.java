package com.qianseit.westore.activity.acco;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AccoSysMessageFragment extends BaseListFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("系统消息");
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
			convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_acco_sys_message, null);
		}
			((TextView)convertView.findViewById(R.id.item_system_date)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("time")));
			((TextView)convertView.findViewById(R.id.item_system_desc)).setText(responseJson.optString("detail"));
			if (responseJson.optInt("is_read") == 0) {
//				((TextView)convertView.findViewById(R.id.item_system_new)).setVisibility(View.VISIBLE);
			} else {
//				((TextView)convertView.findViewById(R.id.item_system_new)).setVisibility(View.GONE);
			}
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("limit", "100");
		return nContentValues;
	}
	
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.mymessage.mysysmsg";
	}

}
