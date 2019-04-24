package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.adpter.BaseSelectAdapter;
import com.qianseit.westore.httpinterface.goods.CategoryGoodsInterface;

/**
 * 分类
 */
public class CategoryGoodsFragment extends BaseDoFragment {
	private ListView mListView;
	ListView mOtherListView;

	JSONObject mCategoryJsonObject, mCategoryTreeJsonObject;
	JSONObject mVCategoryJsonObject, mVCategoryTreeJsonObject;

	List<String> mTopCateList = new ArrayList<String>();
	List<String> mCurOtherCatList = new ArrayList<String>();

	int mTopVCatIndex = 0;
	int mSingleImageWidth = 0;
	int mMultiImageWidth = 0;

	BaseSelectAdapter<String> mTopAdapter = new BaseSelectAdapter<String>(mTopCateList) {

		List<String> mChangedChildList = new ArrayList<String>();

		@Override
		public View getSelectView(int position, View convertView, ViewGroup parent, boolean isSelected) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_category_goods_top, null);
			}
			JSONObject nCate = getItemCate(position);
			((TextView) convertView.findViewById(R.id.name)).setText(nCate.has("cat_name") ? nCate.optString("cat_name") : nCate.optString("virtual_cat_name"));
			convertView.findViewById(R.id.name).setSelected(isSelected);
			convertView.findViewById(R.id.left).setSelected(isSelected);
			return convertView;
		}

		JSONObject getItemCate(int position) {
			if (position < mTopVCatIndex) {
				return mCategoryJsonObject.optJSONObject(getItem(position));
			} else {
				return mVCategoryJsonObject.optJSONObject(getItem(position));
			}
		}

		@Override
		public void onSelectedChanged(int selectedIndex) {
			if (mChangedChildList.size() <= 0) {
				List<String> nSecondChildList = getChildrenList(selectedIndex);
				if (hasThirdCHild(selectedIndex, nSecondChildList)) {
					mChangedChildList.addAll(getChildrenList(selectedIndex));
				} else if (nSecondChildList.size() > 0) {
					mChangedChildList.add(getItem(selectedIndex));
				}
			}
			mCurOtherCatList.clear();
			mCurOtherCatList.addAll(mChangedChildList);
			mOtherAdapter.notifyDataSetChanged();
		}

		@Override
		public void onItemChangeChick(int position, int oldPosition, View itemView) {
			mChangedChildList.clear();
			List<String> nSecondChildList = getChildrenList(position);
			if (hasThirdCHild(position, nSecondChildList)) {
				mChangedChildList.addAll(getChildrenList(position));
			} else if (nSecondChildList.size() > 0) {
				mChangedChildList.add(getItem(position));
			}

			if (mChangedChildList.size() > 0) {
				super.onItemChangeChick(position, oldPosition, itemView);
			} else {
				// 去商品列表页
				startGoodsList(getItemCate(position));
			}
		}

		List<String> getChildrenList(int position) {
			// TODO Auto-generated method stub
			List<String> nChilds = new ArrayList<String>();
			if (position < mTopVCatIndex) {
				JSONArray nArray = mCategoryTreeJsonObject.optJSONArray(getItem(position));
				if (nArray == null || nArray.length() <= 0) {
					return nChilds;
				}
				for (int i = 0; i < nArray.length(); i++) {
					nChilds.add(nArray.optString(i));
				}
			} else {
				JSONArray nArray = mVCategoryTreeJsonObject.optJSONArray(getItem(position));
				if (nArray == null || nArray.length() <= 0) {
					return nChilds;
				}
				for (int i = 0; i < nArray.length(); i++) {
					nChilds.add(nArray.optString(i));
				}
			}

			return nChilds;
		}

		boolean hasThirdCHild(int topPosition, List<String> list) {
			if (list == null || list.size() <= 0) {
				return false;
			}

			boolean hasThirdChild = false;
			if (topPosition < mTopVCatIndex) {
				for (String string : list) {
					JSONArray nArray = mCategoryTreeJsonObject.optJSONArray(string);
					if (nArray != null && nArray.length() > 0) {
						hasThirdChild = true;
					}
				}
			} else {
				for (String string : list) {
					JSONArray nArray = mVCategoryTreeJsonObject.optJSONArray(string);
					if (nArray != null && nArray.length() > 0) {
						hasThirdChild = true;
					}
				}
			}

			return hasThirdChild;
		}

	};

	QianseitAdapter<String> mOtherAdapter = new QianseitAdapter<String>(mCurOtherCatList) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			GridView nGridView = null;
			List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_category_goods_other_parent, null);
				setViewAbsoluteSize(convertView.findViewById(R.id.image), mSingleImageWidth, mSingleImageWidth / 2);
				nGridView = (GridView) convertView.findViewById(R.id.child_gv);
				nGridView.setAdapter(new QianseitAdapter<JSONObject>(nJsonObjects) {

					@Override
					public View getView(int position, View convertView, ViewGroup parent) {
						// TODO Auto-generated method stub
						if (convertView == null) {
							convertView = View.inflate(mActivity, R.layout.item_category_goods_other_child_item, null);
							setViewAbsoluteSize(convertView.findViewById(R.id.image), mMultiImageWidth, mMultiImageWidth);
							convertView.findViewById(R.id.image).setOnClickListener(new OnClickListener() {

								@Override
								public void onClick(View v) {
									// TODO Auto-generated method stub
									startGoodsList(getItem((Integer) v.getTag(R.id.tag_object)));
								}
							});
						}

						JSONObject nJsonObject = getItem(position);
						convertView.findViewById(R.id.image).setTag(R.id.tag_object, position);
						displayRectangleImage((ImageView) convertView.findViewById(R.id.image), nJsonObject.optString("image_default_id"));
						((TextView) convertView.findViewById(R.id.name)).setText(nJsonObject.has("cat_name") ? nJsonObject.optString("cat_name") : nJsonObject.optString("virtual_cat_name"));
						return convertView;
					}
				});
				nGridView.setTag(nJsonObjects);
				convertView.findViewById(R.id.image).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						startGoodsList(getItemCate((Integer) v.getTag(R.id.tag_object)));
					}
				});
			} else {
				nGridView = (GridView) convertView.findViewById(R.id.child_gv);
				nJsonObjects = (List<JSONObject>) nGridView.getTag();
			}

			nJsonObjects.clear();

			JSONObject nJsonObject = getItemCate(position);
			boolean equalsParent = false;
			String nCatId = nJsonObject.optString("cat_id");
			if (!TextUtils.isEmpty(nCatId) && !nCatId.equals("null")) {
				equalsParent = nJsonObject.optString("cat_id").equals(mTopAdapter.getItem(mTopAdapter.getSelectedIndex()));
			} else {
				equalsParent = nJsonObject.optString("virtual_cat_id").equals(mTopAdapter.getItem(mTopAdapter.getSelectedIndex()));
			}
			convertView.findViewById(R.id.name).setVisibility(equalsParent ? View.GONE : View.VISIBLE);
			convertView.findViewById(R.id.top).setVisibility(equalsParent ? View.VISIBLE : View.GONE);

			((TextView) convertView.findViewById(R.id.name)).setText(nJsonObject.has("cat_name") ? nJsonObject.optString("cat_name") : nJsonObject.optString("virtual_cat_name"));
			ImageView nImageView = (ImageView) convertView.findViewById(R.id.image);

			nJsonObjects.addAll(getChildrenList(position));
			nImageView.setTag(R.id.tag_object, position);
			if (nJsonObjects.size() <= 0) {
				convertView.findViewById(R.id.image).setVisibility(View.VISIBLE);
				displayRectangleImage(nImageView, nJsonObject.optString("image_default_id"));
				nGridView.setVisibility(View.GONE);
			} else {
				convertView.findViewById(R.id.image).setVisibility(View.GONE);
				((QianseitAdapter<JSONObject>) nGridView.getAdapter()).notifyDataSetChanged();
				nGridView.setVisibility(View.VISIBLE);
			}

			return convertView;
		}

		JSONObject getItemCate(int position) {
			if (mTopAdapter.getSelectedIndex() < mTopVCatIndex) {
				return mCategoryJsonObject.optJSONObject(getItem(position));
			} else {
				return mVCategoryJsonObject.optJSONObject(getItem(position));
			}
		}

		List<JSONObject> getChildrenList(int position) {
			// TODO Auto-generated method stub
			List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
			if (mTopAdapter.getSelectedIndex() < mTopVCatIndex) {
				JSONArray nArray = mCategoryTreeJsonObject.optJSONArray(mCurOtherCatList.get(position));
				if (nArray == null || nArray.length() <= 0) {
					return nJsonObjects;
				}
				for (int i = 0; i < nArray.length(); i++) {
					nJsonObjects.add(mCategoryJsonObject.optJSONObject(nArray.optString(i)));
				}
			} else {
				JSONArray nArray = mVCategoryTreeJsonObject.optJSONArray(mCurOtherCatList.get(position));
				if (nArray == null || nArray.length() <= 0) {
					return nJsonObjects;
				}
				for (int i = 0; i < nArray.length(); i++) {
					nJsonObjects.add(mVCategoryJsonObject.optJSONObject(nArray.optString(i)));
				}
			}

			return nJsonObjects;
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_goods_category, null);

		mListView = (ListView) findViewById(R.id.top_category);
		mListView.setAdapter(mTopAdapter);

		mOtherListView = (ListView) findViewById(R.id.other_category);
		mOtherListView.setAdapter(mOtherAdapter);

		mOtherListView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {

			@Override
			public void onGlobalLayout() {
				// TODO Auto-generated method stub
				mSingleImageWidth = mOtherListView.getWidth();
				mMultiImageWidth = (mSingleImageWidth - Run.dip2px(mActivity, 2 * 4)) / 3;
			}
		});

		new CategoryGoodsInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub

				JSONObject nCat = responseJson.optJSONObject("cat");
				mCategoryJsonObject = nCat.optJSONObject("info");
				mCategoryTreeJsonObject = nCat.optJSONObject("tree");

				JSONObject nVCat = responseJson.optJSONObject("vcat");
				mVCategoryJsonObject = nVCat.optJSONObject("info");
				mVCategoryTreeJsonObject = nVCat.optJSONObject("tree");

				parseCate();
			}
		}.RunRequest();
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);

	}

	@Override
	public void onResume() {
		super.onResume();
	}

	void parseCate() {
		mTopCateList.clear();
		mCurOtherCatList.clear();

		if (mCategoryTreeJsonObject != null && mCategoryTreeJsonObject.length() > 0) {
			JSONArray nTopJsonArray = mCategoryTreeJsonObject.optJSONArray("0");
			if (nTopJsonArray != null && nTopJsonArray.length() > 0) {
				for (int i = 0; i < nTopJsonArray.length(); i++) {
					mTopCateList.add(nTopJsonArray.optString(i));
				}
			}
			mTopVCatIndex = mTopCateList.size();
		}
		if (mVCategoryTreeJsonObject != null && mVCategoryTreeJsonObject.length() > 0) {
			JSONArray nVTopJsonArray = mVCategoryTreeJsonObject.optJSONArray("0");
			if (nVTopJsonArray != null && nVTopJsonArray.length() > 0) {
				for (int i = 0; i < nVTopJsonArray.length(); i++) {
					mTopCateList.add(nVTopJsonArray.optString(i));
				}
			}
		}

		int nSelected = 0;
		if (mTopCateList.size() > 0) {
			for (int i = 0; i < mTopVCatIndex; i++) {
				if (mCategoryTreeJsonObject.has(mTopCateList.get(i))) {
					JSONArray nOtherJsonArray = mCategoryTreeJsonObject.optJSONArray(mTopCateList.get(i));
					if (nOtherJsonArray != null && nOtherJsonArray.length() > 0) {
						nSelected = i;
						for (int j = 0; j < nOtherJsonArray.length(); j++) {
							mCurOtherCatList.add(nOtherJsonArray.optString(j));
						}
						break;
					}
				}
			}

			if (mCurOtherCatList.size() <= 0) {
				for (int i = mTopVCatIndex; i < mTopCateList.size(); i++) {
					if (mVCategoryTreeJsonObject.has(mTopCateList.get(i))) {
						JSONArray nOtherJsonArray = mVCategoryTreeJsonObject.optJSONArray(mTopCateList.get(i));
						if (nOtherJsonArray != null && nOtherJsonArray.length() > 0) {
							nSelected = i;
							for (int j = 0; j < nOtherJsonArray.length(); j++) {
								mCurOtherCatList.add(nOtherJsonArray.optString(j));
							}
							break;
						}
					}
				}
			}
		}

		mTopAdapter.setSelected(nSelected);
		mTopAdapter.notifyDataSetChanged();
	}

	void startGoodsList(JSONObject cateJsonObject) {
		if (cateJsonObject == null || (!cateJsonObject.has("virtual_cat_id") && !cateJsonObject.has("cat_id"))) {
			return;
		}
		Bundle nBundle = new Bundle();
		if (cateJsonObject.has("virtual_cat_id")) {
			nBundle.putString(Run.EXTRA_VITUAL_CATE, cateJsonObject.optString("virtual_cat_id"));
			nBundle.putString(Run.EXTRA_TITLE, cateJsonObject.optString("virtual_cat_name"));
		} else {
			nBundle.putString(Run.EXTRA_CLASS_ID, cateJsonObject.optString("cat_id"));
			nBundle.putString(Run.EXTRA_TITLE, cateJsonObject.optString("cat_name"));
		}
		startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_LIST, nBundle);
	}
}
