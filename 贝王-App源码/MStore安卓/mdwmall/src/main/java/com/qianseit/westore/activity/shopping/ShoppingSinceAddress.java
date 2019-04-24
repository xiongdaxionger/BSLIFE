package com.qianseit.westore.activity.shopping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.shopping.ShoppingChooseFreagment.SelectsAdapter.ViewHolder;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.City;
import com.qianseit.westore.base.County;
import com.qianseit.westore.base.Province;
import com.qianseit.westore.http.Json;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.beiwangfx.R;

public class ShoppingSinceAddress extends BaseDoFragment {

	private ArrayList<JSONObject> mDataList = new ArrayList<JSONObject>();

	/**
	 * 所有省
	 */
	private int clickNum = 0;
	private Integer[] mSelecArray = new Integer[3];
	private String provinceStr, cityStr, countyStr;
	private ArrayList<Province> mProvinceDatas = new ArrayList<Province>();

	private ListView mListView;
	private String resultJSON;
	private String productID;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("省");
		Intent mIntent = mActivity.getIntent();
		productID = mIntent.getStringExtra(Run.EXTRA_VALUE);
		mActionBar.getBackButton().setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setBackStatus();
			}
		});

	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			setBackStatus();
			return true;
		}

		return super.onKeyDown(keyCode, event);
	}

	private void setBackStatus() {
		clickNum--;
		switch (clickNum) {
		case 0:
			mActionBar.setTitle("省");
			mListView.setAdapter(new SinceAdapter<Province>(mProvinceDatas));
			break;
		case 1:
			mActionBar.setTitle("市");
			Province mProvince = mProvinceDatas.get(mSelecArray[0]);
			provinceStr = mProvince.getName();
			mProvince.getCityList();
			mListView.setAdapter(new SinceAdapter<City>(mProvince.getCityList()));
			break;
		case 2:
			mActionBar.setTitle("区");
			City mCity = mProvinceDatas.get(mSelecArray[0]).getCityList().get(mSelecArray[1]);
			countyStr = mCity.getName();
			mListView.setAdapter(new SinceAdapter<County>(mCity.getCountList()));
			break;
		case 3:
			County mCounty = mProvinceDatas.get(mSelecArray[0]).getCityList().get(mSelecArray[1]).getCountList().get(mSelecArray[2]);
			countyStr = mCounty.getName();
			Intent mIntent = new Intent();
			mIntent.putExtra(Run.EXTRA_ADDR, provinceStr + cityStr + countyStr);
			mIntent.putExtra(Run.EXTRA_DATA, resultJSON);
			mActivity.setResult(Activity.RESULT_OK, mIntent);
			mActivity.finish();
			break;

		default:
			mActivity.finish();
			break;
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.fragment_since_main, null);
		mListView = (ListView) findViewById(R.id.since_listview);
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				clickNum++;
				switch (clickNum) {
				case 1:
					mActionBar.setTitle("市");
					mSelecArray[0] = arg2;
					Province mProvince = mProvinceDatas.get(mSelecArray[0]);
					provinceStr = mProvince.getName();
					mListView.setAdapter(new SinceAdapter<City>(mProvince.getCityList()));
					break;
				case 2:
					mActionBar.setTitle("区");
					mSelecArray[1] = arg2;
					City mCity = mProvinceDatas.get(mSelecArray[0]).getCityList().get(mSelecArray[1]);
					cityStr = mCity.getName();
					mListView.setAdapter(new SinceAdapter<County>(mCity.getCountList()));
					break;
				case 3:
					mSelecArray[2] = arg2;
					County mCounty = mProvinceDatas.get(mSelecArray[0]).getCityList().get(mSelecArray[1]).getCountList().get(mSelecArray[2]);
					countyStr = mCounty.getName();
					Intent mIntent = new Intent();
					mIntent.putExtra(Run.EXTRA_ADDR, provinceStr + cityStr + countyStr);
					mIntent.putExtra(Run.EXTRA_DATA, resultJSON);
					mActivity.setResult(Activity.RESULT_OK, mIntent);
					mActivity.finish();
					break;

				default:
					break;
				}

			}
		});
		Run.excuteJsonTask(new JsonTask(), new SinceAddHandler());
	}

	private class SinceAdapter<T> extends BaseAdapter {

		private List<T> mDataList;

		public SinceAdapter(List<T> mDataList) {
			this.mDataList = mDataList;
		}

		@Override
		public int getCount() {

			return mDataList.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return mDataList.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder mViewHolder;
			if (convertView == null) {
				mViewHolder = new ViewHolder();
				convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_store, null);
				mViewHolder.mTextView = (TextView) convertView.findViewById(R.id.item_store_name);
				convertView.setTag(R.id.text1, mViewHolder);
			} else {
				mViewHolder = (ViewHolder) convertView.getTag(R.id.text1);
			}
			Object object = getItem(position);
			convertView.setTag(object);
			if (object instanceof Province) {
				mViewHolder.mTextView.setText(((Province) object).getName());
			} else if (object instanceof City) {
				mViewHolder.mTextView.setText(((City) object).getName());
			} else if (object instanceof County) {
				mViewHolder.mTextView.setText(((County) object).getName());
			}
			return convertView;
		}

		private class ViewHolder {
			TextView mTextView;
		}
	}

	private void setAddres(JSONObject dataJSON) {
		if (dataJSON == null)
			return;
		if (!dataJSON.isNull("province")) {
			String province = dataJSON.optString("province");
			Province mProvince = containsProvince(mProvinceDatas, province);
			if (mProvince != null) {
				List<City> mCityList = mProvince.getCityList();
				if (!dataJSON.isNull("city")) {
					String city = dataJSON.optString("city");
					City mCity = containsCity(mCityList, city);
					if (mCity != null) {
						List<County> mCountyList = mCity.getCountList();
						if (!dataJSON.isNull("county")) {
							String county = dataJSON.optString("county");
							if (!containsCounty(mCountyList, county)) {
								County mCounty = new County();
								mCounty.setName(county);
								mCountyList.add(mCounty);
							}
						}
					} else {
						mCity = new City();
						if (!(city.endsWith("市"))) {
							city += "市";
						}
						mCity.setName(city);
						mCityList.add(mCity);
						if (!dataJSON.isNull("county")) {
							String county = dataJSON.optString("county");
							County mCounty = new County();
							mCounty.setName(county);
							mCity.getCountList().add(mCounty);
						}
					}
				}
			} else {
				mProvince = new Province();
				mProvince.setName(province);
				mProvinceDatas.add(mProvince);
				if (!dataJSON.isNull("city")) {
					List<City> mCityList = mProvince.getCityList();
					String city = dataJSON.optString("city");
					if (!(city.endsWith("市"))) {
						city += "市";
					}
					City mCity = new City();
					mCity.setName(city);
					mCityList.add(mCity);
					if (!dataJSON.isNull("county")) {
						String county = dataJSON.optString("county");
						County mCounty = new County();
						mCounty.setName(county);
						mCity.getCountList().add(mCounty);
					}

				}
			}
		}
	}

	private Province containsProvince(List<Province> list, String name) {
		for (int i = 0; i < list.size(); i++) {
			Province mProvince = list.get(i);
			if (name.equals(mProvince.getName())) {
				return mProvince;
			}
		}
		return null;
	}

	private City containsCity(List<City> list, String name) {
		for (int i = 0; i < list.size(); i++) {
			City mCity = list.get(i);
			if (name.equals(mCity.getName())) {
				return mCity;
			}
		}
		return null;
	}

	private boolean containsCounty(List<County> list, String name) {
		for (int i = 0; i < list.size(); i++) {
			County mCounty = list.get(i);
			if (name.equals(mCounty.getName())) {
				return true;
			}
		}
		return false;
	}

	private class SinceAddHandler implements JsonTaskHandler {

		@Override
		public void task_response(String json_str) {
			try {
				resultJSON = json_str;
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					JSONArray branArray = all.optJSONArray("data");
					if (branArray != null && branArray.length() > 0) {
						for (int i = 0; i < branArray.length(); i++) {
							JSONObject branItemJSON = branArray.optJSONObject(i);
							if (branItemJSON != null) {
								mDataList.add(branItemJSON);
								setAddres(branItemJSON);
							}
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (mProvinceDatas.size() > 0) {
					mListView.setAdapter(new SinceAdapter<Province>(mProvinceDatas));
				}
			}

		}

		@Override
		public JsonRequestBean task_request() {
			JsonRequestBean jb = new JsonRequestBean(Run.API_URL, "mobileapi.indexad.getwarehouse");
			jb.addParams("product_id", productID);
			return jb;
		}

	}
}
