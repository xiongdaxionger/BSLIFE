package com.qianseit.westore.activity.order;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.util.SparseArray;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.order.OrderListFragment.CancelReasonDialog.CancelReasonSelectedListener;
import com.qianseit.westore.base.BaseDialog;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.member.MemberOrderCancelInterface;
import com.qianseit.westore.httpinterface.member.MemberOrderCancelReasonInterface;
import com.qianseit.westore.httpinterface.member.MemberOrderDeleteInterface;
import com.qianseit.westore.httpinterface.member.MemberOrderReceiptConfirmInterface;
import com.qianseit.westore.httpinterface.member.MemberRebuyInterface;
import com.qianseit.westore.ui.wheelview.WheelAdapter;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;

public class OrderListFragment extends BaseListFragment<JSONObject> {
	protected final int REQUEST_CODE_ORDER_DETAIL = 0x1001;
	protected final int REQUEST_CODE_ORDER_RATING = 0x1002;
	protected final int REQUEST_CODE_ORDER_PAY = 0x1003;

	/**
	 * 去支付
	 */
	protected final int ACTION_PAY = 1;
	/**
	 * 支付结果返回中
	 */
	protected final int ACTION_WAIT_PAY_RESULT = 2;
	/**
	 * 支付尾款已过时
	 */
	protected final int ACTION_PAY_PAYMENT_DUE = 0;
	/**
	 * 确认收货
	 */
	protected final int ACTION_RECEIPT_CONFIRM = 3;
	/**
	 * 确认收货（部分发货不能确认收货）
	 */
	protected final int ACTION_RECEIPT_CONFIRM_PART = 4;
	/**
	 * 评论
	 */
	protected final int ACTION_COMMENT = 5;
	/**
	 * 取消订单
	 */
	protected final int ACTION_CANCEL = 6;
	/**
	 * 删除订单
	 */
	protected final int ACTION_DELETE = 7;
	/**
	 * 申请售后
	 */
	protected final int ACTION_AFTERSALES = 8;
	/**
	 * 查看物流
	 */
	protected final int ACTION_LOGISTICS = 9;

	protected final String CHECK_STATUS_FIELD = "selected";
	protected final String ITEM_TYPE_FIELD = "itemtypefield";
	protected final String ITEM_TYPE_FIRST_FIELD = "itemtypefirstfield";
	protected final String ITEM_TYPE_END_FIELD = "itemtypeendfield";
	protected final String ITEM_PARENT_INDEX = "itemparentindex";
	/**
	 * 只针对标题项有效，如享受更多优惠
	 */
	protected final String ITEM_TITLE_FIELD = "itemtitlefield";

	/**
	 * 商品
	 */
	protected final int ITEM_GOODS = 0;
	/**
	 * 商品赠品
	 */
	protected final int ITEM_GOODS_GIFT = 1;
	/**
	 * 商品配件
	 */
	protected final int ITEM_GOODS_ADJUNCT = 2;
	/**
	 * 商品促销
	 */
	protected final int ITEM_GOODS_PROMOTION = 3;
	/**
	 * 享受更多优惠
	 */
	protected final int ITEM_DISCOUNT_MORE = 4;
	/**
	 * 享受更多优惠
	 */
	protected final int ITEM_DISCOUNT_MORE_PROMOTION = 5;
	/**
	 * 积分兑换的赠品
	 */
	protected final int ITEM_GIFT_SCORE = 6;
	/**
	 * 已享受优惠 订单赠品
	 */
	protected final int ITEM_GIFT_ORDER = 7;
	/**
	 * 已享受优惠 订单促销
	 */
	protected final int ITEM_ORDER_PROMOTION = 8;
	/**
	 * 粗分割线（模块分割）
	 */
	protected final int ITEM_SPACE = 9;
	/**
	 * 已享受优惠
	 */
	protected final int ITEM_DISCOUNT = 10;
	/**
	 * 订单 标题
	 */
	protected final int ITEM_ORDER = 11;
	/**
	 * 订单 状态（包括订单按钮等操作控制）保存当前订单的listview索引
	 */
	protected final int ITEM_STATUS = 12;

	protected SparseArray<List<JSONObject>> mResultGroupMap = new SparseArray<List<JSONObject>>();
	protected JSONObject mCurOrderJsonObject;
	protected Dialog mDialog;

	protected LinearLayout.LayoutParams mButtonLayoutParams;
	protected int mGrayColor;
	CancelReasonDialog mCancelReasonDialog;

	/**是否为佣金订单
	 */
	public boolean isCommisionOrder = false;

	MemberRebuyInterface mRebuyInterface = new MemberRebuyInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_CAR);
		}
	};
	protected MemberOrderCancelInterface mCancelInterface = new MemberOrderCancelInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			onRefresh();
			Run.alert(mActivity, "取消订单成功");
		}
	};
	protected MemberOrderReceiptConfirmInterface mReceiptConfirmInterface = new MemberOrderReceiptConfirmInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			onRefresh();
			Run.alert(mActivity, "确认收货成功");
		}
	};
	protected MemberOrderDeleteInterface mDeleteInterface = new MemberOrderDeleteInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			removeOrder(mCurOrderJsonObject);
			mCurOrderJsonObject = null;
		}
	};

	/**
	 * all:全部订单,nopayed:待支付,prepare:预售订单,noship:待发货,noreceived:待收获,nodiscuss:待评价
	 */
	protected String mOrderType = "all";
	String mEmptyText = "暂无订单";

	/**
	 * @param orderType
	 *            all:全部订单,nopayed:待支付,prepare:预售订单,noship:待发货,noreceived:待收获,
	 *            nodiscuss:待评价
	 */
	public final static String ORDER_TYPE = "$ordertype";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);

		mButtonLayoutParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		mButtonLayoutParams.rightMargin = mActivity.getResources().getDimensionPixelSize(R.dimen.PaddingXMedium);
		mGrayColor = mActivity.getResources().getColor(R.color.westore_gray_textcolor);

		mOrderType = getArguments().getString(ORDER_TYPE);
		isCommisionOrder = getArguments().getBoolean(OrderFragment.ORDER_COMMISION_TYPE);
		if (mOrderType == null) return;
		if (mOrderType.equals("nopayed")){
			mEmptyText = "暂无待支付订单";
		}else if (mOrderType.equals("prepare")){
			mEmptyText = "暂预售订单";
		}else if (mOrderType.equals("noship")){
			mEmptyText = "暂无待发货订单";
		}else if (mOrderType.equals("noreceived")){
			mEmptyText = "暂无待收货订单";
		}else if (mOrderType.equals("nodiscuss")){
			mEmptyText = "暂无待评价订单";
		}
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		new MemberOrderCancelReasonInterface(this) {

			@Override
			public void responseReason(JSONArray reasonArray) {
				// TODO Auto-generated method stub
				mCancelReasonDialog = new CancelReasonDialog(mActivity, reasonArray);
				mCancelReasonDialog.setReasonSelectedListener(new CancelReasonSelectedListener() {

					@Override
					public void selected(JSONObject reasonJsonObject) {
						// TODO Auto-generated method stub
						mCancelInterface.cancel(mCurOrderJsonObject.optString("order_id"), reasonJsonObject.optInt("value"), reasonJsonObject.optString("name"));
					}
				});
			}
		}.RunRequest();
		setEmptyText(mEmptyText);
	}

	@Override
	public View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		JSONObject nItemJsonObject = responseJson;
		switch (getItemViewType(responseJson)) {
			case ITEM_GOODS:
				convertView = getGoodsItemView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_GOODS_GIFT:
				convertView = getGoodsGiftItemView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_GOODS_ADJUNCT:
				convertView = getGoodsAdjunctItemView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_GOODS_PROMOTION:
				convertView = getGoodsPromotionView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_DISCOUNT_MORE_PROMOTION:
				convertView = getDiscountMoreView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_GIFT_SCORE:
				convertView = getGiftScoreItemView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_GIFT_ORDER:
				convertView = getGoodsGiftItemView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_ORDER_PROMOTION:
				convertView = getDiscountMoreView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_SPACE:
				convertView = getSpaceView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_DISCOUNT_MORE:
			case ITEM_DISCOUNT:
				convertView = getTitleView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_STATUS:
				convertView = getStatusView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_ORDER:
				convertView = getOrderView(nItemJsonObject, convertView, parent);
				break;

			default:
				break;
		}

		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (mPageNum == 1) {
			mResultGroupMap.clear();
		}

		try {
			// 商品
			JSONArray nOrdersArray = responseJson.optJSONArray("orders");
			if (nOrdersArray != null && nOrdersArray.length() > 0) {
				for (int i = 0; i < nOrdersArray.length(); i++) {
					JSONObject nOrderJsonObject = nOrdersArray.optJSONObject(i);
					nOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER);
					List<JSONObject> nGroupItemList = new ArrayList<JSONObject>();
					mResultGroupMap.put(nOrderJsonObject.hashCode(), nGroupItemList);

					if (mPageNum > 1 || nJsonObjects.size() > 0) {
						JSONObject nSpaceJsonObject = new JSONObject();
						nSpaceJsonObject.put(ITEM_TYPE_FIELD, ITEM_SPACE);
						nJsonObjects.add(nSpaceJsonObject);
						nGroupItemList.add(nSpaceJsonObject);
					}
					nJsonObjects.add(nOrderJsonObject);
					nGroupItemList.add(nOrderJsonObject);

					List<JSONObject> nJsonObjects2 = parseGoodsArray(nOrderJsonObject.optJSONArray("goods_items"), nOrderJsonObject.hashCode());
					nGroupItemList.addAll(nJsonObjects2);
					nJsonObjects.addAll(nJsonObjects2);

					// 积分兑换的赠品
					JSONObject nJsonObject = nOrderJsonObject.optJSONObject("gift");
					if (nJsonObject != null) {
						JSONArray nGiftScoreArray = nJsonObject.optJSONArray("gift_items");
						if (nGiftScoreArray != null && nGiftScoreArray.length() > 0) {
							for (int j = 0; j < nGiftScoreArray.length(); j++) {
								JSONObject nGiftScoreJsonObject = nGiftScoreArray.optJSONObject(j);
								nGiftScoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE);
								nGroupItemList.add(nGiftScoreJsonObject);
								nJsonObjects.add(nGiftScoreJsonObject);
							}
						}
					}

					// 订单赠品
					nJsonObject = nOrderJsonObject.optJSONObject("order");
					if (nJsonObject != null) {
						JSONArray nGiftOrderArray = nJsonObject.optJSONArray("gift_items");
						if (nGiftOrderArray != null && nGiftOrderArray.length() > 0) {
							for (int j = 0; j < nGiftOrderArray.length(); j++) {
								JSONObject nGiftOrderJsonObject = nGiftOrderArray.optJSONObject(j);
								nGiftOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_ORDER);
								nJsonObjects.add(nGiftOrderJsonObject);
								nGroupItemList.add(nGiftOrderJsonObject);
							}
						}
					}

					// 订单状态：保存当前订单的listview索引
					JSONObject nStatus = new JSONObject();
					nStatus.put(ITEM_TYPE_FIELD, ITEM_STATUS);
					nStatus.put(ITEM_PARENT_INDEX, nOrderJsonObject.hashCode());
					nJsonObjects.add(nStatus);
					nGroupItemList.add(nStatus);
				}
			}

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return nJsonObjects;
	}

	protected void removeOrder(JSONObject orderJsonObject) {
		int nKey = orderJsonObject.hashCode();
		List<JSONObject> nJsonObjects = mResultGroupMap.get(nKey);
		if (nJsonObjects == null) {
			return;
		}

		mResultGroupMap.remove(nKey);
		mResultLists.removeAll(nJsonObjects);
		mAdapter.notifyDataSetChanged();
	}

	protected JSONObject getParentOrder(int key) {
		JSONObject nJsonObject = null;
		List<JSONObject> nJsonObjects = mResultGroupMap.get(key);
		if (nJsonObjects == null || nJsonObjects.size() <= 0) {
			return nJsonObject;
		}

		for (JSONObject jsonObject : nJsonObjects) {
			if (jsonObject.optInt(ITEM_TYPE_FIELD) == ITEM_ORDER) {
				nJsonObject = jsonObject;
				break;
			}
		}

		return nJsonObject;
	}

	/**
	 * 是积分兑换赠品订单
	 *
	 * @param key
	 * @return
	 */
	protected boolean isGiftScore(int key) {
		List<JSONObject> nJsonObjects = mResultGroupMap.get(key);
		if (nJsonObjects == null || nJsonObjects.size() <= 0) {
			return false;
		}

		boolean nIsGiftScore = false;

		for (JSONObject jsonObject : nJsonObjects) {
			int nType = jsonObject.optInt(ITEM_TYPE_FIELD);
			if (nType == ITEM_GOODS) {
				return false;
			} else if (nType == ITEM_GIFT_SCORE) {
				nIsGiftScore = true;
			}
		}

		return nIsGiftScore;
	}

	protected List<JSONObject> parseGoodsArray(JSONArray goodsArray, int parentId) {
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (goodsArray == null || goodsArray.length() <= 0) {
			return nJsonObjects;
		}

		try {
			for (int i = 0; i < goodsArray.length(); i++) {
				JSONObject nGoodsJsonObject = goodsArray.optJSONObject(i);
				nGoodsJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
				nGoodsJsonObject.put(ITEM_PARENT_INDEX, parentId);
				nJsonObjects.add(nGoodsJsonObject);

				// 商品赠品
				JSONArray nGoodsGiftArray = nGoodsJsonObject.optJSONArray("gift_items");
				if (nGoodsGiftArray != null && nGoodsGiftArray.length() > 0) {
					for (int j = 0; j < nGoodsGiftArray.length(); j++) {
						JSONObject nGoodsGiftJsonObject = nGoodsGiftArray.optJSONObject(j);
						nGoodsGiftJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_GIFT);
						nGoodsGiftJsonObject.put(ITEM_PARENT_INDEX, parentId);
						nJsonObjects.add(nGoodsGiftJsonObject);
					}
				}

				// 商品配件
				JSONArray nGoodsAdjunctArray = nGoodsJsonObject.optJSONArray("adjunct_items");
				if (nGoodsAdjunctArray != null && nGoodsAdjunctArray.length() > 0) {
					for (int j = 0; j < nGoodsAdjunctArray.length(); j++) {
						JSONObject nGoodsAdjunctJsonObject = nGoodsAdjunctArray.optJSONObject(j);
						nGoodsAdjunctJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_ADJUNCT);
						nGoodsAdjunctJsonObject.put(ITEM_PARENT_INDEX, parentId);
						nJsonObjects.add(nGoodsAdjunctJsonObject);
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
						nJsonObjects.add(nGoodsPromotionJsonObject);
					}
				}
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return nJsonObjects;
	}

	/**
	 * 订单标题
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getOrderView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_title, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					final JSONObject nOrderJsonObject = (JSONObject) v.getTag();
					startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDERS_DETAIL).putExtra(Run.EXTRA_ORDER_ID, nOrderJsonObject.optString("order_id")),
							REQUEST_CODE_ORDER_DETAIL);
				}
			});
		}
		convertView.setTag(responseJson);
		((TextView) convertView.findViewById(R.id.status)).setText(OrderUtils.getOrderStatus(responseJson));
		((TextView) convertView.findViewById(R.id.bill_number)).setText(responseJson.optString("order_id"));
		return convertView;
	}

	/**
	 * 订单状态栏
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	protected View getStatusView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_status, null);
		}
		JSONObject nOrderJsonObject = getParentOrder(responseJson.optInt(ITEM_PARENT_INDEX));

		boolean isPrepare = nOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare");
		boolean isGiftScore = isGiftScore(responseJson.optInt(ITEM_PARENT_INDEX));
		JSONObject nPrepareJsonObject = nOrderJsonObject.optJSONObject("prepare");
		if (isPrepare && OrderUtils.canPayFinalPayment(nOrderJsonObject) && nPrepareJsonObject != null) {
			convertView.findViewById(R.id.prepare_remark).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.VISIBLE);
			long nBeginTime = nPrepareJsonObject.optLong("begin_time_final");
			long nEndTime = nPrepareJsonObject.optLong("end_time_final");
			long nCurTime = new Date().getTime() / 1000;

			String nSubTotal = String.format("共%s件，已付定金<font color=#F3273F>%s</font>，待付尾款<font color=#F3273F>%s</font>", nOrderJsonObject.optString("itemnum"),
					nPrepareJsonObject.optString("preparesell_price"), nPrepareJsonObject.optString("final_price"));
			String nPrepareRemark = String.format("<font color=#F3273F>请在%s前补完尾款</font>", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", nEndTime));
			if (nCurTime < nBeginTime) {
				nPrepareRemark = String.format("<font color=#F3273F>尾款补款时间将在%s开启</font>", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", nBeginTime));
			}
			if (nCurTime >= nEndTime) {
				convertView.findViewById(R.id.prepare_remark).setVisibility(View.GONE);
				convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.GONE);
				nSubTotal = String.format("共%s件，合计<font color=#F3273F>%s</font>", nOrderJsonObject.optString("itemnum"), nOrderJsonObject.optString("cur_amount"));
			}
			((TextView) convertView.findViewById(R.id.prepare_remark)).setText(Html.fromHtml(nPrepareRemark));

			((TextView) convertView.findViewById(R.id.subtotal)).setText(Html.fromHtml(nSubTotal));
		} else {
			convertView.findViewById(R.id.prepare_remark).setVisibility(View.GONE);
			convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.GONE);
			String nSubTotal = String.format("共%s件，合计<font color=#F3273F>%s</font>", nOrderJsonObject.optString("itemnum"), nOrderJsonObject.optString("cur_amount"));
			if (isGiftScore) {
				nSubTotal = String.format("共%s件，兑换消费积分<font color=#F3273F>%s</font>", nOrderJsonObject.optString("itemnum"), nOrderJsonObject.optString("score_u"));
			}
			((TextView) convertView.findViewById(R.id.subtotal)).setText(Html.fromHtml(nSubTotal));
		}

		LinearLayout nBtnsLayout = (LinearLayout) convertView.findViewById(R.id.buttons);
		nBtnsLayout.removeAllViews();

		if (nOrderJsonObject.optBoolean("cancel_order")) {// true:可取消订单不可再次购买，，否则不可取消订单可再次购买
			TextView nCancelTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nCancelTextView.setText("取消订单");
			nCancelTextView.setTextColor(mGrayColor);
			nCancelTextView.setBackgroundResource(R.drawable.shape_stroke_round5_gray);
			nBtnsLayout.addView(nCancelTextView, mButtonLayoutParams);
			nCancelTextView.setTag(nOrderJsonObject);
			nCancelTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurOrderJsonObject = (JSONObject) v.getTag();
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定取消这个订单吗？", "取消", "确定", null, new OnClickListener() {

						@Override
						public void onClick(View v) {
							// TODO Auto-generated method stub
							mDialog.dismiss();
							if (mCancelReasonDialog != null) {
								mCancelReasonDialog.show();
								return;
							}
							mCancelInterface.cancel(mCurOrderJsonObject.optString("order_id"));
						}
					}, false, null);

				}
			});
		}

		if (nOrderJsonObject.optBoolean("delete_order")) {
			TextView nDeleteTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nDeleteTextView.setText("删除订单");
			nDeleteTextView.setTextColor(mGrayColor);
			nDeleteTextView.setBackgroundResource(R.drawable.shape_stroke_round5_gray);
			nBtnsLayout.addView(nDeleteTextView, mButtonLayoutParams);
			nDeleteTextView.setTag(nOrderJsonObject);
			nDeleteTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurOrderJsonObject = (JSONObject) v.getTag();
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除这个订单吗？", "取消", "确定", null, new OnClickListener() {

						@Override
						public void onClick(View v) {
							// TODO Auto-generated method stub
							mDialog.dismiss();
							mDeleteInterface.delete(mCurOrderJsonObject.optString("order_id"));
						}
					}, false, null);
				}
			});
		}

		if (!nOrderJsonObject.optBoolean("cancel_order") && !isPrepare && !isGiftScore(responseJson.optInt(ITEM_PARENT_INDEX))) {// 预售商品
			// 和积分兑换赠品不能再次购买
			TextView nRebuyTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nRebuyTextView.setText("再次购买");
			nBtnsLayout.addView(nRebuyTextView, mButtonLayoutParams);
			nRebuyTextView.setTag(nOrderJsonObject);
			nRebuyTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurOrderJsonObject = (JSONObject) v.getTag();
					mRebuyInterface.rebuy(mCurOrderJsonObject.optString("order_id"));
				}
			});
		}

		// if (nOrderJsonObject.optBoolean("is_aftersales")) {
		// TextView nAfterSalesTextView = (TextView) View.inflate(mActivity,
		// R.layout.item_order_status_btn, null);
		// nAfterSalesTextView.setText("申请售后");
		// nBtnsLayout.addView(nAfterSalesTextView, mButtonLayoutParams);
		// nAfterSalesTextView.setTag(nOrderJsonObject);
		// nAfterSalesTextView.setOnClickListener(new OnClickListener() {
		//
		// @Override
		// public void onClick(View v) {
		// // TODO Auto-generated method stub
		//
		// }
		// });
		// }
		if (OrderUtils.canLookLogistics(nOrderJsonObject)) {
			TextView nLogsitics = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nLogsitics.setText("查看物流");
			nBtnsLayout.addView(nLogsitics, mButtonLayoutParams);
			nLogsitics.setTag(nOrderJsonObject);
			nLogsitics.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurOrderJsonObject = (JSONObject) v.getTag();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_ORDER_ID, mCurOrderJsonObject.optString("order_id"));
					startActivity(AgentActivity.FRAGMENT_SHOPP_LOGISTICS, nBundle);
				}
			});
		}
		String nPayString = nOrderJsonObject.optString("pay_btn");
		if (!TextUtils.isEmpty(nPayString) && nOrderJsonObject.optInt("pay_btn_code", 0) != 5) {
			TextView nPayTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nPayTextView.setText(nPayString);
			int nActionCode = nOrderJsonObject.optInt("pay_btn_code");
			nPayTextView.setTag(R.id.tag_spec_id, nActionCode);
			nPayTextView.setTag(nOrderJsonObject);
			if (nActionCode == ACTION_WAIT_PAY_RESULT || nActionCode == ACTION_PAY_PAYMENT_DUE || nActionCode == ACTION_RECEIPT_CONFIRM_PART || nActionCode == ACTION_COMMENT) {
				nPayTextView.setBackground(null);
			} else {
				nPayTextView.setBackground(getResources().getDrawable(R.drawable.shape_order_action));
			}
			nPayTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurOrderJsonObject = (JSONObject) v.getTag();
					int nAction = (Integer) v.getTag(R.id.tag_spec_id);
					switch (nAction) {
						case ACTION_PAY:
							startActivityForResult(
									AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_PAYMETHOD).putExtra(Run.EXTRA_ORDER_ID, mCurOrderJsonObject.optString("order_id")),
									REQUEST_CODE_ORDER_PAY);
							break;
						case ACTION_WAIT_PAY_RESULT:
						case ACTION_PAY_PAYMENT_DUE:

							break;
						case ACTION_RECEIPT_CONFIRM:
							mReceiptConfirmInterface.receiptConfirm(mCurOrderJsonObject.optString("order_id"));
							break;
						case ACTION_RECEIPT_CONFIRM_PART:

							break;
						case ACTION_COMMENT:

							break;

						default:
							break;
					}
				}
			});
			nBtnsLayout.addView(nPayTextView, mButtonLayoutParams);
		}

		if (nBtnsLayout.getChildCount() <= 0) {
			((View) nBtnsLayout.getParent()).setVisibility(View.GONE);
		} else {
			((View) nBtnsLayout.getParent()).setVisibility(View.VISIBLE);
		}

		return convertView;
	}

	/**
	 * 商品促销
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	protected View getGoodsPromotionView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_car_promotion, null);
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
	protected View getTitleView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_car_title, null);
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
	protected View getSpaceView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_car_space, null);
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
	protected View getDiscountMoreView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_car_discount_promotion, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					if (!nJsonObject.optBoolean("fororder_status", false)) {
						return;
					}

					// 进入凑单界面
					startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_TOGETHER);
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
	protected View getGoodsItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nProductJsonObject = (JSONObject) v.getTag();
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
				}
			});

			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);
		fillupItemView(convertView, all);
		return convertView;
	}

	/**
	 * 积分兑换的赠品
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	protected View getGiftScoreItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nProductJsonObject = (JSONObject) v.getTag();
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
				}
			});

			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.findViewById(R.id.goods_comment).setTag(all);
		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("point") + "积分");
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
		((TextView) convertView.findViewById(R.id.title)).setText(all.optString("name"));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		((TextView) convertView.findViewById(R.id.type)).setText(all.optString("attr"));

		convertView.setTag(all);
		if (all.optInt("is_comment", 1) == 0) {
			((TextView) convertView.findViewById(R.id.goods_comment)).setText("晒单评价");
			convertView.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_comment).setVisibility(View.GONE);
		}
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
	protected View getGoodsAdjunctItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_adjunct;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nProductJsonObject = (JSONObject) v.getTag();
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
				}
			});

			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		final JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_adjunct, all.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));//
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		((TextView) convertView.findViewById(R.id.type)).setText(all.optString("attr"));

		if (all.optInt("is_comment", 1) == 0) {
			((TextView) convertView.findViewById(R.id.goods_comment)).setText("晒单评价");
			convertView.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_comment).setVisibility(View.GONE);
		}
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
	protected View getGoodsGiftItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_gift;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nProductJsonObject = (JSONObject) v.getTag();
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
				}
			});

			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		if (all == null)
			return convertView;

		convertView.setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_gift, responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		((TextView) convertView.findViewById(R.id.type)).setText(all.optString("attr"));

		if (all.optInt("is_comment", 1) == 0) {
			((TextView) convertView.findViewById(R.id.goods_comment)).setText("晒单评价");
			convertView.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_comment).setVisibility(View.GONE);
		}
		return convertView;
	}

	protected void fillupItemView(View view, final JSONObject all) {
		try {
			((TextView) view.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

			((TextView) view.findViewById(R.id.price)).setText(all.optString("price"));
			// 原价
			TextView oldPriceTV = (TextView) view.findViewById(R.id.market_price);
			oldPriceTV.setText(all.optString("mktprice"));
			oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

			JSONObject nOrderJsonObject = getParentOrder(all.optInt(ITEM_PARENT_INDEX));

			if (nOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare")) {
				String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_prepare, all.optString("name"));
				((TextView) view.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
			} else {
				((TextView) view.findViewById(R.id.title)).setText(all.optString("name"));
			}

			BaseDoFragment.displaySquareImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
			((TextView) view.findViewById(R.id.type)).setText(all.optString("attr"));

			if (all.optInt("is_comment", 1) == 0) {
				((TextView) view.findViewById(R.id.goods_comment)).setText("晒单评价");
				view.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
			} else {
				view.findViewById(R.id.goods_comment).setVisibility(View.GONE);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	OnClickListener mCommentClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			JSONObject nJsonObject = (JSONObject) v.getTag();
			JSONObject nOrderJsonObject = getParentOrder(nJsonObject.optInt(ITEM_PARENT_INDEX));
			if (nJsonObject.optInt("is_comment") == 0) {// 去评价
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_ORDER_ID, nOrderJsonObject.optString("order_id"));
				nBundle.putString(Run.EXTRA_DATA, nJsonObject.toString());
				startActivityForResult(AgentActivity.FRAGMENT_SHOPP_GOODS_COMMENT_PUBLISH, nBundle, REQUEST_CODE_ORDER_RATING);
			}
		}
	};

	@Override
	public int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 13;
	}

	@Override
	public int getItemViewType(JSONObject itemJsonObject) {
		// TODO Auto-generated method stub
		return itemJsonObject.optInt(ITEM_TYPE_FIELD);
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_status", mOrderType);
		nContentValues.put("is_fx",isCommisionOrder ? "true" : "false");
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.orders";
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		switch (requestCode) {
			case REQUEST_CODE_ORDER_RATING:
			case REQUEST_CODE_ORDER_PAY:
				onRefresh();
				break;

			default:
				super.onActivityResult(requestCode, resultCode, data);
				break;
		}
	}

	public static class CancelReasonDialog extends com.qianseit.westore.base.BaseDialog {

		WheelView mReasonLoopView;
		JSONArray mReasonArray;

		CancelReasonSelectedListener mSelectedListener;

		public void setReasonSelectedListener(CancelReasonSelectedListener timeSelectedListener) {
			mSelectedListener = timeSelectedListener;
		}

		public CancelReasonDialog(Context context, JSONArray reasonArray) {
			super(context);
			// TODO Auto-generated constructor stub
			mContext = context;
			mWindow = getWindow();
			mWindow.setBackgroundDrawableResource(backgroundRes());
			mReasonArray = reasonArray;
			this.setContentView(init());
			this.setCanceledOnTouchOutside(true);
			parseCanselReason();
		}

		@Override
		protected int backgroundRes() {
			return R.color.transparent;
		}

		@Override
		protected View init() {
			LinearLayout view = null;
			try {
				view = (LinearLayout) LayoutInflater.from(mContext).inflate(R.layout.dialog_order_cancel_reason, null);

				view.findViewById(R.id.cancel).setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dismiss();
					}
				});
				view.findViewById(R.id.finish).setOnClickListener(new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						returnSelectedReason();
						dismiss();
					}
				});

				mReasonLoopView = (WheelView) view.findViewById(R.id.reason);
			} catch (Exception e) {
				// TODO: handle exception
				Log.w(Run.TAG, e.getMessage());
			}
			return view;
		}

		public void returnSelectedReason() {
			if (mSelectedListener != null) {
				mSelectedListener.selected(mReasonArray.optJSONObject(mReasonLoopView.getCurrentItem()));
			}
		}

		@Override
		protected float widthScale() {
			return 1;
		}

		@Override
		protected int gravity() {
			// TODO Auto-generated method stub
			return Gravity.BOTTOM;
		}

		void parseCanselReason() {
			if (mReasonArray == null || mReasonArray.length() <= 0) {
				return;
			}

			String[] nTypeStrings = new String[mReasonArray.length()];
			for (int i = 0; i < mReasonArray.length(); i++) {
				nTypeStrings[i] = mReasonArray.optJSONObject(i).optString("name");
			}

			mReasonLoopView.setViewAdapter(new ArrayWheelAdapter<String>(mContext, nTypeStrings));
			mReasonLoopView.setCurrentItem(0);
		}

		public interface CancelReasonSelectedListener {
			/**
			 * @param reasonJsonObject
			 *            { "value": 1, "name": "支付不成功" }
			 */
			void selected(JSONObject reasonJsonObject);
		}
	}
}