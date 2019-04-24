package com.qianseit.westore.activity.aftermarket;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListPopupWindow;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.other.CaptureActivity;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.httpinterface.aftermarket.AftermarketSaveExpressInterface;
import com.qianseit.westore.ui.CustomListCheckPopupWindow;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AftermarketReturnGoodsListFragment extends AftermarketRefundListFragment {
	final int REQUEST_DELIVERY_NUM = 0x01;

	List<String> mBeans = new ArrayList<String>();
	ListPopupWindow mListPopupWindow;
	CustomListCheckPopupWindow mCheckPopupWindow;
	ArrayAdapter<String> mCompressAdapter;

	JSONObject mCurGroupJsonObject;
	EditText mNumEditText;
	TextView mNameTextView;
	Dialog mDeliveryDialog;

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mListPopupWindow = new ListPopupWindow(mActivity);
		mCompressAdapter = new ArrayAdapter<String>(mActivity, R.layout.item_simple_list_1, mBeans);
		mListPopupWindow.setAdapter(mCompressAdapter);
		mListPopupWindow.setWidth(LayoutParams.WRAP_CONTENT);
		mListPopupWindow.setHeight(LayoutParams.WRAP_CONTENT);
		mListPopupWindow.setModal(true);// 设置是否是模式
		mListPopupWindow.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView parent, View view, int position, long id) {
				if (mCurGroupJsonObject == null) {
					return;
				}
				mNameTextView.setText(mBeans.get(position));
				mListPopupWindow.dismiss();
			}
		});
		
		createDeliveryDialog();

		setEmptyText("暂无退货记录");
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", "reship");
		return nContentValues;
	}

	@Override
	protected View getGroupItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, boolean isExpanded, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopping_orders_group, null);
			convertView.findViewById(R.id.shopping_orders_group_status).setVisibility(View.GONE);
		}
		JSONObject all = groupBean.mGrupItem;
		String ordersNum = all.optString("order_id");
		convertView.setTag(all);

		// 订单号
		TextView textNumber = (TextView) convertView.findViewById(R.id.shopping_orders_group_number);
		textNumber.setText(ordersNum);

		View goDetailView = convertView.findViewById(R.id.shopping_orders_group_go_detail);
		goDetailView.setTag(all);
		goDetailView.setOnClickListener(this);

		return convertView;
	}

	@Override
	protected View getGroupFooterView(final ExpandListItemBean<JSONObject, JSONObject> groupBean) {
		// TODO Auto-generated method stub
		View nFooterView = View.inflate(mActivity, R.layout.item_shopping_aftermarket_refund_orders_group_footer, null);

		nFooterView.findViewById(R.id.shopping_orders_item_express_ll).setVisibility(View.VISIBLE);

		((TextView) nFooterView.findViewById(R.id.shopping_orders_item_reason_content)).setText(String.format("%1$s，%2$s",
				groupBean.mGrupItem.optString("title"), groupBean.mGrupItem.optString("content")));

		JSONArray nCommentArray = groupBean.mGrupItem.optJSONArray("comment");
		if (nCommentArray == null || nCommentArray.length() <= 0) {
			nFooterView.findViewById(R.id.shopping_orders_item_comment_ll).setVisibility(View.GONE);
		} else {
			nFooterView.findViewById(R.id.shopping_orders_item_comment_ll).setVisibility(View.VISIBLE);

			StringBuilder nBuilder = new StringBuilder();
			for (int i = 0; i < nCommentArray.length(); i++) {
				JSONObject nItemJsonObject = nCommentArray.optJSONObject(i);
				nBuilder.append(StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", nItemJsonObject.optLong("time")));
				nBuilder.append("    ");
				nBuilder.append(nItemJsonObject.optString("content"));
				nBuilder.append("\n");
			}
			if (nBuilder.length() > 0) {
				nBuilder.deleteCharAt(nBuilder.length() - 1);
			}

			((TextView) nFooterView.findViewById(R.id.shopping_orders_item_comment_content)).setText(nBuilder.toString());
			nBuilder.delete(0, nBuilder.length());
		}

		JSONObject nExpressJsonObject = groupBean.mGrupItem.optJSONObject("delivery_data");
		nFooterView.findViewById(R.id.input_delivery).setVisibility(groupBean.mGrupItem.optInt("delivery_status") == 1?View.VISIBLE:View.GONE);
		nFooterView.findViewById(R.id.input_delivery).setTag(groupBean.mGrupItem);
		nFooterView.findViewById(R.id.input_delivery).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mCurGroupJsonObject = (JSONObject) v.getTag();
				mNameTextView.setText("");
				mNumEditText.setText("");
				mDeliveryDialog.show();
			}
		});
		if (nExpressJsonObject == null || !nExpressJsonObject.has("crop_no")) {
			nFooterView.findViewById(R.id.shopping_orders_item_express_ll).setVisibility(View.GONE);
		} else {
			nFooterView.findViewById(R.id.shopping_orders_item_express_ll).setVisibility(View.VISIBLE);
			((TextView) nFooterView.findViewById(R.id.shopping_orders_item_express_content)).setText(String.format("快递公司：%1$s\n快递单号：%2$s",
					nExpressJsonObject.optString("crop_code"), nExpressJsonObject.optString("crop_no")));
		}

		((Button) nFooterView.findViewById(R.id.shopping_orders_item_action)).setText(groupBean.mGrupItem.optString("status"));

		return nFooterView;
	}

	@Override
	protected List<ExpandListItemBean<JSONObject, JSONObject>> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (mPageNum == 1) {
			JSONArray nArray = responseJson.optJSONArray("dlycorp");
			if (nArray != null && nArray.length() > 0) {
				mBeans.clear();
				for (int i = 0; i < nArray.length(); i++) {
					mBeans.add(nArray.optString(i));
				}
				mCompressAdapter.notifyDataSetChanged();
			}
		}
		List<ExpandListItemBean<JSONObject, JSONObject>> nBeans = new ArrayList<BaseExpandListFragment.ExpandListItemBean<JSONObject, JSONObject>>();
		JSONArray array = responseJson.optJSONArray("return_list");
		for (int i = 0, count = array.length(); i < count; i++) {

			ExpandListItemBean<JSONObject, JSONObject> nBean = new ExpandListItemBean<JSONObject, JSONObject>();
			nBean.mGrupItem = array.optJSONObject(i);

			JSONArray goodsArray = nBean.mGrupItem.optJSONArray("product_data");

			if (goodsArray != null && goodsArray.length() > 0) {
				for (int j = 0; j < goodsArray.length(); j++)
					nBean.mDetailLists.add(goodsArray.optJSONObject(j));
			}
			nBeans.add(nBean);
		}
		return nBeans;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.shopping_orders_group_go_detail) {
			final JSONObject nOrderJsonObject = (JSONObject) v.getTag();
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDERS_DETAIL).putExtra(Run.EXTRA_ORDER_ID,
					nOrderJsonObject.optString("order_id")));
		}
	}

	void createDeliveryDialog(){
		mDeliveryDialog = new Dialog(mActivity, R.style.Theme_dialog);
		View view = null;
		try {
			view = LayoutInflater.from(mActivity).inflate(R.layout.dialog_input_delivery, null);

			mNumEditText = (EditText) view.findViewById(R.id.delivery_num);
			mNumEditText.requestFocus();
			
			mNameTextView = (TextView) view.findViewById(R.id.delivery_name);

			view.findViewById(R.id.dialog_cancel_btn).setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					mDeliveryDialog.dismiss();
				}
			});
			
			view.findViewById(R.id.scan).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Intent nIntent = new Intent(mActivity, CaptureActivity.class);
					nIntent.putExtra(Run.EXTRA_DETAIL_TYPE, true);
					startActivityForResult(nIntent, REQUEST_DELIVERY_NUM);
				}
			});
			mNameTextView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mListPopupWindow.setAnchorView(v);
					mListPopupWindow.show();
				}
			});

			Button okBtn = (Button) view.findViewById(R.id.dialog_conform_btn);
			okBtn.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					if (mNumEditText.getText().length() <= 0 || mNumEditText.getText().toString().equals("请选择快递公司")) {
						Run.alert(mActivity, "请输入快递公司名称");
						mNumEditText.requestFocus();
						return;
					}

					if (mNameTextView.getText().length() <= 0) {
						Run.alert(mActivity, "请输入快递单号");
						mNameTextView.requestFocus();
						return;
					}

					new AftermarketSaveExpressInterface(AftermarketReturnGoodsListFragment.this, mNameTextView.getText().toString(), mNumEditText
							.getText().toString(), mCurGroupJsonObject.optString("return_id")) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub
							try {
								mCurGroupJsonObject.put("delivery_status", 0);
								mCurGroupJsonObject.put("delivery_data", responseJson.optJSONObject("data"));
								mAdatpter.notifyDataSetChanged();
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							onRefresh();
						}
					}.RunRequest();
					mDeliveryDialog.dismiss();
				}
			});
		} catch (Exception e) {
			// TODO: handle exception
			Log.w(Run.TAG, e.getMessage());
		}

		mDeliveryDialog.setContentView(view);
		mDeliveryDialog.setCanceledOnTouchOutside(true);
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		
		if (requestCode == REQUEST_DELIVERY_NUM) {
			mNumEditText.setText(data.getStringExtra(Run.EXTRA_SCAN_REZULT));
			return;
		}
		
		super.onActivityResult(requestCode, resultCode, data);
	}
}
