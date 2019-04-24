package com.qianseit.westore.activity.aftermarket;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.order.OrderListFragment;

import org.json.JSONException;
import org.json.JSONObject;

public class AftermarketOrderListFragment extends OrderListFragment {
	final int REQUEST_REFUND = 1;
	final int REQUEST_RETURN_GOODS = 2;

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", mOrderType);
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "aftersales.aftersales.afterlist";
	}

	@Override
	protected View getStatusView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_status, null);
			convertView.findViewById(R.id.prepare_remark).setVisibility(View.GONE);
			convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.GONE);
			convertView.findViewById(R.id.subtotal).setVisibility(View.GONE);
			convertView.findViewById(R.id.subtotal_divider).setVisibility(View.GONE);
		}
		JSONObject nOrderJsonObject = getParentOrder(responseJson.optInt(ITEM_PARENT_INDEX));

		LinearLayout nBtnsLayout = (LinearLayout) convertView.findViewById(R.id.buttons);
		nBtnsLayout.removeAllViews();

		TextView nAfterSalesTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
		boolean nIsAfterrec = nOrderJsonObject.optBoolean("is_afterrec");
		nAfterSalesTextView.setBackground(nIsAfterrec ? getResources().getDrawable(R.drawable.shape_order_action) : null);
		if (mOrderType.equals("reship")) {
			nAfterSalesTextView.setText(nIsAfterrec ? "申请售后" : "已申请售后");
		} else {
			nAfterSalesTextView.setText(nIsAfterrec ? "申请退款" : "已申请退款");
		}
		nBtnsLayout.addView(nAfterSalesTextView, mButtonLayoutParams);
		nAfterSalesTextView.setTag(nOrderJsonObject);
		nAfterSalesTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurOrderJsonObject = (JSONObject) v.getTag();
				if (!mCurOrderJsonObject.optBoolean("is_afterrec")) {
					return;
				}

				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_ORDER_ID, mCurOrderJsonObject.optString("order_id"));
				if (mOrderType.equals("reship")) {// 申请售后
					startActivityForResult(AgentActivity.FRAGMENT_AFTERMARKET_RETURN_GOODS, nBundle, REQUEST_RETURN_GOODS);
				} else {// 申请退款
					startActivityForResult(AgentActivity.FRAGMENT_AFTERMARKET_REFUND, nBundle, REQUEST_REFUND);
				}
			}
		});

		return convertView;
	}

	@Override
	protected void endInit() {
		super.endInit();
		if (mOrderType.equals("reship")){
			setEmptyText("暂无退货订单");
		}else{
			setEmptyText("暂无退款订单");
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode == Activity.RESULT_OK) {

			switch (requestCode) {
			case REQUEST_REFUND:
				try {
					mCurOrderJsonObject.put("is_afterrec", !data.getBooleanExtra(Run.EXTRA_DATA, false));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				mAdapter.notifyDataSetChanged();
				break;
			case REQUEST_RETURN_GOODS:
				try {
					mCurOrderJsonObject.put("is_afterrec", !data.getBooleanExtra(Run.EXTRA_DATA, false));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				mAdapter.notifyDataSetChanged();
				break;

			default:
				super.onActivityResult(requestCode, resultCode, data);
				break;
			}
		} else {
			super.onActivityResult(requestCode, resultCode, data);
		}
	}
}
