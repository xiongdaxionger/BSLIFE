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
import com.qianseit.westore.httpinterface.member.MemberDelFavInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsCollectionFragment extends BaseSwticListFragment {

	private Dialog mDeleteDialog;
	JSONObject mCurJsonObject = null;

	ShoppCarAddInterface mAddCarInterface = new ShoppCarAddInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.goodsCounts += getQty();
			Run.alert(mActivity, "加入购物车成功");
		}

	};
	MemberDelFavInterface mDelFavInterface = new MemberDelFavInterface(this, "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mResultLists.remove(mCurJsonObject);
			mCurJsonObject = null;
			mAdapter.notifyDataSetChanged();
			Run.alert(mActivity, "商品已从收藏列表删除");
		}
	};

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		// TODO Auto-generated method stub

	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("商品收藏");
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setEmptyText("暂无商品收藏");
	}
	
	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (responseJson == null) {
			return nJsonObjects;
		}

		JSONArray nArray = responseJson.optJSONArray("favorite");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}

		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}
		return nJsonObjects;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_goods_collection, null);

			
			convertView.findViewById(R.id.goods_addcar).setOnClickListener(this);
			convertView.findViewById(R.id.goods_icon).setOnClickListener(this);
			convertView.findViewById(R.id.goods_name).setOnClickListener(this);
			convertView.findViewById(R.id.notice).setOnClickListener(this);
		}

		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_icon), responseJson.optString("image_default_id"));
		((TextView) convertView.findViewById(R.id.goods_name)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.goods_price)).setText(responseJson.optString("price"));
		TextView nMktPriceTextView = (TextView) convertView.findViewById(R.id.goods_market_price);
		nMktPriceTextView.setPaintFlags(Paint.STRIKE_THRU_TEXT_FLAG);
		nMktPriceTextView.setText(responseJson.optString("mktprice"));

		boolean nEnabled = true;
		boolean nNotice = false;
		String nStatus = "有货";
		if (responseJson.optBoolean("marketable")) {
			if (responseJson.optInt("store", 0) <= 0) {
				nStatus = "无货";
				nEnabled = false;
				nNotice = true;
			}
		} else {
			nEnabled = false;
			nStatus = "已下架";
		}
		convertView.findViewById(R.id.status).setEnabled(nEnabled);
		((TextView) convertView.findViewById(R.id.status)).setText(nStatus);
		
		convertView.findViewById(R.id.goods_addcar).setVisibility(nEnabled ? View.VISIBLE : View.GONE);
		convertView.findViewById(R.id.goods_addcar).setTag(responseJson);
		convertView.findViewById(R.id.notice).setVisibility(nNotice ? View.VISIBLE : View.GONE);
		convertView.findViewById(R.id.notice).setTag(responseJson);

		convertView.findViewById(R.id.goods_icon).setTag(responseJson.optString("product_id"));
		convertView.findViewById(R.id.goods_name).setTag(responseJson.optString("product_id"));
		return convertView;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.favorite";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		JSONObject nItemJsonObject = null;
		Bundle nBundle = null;
		switch (v.getId()) {
		case R.id.goods_name:
		case R.id.goods_icon:
			String mProductId = (String) v.getTag();
			if (TextUtils.isEmpty(mProductId)) {
				return;
			}
			nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductId);
			startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
			break;
		case R.id.goods_addcar:
			nItemJsonObject = (JSONObject) v.getTag();
			mAddCarInterface.setData(nItemJsonObject.optString("goods_id"), nItemJsonObject.optString("product_id"), 1);
			mAddCarInterface.RunRequest();
			break;
		case R.id.notice:
			nItemJsonObject = (JSONObject) v.getTag();
			nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_GOODS_ID, nItemJsonObject.optString("goods_id"));
			nBundle.putString(Run.EXTRA_PRODUCT_ID, nItemJsonObject.optString("product_id"));
			startActivity(AgentActivity.FRAGMENT_GOODS_ARRIVAL_NOTICE, nBundle);
			break;

		default:
			super.onClick(v);
			break;
		}
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
		mCurJsonObject = data;
		mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除此商品？", "取消", "确定", null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mDeleteDialog.dismiss();
				mDeleteDialog = null;
				mDelFavInterface.delFav(mCurJsonObject.optString("goods_id"));
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
