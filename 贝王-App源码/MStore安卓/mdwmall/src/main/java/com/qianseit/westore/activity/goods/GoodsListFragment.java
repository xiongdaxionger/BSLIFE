package com.qianseit.westore.activity.goods;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LightingColorFilter;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.activity.shopping.ItemSearchView;
import com.qianseit.westore.activity.shopping.SearchCallback;
import com.qianseit.westore.base.BaseGridFragment;
import com.qianseit.westore.httpinterface.goods.GoodsFilterDataInterface;
import com.qianseit.westore.httpinterface.member.MemberAddFavInterface;
import com.qianseit.westore.httpinterface.member.MemberDelFavInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarCheckoutInterface;
import com.qianseit.westore.ui.HorizontalListView;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.loader.ImageCache;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GoodsListFragment extends BaseGridFragment<JSONObject> {
	final int SHOW_FIRST_BRAND_PAGE = 0x01;
	final int REQUEST_SEARCH_KEY = 0x0101;

	ImageView mBrandLogoImageView;
	TextView mBrandNameTextView, mBrandSeoDesc;
	WebView mBrandDescView;
	private boolean mIsAssignment = false;

	private ShareViewPopupWindow mShareViewPopupWindow;

	private HorizontalListView mRadioBarHorizontalListView, mRadioBarCopyHorizontalListView;
	private GoodsSortRadioBarAdapter mBarAdapter;
	private LinearLayout mListHeaderLinearLayout, mRadioBarCopyLinearLayout;

	ItemSearchView mItemSearchView;

	private String mKeywords;
	private String mCategoryId;
	private String mVitualCategoryId;
	private String mBrandId;
	private String mGoodsListTitle;
	boolean isPrepare = false;
	String mTagId;

	boolean mIsFirst = true, isFirstLayout = true, isFirstLoadData = true;

	int mNumColumns = 1;
	int mTopHeight = 0;

	int mTagRedundancyWidth = 0;

	JSONObject mCurJsonObject;

	List<JSONObject> mBrandFirstData = new ArrayList<JSONObject>();
	Resources mResources;

	ContentValues mSortFilternContentValues = new ContentValues();
	GoodsFilterDataInterface mGoodsFilterDataInterface;

	MemberAddFavInterface mAddFavInterface = new MemberAddFavInterface(this, "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "收藏成功");
			try {
				mCurJsonObject.put("is_fav", true);
				mAdapter.notifyDataSetChanged();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	};
	MemberDelFavInterface mDelFavInterface = new MemberDelFavInterface(this, "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "已取消收藏");
			try {
				mCurJsonObject.put("is_fav", false);
				mAdapter.notifyDataSetChanged();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	};

	ShoppCarCheckoutInterface mCarCheckoutInterface = new ShoppCarCheckoutInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_DATA, responseJson.toString());
			startActivity(AgentActivity.FRAGMENT_SHOPP_CONFIRM_ORDER, nBundle);
		}
	};
	ShoppCarAddInterface mAddCarInterface = new ShoppCarAddInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (isFastBuy()) {
				mCarCheckoutInterface.reset();
				mCarCheckoutInterface.setFastbuy();
				mCarCheckoutInterface.addGoodsIdent(getIdentId());
				mCarCheckoutInterface.RunRequest();
				return;
			}
			Run.goodsCounts += getQty();
			setShopCarCount(Run.goodsCounts);
		}

	};

	Map<String, String> mDefualtSelectedItemsWidthValue = new HashMap<String, String>();
	private int mBarTop;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

		isPrepare = getExtraBooleanFromBundle(Run.EXTRA_DETAIL_TYPE);
		mKeywords = getExtraStringFromBundle(Run.EXTRA_KEYWORDS);
		mCategoryId = getExtraStringFromBundle(Run.EXTRA_CLASS_ID);
		mVitualCategoryId = getExtraStringFromBundle(Run.EXTRA_VITUAL_CATE);
		mBrandId = getExtraStringFromBundle(Run.EXTRA_BRAND_ID);
		int nTagId = getExtraIntFromBundle(Run.EXTRA_VALUE);
		mTagId = nTagId > 0 ? nTagId + "" : "";
		mGoodsListTitle = getExtraStringFromBundle(Run.EXTRA_TITLE);
		mActionBar.setRightImageButton(R.drawable.goods_grid, new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (mNumColumns == 1) {
					switchType(2);
				} else {
					switchType(1);
				}

			}
		});

		mGoodsFilterDataInterface = new GoodsFilterDataInterface(this, mCategoryId) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mBarAdapter.setFilterData(responseJson, mDefualtSelectedItemsWidthValue);
			}
		};

		// if (TextUtils.isEmpty(mKeywords)) {
		// mActionBar.setTitle(mGoodsListTitle);
		// } else {
		mItemSearchView = new ItemSearchView(mActivity);
		mItemSearchView.setSearchCallback(new SearchCallback() {

			@Override
			public void search(String searchKey) {
				// TODO Auto-generated method stub
				Bundle nBundle = new Bundle();
				nBundle.putBoolean(Run.EXTRA_DATA, true);
				startActivityForResult(AgentActivity.FRAGMENT_GOODS_SEARCH, nBundle, REQUEST_SEARCH_KEY);
			}
		});
		mItemSearchView.setCanInput(false);
		mItemSearchView.setHint(mKeywords);
		mActionBar.setCustomTitleView(mItemSearchView);
		// }

		mShareViewPopupWindow = new ShareViewPopupWindow(mActivity);

		mTopHeight = Run.dip2px(mActivity, 92);
		mTagRedundancyWidth = Run.dip2px(mActivity, 11);

		mResources = getResources();
	}

	/**
	 * 1:列表|2:表格
	 */
	void switchType(int type) {
		mNumColumns = type;
		mImageWidth = (1080 - Run.dip2px(mActivity, 5 * (mNumColumns + 1))) / mNumColumns - Run.dip2px(mActivity, 10);
		mGridView.setNumColumns(mNumColumns);

		mActionBar.getRightImageButton().setImageResource(mNumColumns == 1 ? R.drawable.goods_grid : R.drawable.goods_list);
		mAdapter.notifyDataSetChanged();
	}

	ShareViewDataSource getShareDataSource(final JSONObject goodsJsonObject) {
		return new ShareViewDataSource() {

			@Override
			public String getShareUrl() {
				// TODO Auto-generated method stub
				return goodsJsonObject.optJSONObject("products").optString("url");
			}

			@Override
			public String getShareText() {
				// TODO Auto-generated method stub
				return goodsJsonObject.optString("name");
			}

			@Override
			public String getShareMessage() {
				// TODO Auto-generated method stub
				return goodsJsonObject.optString("brief");
			}

			@Override
			public String getShareImageUrl() {
				// TODO Auto-generated method stub
				return goodsJsonObject == null ? null : goodsJsonObject.optString("image_default_id");
			}

			@Override
			public String getShareImageFile() {
				// TODO Auto-generated method stub
				return null;
			}
		};
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (mIsFirst) {
			mIsFirst = false;

			JSONObject nSettingJsonObject = responseJson.optJSONObject("setting");
			if (nSettingJsonObject != null && nSettingJsonObject.optString("showtype").equalsIgnoreCase("grid")) {
				switchType(2);
			} else {
				switchType(1);
			}

			JSONObject nBrandJsonObject = responseJson.optJSONObject("brand_data");
			if (nBrandJsonObject != null) {
				mBarAdapter.setSortData(responseJson);
				mBrandFirstData.addAll(parseResponseData(responseJson));
				assignmentView(nBrandJsonObject);

				if (mBrandFirstData.size() <= 0 && mPageNum == 1) {
					mRadioBarHorizontalListView.setVisibility(View.GONE);
				} else {
					mRadioBarHorizontalListView.setVisibility(View.VISIBLE);
					mGoodsFilterDataInterface.fetchFilterData(getFilterCatId(responseJson));
				}

				return nJsonObjects;
			} else {
				mBarAdapter.setSortData(responseJson);
			}
		}

		nJsonObjects = parseResponseData(responseJson);

		if (nJsonObjects.size() <= 0 && mPageNum == 1) {
			mRadioBarHorizontalListView.setVisibility(View.GONE);
		} else {
			mRadioBarHorizontalListView.setVisibility(View.VISIBLE);
			mGoodsFilterDataInterface.fetchFilterData(getFilterCatId(responseJson));
		}

		return nJsonObjects;
	}

	String getFilterCatId(JSONObject jsonObject) {
		if (jsonObject == null || jsonObject.isNull("screen")) {
			return "";
		}

		JSONObject nScreenJsonObject = jsonObject.optJSONObject("screen");
		if (nScreenJsonObject == null || nScreenJsonObject.isNull("cat_id")) {
			return "";
		}

		return nScreenJsonObject.optString("cat_id");
	}

	@Override
	protected void fail(String failCode) {
		if (mIsFirst) {
			mRadioBarHorizontalListView.setVisibility(View.GONE);
		}
	}

	List<JSONObject> parseResponseData(JSONObject jsonObject) {
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (jsonObject == null) {
			return nJsonObjects;
		}

		JSONArray nArray = jsonObject.optJSONArray("goodsData");
		if (nArray != null && nArray.length() > 0) {
			for (int i = 0; i < nArray.length(); i++) {
				nJsonObjects.add(nArray.optJSONObject(i));
			}
		}

		return nJsonObjects;
	}

	@Override
	protected int getItemViewType(JSONObject t) {
		// TODO Auto-generated method stub
		return mNumColumns - 1;
	}

	@Override
	protected int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 2;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		int nType = getItemViewType(responseJson);
		if (convertView == null) {
			if (nType == 0) {
				convertView = View.inflate(mActivity, R.layout.item_goods_list, null);
				convertView.findViewById(R.id.goods_share).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						final ShareViewDataSource nDataSource = getShareDataSource((JSONObject) v.getTag());
						mShareViewPopupWindow.setDataSource(nDataSource);
						View nIconView = (View) v.getTag(R.id.tag_object);
						new ImageCache(mActivity).putBitmap(nDataSource.getShareImageUrl(), nIconView.getDrawingCache());
						mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
					}
				});
				convertView.findViewById(R.id.goods_collect).setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						mCurJsonObject = (JSONObject) v.getTag();
						if (mCurJsonObject.optBoolean("is_fav")) {
							mDelFavInterface.delFav(mCurJsonObject.optString("goods_id"));
						} else {
							mAddFavInterface.addFav(mCurJsonObject.optString("goods_id"));
						}
					}
				});
			} else {
				convertView = View.inflate(mActivity, R.layout.item_goods_grid, null);
				setViewSize(convertView.findViewById(R.id.goods_icon_fl), mImageWidth, mImageWidth);
			}
			convertView.findViewById(R.id.goods_icon).setDrawingCacheEnabled(true);

			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					String mProductId = (String) v.getTag();
					if (TextUtils.isEmpty(mProductId)) {
						return;
					}
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_PRODUCT_ID, mProductId);
					startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
				}
			});

			convertView.findViewById(R.id.goods_addcar).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					int position = (Integer) v.getTag(R.id.tag_first);
					JSONObject nItemJsonObject = mResultLists.get(position);

					JSONObject nPrepareJsonObject = nItemJsonObject.optJSONObject("products").optJSONObject("prepare");
					if (nPrepareJsonObject != null && nPrepareJsonObject.optInt("status") == 1) {
						// 预售商品直接立即购买
						mAddCarInterface.setData(nItemJsonObject.optString("goods_id"), nItemJsonObject.optJSONObject("products").optString("product_id"), 1);
						mAddCarInterface.setIsFastBuy();
						mAddCarInterface.RunRequest();
						return;
					}

					mAddCarInterface.setData(nItemJsonObject.optString("goods_id"), nItemJsonObject.optJSONObject("products").optString("product_id"), 1);
					mAddCarInterface.RunRequest();

					// 加入购物车动画
					// View view = mGridView.getChildAt(position -
					// mGridView.getFirstVisiblePosition());
					// Bitmap bmp = ((ImageView)
					// view.findViewById(R.id.goods_icon)).getDrawingCache();
					// int[] locations = new int[2];
					// view.getLocationInWindow(locations);
					// setAnimation(bmp, locations[0], locations[1] -
					// mTopHeight);
				}
			});
		}
		convertView.findViewById(R.id.goods_addcar).setTag(R.id.tag_first, mResultLists.indexOf(responseJson));

		if (getItemViewType(responseJson) == 0) {
			convertView.findViewById(R.id.goods_share).setTag(responseJson);
			convertView.findViewById(R.id.goods_share).setTag(R.id.tag_object, convertView.findViewById(R.id.goods_icon));
			convertView.findViewById(R.id.goods_collect).setTag(responseJson);

			TextView nIsFav = (TextView) convertView.findViewById(R.id.goods_collect_tv);
			nIsFav.setSelected(responseJson.optBoolean("is_fav"));
			nIsFav.setText(responseJson.optBoolean("is_fav") ? "取消收藏" : "加入收藏");
		}

		((TextView) convertView.findViewById(R.id.goods_name)).setText(responseJson.optString("name"));
		TextView nCommentTextView = (TextView) convertView.findViewById(R.id.goods_comments);
		nCommentTextView.setText(String.format("%s人评论", responseJson.optString("comments_count")));
		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_icon), responseJson.optString("image_default_id"));
		JSONObject nProductJsonObject = responseJson.optJSONObject("products");
		if (nProductJsonObject == null) {
			convertView.setTag("");
			return convertView;
		}
		convertView.setTag(nProductJsonObject.optString("product_id"));

		JSONObject nPriceJsonObject = nProductJsonObject.optJSONObject("price_list");
		if (nPriceJsonObject == null) {
			return convertView;
		}

		((TextView) convertView.findViewById(R.id.goods_price)).setText(nPriceJsonObject.optJSONObject("price").optString("format"));// 防止价格排序混乱
		TextView nMktPriceTextView = (TextView) convertView.findViewById(R.id.goods_market_price);
		nMktPriceTextView.setPaintFlags(Paint.STRIKE_THRU_TEXT_FLAG);
		nMktPriceTextView.setText(getItemViewType(responseJson) == 0 && nPriceJsonObject.has("mktprice") ? StringUtils.getString(nPriceJsonObject.optJSONObject("mktprice"), "format") : "");

		if (nType == 0) {
			if (responseJson.optString("buy_count").equals( "0")) {
				convertView.findViewById(R.id.goods_buycount_tr).setVisibility(View.GONE);
			} else {
				convertView.findViewById(R.id.goods_buycount_tr).setVisibility(View.VISIBLE);
				((TextView) convertView.findViewById(R.id.goods_buycount)).setText(responseJson.optString("buy_count"));
			}
		}

		int store = nProductJsonObject.optInt("store");
		ImageView nStatusImageView = (ImageView) convertView.findViewById(R.id.goods_status);
		View nAddcarView = convertView.findViewById(R.id.goods_addcar);
		if (store <= 0) {
			nAddcarView.setVisibility(View.GONE);
			nStatusImageView.setVisibility(View.VISIBLE);
			nStatusImageView.setImageResource(R.drawable.goods_item_sold_out);
		} else {
			nAddcarView.setVisibility(View.VISIBLE);
			nStatusImageView.setVisibility(View.GONE);

			int nStatus = GoodsUtil.getPrepareStatus(nProductJsonObject);
			if (nStatus == 3 || nStatus == 4 || nStatus == 5 || nStatus == 7) {
				nAddcarView.setVisibility(View.GONE);
				nStatusImageView.setVisibility(View.VISIBLE);
				nStatusImageView.setImageResource(R.drawable.goods_item_activity_finish);
			}
		}

		LinearLayout nPromotionLayout = (LinearLayout) convertView.findViewById(R.id.goods_promation_tag_tr);
		assignmentPromotionTag(responseJson, nPromotionLayout, convertView.findViewById(R.id.goods_promation_rl),
				mNumColumns == 1 ? nCommentTextView.getPaint().measureText(nCommentTextView.getText().toString()) : 0);

		assignmentTap(responseJson, convertView);
		return convertView;
	}

	/**
	 * 解析并赋值促销标签
	 *
	 * @param itemJsonObject
	 * @param promotionLayout
	 */
	void assignmentPromotionTag(JSONObject itemJsonObject, final LinearLayout promotionLayout, final View parentView, final float rightWidth) {
		JSONArray nPromotionArray = itemJsonObject.optJSONArray("promotion_tags");
		promotionLayout.removeAllViews();
		if (nPromotionArray != null && nPromotionArray.length() > 0) {
			LinearLayout.LayoutParams nLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
			nLayoutParams.rightMargin = Run.dip2px(mActivity, 5);
			for (int i = 0; i < nPromotionArray.length(); i++) {
				JSONObject nJsonObject = nPromotionArray.optJSONObject(i);
				final TextView nView = (TextView) View.inflate(mActivity, R.layout.item_promotion_tag, null);
				final String nTag = nJsonObject.optString("tag_name");
				nView.setText(nTag);// nTag.length() > 1 ? nTag.substring(0, 1)
				// :

				promotionLayout.addView(nView, LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);

				((LinearLayout.LayoutParams) nView.getLayoutParams()).rightMargin = nLayoutParams.rightMargin;

				nView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {

					@Override
					public void onGlobalLayout() {
						// TODO Auto-generated method stub
						if (rightWidth + nView.getLeft() + mTagRedundancyWidth + nView.getPaint().measureText(nTag) > parentView.getWidth()) {
							promotionLayout.removeView(nView);
						}
					}
				});
			}
		}
	}

	/**
	 * 解析并赋值标签(左上、右上、左下、右下)文字或者图片
	 *
	 * @param itemJsonObject
	 * @param itemView
	 */
	void assignmentTap(JSONObject itemJsonObject, View itemView) {
		TextView nltTextView = (TextView) itemView.findViewById(R.id.goods_tag_lefttop);
		nltTextView.setVisibility(View.GONE);
		TextView nrtTextView = (TextView) itemView.findViewById(R.id.goods_tag_righttop);
		nrtTextView.setVisibility(View.GONE);
		TextView nlbTextView = (TextView) itemView.findViewById(R.id.goods_tag_leftbottom);
		nlbTextView.setVisibility(View.GONE);
		TextView nrbTextView = (TextView) itemView.findViewById(R.id.goods_tag_rightbottom);
		nrbTextView.setVisibility(View.GONE);

		ImageView nltImageView = (ImageView) itemView.findViewById(R.id.goods_tag_image_lefttop);
		nltImageView.setVisibility(View.GONE);
		ImageView nrtImageView = (ImageView) itemView.findViewById(R.id.goods_tag_image_righttop);
		nrtImageView.setVisibility(View.GONE);
		ImageView nlbImageView = (ImageView) itemView.findViewById(R.id.goods_tag_image_leftbottom);
		nlbImageView.setVisibility(View.GONE);
		ImageView nrbImageView = (ImageView) itemView.findViewById(R.id.goods_tag_image_rightbottom);
		nrbImageView.setVisibility(View.GONE);

		JSONArray nArray = itemJsonObject.optJSONArray("tags");
		if (nArray == null || nArray.length() <= 0) {
			return;
		}

		for (int i = 0; i < nArray.length(); i++) {
			JSONObject nJsonObject = nArray.optJSONObject(i);
			JSONObject nParams = nJsonObject.optJSONObject("params");
			String nLoc = nParams.optString("pic_loc");
			String nImage = nParams.optString("tag_image");
			int nTextColor = Color.parseColor(nJsonObject.optString("tag_fgcolor"));
			int nBgColor = Color.parseColor(nJsonObject.optString("tag_bgcolor"));
			if (nLoc.equals("tl") || nLoc.equals("lt")) {// 左上
				if (TextUtils.isEmpty(nImage)) {
					nltTextView.setBackground(new TintedBitmapDrawable(mResources, R.drawable.goods_tag_lefttop, nBgColor));
					nltTextView.setTextColor(nTextColor);
					nltTextView.setText(nJsonObject.optString("tag_name"));
					nltTextView.setVisibility(View.VISIBLE);
				} else {
					nltImageView.setVisibility(View.VISIBLE);
					displaySquareImage(nltImageView, nImage);
				}
			} else if (nLoc.equals("tr") || nLoc.equals("rt")) {// 右上
				if (TextUtils.isEmpty(nImage)) {
					nrtTextView.setBackground(new TintedBitmapDrawable(mResources, R.drawable.goods_tag_righttop, nBgColor));
					nrtTextView.setTextColor(nTextColor);
					nrtTextView.setVisibility(View.VISIBLE);
					nrtTextView.setText(nJsonObject.optString("tag_name"));
				} else {
					nrtImageView.setVisibility(View.VISIBLE);
					displaySquareImage(nrtImageView, nImage);
				}
			} else if (nLoc.equals("bl") || nLoc.equals("lb")) {// 左下
				if (TextUtils.isEmpty(nImage)) {
					nlbTextView.setBackgroundColor(nBgColor);
					nlbTextView.setTextColor(nTextColor);
					nlbTextView.setVisibility(View.VISIBLE);
					nlbTextView.setText(nJsonObject.optString("tag_name"));
				} else {
					nlbImageView.setVisibility(View.VISIBLE);
					displaySquareImage(nlbImageView, nImage);
				}
			} else if (nLoc.equals("br") || nLoc.equals("rb")) {// 右下
				if (TextUtils.isEmpty(nImage)) {
					nrbTextView.setBackgroundColor(nBgColor);
					nrbTextView.setTextColor(nTextColor);
					nrbTextView.setVisibility(View.VISIBLE);
					nrbTextView.setText(nJsonObject.optString("tag_name"));
				} else {
					nrbImageView.setVisibility(View.VISIBLE);
					displaySquareImage(nrbImageView, nImage);
				}
			}
		}
	}
	public final class TintedBitmapDrawable extends BitmapDrawable {
		private int tint;
		private int alpha;

		public TintedBitmapDrawable(final Resources res, final Bitmap bitmap, final int tint) {
			super(res, bitmap);
			this.tint = tint;
			this.alpha = Color.alpha(tint);
		}

		public TintedBitmapDrawable(final Resources res, final int resId, final int tint) {
			super(res, BitmapFactory.decodeResource(res, resId));
			this.tint = tint;
			this.alpha = Color.alpha(tint);
		}

		public void setTint(final int tint) {
			this.tint = tint;
			this.alpha = Color.alpha(tint);
		}

		@Override public void draw(final Canvas canvas) {
			final Paint paint = getPaint();
			if (paint.getColorFilter() == null) {
				paint.setColorFilter(new LightingColorFilter(tint, 0));
				paint.setAlpha(alpha);
			}
			super.draw(canvas);
		}
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (!TextUtils.isEmpty(mCategoryId)) {
			nContentValues.put("cat_id", mCategoryId);
		} else if (!TextUtils.isEmpty(mVitualCategoryId)) {
			nContentValues.put("virtual_cat_id", mVitualCategoryId);
		} else if (!TextUtils.isEmpty(mBrandId)) {
			nContentValues.put("brand_id", mBrandId);
		} else if (!TextUtils.isEmpty(mTagId)) {
			mDefualtSelectedItemsWidthValue.put("pTag", mTagId);
			mSortFilternContentValues.put("pTag", mTagId);
			mTagId = "";
		}

		if (!TextUtils.isEmpty(mKeywords)) {
			nContentValues.put("search_keywords", mKeywords);
		}

		if (isPrepare) {
			nContentValues.put("show_preparesell_goods", "true");
		}

		nContentValues.putAll(mSortFilternContentValues);

		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		if (mIsFirst) {
			return "b2c.gallery.index";
		} else {
			return "b2c.gallery.getList";
		}
	}

	@Override
	protected void addHeader(LinearLayout headerLayout) {
		// TODO Auto-generated method stub
		LinearLayout nHeaderView = (LinearLayout) View.inflate(mActivity, R.layout.header_goods_list_brand, null);
		headerLayout.addView(nHeaderView);

		mBrandDescView = (WebView) nHeaderView.findViewById(R.id.header_brand_webview);
		mBrandLogoImageView = (ImageView) nHeaderView.findViewById(R.id.header_brand_logo);
		mBrandNameTextView = (TextView) nHeaderView.findViewById(R.id.header_brand_name);
		mBrandSeoDesc = (TextView) nHeaderView.findViewById(R.id.header_brand_seo_desc);

		mBrandLogoImageView.setVisibility(View.GONE);
		mBrandSeoDesc.setVisibility(View.GONE);
		mBrandNameTextView.setVisibility(View.GONE);
		nHeaderView.setVisibility(TextUtils.isEmpty(mBrandId) ? View.GONE : View.VISIBLE);

		mRadioBarCopyHorizontalListView = (HorizontalListView) nHeaderView.findViewById(R.id.bar_list_copy_view);
		mRadioBarCopyLinearLayout = (LinearLayout) nHeaderView.findViewById(R.id.bar_list_view_copy_ll);
		nHeaderView.removeView(mRadioBarCopyLinearLayout);
		((LinearLayout) findViewById(R.id.base_pinned_ll)).addView(mRadioBarCopyLinearLayout);
		mRadioBarCopyLinearLayout.setVisibility(View.GONE);

		initWebsettings();

		mGridView.setBackgroundResource(R.color.fragment_background_color);
	}

	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		// TODO Auto-generated method stub
		super.onWindowFocusChanged(hasFocus);
		if (hasFocus && isFirstLayout) {
			isFirstLayout = false;
			mPullableScrollView.smoothScrollTo(0, 0);
		}
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		mListHeaderLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_header_ll);
		mRadioBarHorizontalListView = (HorizontalListView) findViewById(R.id.bar_list_view);
		mBarAdapter = new GoodsSortRadioBarAdapter(mActivity, new GoodsSortBarHandler() {

			@Override
			public void onSortConditionChanged(ContentValues basicnContentValues) {
				// TODO Auto-generated method stub
				mSortFilternContentValues.clear();
				mSortFilternContentValues.putAll(basicnContentValues);
				if (isFirstLoadData) {
					isFirstLoadData = false;
					return;
				}
				onRefresh(null);
			}

			@Override
			public int parentWidth() {
				// TODO Auto-generated method stub
				return mRadioBarHorizontalListView.getWidth();
			}

			@Override
			public void beginShowPopup() {
				// TODO Auto-generated method stub
				int nY = mGridView.getTop() - Run.dip2px(mActivity, 46);
				if (mPullableScrollView.getScrollY() < nY) {
					mPullableScrollView.smoothScrollTo(0, nY);
				}
			}
		});

		mRadioBarHorizontalListView.setVisibility(View.VISIBLE);
		mRadioBarHorizontalListView.setAdapter(mBarAdapter.mSelectAdapter);
		mRadioBarCopyHorizontalListView.setAdapter(mBarAdapter.mSelectAdapter);
		mListHeaderLinearLayout.setVisibility(View.VISIBLE);
		findViewById(R.id.bar_list_view_ll).setVisibility(View.VISIBLE);

		setShowEmptyText(TextUtils.isEmpty(mBrandId));

		initPinnedScrollView();
		setShowShopCar(true);

//		setEmptyText("暂无商品信息");
		initGoodEmptyView();
	}

	void initGoodEmptyView() {
		View nView = View.inflate(mActivity, R.layout.empty_shop_car, null);
		setCustomEmptyView(nView);
		nView.findViewById(R.id.shopping_go).setVisibility(View.GONE);
		ImageView icon = (ImageView) nView.findViewById(R.id.shopping_hint_icon);
		icon.setImageResource(R.drawable.good_list_empty);
		TextView title = (TextView) nView.findViewById(R.id.tv_title);
		title.setText("没有找到任何相关信息");
		TextView hint = (TextView) nView.findViewById(R.id.tv_hint);
		hint.setText("选择搜索其他商品分类/名称");
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		setShopCarCount(Run.goodsCounts);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		switch (requestCode) {
			case REQUEST_SEARCH_KEY:
				if (resultCode == Activity.RESULT_OK) {
					mKeywords = data.getStringExtra(Run.EXTRA_KEYWORDS);
					mIsFirst = true;
					mSortFilternContentValues.clear();
					mItemSearchView.setHint(mKeywords);
					onRefresh(null);
				}
				break;

			default:
				super.onActivityResult(requestCode, resultCode, data);
				break;
		}
	}

	void assignmentView(JSONObject jsonObject) {
		if (mIsAssignment) {
			return;
		}

		mIsAssignment = true;
		String nBrandDescString = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" /><style>* {max-width:100%;}* {font-size:1.0em;}</style>"
				+ jsonObject.optString("brand_desc");
		mBrandDescView.loadDataWithBaseURL(null, nBrandDescString, "text/html", "utf8", null);
		// mBrandNameTextView.setText(mBrandNameString);

		JSONObject nSeoInfoJsonObject = jsonObject.optJSONObject("seo_info");
		if (nSeoInfoJsonObject != null) {
			mBrandSeoDesc.setText(nSeoInfoJsonObject.optString("seo_description"));
		} else {
			mBrandSeoDesc.setText("");
		}

		displaySquareImage(mBrandLogoImageView, jsonObject.optString("brand_logo"));
	}

	void initWebsettings() {
		// 打开网页时不调用系统浏览器， 而是在本WebView中显示：
		mBrandDescView.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				onClick("custom", url, "");
				return true;
			}

			@Override
			public void onPageFinished(WebView view, String url) {
				// TODO Auto-generated method stub
				super.onPageFinished(view, url);
				mHandler.sendEmptyMessageDelayed(SHOW_FIRST_BRAND_PAGE, 200);
			}

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				// TODO Auto-generated method stub
				super.onPageStarted(view, url, favicon);
			}
		});
		mBrandDescView.setWebChromeClient(new WebChromeClient() {
			@Override
			public void onReceivedTitle(WebView view, String title) {
				// TODO Auto-generated method stub
				super.onReceivedTitle(view, title);
				// mActionBar.setTitle(title);
			}
		});

		// 打开页面时， 自适应屏幕：
		WebSettings webSettings = mBrandDescView.getSettings();
		webSettings.setUseWideViewPort(true);// 设置此属性，可任意比例缩放,将图片调整到适合webview的大小
		webSettings.setLoadWithOverviewMode(true);

		// 便页面支持缩放：
		webSettings.setJavaScriptEnabled(false);
		webSettings.setBuiltInZoomControls(false);
		webSettings.setSupportZoom(false);

		// mWebView.setPluginsEnabled(true); //支持插件
		webSettings.setLayoutAlgorithm(LayoutAlgorithm.NORMAL); // 支持内容重新布局
		webSettings.supportMultipleWindows(); // 多窗口
		webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE); // 关闭webview中缓存
		// webSettings.setAllowFileAccess(true); //设置可以访问文件
		// webSettings.setNeedInitialFocus(true);
		// //当webview调用requestFocus时为webview设置节点
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true); // 支持通过JS打开新窗口
		webSettings.setLoadWithOverviewMode(true); // 缩放至屏幕的大小
		webSettings.setLoadsImagesAutomatically(true); // 支持自动加载图片
	}

	@Override
	public void ui(int what, Message msg) {
		// TODO Auto-generated method stub
		switch (what) {
			case SHOW_FIRST_BRAND_PAGE:
				mResultLists.addAll(mBrandFirstData);
				mAdapter.notifyDataSetChanged();
				mBrandFirstData.clear();
				break;

			default:
				super.ui(what, msg);
				break;
		}
	}

	@Override
	protected int getNumColumns() {
		// TODO Auto-generated method stub
		return mNumColumns;
	}

	@SuppressLint("ClickableViewAccessibility")
	void initPinnedScrollView() {
		mPullableScrollView.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				onScroll(lastScrollY = mPullableScrollView.getScrollY());
				switch (event.getAction()) {
					case MotionEvent.ACTION_UP:
						handler.sendMessageDelayed(handler.obtainMessage(), 20);
						break;
				}
				return false;
			}
		});
	}

	// 监听滚动Y值变化，通过addView和removeView来实现悬停效果
	public void onScroll(int scrollY) {
		int barTopWithBrand = mBarTop;
		if (!TextUtils.isEmpty(mBrandId)) {
			barTopWithBrand = mBarTop + mBrandDescView.getHeight() + Run.dip2px(mActivity, 10);
		}
		if (scrollY > barTopWithBrand) {
			mRadioBarCopyLinearLayout.setVisibility(View.VISIBLE);
		} else {
			mRadioBarCopyLinearLayout.setVisibility(View.GONE);
		}
	}

	/**
	 * 主要是用在用户手指离开MyScrollView，MyScrollView还在继续滑动，我们用来保存Y的距离，然后做比较
	 */
	private int lastScrollY;

	/**
	 * 用于用户手指离开MyScrollView的时候获取MyScrollView滚动的Y距离，然后回调给onScroll方法中
	 */
	private Handler handler = new Handler() {

		public void handleMessage(android.os.Message msg) {
			int scrollY = mPullableScrollView.getScrollY();

			// 此时的距离和记录下的距离不相等，在隔5毫秒给handler发送消息
			if (lastScrollY != scrollY) {
				lastScrollY = scrollY;
				handler.sendMessageDelayed(handler.obtainMessage(), 5);
			}
			onScroll(scrollY);
		}

	};
}