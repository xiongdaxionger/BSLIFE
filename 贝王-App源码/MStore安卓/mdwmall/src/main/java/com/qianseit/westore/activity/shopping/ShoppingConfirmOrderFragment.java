package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AbsListView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alipay.client.AliPayFragment;
import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.order.OrderFragment;
import com.qianseit.westore.activity.order.OrderSegementFragment;
import com.qianseit.westore.activity.partner.PartnerDetailFragment;
import com.qianseit.westore.activity.partner.PartnerInfo;
import com.qianseit.westore.activity.partner.PartnerListFragment;
import com.qianseit.westore.activity.shopping.ShoppShippingTimeDialog.ShippingTimeSelectedListener;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.base.UPPayInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarGetShippingsInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarTotalInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarUseAddrInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarUseScoreInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppCarUseShippingInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppOrderCreateInterface;
import com.qianseit.westore.httpinterface.shopping.ShoppPayIndexInterface;
import com.qianseit.westore.util.StringUtils;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 *
 * 确认订单
 *
 */
public class ShoppingConfirmOrderFragment extends AliPayFragment {
	private final int REQUEST_ADDRESS = 0x1000;
	private final int REQUEST_EXPRESS = 0x1001;
	private final int REQUEST_INVOICE = 0x1002;
	private final int REQUEST_COUPON = 0x1003;
	private final int REQUEST_IDCARD = 0x1005;
	private final int REQUEST_MGETSTORE = 0X1006;
	private final int REQUEST_MGETSTORETIME = 0X1007;
	private final int REQUEST_SELECTMEMBER = 0X1008;

	JSONObject mCheckOutJsonObject;

	/**
	 * 订单详情
	 */
	private JSONObject mOrderDetail;
	/**
	 * 优惠券里列表，当前使用的优惠券
	 */
	private JSONArray mCouponLists;
	private ArrayList<JSONObject> mOrderGoods = new ArrayList<JSONObject>();
	private JSONObject aCart = null;
	/**
	 * 积分抵扣配置
	 */
	private JSONObject payJifen = null;

	/**
	 * 发票配置，当前发票
	 */
	private JSONObject mInvoiceInfo = null, mInvoiceSetting;

	/**
	 * 配送方式列表
	 */
	private JSONArray mShippingArray, mGoodsInentArray;
	/**
	 * 默认配送方式（当前配送方式）， 配送时间设置
	 */
	private JSONObject mDefShippingJsonObject, mShippingTimeJsonObject;
	String mShippingDay = "", mShippingTime = "";
	/**
	 * 会员地址列表
	 */
	private JSONArray mAddressArray;
	/**
	 * 默认收货地址（当前收货地址）
	 */
	private JSONObject defAddress;
	/**个人下单的收货地址
	 */
	private JSONObject personAddress;
	/**选择会员的收货地址
	 */
	private JSONObject memberAddress;
	/**
	 * 支付方式列表
	 */
	private JSONArray mPaymentArray;
	/**
	 * 默认支付方式（当前支付方式）
	 */
	private JSONObject mDefPayment;

	private String isFastBuy = "false";

	private ListView mListView;
	private View mAddressView;
	private RelativeLayout mAddressViewLayout;
	/**选择会员名字视图
	 */
	private TextView mSelectMemberView;
	/**是否开启的代客下单
	 */
	private boolean isSelectMember = false;
	/**选择会员视图
	 */
	private RelativeLayout mSelectMemberLayout;
	/**选中的会员名称--默认为nil
	 */
	private String mSelectMemberName = "";
	/**选中的会员ID
	 */
	private String mSelectMemberID = "";
	private View mBView;
	LinearLayout mCheckoutItemsView;
	private EditText mRemarkEditText;

	private boolean mTriggerTax;// 是否显示开发票功能

	private boolean mPaymentStatus = false;
	private boolean isUseScore;
	private int useScore;

	private String oldCoupunNum;
	private boolean isSelectedIDCard = true;
	boolean isProtacted;

	/**
	 * 货币
	 */
	String mCurrency = "";

	ExpressPopupWindow mExpressPopupWindow;
	ShoppShippingTimeDialog mShippingTimeDialog;

	ShoppCarUseScoreInterface mCarUseScoreInterface = new ShoppCarUseScoreInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mCarTotalInterface.RunRequest();
		}
	};
	ShoppCarTotalInterface mCarTotalInterface = new ShoppCarTotalInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mOrderDetail = responseJson.optJSONObject("order_detail");
			fillupPriceLayout(mOrderDetail);
		}

		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			// 收货地址
			defAddress = isSelectMember ? memberAddress : personAddress;
			if (defAddress != null) {
				nContentValues.put("address", defAddress.optString("value"));
			}

			if (!TextUtils.isEmpty(isFastBuy)) {
				nContentValues.put("isfastbuy", isFastBuy);
			}

			if (mGoodsInentArray != null && mGoodsInentArray.length() > 0) {
				for (int i = 0; i < mGoodsInentArray.length(); i++) {
					nContentValues.put(String.format("obj_ident[%d]", i), mGoodsInentArray.optString(i));
				}
			}

			// 支付方式
			if (mDefPayment != null && !TextUtils.isEmpty(mDefPayment.toString()))
				nContentValues.put("payment[pay_app_id]", mDefPayment.optString("value"));

			// 配送方式
			if (mDefShippingJsonObject != null) {
				nContentValues.put("shipping", mDefShippingJsonObject.optString("value"));
				nContentValues.put("is_protect", isProtacted ? "1" : "0");
			}
			nContentValues.put("payment[currency]", mCurrency);

			nContentValues.put("point[score]", isUseScore ? payJifen.optString("max_discount_value_point") : "0");

			if (mInvoiceInfo != null) {// 发票
				nContentValues.put("payment[is_tax]", "true");
				nContentValues.put("payment[tax_type]", mInvoiceInfo.optString("type"));
				nContentValues.put("payment[tax_company]", mInvoiceInfo.optString("dt_name"));
				nContentValues.put("payment[tax_content]", mInvoiceInfo.optString("content"));
			}
			return nContentValues;
		}
	};
	ShoppOrderCreateInterface mOrderCreateInterface = new ShoppOrderCreateInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			final String nOrderId = responseJson.optString("order_id");
			new ShoppPayIndexInterface(ShoppingConfirmOrderFragment.this) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_PAYMETHOD).putExtra(Run.EXTRA_ORDER_ID, nOrderId)
							.putExtra(Run.EXTRA_DATA, responseJson.toString()).putExtra(Run.EXTRA_VALUE, true).putExtra(OrderFragment.ORDER_COMMISION_TYPE,isSelectMember));

					mActivity.finish();
				}

				@Override
				public void isPaied() {
					long nStartOrdersType = OrderFragment.WAIT_SHIPPING;
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS).putExtra(Run.EXTRA_DETAIL_TYPE, nStartOrdersType).putExtra(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,isSelectMember ? R.id.segement_right : R.id.segement_left));
					mActivity.finish();
				}
			}.getPayIndex(nOrderId);
		}

		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			// 收货地址
			defAddress = isSelectMember ? memberAddress : personAddress;
			if (defAddress != null) {
				nContentValues.put("address", defAddress.optString("value"));
			}

			if (!TextUtils.isEmpty(isFastBuy)) {
				nContentValues.put("isfastbuy", isFastBuy);
			}

			if (mGoodsInentArray != null && mGoodsInentArray.length() > 0) {
				for (int i = 0; i < mGoodsInentArray.length(); i++) {
					nContentValues.put(String.format("obj_ident[%d]", i), mGoodsInentArray.optString(i));
				}
			}
			nContentValues.put("member_id",isSelectMember ? mSelectMemberID : LoginedUser.getInstance().getMember().getMember_id());
			// 支付方式
			if (mDefPayment != null && !TextUtils.isEmpty(mDefPayment.toString()))
				nContentValues.put("payment[pay_app_id]", mDefPayment.optString("value"));

			// 配送方式
			if (mDefShippingJsonObject != null) {
				nContentValues.put("shipping", mDefShippingJsonObject.optString("value"));
				nContentValues.put("is_protect", isProtacted ? "1" : "0");
			}
			nContentValues.put("payment[currency]", mCurrency);

			nContentValues.put("point[score]", isUseScore ? payJifen.optString("max_discount_value_point") : "0");

			nContentValues.put("md5_cart_info", mCheckOutJsonObject.optString("md5_cart_info"));

			if (mInvoiceInfo != null) {// 发票
				nContentValues.put("payment[is_tax]", "true");
				nContentValues.put("payment[tax_type]", mInvoiceInfo.optString("type"));
				nContentValues.put("payment[tax_company]", mInvoiceInfo.optString("dt_name"));
				nContentValues.put("payment[tax_content]", mInvoiceInfo.optString("content"));
			}

			if (!TextUtils.isEmpty(mRemarkEditText.getText().toString())) {
				nContentValues.put("memo", mRemarkEditText.getText().toString());
			}

			//客户端来源
			nContentValues.put("source","android");

			// 配送时间
			if (!TextUtils.isEmpty(mShippingDay)) {
				nContentValues.put("shipping_time[day]", mShippingDay);
				nContentValues.put(mShippingDay.equals("special") ? "shipping_time[special]" : "shipping_time[time]", mShippingTime);
			}
			return nContentValues;
		}
	};
	ShoppCarUseAddrInterface mCarUseAddrInterface = new ShoppCarUseAddrInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub

		}
	};

	ShoppCarGetShippingsInterface mCarGetShippingsInterface = new ShoppCarGetShippingsInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mShippingArray = responseJson.optJSONArray("shippings");
			mExpressPopupWindow.setExpressData(mShippingArray, mDefShippingJsonObject, isProtacted);
			mExpressPopupWindow.showAtLocation(rootView, Gravity.BOTTOM, 0, 0);
		}
	};
	ShoppCarUseShippingInterface mUseShippingInterface = new ShoppCarUseShippingInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mDefPayment = responseJson.optJSONObject("payment");
			mCurrency = responseJson.optString("current_currency");
			mCarTotalInterface.RunRequest();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.confirm_order_title);

		try {
			mCheckOutJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
			mGoodsInentArray = mCheckOutJsonObject.optJSONArray("obj_ident");

			mOrderDetail = mCheckOutJsonObject.optJSONObject("order_detail");

			isFastBuy = mCheckOutJsonObject.optBoolean("is_fastbuy") ? "true" : "";

			aCart = mCheckOutJsonObject.optJSONObject("aCart");
			JSONObject nJsonObject = aCart.optJSONObject("object");
			if (nJsonObject != null) {
				mCouponLists = nJsonObject.optJSONArray("coupon");
			}

			payJifen = mCheckOutJsonObject.optJSONObject("point_dis");

			mInvoiceSetting = mCheckOutJsonObject.optJSONObject("tax_setting");
			mTriggerTax = mInvoiceSetting != null && mInvoiceSetting.has("tax_type");

			personAddress = mCheckOutJsonObject.optJSONObject("def_addr");
			mAddressArray = mCheckOutJsonObject.optJSONArray("member_addr_list");

			mPaymentArray = mCheckOutJsonObject.optJSONArray("payments");
			mDefPayment = mCheckOutJsonObject.optJSONObject("arr_def_payment");
			if (mDefPayment == null && mPaymentArray != null && mPaymentArray.length() > 0) {
				mDefPayment = mPaymentArray.optJSONObject(0);
			}
			mCurrency = mCheckOutJsonObject.optString("current_currency");

			mShippingArray = mCheckOutJsonObject.optJSONArray("shippings");
			mDefShippingJsonObject = mCheckOutJsonObject.optJSONObject("shipping_method");
			defShippingAmend();
			mShippingTimeJsonObject = mCheckOutJsonObject.optJSONObject("shipping_time");
			mShippingTimeDialog = new ShoppShippingTimeDialog(mActivity, mShippingTimeJsonObject);
			mShippingTimeDialog.setTimeSelectedListener(new ShippingTimeSelectedListener() {

				@Override
				public void selected(String typeValue, String date) {
					// TODO Auto-generated method stub
					mShippingDay = typeValue;
					mShippingTime = date;
					((TextView) mBView.findViewById(R.id.confirm_order_shipping_time)).setText(typeValue.equals("special") ? date : typeValue + date);
				}
			});

		} catch (Exception e) {
			mActivity.finish();
		}
	}

	/**
	 * 默认配送方式修正 因为接口返回的默认配送方式和配送方式列表的结构不一致，修正使其一致
	 */
	void defShippingAmend() {
		if (mShippingArray != null && mShippingArray.length() > 0 && mDefShippingJsonObject != null) {
			int nDefShippingId = mDefShippingJsonObject.optInt("shipping_id");
			if (nDefShippingId <= 0) {
				return;
			}

			for (int i = 0; i < mShippingArray.length(); i++) {
				JSONObject nJsonObject = mShippingArray.optJSONObject(i);
				if (nJsonObject.optInt("dt_id") == nDefShippingId) {
					mDefShippingJsonObject = nJsonObject;
					break;
				}
			}
		}
	}

	@Override
	public void init(android.view.LayoutInflater inflater, android.view.ViewGroup container, android.os.Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		if (mActivity instanceof DoActivity) {
			((DoActivity) mActivity).setUPPayCallBack(new UPPayInterface() {

				@Override
				public void UPPayCallback(Intent data) {
					// TODO Auto-generated method stub
					dealUPResult(data);
				}
			});
		}

		rootView = inflater.inflate(R.layout.fragment_confirm_order, null);
		findViewById(R.id.confirm_order_checkout).setOnClickListener(this);
		findViewById(R.id.confirm_order_pay_state_ok).setOnClickListener(this);
		mListView = (ListView) findViewById(android.R.id.list);

		mAddressView = findViewById(R.id.confirm_order_address);
		mAddressViewLayout = (RelativeLayout) mAddressView.findViewById(R.id.confirm_order_address_layout);
		mAddressViewLayout.setOnClickListener(this);
		mSelectMemberView = (TextView) mAddressView.findViewById(R.id.confirm_order_select_member_name);
		mSelectMemberView.setOnClickListener(this);
		mSelectMemberLayout = (RelativeLayout) mAddressView.findViewById(R.id.confirm_order_select_member);
		mSelectMemberLayout.setVisibility(View.GONE);
		mAddressView.findViewById(R.id.confirm_order_idcard_tip_name).setOnClickListener(this);
		mBView = inflater.inflate(R.layout.confirm_order_bottomview, null);
		mCheckoutItemsView = (LinearLayout) mBView.findViewById(R.id.confirm_order_goods_checkout_items);
		mRemarkEditText = (EditText) mBView.findViewById(R.id.confirm_order_remark_et);
		Run.removeFromSuperView(mAddressView);

		Run.removeFromSuperView(mBView);

		mAddressView.setLayoutParams(new AbsListView.LayoutParams(mAddressView.getLayoutParams()));
		mListView.addHeaderView(mAddressView);
		if (!mTriggerTax) {// 后台控制是否显示开发票功能
			mBView.findViewById(R.id.confirm_order_invoice).setVisibility(View.GONE);
		} else {
			mBView.findViewById(R.id.confirm_order_invoice).setVisibility(View.VISIBLE);
		}

		mListView.addFooterView(mBView);
//		mAddressView.setOnClickListener(this);
		mBView.findViewById(R.id.confirm_order_ticket).setOnClickListener(this);
		mBView.findViewById(R.id.confirm_order_invoice).setOnClickListener(this);
		mBView.findViewById(R.id.confirm_order_distribution_layout).setOnClickListener(this);
		mBView.findViewById(R.id.confirm_order_takeself_ll).setOnClickListener(this);
		mBView.findViewById(R.id.confirm_order_shipping_time_ll).setOnClickListener(this);
		findViewById(R.id.confirm_order_checkout).setOnClickListener(this);

		updateScoreDiscount();
		((CheckBox) mBView.findViewById(R.id.confirm_order_payyingbang_checkbox)).setOnCheckedChangeListener(changeListener);
		((CheckBox) mAddressView.findViewById(R.id.confirm_order_customer_checkbox)).setOnCheckedChangeListener(customerListener);
		// 配送时间
		mBView.findViewById(R.id.confirm_order_shipping_time_ll).setVisibility(mShippingTimeJsonObject == null ? View.GONE : View.VISIBLE);

		updateAddressInfo(personAddress);

		if (mCouponLists != null && mCouponLists.length() > 0) {
			((TextView) mBView.findViewById(R.id.confirm_order_status)).setText(mCouponLists.optJSONObject(0).optString("name"));
			oldCoupunNum = mCouponLists.optJSONObject(0).optString("coupon");
		}

		ShoppConfirmOrderAdapter nAdapter = new ShoppConfirmOrderAdapter(aCart, this);
		mListView.setAdapter(nAdapter);
		nAdapter.notifyDataSetChanged();

		mBView.findViewById(R.id.confirm_order_ticket).setVisibility(
				!mCheckOutJsonObject.optString("promotion_type", "").equalsIgnoreCase("prepare") && nAdapter.canUseCoupon() ? View.VISIBLE : View.GONE);

		((TextView) mBView.findViewById(R.id.confirm_order_invoice_title)).setText(R.string.confirm_order_invoice);
		if (mDefShippingJsonObject != null) {
			updateExpressInfo();
		}
		if (personAddress != null) {
			mCarTotalInterface.RunRequest();
		} else {
			fillupPriceLayout(mOrderDetail);
		}

		mExpressPopupWindow = new ExpressPopupWindow(mActivity) {

			@Override
			public void onItemSelected(JSONObject selectedBean, boolean isProtacted) {
				// TODO Auto-generated method stub
				mDefShippingJsonObject = selectedBean;
				ShoppingConfirmOrderFragment.this.isProtacted = isProtacted;
				defAddress = isSelectMember ? memberAddress : personAddress;
				if (defAddress == null || mDefShippingJsonObject == null) {

				} else {
//					if (mDefShippingJsonObject.optString("dt_name").contains("自提")) {
//						startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_SPECIFIC_STORE).putExtra(Run.EXTRA_VALUE, ""), REQUEST_MGETSTORE);
//					} else {
						updateExpressInfo();
						mUseShippingInterface.useShipping(mDefShippingJsonObject.optString("value"));
//					}
				}
			}
		};

		if (mShippingTimeJsonObject != null) {
			mShippingTimeDialog.returnSelectedTime();
		}
	}

	private OnCheckedChangeListener changeListener = new OnCheckedChangeListener() {
		@Override
		public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
			if (isChecked) {
				isUseScore = true;
				// if (!checkCanPayment()) {
				// buttonView.setChecked(false);
				// return;
				// }
				mCarUseScoreInterface.useScore((float) payJifen.optDouble("discount_rate"), payJifen.optInt("max_discount_value_point"));
			} else {
				isUseScore = false;
				mCarTotalInterface.RunRequest();
			}

		}
	};

	/**代客下单开关事件
	 */
	private OnCheckedChangeListener customerListener = new OnCheckedChangeListener() {
		@Override
		public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
			isSelectMember = isChecked;
			mSelectMemberLayout.setVisibility(isSelectMember ? View.VISIBLE : View.GONE);
			mSelectMemberView.setText(mSelectMemberName.isEmpty() ? "请选择下单会员" : mSelectMemberName);
			defAddress = isSelectMember ? memberAddress : personAddress;
			mDefShippingJsonObject = null;
			updateExpressInfo();
			updateAddressInfo(defAddress);
			mCarTotalInterface.RunRequest();
		}
	};

	private String idcardId = null;

	void updateScoreDiscount() {
		// 积分抵扣
		if (payJifen != null && payJifen.optInt("max_discount_value_point") > 0) {
			mBView.findViewById(R.id.confirm_order_dikou_rl).setVisibility(View.VISIBLE);
			((TextView) mBView.findViewById(R.id.confirm_order_dikou_tip)).setText(Run.buildString("可用积分", payJifen.optDouble("max_discount_value_point"), "，可抵扣",
					payJifen.optString("max_discount_value_money"), "元"));
		} else {
			mBView.findViewById(R.id.confirm_order_dikou_rl).setVisibility(View.GONE);
		}
	}

	// 更新收货人信息
	private void updateAddressInfo(JSONObject jsonObject) {
		boolean isChanged = false;
		defAddress = isSelectMember ? memberAddress : personAddress;
		if (defAddress != null) {
			if (!jsonObject.keys().hasNext()) {
				isChanged = true;
				defAddress = jsonObject;
			} else if (!Run.parseAddressId(defAddress).equals(Run.parseAddressId(jsonObject))) {
				isChanged = true;
				defAddress = jsonObject;
			} else {
				defAddress = jsonObject;
			}
		} else {
			defAddress = jsonObject;
		}
		if (isSelectMember){
			memberAddress = jsonObject;
		}
		else {
			personAddress = jsonObject;
		}

		boolean isEmpty = (defAddress == null || !defAddress.keys().hasNext());
		// 没有收货人隐藏
		mAddressView.findViewById(R.id.my_address_book_item_name).setVisibility(isEmpty ? View.INVISIBLE : View.VISIBLE);
		mAddressView.findViewById(R.id.my_address_book_item_phone).setVisibility(isEmpty ? View.INVISIBLE : View.VISIBLE);
		mAddressView.findViewById(R.id.my_address_book_item_address).setVisibility(isEmpty ? View.INVISIBLE : View.VISIBLE);
		// 没有收货人显示
		mAddressView.findViewById(R.id.my_address_book_item_emptyview).setVisibility(isEmpty ? View.VISIBLE : View.INVISIBLE);
		mAddressView.findViewById(R.id.my_address_book_item_arrow).setVisibility(View.VISIBLE);

		if (!isEmpty) {
			String nString = StringUtils.getString(defAddress, "mobile");
			if (TextUtils.isEmpty(nString)) {
				nString = StringUtils.getString(defAddress, "tel");
			}

			((TextView) mAddressView.findViewById(R.id.my_address_book_item_address)).setText(Run.buildString(StringUtils.FormatArea(defAddress.optString("area")), defAddress.optString("addr")));
			((TextView) mAddressView.findViewById(R.id.my_address_book_item_phone)).setText(nString);
			((TextView) mAddressView.findViewById(R.id.my_address_book_item_name)).setText(defAddress.optString("name"));
		}

		if (isChanged && mDefShippingJsonObject != null) {
			Run.alert(mActivity, "您已经更换了收货地址，需要重新选择配送方式");
			mDefShippingJsonObject = null;
			updateExpressInfo();

			mCarTotalInterface.RunRequest();
		}
	}

	// 更新快递信息
	private void updateExpressInfo() {
		if (mDefShippingJsonObject != null) {
			String nString = mDefShippingJsonObject.optString("dt_name");
			if (isProtacted) {
				nString = nString + "[保价]";
			}
			((TextView) mBView.findViewById(R.id.confirm_order_distribution_status)).setText(nString);
			if (mDefShippingJsonObject.optString("dt_name").contains("自提")) {
				mBView.findViewById(R.id.confirm_order_takeself_ll).setVisibility(View.VISIBLE);
			} else {
				mBView.findViewById(R.id.confirm_order_takeself_ll).setVisibility(View.GONE);
			}

		} else {
			((TextView) mBView.findViewById(R.id.confirm_order_distribution_status)).setText("请选择配送方式");
			mBView.findViewById(R.id.confirm_order_takeself_ll).setVisibility(View.GONE);
		}

	}

	@Override
	public void onClick(View v) {
		if (v == mAddressViewLayout) {
			if (isSelectMember && TextUtils.isEmpty(mSelectMemberID)){
				Run.alert(mActivity,"请先选择代客下单会员");
				return;
			}
			String def = "";
			defAddress = isSelectMember ? memberAddress : personAddress;
			if (defAddress != null) {
				def = defAddress.toString();
			}
			// 地址
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_BOOK).putExtra(Run.EXTRA_VALUE, true).putExtra("old_address", def).putExtra("member_id",mSelectMemberID), REQUEST_ADDRESS);
		} else if (v.getId() == R.id.confirm_order_invoice) {

			final String invoiceStr = (mInvoiceInfo != null) ? mInvoiceInfo.toString() : null;
			startActivityForResult(
					AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDER_INVOICE).putExtra(Run.EXTRA_DATA, invoiceStr)
							.putExtra(Run.EXTRA_DETAIL_TYPE, mInvoiceSetting.toString()), REQUEST_INVOICE);
		} else if (v.getId() == R.id.confirm_order_ticket) {
			// 优惠券
			Bundle bundle = new Bundle();
			if (mCouponLists != null && mCouponLists.length() > 0) {
				bundle.putString(Run.EXTRA_COUPON_DATA, mCouponLists.optJSONObject(0).toString());
			}
			bundle.putString(Run.EXTRA_DATA, isFastBuy);
			bundle.putBoolean(Run.EXTRA_VALUE, true);
			Intent intent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_COUPON);
			intent.putExtras(bundle);
			startActivityForResult(intent, REQUEST_COUPON);
		} else if (v.getId() == R.id.confirm_order_distribution_layout) {
			// 配送方式
			defAddress = isSelectMember ? memberAddress : personAddress;
			if (defAddress == null || TextUtils.isEmpty(Run.parseAddressId(defAddress))) {
				Run.alert(mActivity, "请先选择收货地址");
				return;
			}

			String area = Run.parseAddressId(defAddress);

			// 用户自选快递
			mCarGetShippingsInterface.getShippings(area, !TextUtils.isEmpty(isFastBuy));
		} else if (v.getId() == R.id.confirm_order_shipping_time_ll) {
			mShippingTimeDialog.show();
		} else if (v.getId() == R.id.confirm_order_checkout) {
			if (checkCanPayment()) {
				// 跳支付方式画面
				JSONObject nCreateOrderParams = buildCreateOrderParams();
				if (nCreateOrderParams == null) {
					return;
				}

				mOrderCreateInterface.RunRequest();
			}
		} else if (v.getId() == R.id.confirm_order_takeself_ll) {
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_STORE_TIME), REQUEST_MGETSTORETIME);
		}
		else if (v == mSelectMemberView) {
			startActivityForResult(AgentActivity.intentForFragment(mActivity,AgentActivity.FRAGMENT_PARTNR_LIST).putExtra(PartnerListFragment.SELECT_PARTNER_KEY,true),REQUEST_SELECTMEMBER);
		}
		else {
			super.onClick(v);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode != Activity.RESULT_OK) {
			if (requestCode == REQUEST_MGETSTORE) {
				mDefShippingJsonObject = null;
			}
			return;
		}

		try {
			if (requestCode == REQUEST_ADDRESS) {
				String jsonstr = data.getStringExtra(Run.EXTRA_DATA);
				updateAddressInfo(new JSONObject(jsonstr));
			} else if (requestCode == REQUEST_EXPRESS) {
				String dataStr = data.getStringExtra(Run.EXTRA_DATA);
				mDefShippingJsonObject = new JSONObject(dataStr);
				defAddress = isSelectMember ? memberAddress : personAddress;
				if (defAddress == null || mDefShippingJsonObject == null) {

				} else {
					updateExpressInfo();
					mUseShippingInterface.useShipping(mDefShippingJsonObject.optString("value"));
				}
			} else if (requestCode == REQUEST_INVOICE) {
				String jsonstr = data.getStringExtra(Run.EXTRA_DATA);
				try {
					mInvoiceInfo = new JSONObject(jsonstr);
					((TextView) mBView.findViewById(R.id.confirm_order_invoice_message)).setText(Run.buildString(mInvoiceInfo.optString("type_name"), " ", mInvoiceInfo.optString("dt_name"), " ",
							mInvoiceInfo.optString("detail")));
				} catch (Exception e) {
					mInvoiceInfo = null;
					((TextView) mBView.findViewById(R.id.confirm_order_invoice_message)).setText(R.string.invoice_type_null);
				}

				mCarTotalInterface.RunRequest();
			} else if (requestCode == REQUEST_COUPON) {
				boolean nCancelUseCoupon = data.getBooleanExtra(Run.EXTRA_DATA, false);
				JSONObject obj = new JSONObject(data.getStringExtra(Run.EXTRA_COUPON_DATA));
				mCheckOutJsonObject.put("md5_cart_info", obj.optString("md5_cart_info"));

				payJifen = obj.optJSONObject("point_dis");
				updateScoreDiscount();

				if (nCancelUseCoupon) {
					((TextView) mBView.findViewById(R.id.confirm_order_status)).setText("使用");
					oldCoupunNum = "";
					if (mCouponLists != null && mCouponLists.length() > 0) {
						mCouponLists = null;
					}
				} else {
					mCouponLists = obj.optJSONArray("coupons");
					JSONObject couponInfo = mCouponLists.getJSONObject(0);

					((TextView) mBView.findViewById(R.id.confirm_order_status)).setText(couponInfo.optString("name"));
					oldCoupunNum = couponInfo.optString("coupon");
				}
				mCarTotalInterface.RunRequest();

			} else if (requestCode == REQUEST_IDCARD) {
				isSelectedIDCard = true;
				idcardId = data.getStringExtra("idcardId");
//				((TextView) mAddressView.findViewById(R.id.confirm_order_idcard_tip)).setText("已上传");
			} else if (requestCode == REQUEST_MGETSTORE) {
				String storeStr = data.getStringExtra(Run.EXTRA_DATA);
				// try {
				// mStoreJSON = new JSONObject(storeStr);
				// if (mStoreJSON != null && !mStoreJSON.isNull("name")) {
				// // ((TextView)
				// //
				// findViewById(R.id.express_store_text)).setText(mStoreJSON.optString("name"));
				// expressInfo.put("branch_id",
				// mStoreJSON.optString("branch_id"));// 门店
				// }
				// updateExpressInfo();
				// Run.excuteJsonTask(new JsonTask(), new GetTotalPriceTask());
				// // expressInfo.put("time", StoreTime); // 时间
				// } catch (JSONException e) {
				// e.printStackTrace();
				// }
			} else if (requestCode == REQUEST_MGETSTORETIME) {
				String storeTime = data.getStringExtra(Run.EXTRA_DATA);
				((TextView) findViewById(R.id.confirm_order_confirm_order_takeself)).setText(storeTime);
				mDefShippingJsonObject.put("time", StringUtils.formatShortStringTimeToSecTime(storeTime)); // 时间
			} else if (requestCode == REQUEST_SELECTMEMBER){

				PartnerInfo info = data.getParcelableExtra(PartnerDetailFragment.PARTNER_INFO_KEY);

				if (info != null){

					if (info.userId != mSelectMemberID){
						memberAddress = null;
						mDefShippingJsonObject = null;
						updateExpressInfo();
						updateAddressInfo(memberAddress);
						mCarTotalInterface.RunRequest();
					}

					mSelectMemberID = info.userId;

					mSelectMemberName = info.name;

					mSelectMemberView.setText(mSelectMemberName);
				}
			}
		} catch (Exception e) {
		}
	}

	void addCheckoutItem(String checkoutName, String checkoutAmount) {
		if (isNullCheckoutAmount(checkoutAmount)) {
			return;
		}

		View nView = View.inflate(mActivity, R.layout.item_order_checkout, null);
		((TextView) nView.findViewById(R.id.order_checkout_name)).setText(checkoutName);
		((TextView) nView.findViewById(R.id.order_checkout_value)).setText(checkoutAmount);

		mCheckoutItemsView.addView(nView);
	}

	/**
	 * 判断结算下金额是否为空或0
	 *
	 * @param checkoutAmount
	 * @return
	 */
	boolean isNullCheckoutAmount(String checkoutAmount) {
		if (TextUtils.isEmpty(checkoutAmount) || checkoutAmount.equals("0")) {
			return true;
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
				return true;
			}
		} catch (NumberFormatException e) {
			return true;
		}

		return false;
	}

	/**
	 * 更新价格信息
	 *
	 * @param all
	 */
	private void fillupPriceLayout(JSONObject all) {
		mCheckoutItemsView.removeAllViews();

		addCheckoutItem("商品金额", mOrderDetail.optString("price_total"));
		addCheckoutItem("商品优惠", mOrderDetail.optString("discount_amount_prefilter"));
		addCheckoutItem("订单优惠", mOrderDetail.optString("pmt_order"));
		addCheckoutItem("积分抵扣金额", mOrderDetail.optString("point_dis_price"));
		addCheckoutItem("运费", mOrderDetail.optString("cost_freight"));
		addCheckoutItem("物流保价费", mOrderDetail.optString("cost_protect"));
		addCheckoutItem("手续费", mOrderDetail.optString("cost_payment"));
		addCheckoutItem("发票税金", mOrderDetail.optString("cost_tax"));
		addCheckoutItem("订单总金额", mOrderDetail.optString("total_amount"));
		addCheckoutItem("订单消费积分", mOrderDetail.optString("totalConsumeScore"));
		addCheckoutItem("订单获得积分", mOrderDetail.optString("totalGainScore"));

		String nPrepareTotalAmount = mOrderDetail.optString("prepare_total_amount");
		addCheckoutItem("预售商品定金", nPrepareTotalAmount);

		((TextView) findViewById(R.id.confirm_order_total_price))
				.setText(isNullCheckoutAmount(nPrepareTotalAmount) ? Run.buildString("", mOrderDetail.optString("total_amount")) : nPrepareTotalAmount);
	}

	JSONObject buildCreateOrderParams() {
		JSONObject nJsonObject = new JSONObject();

		try {
			JSONObject address = new JSONObject();
			defAddress = isSelectMember ? memberAddress : personAddress;
			if (defAddress != null) {
				address.put("addr_id", defAddress.optString("addr_id"));
				address.put("area", Run.parseAddressId(defAddress));
				nJsonObject.put("address", address.toString());
			}

			if (!TextUtils.isEmpty(isFastBuy)) {
				nJsonObject.put("isfastbuy", isFastBuy);
			}

			if (mGoodsInentArray != null && mGoodsInentArray.length() > 0) {
				for (int i = 0; i < mGoodsInentArray.length(); i++) {
					nJsonObject.put(String.format("obj_ident[%d]", i), mGoodsInentArray.optString(i));
				}
			}

			// 配送方式
			if (mDefShippingJsonObject != null)
				nJsonObject.put("shipping", mDefShippingJsonObject.optString("value"));
			nJsonObject.put("payment[currency]", mCurrency);

			nJsonObject.put("point[score]", isUseScore ? payJifen.optString("max_discount_value_point") : "0");

			nJsonObject.put("md5_cart_info", mCheckOutJsonObject.optString("md5_cart_info"));

			if (mInvoiceInfo != null) {// 发票
				nJsonObject.put("payment[is_tax]", "true");
				nJsonObject.put("payment[tax_type]", mInvoiceInfo.optString("type"));
				nJsonObject.put("payment[tax_company]", mInvoiceInfo.optString("dt_name"));
				nJsonObject.put("payment[tax_content]", mInvoiceInfo.optString("content"));
			}

			if (!TextUtils.isEmpty(mRemarkEditText.getText().toString())) {
				nJsonObject.put("memo", mRemarkEditText.getText().toString());
			}

			// 配送时间
			if (!TextUtils.isEmpty(mShippingDay)) {
				nJsonObject.put("shipping_time[day]", mShippingDay);
				nJsonObject.put(mShippingDay.equals("special") ? "shipping_time[special]" : "shipping_time[time]", mShippingTime);
			}

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return nJsonObject;
	}

	// 检查是否可以支付
	private boolean checkCanPayment() {
		defAddress = isSelectMember ? memberAddress : personAddress;
		if (defAddress == null)
			Run.alertL(mActivity, R.string.confirm_order_address_empty);
		else if (mDefShippingJsonObject == null)
			Run.alertL(mActivity, R.string.confirm_order_express_empty);
		else if (mDefPayment == null) {
			Run.alertL(mActivity, R.string.confirm_order_payment_empty);
		} else
			return true;
		return false;
	}

	/**
	 * 银联支付结果处理
	 *
	 * @param data
	 * @return
	 */
	boolean dealUPResult(Intent data) {
		if (data == null) {
			return false;
		}

		String str = data.getExtras().getString("pay_result");
		if (str == null) {
			return false;
		}
		if (str.equalsIgnoreCase("success")) {
			// 支付成功后，extra中如果存在result_data，取出校验
			// result_data结构见c）result_data参数说明
			if (data.hasExtra("result_data")) {
				String sign = data.getExtras().getString("result_data");
				// 验签证书同后台验签证书
				// 此处的verify，商户需送去商户后台做验签
				if (true) {// verify(sign)
					// 验证通过后，显示支付结果
					Toast.makeText(mActivity, "支付成功", Toast.LENGTH_SHORT).show();
					mPaymentStatus = true;
				} else {
					// 验证不通过后的处理
					// 建议通过商户后台查询支付结果
				}
			} else {
				// 未收到签名信息
				// 建议通过商户后台查询支付结果
			}
			return true;
		} else if (str.equalsIgnoreCase("fail")) {
			Toast.makeText(mActivity, "支付失败", Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 支付失败！ ", "",
			// "确定", null, null, false, null);
			return true;
		} else if (str.equalsIgnoreCase("cancel")) {
			Toast.makeText(mActivity, "你已取消了本次订单的支付！", Toast.LENGTH_SHORT).show();
			mPaymentStatus = false;
			// CommonLoginFragment.showAlertDialog(mActivity, " 你已取消了本次订单的支付！ ",
			// "", "确定", null, null, false, null);
			return true;
		}

		return false;
	}

}
