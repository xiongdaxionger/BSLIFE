package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.adpter.BaseSelectAdapter;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface.AdjunctBean;

public abstract class GoodsCombo {
	final String CHOOSED_STATUS_KEY = "choosedstatus";

	BaseDoFragment mParentFragment;
	Context mContext;

	LinearLayout mBarListView, mGoodsListView;
	List<JSONObject> mComboList = new ArrayList<JSONObject>();
	List<JSONObject> mGoodsList = new ArrayList<JSONObject>();
	int mRadioWidth = 0;
	JSONObject mImagesJsonObject;

	List<View> mCacheGoodsView = new ArrayList<View>();
	List<View> mCacheBarView = new ArrayList<View>();

	QianseitAdapter<JSONObject> mGoodsAdapter = new QianseitAdapter<JSONObject>(mGoodsList) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mContext, R.layout.item_goods_detail_combo_goods, null);
				BaseDoFragment.setViewAbsoluteSize(convertView.findViewById(R.id.item_goods_icon), mRadioWidth, mRadioWidth);
				BaseDoFragment.setViewAbsoluteSize(convertView.findViewById(R.id.item_goods_title), mRadioWidth, LayoutParams.WRAP_CONTENT);
				convertView.findViewById(R.id.item_goods_addcar).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						int nPosition = (Integer) v.getTag();
						JSONObject nItem = getItem(nPosition);
						try {
							nItem.put(CHOOSED_STATUS_KEY, !nItem.optBoolean(CHOOSED_STATUS_KEY, false));
							notifyDataSetChanged();
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
//						addAdjunctToCar(mComboAdapter.getSelectedIndex(), nItem.optInt("product_id"), 1);
					}
				});
				convertView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						int nPosition = (Integer) v.getTag();
						JSONObject nItem = getItem(nPosition);
						Bundle nBundle = new Bundle();
						nBundle.putString(Run.EXTRA_PRODUCT_ID, nItem.optString("product_id"));
						mParentFragment.startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
					}
				});
			}

			JSONObject nItem = getItem(position);
			BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.item_goods_icon), mImagesJsonObject == null ? "" : mImagesJsonObject.optString(nItem.optString("goods_id")));

			TextView nTitleTextView = (TextView) convertView.findViewById(R.id.item_goods_title);
			nTitleTextView.setText(nItem.optString("name"));
			((TextView) convertView.findViewById(R.id.item_goods_price)).setText(nItem.optString("adjprice"));

			convertView.findViewById(R.id.item_goods_addcar).setTag(position);
			convertView.findViewById(R.id.item_goods_addcar).setSelected(nItem.optBoolean(CHOOSED_STATUS_KEY, false));
			convertView.setTag(position);
			return convertView;
		}

		@Override
		public void notifyDataSetChanged() {
			mGoodsListView.removeAllViews();
			for (int i = 0; i < getCount(); i++) {
				mGoodsListView.addView(getView(i, mCacheGoodsView.size() > 0 ? mCacheGoodsView.remove(0) : null, null));
			}
		}
	};
	 
	BaseSelectAdapter<JSONObject> mComboAdapter = new BaseSelectAdapter<JSONObject>(mComboList) {

		@Override
		public View getSelectView(int position, View convertView, ViewGroup parent, boolean selected) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mContext, R.layout.item_goods_detail_combo_bar, null);
			}

			convertView.setSelected(selected);
			JSONObject nItem = getItem(position);
			((TextView) convertView.findViewById(R.id.combo_bar_name)).setText(nItem.optString("name"));

			return convertView;
		}

		@Override
		public void onSelectedChanged(int selectedIndex) {
			JSONObject nJsonObject = getItem(selectedIndex);
			JSONArray nArray = nJsonObject.optJSONArray("items");
			if (nArray != null) {
				mGoodsList.clear();
				for (int i = 0; i < nArray.length(); i++) {
					mGoodsList.add(nArray.optJSONObject(i));
				}
				mParentFragment.mActivity.runOnUiThread(new Runnable() {

					@Override
					public void run() {
						// TODO Auto-generated method stub
						mGoodsAdapter.notifyDataSetChanged();
					}
				});

			}
		}

		@Override
		public void notifyDataSetChanged() {
			mBarListView.removeAllViews();
			for (int i = 0; i < getCount(); i++) {
				mBarListView.addView(getView(i, mCacheBarView.size() > 0 ? mCacheBarView.remove(0) : null, null));
			}
		}
	};

	public GoodsCombo(BaseDoFragment doFragment, LinearLayout barLinear, LinearLayout goodsLinear) {
		mParentFragment = doFragment;
		mContext = doFragment.mActivity;
		mRadioWidth = (Run.getWindowsWidth(mParentFragment.mActivity) - Run.dip2px(mContext, 20)) / 3;
		mBarListView = barLinear;
		mGoodsListView = goodsLinear;

		mComboAdapter.notifyDataSetChanged();
	}

	public void notifyData() {
		mComboAdapter.notifyDataSetChanged();
	}

	public abstract void addAdjunctToCar(int groupId, int productId, int qty);
	
	/**
	 * @return
	 * 返回选中的配件
	 */
	public List<AdjunctBean> getChoosedAdjunct(){
		List<AdjunctBean> nAdjunctBeans = new ArrayList<AdjunctBean>();
		for (int i = 0; i < mComboList.size(); i++) {
			JSONObject nJsonObject = mComboList.get(i);
			JSONArray nArray = nJsonObject.optJSONArray("items");
			if (nArray == null || nArray.length() <= 0) {
				continue;
			}
			for (int j = 0; j < nArray.length(); j++) {
				JSONObject nJsonObject2 = nArray.optJSONObject(j);
				if (nJsonObject2.optBoolean(CHOOSED_STATUS_KEY, false)) {
					AdjunctBean nAdjunctBean = new AdjunctBean(i, nJsonObject2.optInt("product_id"), 1);
					nAdjunctBeans.add(nAdjunctBean);
				}
			}
		}
		return nAdjunctBeans;
	}
	
	public void setData(JSONArray array, JSONObject imagesJsonObject) {
		if (array == null || array.length() <= 0) {
			return;
		}

		mComboList.clear();
		for (int i = 0; i < array.length(); i++) {
			mComboList.add(array.optJSONObject(i));
		}

		mImagesJsonObject = imagesJsonObject;

		mComboAdapter.notifyDataSetChanged();
	}
}
