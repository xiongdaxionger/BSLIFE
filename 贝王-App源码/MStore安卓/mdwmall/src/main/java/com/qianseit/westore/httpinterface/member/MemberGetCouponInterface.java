package com.qianseit.westore.httpinterface.member;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberGetCouponInterface extends BaseHttpInterfaceTask {

	String mCouponNumber;
	
	public MemberGetCouponInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("cpnsCode", mCouponNumber);
		return nContentValues;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.get_coupon";
	}
	
	public void getCoupon(String couponNumber){
		mCouponNumber = couponNumber;
		RunRequest();
	}
}
