package com.qianseit.westore.activity.shopping;

import android.graphics.Point;
import android.os.Bundle;
import android.text.SpannableString;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationClientOption.AMapLocationMode;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps.AMap;
import com.amap.api.maps.AMap.CancelableCallback;
import com.amap.api.maps.AMap.InfoWindowAdapter;
import com.amap.api.maps.AMap.OnCameraChangeListener;
import com.amap.api.maps.AMap.OnInfoWindowClickListener;
import com.amap.api.maps.AMap.OnMapLoadedListener;
import com.amap.api.maps.AMap.OnMarkerClickListener;
import com.amap.api.maps.CameraUpdate;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.LocationSource;
import com.amap.api.maps.MapView;
import com.amap.api.maps.UiSettings;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.Circle;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.beiwangfx.R;
import com.qianseit.westore.base.BaseDoFragment;

import java.util.ArrayList;
import java.util.List;

public class ShoppingMapFragment extends BaseDoFragment implements OnMarkerClickListener, OnInfoWindowClickListener, OnMapLoadedListener, InfoWindowAdapter, LocationSource, AMapLocationListener,
		OnCameraChangeListener, CancelableCallback {
	private AMapLocationClient mlocationClient;
	private AMapLocationClientOption mLocationOption;
	private AMap aMap;
	private UiSettings mUiSettings;
	public OnLocationChangedListener mListener;
	private Marker marker;
	private Circle circle;
	private boolean isLocation = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("实体店");
	}

	/**
	 * 初始化AMap对象
	 */
	protected void initMap(MapView mapView) {

		if (aMap == null) {
			aMap = mapView.getMap();
			mUiSettings = aMap.getUiSettings();
			mUiSettings.setZoomControlsEnabled(false);
			mUiSettings.setScaleControlsEnabled(true);

			aMap.setOnMapLoadedListener(this);// 设置amap加载成功事件监听器
			aMap.setOnMarkerClickListener(this);// 设置点击marker事件监听器
			aMap.setOnInfoWindowClickListener(this);// 设置点击infoWindow事件监听器
			aMap.setInfoWindowAdapter(this);// 设置自定义InfoWindow样式
			aMap.setOnCameraChangeListener(this);

			aMap.setLocationSource(this);// 设置定位监听
			aMap.setMyLocationEnabled(true);
			aMap.setMyLocationType(AMap.LOCATION_TYPE_LOCATE);// 设置定位

		}
	}

	protected void clear() {
		if (aMap != null)
			aMap.clear();
	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onResume() {
		super.onResume();
	}

	protected void setMarkers(ArrayList<MarkerOptions> markerOptionlst, int postion, boolean isDisplay) {
		if (markerOptionlst == null)
			return;
		List<Marker> markerlst = aMap.addMarkers(markerOptionlst, isDisplay);
		if (postion >= 0 && postion < markerOptionlst.size()) {
			Marker marker = markerlst.get(postion);
			marker.showInfoWindow();
		}
	}

	/**
	 * 
	 * @param lat
	 *            根据经纬度显示地理位置
	 */

	protected void setCameraPostion(LatLng lat) {
		aMap.moveCamera(CameraUpdateFactory.newCameraPosition(new CameraPosition(lat, 18, 0, 30)));
	}

	protected void setCameraPostionOther(LatLng lat) {
		changeCamera(CameraUpdateFactory.newCameraPosition(new CameraPosition(lat, 18, 30, 0)), this, true);
	}

	/**
	 * 根据动画按钮状态，调用函数animateCamera或moveCamera来改变可视区域
	 */
	private void changeCamera(CameraUpdate update, CancelableCallback callback, boolean animated) {

		if (animated) {
			aMap.animateCamera(update, 1000, callback);
		} else {
			aMap.moveCamera(update);
		}
	}

	/**
	 * 
	 * @param isScroll
	 *            设置是否可以滑动
	 */
	protected void setScrollGestures(boolean isScroll) {
		mUiSettings.setScrollGesturesEnabled(isScroll);
	}

	/**
	 * 
	 * @param isZoom
	 *            设置是否可以缩放
	 */
	protected void setZoomGestures(boolean isZoom) {
		mUiSettings.setZoomGesturesEnabled(isZoom);
	}

	protected void getLocation(Point paramPoint) {

		// Projection.fromScreenLocation(paramPoint);
		// Projection
	}

	/**
	 * 
	 * @param amapLocation
	 *            //获取当前位置
	 */
	protected void LocationPoint(AMapLocation amapLocation) {

	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onPause() {
		super.onPause();
		deactivate();
	}

	/**
	 * 
	 * 方法必须重写
	 */
	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
	}

	/**
	 * 方法必须重写
	 */
	@Override
	public void onDestroy() {
		super.onDestroy();
		if (null != mlocationClient) {
			mlocationClient.onDestroy();
		}
	}

	@Override
	public void onMapLoaded() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onInfoWindowClick(Marker arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onMarkerClick(Marker marker) {

		if (aMap != null) {
			// growInto(marker);
		}
		return false;
	}

	@Override
	public View getInfoContents(Marker marker) {
		View infoContent = getLayoutInflater().inflate(R.layout.custom_info_contents, null);
		render(marker, infoContent);
		return infoContent;
	}

	@Override
	public View getInfoWindow(Marker arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 自定义infowinfow窗口
	 */
	public void render(Marker marker, View view) {

		String title = marker.getTitle();
		TextView titleUi = ((TextView) view.findViewById(R.id.title));
		if (title != null) {
			SpannableString titleText = new SpannableString(title);
			// titleText.setSpan(new ForegroundColorSpan(Color.RED), 0,
			// titleText.length(), 0);
			// titleUi.setTextSize(15);
			titleUi.setText(titleText);

		} else {
			titleUi.setText("");
		}
		String snippet = marker.getSnippet();
		TextView snippetUi = ((TextView) view.findViewById(R.id.snippet));
		if (snippet != null) {
			SpannableString snippetText = new SpannableString(snippet);
			// snippetText.setSpan(new ForegroundColorSpan(Color.GREEN), 0,
			// snippetText.length(), 0);
			// snippetUi.setTextSize(20);
			snippetUi.setText(snippetText);
		} else {
			snippetUi.setText("");
		}
		if (setIconVisble()) {
			view.findViewById(R.id.market_icon).setVisibility(View.VISIBLE);
		} else {
			view.findViewById(R.id.market_icon).setVisibility(View.GONE);
		}
		view.findViewById(R.id.market_icon).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				markerIconClick();
			}
		});
	}

	protected boolean setIconVisble() {
		return true;
	}

	protected void markerIconClick() {

	}

	@Override
	public void onLocationChanged(AMapLocation amapLocation) {
		if (mListener != null && amapLocation != null) {
			if (amapLocation.getErrorCode() == 0) {
				LocationPoint(amapLocation);
				// mListener.onLocationChanged(amapLocation);// 显示系统小蓝点
				// 定位成功后把地图移动到当前可视区域内
				// if (!isLocation) {
				// isLocation = true;
				// LatLng latLng = new LatLng(amapLocation.getLatitude(),
				// amapLocation.getLongitude());
				// setCameraPostion(latLng);
				// LocationPoint(amapLocation);
				// if (marker != null)
				// marker.destroy();
				// if (circle != null)
				// circle.remove();
				// aMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng,
				// 10));
				// // 自定义定位成功后的小圆点
				// marker = aMap.addMarker(new
				// MarkerOptions().position(latLng).anchor(0.5f, 0.5f)// 锚点设置为中心
				// .icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_delete)));
				// 自定义定位成功后绘制圆形
				// circle = aMap.addCircle(new
				// CircleOptions().center(latLng).radius(50000).fillColor(Color.BLUE).strokeColor(Color.BLACK).strokeWidth(3f));
				// }
			} else {
				String errText = "定位失败," + amapLocation.getErrorCode() + ": " + amapLocation.getErrorInfo();
				Log.e("AmapErr", errText);
			}
		}

	}

	@Override
	public void activate(OnLocationChangedListener listener) {
		mListener = listener;
		if (mlocationClient == null) {
			mlocationClient = new AMapLocationClient(mActivity);
			mLocationOption = new AMapLocationClientOption();
			// 设置定位监听
			mlocationClient.setLocationListener(this);
			// 设置为高精度定位模式
			mLocationOption.setLocationMode(AMapLocationMode.Hight_Accuracy);
			// 设置定位参数
			mlocationClient.setLocationOption(mLocationOption);
			// 此方法为每隔固定时间会发起一次定位请求，为了减少电量消耗或网络流量消耗，
			// 注意设置合适的定位时间的间隔（最小间隔支持为2000ms），并且在合适时间调用stopLocation()方法来取消定位请求
			// 在定位结束后，在合适的生命周期调用onDestroy()方法
			// 在单次定位情况下，定位无论成功与否，都无需调用stopLocation()方法移除请求，定位sdk内部会移除
			mlocationClient.startLocation();
		}

	}

	@Override
	public void deactivate() {
		mListener = null;
		if (mlocationClient != null) {
			mlocationClient.stopLocation();
			mlocationClient.onDestroy();
		}
		mlocationClient = null;
	}

	@Override
	public void onCameraChange(CameraPosition arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onCameraChangeFinish(CameraPosition arg0) {
		// VisibleRegion visibleRegion =
		// aMap.getProjection().getVisibleRegion(); // 获取可视区域、

		// LatLngBounds latLngBounds = visibleRegion.latLngBounds;//
		// 获取可视区域的Bounds
		// boolean isContain = latLngBounds.contains(Constants.SHANGHAI);//
		// 判断上海经纬度是否包括在当前地图可见区域
		CameraChange(arg0);

	}

	/**
	 * 
	 * @param arg0
	 *            移动位置
	 */
	protected void CameraChange(CameraPosition arg0) {

	}

	@Override
	public void onCancel() {

	}

	@Override
	public void onFinish() {
		// TODO Auto-generated method stub

	}

}
