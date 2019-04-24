package com.qianseit.westore.activity.wealth;

import java.util.List;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;

public class WealthRechargeFragment extends BaseRadioBarFragment {
	final long WITHDRAW_ONLINE = 1;
	final long WITHDRAW_CARD = 2;
	
	LongSparseArray<BaseDoFragment> mLongSparseArray = new LongSparseArray<BaseDoFragment>();

	RadioBarBeanList mBarBeanList = new RadioBarBeanList();
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("充值有礼");
	}
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		mBarBeanList.add(WITHDRAW_ONLINE, "在线充值");
//		mBarBeanList.add(WITHDRAW_CARD, "卡券充值");
		
		mLongSparseArray.put(WITHDRAW_ONLINE, new WealthRechargeOnlineFragment());
//		mLongSparseArray.put(WITHDRAW_CARD, new WealthRechargeCardFragment());
		return mBarBeanList;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mLongSparseArray.get(radioBarId);
	}

}
