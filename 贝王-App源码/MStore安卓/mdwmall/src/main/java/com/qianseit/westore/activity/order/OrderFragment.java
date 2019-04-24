package com.qianseit.westore.activity.order;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;

import java.util.List;

public class OrderFragment extends BaseRadioBarFragment {
	/**暴露外部的传值key
	 */
	public final static String ORDER_COMMISION_TYPE = "ORDER_COMMISION_TYPE";

	final public static long ALL = 0;
	public static final long WAIT_PAY = 1;
	public static final long WAIT_SHIPPING = 2;
	public static final long WAIT_RECEIPT = 3;
	public static final long WAIT_COMMENT = 4;
	/**是否为佣金订单
	 */
	public boolean isCommisionOrder = false;
	LongSparseArray<BaseDoFragment> mFragmentArray = new LongSparseArray<BaseDoFragment>();

	int mDefualtOrderType = 0;
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		RadioBarBeanList nBarBeanList = new RadioBarBeanList();
		nBarBeanList.add(ALL, "全部");
		nBarBeanList.add(WAIT_PAY, "待付款");
		nBarBeanList.add(WAIT_SHIPPING, "待发货");
		nBarBeanList.add(WAIT_RECEIPT, "待收货");
		if (!isCommisionOrder){
			nBarBeanList.add(WAIT_COMMENT, "待评价");
		}

		mFragmentArray.append(ALL, OrderUtils.getOrderListFragment("all",isCommisionOrder));
		mFragmentArray.put(WAIT_PAY, OrderUtils.getOrderListFragment("nopayed",isCommisionOrder));
		mFragmentArray.put(WAIT_SHIPPING, OrderUtils.getOrderListFragment("noship",isCommisionOrder));
		mFragmentArray.put(WAIT_RECEIPT, OrderUtils.getOrderListFragment("noreceived",isCommisionOrder));
		if (!isCommisionOrder){
			mFragmentArray.put(WAIT_COMMENT, OrderUtils.getOrderListFragment("nodiscuss",isCommisionOrder));
		}
		return nBarBeanList;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
		mDefualtOrderType = (int) mActivity.getIntent().getLongExtra(Run.EXTRA_DETAIL_TYPE, ALL);
		isCommisionOrder = mActivity.getIntent().getBooleanExtra(ORDER_COMMISION_TYPE,false);

		Bundle nBunlde = getArguments();
		if(nBunlde != null){
			if(mDefualtOrderType == ALL){
				mDefualtOrderType = (int)nBunlde.getLong(Run.EXTRA_DETAIL_TYPE, ALL);
			}
			if(!isCommisionOrder){
				isCommisionOrder = nBunlde.getBoolean(ORDER_COMMISION_TYPE,false);
			}
		}
	}
	
	@Override
	protected int defaultSelectedIndex() {
		// TODO Auto-generated method stub
		return mDefualtOrderType;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		if (radioBarId == ALL) {
			mActionBar.setTitle("全部订单");
		}else if(radioBarId == WAIT_PAY){
			mActionBar.setTitle("待付款订单");
		}else if(radioBarId == WAIT_SHIPPING){
			mActionBar.setTitle("待发货订单");
		}else if(radioBarId == WAIT_RECEIPT){
			mActionBar.setTitle("待收货订单");	
		}else if(radioBarId == WAIT_COMMENT){
			mActionBar.setTitle("待评价订单");
		}
		return mFragmentArray.get(radioBarId);
	}

}
