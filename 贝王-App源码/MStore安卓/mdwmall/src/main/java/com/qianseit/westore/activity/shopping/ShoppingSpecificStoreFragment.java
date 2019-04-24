package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ListView;
import android.widget.TextView;

import com.amap.api.location.AMapLocation;
import com.amap.api.maps.MapView;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.MarkerOptions;
import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.City;
import com.qianseit.westore.base.County;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;

import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

public class ShoppingSpecificStoreFragment extends ShoppingMapFragment {
    private ListView mAddressListView, mAddressTwoListView, mStoreListView;
    private MapView mStoreMapView;
    private int width;
    private LayoutInflater mInflater;

    private List<City> mAddressArray = new ArrayList<City>();
    private List<County> mAddressTwoArray = new ArrayList<County>();
    private List<JSONObject> mListArray = new ArrayList<JSONObject>();
    private AddressAdapter mAddressAdapter;
    private AddressTwoAdapter mAddressTwoAdapter;
    private ListAdapter mListAdapter;
    private boolean islocation = false;
    private int addresSelect = 0;
    private int listSeledt = 0;
    private int addressTwoSelect = 0;
    private DecimalFormat df = new DecimalFormat("0.#");
    private ArrayList<MarkerOptions> markerOptionlst;
    private String productId;
    private boolean isTouch = false;
    private MarkerOptions markerOptionTop;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mActionBar.setTitle("实体门店");
        Intent intent = mActivity.getIntent();
        productId = intent.getStringExtra(Run.EXTRA_VALUE);
        if (!TextUtils.isEmpty(productId)) {
            // mActionBar.setRightTitleButton("确定", new OnClickListener() {
            //
            // @Override
            // public void onClick(View v) {
            // if (mListArray.size() > 0) {
            // JSONObject dataJSON = mListArray.get(listSeledt);
            // Intent intent = new Intent();
            // intent.putExtra(Run.EXTRA_DATA, dataJSON.toString());
            // mActivity.setResult(Activity.RESULT_OK, intent);
            // mActivity.finish();
            // } else {
            // Run.alert(mActivity, "请选择门店");
            // }
            //
            // }
            // });
        }
    }

    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        mInflater = inflater;
        rootView = inflater.inflate(R.layout.fragment_specif_store_main, null);
        mAddressListView = (ListView) findViewById(R.id.store_address_listview);
        mAddressTwoListView = (ListView) findViewById(R.id.store_address_two_listview);
        mStoreListView = (ListView) findViewById(R.id.store_list_listview);
        mStoreMapView = (MapView) findViewById(R.id.store_mapview);

        mAddressAdapter = new AddressAdapter(mAddressArray);
        mAddressTwoAdapter = new AddressTwoAdapter(mAddressTwoArray);
        mListAdapter = new ListAdapter(mListArray);
        mAddressListView.setAdapter(mAddressAdapter);
        mAddressTwoListView.setAdapter(mAddressTwoAdapter);
        mStoreListView.setAdapter(mListAdapter);

        width = Run.getWindowsWidth(mActivity);
        LayoutParams layoutParams = (LayoutParams) mStoreMapView.getLayoutParams();
        layoutParams.height = (width * 781) / 1242;

        mStoreMapView.onCreate(savedInstanceState);
        initMap(mStoreMapView);

        mAddressListView.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
                if (addresSelect != arg2) {
                    addressTwoSelect = 0;
                    listSeledt = 0;
                    addresSelect = arg2;
                    mAddressTwoArray.clear();
                    mListArray.clear();
                    List<County> listTwoArray = mAddressArray.get(arg2).getCountList();
                    mAddressTwoArray.addAll(listTwoArray);
                    if (listTwoArray.size() > 0) {
                        List<JSONObject> listArray = listTwoArray.get(addressTwoSelect).getDataList();
                        mListArray.addAll(listArray);
                    }
                    mAddressAdapter.notifyDataSetChanged();
                    mAddressTwoAdapter.notifyDataSetChanged();
                    mListAdapter.notifyDataSetChanged();
                    clear();
                    addMarkersToMap(mListArray);
                }

            }
        });

        mAddressTwoListView.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
                if (addressTwoSelect != arg2) {
                    listSeledt = 0;
                    addressTwoSelect = arg2;
                    mListArray.clear();
                    List<JSONObject> listArray = mAddressTwoArray.get(arg2).getDataList();
                    mListArray.addAll(listArray);
                    mAddressTwoAdapter.notifyDataSetChanged();
                    mListAdapter.notifyDataSetChanged();
                    clear();
                    addMarkersToMap(listArray);
                }

            }
        });
        mStoreListView.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
                // if (listSeledt != arg2) {
                // listSeledt = arg2;
                // setMarkers(markerOptionlst, arg2);
                // }
                if (!TextUtils.isEmpty(productId)) {
                    JSONObject dataJSON = mListArray.get(arg2);
                    Intent intent = new Intent();
                    intent.putExtra(Run.EXTRA_DATA, dataJSON.toString());
                    mActivity.setResult(Activity.RESULT_OK, intent);
                    mActivity.finish();
                }
            }
        });

    }

    @Override
    protected void markerIconClick() {
        if (mAddressArray.size() > 0) {
            JSONObject dataJSON = mListArray.get(listSeledt);
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_STORE_INFO).putExtra(Run.EXTRA_DATA, dataJSON.toString()));
        }

    }


    @Override
    protected void LocationPoint(AMapLocation amapLocation) {
        if (amapLocation != null && amapLocation.getErrorCode() == 0) {
            //Run.excuteJsonTask(new JsonTask(), new StoreTask(amapLocation.getLatitude(), amapLocation.getLongitude()));
            setCameraPostionOther(new LatLng(amapLocation.getLatitude(), amapLocation.getLongitude()));
            deactivate();
        } else {
            Run.alert(mActivity, "定位失败：" + amapLocation != null ? amapLocation.getErrorInfo() : "");
        }
    }

    @Override
    protected void CameraChange(CameraPosition arg0) {
        String cStr = arg0.toString();
        int start = cStr.indexOf("(");
        int end = cStr.indexOf(")");
        String datStr = cStr.substring(start + 1, end);
        String[] dataArray = datStr.split(",");
        markerOptionTop = new MarkerOptions();
        markerOptionTop.draggable(true);
        markerOptionTop.position(new LatLng(Double.valueOf(dataArray[0]), Double.valueOf(dataArray[1])));
        Run.excuteJsonTask(new JsonTask(), new StoreTask(Double.valueOf(dataArray[0]), Double.valueOf(dataArray[1])));
    }

    /**
     * 在地图上添加marker
     */
    private void addMarkersToMap(List<JSONObject> dataArray) {

        markerOptionlst = new ArrayList<MarkerOptions>();
//		if (markerOptionTop != null) {
//			markerOptionlst.add(markerOptionTop);
//		}
        if (dataArray != null && dataArray.size() > 0) {
            for (int i = 0; i < dataArray.size(); i++) {
                JSONObject dataJSON = dataArray.get(i);
                String maplocation = dataJSON.optString("w_maplocation");
                String strlocation[] = maplocation.split(",");
                if (strlocation.length >= 2) {
                    MarkerOptions markerOption = new MarkerOptions();
                    markerOption.position(new LatLng(Double.valueOf(strlocation[1]), Double.valueOf(strlocation[0])));
                    markerOption.title(dataJSON.optString("name")).snippet(dataJSON.optString("address"));
                    markerOption.draggable(true);
                    markerOption.icon(

                            BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.marke_postion)));

                    markerOption.setFlat(true);
                    markerOptionlst.add(markerOption);
                }

            }
        }
        if (markerOptionlst.size() > 0) {
            setMarkers(markerOptionlst, -1, false);
        }
    }

    private class AddressAdapter extends QianseitAdapter<City> {

        public AddressAdapter(List<City> dataList) {
            super(dataList);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.item_store_address, null);
            }
            City dataCity = getItem(position);
            boolean ischeck = (addresSelect == position);
            convertView.setBackgroundColor(ischeck ? Color.parseColor("#ffffff") : Color.parseColor("#f3f2f2"));
            ((TextView) convertView.findViewById(R.id.item_store_title)).setText(dataCity.getName() + "市");
            return convertView;
        }

    }

    private class AddressTwoAdapter extends QianseitAdapter<County> {

        public AddressTwoAdapter(List<County> dataList) {
            super(dataList);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.item_store_address, null);
            }
            County dataCounty = getItem(position);
            boolean ischeck = (addressTwoSelect == position);
            convertView.setBackgroundColor(ischeck ? Color.parseColor("#ffffff") : Color.parseColor("#f8f8f8"));
            ((TextView) convertView.findViewById(R.id.item_store_title)).setText(dataCounty.getName());
            return convertView;
        }

    }

    private class ListAdapter extends QianseitAdapter<JSONObject> {

        public ListAdapter(List<JSONObject> dataList) {
            super(dataList);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.item_store_list, null);
            }
            final JSONObject dataJSON = getItem(position);

            ((TextView) convertView.findViewById(R.id.item_list_title_tv)).setText(dataJSON.optString("name"));
            ((TextView) convertView.findViewById(R.id.item_list_distance_tv)).setText("距你" + distaceValue(dataJSON.optInt("jl")));
            convertView.findViewById(R.id.store_list_icon).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_STORE_INFO).putExtra(Run.EXTRA_DATA, dataJSON.toString()));

                }
            });
            return convertView;
        }

    }

    private String distaceValue(int distace) {
        if (distace >= 1000) {
            double value = ((double) distace) / 1000;
            return df.format(value) + "km";
        } else {
            return distace + "m";
        }

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

    public class StoreTask implements JsonTaskHandler {
        double latitude, longitude;

        public StoreTask(double latitude, double longitude) {
            addresSelect = 0;
            addressTwoSelect = 0;
            listSeledt = 0;
            mAddressArray.clear();
            mListArray.clear();
            mAddressTwoArray.clear();
            mListAdapter.notifyDataSetChanged();
            mAddressTwoAdapter.notifyDataSetChanged();
            mAddressAdapter.notifyDataSetChanged();
            this.latitude = latitude;
            this.longitude = longitude;
        }

        @Override
        public JsonRequestBean task_request() {
            showCancelableLoadingDialog();
            JsonRequestBean req = new JsonRequestBean(Run.API_URL, "mobileapi.indexad.getwarehouse");
            req.addParams("lat", String.valueOf(latitude));
            req.addParams("lng", String.valueOf(longitude));
            if (!TextUtils.isEmpty(productId)) {
                req.addParams("product_id", productId);
            }
            return req;
        }

        @Override
        public void task_response(String json_str) {
            hideLoadingDialog();
            try {
                JSONObject all = new JSONObject(json_str);
                if (Run.checkRequestJson(mActivity, all)) {
                    JSONArray dataJSON = all.optJSONArray("data");
                    if (dataJSON != null && dataJSON.length() > 0) {
                        for (int i = 0; i < dataJSON.length(); i++) {
                            JSONObject branItemJSON = dataJSON.optJSONObject(i);
                            if (branItemJSON != null) {
                                setAddres(branItemJSON);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                mStoreMapView.setVisibility(View.VISIBLE);
                if (mAddressArray.size() > 0) {
                    findViewById(R.id.store_null_hint).setVisibility(View.GONE);
                    findViewById(R.id.store_linear_content).setVisibility(View.VISIBLE);
                    List<County> listCountyArray = mAddressArray.get(0).getCountList();
                    if (listCountyArray != null && listCountyArray.size() > 0) {
                        mAddressTwoArray.addAll(listCountyArray);
                        List<JSONObject> listArray = mAddressTwoArray.get(0).getDataList();
                        mListArray.addAll(listArray);
                        addMarkersToMap(listArray);
                    }
                    mListAdapter.notifyDataSetChanged();
                    mAddressTwoAdapter.notifyDataSetChanged();
                    mAddressAdapter.notifyDataSetChanged();
                } else {
                    findViewById(R.id.store_null_hint).setVisibility(View.VISIBLE);
                    findViewById(R.id.store_linear_content).setVisibility(View.GONE);
                }
            }

        }
    }

    private County containsCounty(List<County> list, String name) {
        for (int i = 0; i < list.size(); i++) {
            County mCounty = list.get(i);
            if (name.equals(mCounty.getName())) {
                return mCounty;
            }
        }
        return null;
    }

    private City containsCity(List<City> list, String name) {
        for (int i = 0; i < list.size(); i++) {
            City city = list.get(i);
            if (name.equals(city.getName())) {
                return city;
            }
        }
        return null;
    }

    private void setAddres(JSONObject dataJSON) {
        if (dataJSON == null)
            return;
        if (!dataJSON.isNull("city")) {
            String city = dataJSON.optString("city");
            String county = dataJSON.optString("county");
            City cityObj = containsCity(mAddressArray, city);
            if (cityObj == null) {
                City mCity = new City();
                mCity.setName(city);
                List<County> mCountyList = new ArrayList<County>();
                County mConty = new County();
                mConty.setName(county);
                List<JSONObject> CountyArray = new ArrayList<JSONObject>();
                CountyArray.add(dataJSON);
                mCountyList.add(mConty);
                mConty.setDataList(CountyArray);
                mCity.setCountList(mCountyList);
                mAddressArray.add(mCity);
            } else {
                List<County> mCountyList = cityObj.getCountList();
                County countyObj = containsCounty(mCountyList, county);
                if (countyObj == null) {
                    County mCounty = new County();
                    mCounty.setName(county);
                    List<JSONObject> CountyArray = new ArrayList<JSONObject>();
                    CountyArray.add(dataJSON);
                    mCounty.setDataList(CountyArray);
                    mCountyList.add(mCounty);
                } else {
                    List<JSONObject> CountyArray = countyObj.getDataList();
                    CountyArray.add(dataJSON);
                }
            }
        }


    }

}
