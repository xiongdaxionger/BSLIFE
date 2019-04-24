package com.qianseit.westore.activity.shopping;

import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.text.Html;
import android.text.Html.ImageGetter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShoppConfirmOrderAdapter extends QianseitAdapter<JSONObject> {
	final String CHECK_STATUS_FIELD = "selected";
	final String ITEM_TYPE_FIELD = "itemtypefield";
	final String ITEM_TYPE_FIRST_FIELD = "itemtypefirstfield";
	final String ITEM_TYPE_END_FIELD = "itemtypeendfield";
	final String ITEM_PARENT_INDEX = "itemparentindex";
	/**
	 * 只针对标题项有效，如享受更多优惠
	 */
	final String ITEM_TITLE_FIELD = "itemtitlefield";

	/**
	 * 商品
	 */
	final int ITEM_GOODS = 0;
	/**
	 * 商品赠品
	 */
	final int ITEM_GOODS_GIFT = 1;
	/**
	 * 商品配件
	 */
	final int ITEM_GOODS_ADJUNCT = 2;
	/**
	 * 商品促销
	 */
	final int ITEM_GOODS_PROMOTION = 3;
	/**
	 * 享受更多优惠
	 */
	final int ITEM_DISCOUNT_MORE = 4;
	/**
	 * 享受更多优惠
	 */
	final int ITEM_DISCOUNT_MORE_PROMOTION = 5;
	/**
	 * 积分兑换的赠品
	 */
	final int ITEM_GIFT_SCORE = 6;
	/**
	 * 已享受优惠 订单赠品
	 */
	final int ITEM_GIFT_ORDER = 7;
	/**
	 * 已享受优惠 订单促销
	 */
	final int ITEM_ORDER_PROMOTION = 8;
	/**
	 * 粗分割线（模块分割）
	 */
	final int ITEM_SPACE = 9;
	/**
	 * 已享受优惠
	 */
	final int ITEM_DISCOUNT = 10;
	
	JSONObject mCarJsonObject;
	Map<Integer, List<JSONObject>> mResultGroupMap = new HashMap<Integer, List<JSONObject>>();
	
	BaseDoFragment mParentFragment;
	
	boolean mCanUseCoupon = false;
	
	public ShoppConfirmOrderAdapter(JSONObject carJsonObject, BaseDoFragment fragment) {
		super(new ArrayList<JSONObject>());
		// TODO Auto-generated constructor stub
		mParentFragment = fragment;
		setCarData(carJsonObject);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		JSONObject nItemJsonObject = getItem(position);
		switch (getItemViewType(position)) {
		case ITEM_GOODS:
			convertView = getCarItemView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_GOODS_GIFT:
			convertView = getCarGiftItemView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_GOODS_ADJUNCT:
			convertView = getCarAdjunctItemView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_GOODS_PROMOTION:
			convertView = getCarItemPromotionView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_DISCOUNT_MORE_PROMOTION:
			convertView = getCarItemDiscountMoreView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_GIFT_SCORE:
			convertView = getCarItemView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_GIFT_ORDER:
			convertView = getCarGiftItemView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_ORDER_PROMOTION:
			convertView = getCarItemDiscountMoreView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_SPACE:
			convertView = getCarItemSpaceView(nItemJsonObject, convertView, parent);
			break;
		case ITEM_DISCOUNT_MORE:
		case ITEM_DISCOUNT:
			convertView = getCarItemTitleView(nItemJsonObject, convertView, parent);
			break;

		default:
			break;
		}

		return convertView;
	}

	public void setCarData(JSONObject carJsonObject){
		mCarJsonObject = carJsonObject;
		mResultGroupMap.clear();
		mDataList.clear();
		
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (mCarJsonObject == null) {
			return;
		}

		JSONObject nJsonObject = mCarJsonObject.optJSONObject("object");
		if (nJsonObject == null) {
			return;
		}

		try {
			// 商品
			JSONArray nGoodsArray = nJsonObject.optJSONArray("goods");
			if (nGoodsArray != null && nGoodsArray.length() > 0) {
				mCanUseCoupon = true;
				for (int i = 0; i < nGoodsArray.length(); i++) {
					JSONObject nGoodsJsonObject = nGoodsArray.optJSONObject(i);
					nGoodsJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
					List<JSONObject> nGroupItemList = new ArrayList<JSONObject>();
					mResultGroupMap.put(nGoodsJsonObject.hashCode(), nGroupItemList);

					if (nJsonObjects.size() > 0) {
						JSONObject nSpaceJsonObject = new JSONObject();
						nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
						nJsonObjects.add(nSpaceJsonObject);
						nGroupItemList.add(nSpaceJsonObject);
					}
					nJsonObjects.add(nGoodsJsonObject);
					nGroupItemList.add(nGoodsJsonObject);

					int nParentIndex = nJsonObjects.size() - 1;

					// 商品赠品
					JSONArray nGoodsGiftArray = nGoodsJsonObject.optJSONArray("gift");
					if (nGoodsGiftArray != null && nGoodsGiftArray.length() > 0) {
						for (int j = 0; j < nGoodsGiftArray.length(); j++) {
							JSONObject nGoodsGiftJsonObject = nGoodsGiftArray.optJSONObject(j);
							nGoodsGiftJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_GIFT);
							nGoodsGiftJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
							nJsonObjects.add(nGoodsGiftJsonObject);
							nGroupItemList.add(nGoodsGiftJsonObject);
						}
					}

					// 商品配件
					JSONArray nGoodsAdjunctArray = nGoodsJsonObject.optJSONArray("adjunct");
					if (nGoodsAdjunctArray != null && nGoodsAdjunctArray.length() > 0) {
						for (int j = 0; j < nGoodsAdjunctArray.length(); j++) {
							JSONObject nGoodsAdjunctJsonObject = nGoodsAdjunctArray.optJSONObject(j);
							nGoodsAdjunctJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_ADJUNCT);
							nGoodsAdjunctJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
							nJsonObjects.add(nGoodsAdjunctJsonObject);
							nGroupItemList.add(nGoodsAdjunctJsonObject);
						}
					}

					// 商品促销
					JSONArray nGoodsPromotionArray = nGoodsJsonObject.optJSONArray("promotion");
					if (nGoodsPromotionArray != null && nGoodsPromotionArray.length() > 0) {
						for (int j = 0; j < nGoodsPromotionArray.length(); j++) {
							JSONObject nGoodsPromotionJsonObject = nGoodsPromotionArray.optJSONObject(j);
							nGoodsPromotionJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_PROMOTION);
							nGoodsPromotionJsonObject.put(ITEM_TYPE_FIRST_FIELD, j == 0);
							nGoodsPromotionJsonObject.put(ITEM_TYPE_END_FIELD, j == nGoodsPromotionArray.length() - 1);
							nGoodsPromotionJsonObject.put(ITEM_PARENT_INDEX, nParentIndex);
							nJsonObjects.add(nGoodsPromotionJsonObject);
							nGroupItemList.add(nGoodsPromotionJsonObject);
						}
					}
				}
			}

			// 赠品
			JSONObject nGiftJsonObject = nJsonObject.optJSONObject("gift");
			if (nGiftJsonObject != null) {
				// 积分兑换的赠品
				JSONArray nGiftScoreArray = nGiftJsonObject.optJSONArray("cart");
				if (nGiftScoreArray != null && nGiftScoreArray.length() > 0) {
					for (int i = 0; i < nGiftScoreArray.length(); i++) {
						JSONObject nGiftScoreJsonObject = nGiftScoreArray.optJSONObject(i);
						nGiftScoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE);

						List<JSONObject> nGroupItemList = new ArrayList<JSONObject>();
						mResultGroupMap.put(nGiftScoreJsonObject.hashCode(), nGroupItemList);

						if (nJsonObjects.size() > 0) {
							JSONObject nSpaceJsonObject = new JSONObject();
							nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
							nJsonObjects.add(nSpaceJsonObject);
							nGroupItemList.add(nSpaceJsonObject);
						}
						nGroupItemList.add(nGiftScoreJsonObject);

						nJsonObjects.add(nGiftScoreJsonObject);
					}
				}

				// 订单赠品
				JSONArray nGiftOrderArray = nGiftJsonObject.optJSONArray("order");
				if (nGiftOrderArray != null && nGiftOrderArray.length() > 0) {
					List<JSONObject> nGroupItemList = null;
					if (!mResultGroupMap.containsKey(ITEM_DISCOUNT)) {
						nGroupItemList = new ArrayList<JSONObject>();
						mResultGroupMap.put(ITEM_DISCOUNT, nGroupItemList);
						JSONObject nSpaceJsonObject = new JSONObject();
						nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
						nJsonObjects.add(nSpaceJsonObject);
						nGroupItemList.add(nSpaceJsonObject);
					} else {
						nGroupItemList = mResultGroupMap.get(ITEM_DISCOUNT);
					}

					for (int i = 0; i < nGiftOrderArray.length(); i++) {
						JSONObject nGiftOrderJsonObject = nGiftOrderArray.optJSONObject(i);
						nGiftOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_ORDER);
						nJsonObjects.add(nGiftOrderJsonObject);
						nGroupItemList.add(nGiftOrderJsonObject);
					}
				}
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mDataList.addAll(nJsonObjects);
	}

	/**
	 * @return
	 * 积分兑换商品不能使用优惠券
	 */
	public boolean canUseCoupon(){
		return mCanUseCoupon;
	}
	
	/**
	 * 商品促销
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarItemPromotionView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mParentFragment.mActivity, R.layout.item_shopp_car_promotion, null);
		}
		convertView.findViewById(R.id.divider_top).setVisibility(responseJson.optBoolean(ITEM_TYPE_FIRST_FIELD, false) ? View.VISIBLE : View.GONE);
		convertView.findViewById(R.id.divider_bottom).setVisibility(responseJson.optBoolean(ITEM_TYPE_END_FIELD, false) ? View.VISIBLE : View.GONE);
		String nContent = String.format("<font color=#F3273F>[%s]</font>  %s", responseJson.optString("desc_tag"), responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.content)).setText(Html.fromHtml(nContent));
		return convertView;
	}

	/**
	 * 标题项 如享受更多优惠
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarItemTitleView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mParentFragment.mActivity, R.layout.item_shopp_car_title, null);
		}
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString(ITEM_TITLE_FIELD));
		return convertView;
	}

	/**
	 * 分割线项
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarItemSpaceView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mParentFragment.mActivity, R.layout.item_shopp_car_space, null);
		}
		return convertView;
	}

	/**
	 * 享受更多优惠
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarItemDiscountMoreView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mParentFragment.mActivity, R.layout.item_shopp_car_discount_promotion, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					if (!nJsonObject.optBoolean("fororder_status", false)) {
						return;
					}

					// 进入凑单界面
					mParentFragment.startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_TOGETHER);
				}
			});
		}
		((TextView) convertView.findViewById(R.id.promotion_name)).setText(responseJson.optString("desc_tag"));
		((TextView) convertView.findViewById(R.id.promotion_content)).setText(responseJson.optString("name"));
		convertView.findViewById(R.id.promotion_action).setVisibility(responseJson.optBoolean("fororder_status", false) ? View.VISIBLE : View.INVISIBLE);
		convertView.setTag(responseJson);
		return convertView;
	}

	/**
	 * 商品
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order;
			convertView = LayoutInflater.from(mParentFragment.mActivity).inflate(layout, null);
//			convertView.setOnClickListener(new OnClickListener() {
//
//				@Override
//				public void onClick(View v) {
//					// TODO Auto-generated method stub
//					JSONObject nProductJsonObject = (JSONObject) v.getTag();
//					mParentFragment.startActivity(AgentActivity.intentForFragment(mParentFragment.mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
//				}
//			});
		}

		JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);
		fillupItemView(convertView, all);
		return convertView;
	}

	/**
	 * 配件
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarAdjunctItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_adjunct;
			convertView = LayoutInflater.from(mParentFragment.mActivity).inflate(layout, null);
//			convertView.setOnClickListener(new OnClickListener() {
//
//				@Override
//				public void onClick(View v) {
//					// TODO Auto-generated method stub
//					JSONObject nProductJsonObject = (JSONObject) v.getTag();
//					mParentFragment.startActivity(AgentActivity.intentForFragment(mParentFragment.mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
//				}
//			});
		}

		final JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_adjunct, all.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail"));
		((TextView) convertView.findViewById(R.id.type)).setText(all.optString("spec_info"));

		return convertView;
	}

	/**
	 * 商品赠品
	 * 
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getCarGiftItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_gift;
			convertView = LayoutInflater.from(mParentFragment.mActivity).inflate(layout, null);
//			convertView.setOnClickListener(new OnClickListener() {
//
//				@Override
//				public void onClick(View v) {
//					// TODO Auto-generated method stub
//					JSONObject nProductJsonObject = (JSONObject) v.getTag();
//					mParentFragment.startActivity(AgentActivity.intentForFragment(mParentFragment.mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
//				}
//			});
		}

		JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_gift, responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail"));
		((TextView) convertView.findViewById(R.id.type)).setText(all.optString("spec_info"));

		return convertView;
	}

	private void fillupItemView(View view, final JSONObject all) {
		try {
			((TextView) view.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

			((TextView) view.findViewById(R.id.price)).setText(all.optString("price"));
			// 原价
			TextView oldPriceTV = (TextView) view.findViewById(R.id.market_price);
			oldPriceTV.setText(all.optString("mktprice"));
			oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

			((TextView) view.findViewById(R.id.title)).setText(all.optString("name"));
			// ((TextView)
			// view.findViewById(R.id.title)).setText(all.optString("name"));
			BaseDoFragment.displaySquareImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail"));
			((TextView) view.findViewById(R.id.type)).setText(all.optString("spec_info"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 11;
	}

	@Override
	public int getItemViewType(int position) {
		// TODO Auto-generated method stub
		return getItem(position).optInt(ITEM_TYPE_FIELD);
	}

    /**
     * 获取资源图片，html.fromhtml用
     */
    protected ImageGetter imgResGetter = new ImageGetter() {  
          
        @Override  
        public Drawable getDrawable(String source) {  
            // TODO Auto-generated method stub  
            int id = Integer.parseInt(source);  
            Drawable d = mParentFragment.mActivity.getResources().getDrawable(id);
			if (d == null) return d;
            d.setBounds(0, 0, d.getIntrinsicWidth(), d.getIntrinsicHeight());  
            return d;  
        }  
    };
}
