package com.qianseit.westore.activity.aftermarket;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.order.OrderUtils;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;

import java.util.ArrayList;
import java.util.List;

public class AftermarketAllOrdersFragment extends BaseRadioBarFragment {

	public final static long ORDER_AFTERMARKET_APPLY_FOR = 1;
	public final static long ORDER_AFTERMARKET_APPLY_FOR_GOODS = 2;
	public final static long ORDER_AFTERMARKET_RETURN_GOODS = 3;
	public final static long ORDER_AFTERMARKET_REFUND = 4;

	long mDefualtOrderType = ORDER_AFTERMARKET_APPLY_FOR;
	
	LongSparseArray<BaseDoFragment> mLongSparseArray = new LongSparseArray<BaseDoFragment>();
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mDefualtOrderType = mActivity.getIntent().getLongExtra(Run.EXTRA_DETAIL_TYPE, ORDER_AFTERMARKET_APPLY_FOR);
	}

	@Override
	protected int defaultSelectedIndex() {
		// TODO Auto-generated method stub
		return (int) (mDefualtOrderType - 1);
	}
	
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("申请售后");
	}
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		nBarBeans.add(new RadioBarBean("申请退款", ORDER_AFTERMARKET_APPLY_FOR));
		nBarBeans.add(new RadioBarBean("退款记录", ORDER_AFTERMARKET_REFUND));
		nBarBeans.add(new RadioBarBean("申请退货", ORDER_AFTERMARKET_APPLY_FOR_GOODS));
		nBarBeans.add(new RadioBarBean("退货记录", ORDER_AFTERMARKET_RETURN_GOODS));
		
		mLongSparseArray.append(ORDER_AFTERMARKET_APPLY_FOR, OrderUtils.getAftermarketOrderListFragment("refund"));
		mLongSparseArray.append(ORDER_AFTERMARKET_APPLY_FOR_GOODS,  OrderUtils.getAftermarketOrderListFragment("reship"));
		mLongSparseArray.append(ORDER_AFTERMARKET_RETURN_GOODS, new AftermarketReturnGoodsListFragment());
		mLongSparseArray.append(ORDER_AFTERMARKET_REFUND, new AftermarketRefundListFragment());
		return nBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mLongSparseArray.get(radioBarId);
	}

}
