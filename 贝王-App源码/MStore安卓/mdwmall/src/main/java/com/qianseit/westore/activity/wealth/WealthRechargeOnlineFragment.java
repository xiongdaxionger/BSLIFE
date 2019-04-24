package com.qianseit.westore.activity.wealth;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.wealth.WealthDepositIndexInterface;

public class WealthRechargeOnlineFragment extends BaseDoFragment {
	final int RECHARGE_PAY = 0x01;

	EditText mRechargeValueEditText;
	JSONObject mIndexJsonObject;
	String mCurrency = "￥";

	ListView mListView;
	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();
	QianseitAdapter<JSONObject> mAdapter = new QianseitAdapter<JSONObject>(mJsonObjects) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_recharge_gift, null);
				convertView.findViewById(R.id.recharge).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						JSONObject nJsonObject = (JSONObject) v.getTag();
						Bundle nBundle = new Bundle();
						nBundle.putString(Run.EXTRA_DATA, mIndexJsonObject.toString());
						nBundle.putDouble(Run.EXTRA_VALUE, nJsonObject.optDouble("price_min"));
						startActivityForResult(AgentActivity.FRAGMENT_WEALTH_RECHARGE_PAY, nBundle, RECHARGE_PAY);
					}
				});
			}

			JSONObject nJsonObject = getItem(position);
			((TextView) convertView.findViewById(R.id.sub_title)).setText(String.format("充值%s%s 赠", nJsonObject.optString("price_min"), mCurrency));
			((TextView) convertView.findViewById(R.id.title)).setText(nJsonObject.optString("song"));
			((TextView) convertView.findViewById(R.id.brief)).setText(nJsonObject.optString("brief"));
			convertView.findViewById(R.id.recharge).setTag(nJsonObject);
			
			return convertView;
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_wealth_recharge_online, null);
		mRechargeValueEditText = (EditText) findViewById(R.id.recharge_value);
		
		mListView = (ListView) findViewById(R.id.recharge_gift_lv);
		mListView.setAdapter(mAdapter);

		findViewById(R.id.recharge).setOnClickListener(this);
		new WealthDepositIndexInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mIndexJsonObject = responseJson;
				parseIndex();
			}
		}.RunRequest();
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		mRechargeValueEditText.requestFocus();
	}

	void parseIndex() {
		if (mIndexJsonObject == null) {
			return;
		}
		
		mCurrency = mIndexJsonObject.optString("def_cur_sign");
		
		JSONObject nJsonObject = mIndexJsonObject.optJSONObject("active");
		if (nJsonObject == null) {
			return;
		}
		nJsonObject = nJsonObject.optJSONObject("recharge");
		if (nJsonObject == null) {
			return;
		}

		JSONArray nArray = nJsonObject.optJSONArray("filter");
		if (nArray == null || nArray.length() <= 0) {
			return;
		}

		mJsonObjects.clear();
		for (int i = 0; i < nArray.length(); i++) {
			mJsonObjects.add(nArray.optJSONObject(i));
		}
		mAdapter.notifyDataSetChanged();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.recharge:
			if (mRechargeValueEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入充值金额");
				return;
			}
			
			double nAmount = Double.parseDouble(mRechargeValueEditText.getText().toString());
			if (nAmount <= 0) {
				Run.alert(mActivity, "请输入大于零充值金额");
				return;
			}
			
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_DATA, mIndexJsonObject.toString());
			nBundle.putDouble(Run.EXTRA_VALUE, nAmount);
			startActivityForResult(AgentActivity.FRAGMENT_WEALTH_RECHARGE_PAY, nBundle, RECHARGE_PAY);
			break;

		default:
			super.onClick(v);
			break;
		}
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode != Activity.RESULT_OK) {
			super.onActivityResult(requestCode, resultCode, data);
			return;
		}
		
		switch (requestCode) {
		case RECHARGE_PAY:
			break;

		default:
			super.onActivityResult(requestCode, resultCode, data);
			break;
		}
	}
}
