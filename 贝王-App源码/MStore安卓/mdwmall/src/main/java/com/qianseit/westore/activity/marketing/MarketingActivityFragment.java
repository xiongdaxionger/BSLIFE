package com.qianseit.westore.activity.marketing;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.base.BaseListNopageFragment;

public class MarketingActivityFragment extends BaseListNopageFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("我的活动");
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
		} else {
			displaySquareImage((ImageView) convertView.findViewById(R.id.icon), responseJson.optString("img"));
			((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("name"));
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
			MarketingActivityFragment.this.onClick(nJsonObject.optString("type"), "", "");
		}
	};

	@Override
	public int getItemCount() {
		// TODO Auto-generated method stub
		return (int) Math.ceil(mResultLists.size() / 3.0);
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
		
		JSONArray nArray = responseJson.optJSONArray("data");
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
		return "b2c.activity.alist";
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setEmptyText("暂无活动");
	}
}
