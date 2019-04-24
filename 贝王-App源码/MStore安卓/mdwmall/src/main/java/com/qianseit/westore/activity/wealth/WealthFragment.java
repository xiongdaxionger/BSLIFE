package com.qianseit.westore.activity.wealth;

import org.json.JSONObject;

import android.app.Application;
import android.app.Dialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.wealth.WealthIndexInterface;
import com.qianseit.westore.util.StringUtils;
import com.beiwangfx.R;

/**
 * 财富
 * 
 * @author Administrator
 * 
 */
public class WealthFragment extends BaseDoFragment {

	private LoginedUser mLoginedUser;
	private TextView mAdvanceTextView, mAdvanceTipTextView;
	private TextView mAdvanceWithdrawedTextView;
	private TextView mAdvanceWithdrawingTextView;
	private TextView mCommissionTextView;
	private TextView mCommissionTotalTextView;
	private TextView mCommissionFreezeTextView;
	
	JSONObject mIndexJsonObject;
	
	Dialog mDialog;
	
	SparseArray<String> mWealthInfoArray = new SparseArray<String>();

	WealthIndexInterface mIndexInterface = new WealthIndexInterface(this) {
		
		/* (non-Javadoc)
		 * @see com.qianseit.westore.httpinterface.InterfaceHandler#SuccCallBack(org.json.JSONObject)
		 */
		public void SuccCallBack(org.json.JSONObject responseJson) {
			mIndexJsonObject = responseJson;
			assignmentWealthInfo();
		}
		
		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			
			super.task_response(json_str);
		}
	};
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.wealth_title);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_wealth, null);
		rootView.setVisibility(View.INVISIBLE);
		mAdvanceTextView = (TextView) findViewById(R.id.tv_advance);
		mAdvanceTipTextView = (TextView) findViewById(R.id.advance_tip);
		mAdvanceWithdrawedTextView = (TextView) findViewById(R.id.withdrawed);
		mAdvanceWithdrawingTextView = (TextView) findViewById(R.id.withdrawing);
		mCommissionTextView = (TextView) findViewById(R.id.commission);
		mCommissionTotalTextView = (TextView) findViewById(R.id.commission_total);
		mCommissionFreezeTextView = (TextView) findViewById(R.id.commission_freeze);
		findViewById(R.id.wealth_withdraw).setOnClickListener(this);
		findViewById(R.id.wealth_bill).setOnClickListener(this);
		findViewById(R.id.wealth_recharge).setOnClickListener(this);
		
		mWealthInfoArray.put(R.id.withdrawed_tip, "累计提现的金额");
		mWealthInfoArray.put(R.id.withdrawing_tip, "提现中的金额");
		mWealthInfoArray.put(R.id.commission_total_tip, "已获得的佣金累计总额");
		mWealthInfoArray.put(R.id.commission_freeze_tip, "冻结中的佣金总额");
		findViewById(R.id.withdrawed_tip).setOnClickListener(this);
		findViewById(R.id.withdrawing_tip).setOnClickListener(this);
		findViewById(R.id.commission_total_tip).setOnClickListener(this);
		findViewById(R.id.commission_freeze_tip).setOnClickListener(this);
		mAdvanceWithdrawedTextView.setText(getString(R.string.wealth_advance_withdraw, "0"));

		mActionBar.getTitleTV().setTextColor(getResources().getColor(R.color.white));
		mActionBar.getTitleBar().setBackgroundResource(R.color.westore_red);
		mActionBar.getBackButton().setImageResource(R.drawable.comm_button_back_white);
	}

	private void assignmentWealthInfo() {
		// 余额
		JSONObject nAdvanceJsonObject = null;
		JSONObject nCommisionJsonObject = null;
		if (mIndexJsonObject != null) {
			nAdvanceJsonObject = mIndexJsonObject.optJSONObject("advance");
			nCommisionJsonObject = mIndexJsonObject.optJSONObject("commision");
		}else{
			nAdvanceJsonObject = new JSONObject();
			mIndexJsonObject = new JSONObject();
			nCommisionJsonObject = new JSONObject();
		}
		mAdvanceTextView.setText(nAdvanceJsonObject.optString("total"));
		mAdvanceWithdrawedTextView.setText(mIndexJsonObject.optString("tixian"));
		mAdvanceWithdrawingTextView.setText(mIndexJsonObject.optString("txing"));
		if (mIndexJsonObject.optBoolean("commision_status", false)) {
			findViewById(R.id.commission_tr).setVisibility(View.VISIBLE);
			findViewById(R.id.commission_info_tr).setVisibility(View.VISIBLE);
		}else{
			findViewById(R.id.commission_tr).setVisibility(View.GONE);
			findViewById(R.id.commission_info_tr).setVisibility(View.GONE);
		}
		
		if (mIndexJsonObject.optBoolean("withdrawal_status", false)){
			findViewById(R.id.wealth_withdraw).setVisibility(View.VISIBLE);
		}else{
			findViewById(R.id.wealth_withdraw).setVisibility(View.GONE);
			findViewById(R.id.ll_item).setVisibility(View.GONE);

		}
		
		mAdvanceTipTextView.setText(String.format("贝壳（%s）", mIndexJsonObject.optString("cur")));

		mWealthInfoArray.put(R.id.withdrawed_tip, mIndexJsonObject.optString("tixian_notice"));
		mWealthInfoArray.put(R.id.withdrawing_tip, mIndexJsonObject.optString("txing_notice"));
		
		mCommissionTextView.setText(nCommisionJsonObject.optString("total"));
		mCommissionTotalTextView.setText(nCommisionJsonObject.optString("sum"));
		mCommissionFreezeTextView.setText(nCommisionJsonObject.optString("freeze"));
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.wealth_withdraw:
			if (TextUtils.isEmpty(AgentApplication.getLoginedUser(mActivity).mobile)) {
				startActivity(AgentActivity.FRAGMENT_ACCO_BIND_MOBILE);
				Run.alert(mActivity, "先绑定手机号才能添加银行卡");
				return;
			}
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_WITHDRAW));
			break;
		case R.id.wealth_bill:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BILL));
			break;
		case R.id.wealth_recharge:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_RECHARGE));
			break;
			
		case R.id.withdrawed_tip:
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, mWealthInfoArray.get(v.getId()), "", "确定", null, null, false, null);
			break;
		case R.id.withdrawing_tip:
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, mWealthInfoArray.get(v.getId()), "", "确定", null, null, false, null);
			break;
		case R.id.commission_total_tip:
		case R.id.commission_freeze_tip:
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, mWealthInfoArray.get(v.getId()), "", "确定", null, null, false, null);
			break;

		default:
			break;
		}
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		mIndexInterface.RunRequest();
	}
}
