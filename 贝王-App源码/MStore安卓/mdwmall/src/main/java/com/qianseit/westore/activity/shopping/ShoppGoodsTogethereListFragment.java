package com.qianseit.westore.activity.shopping;

import android.content.ContentValues;
import android.os.Bundle;
import android.text.TextUtils;
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
import com.qianseit.westore.base.BaseGridFragment;
import com.qianseit.westore.httpinterface.shopping.ShoppCarAddInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class ShoppGoodsTogethereListFragment extends BaseGridFragment<JSONObject> {
	public static  final String TAB_FILTER = "$tabfilter";

	int mNumColumns = 2;
	
	String mTabFilter = "";

	ContentValues mSortFilternContentValues = new ContentValues();

	ShoppCarAddInterface mAddCarInterface = new ShoppCarAddInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.goodsCounts += getQty();
			setShopCarCount(Run.goodsCounts);
		}

	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
		mTabFilter = getArguments().getString(TAB_FILTER);
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray nArray = responseJson.optJSONArray("list");
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
		if (convertView == null) {
			if (getItemViewType(responseJson) == 0) {
				convertView = View.inflate(mActivity, R.layout.item_goods_list, null);
			} else {
				convertView = View.inflate(mActivity, R.layout.item_goods_grid, null);
				setViewSize(convertView.findViewById(R.id.goods_icon_fl), mImageWidth, mImageWidth);
				convertView.findViewById(R.id.goods_promation_rl).setVisibility(View.GONE);
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
					mAddCarInterface.setData(nItemJsonObject.optString("goods_id"), nItemJsonObject.optString("product_id"), 1);
					mAddCarInterface.RunRequest();
				}
			});
		}
		convertView.findViewById(R.id.goods_addcar).setTag(R.id.tag_first, mResultLists.indexOf(responseJson));

		((TextView) convertView.findViewById(R.id.goods_name)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.goods_comments)).setText("");
		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_icon), responseJson.optString("image_default_id"));
		convertView.setTag(responseJson.optString("product_id"));


		((TextView) convertView.findViewById(R.id.goods_price)).setText(responseJson.optString("price"));

		int store = responseJson.optInt("store");
		if (store <= 0) {
			convertView.findViewById(R.id.goods_addcar).setVisibility(View.GONE);
			convertView.findViewById(R.id.goods_status).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_addcar).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.goods_status).setVisibility(View.GONE);
		}

		return convertView;
	}

	/**
	 * 解析并赋值促销标签
	 * 
	 * @param itemJsonObject
	 * @param promotionLayout
	 */
	void assignmentPromotionTag(JSONObject itemJsonObject, LinearLayout promotionLayout) {
		JSONArray nPromotionArray = itemJsonObject.optJSONArray("promotion_tags");
		promotionLayout.removeAllViews();
		if (nPromotionArray != null && nPromotionArray.length() > 0) {
			LinearLayout.LayoutParams nLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
			nLayoutParams.rightMargin = Run.dip2px(mActivity, 5);
			for (int i = 0; i < nPromotionArray.length(); i++) {
				JSONObject nJsonObject = nPromotionArray.optJSONObject(i);
				TextView nView = (TextView) View.inflate(mActivity, R.layout.item_promotion_tag, null);
				String nTag = nJsonObject.optString("tag_name");
				nView.setText(nTag.length() > 1 ? nTag.substring(0, 1) : nTag);
				promotionLayout.addView(nView, LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);

				((LinearLayout.LayoutParams) nView.getLayoutParams()).rightMargin = nLayoutParams.rightMargin;
			}
		}
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValuess = new ContentValues();
		nContentValuess.put("tab_name", mTabFilter);

		return nContentValuess;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.fororder";
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setShowShopCar(true);
		setShopCarCount(Run.goodsCounts);
	}

	@Override
	protected int getNumColumns() {
		// TODO Auto-generated method stub
		return mNumColumns;
	}
}
