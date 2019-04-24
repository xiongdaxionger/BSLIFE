package com.qianseit.westore.activity.shopping;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.text.util.Linkify;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.shopping.ShoppOrderDetailInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppOrderLogisticsInterface;
import com.qianseit.westore.ui.XPullDownListView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

@SuppressLint("ResourceAsColor")
public class ShoppingLogisticsFragment extends BaseListFragment<JSONObject> {
	private TextView mLogisticsName;
	private TextView mLogisticsId;
	private String mOrderId, mDeliveryId;
	private List<JSONObject> infoArray = new ArrayList<JSONObject>();

	ShoppOrderDetailInterface mDetailInterface = new ShoppOrderDetailInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (responseJson == null) {
				return;
			}
			
			JSONObject nOrderJsonObject = responseJson.optJSONObject("order");
			if (nOrderJsonObject == null) {
				return;
			}
			
			JSONArray nArray = nOrderJsonObject.optJSONArray("logistic");
			if (nArray == null || nArray.length() <= 0) {
				return;
			}
			
			mDeliveryId = nArray.optJSONObject(0).optString("delivery_id");
			onRefresh();
		}
	};
	ShoppOrderLogisticsInterface mLogisticsInterface = new ShoppOrderLogisticsInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			
		}
	};
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("物流详情");
		mOrderId = getExtraStringFromBundle(Run.EXTRA_ORDER_ID);
		mDeliveryId = getExtraStringFromBundle(Run.EXTRA_DELIVERY_ID);
	}

	@Override
	protected void addHeader(XPullDownListView listView) {
		// TODO Auto-generated method stub
		super.addHeader(listView);
		View nHeaderView = View.inflate(mActivity, R.layout.header_logistics, null);
		mLogisticsName = (TextView) nHeaderView.findViewById(R.id.acco_logistics_name);
		mLogisticsId = (TextView) nHeaderView.findViewById(R.id.acco_logistics_id);
		listView.addHeaderView(nHeaderView);
		
		if (TextUtils.isEmpty(mDeliveryId)) {
			if (!TextUtils.isEmpty(mOrderId)) {
				AutoLoad(false);
				mDetailInterface.getDetail(mOrderId);
			}
		}
		
		PageEnable(false);
		listView.setEmptyView(null);
		setEmptyText("没有物流信息");
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		ViewHolder holder = null;
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_logistics, null);
			holder = new ViewHolder();
			holder.icon = (ImageView) convertView.findViewById(R.id.iv_route_icon);
			holder.icon_top_line = convertView.findViewById(R.id.icon_top_line);
			holder.icon_bottom_line = convertView.findViewById(R.id.icon_bottom_line);
			holder.ll_bottom_line = (LinearLayout) convertView.findViewById(R.id.ll_bottom_line);
			holder.info = (TextView) convertView.findViewById(R.id.tv_route_info);
			holder.info.setAutoLinkMask(Linkify.ALL);
			holder.time = (TextView) convertView.findViewById(R.id.tv_route_time);
			holder.address = (TextView) convertView.findViewById(R.id.tv_route_address);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		JSONObject data = responseJson;
		int nPosition = mResultLists.indexOf(responseJson);
		holder.info.setTextColor(Color.parseColor("#999999"));
		holder.time.setTextColor(Color.parseColor("#999999"));
		holder.address.setTextColor(Color.parseColor("#999999"));
		if (nPosition == 0) {
			holder.icon.setImageDrawable(mActivity.getResources().getDrawable(R.drawable.logistics_track_arrive));
			holder.icon_top_line.setVisibility(View.INVISIBLE);
			holder.icon_bottom_line.setVisibility(View.VISIBLE);
			holder.ll_bottom_line.setVisibility(View.VISIBLE);
			holder.info.setTextColor(Color.parseColor("#f04641"));
			holder.time.setTextColor(Color.parseColor("#f04641"));
			holder.address.setTextColor(Color.parseColor("#f04641"));
		} else if (nPosition == infoArray.size() - 1) {
			holder.icon.setImageDrawable(mActivity.getResources().getDrawable(R.drawable.logistics_track_point));
			holder.icon_bottom_line.setVisibility(View.INVISIBLE);
			holder.ll_bottom_line.setVisibility(View.INVISIBLE);
			holder.icon_top_line.setVisibility(View.VISIBLE);
		} else {
			holder.icon.setImageDrawable(mActivity.getResources().getDrawable(R.drawable.logistics_track_point));
			holder.icon_top_line.setVisibility(View.VISIBLE);
			holder.icon_bottom_line.setVisibility(View.VISIBLE);
			holder.ll_bottom_line.setVisibility(View.VISIBLE);
		}

		holder.info.setText(data.optString("AcceptStation"));
		holder.time.setText(data.optString("AcceptTime"));
		String location = data.optString("Remark");
		if (!TextUtils.isEmpty(location) && !"null".equals(location)) {
			holder.address.setVisibility(View.VISIBLE);
			holder.address.setText(location);
		} else {
			holder.address.setVisibility(View.GONE);
		}
		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (responseJson == null) {
			return nJsonObjects;
		}

		String nName = responseJson.optString("logi_name");
		String nNumber = responseJson.optString("logi_no");
		if (nName != null && nName.equalsIgnoreCase("null")) {
			nName = "";
		}
		if (nNumber != null && nNumber.equalsIgnoreCase("null")) {
			nName = "";
		}
		mLogisticsName.setText("物流公司：" + (!TextUtils.isEmpty(nName) ? nName : "暂无物流公司"));
		mLogisticsId.setText("运单编号：" + (!TextUtils.isEmpty(nNumber) ? nNumber : "暂无运单编号"));
		
		JSONArray nArray = responseJson.optJSONArray("logi");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}
		
		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}
		
		return nJsonObjects;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("delivery_id", mDeliveryId);
		return nContentValues;
	}
	
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.order.get_delivery";
	}

	private class ViewHolder {
		private ImageView icon;
		private View icon_top_line;
		private View icon_bottom_line;
		private LinearLayout ll_bottom_line;
		private TextView info;
		private TextView time;
		private TextView address;
	}
}
