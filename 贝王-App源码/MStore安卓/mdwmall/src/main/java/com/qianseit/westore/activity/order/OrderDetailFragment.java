package com.qianseit.westore.activity.order;

import android.app.Dialog;
import android.content.ContentValues;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
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
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.member.MemberOrderCancelInterface;
import com.qianseit.westore.httpinterface.member.MemberOrderDeleteInterface;
import com.qianseit.westore.httpinterface.member.MemberOrderReceiptConfirmInterface;
import com.qianseit.westore.httpinterface.member.MemberRebuyInterface;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDetailFragment extends BaseListFragment<JSONObject> {
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

	final String CHECK_STATUS_FIELD = "selected";
	final String ITEM_TYPE_FIELD = "itemtypefield";
	final String ITEM_TITLE = "itemtitle";
	final String ITEM_CONTENT = "itemcontent";
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
	/**
	 * 订单 信息如配送方式、发票信息等
	 */
	final int ITEM_ORDER_INFO = 11;
	/**
	 * 订单 结算信息
	 */
	final int ITEM_ORDER_CHECKOUT = 12;
	/**
	 * 订单 状态（包括订单按钮等操作控制）保存当前订单的listview索引
	 */
	final int ITEM_STATUS = 13;
	/**
	 * 预售订单补尾款时间
	 */
	final int ITEM_PREPARE_PAYFINAL_INFO = 14;

	TextView mOrderNumberTextView, mOrderCaptionTextView, mContacterTextView, mPhoneTextView, mAddressTextView,mMemberBuyerName;

	Dialog mDialog;
	String mOrderId = "";

	LinearLayout.LayoutParams mButtonLayoutParams;
	LinearLayout mBottomBtnsLayout;
	int mGrayColor;
	/**
	 * 是积分兑换的赠品
	 */
	boolean isGiftScore = false;

	JSONObject mOrderJsonObject;

	MemberRebuyInterface mRebuyInterface = new MemberRebuyInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_CAR);
		}
	};
	MemberOrderCancelInterface mCancelInterface = new MemberOrderCancelInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			onRefresh();
		}
	};
	MemberOrderReceiptConfirmInterface mReceiptConfirmInterface = new MemberOrderReceiptConfirmInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			onRefresh();
		}
	};
	MemberOrderDeleteInterface mDeleteInterface = new MemberOrderDeleteInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mActivity.finish();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("订单详情");

		mButtonLayoutParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		mButtonLayoutParams.rightMargin = mActivity.getResources().getDimensionPixelSize(R.dimen.PaddingXMedium);
		mGrayColor = mActivity.getResources().getColor(R.color.westore_gray_textcolor);

		mOrderId = mActivity.getIntent().getStringExtra(Run.EXTRA_ORDER_ID);
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
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
			case ITEM_ORDER_INFO:
				convertView = getOrderInfoView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_ORDER_CHECKOUT:
				convertView = getOrderCheckoutView(nItemJsonObject, convertView, parent);
				break;
			case ITEM_PREPARE_PAYFINAL_INFO:
				convertView = getPreparePayfinalInfoView(responseJson, convertView, parent);
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
		mOrderJsonObject = responseJson.optJSONObject("order");

		assignmentHeader();

		try {
			// 商品
			List<JSONObject> nJsonObjects2 = parseGoodsArray(mOrderJsonObject.optJSONArray("goods_items"));
			nJsonObjects.addAll(nJsonObjects2);

			// 积分兑换的赠品
			JSONObject nJsonObject = mOrderJsonObject.optJSONObject("gift");
			if (nJsonObject != null) {
				JSONArray nGiftScoreArray = nJsonObject.optJSONArray("gift_items");
				if (nGiftScoreArray != null && nGiftScoreArray.length() > 0) {
					if (nJsonObjects2.size() <= 0) {
						isGiftScore = true;
					}

					for (int j = 0; j < nGiftScoreArray.length(); j++) {
						JSONObject nGiftScoreJsonObject = nGiftScoreArray.optJSONObject(j);
						nGiftScoreJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_SCORE);
						nJsonObjects.add(nGiftScoreJsonObject);
					}
				}
			}

			// 订单赠品
			nJsonObject = mOrderJsonObject.optJSONObject("order");
			if (nJsonObject != null) {
				JSONArray nGiftOrderArray = nJsonObject.optJSONArray("gift_items");
				if (nGiftOrderArray != null && nGiftOrderArray.length() > 0) {
					for (int j = 0; j < nGiftOrderArray.length(); j++) {
						JSONObject nGiftOrderJsonObject = nGiftOrderArray.optJSONObject(j);
						nGiftOrderJsonObject.put(ITEM_TYPE_FIELD, ITEM_GIFT_ORDER);
						nJsonObjects.add(nGiftOrderJsonObject);
					}
				}
			}

			addPreparePayfinalInfo(nJsonObjects);

			// 支付方式
			JSONObject nPayInfoJsonObject = mOrderJsonObject.optJSONObject("payinfo");
			if (nPayInfoJsonObject != null) {
				nPayInfoJsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_INFO);
				nPayInfoJsonObject.put(ITEM_TITLE, "支付方式");
				nPayInfoJsonObject.put(ITEM_CONTENT, nPayInfoJsonObject.optString("app_name"));
				nJsonObjects.add(nPayInfoJsonObject);
			}

			// 配送方式
			JSONObject nShippingJsonObject = mOrderJsonObject.optJSONObject("shipping");
			if (nShippingJsonObject != null) {
				nShippingJsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_INFO);
				nShippingJsonObject.put(ITEM_TITLE, "配送方式");
				nShippingJsonObject.put(ITEM_CONTENT, nShippingJsonObject.optString("shipping_name"));
				nJsonObjects.add(nShippingJsonObject);
			}

			// 配送时间
			JSONObject nAddrJsonObject = mOrderJsonObject.optJSONObject("consignee");
			if (nAddrJsonObject != null) {
				String nTime = StringUtils.getString(nAddrJsonObject, "r_time");
				if (!TextUtils.isEmpty(nTime)) {
					JSONObject nJsonObject2 = new JSONObject();
					nJsonObject2.put(ITEM_TYPE_FIELD, ITEM_ORDER_INFO);
					nJsonObject2.put(ITEM_TITLE, "配送时间");
					nJsonObject2.put(ITEM_CONTENT, nTime);
					nJsonObjects.add(nJsonObject2);
				}
			}

			// 发票信息
			if (mOrderJsonObject.optBoolean("is_tax")) {
				JSONObject nTaxJsonObject = new JSONObject();
				nTaxJsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_INFO);
				nTaxJsonObject.put(ITEM_TITLE, "发票信息");
				String mTaxContent = "不开发票";
				String nTaxType = mOrderJsonObject.optString("tax_type");
				if (nTaxType != null && (nTaxType.equals("个人") || nTaxType.equals("公司"))) {
					mTaxContent = String.format("%s，%s，%s", nTaxType, mOrderJsonObject.optString("tax_title"), mOrderJsonObject.optString("tax_content"));
				}
				nTaxJsonObject.put(ITEM_CONTENT, mTaxContent);
				nJsonObjects.add(nTaxJsonObject);
			}

			// 订单备注
			String nRemark = StringUtils.getString(mOrderJsonObject, "memo");
			if (!TextUtils.isEmpty(nRemark)) {
				JSONObject nRemarkJsonObject = new JSONObject();
				nRemarkJsonObject.put(ITEM_TYPE_FIELD, ITEM_ORDER_INFO);
				nRemarkJsonObject.put(ITEM_TITLE, "订单备注");
				nRemarkJsonObject.put(ITEM_CONTENT, nRemark);
				nJsonObjects.add(nRemarkJsonObject);
			}

			// 订单结算信息
			addCheckoutItem(nJsonObjects, "商品金额", mOrderJsonObject.optString("cost_item"));
			addCheckoutItem(nJsonObjects, "商品优惠", mOrderJsonObject.optString("pmt_goods"));
			addCheckoutItem(nJsonObjects, "订单优惠", mOrderJsonObject.optString("pmt_order"));
			addCheckoutItem(nJsonObjects, "积分抵扣金额", mOrderJsonObject.optString("point_dis_price"));
			JSONObject nShipJsonObject = mOrderJsonObject.optJSONObject("shipping");
			if (nShipJsonObject != null) {
				addCheckoutItem(nJsonObjects, "运费", nShipJsonObject.optString("cost_shipping"));
				addCheckoutItem(nJsonObjects, "物流保价费", nShipJsonObject.optString("cost_protect"));
			}
			addCheckoutItem(nJsonObjects, "手续费", mOrderJsonObject.optString("cost_payment"));
			addCheckoutItem(nJsonObjects, "发票税金", mOrderJsonObject.optString("cost_tax"));
			addCheckoutItem(nJsonObjects, "订单总金额", mOrderJsonObject.optString("total_amount_format"));
			addCheckoutItem(nJsonObjects, "订单消费积分", mOrderJsonObject.optString("score_u"));
			addCheckoutItem(nJsonObjects, "订单获得积分", mOrderJsonObject.optString("score_g"));
			addCheckoutItem(nJsonObjects, "预售商品定金", mOrderJsonObject.optString("prepare_total_amount"));
			addCheckoutItem(nJsonObjects, "已支付金额", mOrderJsonObject.optString("payed"));
			addCheckoutItem(nJsonObjects, "货币汇率", mOrderJsonObject.optString("cur_rate"));
			addCheckoutItem(nJsonObjects, "货币结算金额", mOrderJsonObject.optString("cur_amount"));

			// 订单状态：保存当前订单的listview索引
			JSONObject nStatus = new JSONObject();
			nStatus.put(ITEM_TYPE_FIELD, ITEM_STATUS);
			nJsonObjects.add(nStatus);

			assignmentBottomBtns();

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return nJsonObjects;
	}

	void addCheckoutItem(List<JSONObject> jsonObjects, String checkoutName, String checkoutAmount) throws JSONException {
		if (jsonObjects == null || TextUtils.isEmpty(checkoutAmount) || checkoutAmount.equals("0")) {
			return;
		}

		String nValue = "";
		if (checkoutAmount.startsWith("-")) {
			nValue = checkoutAmount.substring(1);
		} else {
			nValue = checkoutAmount.substring(0);
		}
		if (!TextUtils.isEmpty(nValue) && !TextUtils.isDigitsOnly(nValue.substring(0, 1))) {
			nValue = nValue.substring(1);
		}

		try {
			if (Double.parseDouble(nValue) <= 0) {
				return;
			}
		} catch (NumberFormatException e) {
			return;
		}

		JSONObject nCheckoutItem = new JSONObject();
		nCheckoutItem.put(ITEM_TYPE_FIELD, ITEM_ORDER_CHECKOUT);
		nCheckoutItem.put(ITEM_TITLE, checkoutName);
		nCheckoutItem.put(ITEM_CONTENT, checkoutAmount);
		jsonObjects.add(nCheckoutItem);
	}

	void addPreparePayfinalInfo(List<JSONObject> jsonObjects) throws JSONException {
		if (jsonObjects == null)
			return;
		boolean isPrepare = mOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare");
		JSONObject nPrepareJsonObject = mOrderJsonObject.optJSONObject("prepare");
		if (isPrepare && OrderUtils.canPayFinalPayment(mOrderJsonObject) && nPrepareJsonObject != null) {
			long nBeginTime = nPrepareJsonObject.optLong("begin_time_final");
			long nEndTime = nPrepareJsonObject.optLong("end_time_final");
			long nCurTime = new Date().getTime() / 1000;

			String nPrepareRemark = String.format("<font color=#F3273F>请在%s前补完尾款</font>", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", nEndTime));
			if (nCurTime < nBeginTime) {
				nPrepareRemark = String.format("<font color=#F3273F>尾款补款时间将在%s开启</font>", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", nBeginTime));
			} else if (nCurTime > nEndTime) {
				nPrepareRemark = String.format("<font color=#F3273F>尾款补款时间已在%s结束</font>", StringUtils.LongTimeToString("yyyy-MM-dd HH:mm", nEndTime));
			}

			JSONObject nJsonObject = new JSONObject();
			nJsonObject.put(ITEM_TYPE_FIELD, ITEM_PREPARE_PAYFINAL_INFO);
			nJsonObject.put(ITEM_TITLE, "补款时间");
			nJsonObject.put(ITEM_CONTENT, nPrepareRemark);
			jsonObjects.add(nJsonObject);
		}
	}

	List<JSONObject> parseGoodsArray(JSONArray goodsArray) {
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (goodsArray == null || goodsArray.length() <= 0) {
			return nJsonObjects;
		}

		try {
			for (int i = 0; i < goodsArray.length(); i++) {
				JSONObject nGoodsJsonObject = goodsArray.optJSONObject(i);
				nGoodsJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS);
				nJsonObjects.add(nGoodsJsonObject);

				// 商品赠品
				JSONArray nGoodsGiftArray = nGoodsJsonObject.optJSONArray("gift_items");
				if (nGoodsGiftArray != null && nGoodsGiftArray.length() > 0) {
					for (int j = 0; j < nGoodsGiftArray.length(); j++) {
						JSONObject nGoodsGiftJsonObject = nGoodsGiftArray.optJSONObject(j);
						nGoodsGiftJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_GIFT);
						nJsonObjects.add(nGoodsGiftJsonObject);
					}
				}

				// 商品配件
				JSONArray nGoodsAdjunctArray = nGoodsJsonObject.optJSONArray("adjunct_items");
				if (nGoodsAdjunctArray != null && nGoodsAdjunctArray.length() > 0) {
					for (int j = 0; j < nGoodsAdjunctArray.length(); j++) {
						JSONObject nGoodsAdjunctJsonObject = nGoodsAdjunctArray.optJSONObject(j);
						nGoodsAdjunctJsonObject.put(ITEM_TYPE_FIELD, ITEM_GOODS_ADJUNCT);
						nJsonObjects.add(nGoodsAdjunctJsonObject);
					}
				}

				// 商品促销
				JSONArray nGoodsPromotionArray = nGoodsJsonObject.optJSONArray("goods_pmt");
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

	@Override
	protected void addHeader(XPullDownListView listView) {
		// TODO Auto-generated method stub
		listView.setDividerHeight(0);

		View nHeaderView = View.inflate(mActivity, R.layout.header_order_detail, null);
		listView.addHeaderView(nHeaderView);

		mOrderNumberTextView = (TextView) nHeaderView.findViewById(R.id.bill_number);
		mOrderCaptionTextView = (TextView) nHeaderView.findViewById(R.id.bill_caption);
		mContacterTextView = (TextView) nHeaderView.findViewById(R.id.contacter);
		mPhoneTextView = (TextView) nHeaderView.findViewById(R.id.phone);
		mAddressTextView = (TextView) nHeaderView.findViewById(R.id.address);
		mMemberBuyerName = (TextView) nHeaderView.findViewById(R.id.order_detail_select_member_name);
	}

	@Override
	protected void initBottom(LinearLayout bottomLayout) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.footer_order_detail, null);
		mBottomBtnsLayout = (LinearLayout) nView.findViewById(R.id.buttons);
		bottomLayout.addView(nView);
	}

	void assignmentHeader() {
		mOrderNumberTextView.setText(mOrderJsonObject.optString("order_id"));

		String nCaption = "";
		if (!mOrderJsonObject.isNull("caption")) {
			nCaption = StringUtils.getString(mOrderJsonObject.optJSONObject("caption"), "msg");
		}
		if (TextUtils.isEmpty(nCaption)) {
			findViewById(R.id.bill_caption_ll).setVisibility(View.GONE);
		} else {
			findViewById(R.id.bill_caption_ll).setVisibility(View.VISIBLE);
			mOrderCaptionTextView.setText(nCaption);
		}

		JSONObject nJsonObject = mOrderJsonObject.optJSONObject("consignee");
		String nString = StringUtils.getString(nJsonObject, "mobile");
		if (TextUtils.isEmpty(nString)) {
			nString = StringUtils.getString(nJsonObject, "telephone");
		}

		mContacterTextView.setText(nJsonObject.optString("name"));
		mMemberBuyerName.setText("下单会员：" + mOrderJsonObject.optString("name"));
		mPhoneTextView.setText(nString);
		mAddressTextView.setText(nJsonObject.optString("addr"));
	}

	/**
	 * 订单信息 如支付方式、配送方式等
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getOrderInfoView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_info, null);
		}
		((TextView) convertView.findViewById(R.id.order_info_title)).setText(responseJson.optString(ITEM_TITLE));
		((TextView) convertView.findViewById(R.id.order_info_content)).setText(responseJson.optString(ITEM_CONTENT));
		return convertView;
	}

	/**
	 * 补尾款时间
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getPreparePayfinalInfoView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_info, null);
		}
		((TextView) convertView.findViewById(R.id.order_info_title)).setText(responseJson.optString(ITEM_TITLE));
		((TextView) convertView.findViewById(R.id.order_info_content)).setText(Html.fromHtml(responseJson.optString(ITEM_CONTENT)));
		return convertView;
	}

	/**
	 * 订单信息 如支付方式、配送方式等
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getOrderCheckoutView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_checkout, null);
		}
		((TextView) convertView.findViewById(R.id.order_checkout_name)).setText(responseJson.optString(ITEM_TITLE));
		((TextView) convertView.findViewById(R.id.order_checkout_value)).setText(responseJson.optString(ITEM_CONTENT));
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
	private View getStatusView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_order_detail_subtotal, null);
		}

		boolean isPrepare = mOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare");
		JSONObject nPrepareJsonObject = mOrderJsonObject.optJSONObject("prepare");
		if (isPrepare && OrderUtils.canPayFinalPayment(mOrderJsonObject) && nPrepareJsonObject != null) {
			convertView.findViewById(R.id.subtotal).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.subtotal_divider).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.prepare_remark).setVisibility(View.GONE);
			convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.GONE);
			long nBeginTime = nPrepareJsonObject.optLong("begin_time_final");
			long nEndTime = nPrepareJsonObject.optLong("end_time_final");
			long nCurTime = new Date().getTime() / 1000;

			String nSubTotal = String.format("共%s件，已付定金<font color=#F3273F>%s</font>，待付尾款<font color=#F3273F>%s</font>", mOrderJsonObject.optString("itemnum"),
					nPrepareJsonObject.optString("preparesell_price"), nPrepareJsonObject.optString("final_price"));
			if (nCurTime >= nEndTime) {
				nSubTotal = String.format("共%s件，合计<font color=#F3273F>%s</font>", mOrderJsonObject.optString("itemnum"), mOrderJsonObject.optString("cur_amount"));
			}

			((TextView) convertView.findViewById(R.id.subtotal)).setText(Html.fromHtml(nSubTotal));
		} else {
			convertView.findViewById(R.id.prepare_remark).setVisibility(View.GONE);
			convertView.findViewById(R.id.prepare_remark_divider).setVisibility(View.GONE);
			convertView.findViewById(R.id.subtotal).setVisibility(View.GONE);
			convertView.findViewById(R.id.subtotal_divider).setVisibility(View.GONE);
		}
		((TextView) convertView.findViewById(R.id.order_detail_total_price)).setText(mOrderJsonObject.optString("total_amount_format"));
		String payTime = mOrderJsonObject.optString("pay_time");

		Run.log(payTime);

		if (payTime.isEmpty()){

			((TextView) convertView.findViewById(R.id.order_detail_time)).setText("下单时间：" + StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", mOrderJsonObject.optLong("createtime")));
		}
		else {

			String string = String.format("下单时间: %s\n\n支付时间: %s",StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", mOrderJsonObject.optLong("createtime")),StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", mOrderJsonObject.optLong("pay_time")));

			((TextView) convertView.findViewById(R.id.order_detail_time)).setText(string);
		}

		return convertView;
	}

	/**
	 * @return 底部菜单按钮动态创建
	 */
	private void assignmentBottomBtns() {
		mBottomBtnsLayout.removeAllViews();

		boolean isPrepare = mOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare");
		if (mOrderJsonObject.optBoolean("cancel_order")) {
			TextView nCancelTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nCancelTextView.setText("取消订单");
			nCancelTextView.setTextColor(mGrayColor);
			nCancelTextView.setBackgroundResource(R.drawable.shape_stroke_round5_gray);
			mBottomBtnsLayout.addView(nCancelTextView, mButtonLayoutParams);
			nCancelTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定取消这个订单吗？", "取消", "确定", null, new OnClickListener() {

						@Override
						public void onClick(View v) {
							// TODO Auto-generated method stub
							mDialog.dismiss();
							mCancelInterface.cancel(mOrderJsonObject.optString("order_id"));
						}
					}, false, null);

				}
			});
		}

		if (mOrderJsonObject.optBoolean("delete_order")) {
			TextView nDeleteTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nDeleteTextView.setText("删除订单");
			nDeleteTextView.setTextColor(mGrayColor);
			nDeleteTextView.setBackgroundResource(R.drawable.shape_stroke_round5_gray);
			mBottomBtnsLayout.addView(nDeleteTextView, mButtonLayoutParams);
			nDeleteTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除这个订单吗？", "取消", "确定", null, new OnClickListener() {

						@Override
						public void onClick(View v) {
							// TODO Auto-generated method stub
							mDialog.dismiss();
							mDeleteInterface.delete(mOrderJsonObject.optString("order_id"));
						}
					}, false, null);
				}
			});
		}

		if (!mOrderJsonObject.optBoolean("cancel_order") && !isPrepare && !isGiftScore) {// 预售商品
			// 和
			// 积分兑换赠品不能再次购买
			TextView nRebuyTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nRebuyTextView.setText("再次购买");
			mBottomBtnsLayout.addView(nRebuyTextView, mButtonLayoutParams);
			nRebuyTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mRebuyInterface.rebuy(mOrderId);
				}
			});
		}

		if (mOrderJsonObject.optBoolean("is_aftersales")) {
			TextView nAfterSalesTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nAfterSalesTextView.setText("申请售后");
			mBottomBtnsLayout.addView(nAfterSalesTextView, mButtonLayoutParams);
			nAfterSalesTextView.setTag(mOrderJsonObject);
			nAfterSalesTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub

				}
			});
		}
		if (OrderUtils.canLookLogistics(mOrderJsonObject)) {
			TextView nLogsitics = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nLogsitics.setText("查看物流");
			mBottomBtnsLayout.addView(nLogsitics, mButtonLayoutParams);
			nLogsitics.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONArray nArray = mOrderJsonObject.optJSONArray("logistic");
					if (nArray == null || nArray.length() <= 0) {
						Run.alert(mActivity, "该订单尚未发货");
						return;
					}
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_DELIVERY_ID, nArray.optJSONObject(0).optString("delivery_id"));
					startActivity(AgentActivity.FRAGMENT_SHOPP_LOGISTICS, nBundle);
				}
			});
		}
		String nPayString = mOrderJsonObject.optString("pay_btn");
		if (!TextUtils.isEmpty(nPayString) && !nPayString.equalsIgnoreCase("null")) {
			TextView nPayTextView = (TextView) View.inflate(mActivity, R.layout.item_order_status_btn, null);
			nPayTextView.setText(nPayString);
			nPayTextView.setTag(R.id.tag_spec_id, mOrderJsonObject.optInt("pay_btn_code"));
			nPayTextView.setTag(mOrderJsonObject);
			nPayTextView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					int nAction = (Integer) v.getTag(R.id.tag_spec_id);
					switch (nAction) {
						case ACTION_PAY:
							startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_PAYMETHOD).putExtra(Run.EXTRA_ORDER_ID, mOrderJsonObject.optString("order_id")),
									REQUEST_CODE_ORDER_PAY);
							break;
						case ACTION_WAIT_PAY_RESULT:
						case ACTION_PAY_PAYMENT_DUE:

							break;
						case ACTION_RECEIPT_CONFIRM:
							mReceiptConfirmInterface.receiptConfirm(mOrderJsonObject.optString("order_id"));
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
			mBottomBtnsLayout.addView(nPayTextView, mButtonLayoutParams);
		}

		mBottomBtnsLayout.setVisibility(mBottomBtnsLayout.getChildCount() > 0 ? View.VISIBLE : View.GONE);
	}

	/**
	 * 商品促销
	 *
	 * @param responseJson
	 * @param convertView
	 * @param parent
	 * @return
	 */
	private View getGoodsPromotionView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_car_promotion, null);
		}
		convertView.findViewById(R.id.divider_top).setVisibility(responseJson.optBoolean(ITEM_TYPE_FIRST_FIELD, false) ? View.VISIBLE : View.GONE);
		convertView.findViewById(R.id.divider_bottom).setVisibility(responseJson.optBoolean(ITEM_TYPE_END_FIELD, false) ? View.VISIBLE : View.GONE);
		String nContent = String.format("<font color=#F3273F>[%s]</font>  %s", responseJson.optString("pmt_tag"), responseJson.optString("pmt_memo"));
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
	private View getTitleView(JSONObject responseJson, View convertView, ViewGroup parent) {
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
	private View getSpaceView(JSONObject responseJson, View convertView, ViewGroup parent) {
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
	private View getDiscountMoreView(JSONObject responseJson, View convertView, ViewGroup parent) {
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
	private View getGoodsItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.findViewById(R.id.itemview).setOnClickListener(this);
			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		convertView.findViewById(R.id.itemview).setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);
		if (all == null)
			return convertView;

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
	private View getGoodsAdjunctItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_adjunct;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.findViewById(R.id.itemview).setOnClickListener(this);
			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		final JSONObject all = responseJson;
		convertView.findViewById(R.id.itemview).setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);
		if (all == null)
			return convertView;

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_adjunct, all.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		TextView nTypeTextView = (TextView) convertView.findViewById(R.id.type);
		nTypeTextView.setSingleLine(false);
		nTypeTextView.setText(all.optString("attr"));

		if (all.optInt("is_comment") == 0) {
			((TextView) convertView.findViewById(R.id.goods_comment)).setText("晒单评价");
			convertView.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_comment).setVisibility(View.GONE);
		}

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
			convertView.findViewById(R.id.itemview).setOnClickListener(this);
			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		convertView.findViewById(R.id.itemview).setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);
		if (all == null)
			return convertView;

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("point") + "积分");
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
		((TextView) convertView.findViewById(R.id.title)).setText(all.optString("name"));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		TextView nTypeTextView = (TextView) convertView.findViewById(R.id.type);
		nTypeTextView.setSingleLine(false);
		nTypeTextView.setText(all.optString("attr"));

		if (all.optInt("is_comment") == 0) {
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
	private View getGoodsGiftItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			int layout = R.layout.item_shopp_confirm_order_gift;
			convertView = LayoutInflater.from(mActivity).inflate(layout, null);
			convertView.findViewById(R.id.itemview).setOnClickListener(this);
			convertView.findViewById(R.id.goods_comment).setOnClickListener(mCommentClickListener);
		}

		JSONObject all = responseJson;
		convertView.findViewById(R.id.itemview).setTag(all);
		convertView.findViewById(R.id.goods_comment).setTag(all);
		if (all == null)
			return convertView;

		((TextView) convertView.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));
		((TextView) convertView.findViewById(R.id.price)).setText(all.optString("price"));
		// 原价
		TextView oldPriceTV = (TextView) convertView.findViewById(R.id.market_price);
		oldPriceTV.setText(all.optString("mktprice"));
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_gift, responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
		BaseDoFragment.displaySquareImage((ImageView) convertView.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
		TextView nTypeTextView = (TextView) convertView.findViewById(R.id.type);
		nTypeTextView.setSingleLine(false);
		nTypeTextView.setText(all.optString("attr"));

		if (all.optInt("is_comment") == 0) {
			((TextView) convertView.findViewById(R.id.goods_comment)).setText("晒单评价");
			convertView.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.goods_comment).setVisibility(View.GONE);
		}

		return convertView;
	}

	OnClickListener mCommentClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			JSONObject nJsonObject = (JSONObject) v.getTag();
			if (nJsonObject.optInt("is_comment") == 0) {// 去评价
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_ORDER_ID, mOrderId);
				nBundle.putString(Run.EXTRA_DATA, nJsonObject.toString());
				startActivityForResult(AgentActivity.FRAGMENT_SHOPP_GOODS_COMMENT_PUBLISH, nBundle, REQUEST_CODE_ORDER_RATING);
			}
		}
	};

	private void fillupItemView(View view, final JSONObject all) {
		try {
			((TextView) view.findViewById(R.id.qty)).setText("x" + all.optString("quantity"));

			((TextView) view.findViewById(R.id.price)).setText(all.optString("price"));
			// 原价
			TextView oldPriceTV = (TextView) view.findViewById(R.id.market_price);
			oldPriceTV.setText(all.optString("mktprice"));
			oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

			((TextView) view.findViewById(R.id.title)).setText(all.optString("name"));
			BaseDoFragment.displaySquareImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
			TextView nTypeTextView = (TextView) view.findViewById(R.id.type);
			nTypeTextView.setSingleLine(false);
			nTypeTextView.setText(all.optString("attr"));

			if (mOrderJsonObject.optString("promotion_type").equalsIgnoreCase("prepare")) {
				String nName = String.format("<img src='%d'/> %s", R.drawable.goods_type_prepare, all.optString("name"));
				((TextView) view.findViewById(R.id.title)).setText(Html.fromHtml(nName, imgResGetter, null));
			} else {
				((TextView) view.findViewById(R.id.title)).setText(all.optString("name"));
			}

			if (all.optInt("is_comment") == 0) {
				((TextView) view.findViewById(R.id.goods_comment)).setText("晒单评价");
				view.findViewById(R.id.goods_comment).setVisibility(View.VISIBLE);
			} else {
				view.findViewById(R.id.goods_comment).setVisibility(View.GONE);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 15;
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
		nContentValues.put("order_id", mOrderId);
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.orderdetail";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
			case R.id.itemview:
				JSONObject nProductJsonObject = (JSONObject) v.getTag();
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, nProductJsonObject.optString("product_id")));
				break;

			default:
				break;
		}
	}
}