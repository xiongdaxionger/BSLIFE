package com.qianseit.westore.activity.order;

import android.os.Bundle;

public class OrderListPrepareFragment extends OrderListFragment {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("预售订单");
		mActionBar.setShowTitleBar(true);
		mEmptyText = "暂无预售订单";
		mOrderType = "prepare";
	}
}
