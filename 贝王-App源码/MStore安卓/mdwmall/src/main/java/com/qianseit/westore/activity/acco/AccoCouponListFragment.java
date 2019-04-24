package com.qianseit.westore.activity.acco;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.shopping.ShoppCarNouserCouponInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarUseCouponInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AccoCouponListFragment extends BaseListFragment<JSONObject> {

	final int COUPON_AVAILABLE = 0;
	final int COUPON_UNAVAILABLE = 1;

	private boolean isGoodsBuy = false; // false:不是购买界面进入
	private JSONObject oldCoupun;
	private boolean isFastBuy;

	boolean isCancelUse = false;
	JSONObject mCancelUseCoupon;

	String mNewCouponNumber;

	ShoppCarNouserCouponInterface mNouserCouponInterface = new ShoppCarNouserCouponInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (oldCoupun != null && oldCoupun.optString("coupon").equals(mNewCouponNumber)) {
				oldCoupun = null;
				mAdapter.notifyDataSetChanged();
				mCancelUseCoupon = responseJson;
				isCancelUse = true;
				return;
			}
			mUseCouponInterface.useCoupon(mNewCouponNumber, isFastBuy);
		}
	};
	ShoppCarUseCouponInterface mUseCouponInterface = new ShoppCarUseCouponInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			isCancelUse = false;
			Intent data = new Intent();
			data.putExtra(Run.EXTRA_COUPON_DATA, responseJson.toString());
			mActivity.setResult(Activity.RESULT_OK, data);
			mActivity.finish();
		}
	};

	@Override
	protected void back() {
		if (isCancelUse) {
			Intent data = new Intent();
			data.putExtra(Run.EXTRA_COUPON_DATA, mCancelUseCoupon.toString());
			data.putExtra(Run.EXTRA_DATA, isCancelUse);
			mActivity.setResult(Activity.RESULT_OK, data);
			mActivity.finish();
		}
		super.back();
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);

		Bundle nBundle = getArguments();
		if (nBundle != null) {
			isGoodsBuy = nBundle.getBoolean(Run.EXTRA_VALUE, false);

			String nCouponDataString = nBundle.getString(Run.EXTRA_COUPON_DATA);
			if (!TextUtils.isEmpty(nCouponDataString)) {
				try {
					oldCoupun = new JSONObject(nCouponDataString);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			String nIsFastBuy = nBundle.getString(Run.EXTRA_DATA);
			isFastBuy = !TextUtils.isEmpty(nIsFastBuy) && nIsFastBuy.equalsIgnoreCase("true") ? true : false;
		}
	}

	@Override
	protected int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 2;
	}

	@Override
	protected int getItemViewType(JSONObject t) {
		// TODO Auto-generated method stub
		if (t.has("due") || !t.has("memc_code")) {
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
						mNewCouponNumber = nCouponJsonObject.optString("memc_code");
						if (oldCoupun != null && oldCoupun.optString("coupon").equals(mNewCouponNumber)) {
							mNouserCouponInterface.nouseCoupon(oldCoupun.optString("obj_ident"), isFastBuy);
							return;
						}

						if (oldCoupun != null) {
							mNouserCouponInterface.nouseCoupon(oldCoupun.optString("obj_ident"), isFastBuy);
							return;
						}

						mUseCouponInterface.useCoupon(mNewCouponNumber, isFastBuy);
					}
				});
			} else {
				convertView = View.inflate(mActivity, R.layout.item_coupon_unavailable, null);
			}
		}

		int nCount = responseJson.optInt("count");
		((TextView) convertView.findViewById(R.id.coupon_name)).setText(responseJson.optString("cpns_name"));
		((TextView) convertView.findViewById(R.id.coupon_available_date_from)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("from_time")));
		((TextView) convertView.findViewById(R.id.coupon_available_date_to)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("to_time")));
		((TextView) convertView.findViewById(R.id.coupon_dicription2)).setText(responseJson.optString("description"));
		((TextView) convertView.findViewById(R.id.coupon_dicription)).setText(String.format("%s专享优惠券", getString(R.string.app_share_name)));

		if (nViewType == COUPON_UNAVAILABLE) {
			String nActionString = responseJson.optBoolean("due") ? "不支持" : "不可用";
			((TextView) convertView.findViewById(R.id.coupon_action)).setText(nActionString);
			((TextView) convertView.findViewById(R.id.coupon_status)).setText(responseJson.optString("memc_status"));
			convertView.findViewById(R.id.coupon_status).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.coupon_action).setVisibility(View.GONE);
		} else {
			convertView.findViewById(R.id.coupon_status).setVisibility(View.GONE);
			String nAction = "使用";
			if (oldCoupun != null && oldCoupun.optString("coupon").equals(responseJson.optString("memc_code"))) {
				nAction = "取消使用";
				nCount--;
			}
			((TextView) convertView.findViewById(R.id.coupon_action)).setText(nAction);
			convertView.findViewById(R.id.coupon_action).setTag(responseJson);
			if (isGoodsBuy) {
				convertView.findViewById(R.id.coupon_action).setVisibility(View.VISIBLE);
			} else {
				convertView.findViewById(R.id.coupon_action).setVisibility(View.GONE);
			}
		}

		((TextView) convertView.findViewById(R.id.coupon_count)).setText(nCount > 0 ? String.format("(x%d)", nCount) : "");

		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();

		JSONArray nArray = responseJson.optJSONArray("coupons");
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
		nContentValues.put("status", "use");
		if (isGoodsBuy) {
			nContentValues.put("filter_coupon", "1");
			nContentValues.put("isfastbuy", isFastBuy ? "true" : "");
		}
		return nContentValues;
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		View nHeaderView = View.inflate(mActivity, R.layout.header_coupon_list, null);
		topLayout.addView(nHeaderView);

		nHeaderView.findViewById(R.id.coupon_instructions).setOnClickListener(this);
	}

	@Override
	protected void initBottom(LinearLayout bottomLayout) {
		// TODO Auto-generated method stub
		View nFooterView = View.inflate(mActivity, R.layout.footer_coupon, null);
		bottomLayout.addView(nFooterView);

		nFooterView.findViewById(R.id.coupon_more).setOnClickListener(this);
	}

	@Override
	protected void endInit() {
		initGoodEmptyView();
		mListView.setBackgroundResource(R.color.fragment_background_color);
		mListView.setDividerHeight(0);
	}

	void initGoodEmptyView() {
		View nView = View.inflate(mActivity, R.layout.empty_shop_car, null);
		setCustomEmptyView(nView);
		nView.findViewById(R.id.shopping_go).setVisibility(View.GONE);
		ImageView icon = (ImageView) nView.findViewById(R.id.shopping_hint_icon);
		icon.setImageResource(R.drawable.coupon_empty_new);
		TextView title = (TextView) nView.findViewById(R.id.tv_title);
		title.setText("您没有可用的优惠券");
		TextView hint = (TextView) nView.findViewById(R.id.tv_hint);
		hint.setText("优惠券可以享受商品折扣");
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.coupon_instructions:
			startActivity(AgentActivity.FRAGMENT_ACCO_COUPON_INSTRUCTIONS);
			break;
		case R.id.coupon_more:
			startActivityForResult(AgentActivity.FRAGMENT_MARKETING_COUPON_CENTER, 1);
			break;

		default:
			super.onClick(v);
			break;
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode == Activity.RESULT_OK) {
			onRefresh();
		}
		super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.coupon";
	}
}
