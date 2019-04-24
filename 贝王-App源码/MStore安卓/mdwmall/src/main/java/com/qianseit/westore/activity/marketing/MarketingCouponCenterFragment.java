package com.qianseit.westore.activity.marketing;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.member.MemberGetCouponInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class MarketingCouponCenterFragment extends BaseListFragment<JSONObject> {

	final int COUPON_AVAILABLE = 0;
	final int COUPON_UNAVAILABLE = 1;

	MemberGetCouponInterface mGetCouponInterface = new MemberGetCouponInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			onRefresh();
			mActivity.setResult(Activity.RESULT_OK);
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("领劵中心");
	}

	@Override
	protected int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 2;
	}

	@Override
	protected int getItemViewType(JSONObject t) {
		// TODO Auto-generated method stub
		if (t.optInt("receiveStatus") != 1) {
			return COUPON_UNAVAILABLE;
		} else {
			return COUPON_AVAILABLE;
		}
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		int nViewType = getItemViewType(responseJson);
		if (convertView == null) {
			if (nViewType == COUPON_AVAILABLE) {
				convertView = View.inflate(mActivity, R.layout.item_coupon, null);
				convertView.findViewById(R.id.coupon_action).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						JSONObject nCouponJsonObject = (JSONObject) v.getTag();
						mGetCouponInterface.getCoupon(nCouponJsonObject.optString("cpns_prefix"));
					}
				});
			}else{
				convertView = View.inflate(mActivity, R.layout.item_coupon_unavailable, null);
			}
		}

		((TextView) convertView.findViewById(R.id.coupon_name)).setText(responseJson.optString("cpns_name"));
		((TextView) convertView.findViewById(R.id.coupon_count)).setText("");
		((TextView) convertView.findViewById(R.id.coupon_available_date_from)).setText(responseJson.optString("from_time"));
		((TextView) convertView.findViewById(R.id.coupon_available_date_to)).setText(responseJson.optString("to_time"));
		((TextView) convertView.findViewById(R.id.coupon_dicription2)).setText(responseJson.optString("description"));
		((TextView) convertView.findViewById(R.id.coupon_dicription)).setText(String.format("%s专享优惠券", getString(R.string.app_name)));

		((TextView) convertView.findViewById(R.id.coupon_action)).setText(responseJson.optString("receiveStatusName"));
		convertView.findViewById(R.id.coupon_action).setTag(responseJson);
		if (responseJson.optInt("receiveStatus") == 1) {
			convertView.findViewById(R.id.coupon_action).setEnabled(true);
		} else {
			convertView.findViewById(R.id.coupon_action).setEnabled(false);
		}
		convertView.findViewById(R.id.coupon_status).setVisibility(View.GONE);

		return convertView;
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
		mListView.setBackgroundResource(R.color.fragment_background_color);
		mListView.setDividerHeight(0);
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
		return "b2c.activity.coupon_receive";
	}
}
