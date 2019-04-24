package com.qianseit.westore.activity.statistics;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;

import java.util.HashMap;
import java.util.Map;

/**
 * 统计
 * 
 * @author Administrator
 * 
 */
public class StatisticsChartActivity extends BaseDoFragment implements OnClickListener, OnCheckedChangeListener {
	public final static String STATISTICS_DEFUALT_TYPE = "STATISTICS_DEFUALT_TYPE";
	
	private RadioGroup mStatisticsType;
	
	Map<Integer, BaseDoFragment> mFragmenntMap;
	Integer mDefualtStatisticsType = R.id.income_rb;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mDefualtStatisticsType = mActivity.getIntent().getIntExtra(STATISTICS_DEFUALT_TYPE, R.id.income_rb);
	}
	
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.fragment_statistics_chart, null);
		mStatisticsType = (RadioGroup) findViewById(R.id.statistics_type);
		mStatisticsType.setOnCheckedChangeListener(this);
		Run.removeFromSuperView(mStatisticsType);
//		mActionBar.setCustomTitleView(mStatisticsType);
		mActionBar.setTitle("统计");
		initFragmentMap();
		
//		((RadioButton)mStatisticsType.findViewById(mDefualtStatisticsType)).setChecked(true);
		switchFragment(mFragmenntMap.get(mDefualtStatisticsType));
	}

	@SuppressLint("UseSparseArrays")
	void initFragmentMap(){
		mFragmenntMap = new HashMap<Integer, BaseDoFragment>();
//		mFragmenntMap.put(R.id.visitor_rb, new StatisticsChartVisitorActivity());
//		mFragmenntMap.put(R.id.order_rb, new StatisticsChartOrderActivity());
		mFragmenntMap.put(R.id.income_rb, new StatisticsChartIncomeActivity());
	}
	
	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switchFragment(mFragmenntMap.get(checkedId));
	}

	private void switchFragment(BaseDoFragment baseFragment) {
		if (baseFragment == null) {
			return;
		}
		
		FragmentTransaction fragmentTransaction = mActivity.getSupportFragmentManager().beginTransaction();
		fragmentTransaction.replace(R.id.statistics_content, baseFragment);
		fragmentTransaction.commit();
	}
}
