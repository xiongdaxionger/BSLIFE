package com.qianseit.westore.activity.shopping;

import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.TextView;

import com.amap.api.maps.MapView;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.MarkerOptions;
import com.beiwangfx.R;
import com.qianseit.westore.Run;

import org.json.JSONObject;

import java.text.DecimalFormat;
import java.util.ArrayList;

public class ShoppingStoreInfoFragment extends ShoppingMapFragment {
	private JSONObject dataJSON;
	private MapView mStoreMapView;
	private int width;
	private DecimalFormat df = new DecimalFormat("0.#");

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Intent mIntent = mActivity.getIntent();
		if (mIntent != null) {
			String dataStr = mIntent.getStringExtra(Run.EXTRA_DATA);
			try {
				dataJSON = new JSONObject(dataStr);
				mActionBar.setTitle(dataJSON.optString("name"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_store_info_main, null);
		mStoreMapView = (MapView) findViewById(R.id.store_info_mapview);
		((TextView) findViewById(R.id.store_info_name_tv)).setText(dataJSON.optString("name"));
		((TextView) findViewById(R.id.store_info_business_tv)).setText(dataJSON.optString("w_openday"));
		((TextView) findViewById(R.id.store_info_business_time_tv)).setText(dataJSON.optString("w_opentime"));
		((TextView) findViewById(R.id.store_info_address_tv)).setText(dataJSON.optString("address"));
		((TextView) findViewById(R.id.store_info_phone_tv)).setText(dataJSON.optString("phone"));
		((TextView) findViewById(R.id.store_info_hint_tv)).setText(dataJSON.optString("w_comment"));
		((TextView) findViewById(R.id.store_info_lenth_tv)).setText(distaceValue(dataJSON.optInt("jl")));
		width = Run.getWindowsWidth(mActivity);
		// LayoutParams layoutParams = (LayoutParams)
		// mStoreMapView.getLayoutParams();
		// layoutParams.h = ;
		// mStoreMapView.setMinimumHeight((width * 780) / 1242);

		mStoreMapView.onCreate(savedInstanceState);
		initMap(mStoreMapView);
		addMarkersToMap(dataJSON);
	}

	private String distaceValue(int distace) {
		if (distace >= 1000) {
			double value = ((double) distace) / 1000;
			return df.format(value) + "km";
		} else {
			return distace + "m";
		}

	}

	@Override
	protected boolean setIconVisble() {
		return false;
	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onResume() {
		super.onResume();
		mStoreMapView.onResume();
	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onPause() {
		super.onPause();
		mStoreMapView.onPause();
		deactivate();
	}

	/**
	 * 
	 * 方法必须重写
	 */
	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		mStoreMapView.onSaveInstanceState(outState);
	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onDestroy() {
		super.onDestroy();
		mStoreMapView.onDestroy();
	}

	/**
	 * 在地图上添加marker
	 */
	private void addMarkersToMap(JSONObject dataJSON) {

		ArrayList<MarkerOptions> markerOptionlst = new ArrayList<MarkerOptions>();
		if (dataJSON != null) {
			String maplocation = dataJSON.optString("w_maplocation");
			String strlocation[] = maplocation.split(",");
			if (strlocation.length >= 2) {
				MarkerOptions markerOption = new MarkerOptions();
				markerOption.position(new LatLng(Double.valueOf(strlocation[1]), Double.valueOf(strlocation[0])));
				markerOption.title(dataJSON.optString("name")).snippet(dataJSON.optString("address"));
				markerOption.draggable(true);
				markerOption.icon(BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.marke_info_postion)));
				markerOption.setFlat(true);
				markerOptionlst.add(markerOption);

			}
		}
		if (markerOptionlst.size() > 0) {
			setMarkers(markerOptionlst,0,true);
		}
	}
}
