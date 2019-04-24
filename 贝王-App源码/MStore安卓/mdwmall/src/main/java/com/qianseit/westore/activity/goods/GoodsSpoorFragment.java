package com.qianseit.westore.activity.goods;

import android.app.Dialog;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.TextView;

import com.baoyz.swipemenulistview.SwipeMenuItem;
import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseSwticListFragment;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsSpoorFragment extends BaseSwticListFragment {
	private Dialog mDeleteDialog;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("我的足迹");
		mActionBar.setRightTitleButton("清空", new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				askClearSpoor();
			}
		});
	}
	
	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
		setEmptyText("暂无浏览记录");
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_goods_collection, null);
		}

		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_icon), responseJson.optString("image_default_id"));
		((TextView) convertView.findViewById(R.id.goods_name)).setText(responseJson.optString("title"));
		
		JSONObject nPriceJsonObject = responseJson.optJSONObject("price_list");
		if (nPriceJsonObject == null) {
			return convertView;
		}

		if (responseJson.optBoolean("is_gift") && !responseJson.isNull("gift")) {
			((TextView) convertView.findViewById(R.id.goods_price)).setText(responseJson.optJSONObject("gift").optString("consume_score") + "积分");
			((TextView) convertView.findViewById(R.id.goods_market_price)).setText("");
		}else {
			((TextView) convertView.findViewById(R.id.goods_price)).setText(nPriceJsonObject.optJSONObject("show").optString("format"));
			TextView nMktPriceTextView = (TextView) convertView.findViewById(R.id.goods_market_price);
			nMktPriceTextView.setPaintFlags(Paint.STRIKE_THRU_TEXT_FLAG);
			nMktPriceTextView.setText(nPriceJsonObject.has("mktprice") ? nPriceJsonObject.optJSONObject("mktprice").optString("format") : "");
		}
		
		convertView.findViewById(R.id.status).setVisibility(View.GONE);
		convertView.findViewById(R.id.goods_addcar).setVisibility(View.GONE);

		return convertView;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.goods_name:
		case R.id.goods_icon:
			String mProductId = (String) v.getTag();
			if (TextUtils.isEmpty(mProductId)) {
				return;
			}
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductId);
			startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
			break;

		default:
			super.onClick(v);
			break;
		}
	}

	// 询问删除商品
	private void askClearSpoor() {
		mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定清空商品浏览记录吗", "取消", "确定", null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mDeleteDialog.dismiss();
				mDeleteDialog = null;
				GoodsUtil.clearSpoor(mActivity);
				mResultLists.clear();
				mAdapter.notifyDataSetChanged();
			}
		}, false, null);
	}

	@Override
	protected void loadNextPage(int pageNumber) {
		// TODO Auto-generated method stub
		mResultLists.clear();
		List<JSONObject> data = fetchDatas(null);
		if (data != null) {
			mResultLists.addAll(data);
		}
		if (!rootView.isShown()) {
			rootView.setVisibility(View.VISIBLE);
		}
		mAdapter.notifyDataSetChanged();
		onLoadFinished();
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		// TODO Auto-generated method stub
		JSONObject nJsonObject = (JSONObject) parent.getAdapter().getItem(position);
		String mProductId = nJsonObject.optString("product_id");
		if (TextUtils.isEmpty(mProductId)) {
			return;
		}
		Bundle nBundle = new Bundle();
		nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductId);
		if (nJsonObject.optBoolean("is_gift") && !nJsonObject.isNull("gift")) {
			nBundle.putBoolean(Run.EXTRA_VALUE, true);//赠品
		}
		startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		return GoodsUtil.getSpoor(mActivity);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected List<SwipeMenuItem> createSwipeMenuItems(int viewType) {
		// TODO Auto-generated method stub
		List<SwipeMenuItem> nItems = new ArrayList<SwipeMenuItem>();
		SwipeMenuItem nItem = new SwipeMenuItem(mActivity);
		nItem.setWidth(Run.dip2px(mActivity, 80));
		nItem.setBackground(R.color.westore_red);
		nItem.setTitle("删除");
		nItem.setTitleColor(Color.WHITE);
		nItem.setTitleSize(18);
		nItems.add(nItem);
		return nItems;
	}

	// 询问删除商品
	private void askRemoveGoods(final JSONObject data) {
		mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除此商品？", "取消", "确定", null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mDeleteDialog.dismiss();
				mDeleteDialog = null;
				GoodsUtil.deleteSpoor(mActivity, data);
				mResultLists.remove(data);
				mAdapter.notifyDataSetChanged();
			}
		}, false, null);
	}

	@Override
	protected void onSwipeMenuItemClick(JSONObject positionJsonObject, int index) {
		// TODO Auto-generated method stub
		// super.onSwipeMenuItemClick(positionJsonObject, index);
		askRemoveGoods(positionJsonObject);
	}

}
