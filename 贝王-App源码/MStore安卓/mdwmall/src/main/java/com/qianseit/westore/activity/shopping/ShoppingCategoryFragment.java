package com.qianseit.westore.activity.shopping;

import java.util.HashMap;
import java.util.Map;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.activity.goods.CategoryBrandFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.beiwangfx.R;

/**
 * 统计
 * 
 * @author Administrator
 * 
 */
public class ShoppingCategoryFragment extends BaseDoFragment implements OnClickListener, OnCheckedChangeListener {
	public final static String STATISTICS_DEFUALT_TYPE = "STATISTICS_DEFUALT_TYPE";
	
	private RadioGroup mStatisticsType;
	
	boolean mIsFirst = true;
	
	Map<Integer, BaseDoFragment> mFragmenntMap;
	Integer mDefualtStatisticsType = R.id.category_rb;
	BaseDoFragment mSelectFragment;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mDefualtStatisticsType = mActivity.getIntent().getIntExtra(STATISTICS_DEFUALT_TYPE, R.id.category_rb);
	}
	
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.fragment_shopping_category, null);
		mStatisticsType = (RadioGroup) findViewById(R.id.statistics_type);
		mStatisticsType.setOnCheckedChangeListener(this);
		Run.removeFromSuperView(mStatisticsType);
		mActionBar.setCustomTitleView(mStatisticsType);
		initFragmentMap();

		((RadioButton)mStatisticsType.findViewById(mDefualtStatisticsType)).setChecked(true);
		switchFragment(mFragmenntMap.get(mDefualtStatisticsType));
	}

	@SuppressLint("UseSparseArrays")
	void initFragmentMap(){
		mFragmenntMap = new HashMap<Integer, BaseDoFragment>();
		mFragmenntMap.put(R.id.category_rb, new ShoppingCategoryGoodsFragment());
		mFragmenntMap.put(R.id.brand_rb, new CategoryBrandFragment());
	}
	
	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switchFragment(mFragmenntMap.get(checkedId));
	}

	private void switchFragment(BaseDoFragment baseFragment) {
		if (baseFragment != null && mSelectFragment != null && baseFragment.equals(mSelectFragment)) {
			return;
		}
		
		mSelectFragment = baseFragment;
		FragmentTransaction fragmentTransaction = mActivity.getSupportFragmentManager().beginTransaction();
		fragmentTransaction.replace(R.id.statistics_content, baseFragment);
		fragmentTransaction.commit();
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		if (CommonMainActivity.mActivity.mDefualtSelectedCategoryType == R.id.brand_rb) {
			((RadioButton)mStatisticsType.findViewById(R.id.brand_rb)).setChecked(true);
			switchFragment(mFragmenntMap.get(R.id.brand_rb));
			CommonMainActivity.mActivity.mDefualtSelectedCategoryType = R.id.category_rb;
		}
	}
}
