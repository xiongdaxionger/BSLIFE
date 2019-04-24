package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.content.ContentValues;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.adpter.BaseSelectAdapter;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;
import com.qianseit.westore.ui.CustomListCheckPopupWindow;
import com.qianseit.westore.ui.CustomListCheckPopupWindow.CustomListCheckBean;
import com.qianseit.westore.ui.CustomListCheckPopupWindow.onCustomListPopupCheckListener;
import com.qianseit.westore.ui.GoodsListscreenPopupWindow;
import com.qianseit.westore.ui.GoodsListscreenPopupWindow.onScreenListPopupCheckListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GoodsSortRadioBarAdapter implements onScreenListPopupCheckListener, OnDismissListener {
	final long BRAND_LIST_TYPE_ALL = 1;
	final long BRAND_LIST_TYPE_PRICE = 2;
	final long BRAND_LIST_TYPE_SALES = 3;
	final long BRAND_LIST_TYPE_SORT = 4;
	Map<Long, GoodsSortExpendBarBean> mExpendMap = new HashMap<Long, GoodsSortExpendBarBean>();
	GoodsSortBarHandler mBarHandler;
	Activity mActivity;

	String mSortSql = "";

	JSONObject mPagerJsonObject;

	boolean showFilter = false;

	/**
	 * screen字段
	 */
	JSONObject mSortJsonObject, mFilterJsonObject;
	List<CustomListCheckBean> mSortBeans = new ArrayList<CustomListCheckBean>();
	List<CustomListCheckBean> mPriceSortBeans = new ArrayList<CustomListCheckBean>();
	List<CustomListCheckBean> mSalesSortBeans = new ArrayList<CustomListCheckBean>();
	CustomListCheckPopupWindow mSelectorPopupWindow, mPriceSelectorPopupWindow;

	RadioBarBean mFilterBarBean;

	List<JSONObject> mFilterJsonObjects = new ArrayList<JSONObject>();

	Map<String, String> mDefualtSelectedItemsWidthValue = new HashMap<String, String>();

	// 筛选
	private GoodsListscreenPopupWindow mScreenWindow;

	RadioBarBeanList mBarBeans = new RadioBarBeanList();
	public BaseSelectAdapter<RadioBarBean> mSelectAdapter = new BaseSelectAdapter<RadioBarBean>(mBarBeans) {

		@Override
		public View getSelectView(int position, View convertView, ViewGroup parent, boolean isSelected) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_goods_list_radio_bar, null);
				convertView.findViewById(R.id.bar_item_width).getLayoutParams().width = mBarHandler.parentWidth() / getCount();
			}
			RadioBarBean nBarBean = getItem(position);
			((TextView) convertView.findViewById(R.id.title)).setText(nBarBean.mTitleString);
			if (mExpendMap.containsKey(nBarBean.mId)) {
				int nCurProptyId = mExpendMap.get(nBarBean.mId).getCurProptyId();
				if (nCurProptyId > 0) {
					((ImageView) convertView.findViewById(R.id.indicate)).setImageResource(nCurProptyId);
				} else {
					((ImageView) convertView.findViewById(R.id.indicate)).setImageBitmap(null);
				}
			} else {
				((ImageView) convertView.findViewById(R.id.indicate)).setImageBitmap(null);
			}
			convertView.findViewById(R.id.title).setSelected(isSelected);
			return convertView;
		}

		@Override
		public void onItemChangeChick(int position, int oldPosition, View itemView) {
			RadioBarBean nBarBean = getItem(position);
			if (nBarBean.mId == BRAND_LIST_TYPE_SORT) {// 弹出筛选框
				mBarHandler.beginShowPopup();
				openScreenPopupWindow(itemView);
				return;
			}
			if (mExpendMap.containsKey(nBarBean.mId)) {
				mExpendMap.get(nBarBean.mId).getNextProptyId();
			}

			nBarBean = getItem(oldPosition);
			if (mExpendMap.containsKey(nBarBean.mId)) {
				mExpendMap.get(nBarBean.mId).setDefualtPropty();
				if (nBarBean.mId == BRAND_LIST_TYPE_ALL) {
					mBarHandler.beginShowPopup();

					mSelectorPopupWindow.onSelectedNoCallback(0);
				}
			}

			super.onItemChangeChick(position, oldPosition, itemView);
		}

		@Override
		public void onItemClick(int position, RadioBarBean item, View itemView) {
			RadioBarBean nBarBean = getItem(position);
			if (nBarBean.mId == BRAND_LIST_TYPE_ALL) {
				if (mExpendMap.containsKey(nBarBean.mId)) {
					mExpendMap.get(nBarBean.mId).getNextProptyId();
				}
				// 弹出综合排序选中框
				mBarHandler.beginShowPopup();
				mSelectorPopupWindow.showAsDropDown((View) itemView.getParent());
			} else if (nBarBean.mId == BRAND_LIST_TYPE_PRICE) {
				if (mExpendMap.containsKey(nBarBean.mId)) {
					int nNextId = mExpendMap.get(nBarBean.mId).getNextProptyId();
					mSortSql = mPriceSortBeans.get(mExpendMap.get(nBarBean.mId).mCurIndex - 1).mType;
					if (mBarHandler != null) {
						ContentValues nContentValues = new ContentValues();
						nContentValues.put("orderBy", mSortSql);
						mBarHandler.onSortConditionChanged(nContentValues);
					}
				}
			}

			notifyDataSetChanged();
		}

		public void onSelectedChanged(int selectedIndex) {
			RadioBarBean nBarBean = getItem(selectedIndex);
			if (nBarBean.mId == BRAND_LIST_TYPE_ALL) {
				mSortSql = mSortBeans.size() > 0 ? mSortBeans.get(0).mType : "";
			} else if (nBarBean.mId == BRAND_LIST_TYPE_PRICE) {
				mSortSql = mPriceSortBeans.size() > 0 ? mPriceSortBeans.get(0).mType : "";
			} else if (nBarBean.mId == BRAND_LIST_TYPE_SALES) {
				mSortSql = mSalesSortBeans.size() > 0 ? mSalesSortBeans.get(0).mType : "buy_count desc";
			}

			if (nBarBean.mId != BRAND_LIST_TYPE_ALL && TextUtils.isEmpty(mSortSql)) {
				return;
			}

			if (mBarHandler != null) {
				ContentValues nContentValues = new ContentValues();
				nContentValues.put("orderBy", mSortSql);
				mBarHandler.onSortConditionChanged(nContentValues);
			}
		}

		@Override
		public int getCount() {
			if (showFilter) {
				return 4;
			} else {
				return 3;
			}
		}
	};
	private JSONObject mBrandJsonObject;

	public GoodsSortRadioBarAdapter(Activity activity, GoodsSortBarHandler barHandler) {
		mActivity = activity;
		mBarBeans.add(BRAND_LIST_TYPE_ALL, "默认");
		GoodsSortExpendBarBean nExpendBarBean = new GoodsSortExpendBarBean();
		nExpendBarBean.addProptyId(R.drawable.goods_market_drop_nomorl);
		nExpendBarBean.addProptyId(R.drawable.goods_market_drop);
		nExpendBarBean.getNextProptyId();
		// nExpendBarBean.addProptyId(R.drawable.goods_market_litre);
		mExpendMap.put(BRAND_LIST_TYPE_ALL, nExpendBarBean);

		mBarBeans.add(BRAND_LIST_TYPE_PRICE, "价格");
		nExpendBarBean = new GoodsSortExpendBarBean();
		nExpendBarBean.addProptyId(R.drawable.sort_none);
		nExpendBarBean.addProptyId(R.drawable.sort_asc);
		nExpendBarBean.addProptyId(R.drawable.sort_desc);
		mExpendMap.put(BRAND_LIST_TYPE_PRICE, nExpendBarBean);

		mBarBeans.add(BRAND_LIST_TYPE_SALES, "销量");

		mFilterBarBean = new RadioBarBean("筛选", BRAND_LIST_TYPE_SORT);
		mBarBeans.add(mFilterBarBean);
		nExpendBarBean = new GoodsSortExpendBarBean();
		nExpendBarBean.addProptyId(R.drawable.sort);
		mExpendMap.put(BRAND_LIST_TYPE_SORT, nExpendBarBean);
		mBarHandler = barHandler;

		mSelectorPopupWindow = new CustomListCheckPopupWindow(activity, 0, new onCustomListPopupCheckListener() {

			@Override
			public void onUnCheckedResult(CustomListCheckBean checkBean, int dockViewID) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onResult(CustomListCheckBean checkBean, int dockViewID) {
				// TODO Auto-generated method stub
				mSortSql = checkBean.mType;
				if (mBarHandler != null) {
					ContentValues nContentValues = new ContentValues();
					nContentValues.put("orderBy", mSortSql);
					mBarHandler.onSortConditionChanged(nContentValues);
				}
				mBarBeans.get(0).mTitleString = checkBean.mName;
				mSelectAdapter.notifyDataSetChanged();
			}
		}, mSortBeans);
		mPriceSelectorPopupWindow = new CustomListCheckPopupWindow(activity, 0, new onCustomListPopupCheckListener() {

			@Override
			public void onUnCheckedResult(CustomListCheckBean checkBean, int dockViewID) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onResult(CustomListCheckBean checkBean, int dockViewID) {
				// TODO Auto-generated method stub

			}
		}, mPriceSortBeans);
	}

	private void openScreenPopupWindow(View view) {
		boolean isRefresh = true;
		if (mFilterJsonObjects == null || mFilterJsonObjects.size() <= 0) {
			Run.alert(mActivity, "没有筛选数据，不能筛选");
			return;
		}

		if (this.mScreenWindow == null) {
			mScreenWindow = new GoodsListscreenPopupWindow(mActivity, view.getId(), this, mFilterJsonObjects, null, mPagerJsonObject.optInt("dataCount"));
			mScreenWindow.setOnDismissListener(this);
		} else {
			mScreenWindow.fillData(mFilterJsonObjects, isRefresh);
			mScreenWindow.setGoodsNum(mPagerJsonObject.optInt("dataCount"));
		}
		if (mScreenWindow.isShowing()) {
			mScreenWindow.dismiss();
		} else {
			mScreenWindow.setGoodsNum(mPagerJsonObject.optInt("dataCount"));
			mScreenWindow.setAnimationStyle(android.R.style.Animation_Dialog);
			mScreenWindow.showAsDropDown((View) view.getParent(), Run.dip2px(mActivity, 50), -Run.dip2px(mActivity, 92));
		}
	}

	public void setFilterData(JSONObject jsonObject, Map<String, String> defualtSelectedItemsWidthValue) {
		if (jsonObject == null || !jsonObject.has("screen")) {
			return;
		}
		mDefualtSelectedItemsWidthValue = defualtSelectedItemsWidthValue;
		mFilterJsonObject = jsonObject.optJSONObject("screen");
		parseFilter();
	}

	public void setSortData(JSONObject jsonObject) {
		if (jsonObject == null || !jsonObject.has("screen")) {
			return;
		}
		mSortJsonObject = jsonObject.optJSONObject("screen");
		mPagerJsonObject = jsonObject.optJSONObject("pager");
		mBrandJsonObject = jsonObject.optJSONObject("brand_data");
		parseSort();
	}

	void parseSort() {
		mSortBeans.clear();
		mPriceSortBeans.clear();
		mSalesSortBeans.clear();
		if (mSortJsonObject == null) {
			return;
		}
		JSONArray nArray = mSortJsonObject.optJSONArray("orderBy");
		for (int i = 0; i < nArray.length(); i++) {
			parseJsonToSelectorBean(nArray.optJSONObject(i));
		}
	}

	/**
	 * @param jsonObject
	 *            解析排序对象，并自动归类到综合排序或者价格排序（"sql"包含"price"归到价格培训
	 */
	void parseJsonToSelectorBean(JSONObject jsonObject) {
		if (jsonObject == null) {
			return;
		}
		String nSql = jsonObject.optString("sql");
		nSql = nSql == null ? "" : nSql;
		CustomListCheckBean nBean = new CustomListCheckBean(String.valueOf(jsonObject.hashCode()), jsonObject.optString("sql"), jsonObject.optString("label"), false);
		if (!TextUtils.isEmpty(nSql) && nSql.contains("price")) {
			if (nSql.contains("asc")) {
				mPriceSortBeans.add(0, nBean);
			} else {
				mPriceSortBeans.add(nBean);
			}
		} else {
			if (!TextUtils.isEmpty(nSql) && nSql.contains("buy_count")) {
				mSalesSortBeans.add(nBean);
				return;
			} else if (!TextUtils.isEmpty(nSql) && nSql.contains("buy_w_count")) {
				return;
			}
			mSortBeans.add(nBean);
		}
		if (mSortBeans.size() > 0) {
			mSortBeans.get(0).mSelected = true;
		}
	}

	void parseFilter() {
		mFilterJsonObjects.clear();
		JSONArray nArray = mFilterJsonObject.optJSONArray("filter_entries");
		if (nArray != null && nArray.length() > 0) {
			try {
				for (int i = 0; i < nArray.length(); i++) {
					JSONObject nJsonObject = nArray.optJSONObject(i);
					if (mBrandJsonObject == null || !nJsonObject.optString("screen_field").equalsIgnoreCase("brand_id")) {
						mFilterJsonObjects.add(nJsonObject);
						String nFilterField = nJsonObject.optString("screen_field");
						if (mDefualtSelectedItemsWidthValue != null && mDefualtSelectedItemsWidthValue.containsKey(nFilterField)) {
							String nDefualtValue = mDefualtSelectedItemsWidthValue.get(nFilterField);
							JSONArray nArray2 = nJsonObject.optJSONArray("options");
							if (!TextUtils.isEmpty(nDefualtValue) && nArray2 != null && nArray2.length() > 0) {
								for (int j = 0; j < nArray2.length(); j++) {
									JSONObject nJsonObject2 = nArray2.optJSONObject(j);
									if (nDefualtValue.equals(nJsonObject2.optString("val"))) {
										nJsonObject2.put("mark", true);
										break;
									}
								}
							}
						}
					}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		showFilter = mFilterJsonObjects.size() > 0;
		mSelectAdapter.notifyDataSetChanged();
	}

	public class GoodsSortExpendBarBean {
		public int mCurIndex = 0;
		public int mChickAction = 0;
		List<Integer> mProptyIdList = new ArrayList<Integer>();

		public void addProptyId(Integer proptyId) {
			mProptyIdList.add(proptyId);
		}

		public void clearPropId() {
			mProptyIdList.clear();
			mCurIndex = 0;
		}

		/**
		 * @return 每次都取下一个属性id，取到最后一个后回到选中时默认id（第1个，如果只有1个id则返回第0个）
		 */
		public int getNextProptyId() {
			mCurIndex++;
			return getCurProptyId();
		}

		/**
		 * @return 返回当前选中id
		 */
		public int getCurProptyId() {
			if (mCurIndex >= mProptyIdList.size()) {
				mCurIndex = 1;
			}
			if (mCurIndex >= mProptyIdList.size()) {
				mCurIndex = 0;
			}
			return mProptyIdList.get(mCurIndex);
		}

		/**
		 * 未选中时默认id
		 * 
		 * @return 序号为0的id是默认id 设置为默认id并返回
		 */
		public int setDefualtPropty() {
			mCurIndex = 0;
			return getCurProptyId();
		}
	}

	@Override
	public void onScreenResult(List<JSONObject> ListJson, int dockViewID) {
		// TODO Auto-generated method stub
		if (mBarHandler != null) {
			if (ListJson != null && ListJson.size() > 0) {
				ContentValues screePairList = new ContentValues();
				for (int i = 0; i < ListJson.size(); i++) {
					JSONObject jsonScreen = ListJson.get(i);
					String key = jsonScreen.optString("key");
					String value = jsonScreen.optString("value");
					if (!TextUtils.isEmpty(key) && !TextUtils.isEmpty(value)) {
						screePairList.put(key, value);
					}
				}

				screePairList.put("orderBy", mSortSql);
				mBarHandler.onSortConditionChanged(screePairList);
			}
		}
	}

	@Override
	public void onDismiss() {
		// TODO Auto-generated method stub

	}
}
