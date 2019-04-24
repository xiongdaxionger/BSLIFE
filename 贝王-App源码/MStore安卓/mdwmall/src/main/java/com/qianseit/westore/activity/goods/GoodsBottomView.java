package com.qianseit.westore.activity.goods;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.base.BaseLocalListFragment;
import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter.RadioBarCallback;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;
import com.qianseit.westore.ui.HorizontalListView;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class GoodsBottomView extends LinearLayout {

	List<RadioBarBean> mRadioBarBeans = new RadioBarBeanList();
	Map<Long, BaseDoFragment> mRadioBarMap = new HashMap<Long, BaseDoFragment>();

	HorizontalListView mBarHorizontalListView;
	BaseRadioBarAdapter mAdapter;

	BaseDoFragment mParentDoFragment;

	JSONObject mProductBasicJsonObject, mSettingJsonObject;

	public GoodsBottomView(Context context) {
		this(context, null, 0);
		// TODO Auto-generated constructor stub
	}

	public GoodsBottomView(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
		// TODO Auto-generated constructor stub
	}

	public GoodsBottomView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
		mParentDoFragment = ParentFragment();
		LayoutInflater.from(context).inflate(R.layout.fragment_goods_detail_bottom, this);

		mBarHorizontalListView = (HorizontalListView) findViewById(R.id.goods_detail_bottom_bar);
		final int mWindowWidth = Run.getWindowsWidth(mParentDoFragment.mActivity);
		mAdapter = new BaseRadioBarAdapter(context, mRadioBarBeans, new RadioBarCallback() {

			@Override
			public boolean showRadioBarsDivider() {
				// TODO Auto-generated method stub
				return false;
			}

			@Override
			public int parentWindowsWidth() {
				// TODO Auto-generated method stub
				return mWindowWidth;
			}

			@Override
			public boolean onSelectedRadioBar(RadioBarBean barBean) {
				// TODO Auto-generated method stub
				FragmentTransaction transaction = mParentDoFragment.mActivity.getSupportFragmentManager().beginTransaction();
				transaction.replace(R.id.goods_detail_bottom_comtent, mRadioBarMap.get(barBean.mId));
				transaction.commitAllowingStateLoss();
				return false;
			}
		}) {
			@Override
			public void notifyDataSetChanged() {
				if (getCount() == 1) {
					mBarCallback.onSelectedRadioBar(getItem(0));
					mBarHorizontalListView.setVisibility(View.GONE);
				}else{
					mBarHorizontalListView.setVisibility(View.VISIBLE);
				}
				super.notifyDataSetChanged();
			}
		};
		mAdapter.setVisibleRadios(5);
		mBarHorizontalListView.setAdapter(mAdapter);
	}

	/**
	 * @param productBasicJsonObject
	 * @param settingJsonObject
	 *            "setting": {//配置信息 "acomment": { "switch": { "ask":
	 *            "on",//on开启商品咨询否则关闭 "discuss": "on"//on开启商品评论否则关闭 },
	 *            "point_status": "on"//on商品开启否则关闭 }, "recommend":
	 *            "true",//true商品开启推荐否则关闭推荐 "selllog":
	 *            "true",//true开启商品销售记录否则关闭销售记录 "buytarget":
	 *            "3"//加入购物车按钮跳转方式：1.跳转到购物车页面 2.不跳转，不提示 3.不跳转，弹出购物车提示 }
	 * @param diyArray
	 *            [//自定义tab { "name": "售后保障", "is_call": "", "content":
	 *            ""//html格式, "id": "type_tab_1" } ]
	 */
	public void setDatas(JSONObject productBasicJsonObject, JSONObject settingJsonObject, JSONArray diyArray) {
		mProductBasicJsonObject = productBasicJsonObject;

		GoodsMoreRemarkFragment nImageTextDetailFragment = new GoodsMoreRemarkFragment();
		Bundle nImageTextDetailBundle = new Bundle();
		nImageTextDetailBundle.putString(Run.EXTRA_DATA, mProductBasicJsonObject.optString("intro"));
		nImageTextDetailFragment.setArguments(nImageTextDetailBundle);
		mRadioBarMap.put(RadioBarType.IMAGE_TEXT_DETAIL, nImageTextDetailFragment);
		mRadioBarBeans.add(new RadioBarBean("图文详情", RadioBarType.IMAGE_TEXT_DETAIL));

		JSONArray nArray = mProductBasicJsonObject.optJSONArray("params");
		if (nArray != null && nArray.length() > 0) {

			GoodsSpecParamsFragment nGoodsSpecParamsFragment = new GoodsSpecParamsFragment();
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_DATA, nArray.toString());
			nGoodsSpecParamsFragment.setArguments(nBundle);
			mRadioBarMap.put(RadioBarType.SPEC_PARAMS, nGoodsSpecParamsFragment);
			mRadioBarBeans.add(new RadioBarBean("规格参数", RadioBarType.SPEC_PARAMS));
		}

		if (settingJsonObject != null && !settingJsonObject.isNull("selllog")) {
			if (settingJsonObject.optBoolean("selllog")) {
				GoodsSalesRecordFragment nGoodsSalesRecordFragment = new GoodsSalesRecordFragment();
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_DATA, productBasicJsonObject.optString("goods_id"));
				nGoodsSalesRecordFragment.setArguments(nBundle);
				mRadioBarMap.put(Long.valueOf(settingJsonObject.hashCode()), nGoodsSalesRecordFragment);
				mRadioBarBeans.add(new RadioBarBean("销售记录", Long.valueOf(settingJsonObject.hashCode())));
			}
		}

		if (diyArray != null && diyArray.length() > 0) {
			for (int i = 0; i < diyArray.length(); i++) {
				JSONObject nJsonObject = diyArray.optJSONObject(i);
				GoodsMoreRemarkFragment nGoodsMoreRemarkFragment = new GoodsMoreRemarkFragment();
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_DATA, nJsonObject.optString("content"));
				nGoodsMoreRemarkFragment.setArguments(nBundle);
				mRadioBarMap.put(Long.valueOf(nJsonObject.hashCode()),nGoodsMoreRemarkFragment);
				mRadioBarBeans.add(new RadioBarBean(nJsonObject.optString("name"), Long.valueOf(nJsonObject.hashCode())));
			}
		}

		mSettingJsonObject = settingJsonObject;

		mAdapter.notifyDataSetChanged();
	}

	public void notifyDataSetChanged() {
		mAdapter.notifyDataSetChanged();
	}

	public abstract BaseDoFragment ParentFragment();

	class RadioBarType {
		public final static long IMAGE_TEXT_DETAIL = 1;
		public final static long SPEC_PARAMS = 2;
	}

	@SuppressLint("ValidFragment")
	public static class GoodsMoreRemarkFragment extends BaseWebviewFragment {
		String mHtmlContent;


		@Override
		public void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			mActionBar.setShowTitleBar(false);
			mHtmlContent = getArguments().getString(Run.EXTRA_DATA);
		}

		@Override
		protected void init() {
			// TODO Auto-generated method stub
			rootView.findViewById(R.id.base_top_divider).setVisibility(View.GONE);
		}

		@Override
		public String getContent() {
			// TODO Auto-generated method stub
			return mHtmlContent;
		}

		@Override
		protected void initWebsettings() {
			super.initWebsettings();

			WebSettings webSettings = mWebView.getSettings();
			webSettings.setJavaScriptEnabled(false);
			webSettings.setBuiltInZoomControls(false);
			webSettings.setSupportZoom(false);
		}
	}

	public static class GoodsSpecParamsFragment extends BaseLocalListFragment<JSONObject> {
		List<JSONObject> mSpecParamsJsonObjects;

		@Override
		public void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			mActionBar.setShowTitleBar(false);
			mSpecParamsJsonObjects = new ArrayList<JSONObject>();
			try {
				JSONArray nJsonArray = new JSONArray(getArguments().getString(Run.EXTRA_DATA));
				for (int i = 0; i < nJsonArray.length(); i++) {
					JSONObject nJsonObject = nJsonArray.optJSONObject(i);
					mSpecParamsJsonObjects.add(nJsonObject);
					JSONArray nArray2 = nJsonObject.optJSONArray("group_param");
					for (int j = 0; j < nArray2.length(); j++) {
						mSpecParamsJsonObjects.add(nArray2.optJSONObject(j));
					}
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		@Override
		protected List<JSONObject> buildLocalItems() {
			// TODO Auto-generated method stub
			return mSpecParamsJsonObjects;
		}

		@Override
		protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (getItemViewType(responseJson) == 0) {
				if (convertView == null) {
					convertView = View.inflate(mActivity, R.layout.item_goods_detail_spec_title, null);
				}
				((TextView) convertView.findViewById(R.id.group_param_name)).setText(responseJson.optString("group_name"));
			} else {
				if (convertView == null) {
					convertView = View.inflate(mActivity, R.layout.item_goods_detail_spec_item, null);
				}
				((TextView) convertView.findViewById(R.id.param_name)).setText(responseJson.optString("name"));
				((TextView) convertView.findViewById(R.id.param_value)).setText(responseJson.optString("value"));
			}
			return convertView;
		}

		@Override
		protected int getItemViewType(JSONObject t) {
			// TODO Auto-generated method stub
			return t != null && t.has("group_name") ? 0 : 1;
		}

		@Override
		protected int getViewTypeCount() {
			// TODO Auto-generated method stub
			return 2;
		}
	}

	public static class GoodsSalesRecordFragment extends BaseListFragment<JSONObject> {
		String mGoodsId;
		boolean mShowPrice = true;
		View mHeaderView;

		@Override
		public void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			mActionBar.setShowTitleBar(false);
			mGoodsId = getArguments().getString(Run.EXTRA_DATA);
		}

		@Override
		protected ContentValues extentConditions() {
			// TODO Auto-generated method stub
			ContentValues nContentValues = new ContentValues();
			nContentValues.put("goods_id", mGoodsId);
			return nContentValues;
		}

		@Override
		protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_goods_detail_sales_record, null);
				convertView.findViewById(R.id.price).setVisibility(mShowPrice ? View.VISIBLE : View.GONE);
			}

			((TextView) convertView.findViewById(R.id.nickname)).setText(responseJson.optString("name"));
			((TextView) convertView.findViewById(R.id.price)).setText(responseJson.optString("price"));
			((TextView) convertView.findViewById(R.id.qty)).setText(responseJson.optString("number"));
			((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("createtime")));

			return convertView;
		}

		@Override
		protected void initTop(LinearLayout topLayout) {
			// TODO Auto-generated method stub
			mHeaderView = View.inflate(mActivity, R.layout.item_goods_detail_sales_record, null);
			int nTitleTextColor = mActivity.getResources().getColor(R.color.westore_dark_textcolor);
			((TextView) mHeaderView.findViewById(R.id.nickname)).setTextColor(nTitleTextColor);
			((TextView) mHeaderView.findViewById(R.id.price)).setTextColor(nTitleTextColor);
			((TextView) mHeaderView.findViewById(R.id.qty)).setTextColor(nTitleTextColor);
			((TextView) mHeaderView.findViewById(R.id.time)).setTextColor(nTitleTextColor);
			topLayout.addView(mHeaderView);
			mHeaderView.setVisibility(View.GONE);
		}

		@Override
		protected List<JSONObject> fetchDatas(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (mPageNum == 1) {
				mHeaderView.setVisibility(View.VISIBLE);
				mShowPrice = responseJson.optBoolean("selllog_member_price");
				findViewById(R.id.price).setVisibility(mShowPrice ? View.VISIBLE : View.GONE);
			}
			List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
			JSONObject nJsonObject = responseJson.optJSONObject("sellLogList");
			if (nJsonObject == null) {
				return nJsonObjects;
			}

			JSONArray nArray = nJsonObject.optJSONArray("data");
			if (nArray == null || nArray.length() <= 0) {
				return nJsonObjects;
			}

			for (int i = 0; i < nArray.length(); i++) {
				nJsonObjects.add(nArray.optJSONObject(i));
			}
			return nJsonObjects;
		}

		@Override
		protected String requestInterfaceName() {
			// TODO Auto-generated method stub
			return "b2c.product.goodsSellLoglist";
		}
	}
}
