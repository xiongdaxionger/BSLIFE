package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTaskHandler;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

public class ShoppingStoreFragment extends BaseDoFragment {
	private ListView mListView;
	private LayoutInflater mInflater;
	private StoreAdapter mStoreAdapter;
	private ArrayList<JSONObject> storeArray = new ArrayList<JSONObject>();
	private String addMatch,resultJSON;
	private View nullView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Intent mIntent = mActivity.getIntent();
		String strValue=mIntent.getStringExtra(Run.EXTRA_ADDR);
		resultJSON=mIntent.getStringExtra(Run.EXTRA_VALUE);
		
		if(!TextUtils.isEmpty(strValue)){
			addMatch =strValue.replace(" ", "");
		}
		mActionBar.setTitle(R.string.confirm_order_store_title);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_shopp_store_main, null);
		nullView=inflater.inflate(R.layout.item_list_null, null);
		((TextView)nullView.findViewById(R.id.item_list_text)).setText("没有自提门店");
		mListView = (ListView) findViewById(R.id.shopp_store_list);
		mStoreAdapter = new StoreAdapter();
		mListView.setAdapter(mStoreAdapter);
		mListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				JSONObject jsonItem = (JSONObject) arg1.getTag();
				Intent intent=new Intent();
				intent.putExtra(Run.EXTRA_DATA,jsonItem.toString());
				mActivity.setResult(Activity.RESULT_OK, intent);
				mActivity.finish();
			}
		});
        
		try {
			JSONObject all = new JSONObject(resultJSON);
			if (Run.checkRequestJson(mActivity, all)) {
				JSONObject data = all.optJSONObject("data");
				if (data != null) {
					JSONArray listArray = data.optJSONArray("branchlist");
					if (listArray != null && listArray.length() > 0) {
						for (int i = 0; i < listArray.length(); i++) {
							JSONObject itemJOSN = listArray.optJSONObject(i);
							if (itemJOSN != null) {
								String provStr = itemJOSN.optString("province").trim();// 省
								String cityStr = itemJOSN.optString("city").trim();// 市
								if (!TextUtils.isEmpty(cityStr) && !(cityStr.endsWith("市"))) {
									cityStr = cityStr + "市";
								}
								String contyStr = itemJOSN.optString("county").trim();// 区
								String storeStr = provStr + cityStr + contyStr;
								if (addMatch.equals(storeStr)) {
									storeArray.add(itemJOSN);
								}
							}
						}

					}
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (storeArray.size() > 0){
				mListView.removeFooterView(nullView);
				mStoreAdapter.notifyDataSetChanged();
			}else{
				mListView.addFooterView(nullView);
			}
		}
		//Run.excuteJsonTask(new JsonTask(), new StorelTask());
	}

	private class StoreAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return storeArray.size();
		}

		@Override
		public JSONObject getItem(int position) {
			return storeArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder mHolder;
			if (convertView == null) {
				mHolder = new ViewHolder();
				convertView = mInflater.inflate(R.layout.item_store, null);
				mHolder.mNameText = (TextView) convertView.findViewById(R.id.item_store_name);
				convertView.setTag(R.id.tag_object, mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag(R.id.tag_object);
			}
			JSONObject jsonData = getItem(position);
			convertView.setTag(jsonData);
			mHolder.mNameText.setText(jsonData.optString("name"));
			return convertView;
		}

		private class ViewHolder {
			private TextView mNameText;
		}

	}

	/**
	 * 获取门店
	 */
	private class StorelTask implements JsonTaskHandler {
		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			return new JsonRequestBean(Run.API_URL, "mobileapi.cart.getwarehouse");
		}

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog_mt();
			
		}
	}

}
