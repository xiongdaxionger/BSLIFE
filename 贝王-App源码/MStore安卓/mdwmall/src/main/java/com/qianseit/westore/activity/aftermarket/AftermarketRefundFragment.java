package com.qianseit.westore.activity.aftermarket;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.aftermarket.AftermarketGetRefundInterface;
import com.qianseit.westore.httpinterface.aftermarket.AftermarketRefundSubmitInterface;
import com.beiwangfx.R;

public class AftermarketRefundFragment extends BaseDoFragment {
	final String CHOOSED_FIELD = "choosed";
	final String INPUT_QTY_FIELD = "inputqty";

	List<JSONObject> mList;
	QianseitAdapter<JSONObject> mAdapter;
	ListView mListView;
	JSONObject mOrderJsonObject, mRefundTypeJsonObject;
	String mOrderIdString;

	TextView mTotalAmountTextView;
	EditText mTitleEditText;
	EditText mContentEditText;

	boolean mIsRefundAll = true;
	AftermarketRefundSubmitInterface mRefundSubmitInterface = new AftermarketRefundSubmitInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Intent nIntent = new Intent();
			nIntent.putExtra(Run.EXTRA_DATA, mIsRefundAll);
			mActivity.setResult(Activity.RESULT_OK, nIntent);
			mActivity.finish();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("申请退款");

		Bundle nBundle = mActivity.getIntent().getExtras();
		mList = new ArrayList<JSONObject>();
		if (nBundle != null) {
			mOrderIdString = nBundle.getString(Run.EXTRA_ORDER_ID);
		}

		if (TextUtils.isEmpty(mOrderIdString)) {
			Run.alert(mActivity, "待退款订单Id不能为空");
			mActivity.finish();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_aftermarket_refund, null);

		mListView = (ListView) findViewById(R.id.aftermarket_refund_list);
		mAdapter = new QianseitAdapter<JSONObject>(mList) {

			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				// TODO Auto-generated method stub
				if (convertView == null) {
					int layout = R.layout.item_aftermarket_goods;
					convertView = LayoutInflater.from(mActivity).inflate(layout, null);
					convertView.findViewById(R.id.selected).setOnClickListener(AftermarketRefundFragment.this);
					convertView.findViewById(R.id.minus).setOnClickListener(AftermarketRefundFragment.this);
					convertView.findViewById(R.id.plus).setOnClickListener(AftermarketRefundFragment.this);
					convertView.findViewById(R.id.thumb).setOnClickListener(AftermarketRefundFragment.this);
				}

				JSONObject all = getItem(position);
				if (all == null)
					return convertView;

				convertView.setTag(all);
				assignmentItemView(convertView, all);
				convertView.findViewById(R.id.selected).setTag(all);
				convertView.findViewById(R.id.thumb).setTag(all);
				convertView.findViewById(R.id.plus).setTag(all);
				convertView.findViewById(R.id.minus).setTag(all);

				// 选中与否
				((ImageButton) convertView.findViewById(R.id.selected)).setImageResource(all.optBoolean(CHOOSED_FIELD) ? R.drawable.qianse_item_status_selected
						: R.drawable.qianse_item_status_unselected);
				return convertView;
			}
		};
		mListView.setAdapter(mAdapter);

		mTotalAmountTextView = (TextView) findViewById(R.id.aftermarket_refund_price);
		mTitleEditText = (EditText) findViewById(R.id.aftermarket_refund_reason);
		mContentEditText = (EditText) findViewById(R.id.aftermarket_refund_remark);

		findViewById(R.id.base_submit_btn).setOnClickListener(this);

		new AftermarketGetRefundInterface(this, mOrderIdString, "refund") {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mOrderJsonObject = responseJson;
				JSONArray nTypeArray = mOrderJsonObject.optJSONArray("refund_type");
				mRefundTypeJsonObject = nTypeArray != null && nTypeArray.length() > 0 ? nTypeArray.optJSONObject(0) : new JSONObject();
				mRefundSubmitInterface.setRefundType(mOrderJsonObject.optString("order_id"), mRefundTypeJsonObject.optInt("value"));

				JSONArray nArray = mOrderJsonObject.optJSONArray("goods_items");
				try {
					for (int i = 0; i < nArray.length(); i++) {
						JSONObject nItem = nArray.optJSONObject(i);
						nItem.put(CHOOSED_FIELD, true);
						nItem.put(INPUT_QTY_FIELD, nItem.optInt("quantity"));
						mList.add(nItem);
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				mAdapter.notifyDataSetChanged();
				assignmentTotalAmount();
			}
		}.RunRequest();
	}

	private void assignmentItemView(View view, final JSONObject all) {
		EditText mCarQuantity = ((EditText) view.findViewById(R.id.quantity));
		mCarQuantity.setText(all.optString(INPUT_QTY_FIELD));
		mCarQuantity.setEnabled(false);

		// 商品信息
		JSONObject product = all;
		((TextView) view.findViewById(R.id.price)).setText(product.optString("price_format"));
		// 原价
		TextView oldPriceTV = (TextView) view.findViewById(R.id.oldprice);
		oldPriceTV.setVisibility(View.INVISIBLE);
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		((TextView) view.findViewById(R.id.title)).setText(product.optString("name"));
		if (!product.isNull("attr"))
			((TextView) view.findViewById(R.id.info1)).setText(product.optString("attr"));
		displaySquareImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
	}

	void assignmentTotalAmount() {
		double nTotalAmount = 0;
		for (int i = 0; i < mList.size(); i++) {
			if (mList.get(i).optBoolean(CHOOSED_FIELD)) {
				nTotalAmount = nTotalAmount + mList.get(i).optDouble("price") * mList.get(i).optInt(INPUT_QTY_FIELD);
			}
		}

		mTotalAmountTextView.setText(String.format("%.2f", nTotalAmount));
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		JSONObject all;
		switch (v.getId()) {
		case R.id.base_submit_btn:
			mRefundSubmitInterface.reset();
			mIsRefundAll = true;
			for (int i = 0; i < mList.size(); i++) {
				if (mList.get(i).optBoolean(CHOOSED_FIELD)) {
					JSONObject nJsonObject = mList.get(i);
					mRefundSubmitInterface.addGoods(nJsonObject.optString("product_id"), nJsonObject.optString("bn"), nJsonObject.optString(INPUT_QTY_FIELD), nJsonObject.optString("name"),
							nJsonObject.optString("price"));
					if (nJsonObject.optInt(INPUT_QTY_FIELD) < nJsonObject.optInt("quantity")) {
						mIsRefundAll = false;
					}
				}else{
					mIsRefundAll = false;
				}
			}

			if (mRefundSubmitInterface.getRefundProductCount() < 1) {
				Run.alert(mActivity, "请选择要退款的商品");
				return;
			}

			if (mTitleEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请填写退款理由");
				mTitleEditText.requestFocus();
				return;
			}
			mRefundSubmitInterface.refund(mTitleEditText.getText().toString(), mContentEditText.getText().toString());
			break;
		case R.id.plus:
			all = (JSONObject) v.getTag();
			modQty(all, true);
			break;
		case R.id.minus:
			all = (JSONObject) v.getTag();
			modQty(all, false);
			break;
		case R.id.selected:
			all = (JSONObject) v.getTag();
			try {
				all.put(CHOOSED_FIELD, !all.optBoolean(CHOOSED_FIELD));
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			mAdapter.notifyDataSetChanged();
			assignmentTotalAmount();
			break;
		case R.id.itemview:
		case R.id.thumb:
			all = (JSONObject) v.getTag();
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID,
					all.optString("product_id")));
			break;
		default:
			break;
		}
	}

	void modQty(JSONObject all, boolean add) {
		int nOQty = all.optInt("quantity");
		int nIQty = all.optInt(INPUT_QTY_FIELD);

		if ((!add && nIQty <= 1) || (add && nIQty >= nOQty)) {
			return;
		}

		if (add) {
			nIQty++;
		} else {
			nIQty--;
		}

		try {
			all.put(INPUT_QTY_FIELD, nIQty);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mAdapter.notifyDataSetChanged();
		assignmentTotalAmount();
	}
}
