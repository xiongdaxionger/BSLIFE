package com.qianseit.westore.activity.acco;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.member.MemberScoreListInterface;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AccoPointsFragment extends BaseRadioBarFragment {
	public final static long POINTS_RULE = 1;
	public final static long POINTS_RECORDS = 2;

	private TextView mPointsTextView, mFrozenTextView, mFrozenTipTextView, mFrozenIncomeTextView, mFrozenIncomeTipTextView, mActionTextView;
	long mDefualtType = POINTS_RULE;

	LongSparseArray<BaseDoFragment> mFragmentArray = new LongSparseArray<BaseDoFragment>();

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mDefualtType = mActivity.getIntent().getLongExtra(Run.EXTRA_DETAIL_TYPE, POINTS_RULE);
	}

	@Override
	protected int defaultSelectedIndex() {
		// TODO Auto-generated method stub
		return (int) (mDefualtType - 1);
	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub

		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		nBarBeans.add(new RadioBarBean("积分规则", POINTS_RULE));
		nBarBeans.add(new RadioBarBean("积分记录", POINTS_RECORDS));

		mFragmentArray.put(POINTS_RULE, new AccoPointsRuleFragment());
		mFragmentArray.put(POINTS_RECORDS, new AccoPointsRecordsFragment());

		return nBarBeans;
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		rootView.setVisibility(View.INVISIBLE);
		View nHeaderView = View.inflate(mActivity, R.layout.header_acco_points, null);
		mPointsTextView = (TextView) nHeaderView.findViewById(R.id.tv_points);
		mFrozenTextView = (TextView) nHeaderView.findViewById(R.id.frozen_points_tv);
		mFrozenTipTextView = (TextView) nHeaderView.findViewById(R.id.frozen_points_tv_tip);
		mFrozenIncomeTextView = (TextView) nHeaderView.findViewById(R.id.frozen_income_points_tv);
		mFrozenIncomeTipTextView = (TextView) nHeaderView.findViewById(R.id.frozen_income_points_tv_tip);
		mActionTextView = (TextView) nHeaderView.findViewById(R.id.action);
		topLayout.addView(nHeaderView);
		mActionBar.setTitle("我的积分");
		mActionBar.getTitleTV().setTextColor(getResources().getColor(R.color.white));
		mActionBar.getTitleBar().setBackgroundResource(R.color.westore_red);
		mActionBar.getBackButton().setImageResource(R.drawable.comm_button_back_white);
		
		mActionTextView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startActivity(AgentActivity.FRAGMENT_MARKETING_SIGNIN);
			}
		});
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		new MemberScoreListInterface(this) {
			
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mPointsTextView.setText(responseJson.optString("total" , "0"));
				JSONObject expendPoint = responseJson.optJSONObject("extend_point_html");
				if (expendPoint != null) {
					if (expendPoint.has("expense_point")) {//消费冻结
						JSONObject nJsonObject = expendPoint.optJSONObject("expense_point");
						mFrozenTipTextView.setText(nJsonObject.optString("name") + "：");
						mFrozenTextView.setText("" + nJsonObject.optString("value") + "积分");
						mPointsTextView.setText(String.valueOf(responseJson.optInt("total" , 0) - nJsonObject.optInt("value", 0)));
					}
					if (expendPoint.has("obtained_point")) {//获取冻结
						JSONObject nJsonObject = expendPoint.optJSONObject("obtained_point");
						mFrozenIncomeTipTextView.setText(nJsonObject.optString("name") + "：");
						mFrozenIncomeTextView.setText("" + nJsonObject.optString("value") + "积分");
					}
				}
				
				String nAction = responseJson.optString("exchange_gift_link");
				if (!TextUtils.isEmpty(nAction)) {
					mActionTextView.setText(nAction);
					mActionTextView.setVisibility(View.VISIBLE);
				}else{
					mActionTextView.setVisibility(View.GONE);
				}
			}

			@Override
			public void task_response(String json_str) {
				if (!rootView.isShown()) {
					rootView.setVisibility(View.VISIBLE);
				}
				
				super.task_response(json_str);
			}
		}.RunRequest();
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mFragmentArray.get(radioBarId);
	}

}
