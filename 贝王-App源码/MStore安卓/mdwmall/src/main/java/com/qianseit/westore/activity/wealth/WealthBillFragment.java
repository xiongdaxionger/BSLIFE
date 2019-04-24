package com.qianseit.westore.activity.wealth;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckedTextView;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.ui.CustomListCheckPopupWindow;
import com.qianseit.westore.ui.CustomListCheckPopupWindow.CustomListCheckBean;
import com.qianseit.westore.ui.CustomListCheckPopupWindow.onCustomListPopupCheckListener;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class WealthBillFragment extends BaseListFragment<JSONObject> implements onCustomListPopupCheckListener, OnDismissListener,OnCheckedChangeListener {
	private List<CustomListCheckBean> mExpenditureArray = new ArrayList<CustomListCheckBean>();
	private List<CustomListCheckBean> mIncomeArray = new ArrayList<CustomListCheckBean>();
	private View mHeadViewCondition;
	CheckedTextView mExpendConditionTextView;
	CheckedTextView mIncomeConditionTextView;
	CheckedTextView mFilterConditionTextView;

	CheckedTextView mCurCheckedTextView;
	List<CheckedTextView> mTopItems = new ArrayList<CheckedTextView>();

	private String Type = "in";
	private String billStatus = "in"; // in：收入 out：支出
	private CustomListCheckPopupWindow mIncomeWindow;
	private CustomListCheckPopupWindow mExpenditureWindow;
	/**是否为佣金账单
	 */
	public boolean isCommisionOrder = false;
	/**分段控件
	 */
	private RadioGroup mBillSegement;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

	}

	@SuppressLint("NewApi")
	private void openIncomePopupWindow(View view) {
		if (mIncomeWindow.isShowing()) {
			mIncomeWindow.dismiss();
			mIncomeConditionTextView.setSelected(false);
		} else {
			mIncomeWindow.setAnimationStyle(android.R.style.Animation_Dialog);
			mIncomeWindow.showAsDropDown(mHeadViewCondition.findViewById(R.id.condition_sale_linear), 0, 1);
			mIncomeConditionTextView.setSelected(true);
		}
		mIncomeWindow.notifyDataSetChanged();
	}

	@SuppressLint("NewApi")
	private void openExpenditurePopupWindow(View view) {
		if (mExpenditureWindow.isShowing()) {
			mExpenditureWindow.dismiss();
			mExpendConditionTextView.setSelected(false);
		} else {
			mExpenditureWindow.setAnimationStyle(android.R.style.Animation_Dialog);
			mExpenditureWindow.showAsDropDown(mHeadViewCondition.findViewById(R.id.condition_sort_linear), 0, 1);
			mExpendConditionTextView.setSelected(true);
		}
		mExpenditureWindow.notifyDataSetChanged();
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();

		try {
			JSONArray nArray = responseJson.optJSONArray("advlogs");
			for (int i = 0; i < nArray.length(); i++) {
				nJsonObjects.add(nArray.optJSONObject(i));
			}
		} catch (Exception e) {
			// TODO: handle exception
		}

		return nJsonObjects;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = mActivity.getLayoutInflater().inflate(R.layout.item_bill, null);
		}
		((TextView) convertView.findViewById(R.id.bill_type_name_text)).setText(responseJson.optString("message"));
		long time = responseJson.optLong("mtime") * 1000;

		displaySquareImage((ImageView) convertView.findViewById(R.id.bill_icon), responseJson.optString("img"));

		((TextView) convertView.findViewById(R.id.bill_time_text)).setText(StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", time));
		if (responseJson.has("status")) {
			convertView.findViewById(R.id.bill_status_text).setVisibility(View.VISIBLE);
			((TextView) convertView.findViewById(R.id.bill_status_text)).setText(responseJson.optString("status"));
		} else {
			convertView.findViewById(R.id.bill_status_text).setVisibility(View.GONE);
		}
		String orderID = responseJson.optString("order_id");
		String orderValue = "0".equals(orderID) ? "" : orderID;
		orderValue = orderValue.equalsIgnoreCase("null") ? "" : orderValue;
		if (TextUtils.isEmpty(orderValue) && !responseJson.isNull("memo")) {
			orderValue = responseJson.optString("memo");
		}
		TextView orderText = (TextView) convertView.findViewById(R.id.bill_order_num_text);
		if (TextUtils.isEmpty(orderValue)) {
			((RelativeLayout) orderText.getParent()).setVisibility(View.GONE);
		} else {
			((RelativeLayout) orderText.getParent()).setVisibility(View.VISIBLE);
			orderText.setText(orderValue);
		}

		String nString = responseJson.optString("explode_money");
		if (!TextUtils.isEmpty(nString) && nString.equalsIgnoreCase("null"))
			nString = "";
		if (!TextUtils.isEmpty(nString)) {
			((TextView) convertView.findViewById(R.id.bill_price_text)).setText("-" + nString);
		} else {
			((TextView) convertView.findViewById(R.id.bill_price_text)).setText("+" + responseJson.optString("import_money"));
		}

		return convertView;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", Type);
		nContentValues.put("is_fx",isCommisionOrder ? "true" : "false");
		return nContentValues;
	}

	void initConditions() {
		// 收入
		mIncomeArray.add(new CustomListCheckBean("in", "收入", true));
		// mIncomeArray.add(new CustomListCheckBean("fin", "已完成佣金收入", false));
		// mIncomeArray.add(new CustomListCheckBean("act", "未完成佣金收入", false));
		// mIncomeArray.add(new CustomListCheckBean("cz", "充值记录", false));
		// mIncomeArray.add(new CustomListCheckBean("collect", "收钱账单", false));
		mIncomeWindow = new CustomListCheckPopupWindow(mActivity, R.id.condition1_title, this, mIncomeArray);
		mIncomeWindow.setOnDismissListener(this);

		// 支出
		mExpenditureArray.add(new CustomListCheckBean("out", "支出", true));
		// mExpenditureArray.add(new CustomListCheckBean("tx", "提现明细", false));
		// mExpenditureArray.add(new CustomListCheckBean("despoit", "预存款支付",
		// false));
		mExpenditureWindow = new CustomListCheckPopupWindow(mActivity, R.id.condition2_title, this, mExpenditureArray);
		mExpenditureWindow.setOnDismissListener(this);
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// // TODO Auto-generated method stub
		initConditions();

		LayoutInflater nInflater = mActivity.getLayoutInflater();

		View view = nInflater.inflate(R.layout.fragment_bill_segement,null);
		mBillSegement = (RadioGroup) view.findViewById(R.id.bill_segement);
		mBillSegement.setOnCheckedChangeListener(this);
		Run.removeFromSuperView(mBillSegement);
		((RadioButton) mBillSegement.findViewById(R.id.segement_left)).setText("余额账单");
		((RadioButton) mBillSegement.findViewById(R.id.segement_left)).setChecked(true);
		((RadioButton) mBillSegement.findViewById(R.id.segement_right)).setText("佣金账单");
		mActionBar.setCustomTitleView(mBillSegement);

		mHeadViewCondition = nInflater.inflate(R.layout.fragment_mana_condition, null);
		// mHeadViewCondition.setLayoutParams(new
		// AbsListView.LayoutParams(mHeadViewCondition.getLayoutParams()));
		mIncomeConditionTextView = (CheckedTextView) mHeadViewCondition.findViewById(R.id.condition1_title);
		mExpendConditionTextView = (CheckedTextView) mHeadViewCondition.findViewById(R.id.condition2_title);
		mFilterConditionTextView = (CheckedTextView) mHeadViewCondition.findViewById(R.id.condition3_title);
		mHeadViewCondition.findViewById(R.id.condition_filter_linear).setVisibility(View.GONE);
		mTopItems.add(mIncomeConditionTextView);
		mTopItems.add(mExpendConditionTextView);
		mTopItems.add(mFilterConditionTextView);

		mHeadViewCondition.findViewById(R.id.condition_sale_linear).setOnClickListener(this);
		mHeadViewCondition.findViewById(R.id.condition_sort_linear).setOnClickListener(this);
		mHeadViewCondition.findViewById(R.id.condition_filter_linear).setOnClickListener(this);
		mExpendConditionTextView.setText(mExpenditureArray.get(0).mName);
		mIncomeConditionTextView.setText(mIncomeArray.get(0).mName);
		topLayout.addView(mHeadViewCondition, LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		mCurCheckedTextView = mIncomeConditionTextView;
		setEmptyImage(R.drawable.transparent);

		showDivideTop1(true);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.balance";
	}

	@SuppressLint("NewApi")
	private void openPopupWindow(View view) {
		if (view.getId() == R.id.condition1_title || view.getId() == R.id.condition_sale_linear) {
			openIncomePopupWindow(view);
			return;
		} else if (view.getId() == R.id.condition2_title || view.getId() == R.id.condition_sort_linear) {
			openExpenditurePopupWindow(view);
		}
	}

	void chooseItem(int chooseIndex) {
		if (chooseIndex >= mTopItems.size()) {
			return;
		}

		for (int i = 0; i < mTopItems.size(); i++) {
			if (i != chooseIndex) {
				mTopItems.get(i).setChecked(false);
				onCheckedChanged(mTopItems.get(i));
			} else{
				if (mTopItems.get(i).isChecked()) {
					mCurCheckedTextView = mTopItems.get(i);
					// openPopupWindow(mTopItems.get(i));
				} else {
					mTopItems.get(i).setChecked(true);
					onCheckedChanged(mTopItems.get(i));
				}
				// mCurCheckedTextView = mTopItems.get(i);
				// openPopupWindow(mTopItems.get(i));
				// mTopItems.get(i).setChecked(true);
			}
		}
	}

	void onCheckedChanged(CheckedTextView view) {
		CustomListCheckBean nCheckBean = mExpenditureArray.get(0);
		CustomListCheckPopupWindow nCheckPopupWindow = mExpenditureWindow;
		switch (view.getId()) {
		case R.id.condition1_title:
			nCheckBean = mIncomeArray.get(0);
			nCheckPopupWindow = mIncomeWindow;
			break;
		case R.id.condition2_title:
			nCheckBean = mExpenditureArray.get(0);
			nCheckPopupWindow = mExpenditureWindow;
			break;
		default:
			return;
		}

		if (view.isChecked()) {
			billStatus = nCheckBean.mID;
			nCheckPopupWindow.onSelected();
		} else {
			nCheckPopupWindow.onUnChecked();
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.condition_filter_linear:
			chooseItem(2);
			break;
		case R.id.condition_sort_linear:
			chooseItem(1);
			break;
		case R.id.condition_sale_linear:
			chooseItem(0);
			break;
		default:
			break;
		}
		super.onClick(v);
	}

	@Override
	public void onDismiss() {
		// TODO Auto-generated method stub
		mCurCheckedTextView.setSelected(false);
	}

	public void onResult(CustomListCheckBean checkBean, int dockViewID) {
		// TODO Auto-generated method stub
		switch (dockViewID) {
		case R.id.condition1_title:
			Type = checkBean.mID;
			mIncomeConditionTextView.setText(checkBean.mName);
			setEmptyText("暂无" + checkBean.mName + "账单");
			mIncomeConditionTextView.setSelected(false);
			break;
		case R.id.condition2_title:
			Type = checkBean.mID;
			mExpendConditionTextView.setText(checkBean.mName);
			setEmptyText("暂无" + checkBean.mName + "账单");
			mExpendConditionTextView.setSelected(false);
			break;

		default:
			break;
		}
		onRefresh();
	}

	@Override
	public void onUnCheckedResult(CustomListCheckBean checkBean, int dockViewID) {
		// TODO Auto-generated method stub
		switch (dockViewID) {
		case R.id.condition1_title:
			mIncomeConditionTextView.setText(checkBean.mName);
			break;
		case R.id.condition2_title:
			mExpendConditionTextView.setText(checkBean.mName);
			break;

		default:
			break;
		}
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		isCommisionOrder = checkedId == R.id.segement_left ? false : true;
		onRefresh();
	}
}
